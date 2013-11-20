Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752553Ab3KTK2U (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 05:28:20 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34938 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751312Ab3KTK2R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 05:28:17 -0500
Date: Wed, 20 Nov 2013 11:28:03 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Jacob Pan <jacob.jun.pan@linux.intel.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>, lenb@kernel.org,
        rjw@rjwysocki.net, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, shaohua.li@intel.com,
        rui.zhang@intel.com, Mike Galbraith <bitbucket@online.de>,
        Ingo Molnar <mingo@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        hpa@zytor.com
Subject: Re: [PATCH] x86, acpi, idle: Restructure the mwait idle routines
Message-ID: <20131120102803.GO10022@twins.programming.kicks-ass.net>
References: <20131119090019.GJ3866@twins.programming.kicks-ass.net>
 <20131119090859.GC3694@twins.programming.kicks-ass.net>
 <20131119113153.GD3694@twins.programming.kicks-ass.net>
 <528B7433.7020507@linux.intel.com>
 <20131119145143.GK10022@twins.programming.kicks-ass.net>
 <20131119151338.GF3694@twins.programming.kicks-ass.net>
 <20131119130630.487da962@ultegra>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131119130630.487da962@ultegra>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 19, 2013 at 01:06:30PM -0800, Jacob Pan wrote:
> On Tue, 19 Nov 2013 16:13:38 +0100
> Peter Zijlstra <peterz@infradead.org> wrote:
> 
> > On Tue, Nov 19, 2013 at 03:51:43PM +0100, Peter Zijlstra wrote:
> > > That said, that drive is completely wrecked. It uses
> > > preempt_enable_no_resched() wrong too, it has uncommented barriers..
> > > 
> > > Dude, wtf are you guys smoking?
> > 
> I applied this patch on top of upstream kernel (801a760) and found out
> my machine completely failed to enter idle when nothing is running.
> turbostate shows 100% C0. ftrace shows kernel coming in and out of idle
> frequently.
> 
> Both ACPI idle and intel_idle behaves the same way. I have to do the
> following change to allow entering C-states again.
> 
> diff --git a/arch/x86/include/asm/mwait.h b/arch/x86/include/asm/mwait.h
> index 80014da..b51d1e1 100644
> --- a/arch/x86/include/asm/mwait.h
> +++ b/arch/x86/include/asm/mwait.h
> @@ -49,10 +49,8 @@ static inline void mwait_idle_with_hints(unsigned
> long eax, unsigned long ecx) clflush((void
> *)&current_thread_info()->flags); 
>         __monitor((void *)&current_thread_info()->flags, 0, 0);
> -       if (!current_set_polling_and_test())
> +        if (!need_resched())
>                 __mwait(eax, ecx);
> -
> -       __current_clr_polling();
>  }
>  
>  #endif /* _ASM_X86_MWAIT_H */

That doesn't make any sense; current_set_polling_and_test() returns the
same thing need_resched() does.

But you're right, intel_idle resides 100% in C0 and acpi_idle has 100%
C1 residency... most weird.

/me goes prod at it
