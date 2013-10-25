Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751218Ab3JYF1r (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Oct 2013 01:27:47 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:40941 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750861Ab3JYF1q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Oct 2013 01:27:46 -0400
From: Sachin Kamat <sachin.kamat@linaro.org>
To: linux-kernel@vger.kernel.org
Cc: kishon@ti.com, sachin.kamat@linaro.org
Subject: [PATCH 1/1] drivers: phy: Fix memory leak
Date: Fri, 25 Oct 2013 10:56:24 +0530
Message-Id: <1382678784-20191-1-git-send-email-sachin.kamat@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

'phy' was not being freed upon error in one of the cases.
Adjust the 'goto's to fix this.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
---
 drivers/phy/phy-core.c |   10 +++++-----
 1 file changed, 5 insertions(+), 5 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb..712b358 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -453,7 +453,7 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 	if (id < 0) {
 		dev_err(dev, "unable to get id\n");
 		ret = id;
-		goto err0;
+		goto err1;
 	}
 
 	device_initialize(&phy->dev);
@@ -468,11 +468,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 
 	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
 	if (ret)
-		goto err1;
+		goto err2;
 
 	ret = device_add(&phy->dev);
 	if (ret)
-		goto err1;
+		goto err2;
 
 	if (pm_runtime_enabled(dev)) {
 		pm_runtime_enable(&phy->dev);
@@ -481,11 +481,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 
 	return phy;
 
-err1:
+err2:
 	ida_remove(&phy_ida, phy->id);
 	put_device(&phy->dev);
+err1:
 	kfree(phy);
-
 err0:
 	return ERR_PTR(ret);
 }
-- 
1.7.9.5

