Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758137Ab3CYNvX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 09:51:23 -0400
Received: from mga14.intel.com ([143.182.124.37]:30576 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757950Ab3CYNvW (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 09:51:22 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,905,1355126400"; 
   d="scan'208";a="218614436"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Ley Foon Tan <lftan@altera.com>, linux-kernel@vger.kernel.org,
        linux-serial@vger.kernel.org
Subject: [PATCHv2 3/3] serial: of_serial: Handle auto-flow-control property
Date: Mon, 25 Mar 2013 15:51:15 +0200
Message-Id: <1364219475-18215-1-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <20130325131727.GB2847@xps8300>
References: <20130325131727.GB2847@xps8300>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Automatic Flow Control capability is not tied to this
property. This is only one way of detecting it. The property
is limited to be used only with 8250 driver.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 .../devicetree/bindings/tty/serial/of-serial.txt          |    3 +++
 drivers/tty/serial/of_serial.c                            |   13 ++++++++++---
 2 files changed, 13 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
index c13f0ce..1928a3e 100644
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -34,6 +34,9 @@ Optional properties:
 - no-loopback-test: set to indicate that the port does not implements loopback
   test mode
 - fifo-size: the fifo size of the UART.
+- auto-flow-control: one way to enable automatic flow control support. The
+  driver is allowed to detect support for the capability even without this
+  property.
 
 Example:
 
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 267711b..39c7ea4 100644
--- a/drivers/tty/serial/of_serial.c
+++ b/drivers/tty/serial/of_serial.c
@@ -14,7 +14,6 @@
 #include <linux/slab.h>
 #include <linux/delay.h>
 #include <linux/serial_core.h>
-#include <linux/serial_8250.h>
 #include <linux/serial_reg.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
@@ -22,6 +21,8 @@
 #include <linux/nwpserial.h>
 #include <linux/clk.h>
 
+#include "8250/8250.h"
+
 struct of_serial_info {
 	struct clk *clk;
 	int type;
@@ -171,11 +172,17 @@ static int of_platform_serial_probe(struct platform_device *ofdev)
 #ifdef CONFIG_SERIAL_8250
 	case PORT_8250 ... PORT_MAX_8250:
 	{
-		/* For now the of bindings don't support the extra
-		   8250 specific bits */
 		struct uart_8250_port port8250;
 		memset(&port8250, 0, sizeof(port8250));
 		port8250.port = port;
+
+		if (port.fifosize)
+			port8250.capabilities = UART_CAP_FIFO;
+
+		if (of_property_read_bool(ofdev->dev.of_node,
+					  "auto-flow-control"))
+			port8250.capabilities |= UART_CAP_AFE;
+
 		ret = serial8250_register_8250_port(&port8250);
 		break;
 	}
-- 
1.7.10.4

