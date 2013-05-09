Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753911Ab3EIKaf (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 May 2013 06:30:35 -0400
Received: from multi.imgtec.com ([194.200.65.239]:27358 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753662Ab3EIKac (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 May 2013 06:30:32 -0400
From: James Hogan <james.hogan@imgtec.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
CC: <linux-serial@vger.kernel.org>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-doc@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        James Hogan <james.hogan@imgtec.com>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Jiri Slaby <jslaby@suse.cz>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>,
        Alan Cox <alan@linux.intel.com>, Jamie Iles <jamie@jamieiles.com>,
        Bill Pemberton <wfp5p@virginia.edu>
Subject: [PATCH] serial: 8250_dw: set clock rate
Date: Thu, 9 May 2013 11:29:16 +0100
Message-ID: <1368095356-21081-1-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01181__2013_05_09_11_30_28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If the uart clock provided to the 8250_dw driver is adjustable it may
not be set to the desired rate. Therefore if both a uart clock and a
clock frequency is specified (e.g. via device tree), try and update the
clock to match the frequency.

Unfortunately if the resulting frequency is rounded down (which is the
default behaviour of the generic clk-divider), the 8250 core won't allow
the highest baud rate to be used, so if an explicit frequency is
specified we always report that to the 8250 core.

The device tree bindings document is also updated accordingly.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>
Cc: Rob Landley <rob@landley.net>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Jiri Slaby <jslaby@suse.cz>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
Cc: Alan Cox <alan@linux.intel.com>
Cc: Jamie Iles <jamie@jamieiles.com>
Cc: Bill Pemberton <wfp5p@virginia.edu>
---
 .../bindings/tty/serial/snps-dw-apb-uart.txt       |  4 +-
 drivers/tty/serial/8250/8250_dw.c                  | 47 +++++++++++++++++-----
 2 files changed, 39 insertions(+), 12 deletions(-)

diff --git a/Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt b/Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt
index f13f1c5..e0cfc47 100644
--- a/Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt
+++ b/Documentation/devicetree/bindings/tty/serial/snps-dw-apb-uart.txt
@@ -4,9 +4,11 @@ Required properties:
 - compatible : "snps,dw-apb-uart"
 - reg : offset and length of the register set for the device.
 - interrupts : should contain uart interrupt.
-- clock-frequency : the input clock frequency for the UART.
 
 Optional properties:
+- clock-frequency : the input clock frequency for the UART. If specified in
+  addition to clocks, the clock rate will be set to this frequency.
+- clocks : the input clock specifier for the UART.
 - reg-shift : quantity to shift the register offsets by.  If this property is
   not present then the register offsets are not shifted.
 - reg-io-width : the size (in bytes) of the IO accesses that should be
diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index beaa283..85b3b63 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -128,6 +128,7 @@ dw8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
 static int dw8250_probe_of(struct uart_port *p)
 {
 	struct device_node	*np = p->dev->of_node;
+	struct dw8250_data	*d = p->private_data;
 	u32			val;
 
 	if (!of_property_read_u32(np, "reg-io-width", &val)) {
@@ -148,16 +149,13 @@ static int dw8250_probe_of(struct uart_port *p)
 	if (!of_property_read_u32(np, "reg-shift", &val))
 		p->regshift = val;
 
-	/* clock got configured through clk api, all done */
-	if (p->uartclk)
-		return 0;
-
-	/* try to find out clock frequency from DT as fallback */
-	if (of_property_read_u32(np, "clock-frequency", &val)) {
+	/* try to find out clock frequency from DT */
+	if (!of_property_read_u32(np, "clock-frequency", &val)) {
+		p->uartclk = val;
+	} else if (IS_ERR(d->clk)) {
 		dev_err(p->dev, "clk or clock-frequency not defined\n");
 		return -EINVAL;
 	}
-	p->uartclk = val;
 
 	return 0;
 }
@@ -235,6 +233,7 @@ static int dw8250_probe(struct platform_device *pdev)
 	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
 	struct dw8250_data *data;
 	int err;
+	unsigned long clk_rate;
 
 	if (!regs || !irq) {
 		dev_err(&pdev->dev, "no registers/irq defined\n");
@@ -260,10 +259,6 @@ static int dw8250_probe(struct platform_device *pdev)
 		return -ENOMEM;
 
 	data->clk = devm_clk_get(&pdev->dev, NULL);
-	if (!IS_ERR(data->clk)) {
-		clk_prepare_enable(data->clk);
-		uart.port.uartclk = clk_get_rate(data->clk);
-	}
 
 	uart.port.iotype = UPIO_MEM;
 	uart.port.serial_in = dw8250_serial_in;
@@ -284,6 +279,36 @@ static int dw8250_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	/* Read the clock rate from the clock */
+	if (!IS_ERR(data->clk)) {
+		clk_prepare_enable(data->clk);
+		clk_rate = clk_get_rate(data->clk);
+		/*
+		 * If uartclk hasn't been explicitly specified (e.g. from device
+		 * tree), use the rate from the clock instead.
+		 */
+		if (!uart.port.uartclk)
+			uart.port.uartclk = clk_rate;
+		/*
+		 * If the current clock rate differs from the rate specified,
+		 * try and set the clock rate.
+		 */
+		if (uart.port.uartclk != clk_rate) {
+			if (!clk_set_rate(data->clk, uart.port.uartclk))
+				clk_rate = clk_get_rate(data->clk);
+			dev_info(&pdev->dev,
+				 "uartclk at %lu Hz (%u Hz requested)\n",
+				 clk_rate, uart.port.uartclk);
+			/*
+			 * Don't update uartclk. If the rate was rounded down by
+			 * clk_set_rate() the 8250 core won't allow the highest
+			 * baud rate to be used.
+			 */
+		} else {
+			dev_info(&pdev->dev, "uartclk at %lu Hz\n", clk_rate);
+		}
+	}
+
 	data->line = serial8250_register_8250_port(&uart);
 	if (data->line < 0)
 		return data->line;
-- 
1.8.1.2


