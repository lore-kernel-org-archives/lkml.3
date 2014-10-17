Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753490AbaJQQNj (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Oct 2014 12:13:39 -0400
Received: from mx1.redhat.com ([209.132.183.28]:28950 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752490AbaJQQNi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Oct 2014 12:13:38 -0400
Date: Fri, 17 Oct 2014 18:10:21 +0200
From: Oleg Nesterov <oleg@redhat.com>
To: Michal Hocko <mhocko@suse.cz>
Cc: Cong Wang <xiyou.wangcong@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH -v2] freezer: check OOM kill while being frozen
Message-ID: <20141017161021.GC7227@redhat.com>
References: <20141016203954.GA26336@redhat.com> <CAM_iQpUyCR3Bv1QhFkVmii9vB=fjMAUiWZ4T+mj60=FUZOXS+A@mail.gmail.com> <20141016211136.GA27468@redhat.com> <CAM_iQpXM6eUnvofOq0c71Nx3HygzriKKpN6Vc1+fY=dzFR08ig@mail.gmail.com> <20141016213512.GA28099@redhat.com> <CAM_iQpUFBDscS2n41FdE3S016c_jkb4HaKomy14G7Ez9x4w3+g@mail.gmail.com> <20141016222237.GA30063@redhat.com> <CAM_iQpVZtOCzWA3wWuG5y7AyOBUx41-81jrt+dSeHvr6eHY4RA@mail.gmail.com> <20141017074654.GD8076@dhcp22.suse.cz>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141017074654.GD8076@dhcp22.suse.cz>
User-Agent: Mutt/1.5.18 (2008-05-17)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/17, Michal Hocko wrote:
>
> I think we should rather get back to __thaw_task here.

Yes, agreed.

> Andrew could you replace the previous version by this one, please?

Yes, that patch should be dropped...


And can't resist... please look at
http://marc.info/?l=linux-kernel&m=138427535430827 ;)

> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -45,13 +45,28 @@ bool freezing_slow_path(struct task_struct *p)
>  	if (pm_nosig_freezing || cgroup_freezing(p))
>  		return true;
>
> -	if (pm_freezing && !(p->flags & PF_KTHREAD))
> +	if (!(p->flags & PF_KTHREAD))

Why? Doesn't this mean that try_to_freeze() can race with thaw_processes()
and then this task can be frozen for no reazon?

> +static bool should_thaw_current(bool check_kthr_stop)
> +{
> +	if (!freezing(current))
> +		return true;
> +
> +	if (check_kthr_stop && kthread_should_stop())
> +		return true;
> +
> +	/* It might not be safe to check TIF_MEMDIE for pm freeze. */
> +	if (cgroup_freezing(current) && test_thread_flag(TIF_MEMDIE))

I still think that the comment should tell more to explain why this
is not safe.

And if this is not safe, it is not clear how/why cgroup_freezing() can
save us, both pm_freezing and CGROUP_FREEZING can be true?

And I think that this TIF_MEMDIE should go into freezing_slow_path(),
so we do not even need should_thaw_current().

This also looks more safe to me. Suppose that a task does

	while (try_to_freeze())
		;

Yes, this is pointless but correct. And in fact I think this pattern
is possible. If this task is killed by OOM, it will spin forever.

Oleg.

