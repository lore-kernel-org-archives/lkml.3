Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933377AbaFLKdQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 06:33:16 -0400
Received: from smtprelay.synopsys.com ([198.182.44.111]:44036 "EHLO
	smtprelay.synopsys.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933254AbaFLKdI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 06:33:08 -0400
From: Vineet Gupta <Vineet.Gupta1@synopsys.com>
To: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        "Mark Rutland" <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, Paul Bolle <pebolle@tiscali.nl>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        <linux-serial@vger.kernel.org>, <Francois.Bedard@synopsys.com>,
        Vineet Gupta <Vineet.Gupta1@synopsys.com>
Subject: [PATCH 5/9] serial/arc: remove earlyprintk support and switch to earlycon
Date: Thu, 12 Jun 2014 16:01:35 +0530
Message-ID: <1402569099-9900-6-git-send-email-vgupta@synopsys.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
References: <1402569099-9900-1-git-send-email-vgupta@synopsys.com>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [10.12.196.93]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Vineet Gupta <vgupta@synopsys.com>
---
 arch/arc/boot/dts/angel4.dts  |  2 +-
 drivers/tty/serial/arc_uart.c | 87 ++++++-------------------------------------
 2 files changed, 13 insertions(+), 76 deletions(-)

diff --git a/arch/arc/boot/dts/angel4.dts b/arch/arc/boot/dts/angel4.dts
index 5bb2fdaca02f..6b57475967a6 100644
--- a/arch/arc/boot/dts/angel4.dts
+++ b/arch/arc/boot/dts/angel4.dts
@@ -17,7 +17,7 @@
 	interrupt-parent = <&intc>;
 
 	chosen {
-		bootargs = "console=ttyARC0,115200n8 earlyprintk=ttyARC0";
+		bootargs = "earlycon=arc_uart,mmio32,0xc0fc1000,115200n8 console=ttyARC0,115200n8";
 	};
 
 	aliases {
diff --git a/drivers/tty/serial/arc_uart.c b/drivers/tty/serial/arc_uart.c
index 0c8ba5bb97c7..2ffaf099691a 100644
--- a/drivers/tty/serial/arc_uart.c
+++ b/drivers/tty/serial/arc_uart.c
@@ -500,33 +500,23 @@ static int
 arc_uart_init_one(struct platform_device *pdev, int dev_id)
 {
 	struct resource *res, *res2;
-	unsigned long *plat_data;
 	struct arc_uart_port *uart = &arc_uart_ports[dev_id];
 	struct uart_port *port = &uart->port;
 
-	plat_data = dev_get_platdata(&pdev->dev);
-	if (!plat_data)
-		return -ENODEV;
+	struct device_node *np = pdev->dev.of_node;
+	u32 val;
 
-	if (is_early_platform_device(pdev)) {
-		port->uartclk = plat_data[1];
-		uart->baud = plat_data[2];
-	} else {
-		struct device_node *np = pdev->dev.of_node;
-		u32 val;
-
-		if (of_property_read_u32(np, "clock-frequency", &val)) {
-			dev_err(&pdev->dev, "clock-frequency property NOTset\n");
-			return -EINVAL;
-		}
-		port->uartclk = val;
-
-		if (of_property_read_u32(np, "current-speed", &val)) {
-			dev_err(&pdev->dev, "current-speed property NOT set\n");
-			return -EINVAL;
-		}
-		uart->baud = val;
+	if (of_property_read_u32(np, "clock-frequency", &val)) {
+		dev_err(&pdev->dev, "clock-frequency property NOTset\n");
+		return -EINVAL;
 	}
+	port->uartclk = val;
+
+	if (of_property_read_u32(np, "current-speed", &val)) {
+		dev_err(&pdev->dev, "current-speed property NOT set\n");
+		return -EINVAL;
+	}
+	uart->baud = val;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
 	if (!res)
@@ -615,38 +605,6 @@ static struct console arc_console = {
 	.data	= &arc_uart_driver
 };
 
-static __init void early_serial_write(struct console *con, const char *s,
-					unsigned int n)
-{
-	struct uart_port *port = &arc_uart_ports[con->index].port;
-
-	uart_console_write(port, s, n, arc_serial_poll_putchar);
-}
-
-static struct console arc_early_serial_console __initdata = {
-	.name = "early_ARCuart",
-	.write = early_serial_write,
-	.flags = CON_PRINTBUFFER | CON_BOOT,
-	.index = -1
-};
-
-static int __init arc_serial_probe_earlyprintk(struct platform_device *pdev)
-{
-	int dev_id = pdev->id < 0 ? 0 : pdev->id;
-	int rc;
-
-	arc_early_serial_console.index = dev_id;
-
-	rc = arc_uart_init_one(pdev, dev_id);
-	if (rc)
-		panic("early console init failed\n");
-
-	arc_serial_console_setup(&arc_early_serial_console, NULL);
-
-	register_console(&arc_early_serial_console);
-	return 0;
-}
-
 static __init void arc_early_serial_write(struct console *con, const char *s,
 					  unsigned int n)
 {
@@ -721,27 +679,6 @@ static struct platform_driver arc_platform_driver = {
 	 },
 };
 
-#ifdef CONFIG_SERIAL_ARC_CONSOLE
-
-static struct platform_driver early_arc_platform_driver __initdata = {
-	.probe = arc_serial_probe_earlyprintk,
-	.remove = arc_serial_remove,
-	.driver = {
-		.name = DRIVER_NAME,
-		.owner = THIS_MODULE,
-	 },
-};
-/*
- * Register an early platform driver of "earlyprintk" class.
- * ARCH platform code installs the driver and probes the early devices
- * The installation could rely on user specifying earlyprintk=xyx in cmd line
- * or it could be done independently, for all "earlyprintk" class drivers.
- * [see arch/arc/plat-arcfpga/platform.c]
- */
-early_platform_init("earlyprintk", &early_arc_platform_driver);
-
-#endif  /* CONFIG_SERIAL_ARC_CONSOLE */
-
 static int __init arc_serial_init(void)
 {
 	int ret;
-- 
1.8.3.2

