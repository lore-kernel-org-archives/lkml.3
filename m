Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754975Ab3LTIrP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 03:47:15 -0500
Received: from mail-ea0-f177.google.com ([209.85.215.177]:54087 "EHLO
	mail-ea0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754600Ab3LTIrO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 03:47:14 -0500
Date: Fri, 20 Dec 2013 09:47:10 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        tglx@linutronix.de, hpa@linux.intel.com, len.brown@intel.com,
        linux-tip-commits@vger.kernel.org
Subject: Re: [tip:x86/idle] x86, idle: Use static_cpu_has() for CLFLUSH
 workaround, add barriers
Message-ID: <20131220084710.GA21133@gmail.com>
References: <CA+55aFzGxcML7j8CEvQPYzh0W81uVoAAVmGctMOUZ7CZ1yYd2A@mail.gmail.com>
 <tip-7e98b71920464b8d15fa95c74366416cd3c88861@git.kernel.org>
 <20131219204051.GA2253@gmail.com>
 <20131219215541.GS16438@laptop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131219215541.GS16438@laptop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Thu, Dec 19, 2013 at 09:40:51PM +0100, Ingo Molnar wrote:
> > > +		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> > > +			mb();
> > >  			clflush((void *)&current_thread_info()->flags);
> > > +			mb();
> > > +		}
> 
> >  	if (!current_set_polling_and_test()) {
> >  		if (static_cpu_has(X86_FEATURE_CLFLUSH_MONITOR)) {
> > -			mb();
> > +			/*
> > +			 * There's no need for an extra barrier here: current_set_polling_and_test()
> > +			 * already has an smp_mb() after ->flags gets modified, see sched.h.
> > +			 */
> >  			clflush((void *)&current_thread_info()->flags);
> >  			mb();
> >  		}
> 
> So almost, except that smp_mb() will disappear on an UP kernel whereas
> this errata might just always need the MFENCE.

Yeah. Sigh, so I noticed that and even thought through the UP case and 
concluded: on UP the race cannot happen - which is bogus. Yesterday 
was so much fail, maybe today's a better day ;-)

Thanks,

	ngo
