Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079Ab3AUKJu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jan 2013 05:09:50 -0500
Received: from moutng.kundenserver.de ([212.227.126.171]:60616 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752978Ab3AUKJo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jan 2013 05:09:44 -0500
From: Thierry Reding <thierry.reding@avionic-design.de>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Arnd Bergmann <arnd@arndb.de>, Wolfram Sang <w.sang@pengutronix.de>,
        Joerg Roedel <joro@8bytes.org>, iommu@lists.linux-foundation.org
Subject: [PATCH 13/33] iommu: Convert to devm_ioremap_resource()
Date: Mon, 21 Jan 2013 11:09:06 +0100
Message-Id: <1358762966-20791-14-git-send-email-thierry.reding@avionic-design.de>
X-Mailer: git-send-email 1.8.1.1
In-Reply-To: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
References: <1358762966-20791-1-git-send-email-thierry.reding@avionic-design.de>
X-Provags-ID: V02:K0:dXRSUYLK18qJzD88KMcDR/q1YEIX6sXZUFIg8NBtzyU
 HnNQwXQA81OvbYQ1q+nxcpfnNY/lkRVkys329KfexsD4VJ/OIe
 4wDY7VBUgj5lhTGTn5hvmtEg4bY2z1PKtAV9JJqjqU1kGQte2Q
 h4wawwnH0bDp5Fwdq9y1FVClN3h83EpWFgAlK1qK9ixlf0y9Zp
 qUw4cwb02mug7B+LuXajlTqVlUOX76igUJbQInB1kRAQxkcAcm
 jYOcOeeZOpzbpxhUUQQL5RZSiFEFbXs83JKwjGSkEp8cziOuxb
 tBepSYVYl6mf1uielzEMq+7r5eqhBjPNyB17h9SSzR7tfV63tK
 Gh3OKeYAV2kUS64pc3zzzfdnl+DqHcZi8t5Y2OGoEa83eMRPD2
 d78FONOG1Pvxu1DDPR74/EBFPIOYvSQeT635K1TiJEkScH0CrI
 Yhi44
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Convert all uses of devm_request_and_ioremap() to the newly introduced
devm_ioremap_resource() which provides more consistent error handling.

devm_ioremap_resource() provides its own error messages so all explicit
error messages can be removed from the failure code paths.

Signed-off-by: Thierry Reding <thierry.reding@avionic-design.de>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: iommu@lists.linux-foundation.org
---
 drivers/iommu/tegra-smmu.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/iommu/tegra-smmu.c b/drivers/iommu/tegra-smmu.c
index fc17889..f08dbcd 100644
--- a/drivers/iommu/tegra-smmu.c
+++ b/drivers/iommu/tegra-smmu.c
@@ -19,6 +19,7 @@
 
 #define pr_fmt(fmt)	"%s(): " fmt, __func__
 
+#include <linux/err.h>
 #include <linux/module.h>
 #include <linux/platform_device.h>
 #include <linux/spinlock.h>
@@ -1176,9 +1177,9 @@ static int tegra_smmu_probe(struct platform_device *pdev)
 		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
 		if (!res)
 			return -ENODEV;
-		smmu->regs[i] = devm_request_and_ioremap(&pdev->dev, res);
-		if (!smmu->regs[i])
-			return -EBUSY;
+		smmu->regs[i] = devm_ioremap_resource(&pdev->dev, res);
+		if (IS_ERR(smmu->regs[i]))
+			return PTR_ERR(smmu->regs[i]);
 	}
 
 	err = of_get_dma_window(dev->of_node, NULL, 0, NULL, &base, &size);
-- 
1.8.1.1

