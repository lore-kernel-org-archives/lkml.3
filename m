Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753194Ab3LBJEO (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 04:04:14 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:49722 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751170Ab3LBJEL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 04:04:11 -0500
From: Kishon Vijay Abraham I <kishon@ti.com>
To: <dan.carpenter@oracle.com>, <linux-kernel@vger.kernel.org>,
        <kishon@ti.com>
CC: <gregkh@linuxfoundation.org>, <kernel-janitors@vger.kernel.org>,
        <t.figa@samsung.com>, <balbi@ti.com>, <s.nawrocki@samsung.com>
Subject: [PATCH v2] drivers: phy: tweaks to phy_create()
Date: Mon, 2 Dec 2013 14:33:59 +0530
Message-ID: <1385975039-31835-1-git-send-email-kishon@ti.com>
X-Mailer: git-send-email 1.7.10.4
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dan Carpenter <dan.carpenter@oracle.com>

If this was called with a NULL "dev" then it lead to a NULL dereference
when we called dev_WARN().  I have changed it to WARN_ON() so that we
get a stack dump and can fix the caller.

The rest of this patch is just cleanup like returning directly instead
of having do-nothing gotos.  Using descriptive labels instead of
GW-BASIC style "err0" and "err1".  I also flipped the order of
put_device() and ida_remove() so they are a mirror reflection of the
order they were allocated.

Signed-off-by: Dan Carpenter <dan.carpenter@oracle.com>
Signed-off-by: Kishon Vijay Abraham I <kishon@ti.com>
---
Changes from v1:
rebased to git://git.kernel.org/pub/scm/linux/kernel/git/kishon/linux-phy.git fixes
since the original patch contains a fix which was already fixed.

 drivers/phy/phy-core.c |   26 ++++++++++----------------
 1 file changed, 10 insertions(+), 16 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 712b358..58e0e97 100644
--- a/drivers/phy/phy-core.c
+++ b/drivers/phy/phy-core.c
@@ -437,23 +437,18 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 	int id;
 	struct phy *phy;
 
-	if (!dev) {
-		dev_WARN(dev, "no device provided for PHY\n");
-		ret = -EINVAL;
-		goto err0;
-	}
+	if (WARN_ON(!dev))
+		return ERR_PTR(-EINVAL);
 
 	phy = kzalloc(sizeof(*phy), GFP_KERNEL);
-	if (!phy) {
-		ret = -ENOMEM;
-		goto err0;
-	}
+	if (!phy)
+		return ERR_PTR(-ENOMEM);
 
 	id = ida_simple_get(&phy_ida, 0, 0, GFP_KERNEL);
 	if (id < 0) {
 		dev_err(dev, "unable to get id\n");
 		ret = id;
-		goto err1;
+		goto free_phy;
 	}
 
 	device_initialize(&phy->dev);
@@ -468,11 +463,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 
 	ret = dev_set_name(&phy->dev, "phy-%s.%d", dev_name(dev), id);
 	if (ret)
-		goto err2;
+		goto put_dev;
 
 	ret = device_add(&phy->dev);
 	if (ret)
-		goto err2;
+		goto put_dev;
 
 	if (pm_runtime_enabled(dev)) {
 		pm_runtime_enable(&phy->dev);
@@ -481,12 +476,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 
 	return phy;
 
-err2:
-	ida_remove(&phy_ida, phy->id);
+put_dev:
 	put_device(&phy->dev);
-err1:
+	ida_remove(&phy_ida, phy->id);
+free_phy:
 	kfree(phy);
-err0:
 	return ERR_PTR(ret);
 }
 EXPORT_SYMBOL_GPL(phy_create);
-- 
1.7.10.4

