Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752048AbaIFRWZ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:22:25 -0400
Received: from mail-lb0-f174.google.com ([209.85.217.174]:53001 "EHLO
	mail-lb0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751922AbaIFRWN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:22:13 -0400
From: Alexey Charkov <alchark@gmail.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Tony Prisk <linux@prisktech.co.nz>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, devicetree@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-serial@vger.kernel.org
Cc: Alexey Charkov <alchark@gmail.com>
Subject: [PATCH 1/4] tty: vt8500_serial: add support for UART in WM8880 chips
Date: Sat,  6 Sep 2014 21:21:12 +0400
Message-Id: <1410024075-1354-2-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1410024075-1354-1-git-send-email-alchark@gmail.com>
References: <1410024075-1354-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Newer WonderMedia chips introduced another flag in the UART line control
register, which controls whether RTS/CTS signalling should be handled in
the driver or by the hardware itself.

This patch ensures that the kernel can control RTS/CTS (including
disabling it altogether) by forcing this flag to software mode on affected
chips (only WM8880 so far).

Also remove the redundant copy of the binding doc, while we are here.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
 .../devicetree/bindings/serial/via,vt8500-uart.txt | 17 ------
 .../devicetree/bindings/serial/vt8500-uart.txt     |  3 +-
 drivers/tty/serial/vt8500_serial.c                 | 70 +++++++++++++++++-----
 3 files changed, 58 insertions(+), 32 deletions(-)
 delete mode 100644 Documentation/devicetree/bindings/serial/via,vt8500-uart.txt

diff --git a/Documentation/devicetree/bindings/serial/via,vt8500-uart.txt b/Documentation/devicetree/bindings/serial/via,vt8500-uart.txt
deleted file mode 100644
index 5feef1e..0000000
--- a/Documentation/devicetree/bindings/serial/via,vt8500-uart.txt
+++ /dev/null
@@ -1,17 +0,0 @@
-VIA/Wondermedia VT8500 UART Controller
------------------------------------------------------
-
-Required properties:
-- compatible : "via,vt8500-uart"
-- reg : Should contain 1 register ranges(address and length)
-- interrupts : UART interrupt
-- clocks : phandle to the uart source clock (usually a 24Mhz fixed clock)
-
-Example:
-
-	uart@d8210000 {
-		compatible = "via,vt8500-uart";
-		reg = <0xd8210000 0x1040>;
-		interrupts = <47>;
-		clocks = <&ref24>;
-	};
diff --git a/Documentation/devicetree/bindings/serial/vt8500-uart.txt b/Documentation/devicetree/bindings/serial/vt8500-uart.txt
index 795c393..2b64e61 100644
--- a/Documentation/devicetree/bindings/serial/vt8500-uart.txt
+++ b/Documentation/devicetree/bindings/serial/vt8500-uart.txt
@@ -1,7 +1,8 @@
 * VIA VT8500 and WonderMedia WM8xxx UART Controller
 
 Required properties:
-- compatible: should be "via,vt8500-uart"
+- compatible: should be "via,vt8500-uart" (for VIA/WonderMedia chips up to and
+	including WM8850/WM8950), or "wm,wm8880-uart" (for WM8880 and later)
 
 - reg: base physical address of the controller and length of memory mapped
 	region.
diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 15ad6fc..f225719 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -33,8 +33,8 @@
 #include <linux/serial.h>
 #include <linux/slab.h>
 #include <linux/clk.h>
-#include <linux/platform_device.h>
 #include <linux/of.h>
+#include <linux/of_device.h>
 #include <linux/err.h>
 
 /*
@@ -78,6 +78,29 @@
 #define RX_FIFO_INTS	(RXFAF | RXFF | RXOVER | PER | FER | RXTOUT)
 #define TX_FIFO_INTS	(TXFAE | TXFE | TXUDR)
 
+/*
+ * Line control bits
+ */
+
+#define VT8500_TXEN	(1 << 0)	/* Enable transmit logic */
+#define VT8500_RXEN	(1 << 1)	/* Enable receive logic */
+#define VT8500_CS8	(1 << 2)	/* 8-bit data length (vs. 7-bit) */
+#define VT8500_CSTOPB	(1 << 3)	/* 2 stop bits (vs. 1) */
+#define VT8500_PARENB	(1 << 4)	/* Enable parity */
+#define VT8500_PARODD	(1 << 5)	/* Odd parity (vs. even) */
+#define VT8500_RTS	(1 << 6)	/* Ready to send */
+#define VT8500_LOOPBK	(1 << 7)	/* Enable internal loopback */
+#define VT8500_DMA	(1 << 8)	/* Enable DMA mode (needs FIFO) */
+#define VT8500_BREAK	(1 << 9)	/* Initiate break signal */
+#define VT8500_PSLVERR	(1 << 10)	/* APB error upon empty RX FIFO read */
+#define VT8500_SWRTSCTS	(1 << 11)	/* Software-controlled RTS/CTS */
+
+/*
+ * Capability flags (driver-internal)
+ */
+
+#define VT8500_HAS_SWRTSCTS_SWITCH	(1 << 1)
+
 #define VT8500_MAX_PORTS	6
 
 struct vt8500_port {
@@ -85,6 +108,7 @@ struct vt8500_port {
 	char			name[16];
 	struct clk		*clk;
 	unsigned int		ier;
+	unsigned int		vt8500_uart_flags;
 };
 
 /*
@@ -272,7 +296,8 @@ static void vt8500_set_mctrl(struct uart_port *port, unsigned int mctrl)
 static void vt8500_break_ctl(struct uart_port *port, int break_ctl)
 {
 	if (break_ctl)
-		vt8500_write(port, vt8500_read(port, VT8500_URLCR) | (1 << 9),
+		vt8500_write(port,
+			     vt8500_read(port, VT8500_URLCR) | VT8500_BREAK,
 			     VT8500_URLCR);
 }
 
@@ -347,31 +372,35 @@ static void vt8500_set_termios(struct uart_port *port,
 
 	/* calculate parity */
 	lcr = vt8500_read(&vt8500_port->uart, VT8500_URLCR);
-	lcr &= ~((1 << 5) | (1 << 4));
+	lcr &= ~(VT8500_PARENB | VT8500_PARODD);
 	if (termios->c_cflag & PARENB) {
-		lcr |= (1 << 4);
+		lcr |= VT8500_PARENB;
 		termios->c_cflag &= ~CMSPAR;
 		if (termios->c_cflag & PARODD)
-			lcr |= (1 << 5);
+			lcr |= VT8500_PARODD;
 	}
 
 	/* calculate bits per char */
-	lcr &= ~(1 << 2);
+	lcr &= ~VT8500_CS8;
 	switch (termios->c_cflag & CSIZE) {
 	case CS7:
 		break;
 	case CS8:
 	default:
-		lcr |= (1 << 2);
+		lcr |= VT8500_CS8;
 		termios->c_cflag &= ~CSIZE;
 		termios->c_cflag |= CS8;
 		break;
 	}
 
 	/* calculate stop bits */
-	lcr &= ~(1 << 3);
+	lcr &= ~VT8500_CSTOPB;
 	if (termios->c_cflag & CSTOPB)
-		lcr |= (1 << 3);
+		lcr |= VT8500_CSTOPB;
+
+	lcr &= ~VT8500_SWRTSCTS;
+	if (vt8500_port->vt8500_uart_flags & VT8500_HAS_SWRTSCTS_SWITCH)
+		lcr |= VT8500_SWRTSCTS;
 
 	/* set parity, bits per char, and stop bit */
 	vt8500_write(&vt8500_port->uart, lcr, VT8500_URLCR);
@@ -548,14 +577,31 @@ static struct uart_driver vt8500_uart_driver = {
 	.cons		= VT8500_CONSOLE,
 };
 
+static unsigned int vt8500_flags; /* none required so far */
+static unsigned int wm8880_flags = VT8500_HAS_SWRTSCTS_SWITCH;
+
+static const struct of_device_id wmt_dt_ids[] = {
+	{ .compatible = "via,vt8500-uart", .data = &vt8500_flags},
+	{ .compatible = "wm,wm8880-uart", .data = &wm8880_flags},
+	{}
+};
+
 static int vt8500_serial_probe(struct platform_device *pdev)
 {
 	struct vt8500_port *vt8500_port;
 	struct resource *mmres, *irqres;
 	struct device_node *np = pdev->dev.of_node;
+	const struct of_device_id *match;
+	const unsigned int *flags;
 	int ret;
 	int port;
 
+	match = of_match_device(wmt_dt_ids, &pdev->dev);
+	if (!match)
+		return -EINVAL;
+
+	flags = match->data;
+
 	mmres = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	irqres = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	if (!mmres || !irqres)
@@ -605,6 +651,7 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 		return ret;
 	}
 
+	vt8500_port->vt8500_uart_flags = *flags;
 	vt8500_port->uart.type = PORT_VT8500;
 	vt8500_port->uart.iotype = UPIO_MEM;
 	vt8500_port->uart.mapbase = mmres->start;
@@ -639,11 +686,6 @@ static int vt8500_serial_remove(struct platform_device *pdev)
 	return 0;
 }
 
-static const struct of_device_id wmt_dt_ids[] = {
-	{ .compatible = "via,vt8500-uart", },
-	{}
-};
-
 static struct platform_driver vt8500_platform_driver = {
 	.probe  = vt8500_serial_probe,
 	.remove = vt8500_serial_remove,
-- 
2.0.0

