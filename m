Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755002Ab3JCSyl (ORCPT <rfc822;w@1wt.eu>);
	Thu, 3 Oct 2013 14:54:41 -0400
Received: from mx1.redhat.com ([209.132.183.28]:45996 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754536Ab3JCSyj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 3 Oct 2013 14:54:39 -0400
Date: Thu, 3 Oct 2013 20:47:19 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Steven Rostedt <rostedt@goodmis.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] rcu: Create rcu_sync infrastructure
Message-ID: <20131003184719.GA11996@redhat.com>
References: <20131002145655.361606532@infradead.org> <20131002150518.675931976@infradead.org> <20131003164117.GD5790@linux.vnet.ibm.com> <20131003184001.GM28601@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131003184001.GM28601@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/03, Peter Zijlstra wrote:
>
> On Thu, Oct 03, 2013 at 09:41:17AM -0700, Paul E. McKenney wrote:
> > On Wed, Oct 02, 2013 at 04:56:57PM +0200, Peter Zijlstra wrote:
> > #ifdef CONFIG_PROVE_RCU
> > #define rcu_sync_is_idle_check(rss) BUG_ON(!rss->read_side_check())
> > #else
> > #define rcu_sync_is_idle_check(rss) do { } while (0)
> > #endif
> >
> > 	rcu_sync_is_idle_check(rss);
>
> The below actually seems to build, although I didn't test the config
> permutations, only defconfig.

Yes, but...

I think it would be better to start with the patch below, this way
it would be easier a) to add the new ops (we need more anyway) and b)
use CONFIG_PROVE_RCU to avoid the unused members even if this is
really minor.

Oleg.

rcusync: introdude struct rcu_sync_ops

CHANGELOG

---
 include/linux/rcusync.h |   63 +++++++++++++++++++++--------------------------
 kernel/rcusync.c        |   40 ++++++++++++++---------------
 2 files changed, 47 insertions(+), 56 deletions(-)

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index 7858491..30c6037 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -4,6 +4,11 @@
 #include <linux/wait.h>
 #include <linux/rcupdate.h>
 
+struct rcu_sync_ops {
+	void (*sync)(void);
+	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+};
+
 struct rcu_sync_struct {
 	int			gp_state;
 	int			gp_count;
@@ -12,43 +17,9 @@ struct rcu_sync_struct {
 	int			cb_state;
 	struct rcu_head		cb_head;
 
-	void (*sync)(void);
-	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+	struct rcu_sync_ops	*ops;
 };
 
-#define ___RCU_SYNC_INIT(name)						\
-	.gp_state = 0,							\
-	.gp_count = 0,							\
-	.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),		\
-	.cb_state = 0
-
-#define __RCU_SCHED_SYNC_INIT(name) {					\
-	___RCU_SYNC_INIT(name),						\
-	.sync = synchronize_sched,					\
-	.call = call_rcu_sched,						\
-}
-
-#define __RCU_BH_SYNC_INIT(name) {					\
-	___RCU_SYNC_INIT(name),						\
-	.sync = synchronize_rcu_bh,					\
-	.call = call_rcu_bh,						\
-}
-
-#define __RCU_SYNC_INIT(name) {						\
-	___RCU_SYNC_INIT(name),						\
-	.sync = synchronize_rcu,					\
-	.call = call_rcu,						\
-}
-
-#define DEFINE_RCU_SCHED_SYNC(name)					\
-	struct rcu_sync_struct name = __RCU_SCHED_SYNC_INIT(name)
-
-#define DEFINE_RCU_BH_SYNC(name)					\
-	struct rcu_sync_struct name = __RCU_BH_SYNC_INIT(name)
-
-#define DEFINE_RCU_SYNC(name)						\
-	struct rcu_sync_struct name = __RCU_SYNC_INIT(name)
-
 static inline bool rcu_sync_is_idle(struct rcu_sync_struct *rss)
 {
 	return !rss->gp_state; /* GP_IDLE */
@@ -60,5 +31,27 @@ extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
 extern void rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
 
+extern struct rcu_sync_ops rcu_sync_ops_array[];
+
+#define __RCU_SYNC_INITIALIZER(name, type) {				\
+		.gp_state = 0,						\
+		.gp_count = 0,						\
+		.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),	\
+		.cb_state = 0,						\
+		.ops = rcu_sync_ops_array + (type),			\
+	}
+
+#define	__DEFINE_RCU_SYNC(name, type)	\
+	struct rcu_sync_struct name = __RCU_SYNC_INITIALIZER(name, type)
+
+#define DEFINE_RCU_SYNC(name)		\
+	__DEFINE_RCU_SYNC(name, RCU_SYNC)
+
+#define DEFINE_RCU_SCHED_SYNC(name)	\
+	__DEFINE_RCU_SYNC(name, RCU_SCHED_SYNC)
+
+#define DEFINE_RCU_BH_SYNC(name)	\
+	__DEFINE_RCU_SYNC(name, RCU_BH_SYNC)
+
 #endif /* _LINUX_RCUSYNC_H_ */
 
diff --git a/kernel/rcusync.c b/kernel/rcusync.c
index f84176a..1cefb83 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -1,4 +1,3 @@
-
 #include <linux/rcusync.h>
 #include <linux/sched.h>
 
@@ -7,27 +6,26 @@ enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
 #define	rss_lock	gp_wait.lock
 
+struct rcu_sync_ops rcu_sync_ops_array[] = {
+	[RCU_SYNC] = {
+		.sync = synchronize_rcu,
+		.call = call_rcu,
+	},
+	[RCU_SCHED_SYNC] = {
+		.sync = synchronize_sched,
+		.call = call_rcu_sched,
+	},
+	[RCU_BH_SYNC] = {
+		.sync = synchronize_rcu_bh,
+		.call = call_rcu_bh,
+	},
+};
+
 void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
 {
 	memset(rss, 0, sizeof(*rss));
 	init_waitqueue_head(&rss->gp_wait);
-
-	switch (type) {
-	case RCU_SYNC:
-		rss->sync = synchronize_rcu;
-		rss->call = call_rcu;
-		break;
-
-	case RCU_SCHED_SYNC:
-		rss->sync = synchronize_sched;
-		rss->call = call_rcu_sched;
-		break;
-
-	case RCU_BH_SYNC:
-		rss->sync = synchronize_rcu_bh;
-		rss->call = call_rcu_bh;
-		break;
-	}
+	rss->ops = rcu_sync_ops_array + type;
 }
 
 void rcu_sync_enter(struct rcu_sync_struct *rss)
@@ -44,7 +42,7 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
 	BUG_ON(need_wait && need_sync);
 
 	if (need_sync) {
-		rss->sync();
+		rss->ops->sync();
 		rss->gp_state = GP_PASSED;
 		wake_up_all(&rss->gp_wait);
 	} else if (need_wait) {
@@ -81,7 +79,7 @@ static void rcu_sync_func(struct rcu_head *rcu)
 		 * to catch a later GP.
 		 */
 		rss->cb_state = CB_PENDING;
-		rss->call(&rss->cb_head, rcu_sync_func);
+		rss->ops->call(&rss->cb_head, rcu_sync_func);
 	} else {
 		/*
 		 * We're at least a GP after rcu_sync_exit(); eveybody will now
@@ -99,7 +97,7 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
 	if (!--rss->gp_count) {
 		if (rss->cb_state == CB_IDLE) {
 			rss->cb_state = CB_PENDING;
-			rss->call(&rss->cb_head, rcu_sync_func);
+			rss->ops->call(&rss->cb_head, rcu_sync_func);
 		} else if (rss->cb_state == CB_PENDING) {
 			rss->cb_state = CB_REPLAY;
 		}

