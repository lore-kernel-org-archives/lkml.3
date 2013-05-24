Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755518Ab3EXMx2 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 24 May 2013 08:53:28 -0400
Received: from service87.mimecast.com ([91.220.42.44]:42202 "EHLO
	service87.mimecast.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755196Ab3EXMxX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 24 May 2013 08:53:23 -0400
From: Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>
To: linux-kernel@vger.kernel.org, linux-arm-kernel@lists.infradead.org
Cc: devicetree-discuss@lists.ozlabs.org, Pawel Moll <pawel.moll@arm.com>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Achin Gupta <achin.gupta@arm.com>,
        Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Jon Medhurst <tixy@linaro.org>
Subject: [RFC PATCH 1/3] drivers: mfd: refactor the vexpress config bridge API
Date: Fri, 24 May 2013 13:53:04 +0100
Message-Id: <1369399986-15649-2-git-send-email-lorenzo.pieralisi@arm.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <1369399986-15649-1-git-send-email-lorenzo.pieralisi@arm.com>
References: <1369399986-15649-1-git-send-email-lorenzo.pieralisi@arm.com>
X-OriginalArrivalTime: 24 May 2013 12:53:20.0853 (UTC) FILETIME=[AB4E8850:01CE587D]
X-MC-Unique: 113052413532114001
Content-Type: text/plain; charset=WINDOWS-1252
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org
Content-Transfer-Encoding: 8bit
X-MIME-Autoconverted: from quoted-printable to 8bit by mail.home.local id r4OCrjfj011958

From: Pawel Moll <pawel.moll@arm.com>

The introduction of Serial Power Controller (SPC) requires the vexpress
config interface to change slightly since the SPC memory mapped interface
can be used as configuration bus but also for operating points
programming and retrieval. The helper that allocates the bridge functions
requires an additional parameter allowing to request component specific
functions that need not be initialized through device tree bindings but
just using simple look-up and statically defined constants.

This patch introduces the necessary changes to the vexpress config layer
to cater for the new vexpress bridge interface requirements.

Cc: Samuel Ortiz <sameo@linux.intel.com>
Cc: Achin Gupta <achin.gupta@arm.com>
Cc: Sudeep KarkadaNagesha <Sudeep.KarkadaNagesha@arm.com>
Cc: Pawel Moll <pawel.moll@arm.com>
Cc: Nicolas Pitre <nicolas.pitre@linaro.org>
Cc: Amit Kucheria <amit.kucheria@linaro.org>
Cc: Jon Medhurst <tixy@linaro.org>
Signed-off-by: Pawel Moll <pawel.moll@arm.com>
---
 drivers/mfd/vexpress-config.c | 61 ++++++----
 drivers/mfd/vexpress-sysreg.c |  2 +-
 include/linux/vexpress.h      | 16 ++-
 3 files changed, 51 insertions(+), 28 deletions(-)

diff --git a/drivers/mfd/vexpress-config.c b/drivers/mfd/vexpress-config.c
index 84ce6b9..1af2b0e 100644
--- a/drivers/mfd/vexpress-config.c
+++ b/drivers/mfd/vexpress-config.c
@@ -86,29 +86,13 @@ void vexpress_config_bridge_unregister(struct vexpress_config_bridge *bridge)
 }
 EXPORT_SYMBOL(vexpress_config_bridge_unregister);
 
-
-struct vexpress_config_func {
-	struct vexpress_config_bridge *bridge;
-	void *func;
-};
-
-struct vexpress_config_func *__vexpress_config_func_get(struct device *dev,
-		struct device_node *node)
+static struct vexpress_config_bridge *
+		vexpress_config_bridge_find(struct device_node *node)
 {
-	struct device_node *bridge_node;
-	struct vexpress_config_func *func;
 	int i;
+	struct vexpress_config_bridge *res = NULL;
+	struct device_node *bridge_node = of_node_get(node);
 
-	if (WARN_ON(dev && node && dev->of_node != node))
-		return NULL;
-	if (dev && !node)
-		node = dev->of_node;
-
-	func = kzalloc(sizeof(*func), GFP_KERNEL);
-	if (!func)
-		return NULL;
-
-	bridge_node = of_node_get(node);
 	while (bridge_node) {
 		const __be32 *prop = of_get_property(bridge_node,
 				"arm,vexpress,config-bridge", NULL);
@@ -129,13 +113,46 @@ struct vexpress_config_func *__vexpress_config_func_get(struct device *dev,
 
 		if (test_bit(i, vexpress_config_bridges_map) &&
 				bridge->node == bridge_node) {
-			func->bridge = bridge;
-			func->func = bridge->info->func_get(dev, node);
+			res = bridge;
 			break;
 		}
 	}
 	mutex_unlock(&vexpress_config_bridges_mutex);
 
+	return res;
+}
+
+
+struct vexpress_config_func {
+	struct vexpress_config_bridge *bridge;
+	void *func;
+};
+
+struct vexpress_config_func *__vexpress_config_func_get(
+		struct vexpress_config_bridge *bridge,
+		struct device *dev,
+		struct device_node *node,
+		const char *id)
+{
+	struct vexpress_config_func *func;
+
+	if (WARN_ON(dev && node && dev->of_node != node))
+		return NULL;
+	if (dev && !node)
+		node = dev->of_node;
+
+	if (!bridge)
+		bridge = vexpress_config_bridge_find(node);
+	if (!bridge)
+		return NULL;
+
+	func = kzalloc(sizeof(*func), GFP_KERNEL);
+	if (!func)
+		return NULL;
+
+	func->bridge = bridge;
+	func->func = bridge->info->func_get(dev, node, id);
+
 	if (!func->func) {
 		of_node_put(node);
 		kfree(func);
diff --git a/drivers/mfd/vexpress-sysreg.c b/drivers/mfd/vexpress-sysreg.c
index 96a020b..d2599aa 100644
--- a/drivers/mfd/vexpress-sysreg.c
+++ b/drivers/mfd/vexpress-sysreg.c
@@ -165,7 +165,7 @@ static u32 *vexpress_sysreg_config_data;
 static int vexpress_sysreg_config_tries;
 
 static void *vexpress_sysreg_config_func_get(struct device *dev,
-		struct device_node *node)
+		struct device_node *node, const char *id)
 {
 	struct vexpress_sysreg_config_func *config_func;
 	u32 site;
diff --git a/include/linux/vexpress.h b/include/linux/vexpress.h
index 6e7980d..50368e0 100644
--- a/include/linux/vexpress.h
+++ b/include/linux/vexpress.h
@@ -68,7 +68,8 @@
  */
 struct vexpress_config_bridge_info {
 	const char *name;
-	void *(*func_get)(struct device *dev, struct device_node *node);
+	void *(*func_get)(struct device *dev, struct device_node *node,
+			  const char *id);
 	void (*func_put)(void *func);
 	int (*func_exec)(void *func, int offset, bool write, u32 *data);
 };
@@ -87,12 +88,17 @@ void vexpress_config_complete(struct vexpress_config_bridge *bridge,
 
 struct vexpress_config_func;
 
-struct vexpress_config_func *__vexpress_config_func_get(struct device *dev,
-		struct device_node *node);
+struct vexpress_config_func *__vexpress_config_func_get(
+		struct vexpress_config_bridge *bridge,
+		struct device *dev,
+		struct device_node *node,
+		const char *id);
+#define vexpress_config_func_get(bridge, id) \
+		__vexpress_config_func_get(bridge, NULL, NULL, id)
 #define vexpress_config_func_get_by_dev(dev) \
-		__vexpress_config_func_get(dev, NULL)
+		__vexpress_config_func_get(NULL, dev, NULL, NULL)
 #define vexpress_config_func_get_by_node(node) \
-		__vexpress_config_func_get(NULL, node)
+		__vexpress_config_func_get(NULL, NULL, node, NULL)
 void vexpress_config_func_put(struct vexpress_config_func *func);
 
 /* Both may sleep! */
-- 
1.8.2.2


