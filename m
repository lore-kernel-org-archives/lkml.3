Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754204Ab3HPWQs (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 Aug 2013 18:16:48 -0400
Received: from mail-bk0-f48.google.com ([209.85.214.48]:44392 "EHLO
	mail-bk0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752010Ab3HPWQq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 Aug 2013 18:16:46 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: Grant Likely <grant.likely@linaro.org>
Cc: Rob Herring <rob.herring@calxeda.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Stephen Warren <swarren@wwwdotorg.org>,
        Hiroshi Doyu <hdoyu@nvidia.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Sebastian Hesselbarth <sebastian.hesselbarth@gmail.com>,
        devicetree@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [RFC 4/4] OF: Add device pointer to struct device_node
Date: Fri, 16 Aug 2013 22:39:23 +0200
Message-Id: <1376685563-1053-5-git-send-email-treding@nvidia.com>
X-Mailer: git-send-email 1.8.3.4
In-Reply-To: <1376685563-1053-1-git-send-email-treding@nvidia.com>
References: <1376685563-1053-1-git-send-email-treding@nvidia.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/of/device.c   |  2 ++
 drivers/of/platform.c | 10 +---------
 include/linux/of.h    |  2 ++
 3 files changed, 5 insertions(+), 9 deletions(-)

diff --git a/drivers/of/device.c b/drivers/of/device.c
index f685e55..8f8e715 100644
--- a/drivers/of/device.c
+++ b/drivers/of/device.c
@@ -63,6 +63,8 @@ int of_device_add(struct platform_device *ofdev)
 	if (!ofdev->dev.parent)
 		set_dev_node(&ofdev->dev, of_node_to_nid(ofdev->dev.of_node));
 
+	ofdev->dev.of_node->dev = &ofdev->dev;
+
 	return device_add(&ofdev->dev);
 }
 
diff --git a/drivers/of/platform.c b/drivers/of/platform.c
index b0d1ff8..0ae68bd 100644
--- a/drivers/of/platform.c
+++ b/drivers/of/platform.c
@@ -31,11 +31,6 @@ const struct of_device_id of_default_bus_match_table[] = {
 	{} /* Empty terminated list */
 };
 
-static int of_dev_node_match(struct device *dev, void *data)
-{
-	return dev->of_node == data;
-}
-
 /**
  * of_find_device_by_node - Find the platform_device associated with a node
  * @np: Pointer to device tree node
@@ -44,10 +39,7 @@ static int of_dev_node_match(struct device *dev, void *data)
  */
 struct platform_device *of_find_device_by_node(struct device_node *np)
 {
-	struct device *dev;
-
-	dev = bus_find_device(&platform_bus_type, NULL, np, of_dev_node_match);
-	return dev ? to_platform_device(dev) : NULL;
+	return np->dev ? to_platform_device(np->dev) : NULL;
 }
 EXPORT_SYMBOL(of_find_device_by_node);
 
diff --git a/include/linux/of.h b/include/linux/of.h
index 17ce8a6..e583a6d 100644
--- a/include/linux/of.h
+++ b/include/linux/of.h
@@ -65,6 +65,8 @@ struct device_node {
 	unsigned int unique_id;
 	struct of_irq_controller *irq_trans;
 #endif
+
+	struct device *dev;
 };
 
 #define MAX_PHANDLE_ARGS 8
-- 
1.8.3.4

