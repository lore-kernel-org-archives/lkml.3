Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756102Ab3ENBUy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 21:20:54 -0400
Received: from mail-pb0-f50.google.com ([209.85.160.50]:35662 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755939Ab3ENBT1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 21:19:27 -0400
From: Kent Overstreet <koverstreet@google.com>
To: linux-kernel@vger.kernel.org, linux-fsdevel@vger.kernel.org,
        linux-aio@kvack.org
Cc: akpm@linux-foundation.org, Kent Overstreet <koverstreet@google.com>,
        Tejun Heo <tj@kernel.org>, Oleg Nesterov <oleg@redhat.com>,
        Christoph Lameter <cl@linux-foundation.org>,
        Ingo Molnar <mingo@redhat.com>
Subject: [PATCH 17/21] Percpu tag allocator
Date: Mon, 13 May 2013 18:18:54 -0700
Message-Id: <1368494338-7069-18-git-send-email-koverstreet@google.com>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1368494338-7069-1-git-send-email-koverstreet@google.com>
References: <1368494338-7069-1-git-send-email-koverstreet@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Allocates integers out of a predefined range - for use by e.g. a driver
to allocate tags for communicating with the device.

Signed-off-by: Kent Overstreet <koverstreet@google.com>
Cc: Tejun Heo <tj@kernel.org>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Christoph Lameter <cl@linux-foundation.org>
Cc: Ingo Molnar <mingo@redhat.com>
---
 include/linux/tags.h |  38 ++++++++++++
 lib/Kconfig          |   3 +
 lib/Makefile         |   2 +-
 lib/tags.c           | 167 +++++++++++++++++++++++++++++++++++++++++++++++++++
 4 files changed, 209 insertions(+), 1 deletion(-)
 create mode 100644 include/linux/tags.h
 create mode 100644 lib/tags.c

diff --git a/include/linux/tags.h b/include/linux/tags.h
new file mode 100644
index 0000000..1b8cfca
--- /dev/null
+++ b/include/linux/tags.h
@@ -0,0 +1,38 @@
+/*
+ * Copyright 2012 Google Inc. All Rights Reserved.
+ * Author: koverstreet@google.com (Kent Overstreet)
+ *
+ * Per cpu tag allocator.
+ */
+
+#ifndef _LINUX_TAGS_H
+#define _LINUX_TAGS_H
+
+#include <linux/list.h>
+#include <linux/spinlock.h>
+
+struct tag_cpu_freelist;
+
+struct tag_pool {
+	unsigned			watermark;
+	unsigned			nr_tags;
+
+	struct tag_cpu_freelist		*tag_cpu;
+
+	struct {
+		/* Global freelist */
+		unsigned		nr_free;
+		unsigned		*free;
+		spinlock_t		lock;
+		struct list_head	wait;
+	} ____cacheline_aligned;
+};
+
+unsigned tag_alloc(struct tag_pool *pool, bool wait);
+void tag_free(struct tag_pool *pool, unsigned tag);
+
+void tag_pool_free(struct tag_pool *pool);
+int tag_pool_init(struct tag_pool *pool, unsigned long nr_tags);
+
+
+#endif
diff --git a/lib/Kconfig b/lib/Kconfig
index fe01d41..fa77e31 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -407,4 +407,7 @@ config OID_REGISTRY
 config UCS2_STRING
         tristate
 
+config PERCPU_TAG
+	bool
+
 endmenu
diff --git a/lib/Makefile b/lib/Makefile
index 25a0ce1..c622107 100644
--- a/lib/Makefile
+++ b/lib/Makefile
@@ -13,7 +13,7 @@ lib-y := ctype.o string.o vsprintf.o cmdline.o \
 	 sha1.o md5.o irq_regs.o reciprocal_div.o argv_split.o \
 	 proportions.o flex_proportions.o prio_heap.o ratelimit.o show_mem.o \
 	 is_single_threaded.o plist.o decompress.o kobject_uevent.o \
-	 earlycpio.o percpu-refcount.o
+	 earlycpio.o percpu-refcount.o tags.o
 
 obj-$(CONFIG_ARCH_HAS_DEBUG_STRICT_USER_COPY_CHECKS) += usercopy.o
 lib-$(CONFIG_MMU) += ioremap.o
diff --git a/lib/tags.c b/lib/tags.c
new file mode 100644
index 0000000..5c3de28
--- /dev/null
+++ b/lib/tags.c
@@ -0,0 +1,167 @@
+/*
+ * Copyright 2012 Google Inc. All Rights Reserved.
+ * Author: koverstreet@google.com (Kent Overstreet)
+ *
+ * Per cpu tag allocator.
+ */
+
+#include <linux/gfp.h>
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/tags.h>
+
+struct tag_cpu_freelist {
+	unsigned			nr_free;
+	unsigned			free[];
+};
+
+struct tag_waiter {
+	struct list_head		list;
+	struct task_struct		*task;
+};
+
+static inline void move_tags(unsigned *dst, unsigned *dst_nr,
+			     unsigned *src, unsigned *src_nr,
+			     unsigned nr)
+{
+	*src_nr -= nr;
+	memcpy(dst + *dst_nr, src + *src_nr, sizeof(unsigned) * nr);
+	*dst_nr += nr;
+}
+
+unsigned tag_alloc(struct tag_pool *pool, bool wait)
+{
+	struct tag_cpu_freelist *tags;
+	unsigned long flags;
+	unsigned ret;
+retry:
+	preempt_disable();
+	local_irq_save(flags);
+	tags = this_cpu_ptr(pool->tag_cpu);
+
+	while (!tags->nr_free) {
+		spin_lock(&pool->lock);
+
+		if (pool->nr_free)
+			move_tags(tags->free, &tags->nr_free,
+				  pool->free, &pool->nr_free,
+				  min(pool->nr_free, pool->watermark));
+		else if (wait) {
+			struct tag_waiter wait = { .task = current };
+
+			__set_current_state(TASK_UNINTERRUPTIBLE);
+			list_add(&wait.list, &pool->wait);
+
+			spin_unlock(&pool->lock);
+			local_irq_restore(flags);
+			preempt_enable();
+
+			schedule();
+			__set_current_state(TASK_RUNNING);
+
+			if (!list_empty_careful(&wait.list)) {
+				spin_lock_irqsave(&pool->lock, flags);
+				list_del_init(&wait.list);
+				spin_unlock_irqrestore(&pool->lock, flags);
+			}
+
+			goto retry;
+		} else
+			goto fail;
+
+		spin_unlock(&pool->lock);
+	}
+
+	ret = tags->free[--tags->nr_free];
+
+	local_irq_restore(flags);
+	preempt_enable();
+
+	return ret;
+fail:
+	local_irq_restore(flags);
+	preempt_enable();
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tag_alloc);
+
+void tag_free(struct tag_pool *pool, unsigned tag)
+{
+	struct tag_cpu_freelist *tags;
+	unsigned long flags;
+
+	preempt_disable();
+	local_irq_save(flags);
+	tags = this_cpu_ptr(pool->tag_cpu);
+
+	tags->free[tags->nr_free++] = tag;
+
+	if (tags->nr_free == pool->watermark * 2) {
+		spin_lock(&pool->lock);
+
+		move_tags(pool->free, &pool->nr_free,
+			  tags->free, &tags->nr_free,
+			  pool->watermark);
+
+		while (!list_empty(&pool->wait)) {
+			struct tag_waiter *wait;
+			wait = list_first_entry(&pool->wait,
+						struct tag_waiter, list);
+			list_del_init(&wait->list);
+			wake_up_process(wait->task);
+		}
+
+		spin_unlock(&pool->lock);
+	}
+
+	local_irq_restore(flags);
+	preempt_enable();
+}
+EXPORT_SYMBOL_GPL(tag_free);
+
+void tag_pool_free(struct tag_pool *pool)
+{
+	free_percpu(pool->tag_cpu);
+
+	free_pages((unsigned long) pool->free,
+		   get_order(pool->nr_tags * sizeof(unsigned)));
+}
+EXPORT_SYMBOL_GPL(tag_pool_free);
+
+int tag_pool_init(struct tag_pool *pool, unsigned long nr_tags)
+{
+	unsigned i, order;
+
+	spin_lock_init(&pool->lock);
+	INIT_LIST_HEAD(&pool->wait);
+	pool->nr_tags = nr_tags;
+
+	/* Guard against overflow */
+	if (nr_tags > UINT_MAX)
+		return -ENOMEM;
+
+	order = get_order(nr_tags * sizeof(unsigned));
+	pool->free = (void *) __get_free_pages(GFP_KERNEL, order);
+	if (!pool->free)
+		return -ENOMEM;
+
+	for (i = 1; i < nr_tags; i++)
+		pool->free[pool->nr_free++] = i;
+
+	/* nr_possible_cpus would be more correct */
+	pool->watermark = nr_tags / (num_possible_cpus() * 4);
+
+	pool->watermark = min(pool->watermark, 128);
+
+	if (pool->watermark > 64)
+		pool->watermark = round_down(pool->watermark, 32);
+
+	pool->tag_cpu = __alloc_percpu(sizeof(struct tag_cpu_freelist) +
+				       pool->watermark * 2 * sizeof(unsigned),
+				       sizeof(unsigned));
+	if (!pool->tag_cpu)
+		return -ENOMEM;
+
+	return 0;
+}
+EXPORT_SYMBOL_GPL(tag_pool_init);
-- 
1.8.2.1

