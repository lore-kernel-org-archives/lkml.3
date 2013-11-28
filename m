Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758596Ab3K1MAM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 07:00:12 -0500
Received: from merlin.infradead.org ([205.233.59.134]:48516 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758160Ab3K1MAJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 07:00:09 -0500
Date: Thu, 28 Nov 2013 12:59:46 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Davidlohr Bueso <davidlohr@hp.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, LKML <linux-kernel@vger.kernel.org>,
        Jason Low <jason.low2@hp.com>, Ingo Molnar <mingo@kernel.org>,
        Darren Hart <dvhart@linux.intel.com>, Mike Galbraith <efault@gmx.de>,
        Jeff Mahoney <jeffm@suse.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Scott Norton <scott.norton@hp.com>, Tom Vaden <tom.vaden@hp.com>,
        Aswin Chandramouleeswaran <aswin@hp.com>,
        Waiman Long <Waiman.Long@hp.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: Re: [RFC patch 0/5] futex: Allow lockless empty check of hashbucket
 plist in futex_wake()
Message-ID: <20131128115946.GD13532@twins.programming.kicks-ass.net>
References: <20131125203358.156292370@linutronix.de>
 <1385453551.12603.16.camel@buesod1.americas.hpqcorp.net>
 <20131126085256.GD789@laptop.programming.kicks-ass.net>
 <1385493911.25945.3.camel@buesod1.americas.hpqcorp.net>
 <1385499085.23083.7.camel@buesod1.americas.hpqcorp.net>
 <alpine.DEB.2.02.1311262206150.30673@ionos.tec.linutronix.de>
 <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1385624678.22210.25.camel@buesod1.americas.hpqcorp.net>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 27, 2013 at 11:44:38PM -0800, Davidlohr Bueso wrote:
> How about both enlarging the table _and_ aligning the buckets? As you
> know, increasing the size of the table also benefits (particularly in
> larger systems) in having more spinlocks. So we reduce the amount of
> collisions and alleviate contention on the hb->lock. Btw, do you have
> any particular concerns about the larger hash table patch? 

My only concern was the amount of #ifdef.

Wouldn't something like the below also work?


---
 kernel/futex.c | 20 +++++++++++++++-----
 1 file changed, 15 insertions(+), 5 deletions(-)

diff --git a/kernel/futex.c b/kernel/futex.c
index 80ba086f021d..2e1a9294f751 100644
--- a/kernel/futex.c
+++ b/kernel/futex.c
@@ -70,8 +70,6 @@
 
 int __read_mostly futex_cmpxchg_enabled;
 
-#define FUTEX_HASHBITS (CONFIG_BASE_SMALL ? 4 : 8)
-
 /*
  * Futex flags used to encode options to functions and preserve them across
  * restarts.
@@ -149,9 +147,11 @@ static const struct futex_q futex_q_init = {
 struct futex_hash_bucket {
 	spinlock_t lock;
 	struct plist_head chain;
-};
+} ____cacheline_aligned_in_smp;
 
-static struct futex_hash_bucket futex_queues[1<<FUTEX_HASHBITS];
+static unsigned long __read_mostly futex_hashsize;
+
+static struct futex_hash_bucket *futex_queues;
 
 /*
  * We hash on the keys returned from get_futex_key (see below).
@@ -161,7 +161,7 @@ static struct futex_hash_bucket *hash_futex(union futex_key *key)
 	u32 hash = jhash2((u32*)&key->both.word,
 			  (sizeof(key->both.word)+sizeof(key->both.ptr))/4,
 			  key->both.offset);
-	return &futex_queues[hash & ((1 << FUTEX_HASHBITS)-1)];
+	return &futex_queues[hash & (futex_hashsize - 1)];
 }
 
 /*
@@ -2735,6 +2735,16 @@ static int __init futex_init(void)
 	u32 curval;
 	int i;
 
+#ifdef CONFIG_BASE_SMALL
+	futex_hashsize = 16;
+#else
+	futex_hashsize = roundup_pow_of_two(256 * num_possible_cpus());
+#endif
+
+	futex_queues = alloc_large_system_hash("futex", sizeof(*futex_queues),
+			futex_hashsize, 0, futex_hashsize < 256 ? HASH_SMALL : 0,
+			NULL, NULL, futex_hashsize, futex_hashsize);
+
 	/*
 	 * This will fail and we want it. Some arch implementations do
 	 * runtime detection of the futex_atomic_cmpxchg_inatomic()
