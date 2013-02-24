Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759440Ab3BXEGD (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 23:06:03 -0500
Received: from mail-da0-f42.google.com ([209.85.210.42]:41125 "EHLO
	mail-da0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759244Ab3BXEGB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 23:06:01 -0500
Date: Sat, 23 Feb 2013 20:05:57 -0800
From: Dmitry Torokhov <dmitry.torokhov@gmail.com>
To: Tejun Heo <tj@kernel.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org
Subject: [RFC/PATCH] devres: allow adding custom actions to the stack
Message-ID: <20130224040556.GA15339@core.coreip.homeip.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sometimes drivers need to execute one-off actions in their error handling
or device teardown paths. An example would be toggling a GPIO line to
reset the controlled device into predefined state.

To allow performing such actions when using managed resources let's allow
adding them to stack/group of devres resources.

Signed-off-by: Dmitry Torokhov <dmitry.torokhov@gmail.com>
---
 drivers/base/devres.c  | 74 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/device.h |  4 +++
 2 files changed, 78 insertions(+)

diff --git a/drivers/base/devres.c b/drivers/base/devres.c
index 6683906..507379e 100644
--- a/drivers/base/devres.c
+++ b/drivers/base/devres.c
@@ -671,6 +671,80 @@ int devres_release_group(struct device *dev, void *id)
 EXPORT_SYMBOL_GPL(devres_release_group);
 
 /*
+ * Custom devres actions allow inserting a simple function call
+ * into the teadown sequence.
+ */
+
+struct action_devres {
+	void *data;
+	void (*action)(void *);
+};
+
+static int devm_action_match(struct device *dev, void *res, void *p)
+{
+	struct action_devres *devres = res;
+	struct action_devres *target = p;
+
+	return devres->action == target->action &&
+	       devres->data == target->data;
+}
+
+static void devm_action_release(struct device *dev, void *res)
+{
+	struct action_devres *devres = res;
+
+	devres->action(devres->data);
+}
+
+/**
+ * devm_add_action() - add a custom action to list of managed resources
+ * @dev: Device that owns the action
+ * @action: Function that should be called
+ * @data: Pointer to data passed to @action implementation
+ *
+ * This adds a custom action to the list of managed resources so that
+ * it gets executed as part of standard resource unwinding.
+ */
+int devm_add_action(struct device *dev, void (*action)(void *), void *data)
+{
+	struct action_devres *devres;
+
+	devres = devres_alloc(devm_action_release,
+			      sizeof(struct action_devres), GFP_KERNEL);
+	if (!devres)
+		return -ENOMEM;
+
+	devres->data = data;
+	devres->action = action;
+
+	devres_add(dev, devres);
+	return 0;
+}
+EXPORT_SYMBOL_GPL(devm_add_action);
+
+/**
+ * devm_remove_action() - removes previously added custom action
+ * @dev: Device that owns the action
+ * @action: Function implementing the action
+ * @data: Pointer to data passed to @action implementation
+ *
+ * Removes instance of @action previously added by devm_add_action().
+ * Both action and data should match one of the existing entries.
+ */
+void devm_remove_action(struct device *dev, void (*action)(void *), void *data)
+{
+	struct action_devres devres = {
+		.data = data,
+		.action = action,
+	};
+
+	WARN_ON(devres_destroy(dev, devm_action_release, devm_action_match,
+			       &devres));
+
+}
+EXPORT_SYMBOL_GPL(devm_remove_action);
+
+/*
  * Managed kzalloc/kfree
  */
 static void devm_kzalloc_release(struct device *dev, void *res)
diff --git a/include/linux/device.h b/include/linux/device.h
index 2fbf088..ba7c802 100644
--- a/include/linux/device.h
+++ b/include/linux/device.h
@@ -578,6 +578,10 @@ extern void devm_kfree(struct device *dev, void *p);
 void __iomem *devm_request_and_ioremap(struct device *dev,
 			struct resource *res);
 
+/* allows to add/remove a custom action to devres stack */
+int devm_add_action(struct device *dev, void (*action)(void *), void *data);
+void devm_remove_action(struct device *dev, void (*action)(void *), void *data);
+
 struct device_dma_parameters {
 	/*
 	 * a low level driver may set these to teach IOMMU code about
-- 
1.7.11.7


-- 
Dmitry
