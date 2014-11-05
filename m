Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754804AbaKEMq1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:46:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:48851 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754035AbaKEMqY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:46:24 -0500
Date: Wed, 5 Nov 2014 13:46:20 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141105124620.GB4527@dhcp22.suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
 <2156351.pWp6MNRoWm@vostro.rjw.lan>
 <20141021141159.GE9415@dhcp22.suse.cz>
 <4766859.KSKPTm3b0x@vostro.rjw.lan>
 <20141021142939.GG9415@dhcp22.suse.cz>
 <20141104192705.GA22163@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141104192705.GA22163@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue 04-11-14 14:27:05, Tejun Heo wrote:
> Hello,
> 
> Sorry about the delay.
> 
> On Tue, Oct 21, 2014 at 04:29:39PM +0200, Michal Hocko wrote:
> > Reduce the race window by checking all tasks after OOM killer has been
> 
> Ugh... this is never a good direction to take.  It often just ends up
> making bugs harder to reproduce and track down.

As I've said I wasn't entirely happy with this half solution but it helped
the current situation at the time. The full solution would require to
fully synchronize OOM path with the freezer. The patch below is doing
that.

> > disabled. This is still not race free completely unfortunately because
> > oom_killer_disable cannot stop an already ongoing OOM killer so a task
> > might still wake up from the fridge and get killed without
> > freeze_processes noticing. Full synchronization of OOM and freezer is,
> > however, too heavy weight for this highly unlikely case.
> 
> Both oom killing and PM freezing are exremely rare events and I have
> difficult time why their exclusion would be heavy weight.  Care to
> elaborate

You are right that the allocation OOM path is extremely slow and so an
additional locking shouldn't matter much. I originally thought that
any locking would require more changes in the allocation path. In the
end it looks much easier than I hoped. I haven't tested it so I might be
just missing some subtle issues now.

Anyway I cannot say I would be happy to expose a lock which can block
OOM to happen because this calls for troubles. It is true that we
already have that ugly oom_killer_disabled hack but that only causes
allocation to fail rather than block the OOM path altogether if
something goes wrong. Maybe I am just too paranoid...

So my original intention was to provide a mechanism which would be safe
from OOM point of view and as good as possible from PM POV. The race is
really unlikely and even if it happened there would be an OOM message in
the log which would give us a hint (I can add a special note that oom is
disabled but we are killing a task regardless to make it more obvious if
you prefer).

> Overall, this is a lot of complexity for something which doesn't
> really fix the problem and the comments while referring to the race
> don't mention that the implemented "fix" is broken, which is pretty
> bad as it gives readers of the code a false sense of security and
> another hurdle to overcome in actually tracking down what went wrong
> if this thing ever shows up as an actual breakage.

The patch description mentions that the race is not closed completely.
It is true that the comments in the code could have been more clear
about it.

> I'd strongly recommend implementing something which is actually
> correct.

I think the patch below should be safe. Would you prefer this solution
instead? It is race free but there is the risk that exposing a lock which
completely blocks OOM killer from the allocation path will kick us
later.
---
>From ef6227565fa65b52986c4626d49ba53b499e54d1 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 5 Nov 2014 11:49:14 +0100
Subject: [PATCH] OOM, PM: make OOM detection in the freezer path raceless

5695be142e20 (OOM, PM: OOM killed task shouldn't escape PM suspend)
has left a race window when OOM killer manages to note_oom_kill after
freeze_processes checks the counter. The race window is quite small
and really unlikely and deemed sufficient at the time of submission.

Tejun wasn't happy about this partial solution though and insisted on
a full solution. That requires the full OOM and freezer exclusion,
though. This is done by this patch which introduces oom_sem RW lock.
Page allocation OOM path takes the lock for reading because there might
be concurrent OOM happening on disjunct zonelists. oom_killer_disabled
check is moved right before out_of_memory is called because it was
checked too early before and we do not want to hold the lock while doing
the last attempt for allocation which might involve zone_reclaim.
freeze_processes then takes the lock for write throughout the whole
freezing process and OOM disabling.

There is no need to recheck all the processes with the full
synchronization anymore.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h    |  5 +++++
 kernel/power/process.c | 50 +++++++++-----------------------------------------
 mm/oom_kill.c          | 17 -----------------
 mm/page_alloc.c        | 24 ++++++++++++------------
 4 files changed, 26 insertions(+), 70 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index e8d6e1058723..350b9b2ffeec 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -73,7 +73,12 @@ extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
+/*
+ * oom_killer_disabled can be modified only under oom_sem taken for write
+ * and checked under read lock along with the full OOM handler.
+ */
 extern bool oom_killer_disabled;
+extern struct rw_semaphore oom_sem;
 
 static inline void oom_killer_disable(void)
 {
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5a6ec8678b9a..befce9785233 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -108,30 +108,6 @@ static int try_to_freeze_tasks(bool user_only)
 	return todo ? -EBUSY : 0;
 }
 
-static bool __check_frozen_processes(void)
-{
-	struct task_struct *g, *p;
-
-	for_each_process_thread(g, p)
-		if (p != current && !freezer_should_skip(p) && !frozen(p))
-			return false;
-
-	return true;
-}
-
-/*
- * Returns true if all freezable tasks (except for current) are frozen already
- */
-static bool check_frozen_processes(void)
-{
-	bool ret;
-
-	read_lock(&tasklist_lock);
-	ret = __check_frozen_processes();
-	read_unlock(&tasklist_lock);
-	return ret;
-}
-
 /**
  * freeze_processes - Signal user space processes to enter the refrigerator.
  * The current thread will not be frozen.  The same process that calls
@@ -142,7 +118,6 @@ static bool check_frozen_processes(void)
 int freeze_processes(void)
 {
 	int error;
-	int oom_kills_saved;
 
 	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
@@ -157,27 +132,20 @@ int freeze_processes(void)
 	pm_wakeup_clear();
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
-	oom_kills_saved = oom_kills_count();
+
+	/*
+	 * Need to exlude OOM killer from triggering while tasks are
+	 * getting frozen to make sure none of them gets killed after
+	 * try_to_freeze_tasks is done.
+	 */
+	down_write(&oom_sem);
 	error = try_to_freeze_tasks(true);
 	if (!error) {
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
 		oom_killer_disable();
-
-		/*
-		 * There might have been an OOM kill while we were
-		 * freezing tasks and the killed task might be still
-		 * on the way out so we have to double check for race.
-		 */
-		if (oom_kills_count() != oom_kills_saved &&
-		    !check_frozen_processes()) {
-			__usermodehelper_set_disable_depth(UMH_ENABLED);
-			printk("OOM in progress.");
-			error = -EBUSY;
-		} else {
-			printk("done.");
-		}
+		printk("done.\n");
 	}
-	printk("\n");
+	up_write(&oom_sem);
 	BUG_ON(in_atomic());
 
 	if (error)
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5340f6b91312..bbf405a3a18f 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -404,23 +404,6 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 		dump_tasks(memcg, nodemask);
 }
 
-/*
- * Number of OOM killer invocations (including memcg OOM killer).
- * Primarily used by PM freezer to check for potential races with
- * OOM killed frozen task.
- */
-static atomic_t oom_kills = ATOMIC_INIT(0);
-
-int oom_kills_count(void)
-{
-	return atomic_read(&oom_kills);
-}
-
-void note_oom_kill(void)
-{
-	atomic_inc(&oom_kills);
-}
-
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9cd36b822444..76095266c4b5 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -243,6 +243,7 @@ void set_pageblock_migratetype(struct page *page, int migratetype)
 }
 
 bool oom_killer_disabled __read_mostly;
+DECLARE_RWSEM(oom_sem);
 
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
@@ -2252,14 +2253,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	}
 
 	/*
-	 * PM-freezer should be notified that there might be an OOM killer on
-	 * its way to kill and wake somebody up. This is too early and we might
-	 * end up not killing anything but false positives are acceptable.
-	 * See freeze_processes.
-	 */
-	note_oom_kill();
-
-	/*
 	 * Go through the zonelist yet one more time, keep very high watermark
 	 * here, this is only to catch a parallel oom killing, we must fail if
 	 * we're still under heavy pressure.
@@ -2288,8 +2281,17 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 		if (gfp_mask & __GFP_THISNODE)
 			goto out;
 	}
-	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
+
+	/*
+	 * Exhausted what can be done so it's blamo time.
+	 * Just make sure that we cannot race with oom_killer disabling
+	 * e.g. PM freezer needs to make sure that no OOM happens after
+	 * all tasks are frozen.
+	 */
+	down_read(&oom_sem);
+	if (!oom_killer_disabled)
+		out_of_memory(zonelist, gfp_mask, order, nodemask, false);
+	up_read(&oom_sem);
 
 out:
 	oom_zonelist_unlock(zonelist, gfp_mask);
@@ -2716,8 +2718,6 @@ rebalance:
 	 */
 	if (!did_some_progress) {
 		if (oom_gfp_allowed(gfp_mask)) {
-			if (oom_killer_disabled)
-				goto nopage;
 			/* Coredumps can quickly deplete all memory reserves */
 			if ((current->flags & PF_DUMPCORE) &&
 			    !(gfp_mask & __GFP_NOFAIL))
-- 
2.1.1


-- 
Michal Hocko
SUSE Labs
