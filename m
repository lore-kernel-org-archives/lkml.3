Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753485AbaHKNSc (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 09:18:32 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39945 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751126AbaHKNSb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 09:18:31 -0400
Date: Mon, 11 Aug 2014 15:18:28 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] freezer: check OOM kill signal while being frozen
Message-ID: <20140811131828.GF15312@dhcp22.suse.cz>
References: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407545198-9009-1-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri 08-08-14 17:46:38, Cong Wang wrote:
> There is a race condition between OOM killer and freezer when
> they try to operate on the same process, something like below:
> 
> 	Process A	Process B		Process C
> trigger oom
> B=oom_scan_process_thread()
> 					cgroup_freezer_freeze(B)
> 			...
> 			try_to_freeze()
> 			stay in D state
> oom_kill_process(B)
> 
> In this case, process A triggers OOM and kernel selects process B
> as the victim, right before being killed process B was frozen by
> process C therefore went to D state, then kernel sent SIGKILL but
> it is already too late as process B will never care about pending
> signals any more.

OK, so the system/memcg is still OOM and a new allocation/charge
would trigger killer again, right? Then oom_scan_process_thread sees
TIF_MEMDIE frozen task and thaw it so it can go away and die. So this
shouldn't be a permanent state. Or am I missing something?

> Fix this straightly by checking fatal pending signal
> from OOM killer, so that the frozen process will recover itself
> and then be killed finally.
> 
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
> diff --git a/kernel/freezer.c b/kernel/freezer.c
> index aa6a8aa..c6d189d 100644
> --- a/kernel/freezer.c
> +++ b/kernel/freezer.c
> @@ -68,7 +68,9 @@ bool __refrigerator(bool check_kthr_stop)
>  		spin_lock_irq(&freezer_lock);
>  		current->flags |= PF_FROZEN;
>  		if (!freezing(current) ||
> -		    (check_kthr_stop && kthread_should_stop()))
> +		    (check_kthr_stop && kthread_should_stop()) ||
> +		    (test_tsk_thread_flag(current, TIF_MEMDIE) &&
> +			 fatal_signal_pending(current)))
>  			current->flags &= ~PF_FROZEN;
>  		spin_unlock_irq(&freezer_lock);
>  

-- 
Michal Hocko
SUSE Labs
