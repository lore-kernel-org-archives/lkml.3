Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754871AbaCZNcy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 09:32:54 -0400
Received: from mx1.redhat.com ([209.132.183.28]:43354 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754339AbaCZNcw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 09:32:52 -0400
From: Alexander Gordeev <agordeev@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Alexander Gordeev <agordeev@redhat.com>,
        Kent Overstreet <kmo@daterainc.com>, Jens Axboe <axboe@kernel.dk>,
        Shaohua Li <shli@kernel.org>, Nicholas Bellinger <nab@linux-iscsi.org>
Subject: [PATCH RFC 2/2] percpu_ida: Use for_each_tlm() macro for CPU lookup in steal_tags()
Date: Wed, 26 Mar 2014 14:34:24 +0100
Message-Id: <b075c716d8f4940b5bc3d4747c08b5fcf8db9084.1395840483.git.agordeev@redhat.com>
In-Reply-To: <cover.1395840483.git.agordeev@redhat.com>
References: <cover.1395840483.git.agordeev@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function steal_tags() iterates thru 'cpus_have_tags' cpumask
ignoring the system's CPU topology. That leads to situations
when a newly stolen tag and the data structure(s) associated
with it (i.e. struct request in the block layer) topology-
wise are more remote from the stealing CPU than it could have
been had steal_tags() take the system's topology into accout.

This update makes use of for_each_tlm() macro and softens the
problem described above. As result, cache misses caused by
accesses from a CPU that stole a tag to that tag's associated
data are lessened.

As a side effect, percpu_ida::cpu_last_stolen variable became
superfluous and get eliminated.

Signed-off-by: Alexander Gordeev <agordeev@redhat.com>
Cc: Kent Overstreet <kmo@daterainc.com>
Cc: Jens Axboe <axboe@kernel.dk>
Cc: Shaohua Li <shli@kernel.org>
Cc: Nicholas Bellinger <nab@linux-iscsi.org>
---
 include/linux/percpu_ida.h |    1 -
 lib/percpu_ida.c           |   46 ++++++++++++++++++-------------------------
 2 files changed, 19 insertions(+), 28 deletions(-)

diff --git a/include/linux/percpu_ida.h b/include/linux/percpu_ida.h
index f5cfdd6..0d891f3 100644
--- a/include/linux/percpu_ida.h
+++ b/include/linux/percpu_ida.h
@@ -40,7 +40,6 @@ struct percpu_ida {
 		 * we want to pick a cpu at random. Cycling through them every
 		 * time we steal is a bit easier and more or less equivalent:
 		 */
-		unsigned		cpu_last_stolen;
 
 		/* For sleeping on allocation failure */
 		wait_queue_head_t	wait;
diff --git a/lib/percpu_ida.c b/lib/percpu_ida.c
index 93d145e..5c51baa 100644
--- a/lib/percpu_ida.c
+++ b/lib/percpu_ida.c
@@ -63,42 +63,34 @@ static inline void move_tags(unsigned *dst, unsigned *dst_nr,
 static inline void steal_tags(struct percpu_ida *pool,
 			      struct percpu_ida_cpu *tags)
 {
-	unsigned cpus_have_tags, cpu = pool->cpu_last_stolen;
 	struct percpu_ida_cpu *remote;
+	struct cpumask **tlm;
+	int cpu;
 
-	for (cpus_have_tags = cpumask_weight(&pool->cpus_have_tags);
-	     cpus_have_tags; cpus_have_tags--) {
-		cpu = cpumask_next(cpu, &pool->cpus_have_tags);
+	for_each_tlm(tlm) {
+		for_each_cpu_and(cpu, *tlm, &pool->cpus_have_tags) {
+			cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
 
-		if (cpu >= nr_cpu_ids) {
-			cpu = cpumask_first(&pool->cpus_have_tags);
-			if (cpu >= nr_cpu_ids)
-				BUG();
-		}
+			remote = per_cpu_ptr(pool->tag_cpu, cpu);
+			if (remote == tags)
+				continue;
 
-		pool->cpu_last_stolen = cpu;
-		remote = per_cpu_ptr(pool->tag_cpu, cpu);
+			spin_lock(&remote->lock);
 
-		cpumask_clear_cpu(cpu, &pool->cpus_have_tags);
+			if (remote->nr_free) {
+				memcpy(tags->freelist,
+				       remote->freelist,
+				       sizeof(unsigned) * remote->nr_free);
 
-		if (remote == tags)
-			continue;
+				tags->nr_free = remote->nr_free;
+				remote->nr_free = 0;
+			}
 
-		spin_lock(&remote->lock);
+			spin_unlock(&remote->lock);
 
-		if (remote->nr_free) {
-			memcpy(tags->freelist,
-			       remote->freelist,
-			       sizeof(unsigned) * remote->nr_free);
-
-			tags->nr_free = remote->nr_free;
-			remote->nr_free = 0;
+			if (tags->nr_free)
+				return;
 		}
-
-		spin_unlock(&remote->lock);
-
-		if (tags->nr_free)
-			break;
 	}
 }
 
-- 
1.7.7.6

