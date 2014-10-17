Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753332AbaJQHq7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 03:46:59 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35435 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750729AbaJQHq6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 03:46:58 -0400
Date: Fri, 17 Oct 2014 09:46:54 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>
Cc: Oleg Nesterov <oleg@redhat.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH -v2] freezer: check OOM kill while being frozen
Message-ID: <20141017074654.GD8076@dhcp22.suse.cz>
References: <20141016203954.GA26336@redhat.com>
 <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com>
 <20141016211136.GA27468@redhat.com>
 <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com>
 <20141016213512.GA28099@redhat.com>
 <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com>
 <20141016222237.GA30063@redhat.com>
 <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 16-10-14 19:33:39, Cong Wang wrote:
> On Thu, Oct 16, 2014 at 3:22 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> > On 10/16, Cong Wang wrote:
> >>
> >> On Thu, Oct 16, 2014 at 2:35 PM, Oleg Nesterov <oleg@redhat.com> wrote:
> >> >
> >> > If a task B is already frozen, it sleeps in D state.
> >> >
> >> > If OOM selects B as a victim after that, it won't be woken by
> >> > SIGKILL, thus it obviously can't call should_thaw_current() and
> >> > notice TIF_MEMDIE.
> >>
> >> I see your point now, it would be more clear if you can just quote
> >> the patch instead of changelog.
> >>
> >> So are you saying the loop in __refrigerator() is useless?
> >
> > No.
> >
> >> Since
> >> it will always stay in asleep after schedule()?
> >
> > Not always. But it will stay asleep in this particular case.
> 
> Hmm, so we still need to wake it up in oom killer:
> 
>         if (test_tsk_thread_flag(task, TIF_MEMDIE)) {
>                if (unlikely(frozen(task)))
>                       wake_up_state(task, TASK_UNINTERRUPTIBLE);
> 
> I will update the patch if Michal doesn't.

I think we should rather get back to __thaw_task here.

Andrew could you replace the previous version by this one, please? Again
I am sorry I haven't caught that before.
---
>From 830324c8be8b499e1d18a73076cf4d126c4ac486 Mon Sep 17 00:00:00 2001
From: Cong Wang <xiyou.wangcong@gmail.com>
Date: Thu, 4 Sep 2014 15:30:41 -0700
Subject: [PATCH -v2] freezer: check OOM kill while being frozen

Since f660daac474c6f (oom: thaw threads if oom killed thread is frozen
before deferring) OOM killer relies on being able to thaw a frozen task
to handle OOM situation but a3201227f803 (freezer: make freezing() test
freeze conditions in effect instead of TIF_FREEZE) has reorganized the
code and stopped clearing freeze flag in __thaw_task. This means that
the target task only wakes up and goes into the fridge again because the
freezing condition hasn't changed for it. This reintroduces the bug
fixed by f660daac474c6f.

Fix the issue by checking for TIF_MEMDIE thread flag and get away from
the fridge if it is set.

Changes since v1
- return __thaw_task into oom_scan_process_thread because
  oom_kill_process will not wake task in the fridge because it is
  sleeping uninterruptible

[mhocko@suse.cz: rewrote the changelog]
Fixes: a3201227f803 (freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE)
Cc: stable@vger.kernel.org # 3.3+
Cc: David Rientjes <rientjes@google.com>
Cc: Michal Hocko <mhocko@suse.cz>
Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
Cc: Tejun Heo <tj@kernel.org>
Cc: Andrew Morton <akpm@linux-foundation.org>
Acked-by: Michal Hocko <mhocko@suse.cz>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Michal Hocko <mhocko@suse.cz>
---
 kernel/freezer.c | 20 +++++++++++++++++---
 1 file changed, 17 insertions(+), 3 deletions(-)

diff --git a/kernel/freezer.c b/kernel/freezer.c
index aa6a8aadb911..77ad6794b610 100644
--- a/kernel/freezer.c
+++ b/kernel/freezer.c
@@ -45,13 +45,28 @@ bool freezing_slow_path(struct task_struct *p)
 	if (pm_nosig_freezing || cgroup_freezing(p))
 		return true;
 
-	if (pm_freezing && !(p->flags & PF_KTHREAD))
+	if (!(p->flags & PF_KTHREAD))
 		return true;
 
 	return false;
 }
 EXPORT_SYMBOL(freezing_slow_path);
 
+static bool should_thaw_current(bool check_kthr_stop)
+{
+	if (!freezing(current))
+		return true;
+
+	if (check_kthr_stop && kthread_should_stop())
+		return true;
+
+	/* It might not be safe to check TIF_MEMDIE for pm freeze. */
+	if (cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))
+		return true;
+
+	return false;
+}
+
 /* Refrigerator is place where frozen processes are stored :-). */
 bool __refrigerator(bool check_kthr_stop)
 {
@@ -67,8 +82,7 @@ bool __refrigerator(bool check_kthr_stop)
 
 		spin_lock_irq(&freezer_lock);
 		current->flags |= PF_FROZEN;
-		if (!freezing(current) ||
-		    (check_kthr_stop && kthread_should_stop()))
+		if (should_thaw_current(check_kthr_stop))
 			current->flags &= ~PF_FROZEN;
 		spin_unlock_irq(&freezer_lock);
 
-- 
2.1.1

-- 
Michal Hocko
SUSE Labs
