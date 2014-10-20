Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752569AbaJTSrI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 14:47:08 -0400
Received: from mail-wi0-f180.google.com ([209.85.212.180]:64623 "EHLO
	mail-wi0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750807AbaJTSrB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 14:47:01 -0400
Date: Mon, 20 Oct 2014 20:46:57 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Oleg Nesterov <oleg@redhat.com>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        David Rientjes <rientjes@google.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        linux-kernel@vger.kernel.org
Subject: Re: + oom-pm-oom-killed-task-cannot-escape-pm-suspend.patch added to
 -mm tree
Message-ID: <20141020184657.GA505@dhcp22.suse.cz>
References: <20141017171904.GA12263@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017171904.GA12263@redhat.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 17-10-14 19:19:04, Oleg Nesterov wrote:
> Michal, I am not really arguing with this patch, but since you are going
> (iiuc) to resend it anyway let me ask a couple of questions.
> 
> > This, however, still keeps
> > a window open when a killed task didn't manage to die by the time
> > freeze_processes finishes.
> 
> Sure,
> 
> > Fix this race by checking all tasks after OOM killer has been disabled.
> 
> But this doesn't close the race entirely? please see below.
> 
> >  int freeze_processes(void)
> >  {
> >  	int error;
> > +	int oom_kills_saved;
> >
> >  	error = __usermodehelper_disable(UMH_FREEZING);
> >  	if (error)
> > @@ -132,12 +133,40 @@ int freeze_processes(void)
> >  	pm_wakeup_clear();
> >  	printk("Freezing user space processes ... ");
> >  	pm_freezing = true;
> > +	oom_kills_saved = oom_kills_count();
> >  	error = try_to_freeze_tasks(true);
> >  	if (!error) {
> > -		printk("done.");
> >  		__usermodehelper_set_disable_depth(UMH_DISABLED);
> >  		oom_killer_disable();
> > +
> > +		/*
> > +		 * There was a OOM kill while we were freezing tasks
> > +		 * and the killed task might be still on the way out
> > +		 * so we have to double check for race.
> > +		 */
> > +		if (oom_kills_count() != oom_kills_saved) {
> 
> OK, I agree, this makes the things better, but perhaps we should document
> (at least in the changelog) that this is still racy. oom_killer_disable()
> obviously can stop the already called out_of_memory(), it can kill a frozen

I guess you meant "can't stop the already called..."

> task right after this check or even after the loop before.

You are right. The race window is still there. I've considered all tasks
being frozen already as sufficient but kernel threads and workqueue
items may allocate memory while we are freezing tasks and trigger OOM
killer as well. This will be inherently racy unless we use a locking
between freezer and OOM killer - which sounds too heavy to me. I can
reduce the race window by noting an OOM much earlier (when the allocator
enters OOM last round before OOM killer fires). The question is whether
this is sufficient because it is a half solution too.

> > +			struct task_struct *g, *p;
> > +
> > +			read_lock(&tasklist_lock);
> > +			do_each_thread(g, p) {
> > +				if (p == current || freezer_should_skip(p) ||
> > +				    frozen(p))
> > +					continue;
> > +				error = -EBUSY;
> > +				break;
> > +			} while_each_thread(g, p);
> 
> Please use for_each_process_thread(), do/while_each_thread is deprecated.

Sure, I was mimicking try_to_freeze_tasks which still uses the old
interface. Will send a patch which will use the new macro.

> > +/*
> > + * Number of OOM killer invocations (including memcg OOM killer).
> > + * Primarily used by PM freezer to check for potential races with
> > + * OOM killed frozen task.
> > + */
> > +static atomic_t oom_kills = ATOMIC_INIT(0);
> > +
> > +int oom_kills_count(void)
> > +{
> > +	return atomic_read(&oom_kills);
> > +}
> > +
> >  #define K(x) ((x) << (PAGE_SHIFT-10))
> >  /*
> >   * Must be called while holding a reference to p, which will be released upon
> > @@ -504,11 +516,13 @@ void oom_kill_process(struct task_struct
> >  			pr_err("Kill process %d (%s) sharing same memory\n",
> >  				task_pid_nr(p), p->comm);
> >  			task_unlock(p);
> > +			atomic_inc(&oom_kills);
> 
> Do we really need this? Can't freeze_processes() (ab)use oom_notify_list?

I would really prefer not using oom_notify_list. It is just an ugly
interface.

> Yes, we can have more false positives this way, but probably this doesn't
> matter? This is unlikely case anyway.

Yeah false positives are not a big deal.

I cannot say I would be happy about the following because it doesn't
close the race window completely but it is very well possible that
closing it completely would require much bigger changes and maybe this
is sufficient for now?
---
>From d5f7b3e8bb4859288a759635fdf502c6779faafd Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Mon, 20 Oct 2014 18:12:32 +0200
Subject: [PATCH] OOM, PM: OOM killed task cannot escape PM suspend

PM freezer relies on having all tasks frozen by the time devices are
getting frozen so that no task will touch them while they are getting
frozen. But OOM killer is allowed to kill an already frozen task in
order to handle OOM situtation. In order to protect from late wake ups
OOM killer is disabled after all tasks are frozen. This, however, still
keeps a window open when a killed task didn't manage to die by the time
freeze_processes finishes.

Reduce the race window by checking all tasks after OOM killer has been
disabled. This is still not race free completely unfortunately because
oom_killer_disable cannot stop an already ongoing OOM killer so a task
might still wake up from the fridge and get killed without
freeze_processes noticing. Full synchronization of OOM and freezer is,
however, too heavy weight for this highly unlikely case.

Introduce and check oom_kills counter which gets incremented early when
the allocator enters __alloc_pages_may_oom path and only check all the
tasks if the counter changes during the freezing attempt. The counter
is updated so early to reduce the race window since allocator checked
oom_killer_disabled which is set by PM-freezing code. A false positive
will push the PM-freezer into a slow path but that is not a big deal.

Fixes: f660daac474c6f (oom: thaw threads if oom killed thread is frozen before deferring)
Cc: Cong Wang <xiyou.wangcong@gmail.com>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: David Rientjes <rientjes@google.com>
Cc: Andrew Morton <akpm@linux-foundation.org>
Cc: stable@vger.kernel.org # 3.2+
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h    |  3 +++
 kernel/power/process.c | 31 ++++++++++++++++++++++++++++++-
 mm/oom_kill.c          | 17 +++++++++++++++++
 mm/page_alloc.c        |  8 ++++++++
 4 files changed, 58 insertions(+), 1 deletion(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 647395a1a550..e8d6e1058723 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -50,6 +50,9 @@ static inline bool oom_task_origin(const struct task_struct *p)
 extern unsigned long oom_badness(struct task_struct *p,
 		struct mem_cgroup *memcg, const nodemask_t *nodemask,
 		unsigned long totalpages);
+
+extern int oom_kills_count(void);
+extern void note_oom_kill(void);
 extern void oom_kill_process(struct task_struct *p, gfp_t gfp_mask, int order,
 			     unsigned int points, unsigned long totalpages,
 			     struct mem_cgroup *memcg, nodemask_t *nodemask,
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 4ee194eb524b..a397fa161d11 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -118,6 +118,7 @@ static int try_to_freeze_tasks(bool user_only)
 int freeze_processes(void)
 {
 	int error;
+	int oom_kills_saved;
 
 	error = __usermodehelper_disable(UMH_FREEZING);
 	if (error)
@@ -131,12 +132,40 @@ int freeze_processes(void)
 
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
+	oom_kills_saved = oom_kills_count();
 	error = try_to_freeze_tasks(true);
 	if (!error) {
-		printk("done.");
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
 		oom_killer_disable();
+
+		/*
+		 * There might have been an OOM kill while we were
+		 * freezing tasks and the killed task might be still
+		 * on the way out so we have to double check for race.
+		 */
+		if (oom_kills_count() != oom_kills_saved) {
+			struct task_struct *g, *p;
+
+			read_lock(&tasklist_lock);
+			for_each_process_thread(g, p) {
+				if (p == current || freezer_should_skip(p) ||
+				    frozen(p))
+					continue;
+				error = -EBUSY;
+				goto out_loop;
+			}
+out_loop:
+			read_unlock(&tasklist_lock);
+
+			if (error) {
+				__usermodehelper_set_disable_depth(UMH_ENABLED);
+				printk("OOM in progress.");
+				goto done;
+			}
+		}
+		printk("done.");
 	}
+done:
 	printk("\n");
 	BUG_ON(in_atomic());
 
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index bbf405a3a18f..5340f6b91312 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -404,6 +404,23 @@ static void dump_header(struct task_struct *p, gfp_t gfp_mask, int order,
 		dump_tasks(memcg, nodemask);
 }
 
+/*
+ * Number of OOM killer invocations (including memcg OOM killer).
+ * Primarily used by PM freezer to check for potential races with
+ * OOM killed frozen task.
+ */
+static atomic_t oom_kills = ATOMIC_INIT(0);
+
+int oom_kills_count(void)
+{
+	return atomic_read(&oom_kills);
+}
+
+void note_oom_kill(void)
+{
+	atomic_inc(&oom_kills);
+}
+
 #define K(x) ((x) << (PAGE_SHIFT-10))
 /*
  * Must be called while holding a reference to p, which will be released upon
diff --git a/mm/page_alloc.c b/mm/page_alloc.c
index c9710c9bbee2..e0c7832f8e5a 100644
--- a/mm/page_alloc.c
+++ b/mm/page_alloc.c
@@ -2252,6 +2252,14 @@ __alloc_pages_may_oom(gfp_t gfp_mask, unsigned int order,
 	}
 
 	/*
+	 * PM-freezer should be notified that there might be an OOM killer on its
+	 * way to kill and wake somebody up. This is too early and we might end
+	 * up not killing anything but false positives are acceptable.
+	 * See freeze_processes.
+	 */
+	note_oom_kill();
+
+	/*
 	 * Go through the zonelist yet one more time, keep very high watermark
 	 * here, this is only to catch a parallel oom killing, we must fail if
 	 * we're still under heavy pressure.
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
