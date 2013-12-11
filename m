Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751901Ab3LKOmo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 11 Dec 2013 09:42:44 -0500
Received: from mail-ee0-f43.google.com ([74.125.83.43]:57429 "EHLO
	mail-ee0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750904Ab3LKOmm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 11 Dec 2013 09:42:42 -0500
Date: Wed, 11 Dec 2013 15:42:38 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Mike Galbraith <bitbucket@online.de>, Borislav Petkov <bp@alien8.de>,
        Thomas Gleixner <tglx@linutronix.de>, Len Brown <lenb@kernel.org>,
        Linux PM list <linux-pm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Jeremy Eder <jeder@redhat.com>, x86@kernel.org
Subject: Re: 50 Watt idle power regression bisected to Linux-3.10
Message-ID: <20131211144238.GA4510@gmail.com>
References: <1386559014.4875.16.camel@marge.simpson.net>
 <1386652637.5374.72.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312101458040.28330@ionos.tec.linutronix.de>
 <alpine.DEB.2.02.1312110030330.28330@ionos.tec.linutronix.de>
 <1386732093.5964.6.camel@marge.simpson.net>
 <alpine.DEB.2.02.1312111206200.28330@ionos.tec.linutronix.de>
 <20131211113839.GF21683@pd.tnic>
 <20131211115239.GA21999@twins.programming.kicks-ass.net>
 <1386764955.12005.60.camel@marge.simpson.net>
 <20131211124352.GB21999@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131211124352.GB21999@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Wed, Dec 11, 2013 at 01:29:15PM +0100, Mike Galbraith wrote:
> > On Wed, 2013-12-11 at 12:52 +0100, Peter Zijlstra wrote: 
> > > On Wed, Dec 11, 2013 at 12:38:39PM +0100, Borislav Petkov wrote:
> > > > Right, if it turns out that this is really the case and that this
> > > > erratum hasn't been fixed for models later than 29 - we'd need the
> > > > additional model numbers to set X86_FEATURE_CLFLUSH_MONITOR correctly.
> > > 
> > > You also need: https://lkml.org/lkml/2013/11/19/143
> > > 
> > > Because obviously not all mwait idle loops check that cpu bit.
> > 
> > I had tried that patch, to see if it would magically make the thing
> > start working, nope.  I had also tried...
> 
> > +		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
> > +			clflush((void *)&current_thread_info()->flags);
> 
> Yeah, you need a bit extra to enable that feature bit for your CPU as
> bpetkov said.
> 
> Something like the below.. someone needs to double check and possibly
> add SNB/IVB EX parts if they're already available.
> 
> diff --git a/arch/x86/kernel/cpu/intel.c b/arch/x86/kernel/cpu/intel.c
> index dc1ec0dff939..015642eed045 100644
> --- a/arch/x86/kernel/cpu/intel.c
> +++ b/arch/x86/kernel/cpu/intel.c
> @@ -387,8 +387,15 @@ static void init_intel(struct cpuinfo_x86 *c)
>  			set_cpu_cap(c, X86_FEATURE_PEBS);
>  	}
>  
> -	if (c->x86 == 6 && c->x86_model == 29 && cpu_has_clflush)
> -		set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
> +	if (c->x86 == 6 && cpu_has_clflush) {
> +		switch (c->x86_model) {
> +		case 29: /* Core2 EX */
> +		case 46: /* NHM EX */
> +		case 47: /* WSM EX */
> +			set_cpu_cap(c, X86_FEATURE_CLFLUSH_MONITOR);
> +			break;
> +		}
> +	}

Another thing that is required I think is to issue a write barrier 
before CLFLUSH instruction. By my (possibly incorrect ...) reading of 
the documentation CLFLUSH does not appear to be ordered (at all), so 
it might execute before the modification to the affected memory?


So something like:

		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
			smp_wmb(); /* order CLFLUSH */
			clflush(&current_thread_info()->flags);
		}

possibly put behind some utility function, smp_clflush() or so, hiding 
the CPU feature bit check as well:

		smp_clflush(&current_thread_info()->flags);

or so?

Thanks,

	Ingo
