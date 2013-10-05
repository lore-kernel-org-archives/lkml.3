Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752846Ab3JERZH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 5 Oct 2013 13:25:07 -0400
Received: from mx1.redhat.com ([209.132.183.28]:63143 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752269Ab3JERZF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 5 Oct 2013 13:25:05 -0400
Date: Sat, 5 Oct 2013 19:17:46 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Steven Rostedt <rostedt@goodmis.org>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>, Mel Gorman <mgorman@suse.de>,
        Rik van Riel <riel@redhat.com>,
        Srikar Dronamraju <srikar@linux.vnet.ibm.com>,
        Ingo Molnar <mingo@kernel.org>, Andrea Arcangeli <aarcange@redhat.com>,
        Johannes Weiner <hannes@cmpxchg.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 1/5] rcusync: introduce struct rcu_sync_ops
Message-ID: <20131005171746.GA17664@redhat.com>
References: <20131004184614.GA17536@redhat.com> <20131004184629.GA17550@redhat.com> <CA+55aFxfbV2AsOUhL318AH8y4BUe2FXFb8aTFuqPqc_2SdV2MA@mail.gmail.com> <20131004153012.19245adb@gandalf.local.home> <CA+55aFwda1pErt32162S_1gq=Kkge7Gj3n2sm_rOopAtz2bVUQ@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CA+55aFwda1pErt32162S_1gq=Kkge7Gj3n2sm_rOopAtz2bVUQ@mail.gmail.com>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/04, Linus Torvalds wrote:
>
> On Fri, Oct 4, 2013 at 12:30 PM, Steven Rostedt <rostedt@goodmis.org> wrote:
> >
> > As all the rcu_synchronization() methods (on non UP) are quite
> > expensive, I doubt that this optimization is worth anything.
>
> Maybe. It just annoys me, because afaik, the function that gets called
> is always static per callsite.

I simply can't understand how we can improve the code generation.
And more importantly, why does this matter at all in this case.

So unless you strongly object, I'd prefer to keep it as is. Except
I forgot to add "const" to _array[], this needs v2.

To me the annoying part is that this patch exports rcu_sync_ops*.
We can add "enum rcu_sync_type rcu_sync_struct->gp_type" instead,
see the patch below. But then the next "add the CONFIG_PROVE_RCU
checks" needs to uninline rcu_sync_is_idle() for CONFIG_PROVE_RCU.

Or do you still think we should do something else?

Oleg.
---

diff --git a/include/linux/rcusync.h b/include/linux/rcusync.h
index 7858491..988ec33 100644
--- a/include/linux/rcusync.h
+++ b/include/linux/rcusync.h
@@ -4,6 +4,8 @@
 #include <linux/wait.h>
 #include <linux/rcupdate.h>
 
+enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
+
 struct rcu_sync_struct {
 	int			gp_state;
 	int			gp_count;
@@ -12,53 +14,37 @@ struct rcu_sync_struct {
 	int			cb_state;
 	struct rcu_head		cb_head;
 
-	void (*sync)(void);
-	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+	enum rcu_sync_type	gp_type;
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
 }
 
-enum rcu_sync_type { RCU_SYNC, RCU_SCHED_SYNC, RCU_BH_SYNC };
-
 extern void rcu_sync_init(struct rcu_sync_struct *, enum rcu_sync_type);
 extern void rcu_sync_enter(struct rcu_sync_struct *);
 extern void rcu_sync_exit(struct rcu_sync_struct *);
 
+#define __RCU_SYNC_INITIALIZER(name, type) {				\
+		.gp_state = 0,						\
+		.gp_count = 0,						\
+		.gp_wait = __WAIT_QUEUE_HEAD_INITIALIZER(name.gp_wait),	\
+		.cb_state = 0,						\
+		.gp_type = type,					\
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
index f84176a..99051b7 100644
--- a/kernel/rcusync.c
+++ b/kernel/rcusync.c
@@ -1,7 +1,24 @@
-
 #include <linux/rcusync.h>
 #include <linux/sched.h>
 
+static const struct {
+	void (*sync)(void);
+	void (*call)(struct rcu_head *, void (*)(struct rcu_head *));
+} gp_ops[] = {
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
 enum { GP_IDLE = 0, GP_PENDING, GP_PASSED };
 enum { CB_IDLE = 0, CB_PENDING, CB_REPLAY };
 
@@ -11,23 +28,7 @@ void rcu_sync_init(struct rcu_sync_struct *rss, enum rcu_sync_type type)
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
+	rss->gp_type = type;
 }
 
 void rcu_sync_enter(struct rcu_sync_struct *rss)
@@ -44,7 +45,7 @@ void rcu_sync_enter(struct rcu_sync_struct *rss)
 	BUG_ON(need_wait && need_sync);
 
 	if (need_sync) {
-		rss->sync();
+		gp_ops[rss->gp_type].sync();
 		rss->gp_state = GP_PASSED;
 		wake_up_all(&rss->gp_wait);
 	} else if (need_wait) {
@@ -81,7 +82,7 @@ static void rcu_sync_func(struct rcu_head *rcu)
 		 * to catch a later GP.
 		 */
 		rss->cb_state = CB_PENDING;
-		rss->call(&rss->cb_head, rcu_sync_func);
+		gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
 	} else {
 		/*
 		 * We're at least a GP after rcu_sync_exit(); eveybody will now
@@ -99,7 +100,7 @@ void rcu_sync_exit(struct rcu_sync_struct *rss)
 	if (!--rss->gp_count) {
 		if (rss->cb_state == CB_IDLE) {
 			rss->cb_state = CB_PENDING;
-			rss->call(&rss->cb_head, rcu_sync_func);
+			gp_ops[rss->gp_type].call(&rss->cb_head, rcu_sync_func);
 		} else if (rss->cb_state == CB_PENDING) {
 			rss->cb_state = CB_REPLAY;
 		}

