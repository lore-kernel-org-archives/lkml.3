Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758044AbaD2Ozh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 10:55:37 -0400
Received: from mail-pd0-f180.google.com ([209.85.192.180]:35514 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757976AbaD2Ozf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 10:55:35 -0400
From: Ming Lei <tom.leiming@gmail.com>
To: Jens Axboe <axboe@kernel.dk>, linux-kernel@vger.kernel.org,
        Kent Overstreet <kmo@daterainc.com>
Cc: Christoph Hellwig <hch@lst.de>, Shaohua Li <shli@kernel.org>,
        Nicholas Bellinger <nab@linux-iscsi.org>,
        Nick Swenson <nks@daterainc.com>, Ming Lei <tom.leiming@gmail.com>
Subject: [PATCH 1/3] percpu_ida: introduce kobject for percpu_ida pool
Date: Tue, 29 Apr 2014 22:53:51 +0800
Message-Id: <1398783234-7062-2-git-send-email-tom.leiming@gmail.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
References: <1398783234-7062-1-git-send-email-tom.leiming@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

So that we can export some allocation/free information
for monitoring percpu_ida performance.

Signed-off-by: Ming Lei <tom.leiming@gmail.com>
---
 include/linux/percpu_ida.h |   16 ++++++++++++++++
 lib/percpu_ida.c           |   21 ++++++++++++++++++---
 2 files changed, 34 insertions(+), 3 deletions(-)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index f5cfdd6..463e3b3 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -8,6 +8,7 @@
 #include <linux/spinlock_types.h>
 #include <linux/wait.h>
 #include <linux/cpumask.h>
+#include <linux/kobject.h>
 
 struct percpu_ida_cpu;
 
@@ -52,6 +53,8 @@ struct percpu_ida {
 		unsigned		nr_free;
 		unsigned		*freelist;
 	} ____cacheline_aligned_in_smp;
+
+	struct kobject kobj;
 };
 
 /*
@@ -79,4 +82,17 @@ int percpu_ida_for_each_free(struct percpu_ida *pool, percpu_ida_cb fn,
 	void *data);
 
 unsigned percpu_ida_free_tags(struct percpu_ida *pool, int cpu);
+
+static inline int percpu_ida_kobject_add(struct percpu_ida *pool,
+		struct kobject *parent, const char *name)
+{
+	if (pool->kobj.state_initialized)
+		return kobject_add(&pool->kobj, parent, name);
+	return 0;
+}
+static inline void percpu_ida_kobject_del(struct percpu_ida *pool)
+{
+	if (pool->kobj.state_in_sysfs)
+		kobject_del(&pool->kobj);
+}
 #endif /* __PERCPU_IDA_H__ */
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 93d145e..56ae350 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -260,6 +260,20 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag)
 }
 EXPORT_SYMBOL_GPL(percpu_ida_free);
 
+static void percpu_ida_release(struct kobject *kobj)
+{
+	struct percpu_ida *pool = container_of(kobj,
+			struct percpu_ida, kobj);
+
+	free_percpu(pool->tag_cpu);
+	free_pages((unsigned long) pool->freelist,
+		   get_order(pool->nr_tags * sizeof(unsigned)));
+}
+
+static struct kobj_type percpu_ida_ktype = {
+	.release        = percpu_ida_release,
+};
+
 /**
  * percpu_ida_destroy - release a tag pool's resources
  * @pool: pool to free
@@ -268,9 +282,8 @@ EXPORT_SYMBOL_GPL(percpu_ida_free);
  */
 void percpu_ida_destroy(struct percpu_ida *pool)
 {
-	free_percpu(pool->tag_cpu);
-	free_pages((unsigned long) pool->freelist,
-		   get_order(pool->nr_tags * sizeof(unsigned)));
+	if (pool->kobj.state_initialized)
+		kobject_put(&pool->kobj);
 }
 EXPORT_SYMBOL_GPL(percpu_ida_destroy);
 
@@ -324,6 +337,8 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
 	for_each_possible_cpu(cpu)
 		spin_lock_init(&per_cpu_ptr(pool->tag_cpu, cpu)->lock);
 
+	kobject_init(&pool->kobj, &percpu_ida_ktype);
+
 	return 0;
 err:
 	percpu_ida_destroy(pool);
-- 
1.7.9.5

