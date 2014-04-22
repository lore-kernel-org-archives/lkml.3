Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932920AbaDVPN6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 11:13:58 -0400
Received: from mail-ee0-f43.google.com ([74.125.83.43]:45215 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756707AbaDVPKx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 11:10:53 -0400
From: Thierry Reding <thierry.reding@gmail.com>
To: dri-devel@lists.freedesktop.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org, linux-tegra@vger.kernel.org
Subject: [RFC 1/5] drivers/base: Allow multiple masters per device
Date: Tue, 22 Apr 2014 17:09:29 +0200
Message-Id: <1398179373-29966-2-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
References: <1398179373-29966-1-git-send-email-thierry.reding@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Currently the component/master framework allows only a single master to
be registered against a struct device. A master is uniquely identified
by the device and the master operations table, but the current API does
not pass enough information along to allow a master to be uniquely
identified when calling component_unbind_all().

To make it possible to register multiple masters on one device, instead
of passing around the device associated with a master, pass around the
master directly. That way it can always be uniquely identified.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/component.c  | 18 +++++++-----------
 include/linux/component.h | 17 ++++++++---------
 2 files changed, 15 insertions(+), 20 deletions(-)

diff --git a/drivers/base/component.c b/drivers/base/component.c
index c4778995cd72..14fe81bf5ed2 100644
--- a/drivers/base/component.c
+++ b/drivers/base/component.c
@@ -120,7 +120,7 @@ static int try_to_bring_up_master(struct master *master,
 		 * Search the list of components, looking for components that
 		 * belong to this master, and attach them to the master.
 		 */
-		if (master->ops->add_components(master->dev, master)) {
+		if (master->ops->add_components(master, master->dev)) {
 			/* Failed to find all components */
 			master_remove_components(master);
 			ret = 0;
@@ -139,7 +139,7 @@ static int try_to_bring_up_master(struct master *master,
 		}
 
 		/* Found all components */
-		ret = master->ops->bind(master->dev);
+		ret = master->ops->bind(master, master->dev);
 		if (ret < 0) {
 			devres_release_group(master->dev, NULL);
 			dev_info(master->dev, "master bind failed: %d\n", ret);
@@ -172,7 +172,7 @@ static int try_to_bring_up_masters(struct component *component)
 static void take_down_master(struct master *master)
 {
 	if (master->bound) {
-		master->ops->unbind(master->dev);
+		master->ops->unbind(master, master->dev);
 		devres_release_group(master->dev, NULL);
 		master->bound = false;
 	}
@@ -233,21 +233,19 @@ static void component_unbind(struct component *component,
 {
 	WARN_ON(!component->bound);
 
-	component->ops->unbind(component->dev, master->dev, data);
+	component->ops->unbind(component->dev, master, data);
 	component->bound = false;
 
 	/* Release all resources claimed in the binding of this component */
 	devres_release_group(component->dev, component);
 }
 
-void component_unbind_all(struct device *master_dev, void *data)
+void component_unbind_all(struct master *master, void *data)
 {
-	struct master *master;
 	struct component *c;
 
 	WARN_ON(!mutex_is_locked(&component_mutex));
 
-	master = __master_find(master_dev, NULL);
 	if (!master)
 		return;
 
@@ -282,7 +280,7 @@ static int component_bind(struct component *component, struct master *master,
 	dev_dbg(master->dev, "binding %s (ops %ps)\n",
 		dev_name(component->dev), component->ops);
 
-	ret = component->ops->bind(component->dev, master->dev, data);
+	ret = component->ops->bind(component->dev, master, data);
 	if (!ret) {
 		component->bound = true;
 
@@ -308,15 +306,13 @@ static int component_bind(struct component *component, struct master *master,
 	return ret;
 }
 
-int component_bind_all(struct device *master_dev, void *data)
+int component_bind_all(struct master *master, void *data)
 {
-	struct master *master;
 	struct component *c;
 	int ret = 0;
 
 	WARN_ON(!mutex_is_locked(&component_mutex));
 
-	master = __master_find(master_dev, NULL);
 	if (!master)
 		return -EINVAL;
 
diff --git a/include/linux/component.h b/include/linux/component.h
index 68870182ca1e..89fe8bb35053 100644
--- a/include/linux/component.h
+++ b/include/linux/component.h
@@ -2,24 +2,23 @@
 #define COMPONENT_H
 
 struct device;
+struct master;
 
 struct component_ops {
-	int (*bind)(struct device *, struct device *, void *);
-	void (*unbind)(struct device *, struct device *, void *);
+	int (*bind)(struct device *, struct master *, void *);
+	void (*unbind)(struct device *, struct master *, void *);
 };
 
 int component_add(struct device *, const struct component_ops *);
 void component_del(struct device *, const struct component_ops *);
 
-int component_bind_all(struct device *, void *);
-void component_unbind_all(struct device *, void *);
-
-struct master;
+int component_bind_all(struct master *, void *);
+void component_unbind_all(struct master *, void *);
 
 struct component_master_ops {
-	int (*add_components)(struct device *, struct master *);
-	int (*bind)(struct device *);
-	void (*unbind)(struct device *);
+	int (*add_components)(struct master *, struct device *);
+	int (*bind)(struct master *, struct device *);
+	void (*unbind)(struct master *, struct device *);
 };
 
 int component_master_add(struct device *, const struct component_master_ops *);
-- 
1.9.2

