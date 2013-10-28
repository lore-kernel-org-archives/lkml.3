Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755563Ab3J1KEP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Oct 2013 06:04:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:55405 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756309Ab3J1KEN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Oct 2013 06:04:13 -0400
Date: Mon, 28 Oct 2013 11:06:21 +0100
From: Alexander Gordeev <agordeev@redhat.com>
To: Kent Overstreet <kmo@daterainc.com>
Cc: Oleg Nesterov <oleg@redhat.com>, Jens Axboe <axboe@kernel.dk>,
        "Nicholas A. Bellinger" <nab@linux-iscsi.org>,
        linux-kernel@vger.kernel.org
Subject: [PATCH 5/5] percpu_ida: Allow variable maximum number of cached tags
Message-ID: <20131028100620.GF5744@dhcp-26-207.brq.redhat.com>
References: <cover.1382950629.git.agordeev@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1382950629.git.agordeev@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently a threshold for stealing tags from remote CPUs
is set to a half of the total number of tags. However,
in general case this threshold is a function not only of
the total number of tags and maximum number of tags per
CPU, but also of a usage pattern. Just let percpu_ida
users decide how big this threshold value should be.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
---
 block/blk-mq-tag.c         |    9 +++++----
 include/linux/percpu_ida.h |    5 +++--
 lib/percpu_ida.c           |    7 +++++--
 3 files changed, 13 insertions(+), 8 deletions(-)

diff --git a/block/blk-mq-tag.c b/block/blk-mq-tag.c
index d64a02f..da0b3dd 100644
--- a/block/blk-mq-tag.c
+++ b/block/blk-mq-tag.c
@@ -145,10 +145,11 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 	tags->nr_max_cache = nr_cache;
 	tags->nr_batch_move = max(1u, nr_cache / 2);
 
-	ret = __percpu_ida_init(&tags->free_tags, tags->nr_tags -
-				tags->nr_reserved_tags,
+	ret = __percpu_ida_init(&tags->free_tags,
+				tags->nr_tags - tags->nr_reserved_tags,
 				tags->nr_max_cache,
-				tags->nr_batch_move);
+				tags->nr_batch_move,
+				(tags->nr_tags - tags->nr_reserved_tags) / 2);
 	if (ret)
 		goto err_free_tags;
 
@@ -158,7 +159,7 @@ struct blk_mq_tags *blk_mq_init_tags(unsigned int total_tags,
 		 * no cached. It's fine reserved tags allocation is slow.
 		 */
 		ret = __percpu_ida_init(&tags->reserved_tags, reserved_tags,
-				1, 1);
+				1, 1, 0);
 		if (ret)
 			goto err_reserved_tags;
 	}
diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index 1900bd0..d874cca 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -18,6 +18,7 @@ struct percpu_ida {
 	unsigned			nr_tags;
 	unsigned			percpu_max_size;
 	unsigned			percpu_batch_size;
+	unsigned			max_cached;
 
 	struct percpu_ida_cpu __percpu	*tag_cpu;
 
@@ -66,11 +67,11 @@ void percpu_ida_free(struct percpu_ida *pool, unsigned tag);
 
 void percpu_ida_destroy(struct percpu_ida *pool);
 int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
-	unsigned long max_size, unsigned long batch_size);
+	unsigned long max_size, unsigned long batch_size, unsigned max_cached);
 static inline int percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags)
 {
 	return __percpu_ida_init(pool, nr_tags, IDA_DEFAULT_PCPU_SIZE,
-		IDA_DEFAULT_PCPU_BATCH_MOVE);
+		IDA_DEFAULT_PCPU_BATCH_MOVE, nr_tags / 2);
 }
 
 typedef int (*percpu_ida_cb)(unsigned, void *);
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 1fc89f9..241f8a3 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -74,7 +74,7 @@ static inline void steal_tags(struct percpu_ida *pool,
 	smp_rmb();
 
 	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
-	     cpus_have_tags * pool->percpu_max_size > pool->nr_tags / 2;
+	     cpus_have_tags * pool->percpu_max_size > pool->max_cached;
 	     cpus_have_tags--) {
 		cpu = cpumask_next(cpu, &pool->cpus_have_tags);
 
@@ -294,7 +294,7 @@ EXPORT_SYMBOL_GPL(percpu_ida_destroy);
  * performance, the workload should not span more cpus than nr_tags / 128.
  */
 int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
-	unsigned long max_size, unsigned long batch_size)
+	unsigned long max_size, unsigned long batch_size, unsigned max_cached)
 {
 	unsigned i, cpu, order;
 
@@ -302,6 +302,8 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
 		return -ERANGE;
 	if (!batch_size)
 		return -EINVAL;
+	if (max_cached > nr_tags)
+		return -EINVAL;
 
 	memset(pool, 0, sizeof(*pool));
 
@@ -310,6 +312,7 @@ int __percpu_ida_init(struct percpu_ida *pool, unsigned long nr_tags,
 	pool->nr_tags = nr_tags;
 	pool->percpu_max_size = max_size;
 	pool->percpu_batch_size = batch_size;
+	pool->max_cached = max_cached;
 
 	/* Guard against overflow */
 	if (nr_tags > (unsigned) INT_MAX + 1) {
-- 
1.7.7.6


-- 
Regards,
Alexander Gordeev
agordeev@redhat.com
