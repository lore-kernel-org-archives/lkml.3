Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759100Ab3DQTyI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 17 Apr 2013 15:54:08 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58281 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758718Ab3DQTyE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 17 Apr 2013 15:54:04 -0400
Date: Wed, 17 Apr 2013 12:53:40 -0700
From: tip-bot for Pavel Emelyanov <tipbot@zytor.com>
Message-ID: <tip-5ed67f05f66c41e39880a6d61358438a25f9fee5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        matt.helsley@gmail.com, peterz@infradead.org, xemul@parallels.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        matt.helsley@gmail.com, peterz@infradead.org, xemul@parallels.com,
        tglx@linutronix.de, mtk.manpages@gmail.com
In-Reply-To: <513D9FF5.9010004@parallels.com>
References: <513D9FF5.9010004@parallels.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:timers/core] posix timers: Allocate timer id per process (v2
 )
Git-Commit-ID: 5ed67f05f66c41e39880a6d61358438a25f9fee5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 17 Apr 2013 12:53:46 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ed67f05f66c41e39880a6d61358438a25f9fee5
Gitweb:     http://git.kernel.org/tip/5ed67f05f66c41e39880a6d61358438a25f9fee5
Author:     Pavel Emelyanov <xemul@parallels.com>
AuthorDate: Mon, 11 Mar 2013 13:12:21 +0400
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 17 Apr 2013 20:51:01 +0200

posix timers: Allocate timer id per process (v2)

Currently kernel generates IDs for posix timers in a global manner --
there's a kernel-wide IDR tree from which IDs are created. This makes
it impossible to recreate a timer with a desired ID (in particular
this is done by the CRIU checkpoint-restore project) -- since these
IDs are global it may happen, that at the time we recreate a timer, the
ID we want for it is already busy by some other timer.

In order to address this, replace the IDR tree with a global hash
table for timers and makes timer IDs unique per signal_struct (to
which timers are linked anyway). With this, two timers belonging to
different processes may have equal IDs and we can recreate either of
them with the ID we want.

Signed-off-by: Pavel Emelyanov <xemul@parallels.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Michael Kerrisk <mtk.manpages@gmail.com>
Cc: Matthew Helsley <matt.helsley@gmail.com>
Link: http://lkml.kernel.org/r/513D9FF5.9010004@parallels.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
---
 include/linux/posix-timers.h |   1 +
 include/linux/sched.h        |   3 +-
 kernel/posix-timers.c        | 106 ++++++++++++++++++++++++++++---------------
 3 files changed, 72 insertions(+), 38 deletions(-)

diff --git a/include/linux/posix-timers.h b/include/linux/posix-timers.h
index 042058f..60bac69 100644
--- a/include/linux/posix-timers.h
+++ b/include/linux/posix-timers.h
@@ -55,6 +55,7 @@ struct cpu_timer_list {
 /* POSIX.1b interval timer structure. */
 struct k_itimer {
 	struct list_head list;		/* free/ allocate list */
+	struct hlist_node t_hash;
 	spinlock_t it_lock;
 	clockid_t it_clock;		/* which timer type */
 	timer_t it_id;			/* timer id */
diff --git a/include/linux/sched.h b/include/linux/sched.h
index d35d2b6..d13341b 100644
--- a/include/linux/sched.h
+++ b/include/linux/sched.h
@@ -526,7 +526,8 @@ struct signal_struct {
 	unsigned int		has_child_subreaper:1;
 
 	/* POSIX.1b Interval Timers */
-	struct list_head posix_timers;
+	int			posix_timer_id;
+	struct list_head	posix_timers;
 
 	/* ITIMER_REAL timer for the process */
 	struct hrtimer real_timer;
diff --git a/kernel/posix-timers.c b/kernel/posix-timers.c
index 2a2e173..34d7592 100644
--- a/kernel/posix-timers.c
+++ b/kernel/posix-timers.c
@@ -40,38 +40,31 @@
 #include <linux/list.h>
 #include <linux/init.h>
 #include <linux/compiler.h>
-#include <linux/idr.h>
+#include <linux/hash.h>
 #include <linux/posix-clock.h>
 #include <linux/posix-timers.h>
 #include <linux/syscalls.h>
 #include <linux/wait.h>
 #include <linux/workqueue.h>
 #include <linux/export.h>
+#include <linux/hashtable.h>
 
 /*
- * Management arrays for POSIX timers.	 Timers are kept in slab memory
- * Timer ids are allocated by an external routine that keeps track of the
- * id and the timer.  The external interface is:
- *
- * void *idr_find(struct idr *idp, int id);           to find timer_id <id>
- * int idr_get_new(struct idr *idp, void *ptr);       to get a new id and
- *                                                    related it to <ptr>
- * void idr_remove(struct idr *idp, int id);          to release <id>
- * void idr_init(struct idr *idp);                    to initialize <idp>
- *                                                    which we supply.
- * The idr_get_new *may* call slab for more memory so it must not be
- * called under a spin lock.  Likewise idr_remore may release memory
- * (but it may be ok to do this under a lock...).
- * idr_find is just a memory look up and is quite fast.  A -1 return
- * indicates that the requested id does not exist.
+ * Management arrays for POSIX timers. Timers are now kept in static hash table
+ * with 512 entries.
+ * Timer ids are allocated by local routine, which selects proper hash head by
+ * key, constructed from current->signal address and per signal struct counter.
+ * This keeps timer ids unique per process, but now they can intersect between
+ * processes.
  */
 
 /*
  * Lets keep our timers in a slab cache :-)
  */
 static struct kmem_cache *posix_timers_cache;
-static struct idr posix_timers_id;
-static DEFINE_SPINLOCK(idr_lock);
+
+static DEFINE_HASHTABLE(posix_timers_hashtable, 9);
+static DEFINE_SPINLOCK(hash_lock);
 
 /*
  * we assume that the new SIGEV_THREAD_ID shares no bits with the other
@@ -152,6 +145,57 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags);
 	__timr;								   \
 })
 
+static int hash(struct signal_struct *sig, unsigned int nr)
+{
+	return hash_32(hash32_ptr(sig) ^ nr, HASH_BITS(posix_timers_hashtable));
+}
+
+static struct k_itimer *__posix_timers_find(struct hlist_head *head,
+					    struct signal_struct *sig,
+					    timer_t id)
+{
+	struct hlist_node *node;
+	struct k_itimer *timer;
+
+	hlist_for_each_entry_rcu(timer, head, t_hash) {
+		if ((timer->it_signal == sig) && (timer->it_id == id))
+			return timer;
+	}
+	return NULL;
+}
+
+static struct k_itimer *posix_timer_by_id(timer_t id)
+{
+	struct signal_struct *sig = current->signal;
+	struct hlist_head *head = &posix_timers_hashtable[hash(sig, id)];
+
+	return __posix_timers_find(head, sig, id);
+}
+
+static int posix_timer_add(struct k_itimer *timer)
+{
+	struct signal_struct *sig = current->signal;
+	int first_free_id = sig->posix_timer_id;
+	struct hlist_head *head;
+	int ret = -ENOENT;
+
+	do {
+		spin_lock(&hash_lock);
+		head = &posix_timers_hashtable[hash(sig, sig->posix_timer_id)];
+		if (!__posix_timers_find(head, sig, sig->posix_timer_id)) {
+			hlist_add_head_rcu(&timer->t_hash, head);
+			ret = sig->posix_timer_id;
+		}
+		if (++sig->posix_timer_id < 0)
+			sig->posix_timer_id = 0;
+		if ((sig->posix_timer_id == first_free_id) && (ret == -ENOENT))
+			/* Loop over all possible ids completed */
+			ret = -EAGAIN;
+		spin_unlock(&hash_lock);
+	} while (ret == -ENOENT);
+	return ret;
+}
+
 static inline void unlock_timer(struct k_itimer *timr, unsigned long flags)
 {
 	spin_unlock_irqrestore(&timr->it_lock, flags);
@@ -298,7 +342,6 @@ static __init int init_posix_timers(void)
 	posix_timers_cache = kmem_cache_create("posix_timers_cache",
 					sizeof (struct k_itimer), 0, SLAB_PANIC,
 					NULL);
-	idr_init(&posix_timers_id);
 	return 0;
 }
 
@@ -520,9 +563,9 @@ static void release_posix_timer(struct k_itimer *tmr, int it_id_set)
 {
 	if (it_id_set) {
 		unsigned long flags;
-		spin_lock_irqsave(&idr_lock, flags);
-		idr_remove(&posix_timers_id, tmr->it_id);
-		spin_unlock_irqrestore(&idr_lock, flags);
+		spin_lock_irqsave(&hash_lock, flags);
+		hlist_del_rcu(&tmr->t_hash);
+		spin_unlock_irqrestore(&hash_lock, flags);
 	}
 	put_pid(tmr->it_pid);
 	sigqueue_free(tmr->sigq);
@@ -568,22 +611,11 @@ SYSCALL_DEFINE3(timer_create, const clockid_t, which_clock,
 		return -EAGAIN;
 
 	spin_lock_init(&new_timer->it_lock);
-
-	idr_preload(GFP_KERNEL);
-	spin_lock_irq(&idr_lock);
-	error = idr_alloc(&posix_timers_id, new_timer, 0, 0, GFP_NOWAIT);
-	spin_unlock_irq(&idr_lock);
-	idr_preload_end();
-	if (error < 0) {
-		/*
-		 * Weird looking, but we return EAGAIN if the IDR is
-		 * full (proper POSIX return value for this)
-		 */
-		if (error == -ENOSPC)
-			error = -EAGAIN;
+	new_timer_id = posix_timer_add(new_timer);
+	if (new_timer_id < 0) {
+		error = new_timer_id;
 		goto out;
 	}
-	new_timer_id = error;
 
 	it_id_set = IT_ID_SET;
 	new_timer->it_id = (timer_t) new_timer_id;
@@ -661,7 +693,7 @@ static struct k_itimer *__lock_timer(timer_t timer_id, unsigned long *flags)
 		return NULL;
 
 	rcu_read_lock();
-	timr = idr_find(&posix_timers_id, (int)timer_id);
+	timr = posix_timer_by_id(timer_id);
 	if (timr) {
 		spin_lock_irqsave(&timr->it_lock, *flags);
 		if (timr->it_signal == current->signal) {
