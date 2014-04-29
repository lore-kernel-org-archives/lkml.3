Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758056AbaD2Oz6 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:55:58 -0400
Received: from mail-pa0-f54.google.com ([209.85.220.54]:38082 "EHLO
	mail-pa0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757552AbaD2Oz4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:55:56 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nick Swenson <nks@daterainc.com>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 2/3] percpu_ida: support exporting allocation/free info via sysfs
Date: Tue, 29 Apr 2014 22:53:52 +0800
Message-Id: <1398783234-7062-3-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
References: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

With this information, it is easy to monitor percpu_ida
performance.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/percpu_ida.h |   24 ++++++++
 lib/Kconfig                |    7 +++
 lib/percpu_ida.c           |  130 +++++++++++++++++++++++++++++++++++++++++++-
 3 files changed, 159 insertions(+), 2 deletions(-)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 463e3b3..be1036d 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -12,6 +12,27 @@
 
 struct percpu_ida_cpu;
 
+#ifdef CONFIG_PERCPU_IDA_STATS
+struct percpu_ida_stats {
+	u64 alloc_tags;
+	u64 alloc_in_fastpath;
+	u64 alloc_from_global_pool;
+	u64 alloc_by_stealing;
+	u64 alloc_after_sched;
+
+	u64 freed_tags;
+	u64 freed_empty;
+	u64 freed_full;
+};
+
+#define percpu_ida_inc(pool, ptr)		\
+do {						\
+	__this_cpu_inc(pool->stats->ptr);	\
+} while (0)
+#else
+#define percpu_ida_inc(pool, ptr)	do {} while (0)
+#endif
+
 struct percpu_ida {
 	/*
 	 * number of tags available to be allocated, as passed to
@@ -55,6 +76,9 @@ struct percpu_ida {
 	} ____cacheline_aligned_in_smp;
 
 	struct kobject kobj;
+#ifdef CONFIG_PERCPU_IDA_STATS
+	struct percpu_ida_stats __percpu *stats;
+#endif
 };
 
 /*
diff --git a/lib/Kconfig b/lib/Kconfig
index 325a8d4..d47a1cf 100644
--- a/lib/Kconfig
+++ b/lib/Kconfig
@@ -476,6 +476,13 @@ config OID_REGISTRY
 	help
 	  Enable fast lookup object identifier registry.
 
+config PERCPU_IDA_STATS
+	bool "Export percpu_ida status by sysfs"
+	default n
+	help
+	  Export percpu_ida allocation/free information so
+	  the performance can be monitored.
+
 config UCS2_STRING
         tristate
 
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 56ae350..6f6c68d 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -42,6 +42,105 @@ struct percpu_ida_cpu {
 	unsigned			freelist[];
 };
 
+#ifdef CONFIG_PERCPU_IDA_STATS
+struct pcpu_ida_sysfs_entry {
+	struct attribute attr;
+	ssize_t (*show)(struct percpu_ida *, char *);
+};
+
+#define pcpu_ida_show(field, fmt)					\
+static ssize_t field##_show(struct percpu_ida *pool, char *buf)		\
+{									\
+	u64 val = 0;							\
+	ssize_t rc;							\
+	unsigned cpu;							\
+									\
+	for_each_possible_cpu(cpu)					\
+		val += per_cpu_ptr(pool->stats, cpu)->field;		\
+									\
+	rc = sprintf(buf, fmt, val);					\
+	return rc;							\
+}
+
+#define PERCPU_IDA_ATTR_RO(_name)		\
+	struct pcpu_ida_sysfs_entry pcpu_ida_attr_##_name = __ATTR_RO(_name)
+
+#define pcpu_ida_attr_ro(field, fmt)		\
+	pcpu_ida_show(field, fmt)		\
+	static PERCPU_IDA_ATTR_RO(field)
+
+pcpu_ida_attr_ro(alloc_tags, "%lld\n");
+pcpu_ida_attr_ro(alloc_in_fastpath, "%lld\n");
+pcpu_ida_attr_ro(alloc_from_global_pool, "%lld\n");
+pcpu_ida_attr_ro(alloc_by_stealing, "%lld\n");
+pcpu_ida_attr_ro(alloc_after_sched, "%lld\n");
+pcpu_ida_attr_ro(freed_tags, "%lld\n");
+pcpu_ida_attr_ro(freed_empty, "%lld\n");
+pcpu_ida_attr_ro(freed_full, "%lld\n");
+
+ssize_t pcpu_ida_sysfs_max_size_show(struct percpu_ida *pool, char *page)
+{
+	ssize_t rc = sprintf(page, "%u\n", pool->percpu_max_size);
+	return rc;
+}
+
+static struct pcpu_ida_sysfs_entry pcpu_ida_attr_max_size = {
+	.attr = {.name = "percpu_max_size", .mode = S_IRUGO},
+	.show = pcpu_ida_sysfs_max_size_show,
+};
+
+ssize_t pcpu_ida_sysfs_batch_size_show(struct percpu_ida *pool, char *page)
+{
+	ssize_t rc = sprintf(page, "%u\n", pool->percpu_batch_size);
+	return rc;
+}
+
+static struct pcpu_ida_sysfs_entry pcpu_ida_attr_batch_size = {
+	.attr = {.name = "percpu_batch_size", .mode = S_IRUGO},
+	.show = pcpu_ida_sysfs_batch_size_show,
+};
+
+static ssize_t percpu_ida_sysfs_show(struct kobject *kobj,
+		struct attribute *attr, char *page)
+{
+	struct pcpu_ida_sysfs_entry *entry;
+	struct percpu_ida *pool;
+	ssize_t res = -EIO;
+
+	entry = container_of(attr, struct pcpu_ida_sysfs_entry, attr);
+	pool = container_of(kobj, struct percpu_ida, kobj);
+
+	if (!entry->show)
+		return res;
+	res = entry->show(pool, page);
+	return res;
+}
+
+static struct attribute *percpu_ida_def_attrs[] = {
+	&pcpu_ida_attr_alloc_tags.attr,
+	&pcpu_ida_attr_alloc_in_fastpath.attr,
+	&pcpu_ida_attr_alloc_from_global_pool.attr,
+	&pcpu_ida_attr_alloc_by_stealing.attr,
+	&pcpu_ida_attr_alloc_after_sched.attr,
+	&pcpu_ida_attr_freed_tags.attr,
+	&pcpu_ida_attr_freed_empty.attr,
+	&pcpu_ida_attr_freed_full.attr,
+	&pcpu_ida_attr_max_size.attr,
+	&pcpu_ida_attr_batch_size.attr,
+	NULL,
+};
+#else
+static ssize_t percpu_ida_sysfs_show(struct kobject *kobj,
+		struct attribute *attr, char *page)
+{
+	return -EIO;
+}
+
+static struct attribute *percpu_ida_def_attrs[] = {
+	NULL,
+};
+#endif
+
 static inline void move_tags(unsigned *dst, unsigned *dst_nr,
 			     unsigned *src, unsigned *src_nr,
 			     unsigned nr)
@@ -154,9 +253,12 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
 	local_irq_save(flags);
 	tags = this_cpu_ptr(pool->tag_cpu);
 
+	percpu_ida_inc(pool, alloc_tags);
+
 	/* Fastpath */
 	tag = alloc_local_tag(tags);
 	if (likely(tag >= 0)) {
+		percpu_ida_inc(pool, alloc_in_fastpath);
 		local_irq_restore(flags);
 		return tag;
 	}
@@ -174,10 +276,15 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
 		if (state != TASK_RUNNING)
 			prepare_to_wait(&pool->wait, &wait, state);
 
-		if (!tags->nr_free)
+		if (!tags->nr_free) {
+			percpu_ida_inc(pool, alloc_from_global_pool);
 			alloc_global_tags(pool, tags);
-		if (!tags->nr_free)
+		}
+
+		if (!tags->nr_free) {
 			steal_tags(pool, tags);
+			percpu_ida_inc(pool, alloc_by_stealing);
+		}
 
 		if (tags->nr_free) {
 			tag = tags->freelist[--tags->nr_free];
@@ -197,6 +304,7 @@ int percpu_ida_alloc(struct percpu_ida *pool, int state)
 			break;
 		}
 
+		percpu_ida_inc(pool, alloc_after_sched);
 		schedule();
 
 		local_irq_save(flags);
@@ -227,6 +335,8 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	local_irq_save(flags);
 	tags = this_cpu_ptr(pool->tag_cpu);
 
+	percpu_ida_inc(pool, freed_tags);
+
 	spin_lock(&tags->lock);
 	tags->freelist[tags->nr_free++] = tag;
 
@@ -234,12 +344,14 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 	spin_unlock(&tags->lock);
 
 	if (nr_free == 1) {
+		percpu_ida_inc(pool, freed_empty);
 		cpumask_set_cpu(smp_processor_id(),
 				&pool->cpus_have_tags);
 		wake_up(&pool->wait);
 	}
 
 	if (nr_free == pool->percpu_max_size) {
+		percpu_ida_inc(pool, freed_full);
 		spin_lock(&pool->lock);
 
 		/*
@@ -265,13 +377,22 @@ static void percpu_ida_release(struct kobject *kobj)
 	struct percpu_ida *pool = container_of(kobj,
 			struct percpu_ida, kobj);
 
+#ifdef CONFIG_PERCPU_IDA_STATS
+	free_percpu(pool->stats);
+#endif
 	free_percpu(pool->tag_cpu);
 	free_pages((unsigned long) pool->freelist,
 		   get_order(pool->nr_tags * sizeof(unsigned)));
 }
 
+static struct sysfs_ops percpu_ida_sysfs_ops = {
+	.show	= percpu_ida_sysfs_show,
+};
+
 static struct kobj_type percpu_ida_ktype = {
+	.sysfs_ops	= &percpu_ida_sysfs_ops,
 	.release        = percpu_ida_release,
+	.default_attrs  = percpu_ida_def_attrs,
 };
 
 /**
@@ -339,6 +460,11 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
 
 	kobject_init(&pool->kobj, &percpu_ida_ktype);
 
+#ifdef CONFIG_PERCPU_IDA_STATS
+	pool->stats = alloc_percpu(struct percpu_ida_stats);
+	if (!pool->stats)
+		goto err;
+#endif
 	return 0;
 err:
 	percpu_ida_destroy(pool);
-- 
1.7.9.5

