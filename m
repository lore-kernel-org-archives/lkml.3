Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753574AbaIHJTy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 8 Sep 2014 05:19:54 -0400
Received: from asavent2.altibox.net ([109.247.116.19]:39289 "EHLO
	asavent2.altibox.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753397AbaIHJTx convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 8 Sep 2014 05:19:53 -0400
X-Greylist: delayed 550 seconds by postgrey-1.27 at vger.kernel.org; Mon, 08 Sep 2014 05:19:52 EDT
From: Raymond van der Rots <raymond@electrocompaniet.no>
Content-Type: text/plain; charset=us-ascii
Content-Transfer-Encoding: 8BIT
Subject: [PATCH] imx6 PCI Host initialisation order
Date: Mon, 8 Sep 2014 11:10:37 +0200
Message-Id: <BD2B99C7-743D-429F-801E-FCFAFAE4A7DB@electrocompaniet.no>
Cc: linux-kernel@vger.kernel.org
To: r65037@freescale.com, shawn.guo@freescale.com
Mime-Version: 1.0 (Mac OS X Mail 7.3 \(1878.6\))
X-Mailer: Apple Mail (2.1878.6)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

The imx6dl on our hardware board frequently had problems bringing up the PCI link, with or without peripherals connected. I found these issues to be due to the initialisation order of the PCI Host.

The host driver first enables the phy, and then enables its clocks. However, according to the reference manual (IMX6SDLRM, page 2033):
> The phy_ref_ssp_en signal must remain deasserted until the reference clock is running at the appropriate frequency, at which point phy_ref_ssp_en can be asserted.


Which implies that the clocks should be brought up first, after which the peripheral should be enabled.
This patch changes that initialisation order.

I do not have other hardware with an imx6dl, so this patch has only been tested on our board. Could someone confirm that this is more technically correct or improves behaviour?

Signed-off-by: Raymond van der Rots <raymond@electrocompaniet.no>
---
diff --git a/drivers/pci/host/pci-imx6.c b/drivers/pci/host/pci-imx6.c
index a568efa..17c35b4 100644
--- a/drivers/pci/host/pci-imx6.c
+++ b/drivers/pci/host/pci-imx6.c
@@ -228,11 +228,6 @@ static int imx6_pcie_deassert_core_reset(struct pcie_port *pp)
 	struct imx6_pcie *imx6_pcie = to_imx6_pcie(pp);
 	int ret;
 
-	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
-			IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
-	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
-			IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
-
 	ret = clk_prepare_enable(imx6_pcie->pcie_phy);
 	if (ret) {
 		dev_err(pp->dev, "unable to enable pcie_phy clock\n");
@@ -254,6 +249,11 @@ static int imx6_pcie_deassert_core_reset(struct pcie_port *pp)
 	/* allow the clocks to stabilize */
 	usleep_range(200, 500);
 
+	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
+			IMX6Q_GPR1_PCIE_TEST_PD, 0 << 18);
+	regmap_update_bits(imx6_pcie->iomuxc_gpr, IOMUXC_GPR1,
+			IMX6Q_GPR1_PCIE_REF_CLK_EN, 1 << 16);
+
 	/* Some boards don't have PCIe reset GPIO. */
 	if (gpio_is_valid(imx6_pcie->reset_gpio)) {
 		gpio_set_value(imx6_pcie->reset_gpio, 0);


