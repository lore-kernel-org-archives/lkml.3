Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaIFRWa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 6 Sep 2014 13:22:30 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:47460 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751987AbaIFRWZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 6 Sep 2014 13:22:25 -0400
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
Subject: [PATCH 3/4] tty: vt8500_serial: explicitly calculate base baud rate
Date: Sat,  6 Sep 2014 21:21:14 +0400
Message-Id: <1410024075-1354-4-git-send-email-alchark@gmail.com>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1410024075-1354-1-git-send-email-alchark@gmail.com>
References: <1410024075-1354-1-git-send-email-alchark@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code relies on the UART clock pre-divisor to be already
configured in the baud rate register. Calculate it in the driver
and set explicitly instead, also return the "real" effective baud
rate, which is generally slightly different from the requested value.

While at this, also ensure that break signal timing is updated when
baud rate changes.

Signed-off-by: Alexey Charkov <alchark@gmail.com>
---
 drivers/tty/serial/vt8500_serial.c | 27 +++++++++++++++++++++------
 1 file changed, 21 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/vt8500_serial.c b/drivers/tty/serial/vt8500_serial.c
index 47e74f9..bfcebfd 100644
--- a/drivers/tty/serial/vt8500_serial.c
+++ b/drivers/tty/serial/vt8500_serial.c
@@ -101,12 +101,15 @@
 
 #define VT8500_HAS_SWRTSCTS_SWITCH	(1 << 1)
 
+#define VT8500_RECOMMENDED_CLK		12000000
+#define VT8500_OVERSAMPLING_DIVISOR	13
 #define VT8500_MAX_PORTS	6
 
 struct vt8500_port {
 	struct uart_port	uart;
 	char			name[16];
 	struct clk		*clk;
+	unsigned int		clk_predivisor;
 	unsigned int		ier;
 	unsigned int		vt8500_uart_flags;
 };
@@ -311,20 +314,25 @@ static void vt8500_break_ctl(struct uart_port *port, int break_ctl)
 
 static int vt8500_set_baud_rate(struct uart_port *port, unsigned int baud)
 {
+	struct vt8500_port *vt8500_port =
+			container_of(port, struct vt8500_port, uart);
 	unsigned long div;
 	unsigned int loops = 1000;
 
-	div = vt8500_read(port, VT8500_URDIV) & ~(0x3ff);
+	div = ((vt8500_port->clk_predivisor - 1) & 0xf) << 16;
+	div |= (uart_get_divisor(port, baud) - 1) & 0x3ff;
 
-	if (unlikely((baud < 900) || (baud > 921600)))
-		div |= 7;
-	else
-		div |= (921600 / baud) - 1;
+	/* Effective baud rate */
+	baud = port->uartclk / 16 / ((div & 0x3ff) + 1);
 
 	while ((vt8500_read(port, VT8500_URUSR) & (1 << 5)) && --loops)
 		cpu_relax();
+
 	vt8500_write(port, div, VT8500_URDIV);
 
+	/* Break signal timing depends on baud rate, update accordingly */
+	vt8500_write(port, mult_frac(baud, 4096, 1000000), VT8500_URBKR);
+
 	return baud;
 }
 
@@ -660,6 +668,10 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	}
 
 	vt8500_port->vt8500_uart_flags = *flags;
+	vt8500_port->clk_predivisor = DIV_ROUND_CLOSEST(
+					clk_get_rate(vt8500_port->clk),
+					VT8500_RECOMMENDED_CLK
+				      );
 	vt8500_port->uart.type = PORT_VT8500;
 	vt8500_port->uart.iotype = UPIO_MEM;
 	vt8500_port->uart.mapbase = mmres->start;
@@ -670,7 +682,10 @@ static int vt8500_serial_probe(struct platform_device *pdev)
 	vt8500_port->uart.dev = &pdev->dev;
 	vt8500_port->uart.flags = UPF_IOREMAP | UPF_BOOT_AUTOCONF;
 
-	vt8500_port->uart.uartclk = clk_get_rate(vt8500_port->clk);
+	/* Serial core uses the magic "16" everywhere - adjust for it */
+	vt8500_port->uart.uartclk = 16 * clk_get_rate(vt8500_port->clk) /
+					vt8500_port->clk_predivisor /
+					VT8500_OVERSAMPLING_DIVISOR;
 
 	snprintf(vt8500_port->name, sizeof(vt8500_port->name),
 		 "VT8500 UART%d", pdev->id);
-- 
2.0.0

