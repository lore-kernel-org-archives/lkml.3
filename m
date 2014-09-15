Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaIOLWV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 07:22:21 -0400
Received: from cantor2.suse.de ([195.135.220.15]:35373 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753396AbaIOLWU (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 07:22:20 -0400
Date: Mon, 15 Sep 2014 13:22:18 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch v4 1/2] freezer: check OOM kill while being frozen
Message-ID: <20140915112218.GB19976@dhcp22.suse.cz>
References: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1409869842-10807-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu 04-09-14 15:30:41, Cong Wang wrote:
> There is a race condition between OOM killer and freezer when
> they try to operate on the same process, something like below:
> 
>         Process A       Process B               Process C
> trigger page fault
> then trigger oom
> B=oom_scan_process_thread()
>                                         cgroup freezer freeze(A, B)
>                         ...
>                         try_to_freeze()
>                         stay in D state
> oom_kill_process(B)
> restart page fault
> ...
> 
> In this case, process A triggered a page fault in user-space,
> and the kernel page fault handler triggered OOM, then kernel
> selected process B as the victim, right before being killed
> process B was frozen by process C therefore went to D state,
> then kernel sent SIGKILL but it is already too late as
> process B will not care about pending signals any more.

I have just got back to this patch again and I guess that the
description is a bit misleading. Sure there is a race but the main
problem is that frozen tasks are OOM unkillable in principle. So a task
might hide into the fridge and livelock OOM killer. This has been broken
since __thaw_task doesn't thaw anything (I guess it was a3201227f803
which broke it).

What do you think about the following changelog instead?
"
Since f660daac474c6f (oom: thaw threads if oom killed thread is frozen
before deferring) OOM killer relies on being able to thaw a frozen task
to handle OOM situation but a3201227f803 (freezer: make freezing() test
freeze conditions in effect instead of TIF_FREEZE) has reorganized the
code and stopped clearing freeze flag in __thaw_task. This means that
the target task only wakes up and goes into the fridge again because the
freezing condition hasn't changed for it. This reintroduces the bug
fixed by f660daac474c6f.

Fix the issue by checking for TIF_MEMDIE thread flag and get away from
the fridge if it is set. oom_scan_process_thread doesn't have to check
for the frozen task anymore because do_send_sig_info will wake up the
thread and TIF_MEMDIE is already set by that time.

Fixes: a3201227f803 (freezer: make freezing() test freeze conditions in effect instead of TIF_FREEZE)
Cc: stable@vger.kernel.org # 3.3+
"

[...]
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
> +		return true;

+ cgroup_freezing check can go away.

-- 
Michal Hocko
SUSE Labs
