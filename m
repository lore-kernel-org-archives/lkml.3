Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935669AbaDJTkz (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 15:40:55 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:17273 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S934889AbaDJTky (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Apr 2014 15:40:54 -0400
Date: Thu, 10 Apr 2014 15:40:51 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>, linux-kernel@vger.kernel.org
Subject: Re: x86: Allow vmalloc faults from NMI context
Message-ID: <20140410154051.4d709272@gandalf.local.home>
In-Reply-To: <20140410144003.GF13658@twins.programming.kicks-ass.net>
References: <20140410144003.GF13658@twins.programming.kicks-ass.net>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, 10 Apr 2014 16:40:03 +0200
Peter Zijlstra <peterz@infradead.org> wrote:

> Jiri reported he hit vmalloc_faults()'s:
> 
>   WARN_ON_ONCE(in_nmi());
> 
> The patch that added this ebc8827f75954 ("x86: Barf when vmalloc and
> kmemcheck faults happen in NMI") explains that this was done in order to
> avoid faults from NMI to cause nested NMIs.
> 
> We have, however, completely fixed this issue and can now safely take
> faults from NMI context.
> 
> Therefore remove this warning. We must still leave the kmemcheck warn in
> place since kmemcheck itself can't deal with NMI context yet.
> 

Yay, finally....

Link: http://lkml.kernel.org/p/20131015163906.342d8ffa@gandalf.local.home

-- Steve

> Signed-off-by: Peter Zijlstra <peterz@infradead.org>
> ---
>  arch/x86/mm/fault.c | 4 ----
>  1 file changed, 4 deletions(-)
> 
> diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
> index 8e5722992677..d0234cdf70f1 100644
> --- a/arch/x86/mm/fault.c
> +++ b/arch/x86/mm/fault.c
> @@ -271,8 +271,6 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
>  	if (!(address >= VMALLOC_START && address < VMALLOC_END))
>  		return -1;
>  
> -	WARN_ON_ONCE(in_nmi());
> -
>  	/*
>  	 * Synchronize this task's top level page-table
>  	 * with the 'reference' page table.
> @@ -369,8 +367,6 @@ static noinline __kprobes int vmalloc_fault(unsigned long address)
>  	if (!(address >= VMALLOC_START && address < VMALLOC_END))
>  		return -1;
>  
> -	WARN_ON_ONCE(in_nmi());
> -
>  	/*
>  	 * Copy kernel mappings over when needed. This can also
>  	 * happen within a race in page table update. In the later

