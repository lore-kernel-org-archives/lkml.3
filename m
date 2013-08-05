Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755610Ab3HEWZy (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 Aug 2013 18:25:54 -0400
Received: from zene.cmpxchg.org ([85.214.230.12]:51973 "EHLO zene.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755088Ab3HEWZw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 Aug 2013 18:25:52 -0400
Date: Mon, 5 Aug 2013 18:25:39 -0400
From: Johannes Weiner <hannes@cmpxchg.org>
To: Andrew Morton <akpm@linux-foundation.org>
Cc: Michal Hocko <mhocko@suse.cz>, David Rientjes <rientjes@google.com>,
        KAMEZAWA Hiroyuki <kamezawa.hiroyu@jp.fujitsu.com>,
        azurIt <azurit@pobox.sk>,
        KOSAKI Motohiro <kosaki.motohiro@jp.fujitsu.com>, linux-mm@kvack.org,
        cgroups@vger.kernel.org, x86@kernel.org, linux-arch@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [patch 3/7] arch: mm: pass userspace fault flag to generic fault
 handler
Message-ID: <20130805222539.GD715@cmpxchg.org>
References: <1375549200-19110-1-git-send-email-hannes@cmpxchg.org>
 <1375549200-19110-4-git-send-email-hannes@cmpxchg.org>
 <20130805150618.47d699f5ce9f42242ee2e7c3@linux-foundation.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130805150618.47d699f5ce9f42242ee2e7c3@linux-foundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Aug 05, 2013 at 03:06:18PM -0700, Andrew Morton wrote:
> On Sat,  3 Aug 2013 12:59:56 -0400 Johannes Weiner <hannes@cmpxchg.org> wrote:
> 
> > Unlike global OOM handling, memory cgroup code will invoke the OOM
> > killer in any OOM situation because it has no way of telling faults
> > occuring in kernel context - which could be handled more gracefully -
> > from user-triggered faults.
> > 
> > Pass a flag that identifies faults originating in user space from the
> > architecture-specific fault handlers to generic code so that memcg OOM
> > handling can be improved.
> 
> arch/arm64/mm/fault.c has changed.  Here's what I came up with:
> 
> --- a/arch/arm64/mm/fault.c~arch-mm-pass-userspace-fault-flag-to-generic-fault-handler
> +++ a/arch/arm64/mm/fault.c
> @@ -199,13 +199,6 @@ static int __kprobes do_page_fault(unsig
>  	unsigned long vm_flags = VM_READ | VM_WRITE | VM_EXEC;
>  	unsigned int mm_flags = FAULT_FLAG_ALLOW_RETRY | FAULT_FLAG_KILLABLE;
>  
> -	if (esr & ESR_LNX_EXEC) {
> -		vm_flags = VM_EXEC;
> -	} else if ((esr & ESR_WRITE) && !(esr & ESR_CM)) {
> -		vm_flags = VM_WRITE;
> -		mm_flags |= FAULT_FLAG_WRITE;
> -	}
> -
>  	tsk = current;
>  	mm  = tsk->mm;
>  
> @@ -220,6 +213,16 @@ static int __kprobes do_page_fault(unsig
>  	if (in_atomic() || !mm)
>  		goto no_context;
>  
> +	if (user_mode(regs))
> +		mm_flags |= FAULT_FLAG_USER;
> +
> +	if (esr & ESR_LNX_EXEC) {
> +		vm_flags = VM_EXEC;
> +	} else if ((esr & ESR_WRITE) && !(esr & ESR_CM)) {
> +		vm_flags = VM_WRITE;
> +		mm_flags |= FAULT_FLAG_WRITE;
> +	}
> +
>  	/*
>  	 * As per x86, we may deadlock here. However, since the kernel only
>  	 * validly references user space from well defined areas of the code,
> 
> But I'm not terribly confident in it.

It looks good to me.  They added the vm_flags but they are not used
any earlier than the mm_flags (__do_page_fault), which I moved to the
same location as you did in this fixup.

Thanks!
