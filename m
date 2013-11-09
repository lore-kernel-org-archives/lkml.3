Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752152Ab3KIF3M (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Nov 2013 00:29:12 -0500
Received: from top.free-electrons.com ([176.31.233.9]:58057 "EHLO
	mail.free-electrons.com" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751216Ab3KIF3L (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Nov 2013 00:29:11 -0500
From: Michael Opdenacker <michael.opdenacker@free-electrons.com>
To: kishon@ti.com
Cc: linux-kernel@vger.kernel.org,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>
Subject: [PATCH] drivers: phy: fix memory leak in error handling
Date: Sat,  9 Nov 2013 06:28:48 +0100
Message-Id: <1383974928-20730-1-git-send-email-michael.opdenacker@free-electrons.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This fixes a memory leak in the phy_create() function.

If ida_simple_get() returns with an error, the code jumps
to the "err0" label without freeing the "phy" pointer.

This patch introduces a new error management label to address this.

Issue found with Coverity (CID 1127219)

Signed-off-by: Michael Opdenacker <michael.opdenacker@free-electrons.com>
---
 drivers/phy/phy-core.c | 10 ++++++----
 1 file changed, 6 insertions(+), 4 deletions(-)

diff --git a/drivers/phy/phy-core.c b/drivers/phy/phy-core.c
index 03cf8fb81554..8ddffe84d905 100644
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
@@ -481,9 +481,11 @@ struct phy *phy_create(struct device *dev, const struct phy_ops *ops,
 
 	return phy;
 
-err1:
+err2:
 	ida_remove(&phy_ida, phy->id);
 	put_device(&phy->dev);
+
+err1:
 	kfree(phy);
 
 err0:
-- 
1.8.1.2

