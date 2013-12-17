Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753918Ab3LQNCQ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 08:02:16 -0500
Received: from smtp5.epfl.ch ([128.178.224.8]:50574 "EHLO smtp5.epfl.ch"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753598Ab3LQNAy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 08:00:54 -0500
From: Florian Vaussard <florian.vaussard@epfl.ch>
To: Joerg Roedel <joro@8bytes.org>, Tony Lindgren <tony@atomide.com>,
        =?UTF-8?q?Beno=C3=AEt=20Cousson?= <bcousson@baylibre.com>
Cc: Rob Herring <rob.herring@calxeda.com>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Rob Landley <rob@landley.net>,
        Grant Likely <grant.likely@linaro.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Florian Vaussard <florian.vaussard@epfl.ch>,
        iommu@lists.linux-foundation.org, devicetree@vger.kernel.org,
        linux-doc@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-omap@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Subject: [PATCH 4/7] iommu/omap: Allow enable/disable even without pdata
Date: Tue, 17 Dec 2013 13:53:35 +0100
Message-Id: <1387284818-28739-5-git-send-email-florian.vaussard@epfl.ch>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
References: <1387284818-28739-1-git-send-email-florian.vaussard@epfl.ch>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When booting with a devietree, no platform data is provided. Do not prematurely
exit iommu_enable() and iommu_disable() in such a case.

Signed-off-by: Florian Vaussard <florian.vaussard@epfl.ch>
---
 drivers/iommu/omap-iommu.c | 10 ++--------
 1 file changed, 2 insertions(+), 8 deletions(-)

diff --git a/drivers/iommu/omap-iommu.c b/drivers/iommu/omap-iommu.c
index 51efcc4..0a9854d 100644
--- a/drivers/iommu/omap-iommu.c
+++ b/drivers/iommu/omap-iommu.c
@@ -149,13 +149,10 @@ static int iommu_enable(struct omap_iommu *obj)
 	struct platform_device *pdev = to_platform_device(obj->dev);
 	struct iommu_platform_data *pdata = pdev->dev.platform_data;
 
-	if (!pdata)
-		return -EINVAL;
-
 	if (!arch_iommu)
 		return -ENODEV;
 
-	if (pdata->deassert_reset) {
+	if (pdata && pdata->deassert_reset) {
 		err = pdata->deassert_reset(pdev, pdata->reset_name);
 		if (err) {
 			dev_err(obj->dev, "deassert_reset failed: %d\n", err);
@@ -175,14 +172,11 @@ static void iommu_disable(struct omap_iommu *obj)
 	struct platform_device *pdev = to_platform_device(obj->dev);
 	struct iommu_platform_data *pdata = pdev->dev.platform_data;
 
-	if (!pdata)
-		return;
-
 	arch_iommu->disable(obj);
 
 	pm_runtime_put_sync(obj->dev);
 
-	if (pdata->assert_reset)
+	if (pdata && pdata->assert_reset)
 		pdata->assert_reset(pdev, pdata->reset_name);
 }
 
-- 
1.8.1.2

