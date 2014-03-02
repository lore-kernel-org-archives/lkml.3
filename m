Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753465AbaCBOdQ (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 09:33:16 -0500
Received: from co9ehsobe003.messaging.microsoft.com ([207.46.163.26]:3341 "EHLO
	co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752043AbaCBOdM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 09:33:12 -0500
X-Forefront-Antispam-Report: CIP:149.199.60.83;KIP:(null);UIP:(null);IPV:NLI;H:xsj-gw1;RD:unknown-60-83.xilinx.com;EFVD:NLI
X-SpamScore: 9
X-BigFish: VPS9(zzc8kzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzdch70kd2iz1de098h17326ah8275bh8275dh1de097h186068hz2fh95h839hc61hd24hf0ah119dh1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h14ddh1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1b0ah224fh1d0ch1d2eh1d3fh1dfeh1dffh1e1dh1e23h1fe8h1ff5h2218h2216h226dh24afh2327h2336h2438h2461h2487h24d7h2516h2545h255eh906i20cfi1155h)
From: Punnaiah Choudary Kalluri <punnaiah.choudary.kalluri@xilinx.com>
To: <dougthompson@xmission.com>, <devicetree@vger.kernel.org>,
        <linux-doc@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>,
        <michal.simek@xilinx.com>, <robh+dt@kernel.org>, <pawel.moll@arm.com>,
        <mark.rutland@arm.com>, <ijc+devicetree@hellion.org.uk>,
        <galak@codeaurora.org>, <rob@landley.net>
CC: <kpc528@gmail.com>, <kalluripunnaiahchoudary@gmail.com>,
        <punnaia@xilinx.com>
Subject: [RFC PATCH] edac: add support for ARM PL310 L2 cache parity
Date: Sun, 2 Mar 2014 20:02:40 +0530
X-Mailer: git-send-email 1.7.4
In-Reply-To: <1393770760-32550-1-git-send-email-punnaia@xilinx.com>
References: <1393770760-32550-1-git-send-email-punnaia@xilinx.com>
X-RCIS-Action: ALLOW
MIME-Version: 1.0
Content-Type: text/plain
Message-ID: <a1a9e47a-069c-4285-9899-d5a58cf532c2@CO9EHSMHS003.ehs.local>
X-OriginatorOrg: xilinx.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add support for ARM Pl310 L2 cache controller parity error

Signed-off-by: Punnaiah Choudary Kalluri <punnaia@xilinx.com>
---
 .../devicetree/bindings/edac/pl310_edac_l2.txt     |   19 ++
 drivers/edac/Kconfig                               |    7 +
 drivers/edac/Makefile                              |    1 +
 drivers/edac/pl310_edac_l2.c                       |  236 ++++++++++++++++++++
 4 files changed, 263 insertions(+), 0 deletions(-)
 create mode 100644 Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
 create mode 100644 drivers/edac/pl310_edac_l2.c

diff --git a/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt b/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
new file mode 100644
index 0000000..94fbb8d
--- /dev/null
+++ b/Documentation/devicetree/bindings/edac/pl310_edac_l2.txt
@@ -0,0 +1,19 @@
+Pl310 L2 Cache EDAC driver, it does reports the data and tag ram parity errors.
+
+Required properties:
+- compatible: Should be "arm,pl310-cache".
+- intterupts: Interrupt number to the cpu.
+- reg: Physical base address and size of cache controller's memory mapped
+  registers
+
+Example:
+++++++++
+
+	L2: cache-controller {
+		compatible = "arm,pl310-cache";
+		interrupts = <0 2 4>;
+		reg = <0xf8f02000 0x1000>;
+	};
+
+PL310 L2 Cache EDAC driver detects the Parity enable state by reading the
+appropriate control register.
diff --git a/drivers/edac/Kconfig b/drivers/edac/Kconfig
index 878f090..059ac31 100644
--- a/drivers/edac/Kconfig
+++ b/drivers/edac/Kconfig
@@ -326,6 +326,13 @@ config EDAC_TILE
 	  Support for error detection and correction on the
 	  Tilera memory controller.
 
+config EDAC_PL310_L2
+	tristate "Pl310 L2 Cache Controller"
+	depends on EDAC_MM_EDAC && ARM
+	help
+	  Support for parity error detection on L2 cache controller
+	  data and tag ram memory
+
 config EDAC_HIGHBANK_MC
 	tristate "Highbank Memory Controller"
 	depends on EDAC_MM_EDAC && ARCH_HIGHBANK
diff --git a/drivers/edac/Makefile b/drivers/edac/Makefile
index 4154ed6..179356f 100644
--- a/drivers/edac/Makefile
+++ b/drivers/edac/Makefile
@@ -64,3 +64,4 @@ obj-$(CONFIG_EDAC_OCTEON_PC)		+= octeon_edac-pc.o
 obj-$(CONFIG_EDAC_OCTEON_L2C)		+= octeon_edac-l2c.o
 obj-$(CONFIG_EDAC_OCTEON_LMC)		+= octeon_edac-lmc.o
 obj-$(CONFIG_EDAC_OCTEON_PCI)		+= octeon_edac-pci.o
+obj-$(CONFIG_EDAC_PL310_L2)		+= pl310_edac_l2.o
diff --git a/drivers/edac/pl310_edac_l2.c b/drivers/edac/pl310_edac_l2.c
new file mode 100644
index 0000000..649371a
--- /dev/null
+++ b/drivers/edac/pl310_edac_l2.c
@@ -0,0 +1,236 @@
+/*
+ * Pl310 L2 Cache EDAC Driver
+ *
+ * Copyright (C) 2013-2014 Xilinx, Inc.
+ *
+ * This program is free software: you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License as published by
+ * the Free Software Foundation, either version 2 of the License, or
+ * (at your option) any later version.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ *
+ * You should have received a copy of the GNU General Public License
+ * along with this program.  If not, see <http://www.gnu.org/licenses/>.
+ */
+#include <linux/edac.h>
+#include <linux/interrupt.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <asm/hardware/cache-l2x0.h>
+#include "edac_core.h"
+
+/* Auxilary control register definitions */
+#define L2X0_AUX_CTRL_PARITY_MASK	BIT(21)
+
+/* Interrupt imask/status/clear register definitions */
+#define L2X0_INTR_PARRD_MASK	0x4
+#define L2X0_INTR_PARRT_MASK	0x2
+
+/**
+ * struct pl310_edac_l2_priv - Zynq L2 cache controller private instance data
+ * @base:		Base address of the controller
+ * @irq:		Interrupt number
+ */
+struct pl310_edac_l2_priv {
+	void __iomem *base;
+	int irq;
+};
+
+/**
+ * pl310_edac_l2_parityerr_check - Check controller staus for parity errors
+ * @dci:	Pointer to the edac device controller instance
+ *
+ * This routine is used to check and post parity errors
+ */
+static void pl310_edac_l2_parityerr_check(struct edac_device_ctl_info *dci)
+{
+	struct pl310_edac_l2_priv *priv = dci->pvt_info;
+	u32 regval;
+
+	regval = readl(priv->base + L2X0_RAW_INTR_STAT);
+	if (regval & L2X0_INTR_PARRD_MASK) {
+		/* Data parity error will be reported as correctable error */
+		writel(L2X0_INTR_PARRD_MASK, priv->base + L2X0_INTR_CLEAR);
+		edac_device_handle_ce(dci, 0, 0, dci->ctl_name);
+	}
+	if (regval & L2X0_INTR_PARRT_MASK) {
+		/* tag parity error will be reported as uncorrectable error */
+		writel(L2X0_INTR_PARRT_MASK, priv->base + L2X0_INTR_CLEAR);
+		edac_device_handle_ue(dci, 0, 0, dci->ctl_name);
+	}
+}
+
+/**
+ * pl310_edac_l2_int_handler - ISR fucntion for l2cahe controller
+ * @irq:	Irq Number
+ * @device:	Pointer to the edac device controller instance
+ *
+ * This routine is triggered whenever there is parity error detected
+ *
+ * Return: Always returns IRQ_HANDLED
+ */
+static irqreturn_t pl310_edac_l2_int_handler(int irq, void *device)
+{
+	pl310_edac_l2_parityerr_check((struct edac_device_ctl_info *)device);
+	return IRQ_HANDLED;
+}
+
+/**
+ * pl310_edac_l2_poll_handler - Poll the status reg for parity errors
+ * @dci:	Pointer to the edac device controller instance
+ *
+ * This routine is used to check and post parity errors and is called by
+ * the EDAC polling thread
+ */
+static void pl310_edac_l2_poll_handler(struct edac_device_ctl_info *dci)
+{
+	pl310_edac_l2_parityerr_check(dci);
+}
+
+/**
+ * pl310_edac_l2_get_paritystate - check the parity enable/disable status
+ * @base:	Pointer to the contoller base address
+ *
+ * This routine returns the parity enable/diable status for the controller
+ *
+ * Return: true/false -  parity enabled/disabled.
+ */
+static bool pl310_edac_l2_get_paritystate(void __iomem *base)
+{
+	u32 regval;
+
+	regval = readl(base + L2X0_AUX_CTRL);
+	if (regval & L2X0_AUX_CTRL_PARITY_MASK)
+		return true;
+
+	return false;
+}
+
+/**
+ * pl310_edac_l2_probe - Check controller and bind driver
+ * @pdev:	Pointer to the platform_device struct
+ *
+ * This routine probes a specific arm,pl310-cache instance for binding
+ * with the driver.
+ *
+ * Return: 0 if the controller instance was successfully bound to the
+ * driver; otherwise, < 0 on error.
+ */
+static int pl310_edac_l2_probe(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci;
+	struct pl310_edac_l2_priv *priv;
+	int rc;
+	struct resource *res;
+	void __iomem *baseaddr;
+	u32 regval;
+
+	/* Get the data from the platform device */
+	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
+	baseaddr = devm_ioremap_resource(&pdev->dev, res);
+	if (IS_ERR(baseaddr))
+		return PTR_ERR(baseaddr);
+
+	/* Check for the ecc enable status */
+	if (pl310_edac_l2_get_paritystate(baseaddr) == false) {
+		dev_err(&pdev->dev, "parity check not enabled\n");
+		return -ENXIO;
+	}
+
+	dci = edac_device_alloc_ctl_info(sizeof(*priv), "l2cache",
+					 1, "L", 1, 1, NULL, 0, 0);
+	if (IS_ERR(dci))
+		return PTR_ERR(dci);
+
+	priv = dci->pvt_info;
+	priv->base = baseaddr;
+	dci->dev = &pdev->dev;
+	dci->mod_name = "pl310_edac_l2";
+	dci->ctl_name = "pl310_l2_controller";
+	dci->dev_name = dev_name(&pdev->dev);
+
+	priv->irq = platform_get_irq(pdev, 0);
+	rc = devm_request_irq(&pdev->dev, priv->irq,
+				pl310_edac_l2_int_handler,
+				0, dev_name(&pdev->dev), (void *)dci);
+	if (rc < 0) {
+		dci->edac_check = pl310_edac_l2_poll_handler;
+		edac_op_state = EDAC_OPSTATE_POLL;
+	}
+
+	rc = edac_device_add_device(dci);
+	if (rc) {
+		dev_err(&pdev->dev, "failed to register with EDAC core\n");
+		goto del_edac_device;
+	}
+
+	if (edac_op_state != EDAC_OPSTATE_POLL) {
+		regval = readl(priv->base+L2X0_INTR_MASK);
+		regval |= (L2X0_INTR_PARRD_MASK | L2X0_INTR_PARRT_MASK);
+		writel(regval, priv->base+L2X0_INTR_MASK);
+	}
+
+	return rc;
+
+del_edac_device:
+	edac_device_del_device(&pdev->dev);
+	edac_device_free_ctl_info(dci);
+
+	return rc;
+}
+
+/**
+ * pl310_edac_l2_remove - Unbind driver from controller
+ * @pdev:	Pointer to the platform_device struct
+ *
+ * This routine unbinds the EDAC device controller instance associated
+ * with the specified arm,pl310-cache controller described by the
+ * OpenFirmware device tree node passed as a parameter.
+ *
+ * Return: Always returns 0
+ */
+static int pl310_edac_l2_remove(struct platform_device *pdev)
+{
+	struct edac_device_ctl_info *dci = platform_get_drvdata(pdev);
+	struct pl310_edac_l2_priv *priv = dci->pvt_info;
+	u32 regval;
+
+	if (edac_op_state != EDAC_OPSTATE_POLL) {
+		regval = readl(priv->base+L2X0_INTR_MASK);
+		regval &= ~(L2X0_INTR_PARRD_MASK | L2X0_INTR_PARRT_MASK);
+		writel(regval, priv->base+L2X0_INTR_MASK);
+	}
+
+	edac_device_del_device(&pdev->dev);
+	edac_device_free_ctl_info(dci);
+
+	return 0;
+}
+
+/* Device tree node type and compatible tuples this driver can match on */
+static struct of_device_id pl310_edac_l2_match[] = {
+	{ .compatible = "arm,pl310-cache", },
+	{ /* end of table */ }
+};
+
+MODULE_DEVICE_TABLE(of, pl310_edac_l2_match);
+
+static struct platform_driver pl310_edac_l2_driver = {
+	.driver = {
+		 .name = "pl310-edac-l2",
+		 .owner = THIS_MODULE,
+		 .of_match_table = pl310_edac_l2_match,
+	},
+	.probe = pl310_edac_l2_probe,
+	.remove = pl310_edac_l2_remove,
+};
+
+module_platform_driver(pl310_edac_l2_driver);
+
+MODULE_AUTHOR("Xilinx Inc.");
+MODULE_DESCRIPTION("pl310 L2 EDAC driver");
+MODULE_LICENSE("GPL v2");
-- 
1.7.4


