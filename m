Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755868AbaFRUzF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Jun 2014 16:55:05 -0400
Received: from mail-we0-f173.google.com ([74.125.82.173]:48774 "EHLO
	mail-we0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754954AbaFRUzA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Jun 2014 16:55:00 -0400
From: Grant Likely <grant.likely@linaro.org>
To: linux-kernel@vger.kernel.org, devicetree@vger.kernel.org, robh@kernel.org,
        olof@lixom.net, benh@kernel.crashing.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [PATCH 2/4] of: Enable console on serial ports specified by /chosen/stdout-path
Date: Wed, 18 Jun 2014 21:54:32 +0100
Message-Id: <1403124874-19929-3-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1403124874-19929-1-git-send-email-grant.likely@linaro.org>
References: <1403124874-19929-1-git-send-email-grant.likely@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the devicetree specifies a serial port as a stdout device, then the
kernel can use it as the default console if nothing else was selected on
the command line. For any serial port that uses the uart_add_one_port()
feature, the uart_add_one_port() has all the information needed to
automatically enable the console device, which is what this patch does.

With this change applied, a device tree platform can be booted without
any console= parameters on the command line and the kernel will still be
able to determine its console.

Tested on QEMU Versatile model and i.MX

Signed-off-by: Grant Likely <grant.likely@linaro.org>
Tested-by: Sascha Hauer <s.hauer@pengutronix.de>
---
 drivers/tty/serial/serial_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index fbf6c5ad222f..3ce68f962c92 100644
--- a/drivers/tty/serial/serial_core.c
+++ b/drivers/tty/serial/serial_core.c
@@ -26,6 +26,7 @@
 #include <linux/slab.h>
 #include <linux/init.h>
 #include <linux/console.h>
+#include <linux/of.h>
 #include <linux/proc_fs.h>
 #include <linux/seq_file.h>
 #include <linux/device.h>
@@ -2615,6 +2616,8 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 		spin_lock_init(&uport->lock);
 		lockdep_set_class(&uport->lock, &port_lock_key);
 	}
+	if (uport->cons && uport->dev)
+		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
 
 	uart_configure_port(drv, state, uport);
 
-- 
1.9.1

