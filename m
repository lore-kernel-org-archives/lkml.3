Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932223Ab3KWA5j (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 19:57:39 -0500
Received: from g4t0014.houston.hp.com ([15.201.24.17]:5425 "EHLO
	g4t0014.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932115Ab3KWA4v (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 19:56:51 -0500
From: Davidlohr Bueso <davidlohr@hp.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, dvhart@linux.intel.com, peterz@infradead.org,
        tglx@linutronix.de, efault@gmx.de, jeffm@suse.com,
        torvalds@linux-foundation.org, scott.norton@hp.com, tom.vaden@hp.com,
        aswin@hp.com, Waiman.Long@hp.com, jason.low2@hp.com, davidlohr@hp.com
Subject: [PATCH 3/5] futex: Larger hash table
Date: Fri, 22 Nov 2013 16:56:35 -0800
Message-Id: <1385168197-8612-4-git-send-email-davidlohr@hp.com>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
References: <1385168197-8612-1-git-send-email-davidlohr@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently, the futex global hash table suffers from it's fixed, smallish
(for today's standards) size of 256 entries, as well as its lack of NUMA
awareness. Large systems, using many futexes, can be prone to high amounts
of collisions; where these futexes hash to the same bucket and lead to
extra contention on the same hb->lock. Furthermore, cacheline bouncing is a
reality when we have multiple hb->locks residing on the same cacheline and
different futexes hash to adjacent buckets.

This patch keeps the current static size of 16 entries for small systems,
or otherwise, 256 * ncpus (or larger as we need to round the number to a
power of 2). Note that this number of CPUs accounts for all CPUs that can
ever be available in the system, taking into consideration things like
hotpluging. While we do impose extra overhead at bootup by making the hash
table larger, this is a one time thing, and does not shadow the benefits
of this patch.

Also, similar to other core kernel components (pid, dcache, tcp), by using
alloc_large_system_hash() we benefit from its NUMA awareness and thus the
table is distributed among the nodes instead of in a single one. We impose
this function's minimum limit of 256 entries, so that in worst case scenarios
or issues, we still end up using the current amount anyways.

For a custom microbenchmark that pounds on the uaddr hashing -- making the wait
path fail at futex_wait_setup() returning -EWOULDBLOCK for large amounts of futexes,
we can see the following benefits on a 80-core, 8-socket 1Tb server:

+---------+----------------------------------+------------------------------------------+----------+
| threads | baseline (ops/sec) [insns/cycle] | large hash table (ops/sec) [insns/cycle] | increase |
+---------+----------------------------------+------------------------------------------+----------+
|     512 | 34429    [0.07]                  | 255274    [0.48]                         | +641.45% |
|     256 | 65452    [0.07]                  | 443563    [0.41]                         | +577.69% |
|     128 | 125111   [0.07]                  | 742613    [0.33]                         | +493.56% |
|      80 | 203642   [0.09]                  | 1028147   [0.29]                         | +404.87% |
|      64 | 262944   [0.09]                  | 997300    [0.28]                         | +279.28% |
|      32 | 642390   [0.24]                  | 965996    [0.27]                         | +50.37   |
+---------+----------------------------------+------------------------------------------+----------+

Cc: Ingo Molnar <mingo@kernel.org>
Cc: Darren Hart <dvhart@linux.intel.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Jeff Mahoney <jeffm@suse.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Scott Norton <scott.norton@hp.com>
Cc: Tom Vaden <tom.vaden@hp.com>
Cc: Aswin Chandramouleeswaran <aswin@hp.com>
Signed-off-by: Waiman Long <Waiman.Long@hp.com>
Signed-off-by: Jason Low <jason.low2@hp.com>
Signed-off-by: Davidlohr Bueso <davidlohr@hp.com>
---
 kernel/futex.c | 26 +++++++++++++++++++++-----
 1 file changed, 21 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 0768c68..5fa9eb0 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -63,6 +63,7 @@
 #include <linux/sched/rt.h>
 #include <linux/hugetlb.h>
 #include <linux/freezer.h>
+#include <linux/bootmem.h>
 
 #include <asm/futex.h>
 
@@ -70,7 +71,11 @@
 
 int __read_mostly futex_cmpxchg_enabled;
 
-#define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
+#if CONFIG_BASE_SMALL
+static unsigned long futex_hashsize = 16;
+#else
+static unsigned long futex_hashsize;
+#endif
 
 /*
  * Futex flags used to encode options to functions and preserve them across
@@ -151,7 +156,11 @@ struct futex_hash_bucket {
 	struct plist_head chain;
 };
 
-static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
+#if CONFIG_BASE_SMALL
+static struct futex_hash_bucket futex_queues[futex_hashsize];
+#else
+static struct futex_hash_bucket *futex_queues;
+#endif
 
 /*
  * We hash on the keys returned from get_futex_key (see below).
@@ -161,7 +170,7 @@ static struct futex_hash_bucket *hash_futex(union futex_key *key)
 	u32 hash = jhash2((u32*)&key->both.word,
 			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
 			  key->both.offset);
-	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
+	return &futex_queues[hash & (futex_hashsize - 1)];
 }
 
 /*
@@ -2715,7 +2724,14 @@ SYSCALL_DEFINE6(futex, u32 __user *, uaddr, int, op, u32, val,
 static int __init futex_init(void)
 {
 	u32 curval;
-	int i;
+	unsigned long i;
+
+#if !CONFIG_BASE_SMALL
+	futex_hashsize = roundup_pow_of_two((256 * num_possible_cpus()));
+	futex_queues = alloc_large_system_hash("futex", sizeof(*futex_queues),
+					       futex_hashsize, 0, 0, NULL, NULL,
+					       256, futex_hashsize);
+#endif
 
 	/*
 	 * This will fail and we want it. Some arch implementations do
@@ -2730,7 +2746,7 @@ static int __init futex_init(void)
 	if (cmpxchg_futex_value_locked(&curval, NULL, 0, 0) == -EFAULT)
 		futex_cmpxchg_enabled = 1;
 
-	for (i = 0; i < ARRAY_SIZE(futex_queues); i++) {
+	for (i = 0; i < futex_hashsize; i++) {
 		plist_head_init(&futex_queues[i].chain);
 		spin_lock_init(&futex_queues[i].lock);
 	}
-- 
1.8.1.4

