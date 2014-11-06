Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751385AbaKFQC1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 11:02:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:56156 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750955AbaKFQCZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 11:02:25 -0500
Date: Thu, 6 Nov 2014 17:02:23 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141106160223.GJ7202@dhcp22.suse.cz>
References: <20141105134219.GD4527@dhcp22.suse.cz>
 <20141105154436.GB14386@htj.dyndns.org>
 <20141105160115.GA28226@dhcp22.suse.cz>
 <20141105162929.GD14386@htj.dyndns.org>
 <20141105163956.GD28226@dhcp22.suse.cz>
 <20141105165428.GF14386@htj.dyndns.org>
 <20141105174609.GE28226@dhcp22.suse.cz>
 <20141105175527.GH14386@htj.dyndns.org>
 <20141106124953.GD7202@dhcp22.suse.cz>
 <20141106150121.GA25642@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141106150121.GA25642@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 06-11-14 10:01:21, Tejun Heo wrote:
> On Thu, Nov 06, 2014 at 01:49:53PM +0100, Michal Hocko wrote:
> > On Wed 05-11-14 12:55:27, Tejun Heo wrote:
> > > On Wed, Nov 05, 2014 at 06:46:09PM +0100, Michal Hocko wrote:
> > > > Because out_of_memory can be called from mutliple paths. And
> > > > the only interesting one should be the page allocation path.
> > > > pagefault_out_of_memory is not interesting because it cannot happen for
> > > > the frozen task.
> > > 
> > > Hmmm.... wouldn't that be broken by definition tho?  So, if the oom
> > > killer is invoked from somewhere else than page allocation path, it
> > > would proceed ignoring the disabled setting and would race against PM
> > > freeze path all the same. 
> > 
> > Not really because try_to_freeze_tasks doesn't finish until _all_ tasks
> > are frozen and a task in the page fault path cannot be frozen, can it?
> 
> We used to have freezing points deep in file system code which may be
> reacheable from page fault.

If that is really the case then there is no way around and use
out_of_memory from the page fault path as well. I cannot say I would be
happy about that though. There should be ideally only single freezing
place. But that is another story.

> Please take a step back and look at the paragraph above.  Doesn't
> it sound extremely contrived and brittle even if it's not outright
> broken?  What if somebody adds another oom killing site somewhere
> else?

The only way to add an oom killing site is out_of_memory and that does
all the magic with my patch.

> How can this possibly be a solution that we intentionally implement?
>
> > I mean there shouldn't be any problem to not invoke OOM killer under
> > from the page fault path as well but that might lead to looping in the
> > page fault path without any progress until freezer enables OOM killer on
> > the failure path because the said task cannot be frozen.
> > 
> > Is this preferable?
> 
> Why would PM freezing make OOM killing fail?  That doesn't make much
> sense.  Sure, it can block it for a finite duration for sync purposes
> but making OOM killing fail seems the wrong way around.  

We cannot block in the allocation path because the request might come
from the freezer path itself (e.g. when suspending devices etc.).
At least this is my understanding why the original oom disable approach
was implemented.

> We're doing one thing for non-PM freezing and the other way around for
> PM freezing, which indicates one of the two directions is wrong.

Because those two paths are quite different in their requirements. The
cgroup freezer only cares about freezing tasks and it doesn't have to
care about tasks accessing a possibly half suspended device on their way
out.

> Shouldn't it be that OOM killing happening while PM freezing is in
> progress cancels PM freezing rather than the other way around?  Find a
> point in PM suspend/hibernation operation where everything must be
> stable, disable OOM killing there and check whether OOM killing
> happened inbetween and if so back out. 

This is freeze_processes AFAIU. I might be wrong of course but this is
the time since when nobody should be waking processes up because they
could access half suspended devices.

> It seems rather obvious to me that OOM killing has to have precedence
> over PM freezing.
> 
> Sure, once the system reaches a point where the whole system must be
> in a stable state for snapshotting or whatever, disabling OOM killing
> is fine but at that point the system is in a very limited execution
> mode and sure won't be processing page faults from userland for
> example and we can actually disable OOM killing knowing that anything
> afterwards is ready to handle memory allocation failures.

I am really confused now. This is basically what the final patch does
actually.  Here is the what I have currently just to make the further
discussion easier.
---
>From 337e772eaf636a96409e84bcd33d77ebc2950549 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Wed, 5 Nov 2014 15:09:56 +0100
Subject: [PATCH 1/2] OOM, PM: make OOM detection in the freezer path raceless

5695be142e20 (OOM, PM: OOM killed task shouldn't escape PM suspend)
has left a race window when OOM killer manages to note_oom_kill after
freeze_processes checks the counter. The race window is quite small and
really unlikely and partial solution deemed sufficient at the time of
submission.

Tejun wasn't happy about this partial solution though and insisted on
a full solution. That requires the full OOM and freezer exclusion,
though. This is done by this patch which introduces oom_sem RW lock
and gets rid of oom_killer_disabled global flag.

The PM code uses oom_killer_{disable,enable} which takes the lock
for write and excludes all the OOM killer invocation from any
out_of_memory users which newly returns a success status. It fails
only if the oom_sem cannot be taken for read which indicates that
OOM has been disabled. This is done by read trylock so we can never
deadlock.

The caller has to take an appropriate action when the out_of_memory
fails.

The allocation path simply fails the allocation request the same
way as previously. Sysrq path notes that the OOM didn't happen due to
OOM disable.

The page fault path ignored oom disabled flag previously with an
assumption that the page fault path cannot enter the fridge. As per
Tejun the freezing point used to be deep in the fs code. Therefore it
is safer and more robust to include pagefault_out_of_memory as well.
The task will be refaulting until there is some memory freed or PM
freezer fails because the said task cannot be frozen and re-enable OOM
killer when the OOM eventually happens if the memory still short.

There is no need to recheck all the processes with the full
synchronization anymore.

Suggested-by: Tejun Heo <tj@kernel.org>
Signed-off-by: Michal Hocko <mhocko@suse.cz>

fold me
---
 drivers/tty/sysrq.c    |  6 ++++--
 include/linux/oom.h    | 25 +++++++++++++----------
 kernel/power/process.c | 50 ++++++++--------------------------------------
 mm/oom_kill.c          | 54 ++++++++++++++++++++++++++++++++------------------
 mm/page_alloc.c        | 32 +++++++++++++++---------------
 5 files changed, 77 insertions(+), 90 deletions(-)

diff --git a/drivers/tty/sysrq.c b/drivers/tty/sysrq.c
index 42bad18c66c9..14f3d7fd961f 100644
--- a/drivers/tty/sysrq.c
+++ b/drivers/tty/sysrq.c
@@ -355,8 +355,10 @@ static struct sysrq_key_op sysrq_term_op = {
 
 static void moom_callback(struct work_struct *ignored)
 {
-	out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL), GFP_KERNEL,
-		      0, NULL, true);
+	if (!out_of_memory(node_zonelist(first_memory_node, GFP_KERNEL),
+			   GFP_KERNEL, 0, NULL, true)) {
+		printk(KERN_INFO "OOM killer disabled\n");
+	}
 }
 
 static DECLARE_WORK(moom_work, moom_callback);
diff --git a/include/linux/oom.h b/include/linux/oom.h
index e8d6e1058723..04b892ddca7d 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -68,22 +68,25 @@ extern enum oom_scan_t oom_scan_process_thread(struct task_struct *task,
 		unsigned long totalpages, const nodemask_t *nodemask,
 		bool force_kill);
 
-extern void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+extern bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *mask, bool force_kill);
 extern int register_oom_notifier(struct notifier_block *nb);
 extern int unregister_oom_notifier(struct notifier_block *nb);
 
-extern bool oom_killer_disabled;
-
-static inline void oom_killer_disable(void)
-{
-	oom_killer_disabled = true;
-}
+/**
+ * oom_killer_disable - disable OOM killer in page allocator
+ *
+ * Forces all page allocations to fail rather than trigger OOM killer.
+ *
+ * This function should be used with an extreme care and any new usage
+ * should be consulted with MM people.
+ */
+extern void oom_killer_disable(void);
 
-static inline void oom_killer_enable(void)
-{
-	oom_killer_disabled = false;
-}
+/**
+ * oom_killer_enable - enable OOM killer
+ */
+extern void oom_killer_enable(void);
 
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
index 5340f6b91312..7f88ddd55f80 100644
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
@@ -615,8 +598,20 @@ void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
 	spin_unlock(&zone_scan_lock);
 }
 
+static DECLARE_RWSEM(oom_sem);
+
+void oom_killer_disable(void)
+{
+	down_write(&oom_sem);
+}
+
+void oom_killer_enable(void)
+{
+	up_write(&oom_sem);
+}
+
 /**
- * out_of_memory - kill the "best" process when we run out of memory
+ * __out_of_memory - kill the "best" process when we run out of memory
  * @zonelist: zonelist pointer
  * @gfp_mask: memory allocation flags
  * @order: amount of memory being requested as a power of 2
@@ -628,7 +623,7 @@ void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
  * OR try to be smart about which process to kill. Note that we
  * don't have to be perfect here, we just have to be good.
  */
-void out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+static void __out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
 		int order, nodemask_t *nodemask, bool force_kill)
 {
 	const nodemask_t *mpol_mask;
@@ -693,6 +688,27 @@ out:
 		schedule_timeout_killable(1);
 }
 
+/** out_of_memory -  tries to invoke OOM killer.
+ * @zonelist: zonelist pointer
+ * @gfp_mask: memory allocation flags
+ * @order: amount of memory being requested as a power of 2
+ * @nodemask: nodemask passed to page allocator
+ * @force_kill: true if a task must be killed, even if others are exiting
+ *
+ * invokes __out_of_memory if the OOM is not disabled by oom_killer_disable()
+ * when it returns false. Otherwise returns true.
+ */
+bool out_of_memory(struct zonelist *zonelist, gfp_t gfp_mask,
+		int order, nodemask_t *nodemask, bool force_kill)
+{
+	if (!down_read_trylock(&oom_sem))
+		return false;
+	__out_of_memory(zonelist, gfp_mask, order, nodemask, force_kill);
+	up_read(&oom_sem);
+
+	return true;
+}
+
 /*
  * The pagefault handler calls here because it is out of memory, so kill a
  * memory-hogging task.  If any populated zone has ZONE_OOM_LOCKED set, a
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index 9cd36b822444..d44d69aa7b70 100644
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
@@ -2241,10 +2239,11 @@ static inline struct page *
 __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	struct zonelist *zonelist, enum zone_type high_zoneidx,
 	nodemask_t *nodemask, struct zone *preferred_zone,
-	int classzone_idx, int migratetype)
+	int classzone_idx, int migratetype, bool *oom_failed)
 {
 	struct page *page;
 
+	*oom_failed = false;
 	/* Acquire the per-zone oom lock for each zone */
 	if (!oom_zonelist_trylock(zonelist, gfp_mask)) {
 		schedule_timeout_uninterruptible(1);
@@ -2252,14 +2251,6 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
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
@@ -2289,8 +2280,8 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 			goto out;
 	}
 	/* Exhausted what can be done so it's blamo time */
-	out_of_memory(zonelist, gfp_mask, order, nodemask, false);
-
+	if (!out_of_memory(zonelist, gfp_mask, order, nodemask, false))
+		*oom_failed = true;
 out:
 	oom_zonelist_unlock(zonelist, gfp_mask);
 	return page;
@@ -2716,8 +2707,8 @@ rebalance:
 	 */
 	if (!did_some_progress) {
 		if (oom_gfp_allowed(gfp_mask)) {
-			if (oom_killer_disabled)
-				goto nopage;
+			bool oom_failed;
+
 			/* Coredumps can quickly deplete all memory reserves */
 			if ((current->flags & PF_DUMPCORE) &&
 			    !(gfp_mask & __GFP_NOFAIL))
@@ -2725,10 +2716,19 @@ rebalance:
 			page = __alloc_pages_may_oom(gfp_mask, order,
 					zonelist, high_zoneidx,
 					nodemask, preferred_zone,
-					classzone_idx, migratetype);
+					classzone_idx, migratetype,
+					&oom_failed);
+
 			if (page)
 				goto got_pg;
 
+			/*
+			 * OOM killer might be disabled and then we have to
+			 * fail the allocation
+			 */
+			if (oom_failed)
+				goto nopage;
+
 			if (!(gfp_mask & __GFP_NOFAIL)) {
 				/*
 				 * The oom killer is not called for high-order
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
