Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755608AbaGBQAU (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 12:00:20 -0400
Received: from www.linutronix.de ([62.245.132.108]:48198 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754338AbaGBQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 12:00:17 -0400
From: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
To: linux-serial@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Sebastian Andrzej Siewior <bigeasy@linutronix.de>
Subject: [RFC PATCH] tty: serial: Add 8250-core based omap driver
Date: Wed,  2 Jul 2014 18:00:09 +0200
Message-Id: <1404316809-20637-1-git-send-email-bigeasy@linutronix.de>
X-Mailer: git-send-email 2.0.0
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch provides a 8250-core based UART driver for the internal OMAP
UART. The longterm goal is to provide the same functionality as the
current OMAP uart driver and hopefully DMA support which could borrowed
from the 8250-core.

The whole PM-Runtime part is currently missing.
It has been only tested as console UART.
The tty name is ttyS based instead of ttyO. How big is the pain here,
what could be the easiest way to provide compatibility?

Signed-off-by: Sebastian Andrzej Siewior <bigeasy@linutronix.de>
---
 drivers/tty/serial/8250/8250_core.c |   7 ++
 drivers/tty/serial/8250/8250_omap.c | 224 ++++++++++++++++++++++++++++++++++++
 drivers/tty/serial/8250/Kconfig     |   9 ++
 drivers/tty/serial/8250/Makefile    |   1 +
 include/uapi/linux/serial_core.h    |   3 +-
 5 files changed, 243 insertions(+), 1 deletion(-)
 create mode 100644 drivers/tty/serial/8250/8250_omap.c

diff --git a/drivers/tty/serial/8250/8250_core.c b/drivers/tty/serial/8250/8250_core.c
index 7a91c6d..f47e876 100644
--- a/drivers/tty/serial/8250/8250_core.c
+++ b/drivers/tty/serial/8250/8250_core.c
@@ -260,6 +260,13 @@ static const struct serial8250_config uart_config[] = {
 		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_10,
 		.flags		= UART_CAP_FIFO | UART_CAP_AFE,
 	},
+	[PORT_OMAP_16750] = {
+		.name		= "OMAP",
+		.fifo_size	= 64,
+		.tx_loadsz	= 64,
+		.fcr		= UART_FCR_ENABLE_FIFO | UART_FCR_R_TRIG_01,
+		.flags		= UART_CAP_FIFO | UART_CAP_EFR | UART_CAP_SLEEP,
+	},
 	[PORT_TEGRA] = {
 		.name		= "Tegra",
 		.fifo_size	= 32,
diff --git a/drivers/tty/serial/8250/8250_omap.c b/drivers/tty/serial/8250/8250_omap.c
new file mode 100644
index 0000000..a23013f
--- /dev/null
+++ b/drivers/tty/serial/8250/8250_omap.c
@@ -0,0 +1,224 @@
+/*
+ * 8250-core based driver for the OMAP internal UART
+ *
+ *  Copyright (C) 2014 Sebastian Andrzej Siewior
+ *
+ */
+
+#include <linux/device.h>
+#include <linux/io.h>
+#include <linux/module.h>
+#include <linux/serial_8250.h>
+#include <linux/serial_core.h>
+#include <linux/serial_reg.h>
+#include <linux/platform_device.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+
+#include "8250.h"
+
+#define UART_DLL_EM 9
+#define UART_DLM_EM 10
+
+#define DEFAULT_CLK_SPEED 48000000 /* 48Mhz*/
+
+#define UART_ERRATA_i202_MDR1_ACCESS	(1 << 0)
+#define OMAP_UART_WER_HAS_TX_WAKEUP	(1 << 1)
+
+/* SCR register bitmasks */
+#define OMAP_UART_SCR_RX_TRIG_GRANU1_MASK	(1 << 7)
+#define OMAP_UART_SCR_TX_TRIG_GRANU1_MASK	(1 << 6)
+#define OMAP_UART_SCR_TX_EMPTY			(1 << 3)
+
+/* MVR register bitmasks */
+#define OMAP_UART_MVR_SCHEME_SHIFT	30
+#define OMAP_UART_LEGACY_MVR_MAJ_MASK	0xf0
+#define OMAP_UART_LEGACY_MVR_MAJ_SHIFT	4
+#define OMAP_UART_LEGACY_MVR_MIN_MASK	0x0f
+#define OMAP_UART_MVR_MAJ_MASK		0x700
+#define OMAP_UART_MVR_MAJ_SHIFT		8
+#define OMAP_UART_MVR_MIN_MASK		0x3f
+
+#define UART_BUILD_REVISION(x, y)	(((x) << 8) | (y))
+
+#define OMAP_UART_REV_46 0x0406
+#define OMAP_UART_REV_52 0x0502
+#define OMAP_UART_REV_63 0x0603
+
+struct serial8250_omap_priv {
+	int line;
+	u32 habit;
+};
+
+static u32 uart_read(struct uart_8250_port *up, u32 reg)
+{
+	return readl(up->port.membase + (reg << up->port.regshift));
+}
+
+static void uart_write(struct uart_8250_port *up, u32 reg, u32 val)
+{
+	writel(val, up->port.membase + (reg << up->port.regshift));
+}
+
+static void omap_serial_fill_features_erratas(struct uart_8250_port *up,
+		struct serial8250_omap_priv *priv)
+{
+	u32 mvr, scheme;
+	u16 revision, major, minor;
+
+	mvr = uart_read(up, UART_OMAP_MVER);
+
+	/* Check revision register scheme */
+	scheme = mvr >> OMAP_UART_MVR_SCHEME_SHIFT;
+
+	switch (scheme) {
+	case 0: /* Legacy Scheme: OMAP2/3 */
+		/* MINOR_REV[0:4], MAJOR_REV[4:7] */
+		major = (mvr & OMAP_UART_LEGACY_MVR_MAJ_MASK) >>
+			OMAP_UART_LEGACY_MVR_MAJ_SHIFT;
+		minor = (mvr & OMAP_UART_LEGACY_MVR_MIN_MASK);
+		break;
+	case 1:
+		/* New Scheme: OMAP4+ */
+		/* MINOR_REV[0:5], MAJOR_REV[8:10] */
+		major = (mvr & OMAP_UART_MVR_MAJ_MASK) >>
+			OMAP_UART_MVR_MAJ_SHIFT;
+		minor = (mvr & OMAP_UART_MVR_MIN_MASK);
+		break;
+	default:
+		dev_warn(up->port.dev,
+				"Unknown revision, defaulting to highest\n");
+		/* highest possible revision */
+		major = 0xff;
+		minor = 0xff;
+	}
+	/* normalize revision for the driver */
+	revision = UART_BUILD_REVISION(major, minor);
+
+	switch (revision) {
+	case OMAP_UART_REV_46:
+		priv->habit = UART_ERRATA_i202_MDR1_ACCESS;
+		break;
+	case OMAP_UART_REV_52:
+		priv->habit = UART_ERRATA_i202_MDR1_ACCESS |
+				OMAP_UART_WER_HAS_TX_WAKEUP;
+		break;
+	case OMAP_UART_REV_63:
+		priv->habit = UART_ERRATA_i202_MDR1_ACCESS |
+			OMAP_UART_WER_HAS_TX_WAKEUP;
+		break;
+	default:
+		break;
+	}
+}
+
+static int serial8250_omap_probe(struct platform_device *pdev)
+{
+	struct resource *regs = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	struct resource *irq = platform_get_resource(pdev, IORESOURCE_IRQ, 0);
+	struct serial8250_omap_priv *priv;
+	struct uart_8250_port up;
+	int ret;
+	void __iomem *membase;
+
+	if (!regs || !irq) {
+		dev_err(&pdev->dev, "missing registers or irq\n");
+		return -EINVAL;
+	}
+
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
+	if (!priv) {
+		dev_err(&pdev->dev, "unable to allocate private data\n");
+		return -ENOMEM;
+	}
+	membase = devm_ioremap_nocache(&pdev->dev, regs->start,
+			resource_size(regs));
+	if (!membase)
+		return -ENODEV;
+
+	memset(&up, 0, sizeof(up));
+	up.port.dev = &pdev->dev;
+	up.port.mapbase = regs->start;
+	up.port.membase = membase;
+	up.port.irq = irq->start;
+	/*
+	 * It claims to be 16C750 compatible however it is a little different.
+	 * It has EFR and has no FCR7_64byte bit. The AFE which it claims to is
+	 * enabled via EFR instead of MCR.
+	 */
+	up.port.type = PORT_OMAP_16750;
+	up.port.iotype = UPIO_MEM32;
+	up.port.flags = UPF_BOOT_AUTOCONF | UPF_FIXED_PORT | UPF_FIXED_TYPE;
+	up.port.private_data = priv;
+
+	up.port.regshift = 2;
+	up.port.fifosize = 64;
+
+	if (pdev->dev.of_node) {
+		up.port.line = of_alias_get_id(pdev->dev.of_node, "serial");
+		of_property_read_u32(pdev->dev.of_node, "clock-frequency",
+				&up.port.uartclk);
+	} else {
+		up.port.line = pdev->id;
+	}
+
+	if (up.port.line < 0) {
+		dev_err(&pdev->dev, "failed to get alias/pdev id, errno %d\n",
+				up.port.line);
+		ret = -ENODEV;
+		/*XXX*/
+		BUG();
+	}
+	if (!up.port.uartclk) {
+		up.port.uartclk = DEFAULT_CLK_SPEED;
+		dev_warn(&pdev->dev,
+				"No clock speed specified: using default: %d\n",
+				DEFAULT_CLK_SPEED);
+	}
+
+	omap_serial_fill_features_erratas(&up, priv);
+
+	uart_write(&up, UART_OMAP_SCR, OMAP_UART_SCR_TX_EMPTY |
+			OMAP_UART_SCR_RX_TRIG_GRANU1_MASK);
+
+	ret = serial8250_register_8250_port(&up);
+	if (ret < 0) {
+		dev_err(&pdev->dev, "unable to register 8250 port\n");
+		return ret;
+	}
+	priv->line = ret;
+	platform_set_drvdata(pdev, priv);
+	return 0;
+}
+
+static int serial8250_omap_remove(struct platform_device *pdev)
+{
+	struct serial8250_omap_priv *priv = platform_get_drvdata(pdev);
+
+	serial8250_unregister_port(priv->line);
+	return 0;
+}
+
+static const struct of_device_id serial8250_omap_dt_ids[] = {
+	{ .compatible = "ti,omap2-uart" },
+	{ .compatible = "ti,omap3-uart" },
+	{ .compatible = "ti,omap4-uart" },
+	{},
+};
+MODULE_DEVICE_TABLE(of, serial8250_omap_dt_ids);
+
+static struct platform_driver serial8250_omap_platform_driver = {
+	.driver = {
+		.name		= "serial8250-omap",
+		.of_match_table = serial8250_omap_dt_ids,
+		.owner		= THIS_MODULE,
+	},
+	.probe			= serial8250_omap_probe,
+	.remove			= serial8250_omap_remove,
+};
+
+module_platform_driver(serial8250_omap_platform_driver);
+
+MODULE_AUTHOR("Sebastian Andrzej Siewior");
+MODULE_DESCRIPTION("OMAP 8250 Driver");
+MODULE_LICENSE("GPL v2");
diff --git a/drivers/tty/serial/8250/Kconfig b/drivers/tty/serial/8250/Kconfig
index 349ee59..7a5073b 100644
--- a/drivers/tty/serial/8250/Kconfig
+++ b/drivers/tty/serial/8250/Kconfig
@@ -298,3 +298,12 @@ config SERIAL_8250_RT288X
 	  If you have a Ralink RT288x/RT305x SoC based board and want to use the
 	  serial port, say Y to this option. The driver can handle up to 2 serial
 	  ports. If unsure, say N.
+
+config SERIAL_8250_OMAP
+	tristate "Support for OMAP internal UART (8250 based driver)"
+	depends on SERIAL_8250 && ARCH_OMAP2PLUS
+	help
+	  If you have a machine based on an Texas Instruments OMAP CPU you
+	  can enable its onboard serial ports by enabling this option.
+
+	  This driver is in early stage and uses ttyS instead of ttyO.
diff --git a/drivers/tty/serial/8250/Makefile b/drivers/tty/serial/8250/Makefile
index 36d68d0..4bac392 100644
--- a/drivers/tty/serial/8250/Makefile
+++ b/drivers/tty/serial/8250/Makefile
@@ -20,3 +20,4 @@ obj-$(CONFIG_SERIAL_8250_HUB6)		+= 8250_hub6.o
 obj-$(CONFIG_SERIAL_8250_FSL)		+= 8250_fsl.o
 obj-$(CONFIG_SERIAL_8250_DW)		+= 8250_dw.o
 obj-$(CONFIG_SERIAL_8250_EM)		+= 8250_em.o
+obj-$(CONFIG_SERIAL_8250_OMAP)		+= 8250_omap.o
diff --git a/include/uapi/linux/serial_core.h b/include/uapi/linux/serial_core.h
index 5820269..74f9b11 100644
--- a/include/uapi/linux/serial_core.h
+++ b/include/uapi/linux/serial_core.h
@@ -54,7 +54,8 @@
 #define PORT_ALTR_16550_F32 26	/* Altera 16550 UART with 32 FIFOs */
 #define PORT_ALTR_16550_F64 27	/* Altera 16550 UART with 64 FIFOs */
 #define PORT_ALTR_16550_F128 28 /* Altera 16550 UART with 128 FIFOs */
-#define PORT_MAX_8250	28	/* max port ID */
+#define PORT_OMAP_16750	29	/* TI's OMAP internal 16C750 compatible UART */
+#define PORT_MAX_8250	29	/* max port ID */
 
 /*
  * ARM specific type numbers.  These are not currently guaranteed
-- 
2.0.0

