Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710Ab3AOMeo (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jan 2013 07:34:44 -0500
Received: from mail-wg0-f54.google.com ([74.125.82.54]:59475 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756564Ab3AOMeh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jan 2013 07:34:37 -0500
From: Maarten Lankhorst <m.b.lankhorst@gmail.com>
To: dri-devel@lists.freedesktop.org, linux-kernel@vger.kernel.org,
        linux-media@vger.kernel.org, linaro-mm-sig@lists.linaro.org
Cc: Maarten Lankhorst <maarten.lankhorst@canonical.com>
Subject: [PATCH 6/7] reservation: cross-device reservation support
Date: Tue, 15 Jan 2013 13:34:03 +0100
Message-Id: <1358253244-11453-7-git-send-email-maarten.lankhorst@canonical.com>
X-Mailer: git-send-email 1.8.0.3
In-Reply-To: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
References: <1358253244-11453-1-git-send-email-maarten.lankhorst@canonical.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This adds support for a generic reservations framework that can be
hooked up to ttm and dma-buf and allows easy sharing of reservations
across devices.

The idea is that a dma-buf and ttm object both will get a pointer
to a struct reservation_object, which has to be reserved before
anything is done with the contents of the dma-buf.

Signed-off-by: Maarten Lankhorst <maarten.lankhorst@canonical.com>
---
 Documentation/DocBook/device-drivers.tmpl |   2 +
 drivers/base/Makefile                     |   2 +-
 drivers/base/reservation.c                | 251 ++++++++++++++++++++++++++++++
 include/linux/reservation.h               | 182 ++++++++++++++++++++++
 4 files changed, 436 insertions(+), 1 deletion(-)
 create mode 100644 drivers/base/reservation.c
 create mode 100644 include/linux/reservation.h

diff --git a/Documentation/DocBook/device-drivers.tmpl b/Documentation/DocBook/device-drivers.tmpl
index ad14396..24e6e80 100644
--- a/Documentation/DocBook/device-drivers.tmpl
+++ b/Documentation/DocBook/device-drivers.tmpl
@@ -129,6 +129,8 @@ X!Edrivers/base/interface.c
 !Edrivers/base/fence.c
 !Iinclude/linux/fence.h
 !Iinclude/linux/seqno-fence.h
+!Edrivers/base/reservation.c
+!Iinclude/linux/reservation.h
 !Edrivers/base/dma-coherent.c
 !Edrivers/base/dma-mapping.c
      </sect1>
diff --git a/drivers/base/Makefile b/drivers/base/Makefile
index 0026563..f6f731d 100644
--- a/drivers/base/Makefile
+++ b/drivers/base/Makefile
@@ -10,7 +10,7 @@ obj-$(CONFIG_CMA) += dma-contiguous.o
 obj-y			+= power/
 obj-$(CONFIG_HAS_DMA)	+= dma-mapping.o
 obj-$(CONFIG_HAVE_GENERIC_DMA_COHERENT) += dma-coherent.o
-obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o fence.o
+obj-$(CONFIG_DMA_SHARED_BUFFER) += dma-buf.o fence.o reservation.o
 obj-$(CONFIG_ISA)	+= isa.o
 obj-$(CONFIG_FW_LOADER)	+= firmware_class.o
 obj-$(CONFIG_NUMA)	+= node.o
diff --git a/drivers/base/reservation.c b/drivers/base/reservation.c
new file mode 100644
index 0000000..07584dd
--- /dev/null
+++ b/drivers/base/reservation.c
@@ -0,0 +1,251 @@
+/*
+ * Copyright (C) 2012 Canonical Ltd
+ *
+ * Based on bo.c which bears the following copyright notice,
+ * but is dual licensed:
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ *
+ **************************************************************************/
+/*
+ * Authors: Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ */
+
+#include <linux/fence.h>
+#include <linux/reservation.h>
+#include <linux/export.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+
+atomic_long_t reservation_counter = ATOMIC_LONG_INIT(1);
+EXPORT_SYMBOL(reservation_counter);
+
+const char reservation_object_name[] = "reservation_object";
+EXPORT_SYMBOL(reservation_object_name);
+
+const char reservation_ticket_name[] = "reservation_ticket";
+EXPORT_SYMBOL(reservation_ticket_name);
+
+struct lock_class_key reservation_object_class;
+EXPORT_SYMBOL(reservation_object_class);
+
+struct lock_class_key reservation_ticket_class;
+EXPORT_SYMBOL(reservation_ticket_class);
+
+/**
+ * ticket_backoff - cancel a reservation
+ * @ticket:	[in] a reservation_ticket
+ * @entries:	[in] the list list of reservation_entry entries to unreserve
+ *
+ * This function cancels a previous reservation done by
+ * ticket_reserve. This is useful in case something
+ * goes wrong between reservation and committing.
+ *
+ * This should only be called after ticket_reserve returns success.
+ */
+void
+ticket_backoff(struct reservation_ticket *ticket, struct list_head *entries)
+{
+	struct list_head *cur;
+
+	if (list_empty(entries))
+		return;
+
+	list_for_each(cur, entries) {
+		struct reservation_object *obj;
+
+		reservation_entry_get(cur, &obj, NULL);
+
+		mutex_unreserve_unlock(&obj->lock);
+	}
+	reservation_ticket_fini(ticket);
+}
+EXPORT_SYMBOL(ticket_backoff);
+
+static void
+ticket_backoff_early(struct list_head *list, struct reservation_entry *entry)
+{
+	list_for_each_entry_continue_reverse(entry, list, head) {
+		struct reservation_object *obj;
+
+		reservation_entry_get(&entry->head, &obj, NULL);
+		mutex_unreserve_unlock(&obj->lock);
+	}
+}
+
+/**
+ * ticket_reserve - reserve a list of reservation_entry
+ * @ticket:	[out]	a reservation_ticket
+ * @entries:	[in]	a list of entries to reserve.
+ *
+ * Do not initialize ticket, it will be initialized by this function
+ * on success.
+ *
+ * Returns -EINTR if signal got queued, -EINVAL if fence list is full,
+ * -EDEADLK if buffer appears on the list twice, 0 on success.
+ *
+ * XXX: Nuke rest
+ * The caller will have to queue waits on those fences before calling
+ * ufmgr_fence_buffer_objects, with either hardware specific methods,
+ * fence_add_callback will, or fence_wait.
+ *
+ * As such, by incrementing refcount on reservation_entry before calling
+ * fence_add_callback, and making the callback decrement refcount on
+ * reservation_entry, or releasing refcount if fence_add_callback
+ * failed, the reservation_entry will be freed when all the fences
+ * have been signaled, and only after the last ref is released, which should
+ * be after ufmgr_fence_buffer_objects. With proper locking, when the
+ * list_head holding the list of reservation_entry's becomes empty it
+ * indicates all fences for all bufs have been signaled.
+ */
+int
+ticket_reserve(struct reservation_ticket *ticket,
+		   struct list_head *entries)
+{
+	struct list_head *cur;
+	int ret;
+	struct reservation_object *res_bo = NULL;
+
+	if (list_empty(entries))
+		return 0;
+
+	reservation_ticket_init(ticket);
+retry:
+	list_for_each(cur, entries) {
+		struct reservation_entry *entry;
+		struct reservation_object *bo;
+		bool shared;
+
+		entry = reservation_entry_get(cur, &bo, &shared);
+		if (unlikely(res_bo == bo)) {
+			res_bo = NULL;
+			continue;
+		}
+
+		ret = mutex_reserve_lock_interruptible(&bo->lock,
+						       ticket,
+						       ticket->seqno);
+		switch (ret) {
+		case 0:
+			break;
+		case -EAGAIN:
+			ticket_backoff_early(entries, entry);
+			if (res_bo)
+				mutex_unreserve_unlock(&res_bo->lock);
+
+			ret = mutex_reserve_lock_intr_slow(&bo->lock, ticket,
+							   ticket->seqno);
+			if (unlikely(ret != 0))
+				goto err_fini;
+			res_bo = bo;
+			break;
+		default:
+			goto err;
+		}
+
+		if (shared &&
+		    bo->fence_shared_count == BUF_MAX_SHARED_FENCE) {
+			WARN_ON_ONCE(1);
+			ret = -EINVAL;
+			mutex_unreserve_unlock(&bo->lock);
+			goto err;
+		}
+		if (unlikely(res_bo == bo))
+			goto retry;
+		continue;
+
+err:
+		if (res_bo != bo)
+			mutex_unreserve_unlock(&bo->lock);
+		ticket_backoff_early(entries, entry);
+err_fini:
+		reservation_ticket_fini(ticket);
+		return ret;
+	}
+
+	return 0;
+}
+EXPORT_SYMBOL(ticket_reserve);
+
+/**
+ * ticket_commit - commit a reservation with a new fence
+ * @ticket:	[in]	the reservation_ticket returned by
+ * ticket_reserve
+ * @entries:	[in]	a linked list of struct reservation_entry
+ * @fence:	[in]	the fence that indicates completion
+ *
+ * This function will call reservation_ticket_fini, no need
+ * to do it manually.
+ *
+ * This function should be called after a hardware command submission is
+ * completed succesfully. The fence is used to indicate completion of
+ * those commands.
+ */
+void
+ticket_commit(struct reservation_ticket *ticket,
+		  struct list_head *entries, struct fence *fence)
+{
+	struct list_head *cur;
+
+	if (list_empty(entries))
+		return;
+
+	if (WARN_ON(!fence)) {
+		ticket_backoff(ticket, entries);
+		return;
+	}
+
+	list_for_each(cur, entries) {
+		struct reservation_object *bo;
+		bool shared;
+
+		reservation_entry_get(cur, &bo, &shared);
+
+		if (!shared) {
+			int i;
+			for (i = 0; i < bo->fence_shared_count; ++i) {
+				fence_put(bo->fence_shared[i]);
+				bo->fence_shared[i] = NULL;
+			}
+			bo->fence_shared_count = 0;
+			if (bo->fence_excl)
+				fence_put(bo->fence_excl);
+
+			bo->fence_excl = fence;
+		} else {
+			if (WARN_ON(bo->fence_shared_count >=
+				    ARRAY_SIZE(bo->fence_shared))) {
+				mutex_unreserve_unlock(&bo->lock);
+				continue;
+			}
+
+			bo->fence_shared[bo->fence_shared_count++] = fence;
+		}
+		fence_get(fence);
+
+		mutex_unreserve_unlock(&bo->lock);
+	}
+	reservation_ticket_fini(ticket);
+}
+EXPORT_SYMBOL(ticket_commit);
diff --git a/include/linux/reservation.h b/include/linux/reservation.h
new file mode 100644
index 0000000..fc2349d
--- /dev/null
+++ b/include/linux/reservation.h
@@ -0,0 +1,182 @@
+/*
+ * Header file for reservations for dma-buf and ttm
+ *
+ * Copyright(C) 2011 Linaro Limited. All rights reserved.
+ * Copyright (C) 2012 Canonical Ltd
+ * Copyright (C) 2012 Texas Instruments
+ *
+ * Authors:
+ * Rob Clark <rob.clark@linaro.org>
+ * Maarten Lankhorst <maarten.lankhorst@canonical.com>
+ * Thomas Hellstrom <thellstrom-at-vmware-dot-com>
+ *
+ * Based on bo.c which bears the following copyright notice,
+ * but is dual licensed:
+ *
+ * Copyright (c) 2006-2009 VMware, Inc., Palo Alto, CA., USA
+ * All Rights Reserved.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the
+ * "Software"), to deal in the Software without restriction, including
+ * without limitation the rights to use, copy, modify, merge, publish,
+ * distribute, sub license, and/or sell copies of the Software, and to
+ * permit persons to whom the Software is furnished to do so, subject to
+ * the following conditions:
+ *
+ * The above copyright notice and this permission notice (including the
+ * next paragraph) shall be included in all copies or substantial portions
+ * of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NON-INFRINGEMENT. IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDERS, AUTHORS AND/OR ITS SUPPLIERS BE LIABLE FOR ANY CLAIM,
+ * DAMAGES OR OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR
+ * OTHERWISE, ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE
+ * USE OR OTHER DEALINGS IN THE SOFTWARE.
+ */
+#ifndef _LINUX_RESERVATION_H
+#define _LINUX_RESERVATION_H
+
+#include <linux/spinlock.h>
+#include <linux/mutex.h>
+#include <linux/fence.h>
+
+#define BUF_MAX_SHARED_FENCE 8
+
+struct fence;
+
+extern atomic_long_t reservation_counter;
+extern const char reservation_object_name[];
+extern struct lock_class_key reservation_object_class;
+extern const char reservation_ticket_name[];
+extern struct lock_class_key reservation_ticket_class;
+
+struct reservation_object {
+	struct ticket_mutex lock;
+
+	u32 fence_shared_count;
+	struct fence *fence_excl;
+	struct fence *fence_shared[BUF_MAX_SHARED_FENCE];
+};
+
+struct reservation_ticket {
+	unsigned long seqno;
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	struct lockdep_map dep_map;
+#endif
+};
+
+/**
+ * struct reservation_entry - reservation structure for a
+ * reservation_object
+ * @head:	list entry
+ * @obj_shared:	pointer to a reservation_object to reserve
+ *
+ * Bit 0 of obj_shared is set to bool shared, as such pointer has to be
+ * converted back, which can be done with reservation_entry_get.
+ */
+struct reservation_entry {
+	struct list_head head;
+	unsigned long obj_shared;
+};
+
+
+static inline void
+reservation_object_init(struct reservation_object *obj)
+{
+	obj->fence_shared_count = 0;
+	obj->fence_excl = NULL;
+
+	__ticket_mutex_init(&obj->lock, reservation_object_name,
+			    &reservation_object_class);
+}
+
+static inline void
+reservation_object_fini(struct reservation_object *obj)
+{
+	int i;
+
+	if (obj->fence_excl)
+		fence_put(obj->fence_excl);
+	for (i = 0; i < obj->fence_shared_count; ++i)
+		fence_put(obj->fence_shared[i]);
+
+	mutex_destroy(&obj->lock.base);
+}
+
+static inline void
+reservation_ticket_init(struct reservation_ticket *t)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	/*
+	 * Make sure we are not reinitializing a held ticket:
+	 */
+
+	debug_check_no_locks_freed((void *)t, sizeof(*t));
+	lockdep_init_map(&t->dep_map, reservation_ticket_name,
+			 &reservation_ticket_class, 0);
+#endif
+	mutex_acquire(&t->dep_map, 0, 0, _THIS_IP_);
+	do {
+		t->seqno = atomic_long_inc_return(&reservation_counter);
+	} while (unlikely(!t->seqno));
+}
+
+/**
+ * reservation_ticket_fini - end a reservation ticket
+ * @t:	[in]	reservation_ticket that completed all reservations
+ *
+ * This currently does nothing, but should be called after all reservations
+ * made with this ticket have been unreserved. It is likely that in the future
+ * it will be hooked up to perf events, or aid in debugging in other ways.
+ */
+static inline void
+reservation_ticket_fini(struct reservation_ticket *t)
+{
+#ifdef CONFIG_DEBUG_LOCK_ALLOC
+	mutex_release(&t->dep_map, 0, _THIS_IP_);
+	t->seqno = 0;
+#endif
+}
+
+/**
+ * reservation_entry_init - initialize and append a reservation_entry
+ * to the list
+ * @entry:	entry to initialize
+ * @list:	list to append to
+ * @obj:	reservation_object to initialize the entry with
+ * @shared:	whether shared or exclusive access is requested
+ */
+static inline void
+reservation_entry_init(struct reservation_entry *entry,
+			   struct list_head *list,
+			   struct reservation_object *obj, bool shared)
+{
+	entry->obj_shared = (unsigned long)obj | !!shared;
+	list_add_tail(&entry->head, list);
+}
+
+static inline struct reservation_entry *
+reservation_entry_get(struct list_head *list,
+			  struct reservation_object **obj, bool *shared)
+{
+	struct reservation_entry *e = container_of(list, struct reservation_entry, head);
+	unsigned long val = e->obj_shared;
+
+	if (obj)
+		*obj = (struct reservation_object*)(val & ~1);
+	if (shared)
+		*shared = val & 1;
+	return e;
+}
+
+extern int ticket_reserve(struct reservation_ticket *,
+			  struct list_head *entries);
+extern void ticket_backoff(struct reservation_ticket *,
+			   struct list_head *entries);
+extern void ticket_commit(struct reservation_ticket *,
+			  struct list_head *entries, struct fence *);
+
+#endif /* _LINUX_RESERVATION_H */
-- 
1.8.0.3

