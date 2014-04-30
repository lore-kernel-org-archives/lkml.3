Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1422668AbaD3ODq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 10:03:46 -0400
Received: from mailout1.w1.samsung.com ([210.118.77.11]:53156 "EHLO
	mailout1.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933552AbaD3ODm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 10:03:42 -0400
X-AuditID: cbfec7f5-b7fae6d000004d6d-02-536102be5df4
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Thierry Reding <thierry.reding@gmail.com>,
        David Airlie <airlied@linux.ie>, Inki Dae <inki.dae@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Tomasz Figa <t.figa@samsung.com>,
        Tomasz Stansislawski <t.stanislaws@samsung.com>,
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/S5P EXYNOS
	AR...),
        dri-devel@lists.freedesktop.org, linux-media@vger.kernel.org
Subject: [RFC PATCH 1/4] drivers/base: add interface tracker framework
Date: Wed, 30 Apr 2014 16:02:51 +0200
Message-id: <1398866574-27001-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.8.3.2
In-reply-to: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
References: <1398866574-27001-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrCLMWRmVeSWpSXmKPExsVy+t/xy7r7mBKDDa7f5LC4te4cq0XvuZNM
	Fn8nHWO3uPL1PZtF8+L1bBaT7k9gsTjb9IbdYtPja6wWl3fNYbPo2bCV1WLG+X1MFrcv81qs
	PXKX3WL9jNcsFvPaX7Ja/Nw1j8VBwKOluYfN4/evSYweO2fdZffY/u0Bq8f+uWvYPe53H2fy
	2Lyk3qNvyypGj8+b5AI4o7hsUlJzMstSi/TtErgyJvWfZCxoiK1YtjCigXGxTxcjJ4eEgInE
	ge87WCFsMYkL99azgdhCAksZJQ4c1+1i5AKy+5gknl5dyw6SYBPQlPi7+SZYkYiAjsT1nm5m
	kCJmgdWsEgc+T2IGSQgLuEmcvLmICcRmEVCVOP2phwXE5hVwljh+4D0zxDYFiWVf1oLZnAIu
	Ei0/90FtdpaYMXER0wRG3gWMDKsYRVNLkwuKk9JzjfSKE3OLS/PS9ZLzczcxQkL66w7Gpces
	DjEKcDAq8fAKbI0PFmJNLCuuzD3EKMHBrCTCe/RfQrAQb0piZVVqUX58UWlOavEhRiYOTqkG
	xomVGwOeuR68339hydujL+qZr7SYRV73Obb9e+eOyumetzJvf77pdWOBbuG+Hu5nC/0WrP1f
	dH/2bsPlTiY3pnm+l39d9vDUpFT75Bv+oUUZ9ocPvQzaELg63/C2zOaH786XH0+bPU10Qmzj
	6YOH/vdV+Bl975E4fD/1yLt+mcT7SiudLfu7OGyVWIozEg21mIuKEwGF2oq/RwIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

interface_tracker is a generic framework which allows to track appearance
and disappearance of different interfaces provided by kernel/driver code inside
the kernel. Examples of such interfaces: clocks, phys, regulators, drm_panel...
Interface is specified by a pair of object pointer and interface type. Object
type depends on interface type, for example interface type drm_panel determines
that object is a device_node. Object pointer is used to distinguish different
interfaces of the same type and should identify object the interface is bound to.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/base/Makefile             |   2 +-
 drivers/base/interface_tracker.c  | 307 ++++++++++++++++++++++++++++++++++++++
 include/linux/interface_tracker.h |  27 ++++
 3 files changed, 335 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/interface_tracker.c
 create mode 100644 include/linux/interface_tracker.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 04b314e..5a45c41 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o
+			   topology.o container.o interface_tracker.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/interface_tracker.c b/drivers/base/interface_tracker.c
new file mode 100644
index 0000000..3d36cba
--- /dev/null
+++ b/drivers/base/interface_tracker.c
@@ -0,0 +1,307 @@
+/*
+ * Generic framework for tracking kernel interfaces
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * interface_tracker is a generic framework which allows to track appearance
+ * and disappearance of different interfaces provided by kernel/driver code
+ * inside the kernel. Examples of such interfaces: clocks, phys, regulators,
+ * drm_panel...
+ * Interface is specified by a pair of object pointer and interface type. Object
+ * type depends on interface type, for example interface type drm_panel
+ * determines that object is a device_node. Object pointer is used
+ * to distinguish different interfaces of the same type and should identify
+ * object the interface is bound to. For example it could be DT node,
+ * struct device...
+ *
+ * The framework provides two functions for interface providers which should be
+ * called just after interface becomes available or just before interface
+ * removal. Interface consumers can register callback which will be called when
+ * the requested interface changes its state, if during callback registration
+ * the interface is already up, notification will be sent also.
+ *
+ * The framework allows nesting calls, for example it is possible to signal one
+ * interface in tracker callback of another interface. It is done by putting
+ * every request into the queue. If the queue is empty before adding
+ * the request, the queue will be processed after, if there is already another
+ * request in the queue it means the queue is already processed by different
+ * thread so no additional action is required. With this pattern only spinlock
+ * is necessary to protect the queue. However in case of removal of either
+ * callback or interface caller should be sure that his request has been
+ * processed so framework waits until the queue becomes empty, it is done using
+ * completion mechanism.
+ * The framework functions should not be called in atomic context. Callbacks
+ * should be aware that they can be called in any time between registration and
+ * unregistration, so they should use synchronization mechanisms carefully.
+ * Callbacks should also avoid to perform time consuming tasks, the framework
+ * serializes them, so it could stall other callbacks.
+ */
+
+#include <linux/completion.h>
+#include <linux/interface_tracker.h>
+#include <linux/list.h>
+#include <linux/slab.h>
+#include <linux/spinlock.h>
+
+enum interface_tracker_task_id {
+	interface_tracker_task_register,
+	interface_tracker_task_unregister,
+	interface_tracker_task_ifup,
+	interface_tracker_task_ifdown,
+};
+
+struct interface_tracker_task {
+	struct list_head list;
+	enum interface_tracker_task_id task_id;
+
+	const void *object;
+	unsigned long type;
+	union {
+		struct interface_tracker_block *itb;
+		void *data;
+	};
+};
+
+struct interface_tracker_node {
+	struct list_head list;
+	struct list_head itb_head;
+	const void *object;
+	unsigned long type;
+	void *data;
+	bool ifup;
+};
+
+static LIST_HEAD(interface_tracker_queue);
+static DEFINE_SPINLOCK(interface_tracker_queue_lock);
+static DECLARE_COMPLETION(interface_tracker_queue_completion);
+
+static LIST_HEAD(interface_tracker_nodes);
+
+static struct interface_tracker_node *
+interface_tracker_get_node(const void *object, unsigned long type, bool create)
+{
+	struct interface_tracker_node *node;
+
+	list_for_each_entry(node, &interface_tracker_nodes, list) {
+		if (node->type == type && node->object == object)
+			return node;
+	}
+
+	if (!create)
+		return NULL;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	node->object = object;
+	node->type = type;
+	node->ifup = false;
+	INIT_LIST_HEAD(&node->itb_head);
+	list_add(&node->list, &interface_tracker_nodes);
+
+	return node;
+}
+
+static void interface_tracker_process_task(struct interface_tracker_task *task)
+{
+	struct interface_tracker_block *itb;
+	struct interface_tracker_node *node;
+
+	switch (task->task_id) {
+	case interface_tracker_task_register:
+		node = interface_tracker_get_node(task->object, task->type,
+						  true);
+		list_add_tail(&task->itb->list, &node->itb_head);
+
+		if (node->ifup)
+			task->itb->callback(task->itb, task->object, task->type,
+					    true, node->data);
+		return;
+	case interface_tracker_task_unregister:
+		node = interface_tracker_get_node(task->object, task->type,
+						  false);
+		if (WARN_ON(!node))
+			return;
+
+		list_for_each_entry(itb, &node->itb_head, list) {
+			if (itb != task->itb)
+				continue;
+			list_del(&itb->list);
+			if (list_empty(&node->itb_head)) {
+				list_del(&node->list);
+				kfree(node);
+			}
+			return;
+		}
+
+		WARN_ON(true);
+
+		return;
+	case interface_tracker_task_ifup:
+		node = interface_tracker_get_node(task->object, task->type,
+						  true);
+
+		if (WARN_ON(node->ifup))
+			return;
+
+		node->ifup = true;
+		node->data = task->data;
+		list_for_each_entry(itb, &node->itb_head, list)
+			itb->callback(itb, task->object, task->type, true,
+				      node->data);
+		return;
+	case interface_tracker_task_ifdown:
+		node = interface_tracker_get_node(task->object, task->type,
+						  false);
+
+		if (WARN_ON(!node))
+			return;
+
+		WARN_ON(!node->ifup);
+
+		if (list_empty(&node->itb_head)) {
+			list_del(&node->list);
+			kfree(node);
+			return;
+		}
+
+		node->ifup = false;
+		node->data = task->data;
+
+		list_for_each_entry(itb, &node->itb_head, list)
+			itb->callback(itb, task->object, task->type, false,
+				      node->data);
+	}
+}
+
+static int interface_tracker_process_queue(void)
+{
+	struct interface_tracker_task *task, *ptask = NULL;
+	unsigned long flags;
+	bool empty;
+
+	/* Queue non-emptiness is used as a sentinel to prevent processing
+	 * by multiple threads, so we cannot delete entry from the queue
+	 * until it is processed.
+	 */
+	while (true) {
+		spin_lock_irqsave(&interface_tracker_queue_lock, flags);
+
+		if (ptask)
+			list_del(&ptask->list);
+		task = list_first_entry(&interface_tracker_queue,
+					struct interface_tracker_task, list);
+
+		empty = list_empty(&interface_tracker_queue);
+		if (empty)
+			complete_all(&interface_tracker_queue_completion);
+
+		spin_unlock_irqrestore(&interface_tracker_queue_lock, flags);
+
+		if (ptask)
+			kfree(ptask);
+
+		if (empty)
+			break;
+
+		interface_tracker_process_task(task);
+		ptask = task;
+	}
+
+	return 0;
+}
+
+static int interface_tracker_add_task(struct interface_tracker_task *task,
+				      bool sync)
+{
+	unsigned long flags;
+	int ret = 0;
+	bool empty;
+
+	spin_lock_irqsave(&interface_tracker_queue_lock, flags);
+
+	empty = list_empty(&interface_tracker_queue);
+	if (empty)
+		reinit_completion(&interface_tracker_queue_completion);
+
+	list_add(&task->list, &interface_tracker_queue);
+
+	spin_unlock_irqrestore(&interface_tracker_queue_lock, flags);
+
+	if (empty) {
+		ret = interface_tracker_process_queue();
+	}else if (sync) {
+		wait_for_completion(&interface_tracker_queue_completion);
+	}
+
+	return ret;
+}
+
+int interface_tracker_register(const void *object, unsigned long type,
+			       struct interface_tracker_block *itb)
+{
+	struct interface_tracker_task *task;
+
+	task = kmalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	task->task_id = interface_tracker_task_register;
+	task->object = object;
+	task->type = type;
+	task->itb = itb;
+
+	return interface_tracker_add_task(task, false);
+}
+
+int interface_tracker_unregister(const void *object, unsigned long type,
+				 struct interface_tracker_block *itb)
+{
+	struct interface_tracker_task *task;
+
+	task = kmalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	task->task_id = interface_tracker_task_unregister;
+	task->object = object;
+	task->type = type;
+	task->itb = itb;
+
+	return interface_tracker_add_task(task, true);
+}
+
+int interface_tracker_ifup(const void *object, unsigned long type, void *data)
+{
+	struct interface_tracker_task *task;
+
+	task = kmalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	task->task_id = interface_tracker_task_ifup;
+	task->object = object;
+	task->type = type;
+	task->data = data;
+
+	return interface_tracker_add_task(task, false);
+}
+
+int interface_tracker_ifdown(const void *object, unsigned long type, void *data)
+{
+	struct interface_tracker_task *task;
+
+	task = kmalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	task->task_id = interface_tracker_task_ifdown;
+	task->object = object;
+	task->type = type;
+	task->data = data;
+
+	return interface_tracker_add_task(task, true);
+}
diff --git a/include/linux/interface_tracker.h b/include/linux/interface_tracker.h
new file mode 100644
index 0000000..e1eff00
--- /dev/null
+++ b/include/linux/interface_tracker.h
@@ -0,0 +1,27 @@
+#ifndef INTERFACE_TRACKER_H
+#define INTERFACE_TRACKER_H
+
+#include <linux/types.h>
+
+struct list_head;
+struct interface_tracker_block;
+
+typedef void (*interface_tracker_fn_t)(struct interface_tracker_block *itb,
+				       const void *object, unsigned long type,
+				       bool on, void *data);
+
+struct interface_tracker_block {
+	interface_tracker_fn_t callback;
+	struct list_head list;
+};
+
+extern int interface_tracker_register(const void *object, unsigned long type,
+				      struct interface_tracker_block *itb);
+extern int interface_tracker_unregister(const void *object, unsigned long type,
+					struct interface_tracker_block *itb);
+extern int interface_tracker_ifup(const void *object, unsigned long type,
+				  void *data);
+extern int interface_tracker_ifdown(const void *object, unsigned long type,
+				    void *data);
+
+#endif /* INTERFACE_TRACKER_H */
-- 
1.8.3.2

