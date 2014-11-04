Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932125AbaKDQ3n (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:29:43 -0500
Received: from mail-pd0-f181.google.com ([209.85.192.181]:35169 "EHLO
	mail-pd0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754924AbaKDQ3k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:29:40 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [RFC 2/2] drm/panel: Use generic object registry
Date: Tue,  4 Nov 2014 17:29:28 +0100
Message-Id: <1415118568-18771-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
References: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Convert to the new generic object registry and introduce proper object
and module reference counting. This should make panel registration and
removal a lot more robust.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/gpu/drm/drm_panel.c | 100 ++++++++++++++++++++++++++++++++++----------
 include/drm/drm_panel.h     |  13 ++++--
 2 files changed, 86 insertions(+), 27 deletions(-)

diff --git a/drivers/gpu/drm/drm_panel.c b/drivers/gpu/drm/drm_panel.c
index 3dfe3c886502..c1b58bd421a3 100644
--- a/drivers/gpu/drm/drm_panel.c
+++ b/drivers/gpu/drm/drm_panel.c
@@ -23,13 +23,11 @@
 
 #include <linux/err.h>
 #include <linux/module.h>
+#include <linux/registry.h>
 
 #include <drm/drm_crtc.h>
 #include <drm/drm_panel.h>
 
-static DEFINE_MUTEX(panel_lock);
-static LIST_HEAD(panel_list);
-
 /**
  * DOC: drm panel
  *
@@ -38,6 +36,33 @@ static LIST_HEAD(panel_list);
  * drivers.
  */
 
+/*
+ * DRM panel registry
+ */
+static struct registry panels = {
+	.lock = __MUTEX_INITIALIZER(panels.lock),
+	.list = LIST_HEAD_INIT(panels.list),
+	.owner = THIS_MODULE,
+};
+
+static inline struct drm_panel *to_drm_panel(struct registry_record *record)
+{
+	return container_of(record, struct drm_panel, record);
+}
+
+static void drm_panel_release(struct registry_record *record)
+{
+	struct drm_panel *panel = to_drm_panel(record);
+
+	/*
+	 * The .release() callback is optional because drivers may not need
+	 * to manually release any resources (e.g. if they've used devm_*()
+	 * helper functions).
+	 */
+	if (panel->funcs && panel->funcs->release)
+		panel->funcs->release(panel);
+}
+
 /**
  * drm_panel_init - initialize a panel
  * @panel: DRM panel
@@ -47,11 +72,48 @@ static LIST_HEAD(panel_list);
  */
 void drm_panel_init(struct drm_panel *panel)
 {
-	INIT_LIST_HEAD(&panel->list);
+	registry_record_init(&panel->record);
+	panel->record.release = drm_panel_release;
 }
 EXPORT_SYMBOL(drm_panel_init);
 
 /**
+ * drm_panel_ref - acquire a reference to a panel
+ * @panel: DRM panel
+ *
+ * Increases the reference on a panel and returns a pointer to it.
+ *
+ * Return: A reference to the panel on success or NULL on failure.
+ */
+struct drm_panel *drm_panel_ref(struct drm_panel *panel)
+{
+	if (panel) {
+		struct registry_record *record;
+
+		record = registry_record_ref(&panel->record);
+		if (!record)
+			panel = NULL;
+	}
+
+	return panel;
+}
+EXPORT_SYMBOL(drm_panel_ref);
+
+/**
+ * drm_panel_unref - release a reference to a panel
+ * @panel: DRM panel
+ *
+ * Decreases the reference count on a panel. If the reference count reaches 0
+ * the panel is destroyed.
+ */
+void drm_panel_unref(struct drm_panel *panel)
+{
+	if (panel)
+		registry_record_unref(&panel->record);
+}
+EXPORT_SYMBOL(drm_panel_unref);
+
+/**
  * drm_panel_add - add a panel to the global registry
  * @panel: panel to add
  *
@@ -62,11 +124,10 @@ EXPORT_SYMBOL(drm_panel_init);
  */
 int drm_panel_add(struct drm_panel *panel)
 {
-	mutex_lock(&panel_lock);
-	list_add_tail(&panel->list, &panel_list);
-	mutex_unlock(&panel_lock);
+	panel->record.owner = panel->dev->driver->owner;
+	panel->record.dev = panel->dev;
 
-	return 0;
+	return registry_add(&panels, &panel->record);
 }
 EXPORT_SYMBOL(drm_panel_add);
 
@@ -74,13 +135,12 @@ EXPORT_SYMBOL(drm_panel_add);
  * drm_panel_remove - remove a panel from the global registry
  * @panel: DRM panel
  *
- * Removes a panel from the global registry.
+ * Removes a panel from the global registry. References to the object can
+ * still exist, but drivers won't be able to look the panel up again.
  */
 void drm_panel_remove(struct drm_panel *panel)
 {
-	mutex_lock(&panel_lock);
-	list_del_init(&panel->list);
-	mutex_unlock(&panel_lock);
+	registry_remove(&panels, &panel->record);
 }
 EXPORT_SYMBOL(drm_panel_remove);
 
@@ -132,25 +192,19 @@ EXPORT_SYMBOL(drm_panel_detach);
  * @np: device tree node of the panel
  *
  * Searches the set of registered panels for one that matches the given device
- * tree node. If a matching panel is found, return a pointer to it.
+ * tree node. If a matching panel is found, return a reference to it.
  *
  * Return: A pointer to the panel registered for the specified device tree
  * node or NULL if no panel matching the device tree node can be found.
  */
 struct drm_panel *of_drm_find_panel(struct device_node *np)
 {
-	struct drm_panel *panel;
-
-	mutex_lock(&panel_lock);
+	struct registry_record *record;
 
-	list_for_each_entry(panel, &panel_list, list) {
-		if (panel->dev->of_node == np) {
-			mutex_unlock(&panel_lock);
-			return panel;
-		}
-	}
+	record = registry_find_by_of_node(&panels, np);
+	if (record)
+		return container_of(record, struct drm_panel, record);
 
-	mutex_unlock(&panel_lock);
 	return NULL;
 }
 EXPORT_SYMBOL(of_drm_find_panel);
diff --git a/include/drm/drm_panel.h b/include/drm/drm_panel.h
index b88b4dcd698b..117e221dbc08 100644
--- a/include/drm/drm_panel.h
+++ b/include/drm/drm_panel.h
@@ -24,7 +24,8 @@
 #ifndef __DRM_PANEL_H__
 #define __DRM_PANEL_H__
 
-#include <linux/list.h>
+#include <linux/module.h>
+#include <linux/registry.h>
 
 struct drm_connector;
 struct drm_device;
@@ -32,6 +33,7 @@ struct drm_panel;
 
 /**
  * struct drm_panel_funcs - perform operations on a given panel
+ * @release: called when the final reference is dropped
  * @disable: disable panel (turn off back light, etc.)
  * @unprepare: turn off panel
  * @prepare: turn on panel and perform set up
@@ -63,6 +65,7 @@ struct drm_panel;
  * the panel. This is the job of the .unprepare() function.
  */
 struct drm_panel_funcs {
+	void (*release)(struct drm_panel *panel);
 	int (*disable)(struct drm_panel *panel);
 	int (*unprepare)(struct drm_panel *panel);
 	int (*prepare)(struct drm_panel *panel);
@@ -72,20 +75,20 @@ struct drm_panel_funcs {
 
 /**
  * struct drm_panel - DRM panel object
+ * @record: registry record
  * @drm: DRM device owning the panel
  * @connector: DRM connector that the panel is attached to
  * @dev: parent device of the panel
  * @funcs: operations that can be performed on the panel
- * @list: panel entry in registry
  */
 struct drm_panel {
+	struct registry_record record;
+
 	struct drm_device *drm;
 	struct drm_connector *connector;
 	struct device *dev;
 
 	const struct drm_panel_funcs *funcs;
-
-	struct list_head list;
 };
 
 /**
@@ -180,6 +183,8 @@ static inline int drm_panel_get_modes(struct drm_panel *panel)
 }
 
 void drm_panel_init(struct drm_panel *panel);
+struct drm_panel *drm_panel_ref(struct drm_panel *panel);
+void drm_panel_unref(struct drm_panel *panel);
 
 int drm_panel_add(struct drm_panel *panel);
 void drm_panel_remove(struct drm_panel *panel);
-- 
2.1.3

