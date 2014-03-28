Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752628AbaC1QKB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 12:10:01 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:36661 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752167AbaC1QIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 12:08:16 -0400
From: Grant Likely <grant.likely@linaro.org>
To: devicetree@vger.kernel.org, christoffer.dall@linaro.org,
        linux-kernel@vger.kernel.org, olof@lixom.net, benh@kernel.crashing.org,
        rob.herring@linaro.org
Cc: Grant Likely <grant.likely@linaro.org>
Subject: [RFC 3/5] of: Enable console on serial ports specified by /chosen/stdout-path
Date: Fri, 28 Mar 2014 09:08:03 -0700
Message-Id: <1396022885-6102-4-git-send-email-grant.likely@linaro.org>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
References: <1396022885-6102-1-git-send-email-grant.likely@linaro.org>
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

Signed-off-by: Grant Likely <grant.likely@linaro.org>
---
 drivers/tty/serial/serial_core.c | 3 +++
 1 file changed, 3 insertions(+)

diff --git a/drivers/tty/serial/serial_core.c b/drivers/tty/serial/serial_core.c
index ece2049bd270..2fac7593d7b2 100644
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
@@ -2604,6 +2605,8 @@ int uart_add_one_port(struct uart_driver *drv, struct uart_port *uport)
 		spin_lock_init(&uport->lock);
 		lockdep_set_class(&uport->lock, &port_lock_key);
 	}
+	if (uport->cons && uport->dev)
+		of_console_check(uport->dev->of_node, uport->cons->name, uport->line);
 
 	uart_configure_port(drv, state, uport);
 
-- 
1.8.3.2

