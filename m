Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932071AbaKDQ3k (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 11:29:40 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:49625 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754733AbaKDQ3e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 11:29:34 -0500
From: Thierry Reding <thierry.reding@gmail.com>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Daniel Vetter <daniel.vetter@ffwll.ch>,
        David Herrmann <dh.herrmann@gmail.com>,
        dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org
Subject: [RFC 1/2] core: Add generic object registry implementation
Date: Tue,  4 Nov 2014 17:29:27 +0100
Message-Id: <1415118568-18771-1-git-send-email-thierry.reding@gmail.com>
X-Mailer: git-send-email 2.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Thierry Reding <treding@nvidia.com>

Add a generic implementation of an object registry. This targets drivers
and subsystems that provide auxiliary objects that other drivers need to
look up. The goal is to put the difficult parts (keep object references,
module usage count, ...) into core code so that individual subsystems do
not have to deal with them.

The intention is for subsystems to instantiate a struct registry and use
a struct registry_record embedded into a subsystem-specific structure to
provide a subsystem-specific API around that.

Signed-off-by: Thierry Reding <treding@nvidia.com>
---
 drivers/base/Makefile    |   2 +-
 drivers/base/registry.c  | 147 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/registry.h |  62 ++++++++++++++++++++
 3 files changed, 210 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/registry.c
 create mode 100644 include/linux/registry.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 53c3fe1aeb29..250262d1af2c 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o property.o
+			   topology.o container.o property.o registry.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/registry.c b/drivers/base/registry.c
new file mode 100644
index 000000000000..9f510f6237b7
--- /dev/null
+++ b/drivers/base/registry.c
@@ -0,0 +1,147 @@
+/*
+ * Copyright (C) 2014, NVIDIA Corporation.  All rights reserved.
+ *
+ * This file is released under the GPL v2.
+ */
+
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/registry.h>
+
+static inline struct registry_record *to_registry_record(struct kref *kref)
+{
+	return container_of(kref, struct registry_record, kref);
+}
+
+static void registry_record_release(struct kref *kref)
+{
+	struct registry_record *record = to_registry_record(kref);
+
+	record->release(record);
+}
+
+/**
+ * registry_record_init - initialize a registry record
+ * @record: record to initialize
+ *
+ * Sets up internal fields of the registry record so that it can subsequently
+ * be added to a registry.
+ */
+void registry_record_init(struct registry_record *record)
+{
+	INIT_LIST_HEAD(&record->list);
+	kref_init(&record->kref);
+}
+
+/**
+ * registry_record_ref - reference on the registry record
+ * @record: record to reference
+ *
+ * Increases the reference count on the record and returns a pointer to it.
+ *
+ * Return: A pointer to the record on success or NULL on failure.
+ */
+struct registry_record *registry_record_ref(struct registry_record *record)
+{
+	if (!record)
+		return NULL;
+
+	/*
+	 * Refuse to give out any more references if the module owning the
+	 * record is being removed.
+	 */
+	if (!try_module_get(record->owner))
+		return NULL;
+
+	kref_get(&record->kref);
+
+	return record;
+}
+
+/**
+ * registry_record_unref - drop a reference to a registry record
+ * @record: record to unreference
+ *
+ * Decreases the reference count on the record. When the reference count
+ * reaches zero the record will be destroyed.
+ */
+void registry_record_unref(struct registry_record *record)
+{
+	if (record) {
+		/*
+		 * Keep a copy of the module owner since the record may
+		 * disappear during the kref_put().
+		 */
+		struct module *owner = record->owner;
+
+		kref_put(&record->kref, registry_record_release);
+		module_put(owner);
+	}
+}
+
+/**
+ * registry_add - add a record to a registry
+ * @registry: registry to add the record to
+ * @record: record to add
+ *
+ * Tries to increase the reference count of the module owning the registry. If
+ * successful adds the new record to the registry.
+ *
+ * Return: 0 on success or a negative error code on failure.
+ */
+int registry_add(struct registry *registry, struct registry_record *record)
+{
+	if (!try_module_get(registry->owner))
+		return -ENODEV;
+
+	mutex_lock(&registry->lock);
+	list_add_tail(&record->list, &registry->list);
+	mutex_unlock(&registry->lock);
+
+	return 0;
+}
+
+/**
+ * registry_remove - remove a record from a registry
+ * @registry: registry to remove the record from
+ * @record: record to remove
+ *
+ * Decreases the reference count on the module owning the registry.
+ */
+void registry_remove(struct registry *registry,
+		     struct registry_record *record)
+{
+	mutex_lock(&registry->lock);
+	list_del_init(&record->list);
+	mutex_unlock(&registry->lock);
+
+	module_put(registry->owner);
+}
+
+#ifdef CONFIG_OF
+/**
+ * registry_find_by_of_node - look up an object by device node in a registry
+ * @registry: registry to search
+ * @np: device node to match on
+ *
+ * Return: A pointer to the record matching @np or NULL if no such record was
+ * found.
+ */
+struct registry_record *registry_find_by_of_node(struct registry *registry,
+						 struct device_node *np)
+{
+	struct registry_record *record;
+
+	mutex_lock(&registry->lock);
+
+	list_for_each_entry(record, &registry->list, list)
+		if (record->dev->of_node == np)
+			goto out;
+
+	record = NULL;
+
+out:
+	mutex_unlock(&registry->lock);
+	return record;
+}
+#endif
diff --git a/include/linux/registry.h b/include/linux/registry.h
new file mode 100644
index 000000000000..a807f4124736
--- /dev/null
+++ b/include/linux/registry.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright (C) 2014, NVIDIA Corporation.  All rights reserved.
+ *
+ * This file is released under the GPL v2.
+ */
+
+#ifndef __LINUX_REGISTRY_H
+#define __LINUX_REGISTRY_H
+
+#include <linux/kref.h>
+#include <linux/list.h>
+#include <linux/mutex.h>
+
+struct device;
+struct device_node;
+struct module;
+
+struct registry;
+
+/**
+ * struct registry_record - registry record object
+ * @list: entry in registry for this record
+ * @owner: owner module
+ * @kref: reference count
+ * @dev: parent device
+ * @release: callback to destroy a record when no reference are left
+ */
+struct registry_record {
+	struct list_head list;
+	struct module *owner;
+	struct kref kref;
+	struct device *dev;
+
+	void (*release)(struct registry_record *record);
+};
+
+void registry_record_init(struct registry_record *record);
+struct registry_record *registry_record_ref(struct registry_record *record);
+void registry_record_unref(struct registry_record *record);
+
+/**
+ * struct registry - generic object registry
+ * @list: list head of objects
+ * @owner: owner module
+ * @lock: lock for object list
+ */
+struct registry {
+	struct list_head list;
+	struct module *owner;
+	struct mutex lock;
+};
+
+int registry_add(struct registry *registry, struct registry_record *record);
+void registry_remove(struct registry *registry,
+		     struct registry_record *record);
+
+#ifdef CONFIG_OF
+struct registry_record *registry_find_by_of_node(struct registry *registry,
+						 struct device_node *np);
+#endif
+
+#endif
-- 
2.1.3

