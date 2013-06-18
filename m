Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933322Ab3FRTOG (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Jun 2013 15:14:06 -0400
Received: from mail-pd0-f181.google.com ([209.85.192.181]:41513 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932391Ab3FRTNH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Jun 2013 15:13:07 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>
Subject: [PATCH 3/5] tty/8250_dw: Add support for OCTEON UARTS.
Date: Tue, 18 Jun 2013 12:12:53 -0700
Message-Id: <1371582775-12141-4-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371582775-12141-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

A few differences needed by OCTEON:

o These are DWC UARTS, but have USR at a different offset.

o OCTEON must have 64-bit wide register accesses, so we have OCTEON
  specific register accessors.

o No UCV register, so we hard code some properties.

Signed-off-by: David Daney <david.daney@cavium.com>
---
 drivers/tty/serial/8250/8250_dw.c | 45 +++++++++++++++++++++++++++++++++------
 1 file changed, 39 insertions(+), 6 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index d07b6af..a50c1d5 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -57,8 +57,30 @@ struct dw8250_data {
 	int		last_lcr;
 	int		line;
 	struct clk	*clk;
+	u8		usr_reg;
+	bool		no_ucv;
 };
 
+static unsigned int dw8250_serial_inq(struct uart_port *p, int offset)
+{
+	offset <<= p->regshift;
+
+	return (u8)__raw_readq(p->membase + offset);
+}
+
+static void dw8250_serial_outq(struct uart_port *p, int offset, int value)
+{
+	struct dw8250_data *d = p->private_data;
+
+	if (offset == UART_LCR)
+		d->last_lcr = value;
+
+	offset <<= p->regshift;
+	__raw_writeq(value, p->membase + offset);
+	dw8250_serial_inq(p, UART_LCR);
+}
+
+
 static void dw8250_serial_out(struct uart_port *p, int offset, int value)
 {
 	struct dw8250_data *d = p->private_data;
@@ -104,7 +126,7 @@ static int dw8250_handle_irq(struct uart_port *p)
 		return 1;
 	} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 		/* Clear the USR and write the LCR again. */
-		(void)p->serial_in(p, DW_UART_USR);
+		(void)p->serial_in(p, d->usr_reg);
 		p->serial_out(p, UART_LCR, d->last_lcr);
 
 		return 1;
@@ -125,12 +147,20 @@ dw8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
 		pm_runtime_put_sync_suspend(port->dev);
 }
 
-static int dw8250_probe_of(struct uart_port *p)
+static int dw8250_probe_of(struct uart_port *p,
+			   struct dw8250_data *data)
 {
 	struct device_node	*np = p->dev->of_node;
 	u32			val;
 
-	if (!of_property_read_u32(np, "reg-io-width", &val)) {
+	if (of_device_is_compatible(np, "cavium,octeon-3860-uart")) {
+		p->serial_in = dw8250_serial_inq;
+		p->serial_out = dw8250_serial_outq;
+		p->flags = ASYNC_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
+		p->type = PORT_OCTEON;
+		data->usr_reg = 0x27;
+		data->no_ucv = true;
+	} else if (!of_property_read_u32(np, "reg-io-width", &val)) {
 		switch (val) {
 		case 1:
 			break;
@@ -259,6 +289,7 @@ static int dw8250_probe(struct platform_device *pdev)
 	if (!data)
 		return -ENOMEM;
 
+	data->usr_reg = DW_UART_USR;
 	data->clk = devm_clk_get(&pdev->dev, NULL);
 	if (!IS_ERR(data->clk)) {
 		clk_prepare_enable(data->clk);
@@ -270,10 +301,8 @@ static int dw8250_probe(struct platform_device *pdev)
 	uart.port.serial_out = dw8250_serial_out;
 	uart.port.private_data = data;
 
-	dw8250_setup_port(&uart);
-
 	if (pdev->dev.of_node) {
-		err = dw8250_probe_of(&uart.port);
+		err = dw8250_probe_of(&uart.port, data);
 		if (err)
 			return err;
 	} else if (ACPI_HANDLE(&pdev->dev)) {
@@ -284,6 +313,9 @@ static int dw8250_probe(struct platform_device *pdev)
 		return -ENODEV;
 	}
 
+	if (!data->no_ucv)
+		dw8250_setup_port(&uart);
+
 	data->line = serial8250_register_8250_port(&uart);
 	if (data->line < 0)
 		return data->line;
@@ -362,6 +394,7 @@ static const struct dev_pm_ops dw8250_pm_ops = {
 
 static const struct of_device_id dw8250_of_match[] = {
 	{ .compatible = "snps,dw-apb-uart" },
+	{ .compatible = "cavium,octeon-3860-uart" },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, dw8250_of_match);
-- 
1.7.11.7

