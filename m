Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934146Ab3JPLko (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 07:40:44 -0400
Received: from mail-wg0-f54.google.com ([74.125.82.54]:55370 "EHLO
	mail-wg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932406Ab3JPLkn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 07:40:43 -0400
Date: Wed, 16 Oct 2013 13:40:37 +0200
From: Frederic Weisbecker <fweisbec@gmail.com>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "paulmck@linux.vnet.ibm.com" <paulmck@linux.vnet.ibm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        "x86@kernel.org" <x86@kernel.org>,
        "Wang, Xiaoming" <xiaoming.wang@intel.com>,
        "Li, Zhuangzhi" <zhuangzhi.li@intel.com>,
        "Liu, Chuansheng" <chuansheng.liu@intel.com>
Subject: Re: [PATCH] x86: Remove WARN_ON(in_nmi()) from vmalloc_fault
Message-ID: <20131016114036.GB12773@localhost.localdomain>
References: <20131015163906.342d8ffa@gandalf.local.home>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131015163906.342d8ffa@gandalf.local.home>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 15, 2013 at 04:39:06PM -0400, Steven Rostedt wrote:
> Since the NMI iretq nesting has been fixed, there's no reason that
> an NMI handler can not take a page fault for vmalloc'd code. No locks
> are taken in that code path, and the software now handles nested NMIs
> when the fault re-enables NMIs on iretq.
> 
> Not only that, if the vmalloc_fault() WARN_ON_ONCE() is hit, and that
> warn on triggers a vmalloc fault for some reason, then we can go into
> an infinite loop (the WARN_ON_ONCE() does the WARN() before updating
> the variable to make it happen "once").
> 
> Reported-by: "Liu, Chuansheng" <chuansheng.liu@intel.com>
> Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

Thanks! For now we probably indeed want this patch. But I hope it's only
for the short term.

I still think that allowing faults in NMIs is very nasty, as we expect NMIs to never
be disturbed. I'm not even sure if that interacts correctly with the rcu_nmi_enter()
and preempt_count & NMI_MASK things. Not sure how perf is ready for that either (now
hardware events can be interrupted by fault trace events).

So I hope we can think about something else for the long term.

> ---
>  arch/x86/mm/fault.c | 2 --
>  1 file changed, 2 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 3aaeffc..78926c6 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -268,8 +268,6 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
>  	if (!(address >= VMALLOC_START && address < VMALLOC_END))
>  		return -1;
>  
> -	WARN_ON_ONCE(in_nmi());
> -
>  	/*
>  	 * Synchronize this task's top level page-table
>  	 * with the 'reference' page table.
> -- 
> 1.8.1.4
> 
