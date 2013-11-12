Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932091Ab3KLQTf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 11:19:35 -0500
Received: from mail1.bemta3.messagelabs.com ([195.245.230.165]:46077 "EHLO
	mail1.bemta3.messagelabs.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752482Ab3KLQTd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 11:19:33 -0500
X-Env-Sender: Johannes.Thumshirn@men.de
X-Msg-Ref: server-8.tower-38.messagelabs.com!1384273156!8997236!1
X-Originating-IP: [80.255.6.145]
X-StarScan-Received: 
X-StarScan-Version: 6.9.13; banners=-,-,-
X-VirusChecked: Checked
X-PGP-Universal: processed;
	by keys.men.de on Tue, 12 Nov 2013 17:19:16 +0100
Date: Tue, 12 Nov 2013 17:19:09 +0100
From: Johannes Thumshirn <johannes.thumshirn@men.de>
To: <torvalds@linux-foundation.org>
CC: <linux-kernel@vger.kernel.org>, <linux-edac@vger.kernel.org>
Subject: [GIT PULL] mpc85xx_edac changes for 3.13
Message-ID: <20131112161901.GA15637@jtlinux>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
X-Originating-IP: [192.1.1.31]
X-OriginalArrivalTime: 12 Nov 2013 16:19:15.0838 (UTC) FILETIME=[EE80A1E0:01CEDFC2]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

Please pull these changes for mpc85xx_edac. They have been around on linux-edac
for a while.

Thanks.

--
The following changes since commit 10d0c9705e80bbd3d587c5fad24599aabaca6688:

  Merge tag 'devicetree-for-3.13' of git://git.kernel.org/pub/scm/linux/kernel/git/robh/linux (2013-11-12 16:52:17 +0900)

are available in the git repository at:


  git://github.com/morbidrsa/linux.git tags/mpc85xx-edac-for-3.13

for you to fetch changes up to 43b5acb650587ec6495c2e3b8c2e30311e9dc8cf:

  edac/85xx: Remove mpc85xx_pci_err_remove (2013-11-12 17:06:16 +0100)

----------------------------------------------------------------
mpc85xx_edac for 3.13

----------------------------------------------------------------
Chunhe Lan (1):
      edac/85xx: Add PCIe error interrupt edac support

Johannes Thumshirn (2):
      MAINTAINERS: Add edac-mpc85xx driver to MAINTAINERS
      edac/85xx: Remove mpc85xx_pci_err_remove

 MAINTAINERS                 |   7 +++
 drivers/edac/mpc85xx_edac.c | 120 ++++++++++++++++++++++++++++++++------------
 drivers/edac/mpc85xx_edac.h |   7 +++
 3 files changed, 101 insertions(+), 33 deletions(-)

diff --git a/MAINTAINERS b/MAINTAINERS
index 051e4dc..3391279 100644
--- a/MAINTAINERS
+++ b/MAINTAINERS
@@ -3129,6 +3129,13 @@ W:	bluesmoke.sourceforge.net
 S:	Maintained
 F:	drivers/edac/i82975x_edac.c

+EDAC-MPC85XX
+M:	Johannes Thumshirn <johannes.thumshirn@men.de>
+L:	linux-edac@vger.kernel.org
+W:	bluesmoke.sourceforge.net
+S:	Maintained
+F:	drivers/edac/mpc85xx_edac.[ch]
+
 EDAC-PASEMI
 M:	Egor Martovetsky <egor@pasemi.com>
 L:	linux-edac@vger.kernel.org
diff --git a/drivers/edac/mpc85xx_edac.c b/drivers/edac/mpc85xx_edac.c
index 3eb32f6..8f91821 100644
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
@@ -327,28 +403,6 @@ err:
 }
 EXPORT_SYMBOL(mpc85xx_pci_err_probe);

-static int mpc85xx_pci_err_remove(struct platform_device *op)
-{
-	struct edac_pci_ctl_info *pci = dev_get_drvdata(&op->dev);
-	struct mpc85xx_pci_pdata *pdata = pci->pvt_info;
-
-	edac_dbg(0, "\n");
-
-	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_CAP_DR,
-		 orig_pci_err_cap_dr);
-
-	out_be32(pdata->pci_vbase + MPC85XX_PCI_ERR_EN, orig_pci_err_en);
-
-	edac_pci_del_device(pci->dev);
-
-	if (edac_op_state == EDAC_OPSTATE_INT)
-		irq_dispose_mapping(pdata->irq);
-
-	edac_pci_free_ctl_info(pci);
-
-	return 0;
-}
-
 #endif				/* CONFIG_PCI */

 /**************************** L2 Err device ***************************/
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
