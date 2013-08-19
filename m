Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751375Ab3HSLVD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:21:03 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:1124 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751289Ab3HSLVA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:21:00 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24233027"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Thierry Reding <thierry.reding@gmail.com>
Cc: kernel-janitors@vger.kernel.org, Bjorn Helgaas <bhelgaas@google.com>,
        Stephen Warren <swarren@wwwdotorg.org>, linux-tegra@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 1/7] PCI: tegra: replace devm_request_and_ioremap by devm_ioremap_resource
Date: Mon, 19 Aug 2013 13:20:35 +0200
Message-Id: <1376911241-27720-2-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use devm_ioremap_resource instead of devm_request_and_ioremap.

This was done using the semantic patch
scripts/coccinelle/api/devm_ioremap_resource.cocci

Error-handling code was manually removed from the associated calls to
platform_get_resource.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
The first block of modified code is followed by a call to
devm_request_mem_region for pcie->cs with no associated ioremap.  Should
ioremap be used in this case as well?

 drivers/pci/host/pci-tegra.c |   29 +++++++++--------------------
 1 file changed, 9 insertions(+), 20 deletions(-)

diff --git a/drivers/pci/host/pci-tegra.c b/drivers/pci/host/pci-tegra.c
index 7356741..db2ddc5 100644
--- a/drivers/pci/host/pci-tegra.c
+++ b/drivers/pci/host/pci-tegra.c
@@ -1031,28 +1031,17 @@ static int tegra_pcie_get_resources(struct tegra_pcie *pcie)
 		return err;
 	}
 
-	/* request and remap controller registers */
 	pads = platform_get_resource_byname(pdev, IORESOURCE_MEM, "pads");
-	if (!pads) {
-		err = -EADDRNOTAVAIL;
+	pcie->pads = devm_ioremap_resource(&pdev->dev, pads);
+	if (IS_ERR(pcie->pads)) {
+		err = PTR_ERR(pcie->pads);
 		goto poweroff;
 	}
 
 	afi = platform_get_resource_byname(pdev, IORESOURCE_MEM, "afi");
-	if (!afi) {
-		err = -EADDRNOTAVAIL;
-		goto poweroff;
-	}
-
-	pcie->pads = devm_request_and_ioremap(&pdev->dev, pads);
-	if (!pcie->pads) {
-		err = -EADDRNOTAVAIL;
-		goto poweroff;
-	}
-
-	pcie->afi = devm_request_and_ioremap(&pdev->dev, afi);
-	if (!pcie->afi) {
-		err = -EADDRNOTAVAIL;
+	pcie->afi = devm_ioremap_resource(&pdev->dev, afi);
+	if (IS_ERR(pcie->afi)) {
+		err = PTR_ERR(pcie->afi);
 		goto poweroff;
 	}
 
@@ -1492,9 +1481,9 @@ static int tegra_pcie_parse_dt(struct tegra_pcie *pcie)
 		rp->lanes = value;
 		rp->pcie = pcie;
 
-		rp->base = devm_request_and_ioremap(pcie->dev, &rp->regs);
-		if (!rp->base)
-			return -EADDRNOTAVAIL;
+		rp->base = devm_ioremap_resource(pcie->dev, &rp->regs);
+		if (IS_ERR(rp->base))
+			return PTR_ERR(rp->base);
 
 		list_add_tail(&rp->list, &pcie->ports);
 	}

