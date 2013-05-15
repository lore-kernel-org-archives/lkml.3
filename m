Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754535Ab3EOErT (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 May 2013 00:47:19 -0400
Received: from szxga01-in.huawei.com ([119.145.14.64]:41712 "EHLO
	szxga01-in.huawei.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751108Ab3EOErS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 May 2013 00:47:18 -0400
Message-ID: <51931347.7020600@huawei.com>
Date: Wed, 15 May 2013 12:47:03 +0800
From: Libo Chen <clbchenlibo.chen@huawei.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; rv:17.0) Gecko/20130328 Thunderbird/17.0.5
MIME-Version: 1.0
To: Andrew Morton <akpm@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] msm: iommu: fix leak and invalid access
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.135.72.158]
X-CFilter-Loop: Reflected
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


This patch merge two patch that I sended before:
1. msm: iommu: add missing platform_device_unregister() in err case
2. msm: iommu: no need kfree before kzalloc successful

It fixes two obvious problems:
1. We have registered msm_iommu_driver first, and need unregister it when
registered msm_iommu_ctx_driver fail

2. We don`t need to kfree drvdata before kzalloc successful

Signed-off-by: Libo Chen <libo.chen@huawei.com>
---
 drivers/iommu/msm_iommu_dev.c |   11 +++++------
 1 files changed, 5 insertions(+), 6 deletions(-)

diff --git a/drivers/iommu/msm_iommu_dev.c b/drivers/iommu/msm_iommu_dev.c
index 8e8fb07..bae0b23 100644
--- a/drivers/iommu/msm_iommu_dev.c
+++ b/drivers/iommu/msm_iommu_dev.c
@@ -292,22 +292,20 @@ static int msm_iommu_ctx_probe(struct platform_device *pdev)
 	struct msm_iommu_ctx_drvdata *ctx_drvdata = NULL;
 	int i, ret;
 	if (!c || !pdev->dev.parent) {
-		ret = -EINVAL;
-		goto fail;
+		return -EINVAL;
 	}

 	drvdata = dev_get_drvdata(pdev->dev.parent);

 	if (!drvdata) {
-		ret = -ENODEV;
-		goto fail;
+		return -ENODEV;
 	}

 	ctx_drvdata = kzalloc(sizeof(*ctx_drvdata), GFP_KERNEL);
 	if (!ctx_drvdata) {
-		ret = -ENOMEM;
-		goto fail;
+		return -ENOMEM;
 	}
+
 	ctx_drvdata->num = c->num;
 	ctx_drvdata->pdev = pdev;

@@ -401,6 +399,7 @@ static int __init msm_iommu_driver_init(void)

 	ret = platform_driver_register(&msm_iommu_ctx_driver);
 	if (ret != 0) {
+		platform_driver_unregister(&msm_iommu_driver);
 		pr_err("Failed to register IOMMU context driver\n");
 		goto error;
 	}
-- 
1.7.1


