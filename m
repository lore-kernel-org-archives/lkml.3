Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755053Ab3JCTjN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 15:39:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50733 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754965Ab3JCTjM (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 15:39:12 -0400
Date: Thu, 3 Oct 2013 21:32:06 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131003193206.GA17796@redhat.com>
References: <20131002145655.361606532@infradead.org> <20131002150518.675931976@infradead.org> <20131003164117.GD5790@linux.vnet.ibm.com> <20131003184001.GM28601@twins.programming.kicks-ass.net> <20131003184719.GA11996@redhat.com> <20131003192135.GR5790@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003192135.GR5790@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Paul E. McKenney wrote:
>
> On Thu, Oct 03, 2013 at 08:47:19PM +0200, Oleg Nesterov wrote:
> >
> > Yes, but...
> >
> > I think it would be better to start with the patch below, this way
> > it would be easier a) to add the new ops (we need more anyway) and b)
> > use CONFIG_PROVE_RCU to avoid the unused members even if this is
> > really minor.
>
> I am fine with this as well, but I don't see the code that checks for
> the required RCU read-side critical section.

Because I believe this needs another patch ;) see below, didn't test
it yet.

(and yes, until I saw the patch from Peter I didn't realize we already
 have all necessary helpers as functions, somehow I tought that they
 are macros).

Oleg.

rcusync: add the CONFIG_PROVE_RCU checks

CHANGELOG
---

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index 30c6037..aa7e9e0 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -7,6 +7,9 @@
 struct rcu_sync_ops {
 	void (*sync)(void);
 	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+#ifdef CONFIG_PROVE_RCU
+	bool (*held)(void);
+#endif
 };
 
 struct rcu_sync_struct {
@@ -22,6 +25,9 @@ struct rcu_sync_struct {
 
 static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
 {
+#ifdef CONFIG_PROVE_RCU
+	WARN_ON(!rss->ops->held());
+#endif
 	return !rss->gp_state; /* GP_IDLE */
 }
 
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index 1cefb83..21f191f 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -6,18 +6,27 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
 #define	rss_lock	gp_wait.lock
 
+#ifdef CONFIG_PROVE_RCU
+#define __INIT_HELD(func)	.held = func,
+#else
+#define	__INIT_HELD(func)
+#endif
+
 struct rcu_sync_ops rcu_sync_ops_array[] = {
 	[RCU_SYNC] = {
 		.sync = synchronize_rcu,
 		.call = call_rcu,
+		__INIT_HELD(rcu_read_lock_held)
 	},
 	[RCU_SCHED_SYNC] = {
 		.sync = synchronize_sched,
 		.call = call_rcu_sched,
+		__INIT_HELD(rcu_read_lock_sched_held)
 	},
 	[RCU_BH_SYNC] = {
 		.sync = synchronize_rcu_bh,
 		.call = call_rcu_bh,
+		__INIT_HELD(rcu_read_lock_bh_held)
 	},
 };
 

