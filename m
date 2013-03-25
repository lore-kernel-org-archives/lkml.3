Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756569Ab3CYLe5 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Mar 2013 07:34:57 -0400
Received: from mga01.intel.com ([192.55.52.88]:32083 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756504Ab3CYLez (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Mar 2013 07:34:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,904,1355126400"; 
   d="scan'208";a="311514239"
From: Heikki Krogerus <heikki.krogerus@linux.intel.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>, Ley Foon Tan <lftan@altera.com>,
        linux-kernel@vger.kernel.org, linux-serial@vger.kernel.org
Subject: [PATCH 3/3] serial: of_serial: Handle hw-flow-control property
Date: Mon, 25 Mar 2013 13:34:46 +0200
Message-Id: <1364211286-31611-4-git-send-email-heikki.krogerus@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com>
References: <1364211286-31611-1-git-send-email-heikki.krogerus@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This will add support for hardware flow control. It is
limited to be used only with 8250 driver.

Signed-off-by: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 .../devicetree/bindings/tty/serial/of-serial.txt          |    1 +
 drivers/tty/serial/of_serial.c                            |   13 ++++++++++---
 2 files changed, 11 insertions(+), 3 deletions(-)

diff --git a/Documentation/devicetree/bindings/tty/serial/of-serial.txt b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
index c13f0ce..e775c93 100644
--- a/Documentation/devicetree/bindings/tty/serial/of-serial.txt
+++ b/Documentation/devicetree/bindings/tty/serial/of-serial.txt
@@ -34,6 +34,7 @@ Optional properties:
 - no-loopback-test: set to indicate that the port does not implements loopback
   test mode
 - fifo-size: the fifo size of the UART.
+- hw-flow-control: support for hardware flow control
 
 Example:
 
diff --git a/drivers/tty/serial/of_serial.c b/drivers/tty/serial/of_serial.c
index 267711b..2933112 100644
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
+					  "hw-flow-control"))
+			port8250.capabilities |= UART_CAP_AFE;
+
 		ret = serial8250_register_8250_port(&port8250);
 		break;
 	}
-- 
1.7.10.4

