Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758010AbaLJPtE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Dec 2014 10:49:04 -0500
Received: from mailout3.w1.samsung.com ([210.118.77.13]:56575 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757877AbaLJPs5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Dec 2014 10:48:57 -0500
X-AuditID: cbfec7f5-b7fc86d0000066b7-58-54886b6699f9
From: Andrzej Hajda <a.hajda@samsung.com>
To: linux-kernel@vger.kernel.org (open list)
Cc: Andrzej Hajda <a.hajda@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Mike Turquette <mturquette@linaro.org>,
        Russell King <linux@arm.linux.org.uk>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thierry Reding <thierry.reding@gmail.com>,
        Inki Dae <inki.dae@samsung.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <robh+dt@kernel.org>,
        linux-arm-kernel@lists.infradead.org (moderated list:ARM/CLKDEV SUPPORT),
        linux-gpio@vger.kernel.org (open list:GPIO SUBSYSTEM),
        dri-devel@lists.freedesktop.org (open list:DRM PANEL DRIVERS),
        linux-samsung-soc@vger.kernel.org (moderated list:ARM/S5P EXYNOS AR...),
        devicetree@vger.kernel.org (open list:OPEN FIRMWARE AND...),
        boris.brezillon@free-electrons.com
Subject: [RFC 01/15] drivers/base: add track framework
Date: Wed, 10 Dec 2014 16:48:19 +0100
Message-id: <1418226513-14105-2-git-send-email-a.hajda@samsung.com>
X-Mailer: git-send-email 1.9.1
In-reply-to: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
References: <1418226513-14105-1-git-send-email-a.hajda@samsung.com>
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFrrBLMWRmVeSWpSXmKPExsVy+t/xy7pp2R0hBtfvalrcWneO1eLAi4Us
	FlMfPmGzmH8EyL3y9T2bxblXj1gsDvzZwWjRvHg9m8Wk+xNYLC487WGz+Halg8liyp/lTBab
	Hl9jtdg8/w+jxeVdc9gsZpzfx2Rx+zKvxdojd9ktnk64yGbRuvcIu8XPXfNYHEQ9Wpp72Dye
	bLrI6LFz1l12j02rOtk87lzbw+axf+4ado/73ceZPDYvqffo27KK0eP4je1MHp83yQVwR3HZ
	pKTmZJalFunbJXBl/L9zgblgRUFFx801rA2MN6O6GDk5JARMJF6v6maHsMUkLtxbz9bFyMUh
	JLCUUaJh9llGCKePSeLn3lmMIFVsApoSfzffZAOxRQR0JK73dDODFDELbGCXWDd9H1CCg0NY
	wEzi3l1+kBoWAVWJBbMmMIPYvALOEvNuv2eD2CYncfLYZFYQm1PAReLv871g84WAapZse886
	gZF3ASPDKkbR1NLkguKk9FwjveLE3OLSvHS95PzcTYyQ2Pi6g3HpMatDjAIcjEo8vDsU20KE
	WBPLiitzDzFKcDArifAuTO4IEeJNSaysSi3Kjy8qzUktPsTIxMEp1cB4vi3jlR1bxdqYdy+7
	97C35Grai9jw3zSao3VD8PDvFqWJzmtCmKcVJBZdqr5Qv3n3Kv78j0Vn7v6TN7vyf76Y432R
	O7l1MZJzfv7QCvRJmxB0eMnphdcm7s2bJCaS1P34TRzXms1FJTK8pcn5lu/b49xNuPSF591c
	qKbqfHy60mXvr8EnexqVWIozEg21mIuKEwGLvg5IawIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

track is a generic framework for safe tracking presence of any kernel objects
having an id. There are no special requirements about type of object or its
id. Id shall be unique.
Typical usage of the framework by consumer looks as follow:
1. Consumer registers notifier callback for objects with given id.
2. If the object is present consumer is notified immediately, otherwise it
   will be notified immediately after object creation.
3. If the object is about to be removed notification is sent to the consumer
   just before removal.
4. When consumer do not need the object anymore it unregisters its notifier
   callback. If the object is present during notifier unregistration
   notification about removal of the object is sent to the consumer.

All notification callbacks are serialized so the consumer do not need use
additional mechanisms to prevent callback races. Consumer should assume that
object is valid only between up and down notification callbacks inclusive.

Framework usage by object provider is simple:
1. When object becomes available it notifies framework about it.
2. When object becomes unavailable it notifies framework about it.

Provider should take care of calling notifications synchronously in proper
order.

The framework does not uses locks during notification calls, so it is safe
to call framework functions from the callbacks. This feature allows to model
complex object dependencies without deadlock risk.

Some framework functions can sleep so the framework should be used in process
context.

Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
---
 drivers/base/Makefile |   2 +-
 drivers/base/track.c  | 241 ++++++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/track.h | 148 +++++++++++++++++++++++++++++++
 3 files changed, 390 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/track.c
 create mode 100644 include/linux/track.h

diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 6922cd6..4edff7d 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -4,7 +4,7 @@ obj-y			:= component.o core.o bus.o dd.o syscore.o \
 			   driver.o class.o platform.o \
 			   cpu.o firmware.o init.o map.o devres.o \
 			   attribute_container.o transport_class.o \
-			   topology.o container.o
+			   topology.o container.o track.o
 obj-$(CONFIG_DEVTMPFS)	+= devtmpfs.o
 obj-$(CONFIG_DMA_CMA) += dma-contiguous.o
 obj-y			+= power/
diff --git a/drivers/base/track.c b/drivers/base/track.c
new file mode 100644
index 0000000..8cf0492
--- /dev/null
+++ b/drivers/base/track.c
@@ -0,0 +1,241 @@
+/*
+ * Generic framework for tracking named object
+ *
+ * Copyright (c) 2014 Samsung Electronics Co., Ltd
+ * Andrzej Hajda <a.hajda@samsung.com>
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 as
+ * published by the Free Software Foundation.
+ *
+ * track is a generic framework for safe tracking presence of any kernel objects
+ * having an id. There are no special requirements about type of object or its
+ * id. Id shall be unique.
+ * Typical usage of the framework by consumer looks as follow:
+ * 1. Consumer registers notifier callback for objects with given id.
+ * 2. If the object is present consumer is notified immediately, otherwise it
+ *    will be notified immediately after object creation.
+ * 3. If the object is about to be removed notification is sent to the consumer
+ *    just before removal.
+ * 4. When consumer do not need the object anymore it unregisters its notifier
+ *    callback. If the object is present during notifier unregistration
+ *    notification about removal of the object is sent to the consumer.
+ *
+ * All notification callbacks are serialized so the consumer do not need use
+ * additional mechanisms to prevent callback races. Consumer should assume that
+ * object is valid only between up and down notification callbacks inclusive.
+ *
+ * Framework usage by object provider is simple:
+ * 1. When object becomes available it notifies framework about it.
+ * 2. When object becomes unavailable it notifies framework about it.
+ *
+ * Provider should take care of calling notifications synchronously in proper
+ * order.
+ *
+ * The framework does not uses locks during notification calls, so it is safe
+ * to call framework functions from the callbacks. This feature allows to model
+ * complex object dependencies without deadlock risk.
+ *
+ * Some framework functions can sleep so the framework should be used in process
+ * context.
+ *
+ */
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/track.h>
+
+struct track_task {
+	struct list_head list;
+	enum track_task_id task_id;
+
+	unsigned long type;
+	const void *id;
+	union {
+		void *data;
+		struct track_block *itb;
+	};
+};
+
+struct track_node {
+	struct list_head list;
+	struct list_head itb_head;
+	struct track_block *itb_next;
+	const void *id;
+	unsigned long type;
+	void *data;
+	bool up;
+};
+
+static struct track_node *
+track_get_node(struct tracker *track, unsigned long type, const void *id,
+		bool create)
+{
+	struct track_node *node;
+
+	list_for_each_entry(node, &track->nodes, list) {
+		if (node->type == type && node->id == id)
+			return node;
+	}
+
+	if (!create)
+		return NULL;
+
+	node = kmalloc(sizeof(*node), GFP_KERNEL);
+	if (!node)
+		return NULL;
+
+	node->id = id;
+	node->type = type;
+	node->up = false;
+	INIT_LIST_HEAD(&node->itb_head);
+	list_add(&node->list, &track->nodes);
+
+	return node;
+}
+
+static void track_process_task(struct tracker *track, struct track_task *task)
+{
+	struct track_block *itb;
+	struct track_node *node;
+
+	switch (task->task_id) {
+	case track_task_register:
+		node = track_get_node(track, task->type, task->id, true);
+		list_add_tail(&task->itb->list, &node->itb_head);
+
+		if (node->up)
+			task->itb->callback(task->itb, node->data, true);
+		return;
+	case track_task_unregister:
+		node = track_get_node(track, task->type, task->id, false);
+		if (WARN_ON(!node))
+			return;
+
+		if (node->up)
+			task->itb->callback(task->itb, node->data, false);
+
+		if (node->itb_next == task->itb)
+			node->itb_next = list_next_entry(node->itb_next, list);
+		list_del(&task->itb->list);
+
+		if (list_empty(&node->itb_head) && !node->up) {
+			list_del(&node->list);
+			kfree(node);
+		}
+		return;
+	case track_task_up:
+		node = track_get_node(track, task->type, task->id, true);
+
+		node->up = true;
+		node->data = task->data;
+		list_for_each_entry_safe(itb, node->itb_next, &node->itb_head,
+					 list)
+			itb->callback(itb, node->data, true);
+		return;
+	case track_task_down:
+		node = track_get_node(track, task->type, task->id, false);
+
+		if (WARN_ON(!node))
+			return;
+
+		WARN_ON(!node->up);
+
+		if (list_empty(&node->itb_head)) {
+			list_del(&node->list);
+			kfree(node);
+			return;
+		}
+
+		node->up = false;
+		node->data = task->data;
+
+		list_for_each_entry_safe(itb, node->itb_next, &node->itb_head,
+					 list)
+			itb->callback(itb, node->data, false);
+	}
+}
+
+static int track_process_queue(struct tracker *track)
+{
+	struct track_task *task, *ptask = NULL;
+	unsigned long flags;
+	bool empty;
+
+	/* Queue non-emptiness is used as a sentinel to prevent processing
+	 * by multiple threads, so we cannot delete entry from the queue
+	 * until it is processed.
+	 */
+	while (true) {
+		spin_lock_irqsave(&track->queue_lock, flags);
+
+		if (ptask)
+			list_del(&ptask->list);
+		task = list_first_entry(&track->queue,
+					struct track_task, list);
+
+		empty = list_empty(&track->queue);
+		if (empty)
+			complete_all(&track->queue_empty);
+
+		spin_unlock_irqrestore(&track->queue_lock, flags);
+
+		kfree(ptask);
+
+		if (empty)
+			break;
+
+		track_process_task(track, task);
+		ptask = task;
+	}
+
+	return 0;
+}
+
+int track_add_task(struct tracker *track, enum track_task_id task_id,
+		   unsigned long type, const void *id, void *data, bool sync)
+{
+	struct track_task *task;
+	unsigned long flags;
+	bool empty, owner;
+
+	task = kmalloc(sizeof(*task), GFP_KERNEL);
+	if (!task)
+		return -ENOMEM;
+
+	task->task_id = task_id;
+	task->id = id;
+	task->type = type;
+	task->data = data;
+
+	spin_lock_irqsave(&track->queue_lock, flags);
+
+	empty = list_empty(&track->queue);
+	if (empty) {
+		reinit_completion(&track->queue_empty);
+		track->queue_owner = current;
+	} else {
+		owner = (track->queue_owner == current);
+	}
+
+	if (empty || !owner)
+		list_add(&task->list, &track->queue);
+
+	spin_unlock_irqrestore(&track->queue_lock, flags);
+
+	pr_debug("%s:%d: task=%c type=%ld id=%p\n", __func__, __LINE__,
+		 "ru+-"[task_id], type, id);
+
+	if (empty)
+		return track_process_queue(track);
+
+	if (owner) {
+		track_process_task(track, task);
+		kfree(task);
+		return 0;
+	}
+
+	if (sync)
+		wait_for_completion(&track->queue_empty);
+
+	return 0;
+}
diff --git a/include/linux/track.h b/include/linux/track.h
new file mode 100644
index 0000000..b1eed60
--- /dev/null
+++ b/include/linux/track.h
@@ -0,0 +1,148 @@
+#ifndef TRACK_H
+#define TRACK_H
+
+#include <linux/completion.h>
+#include <linux/list.h>
+#include <linux/spinlock.h>
+#include <linux/types.h>
+
+struct list_head;
+struct track_block;
+struct tracker;
+
+typedef void (*track_fn_t)(struct track_block *itb, void *data, bool on);
+
+/**
+ * struct track_block - structure used by track consumers to register callback
+ * @callback: Pointer to notification function provided by consumer
+ * @list: field used by track core to chain blocks
+ *
+ * struct track_block is passed to the framework during callback registration,
+ * it should be valid until callback unregistration.
+ * Usually it can be embedded in drivers private data, so callback function can
+ * get pointer to private data using container_of mechanism.
+ *
+ */
+struct track_block {
+	track_fn_t callback;
+	struct list_head list;
+};
+
+enum track_task_id {
+	track_task_register,
+	track_task_unregister,
+	track_task_up,
+	track_task_down,
+};
+
+/**
+ * struct tracker - the main structure for tracking objects
+ * @queue: queue of tasks to do
+ * @queue_lock: lock protecting @queue access
+ * @queue_empty: completion fired when queue becomes empty
+ * @queue_owner: id of task processing queue
+ * @nodes: list head of track_nodes
+ *
+ * struct tracker - is the main structure used to track and synchronize
+ * framework functions and callbacks. There can be many independent trackers in
+ * the system.
+ */
+struct tracker {
+	struct list_head queue;
+	spinlock_t queue_lock;
+	struct completion queue_empty;
+	struct task_struct *queue_owner;
+	struct list_head nodes;
+};
+
+/**
+ * DEFINE_TRACKER - define the main structure for object tracking
+ * @x: name of the structure
+ *
+ * This macro defines and initializes tracker structure.
+ */
+#define DEFINE_TRACKER(x) \
+	struct tracker x = { \
+		.queue = LIST_HEAD_INIT(x.queue), \
+		.queue_lock = __SPIN_LOCK_UNLOCKED(x.queue_lock), \
+		.queue_empty = COMPLETION_INITIALIZER(x.queue_empty), \
+		.nodes = LIST_HEAD_INIT(x.nodes), \
+	}
+
+/* internal function, exposed only to allow inline public functions */
+extern int track_add_task(struct tracker *track, enum track_task_id task_id,
+		unsigned long type, const void *id, void *data, bool sync);
+
+/**
+ * track_register - register track callback
+ * @track: pointer to tracker main structure
+ * @itb: block containing registered callback
+ * @type: tracked object type, defined by user
+ * @id: object id
+ *
+ * track_register registers callback which will receive notifications about
+ * presence of object identified by pair (@type, @id). If during registration
+ * tracked object is present, notification callback will be sent immediately.
+ */
+static inline int track_register(struct tracker *track, struct track_block *itb,
+		unsigned long type, const void *id)
+{
+	return track_add_task(track, track_task_register, type, id, itb,
+				false);
+}
+
+/**
+ * track_unregister - unregister track callback
+ * @track: pointer to tracker main structure
+ * @itb: block containing registered callback
+ * @type: tracked object type
+ * @id: object id
+ *
+ * track_unregister unregisters previously registered callback. If during
+ * unregistration tracked object is present, notification is send immediately.
+ */
+static inline int track_unregister(struct tracker *track,
+		struct track_block *itb, unsigned long type, const void *id)
+{
+	return track_add_task(track, track_task_unregister, type, id, itb,
+				true);
+}
+
+/**
+ * track_up - notifies about object appearance
+ * @track: pointer to tracker main structure
+ * @type: tracked object type
+ * @id: object id
+ * @data: optional data pointer, usually it should be object pointer
+ *
+ * track_up sends notification about object appearance to all callbacks
+ * registered to track this object. It should be called after the object is
+ * fully created. It is up to provider to synchronize calls to track_up and
+ * track_down for given object.
+ */
+static inline int track_up(struct tracker *track, unsigned long type,
+		const void *id, void *data)
+{
+	return track_add_task(track, track_task_up, type, id, data, false);
+}
+
+/**
+ * track_down - notifies about object disappearance
+ * @track: pointer to tracker main structure
+ * @type: tracked object type
+ * @id: object id
+ * @data: optional data pointer, usually it should be object pointer
+ *
+ * track_up sends notification about object disappearance to all callbacks
+ * registered to track this object. It should be called before the object is
+ * destroyed. It is up to provider to synchronize calls to track_up and
+ * track_down for given object.
+ */
+static inline int track_down(struct tracker *track, unsigned long type,
+		const void *id, void *data)
+{
+	return track_add_task(track, track_task_down, type, id, data,
+				true);
+}
+
+#endif /* TRACK_H */
-- 
1.9.1

