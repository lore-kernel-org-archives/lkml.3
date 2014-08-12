Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751647AbaHLMJJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 08:09:09 -0400
Received: from cantor2.suse.de ([195.135.220.15]:34370 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751157AbaHLMJH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 08:09:07 -0400
Date: Tue, 12 Aug 2014 14:09:05 +0200
From: Michal Hocko <mhocko@suse.cz>
To: Cong Wang <xiyou.wangcong@gmail.com>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, David Rientjes <rientjes@google.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Tejun Heo <tj@kernel.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: Re: [Patch] x86,mm: check freeze request in page fault handler
Message-ID: <20140812120905.GB7049@dhcp22.suse.cz>
References: <1407804835-24763-1-git-send-email-xiyou.wangcong@gmail.com>
 <1407804835-24763-2-git-send-email-xiyou.wangcong@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1407804835-24763-2-git-send-email-xiyou.wangcong@gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon 11-08-14 17:53:55, Cong Wang wrote:
> When a process triggers a page fault and kernel keeps
> trying to retry the fault, there is no chance for this process
> to be frozen, so the freeze request will always be pending.

The retry cannot happen indefinitely, no?

Besides that the patch is broken in at least 2 ways. You are not
releasing mmap_sem and this will break memcg OOM killer handling.

If a memcg is under OOM (because of hard limit) then try_charge
calls mem_cgroup_oom which marks the current task with OOM
information. Notably takes a reference to memcg->css. The charge fail
will then gets up the pagefault stack until we get to mm_fault_error
where you put the task into freezer and then returns without
pagefault_out_of_memory which would handle memcg specific parts in
mem_cgroup_oom_synchronize. If the task wakes up and the page fault
retry succeeds (because some charges were released in the meantime) then
you leak a reference to memcg->css.

Besides that the whole change would need a better justification. Why
other archs do not need this?

> This patch lets the page fault handler check pending
> freeze request and freeze current process if so.
> 
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Ingo Molnar <mingo@redhat.com>
> Cc: David Rientjes <rientjes@google.com>
> Cc: Michal Hocko <mhocko@suse.cz>
> Cc: "Rafael J. Wysocki" <rjw@rjwysocki.net>
> Cc: Tejun Heo <tj@kernel.org>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
> ---
>  arch/x86/mm/fault.c | 4 ++++
>  1 file changed, 4 insertions(+)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index a241946..ad9728a 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -14,6 +14,7 @@
>  #include <linux/hugetlb.h>		/* hstate_index_to_shift	*/
>  #include <linux/prefetch.h>		/* prefetchw			*/
>  #include <linux/context_tracking.h>	/* exception_enter(), ...	*/
> +#include <linux/freezer.h>		/* try_to_freeze()		*/
>  
>  #include <asm/traps.h>			/* dotraplinkage, ...		*/
>  #include <asm/pgalloc.h>		/* pgd_*(), ...			*/
> @@ -885,6 +886,9 @@ mm_fault_error(struct pt_regs *regs, unsigned long error_code,
>  		up_read(&current->mm->mmap_sem);
>  		no_context(regs, error_code, address, 0, 0);
>  		return;
> +	} else if (signal_pending(current) && (error_code & PF_USER)) {
> +		if (try_to_freeze())
> +			return;
>  	}
>  
>  	if (fault & VM_FAULT_OOM) {
> -- 
> 1.8.3.1
> 

-- 
Michal Hocko
SUSE Labs
