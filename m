Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751550Ab3HSLXg (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 07:23:36 -0400
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:1124 "EHLO
	mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751296Ab3HSLVB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 07:21:01 -0400
X-IronPort-AV: E=Sophos;i="4.89,913,1367964000"; 
   d="scan'208";a="24233029"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Will Deacon <will.deacon@arm.com>
Cc: kernel-janitors@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 3/7] iommu/arm: replace devm_request_and_ioremap by devm_ioremap_resource
Date: Mon, 19 Aug 2013 13:20:37 +0200
Message-Id: <1376911241-27720-4-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.7.8.6
In-Reply-To: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1376911241-27720-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Julia Lawall <Julia.Lawall@lip6.fr>

Use devm_ioremap_resource instead of devm_request_and_ioremap.

This was partly done using the semantic patch
scripts/coccinelle/api/devm_ioremap_resource.cocci

The error-handling code on the call to platform_get_resource was removed
manually, and the initialization of smmu->size was manually moved lower, to
take advantage of the NULL test on res performed by devm_ioremap_resource.

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/iommu/arm-smmu.c |   11 +++--------
 1 file changed, 3 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/arm-smmu.c b/drivers/iommu/arm-smmu.c
index ebd0a4c..dd91465 100644
--- a/drivers/iommu/arm-smmu.c
+++ b/drivers/iommu/arm-smmu.c
@@ -1761,15 +1761,10 @@ static int arm_smmu_device_dt_probe(struct platform_device *pdev)
 	smmu->dev = dev;
 
 	res = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!res) {
-		dev_err(dev, "missing base address/size\n");
-		return -ENODEV;
-	}
-
+	smmu->base = devm_ioremap_resource(dev, res);
+	if (IS_ERR(smmu->base))
+		return PTR_ERR(smmu->base);
 	smmu->size = resource_size(res);
-	smmu->base = devm_request_and_ioremap(dev, res);
-	if (!smmu->base)
-		return -EADDRNOTAVAIL;
 
 	if (of_property_read_u32(dev->of_node, "#global-interrupts",
 				 &smmu->num_global_irqs)) {

