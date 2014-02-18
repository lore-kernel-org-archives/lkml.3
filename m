Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754117AbaBRCJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 17 Feb 2014 21:09:50 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:58015 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753925AbaBRCJs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 17 Feb 2014 21:09:48 -0500
From: Magnus Damm <magnus.damm@gmail.com>
To: linux-pci@vger.kernel.org
Cc: horms@verge.net.au, linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org,
        valentine.barshak@cogentembedded.com, ben.dooks@codethink.co.uk,
        geert@linux-m68k.org, bhelgaas@google.com,
        Magnus Damm <magnus.damm@gmail.com>
Date: Tue, 18 Feb 2014 11:11:01 +0900
Message-Id: <20140218021101.14164.97765.sendpatchset@w520>
In-Reply-To: <20140218021041.14164.56411.sendpatchset@w520>
References: <20140218021041.14164.56411.sendpatchset@w520>
Subject: [PATCH v2 02/08] PCI: rcar: add error interrupt handling
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ben Dooks <ben.dooks@codethink.co.uk>

Add option to enable interrupts to report any errors from
the AHB-PCI bridge to help find any issues with the bridge
when in use.

Signed-off-by: Ben Dooks <ben.dooks@codethink.co.uk>
Signed-off-by: Magnus Damm <damm@opensource.se>
---

v2:
        - removed kconfig entry and use CONFIG_PCI_DEBUG
        - check for irq > 0 before trying to attach irq

 drivers/pci/host/pci-rcar-gen2.c |   60 ++++++++++++++++++++++++++++++++++++++
 1 file changed, 60 insertions(+)

--- 0004/drivers/pci/host/pci-rcar-gen2.c
+++ work/drivers/pci/host/pci-rcar-gen2.c	2014-02-13 09:42:56.000000000 +0900
@@ -39,9 +39,26 @@
 
 #define RCAR_PCI_INT_ENABLE_REG		(RCAR_AHBPCI_PCICOM_OFFSET + 0x20)
 #define RCAR_PCI_INT_STATUS_REG		(RCAR_AHBPCI_PCICOM_OFFSET + 0x24)
+#define RCAR_PCI_INT_SIGTABORT		(1 << 0)
+#define RCAR_PCI_INT_SIGRETABORT	(1 << 1)
+#define RCAR_PCI_INT_REMABORT		(1 << 2)
+#define RCAR_PCI_INT_PERR		(1 << 3)
+#define RCAR_PCI_INT_SIGSERR		(1 << 4)
+#define RCAR_PCI_INT_RESERR		(1 << 5)
+#define RCAR_PCI_INT_WIN1ERR		(1 << 12)
+#define RCAR_PCI_INT_WIN2ERR		(1 << 13)
 #define RCAR_PCI_INT_A			(1 << 16)
 #define RCAR_PCI_INT_B			(1 << 17)
 #define RCAR_PCI_INT_PME		(1 << 19)
+#define RCAR_PCI_INT_ALLERRORS (RCAR_PCI_INT_SIGTABORT		| \
+				RCAR_PCI_INT_SIGRETABORT	| \
+				RCAR_PCI_INT_SIGRETABORT	| \
+				RCAR_PCI_INT_REMABORT		| \
+				RCAR_PCI_INT_PERR		| \
+				RCAR_PCI_INT_SIGSERR		| \
+				RCAR_PCI_INT_RESERR		| \
+				RCAR_PCI_INT_WIN1ERR		| \
+				RCAR_PCI_INT_WIN2ERR)
 
 #define RCAR_AHB_BUS_CTR_REG		(RCAR_AHBPCI_PCICOM_OFFSET + 0x30)
 #define RCAR_AHB_BUS_MMODE_HTRANS	(1 << 0)
@@ -164,6 +181,46 @@ static int __init rcar_pci_map_irq(const
 	return priv->irq;
 }
 
+#ifdef CONFIG_PCI_DEBUG
+/* if debug enabled, then attach an error handler irq to the bridge */
+
+static irqreturn_t rcar_pci_err_irq(int irq, void *pw)
+{
+	struct rcar_pci_priv *priv = pw;
+	u32 status = ioread32(priv->reg + RCAR_PCI_INT_STATUS_REG);
+
+	if (status & RCAR_PCI_INT_ALLERRORS) {
+		dev_err(priv->dev, "error irq: status %08x\n", status);
+
+		/* clear the error(s) */
+		iowrite32(status & RCAR_PCI_INT_ALLERRORS,
+			  priv->reg + RCAR_PCI_INT_STATUS_REG);
+		return IRQ_HANDLED;
+	}
+
+	return IRQ_NONE;
+}
+
+static void rcar_pci_setup_errirq(struct rcar_pci_priv *priv)
+{
+	int ret;
+	u32 val;
+
+	ret = devm_request_irq(priv->dev, priv->irq, rcar_pci_err_irq,
+			       IRQF_SHARED, "error irq", priv);
+	if (ret) {
+		dev_err(priv->dev, "cannot claim IRQ for error handling\n");
+		return;
+	}
+
+	val = ioread32(priv->reg + RCAR_PCI_INT_ENABLE_REG);
+	val |= RCAR_PCI_INT_ALLERRORS;
+	iowrite32(val, priv->reg + RCAR_PCI_INT_ENABLE_REG);
+}
+#else
+static inline void rcar_pci_setup_errirq(struct rcar_pci_priv *priv) { }
+#endif
+
 /* PCI host controller setup */
 static int __init rcar_pci_setup(int nr, struct pci_sys_data *sys)
 {
@@ -224,6 +281,9 @@ static int __init rcar_pci_setup(int nr,
 	iowrite32(RCAR_PCI_INT_A | RCAR_PCI_INT_B | RCAR_PCI_INT_PME,
 		  reg + RCAR_PCI_INT_ENABLE_REG);
 
+	if (priv->irq > 0)
+		rcar_pci_setup_errirq(priv);
+
 	/* Add PCI resources */
 	pci_add_resource(&sys->resources, &priv->io_res);
 	pci_add_resource(&sys->resources, &priv->mem_res);
