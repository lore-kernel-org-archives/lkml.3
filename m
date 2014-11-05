Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754916AbaKEOPF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 09:15:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:52044 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754534AbaKEOPB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 09:15:01 -0500
Date: Wed, 5 Nov 2014 15:14:58 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141105141458.GE4527@dhcp22.suse.cz>
References: <1413876435-11720-1-git-send-email-mhocko@suse.cz>
 <2156351.pWp6MNRoWm@vostro.rjw.lan>
 <20141021141159.GE9415@dhcp22.suse.cz>
 <4766859.KSKPTm3b0x@vostro.rjw.lan>
 <20141021142939.GG9415@dhcp22.suse.cz>
 <20141104192705.GA22163@htj.dyndns.org>
 <20141105124620.GB4527@dhcp22.suse.cz>
 <20141105130247.GA14386@htj.dyndns.org>
 <20141105133100.GC4527@dhcp22.suse.cz>
 <20141105134219.GD4527@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105134219.GD4527@dhcp22.suse.cz>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-11-14 14:42:19, Michal Hocko wrote:
> On Wed 05-11-14 14:31:00, Michal Hocko wrote:
> > On Wed 05-11-14 08:02:47, Tejun Heo wrote:
> [...]
> > > Also, why isn't this part of
> > > oom_killer_disable/enable()?  The way they're implemented is really
> > > silly now.  It just sets a flag and returns whether there's a
> > > currently running instance or not.  How were these even useful? 
> > > Why can't you just make disable/enable to what they were supposed to
> > > do from the beginning?
> > 
> > Because then we would block all the potential allocators coming from
> > workqueues or kernel threads which are not frozen yet rather than fail
> > the allocation.
> 
> After thinking about this more it would be doable by using trylock in
> the allocation oom path. I will respin the patch. The API will be
> cleaner this way.
---
>From 33654faeea161ef9a411f9ff6d84419712bb4a0f Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 5 Nov 2014 15:09:56 +0100
Subject: [PATCH] OOM, PM: make OOM detection in the freezer path raceless

5695be142e20 (OOM, PM: OOM killed task shouldn't escape PM suspend)
has left a race window when OOM killer manages to note_oom_kill after
freeze_processes checks the counter. The race window is quite small
and really unlikely and deemed sufficient at the time of submission.

Tejun wasn't happy about this partial solution though and insisted on
a full solution. That requires the full OOM and freezer exclusion,
though. This is done by this patch which introduces oom_sem RW lock
and gets rid of oom_killer_disabled global flag.

The PM code uses oom_killer_{disable,enable} which takes the lock
for write and exclude all the OOM killer invocation from the page
allocation path.

The allocation path uses oom_killer_allowed_{begin,end} around
__alloc_pages_may_oom call. This is implemented by a read trylock so all
the concurrent OOM killers (operating on different zonlists) are allowed
to proceed unless OOM is disabled when the allocation simply fails.

There is no need to recheck all the processes with the full
synchronization anymore.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h    | 33 ++++++++++++++++++++++++---------
 kernel/power/process.c | 50 ++++++++------------------------------------------
 mm/oom_kill.c          | 39 ++++++++++++++++++++++-----------------
 mm/page_alloc.c        | 21 +++++++++------------
 4 files changed, 63 insertions(+), 80 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index e8d6e1058723..850f7f653eb7 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -73,17 +73,32 @@ extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
-extern bool oom_killer_disabled;
+/**
+ * oom_killer_disable - disable OOM killer in page allocator
+ *
+ * Forces all page allocations to fail rather than trigger OOM killer.
+ */
+extern void oom_killer_disable(void);
 
-static inline void oom_killer_disable(void)
-{
-	oom_killer_disabled = true;
-}
+/**
+ * oom_killer_enable - enable OOM killer
+ */
+extern void oom_killer_enable(void);
 
-static inline void oom_killer_enable(void)
-{
-	oom_killer_disabled = false;
-}
+/**
+ * oom_killer_allowed_start - start OOM killer section
+ *
+ * Synchronise with oom_killer_{disable,enable} sections.
+ * Returns 1 if oom_killer is allowed.
+ */
+extern int oom_killer_allowed_start(void);
+
+/**
+ * oom_killer_allowed_end - end OOM killer section
+ *
+ * previously started by oom_killer_allowed_end.
+ */
+extern void oom_killer_allowed_end(void);
 
 static inline bool oom_gfp_allowed(gfp_t gfp_mask)
 {
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 5a6ec8678b9a..7d08d56cbf3f 100644
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
@@ -157,27 +132,18 @@ int freeze_processes(void)
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
+	oom_killer_disable();
 	error = try_to_freeze_tasks(true);
 	if (!error) {
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
-		oom_killer_disable();
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
 	BUG_ON(in_atomic());
 
 	if (error)
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index 5340f6b91312..7fc75b4df837 100644
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
@@ -615,6 +598,28 @@ void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
 	spin_unlock(&zone_scan_lock);
 }
 
+static DECLARE_RWSEM(oom_sem);
+
+void oom_killer_disabled(void)
+{
+	down_write(&oom_sem);
+}
+
+void oom_killer_enable(void)
+{
+	up_write(&oom_sem);
+}
+
+int oom_killer_allowed_start(void)
+{
+	return down_read_trylock(&oom_sem);
+}
+
+void oom_killer_allowed_end(void)
+{
+	up_read(&oom_sem);
+}
+
 /**
  * out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9cd36b822444..206ce46ce975 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -242,8 +242,6 @@ void set_pageblock_migratetype(struct page *page, int migratetype)
 					PB_migrate, PB_migrate_end);
 }
 
-bool oom_killer_disabled __read_mostly;
-
 #ifdef CONFIG_DEBUG_VM
 static int page_outside_zone_boundaries(struct zone *zone, struct page *page)
 {
@@ -2252,14 +2250,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
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
@@ -2716,16 +2706,23 @@ rebalance:
 	 */
 	if (!did_some_progress) {
 		if (oom_gfp_allowed(gfp_mask)) {
-			if (oom_killer_disabled)
-				goto nopage;
 			/* Coredumps can quickly deplete all memory reserves */
 			if ((current->flags & PF_DUMPCORE) &&
 			    !(gfp_mask & __GFP_NOFAIL))
 				goto nopage;
+			/*
+			 * Just make sure that we cannot race with oom_killer
+			 * disabling e.g. PM freezer needs to make sure that
+			 * no OOM happens after all tasks are frozen.
+			 */
+			if (!oom_killer_allowed_start())
+				goto nopage;
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
 					classzone_idx, migratetype);
+			oom_killer_allowed_end();
+
 			if (page)
 				goto got_pg;
 
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
