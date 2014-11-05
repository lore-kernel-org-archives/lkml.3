Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751513AbaKESlb (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 13:41:31 -0500
Received: from mailout32.mail01.mtsvc.net ([216.70.64.70]:47377 "EHLO
	n23.mail01.mtsvc.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751247AbaKESlV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 13:41:21 -0500
From: Peter Hurley <peter@hurleysoftware.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Cc: linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org,
        Jiri Slaby <jslaby@suse.cz>, Peter Hurley <peter@hurleysoftware.com>
Subject: [PATCH 4/4] serial: 8250_pnp: Override pnp suspend for no_console_suspend
Date: Wed,  5 Nov 2014 13:40:54 -0500
Message-Id: <1415212854-16944-5-git-send-email-peter@hurleysoftware.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
References: <1415212854-16944-1-git-send-email-peter@hurleysoftware.com>
X-Authenticated-User: 990527 peter@hurleysoftware.com
X-MT-ID: 8FA290C2A27252AACF65DBC4A42F3CE3735FB2A4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Prevent PNP bus from powering down the serial console device
when suspending if the no_console_suspend command line option is set.

Signed-off-by: Peter Hurley <peter@hurleysoftware.com>
---
 drivers/tty/serial/8250/8250_pnp.c | 18 +++++++++++++++++-
 1 file changed, 17 insertions(+), 1 deletion(-)

diff --git a/drivers/tty/serial/8250/8250_pnp.c b/drivers/tty/serial/8250/8250_pnp.c
index 50b7c89..f603581 100644
--- a/drivers/tty/serial/8250/8250_pnp.c
+++ b/drivers/tty/serial/8250/8250_pnp.c
@@ -487,7 +487,7 @@ serial_pnp_probe(struct pnp_dev *dev, const struct pnp_device_id *dev_id)
 
 	if (uart_console(&port8250->port) && !console_suspend_enabled) {
 		info->override_disable = !!(dev->capabilities & PNP_DISABLE);
-		dev->capabilities &= ~PNP_DISABLE;
+		dev->capabilities &= ~(PNP_DISABLE | PNP_SUSPEND);
 	}
 
 	pnp_set_drvdata(dev, info);
@@ -502,6 +502,7 @@ static void serial_pnp_remove(struct pnp_dev *dev)
 		serial8250_unregister_port(info->line);
 		if (info->override_disable)
 			dev->capabilities |= PNP_DISABLE;
+		dev->capabilities |= PNP_SUSPEND;
 	}
 }
 
@@ -519,10 +520,25 @@ static int serial_pnp_suspend(struct pnp_dev *dev, pm_message_t state)
 static int serial_pnp_resume(struct pnp_dev *dev)
 {
 	struct serial_pnp_info *info = pnp_get_drvdata(dev);
+	unsigned int ier, mcr, lcr, dll, dlm;
+	struct uart_8250_port *port8250;
 
 	if (!info)
 		return -ENODEV;
+
+	port8250 = serial8250_get_port(info->line);
+	ier = serial_port_in(&port8250->port, UART_IER);
+	mcr = serial_port_in(&port8250->port, UART_MCR);
+	lcr = serial_port_in(&port8250->port, UART_LCR);
+	serial_port_out(&port8250->port, UART_LCR, lcr | UART_LCR_DLAB);
+	dll = serial_port_in(&port8250->port, UART_DLL);
+	dlm = serial_port_in(&port8250->port, UART_DLM);
+	serial_port_out(&port8250->port, UART_LCR, lcr & ~UART_LCR_DLAB);
+
 	serial8250_resume_port(info->line);
+
+	dev_info(&dev->dev, "IER:%02x MCR:%02x LCR:%02x DL:%02x%02x\n",
+		 ier, mcr, lcr, dlm, dll);
 	return 0;
 }
 #else
-- 
2.1.3

