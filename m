Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935227Ab3FSViz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Jun 2013 17:38:55 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:38068 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935012Ab3FSVhi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Jun 2013 17:37:38 -0400
From: David Daney <ddaney.cavm@gmail.com>
To: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Jamie Iles <jamie@jamieiles.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Jiri Slaby <jslaby@suse.cz>, linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Arnd Bergmann <arnd@arndb.de>,
        Heikki Krogerus <heikki.krogerus@linux.intel.com>
Subject: [PATCH v2 2/4] tty/8250_dw: Add support for OCTEON UARTS.
Date: Wed, 19 Jun 2013 14:37:27 -0700
Message-Id: <1371677849-23912-3-git-send-email-ddaney.cavm@gmail.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1371677849-23912-1-git-send-email-ddaney.cavm@gmail.com>
References: <1371677849-23912-1-git-send-email-ddaney.cavm@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Daney <david.daney@cavium.com>

A few differences needed by OCTEON:

o These are DWC UARTS, but have USR at a different offset.

o Internal SoC buses require reading back from registers to maintain
  write ordering.

o 8250 on OCTEON appears with 64-bit wide registers, so when using
  readb/writeb in big endian mode we have to adjust the membase to hit
  the proper part of the register.

o No UCV register, so we hard code some properties.

Because OCTEON doesn't have a UCV register, I change where
dw8250_setup_port(), which reads the UCV, is called by pushing it in
to the OF and ACPI probe functions, and move unchanged
dw8250_setup_port() earlier in the file.

Signed-off-by: David Daney <david.daney@cavium.com>
Acked-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Arnd Bergmann <arnd@arndb.de>
Cc: Heikki Krogerus <heikki.krogerus@linux.intel.com>
---
 drivers/tty/serial/8250/8250_dw.c | 108 ++++++++++++++++++++++++--------------
 1 file changed, 69 insertions(+), 39 deletions(-)

diff --git a/drivers/tty/serial/8250/8250_dw.c b/drivers/tty/serial/8250/8250_dw.c
index d07b6af..76a8daa 100644
--- a/drivers/tty/serial/8250/8250_dw.c
+++ b/drivers/tty/serial/8250/8250_dw.c
@@ -29,6 +29,8 @@
 #include <linux/clk.h>
 #include <linux/pm_runtime.h>
 
+#include <asm/byteorder.h>
+
 #include "8250.h"
 
 /* Offsets for the DesignWare specific registers */
@@ -57,6 +59,7 @@ struct dw8250_data {
 	int		last_lcr;
 	int		line;
 	struct clk	*clk;
+	u8		usr_reg;
 };
 
 static void dw8250_serial_out(struct uart_port *p, int offset, int value)
@@ -77,6 +80,13 @@ static unsigned int dw8250_serial_in(struct uart_port *p, int offset)
 	return readb(p->membase + offset);
 }
 
+/* Read Back (rb) version to ensure register access ording. */
+static void dw8250_serial_out_rb(struct uart_port *p, int offset, int value)
+{
+	dw8250_serial_out(p, offset, value);
+	dw8250_serial_in(p, UART_LCR);
+}
+
 static void dw8250_serial_out32(struct uart_port *p, int offset, int value)
 {
 	struct dw8250_data *d = p->private_data;
@@ -104,7 +114,7 @@ static int dw8250_handle_irq(struct uart_port *p)
 		return 1;
 	} else if ((iir & UART_IIR_BUSY) == UART_IIR_BUSY) {
 		/* Clear the USR and write the LCR again. */
-		(void)p->serial_in(p, DW_UART_USR);
+		(void)p->serial_in(p, d->usr_reg);
 		p->serial_out(p, UART_LCR, d->last_lcr);
 
 		return 1;
@@ -125,12 +135,60 @@ dw8250_do_pm(struct uart_port *port, unsigned int state, unsigned int old)
 		pm_runtime_put_sync_suspend(port->dev);
 }
 
-static int dw8250_probe_of(struct uart_port *p)
+static void dw8250_setup_port(struct uart_8250_port *up)
+{
+	struct uart_port	*p = &up->port;
+	u32			reg = readl(p->membase + DW_UART_UCV);
+
+	/*
+	 * If the Component Version Register returns zero, we know that
+	 * ADDITIONAL_FEATURES are not enabled. No need to go any further.
+	 */
+	if (!reg)
+		return;
+
+	dev_dbg_ratelimited(p->dev, "Designware UART version %c.%c%c\n",
+		(reg >> 24) & 0xff, (reg >> 16) & 0xff, (reg >> 8) & 0xff);
+
+	reg = readl(p->membase + DW_UART_CPR);
+	if (!reg)
+		return;
+
+	/* Select the type based on fifo */
+	if (reg & DW_UART_CPR_FIFO_MODE) {
+		p->type = PORT_16550A;
+		p->flags |= UPF_FIXED_TYPE;
+		p->fifosize = DW_UART_CPR_FIFO_SIZE(reg);
+		up->tx_loadsz = p->fifosize;
+		up->capabilities = UART_CAP_FIFO;
+	}
+
+	if (reg & DW_UART_CPR_AFCE_MODE)
+		up->capabilities |= UART_CAP_AFE;
+}
+
+static int dw8250_probe_of(struct uart_port *p,
+			   struct dw8250_data *data)
 {
 	struct device_node	*np = p->dev->of_node;
 	u32			val;
-
-	if (!of_property_read_u32(np, "reg-io-width", &val)) {
+	bool has_ucv = true;
+
+	if (of_device_is_compatible(np, "cavium,octeon-3860-uart")) {
+#ifdef __BIG_ENDIAN
+		/*
+		 * Low order bits of these 64-bit registers, when
+		 * accessed as a byte, are 7 bytes further down in the
+		 * address space in big endian mode.
+		 */
+		p->membase += 7;
+#endif
+		p->serial_out = dw8250_serial_out_rb;
+		p->flags = ASYNC_SKIP_TEST | UPF_SHARE_IRQ | UPF_FIXED_TYPE;
+		p->type = PORT_OCTEON;
+		data->usr_reg = 0x27;
+		has_ucv = false;
+	} else if (!of_property_read_u32(np, "reg-io-width", &val)) {
 		switch (val) {
 		case 1:
 			break;
@@ -144,6 +202,8 @@ static int dw8250_probe_of(struct uart_port *p)
 			return -EINVAL;
 		}
 	}
+	if (has_ucv)
+		dw8250_setup_port(container_of(p, struct uart_8250_port, port));
 
 	if (!of_property_read_u32(np, "reg-shift", &val))
 		p->regshift = val;
@@ -168,6 +228,8 @@ static int dw8250_probe_acpi(struct uart_8250_port *up)
 	const struct acpi_device_id *id;
 	struct uart_port *p = &up->port;
 
+	dw8250_setup_port(up);
+
 	id = acpi_match_device(p->dev->driver->acpi_match_table, p->dev);
 	if (!id)
 		return -ENODEV;
@@ -196,38 +258,6 @@ static inline int dw8250_probe_acpi(struct uart_8250_port *up)
 }
 #endif /* CONFIG_ACPI */
 
-static void dw8250_setup_port(struct uart_8250_port *up)
-{
-	struct uart_port	*p = &up->port;
-	u32			reg = readl(p->membase + DW_UART_UCV);
-
-	/*
-	 * If the Component Version Register returns zero, we know that
-	 * ADDITIONAL_FEATURES are not enabled. No need to go any further.
-	 */
-	if (!reg)
-		return;
-
-	dev_dbg_ratelimited(p->dev, "Designware UART version %c.%c%c\n",
-		(reg >> 24) & 0xff, (reg >> 16) & 0xff, (reg >> 8) & 0xff);
-
-	reg = readl(p->membase + DW_UART_CPR);
-	if (!reg)
-		return;
-
-	/* Select the type based on fifo */
-	if (reg & DW_UART_CPR_FIFO_MODE) {
-		p->type = PORT_16550A;
-		p->flags |= UPF_FIXED_TYPE;
-		p->fifosize = DW_UART_CPR_FIFO_SIZE(reg);
-		up->tx_loadsz = p->fifosize;
-		up->capabilities = UART_CAP_FIFO;
-	}
-
-	if (reg & DW_UART_CPR_AFCE_MODE)
-		up->capabilities |= UART_CAP_AFE;
-}
-
 static int dw8250_probe(struct platform_device *pdev)
 {
 	struct uart_8250_port uart = {};
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
@@ -362,6 +391,7 @@ static const struct dev_pm_ops dw8250_pm_ops = {
 
 static const struct of_device_id dw8250_of_match[] = {
 	{ .compatible = "snps,dw-apb-uart" },
+	{ .compatible = "cavium,octeon-3860-uart" },
 	{ /* Sentinel */ }
 };
 MODULE_DEVICE_TABLE(of, dw8250_of_match);
-- 
1.7.11.7

