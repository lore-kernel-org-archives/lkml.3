Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751574AbaKESlz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:41:55 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:49821 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751167AbaKESlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:41:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 2/4] serial: 8250_pnp: Override pnp disable for no_console_suspend
Date: Wed,  5 Nov 2014 13:40:52 -0500
Message-Id: <1415212854-16944-3-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
References: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When the kernel command line parameter, no_console_suspend, is used,
the console should continue to output console messages. For a serial
console, the serial core ensures that the device is not shutdown when
no_console_suspend is specified. However, the pnp bus subsequently
disables the device and no further output occurs.

When registering the 8250 port, override PNP_DISABLE if the serial
device is a console and consoles are not suspending. Restore the
PNP_DISABLE capability (if overriden) on device removal.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_pnp.c | 45 ++++++++++++++++++++++++++++----------
 1 file changed, 34 insertions(+), 11 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 682a2fb..50b7c89 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -18,11 +18,17 @@
 #include <linux/kernel.h>
 #include <linux/serial_core.h>
 #include <linux/bitops.h>
+#include <linux/console.h>
 
 #include <asm/byteorder.h>
 
 #include "8250.h"
 
+struct serial_pnp_info {
+	int line;
+	bool override_disable;
+};
+
 #define UNKNOWN_DEV 0x3000
 #define CIR_PORT	0x0800
 
@@ -426,7 +432,8 @@ static int serial_pnp_guess_board(struct pnp_dev *dev)
 static int
 serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 {
-	struct uart_8250_port uart;
+	struct uart_8250_port uart, *port8250;
+	struct serial_pnp_info *info;
 	int ret, line, flags = dev_id->driver_data;
 
 	if (flags & UNKNOWN_DEV) {
@@ -435,6 +442,10 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 			return ret;
 	}
 
+	info = devm_kzalloc(&dev->dev, sizeof(*info), GFP_KERNEL);
+	if (!info)
+		return -ENOMEM;
+
 	memset(&uart, 0, sizeof(uart));
 	if (pnp_irq_valid(dev, 0))
 		uart.port.irq = pnp_irq(dev, 0);
@@ -471,35 +482,47 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 	if (line < 0 || (flags & CIR_PORT))
 		return -ENODEV;
 
-	pnp_set_drvdata(dev, (void *)((long)line + 1));
+	info->line = line;
+	port8250 = serial8250_get_port(line);
+
+	if (uart_console(&port8250->port) && !console_suspend_enabled) {
+		info->override_disable = !!(dev->capabilities & PNP_DISABLE);
+		dev->capabilities &= ~PNP_DISABLE;
+	}
+
+	pnp_set_drvdata(dev, info);
 	return 0;
 }
 
 static void serial_pnp_remove(struct pnp_dev *dev)
 {
-	long line = (long)pnp_get_drvdata(dev);
-	if (line)
-		serial8250_unregister_port(line - 1);
+	struct serial_pnp_info *info = pnp_get_drvdata(dev);
+
+	if (info) {
+		serial8250_unregister_port(info->line);
+		if (info->override_disable)
+			dev->capabilities |= PNP_DISABLE;
+	}
 }
 
 #ifdef CONFIG_PM
 static int serial_pnp_suspend(struct pnp_dev *dev, pm_message_t state)
 {
-	long line = (long)pnp_get_drvdata(dev);
+	struct serial_pnp_info *info = pnp_get_drvdata(dev);
 
-	if (!line)
+	if (!info)
 		return -ENODEV;
-	serial8250_suspend_port(line - 1);
+	serial8250_suspend_port(info->line);
 	return 0;
 }
 
 static int serial_pnp_resume(struct pnp_dev *dev)
 {
-	long line = (long)pnp_get_drvdata(dev);
+	struct serial_pnp_info *info = pnp_get_drvdata(dev);
 
-	if (!line)
+	if (!info)
 		return -ENODEV;
-	serial8250_resume_port(line - 1);
+	serial8250_resume_port(info->line);
 	return 0;
 }
 #else
-- 
2.1.3

