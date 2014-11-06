Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751714AbaKFNFs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 08:05:48 -0500
Received: from cantor2.suse.de ([195.135.220.15]:49964 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751141AbaKFNFq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 08:05:46 -0500
Date: Thu, 6 Nov 2014 14:05:43 +0100
From: Michal Hocko <mhocko@suse.cz>
To: Tejun Heo <tj@kernel.org>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Andrew Morton <akpm@linux-foundation.org>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        David Rientjes <rientjes@google.com>, Oleg Nesterov <oleg@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        Linux PM list <linux-pm@vger.kernel.org>
Subject: Re: [PATCH 3/4] OOM, PM: OOM killed task shouldn't escape PM suspend
Message-ID: <20141106130543.GE7202@dhcp22.suse.cz>
References: <20141105124620.GB4527@dhcp22.suse.cz>
 <20141105130247.GA14386@htj.dyndns.org>
 <20141105133100.GC4527@dhcp22.suse.cz>
 <20141105134219.GD4527@dhcp22.suse.cz>
 <20141105154436.GB14386@htj.dyndns.org>
 <20141105160115.GA28226@dhcp22.suse.cz>
 <20141105162929.GD14386@htj.dyndns.org>
 <20141105163956.GD28226@dhcp22.suse.cz>
 <20141105165428.GF14386@htj.dyndns.org>
 <20141105170111.GG14386@htj.dyndns.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141105170111.GG14386@htj.dyndns.org>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed 05-11-14 12:01:11, Tejun Heo wrote:
> On Wed, Nov 05, 2014 at 11:54:28AM -0500, Tejun Heo wrote:
> > > Still not following. How do you want to detect an on-going OOM without
> > > any interface around out_of_memory?
> > 
> > I thought you were using oom_killer_allowed_start() outside OOM path.
> > Ugh.... why is everything weirdly structured?  oom_killer_disabled
> > implies that oom killer may fail, right?  Why is
> > __alloc_pages_slowpath() checking it directly?  If whether oom killing
> > failed or not is relevant to its users, make out_of_memory() return an
> > error code.  There's no reason for the exclusion detail to leak out of
> > the oom killer proper.  The only interface should be disable/enable
> > and whether oom killing failed or not.
> 
> And what's implemented is wrong.  What happens if oom killing is
> already in progress and then a task blocks trying to write-lock the
> rwsem and then that task is selected as the OOM victim?

But this is nothing new. Suspend hasn't been checking for fatal signals
nor for TIF_MEMDIE since the OOM disabling was introduced and I suppose
even before.

This is not harmful though. The previous OOM kill attempt would kick the
current TASK and mark it with TIF_MEMDIE and retry the allocation. After
OOM is disabled the allocation simply fails. The current will die on its
way out of the kernel. Definitely worth fixing. In a separate patch.

> disable() call must be able to fail.

This would be a way to do it without requiring caller to check for
TIF_MEMDIE explicitly. The fewer of them we have the better.
---
>From 3a7e18144a369bfc537c1cda4c7c2c548e9114b8 Mon Sep 17 00:00:00 2001
From: Michal Hocko <mhocko@suse.cz>
Date: Thu, 6 Nov 2014 11:51:34 +0100
Subject: [PATCH] OOM, PM: handle pm freezer as an OOM victim correctly

PM freezer doesn't check whether it has been killed by OOM killer
after it disables OOM killer which means that it continues with the
suspend even though it should die as soon as possible. This has been
the case ever since PM suspend disables OOM killer and I suppose
it has ignored OOM even before.

This is not harmful though. The allocation which triggers OOM will
retry the allocation after a process is killed and the next attempt
will fail because the OOM killer will be disabled at the time so
there is no risk of an endless loop because the OOM victim doesn't
die.

But this is a correctness issue because no task should ignore OOM.
As suggested by Tejun, oom_killer_disable will return a success status
now. If the current task is pending fatal signals or TIF_MEMDIE is set
after oom_sem is taken then the caller should bail out and this is what
freeze_processes does with this patch.

Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 include/linux/oom.h    |  4 +++-
 kernel/power/process.c | 16 ++++++++++------
 mm/oom_kill.c          | 12 +++++++++++-
 3 files changed, 24 insertions(+), 8 deletions(-)

diff --git a/include/linux/oom.h b/include/linux/oom.h
index 4af99a9b543b..a978bf2b02a1 100644
--- a/include/linux/oom.h
+++ b/include/linux/oom.h
@@ -77,8 +77,10 @@ extern int unregister_oom_notifier(struct notifier_block *nb);
  * oom_killer_disable - disable OOM killer in page allocator
  *
  * Forces all page allocations to fail rather than trigger OOM killer.
+ * Returns true on success and fails if the OOM killer couldn't be
+ * disabled (e.g. because the current task has been killed before)
  */
-extern void oom_killer_disable(void);
+extern bool oom_killer_disable(void);
 
 /**
  * oom_killer_enable - enable OOM killer
diff --git a/kernel/power/process.c b/kernel/power/process.c
index 7d08d56cbf3f..0f8b782f9215 100644
--- a/kernel/power/process.c
+++ b/kernel/power/process.c
@@ -123,6 +123,16 @@ int freeze_processes(void)
 	if (error)
 		return error;
 
+	/*
+	 * Need to exlude OOM killer from triggering while tasks are
+	 * getting frozen to make sure none of them gets killed after
+	 * try_to_freeze_tasks is done.
+	 */
+	if (!oom_killer_disable()) {
+		usermodehelper_enable();
+		return -EBUSY;
+	}
+
 	/* Make sure this task doesn't get frozen */
 	current->flags |= PF_SUSPEND_TASK;
 
@@ -133,12 +143,6 @@ int freeze_processes(void)
 	printk("Freezing user space processes ... ");
 	pm_freezing = true;
 
-	/*
-	 * Need to exlude OOM killer from triggering while tasks are
-	 * getting frozen to make sure none of them gets killed after
-	 * try_to_freeze_tasks is done.
-	 */
-	oom_killer_disable();
 	error = try_to_freeze_tasks(true);
 	if (!error) {
 		__usermodehelper_set_disable_depth(UMH_DISABLED);
diff --git a/mm/oom_kill.c b/mm/oom_kill.c
index f80c5b777f05..58ade54ee421 100644
--- a/mm/oom_kill.c
+++ b/mm/oom_kill.c
@@ -600,9 +600,19 @@ void oom_zonelist_unlock(struct zonelist *zonelist, gfp_t gfp_mask)
 
 static DECLARE_RWSEM(oom_sem);
 
-void oom_killer_disable(void)
+bool oom_killer_disable(void)
 {
+	bool ret = true;
+
 	down_write(&oom_sem);
+
+	/* We might have been killed while waiting for the oom_sem. */
+	if (fatal_signal_pending(current) || test_thread_flag(TIF_MEMDIE)) {
+		up_write(&oom_sem);
+		ret = false;
+	}
+
+	return ret;
 }
 
 void oom_killer_enable(void)
-- 
2.1.1


-- 
Michal Hocko
SUSE Labs
