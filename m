Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161020Ab3LFMVi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 07:21:38 -0500
Received: from comal.ext.ti.com ([198.47.26.152]:46447 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757569Ab3LFMV1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 07:21:27 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <gregkh@linuxfoundation.org>, <linux-kernel@vger.kernel.org>
CC: <kishon@ti.com>, Sachin Kamat <sachin.kamat@linaro.org>
Subject: [PATCH 1/3] drivers: phy: Fix memory leak
Date: Fri, 6 Dec 2013 17:51:18 +0530
Message-ID: <1386332480-31671-2-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386332480-31671-1-git-send-email-kishon@ti.com>
References: <1386332480-31671-1-git-send-email-kishon@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Sachin Kamat <sachin.kamat@linaro.org>

'phy' was not being freed upon error in one of the cases.
Adjust the 'goto's to fix this.

Signed-off-by: Sachin Kamat <sachin.kamat@linaro.org>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
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
1.7.10.4

