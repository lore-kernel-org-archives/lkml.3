Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753294Ab3IWPV7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:21:59 -0400
Received: from mail1.bemta14.messagelabs.com ([193.109.254.106]:54328 "EHLO
	mail1.bemta14.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753129Ab3IWPVz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:21:55 -0400
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-9.tower-193.messagelabs.com!1379949711!13854659!3
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.12; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Mon, 23 Sep 2013 17:21:52 +0200
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <linux-edac@vger.kernel.org>
CC: Borislav Petkov <bp@alien8.de>, Dave Jiang <dave.jiang@gmail.com>,
        Doug Thompson <dougthompson@xmission.com>,
        Chunhe Lan <Chunhe.Lan@freescale.com>, <linux-kernel@vger.kernel.org>,
        Johannes Thumshirn <johannes.thumshirn@men.de>
Subject: [PATCH 2/3] edac/85xx: Add PCIe error interrupt edac support
Date: Mon, 23 Sep 2013 17:23:28 +0200
Message-ID: <1379949809-11083-3-git-send-email-johannes.thumshirn@men.de>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1379949809-11083-1-git-send-email-johannes.thumshirn@men.de>
References: <1379949809-11083-1-git-send-email-johannes.thumshirn@men.de>
MIME-Version: 1.0
Content-Type: text/plain
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 23 Sep 2013 15:21:52.0474 (UTC) FILETIME=[A1717BA0:01CEB870]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Chunhe Lan <Chunhe.Lan@freescale.com>

Adding pcie error interrupt edac support for mpc85xx, p3041, p4080,
and p5020. The mpc85xx uses the legacy interrupt report mechanism -
the error interrupts are reported directly to mpic. While, the p3041/
p4080/p5020 attaches the most of error interrupts to interrupt zero.
And report error interrupts to mpic via interrupt 0.

This patch can handle both of them.

Signed-off-by: Chunhe Lan <Chunhe.Lan@freescale.com>
Cc: Doug Thompson <dougthompson@xmission.com>
Cc: Dave Jiang <dave.jiang@gmail.com>
Cc: Borislav Petkov <bp@alien8.de>
Signed-off-by: Johannes Thumshirn <johannes.thumshirn@men.de>
---
 drivers/edac/mpc85xx_edac.c |   98 ++++++++++++++++++++++++++++++++++++++-----
 drivers/edac/mpc85xx_edac.h |    7 ++++
 2 files changed, 94 insertions(+), 11 deletions(-)

diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 3eb32f6..8df5f4d 100644
--- a/drivers/edac/mpc85xx_edac.c
+++ b/drivers/edac/mpc85xx_edac.c
@@ -1,6 +1,8 @@
 /*
  * Freescale MPC85xx Memory Controller kenel module
  *
+ * Parts Copyrighted (c) 2013 by Freescale Semiconductor, Inc.
+ *
  * Author: Dave Jiang <djiang@mvista.com>
  *
  * 2006-2007 (c) MontaVista Software, Inc. This file is licensed under
@@ -196,6 +198,42 @@ static void mpc85xx_pci_check(struct edac_pci_ctl_info *pci)
 		edac_pci_handle_npe(pci, pci->ctl_name);
 }
 
+static void mpc85xx_pcie_check(struct edac_pci_ctl_info *pci)
+{
+	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
+	u32 err_detect;
+
+	err_detect = in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR);
+
+	pr_err("PCIe error(s) detected\n");
+	pr_err("PCIe ERR_DR register: 0x%08x\n", err_detect);
+	pr_err("PCIe ERR_CAP_STAT register: 0x%08x\n",
+			in_be32(pdata->pci_vbase + MPC85XX_PCI_GAS_TIMR));
+	pr_err("PCIe ERR_CAP_R0 register: 0x%08x\n",
+			in_be32(pdata->pci_vbase + MPC85XX_PCIE_ERR_CAP_R0));
+	pr_err("PCIe ERR_CAP_R1 register: 0x%08x\n",
+			in_be32(pdata->pci_vbase + MPC85XX_PCIE_ERR_CAP_R1));
+	pr_err("PCIe ERR_CAP_R2 register: 0x%08x\n",
+			in_be32(pdata->pci_vbase + MPC85XX_PCIE_ERR_CAP_R2));
+	pr_err("PCIe ERR_CAP_R3 register: 0x%08x\n",
+			in_be32(pdata->pci_vbase + MPC85XX_PCIE_ERR_CAP_R3));
+
+	/* clear error bits */
+	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR, err_detect);
+}
+
+static int mpc85xx_pcie_find_capability(struct device_node *np)
+{
+	struct pci_controller *hose;
+
+	if (!np)
+		return -EINVAL;
+
+	hose = pci_find_hose_for_OF_device(np);
+
+	return early_find_capability(hose, 0, 0, PCI_CAP_ID_EXP);
+}
+
 static irqreturn_t mpc85xx_pci_isr(int irq, void *dev_id)
 {
 	struct edac_pci_ctl_info *pci = dev_id;
@@ -207,7 +245,10 @@ static irqreturn_t mpc85xx_pci_isr(int irq, void *dev_id)
 	if (!err_detect)
 		return IRQ_NONE;
 
-	mpc85xx_pci_check(pci);
+	if (pdata->is_pcie)
+		mpc85xx_pcie_check(pci);
+	else
+		mpc85xx_pci_check(pci);
 
 	return IRQ_HANDLED;
 }
@@ -239,14 +280,22 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
 	pdata = pci->pvt_info;
 	pdata->name = "mpc85xx_pci_err";
 	pdata->irq = NO_IRQ;
+
+	if (mpc85xx_pcie_find_capability(op->dev.of_node) > 0)
+		pdata->is_pcie = true;
+
 	dev_set_drvdata(&op->dev, pci);
 	pci->dev = &op->dev;
 	pci->mod_name = EDAC_MOD_STR;
 	pci->ctl_name = pdata->name;
 	pci->dev_name = dev_name(&op->dev);
 
-	if (edac_op_state == EDAC_OPSTATE_POLL)
-		pci->edac_check = mpc85xx_pci_check;
+	if (edac_op_state == EDAC_OPSTATE_POLL) {
+		if (pdata->is_pcie)
+			pci->edac_check = mpc85xx_pcie_check;
+		else
+			pci->edac_check = mpc85xx_pci_check;
+	}
 
 	pdata->edac_idx = edac_pci_idx++;
 
@@ -275,16 +324,26 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
 		goto err;
 	}
 
-	orig_pci_err_cap_dr =
-	    in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR);
+	if (pdata->is_pcie) {
+		orig_pci_err_cap_dr =
+		    in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_ADDR);
+		out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_ADDR, ~0);
+		orig_pci_err_en =
+		    in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN);
+		out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, 0);
+	} else {
+		orig_pci_err_cap_dr =
+		    in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR);
 
-	/* PCI master abort is expected during config cycles */
-	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR, 0x40);
+		/* PCI master abort is expected during config cycles */
+		out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR, 0x40);
 
-	orig_pci_err_en = in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN);
+		orig_pci_err_en =
+		    in_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN);
 
-	/* disable master abort reporting */
-	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, ~0x40);
+		/* disable master abort reporting */
+		out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, ~0x40);
+	}
 
 	/* clear error bits */
 	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_DR, ~0);
@@ -297,7 +356,8 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
 	if (edac_op_state == EDAC_OPSTATE_INT) {
 		pdata->irq = irq_of_parse_and_map(op->dev.of_node, 0);
 		res = devm_request_irq(&op->dev, pdata->irq,
-				       mpc85xx_pci_isr, IRQF_DISABLED,
+				       mpc85xx_pci_isr,
+				       IRQF_DISABLED | IRQF_SHARED,
 				       "[EDAC] PCI err", pci);
 		if (res < 0) {
 			printk(KERN_ERR
@@ -312,6 +372,22 @@ int mpc85xx_pci_err_probe(struct platform_device *op)
 		       pdata->irq);
 	}
 
+	if (pdata->is_pcie) {
+		/*
+		 * Enable all PCIe error interrupt & error detect except invalid
+		 * PEX_CONFIG_ADDR/PEX_CONFIG_DATA access interrupt generation
+		 * enable bit and invalid PEX_CONFIG_ADDR/PEX_CONFIG_DATA access
+		 * detection enable bit. Because PCIe bus code to initialize and
+		 * configure these PCIe devices on booting will use some invalid
+		 * PEX_CONFIG_ADDR/PEX_CONFIG_DATA, edac driver prints the much
+		 * notice information. So disable this detect to fix ugly print.
+		 */
+		out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, ~0
+			 & ~PEX_ERR_ICCAIE_EN_BIT);
+		out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_ADDR, 0
+			 | PEX_ERR_ICCAD_DISR_BIT);
+	}
+
 	devres_remove_group(&op->dev, mpc85xx_pci_err_probe);
 	edac_dbg(3, "success\n");
 	printk(KERN_INFO EDAC_MOD_STR " PCI err registered\n");
diff --git a/drivers/edac/mpc85xx_edac.h b/drivers/edac/mpc85xx_edac.h
index 932016f..8c62564 100644
--- a/drivers/edac/mpc85xx_edac.h
+++ b/drivers/edac/mpc85xx_edac.h
@@ -134,13 +134,19 @@
 #define MPC85XX_PCI_ERR_DR		0x0000
 #define MPC85XX_PCI_ERR_CAP_DR		0x0004
 #define MPC85XX_PCI_ERR_EN		0x0008
+#define   PEX_ERR_ICCAIE_EN_BIT		0x00020000
 #define MPC85XX_PCI_ERR_ATTRIB		0x000c
 #define MPC85XX_PCI_ERR_ADDR		0x0010
+#define   PEX_ERR_ICCAD_DISR_BIT	0x00020000
 #define MPC85XX_PCI_ERR_EXT_ADDR	0x0014
 #define MPC85XX_PCI_ERR_DL		0x0018
 #define MPC85XX_PCI_ERR_DH		0x001c
 #define MPC85XX_PCI_GAS_TIMR		0x0020
 #define MPC85XX_PCI_PCIX_TIMR		0x0024
+#define MPC85XX_PCIE_ERR_CAP_R0		0x0028
+#define MPC85XX_PCIE_ERR_CAP_R1		0x002c
+#define MPC85XX_PCIE_ERR_CAP_R2		0x0030
+#define MPC85XX_PCIE_ERR_CAP_R3		0x0034
 
 struct mpc85xx_mc_pdata {
 	char *name;
@@ -158,6 +164,7 @@ struct mpc85xx_l2_pdata {
 
 struct mpc85xx_pci_pdata {
 	char *name;
+	bool is_pcie;
 	int edac_idx;
 	void __iomem *pci_vbase;
 	int irq;
-- 
1.7.9.5

