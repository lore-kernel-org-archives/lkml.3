Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752550AbaJTRoK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Oct 2014 13:44:10 -0400
Received: from mx1.redhat.com ([209.132.183.28]:24930 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752165AbaJTRoF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Oct 2014 13:44:05 -0400
Date: Mon, 20 Oct 2014 19:40:43 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] freezer: check OOM kill while being frozen
Message-ID: <20141020174043.GA17089@redhat.com>
References: <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com> <20141016211136.GA27468@redhat.com> <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com> <20141016213512.GA28099@redhat.com> <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com> <20141016222237.GA30063@redhat.com> <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com> <20141017074654.GD8076@dhcp22.suse.cz> <20141017161021.GC7227@redhat.com> <20141020151723.GA4603@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141020151723.GA4603@dhcp22.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/20, Michal Hocko wrote:
>
> On Fri 17-10-14 18:10:21, Oleg Nesterov wrote:
>
> > And if this is not safe, it is not clear how/why cgroup_freezing() can
> > save us, both pm_freezing and CGROUP_FREEZING can be true?
>
> You mean that the pm_freezer would race with cgroup one?

Yes, so if we actually want this check we should probably check
!pm_freezing or update the comment.

Nevermind, you removed this check and I agree. Even if we add it back
for some reason, it can come in a separate patch with the detailed
explanation.

> > And I think that this TIF_MEMDIE should go into freezing_slow_path(),
> > so we do not even need should_thaw_current().
>
> OK, it would make the patch simpler. On the other hand having the check
> in the __refrigerator makes it easier to follow. freezing is called from
> too many places. But I see your point, I guess. It really doesn't make
> sense to go into fridge when it is clear that the task wouldn't get
> frozen anyway. Some users even check the return value of freezing and do
> different things in two paths. Those seem to be mostly kernel threads
> but I haven't checked all the places. Anyway this should be irrelevant
> to the OOM POV.

Yes, thanks.

> > This also looks more safe to me. Suppose that a task does
> >
> > 	while (try_to_freeze())
> > 		;
> >
> > Yes, this is pointless but correct. And in fact I think this pattern
> > is possible. If this task is killed by OOM, it will spin forever.
>
> I am really not sure what such a code would be supposed to do.

and I actually meant

	while (freezing())
		try_to_freeze();

yes, sure, this looks strange and pointless. But still correct. And you
never know what some driver can do. This pattern can be hidden in a more
complex code, say,

	for (;;) {
		lock_something();
		// we can't use wait_event_freezable() under the lock
		wait_event_interruptible(condition() || freezing());
		// check this before signal_pending() to avoid the restart,
		// or we can't restart, or it was just written this way for
		// no reason.
		if (freezing()) {
			unlock_something();
			try_to_freeze();
			continue;
		}
		unlock_something();

		if (signal_pending())
			break;

		...
	}

sure, most probably the code like this asks for cleanups, but it is easy
to notice that it is actually wrong if try_to_freeze() could return with
freezing() == T. But I agree, this issue is minor.

> Does it make more sense to you now, Oleg?

Thanks!

Acked-by: Oleg Nesterov <oleg@redhat.com>





> From 6e8b92e7133307e30afe35c6a0637cb58c0fc147 Mon Sep 17 00:00:00 2001
> From: Cong Wang <xiyou.wangcong@gmail.com>
> Date: Mon, 20 Oct 2014 17:16:01 +0200
> Subject: [PATCH] freezer: check OOM kill while being frozen
> 
> Since f660daac474c6f (oom: thaw threads if oom killed thread is frozen
> before deferring) OOM killer relies on being able to thaw a frozen task
> to handle OOM situation but a3201227f803 (freezer: make freezing() test
> freeze conditions in effect instead of TIF_FREEZE) has reorganized the
> code and stopped clearing freeze flag in __thaw_task. This means that
> the target task only wakes up and goes into the fridge again because the
> freezing condition hasn't changed for it. This reintroduces the bug
> fixed by f660daac474c6f.
> 
> Fix the issue by checking for TIF_MEMDIE thread flag in
> freezing_slow_path and exclude the task from freezing completely. If a
> task was already frozen it would get woken by __thaw_task from OOM killer
> and get out of freezer after rechecking freezing().
> 
> Changes since v1
> - put TIF_MEMDIE check into freezing_slowpath rather than in __refrigerator
>   as per Oleg
> - return __thaw_task into oom_scan_process_thread because
>   oom_kill_process will not wake task in the fridge because it is
>   sleeping uninterruptible
> 
> [mhocko@suse.cz: rewrote the changelog]
> Fixes: a3201227f803 (freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE)
> Cc: stable@vger.kernel.org # 3.3+
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Acked-by: Michal Hocko <mhocko@suse.cz>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> Signed-off-by: Michal Hocko <mhocko@suse.cz>
> ---
>  kernel/freezer.c | 3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index aa6a8aadb911..8f9279b9c6d7 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -42,6 +42,9 @@ bool freezing_slow_path(struct task_struct *p)
>  	if (p->flags & (PF_NOFREEZE | PF_SUSPEND_TASK))
>  		return false;
>  
> +	if (test_thread_flag(TIF_MEMDIE))
> +		return false;
> +
>  	if (pm_nosig_freezing || cgroup_freezing(p))
>  		return true;
>  
> -- 
> 2.1.1
> 
> -- 
> Michal Hocko
> SUSE Labs

