Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755622Ab3HCB0V (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 21:26:21 -0400
Received: from out1-smtp.messagingengine.com ([66.111.4.25]:58475 "EHLO
	out1-smtp.messagingengine.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753739Ab3HCB0U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 21:26:20 -0400
X-Sasl-enc: /V3649IJPneZ5Dln4qyYDNsKroxrxDwVmvjnEaV+ge3q 1375493174
Date: Sat, 3 Aug 2013 09:18:12 +0800
From: Greg KH <greg@kroah.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: hpa@zytor.com, linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        pjt@google.com, jmario@redhat.com, riel@redhat.com, tglx@linutronix.de,
        dzickus@redhat.com, linux-tip-commits@vger.kernel.org
Subject: Re: [tip:sched/core] sched/x86: Optimize switch_mm() for
 multi-threaded workloads
Message-ID: <20130803011812.GA32230@kroah.com>
References: <20130731221421.616d3d20@annuminas.surriel.com>
 <tip-8f898fbbe5ee5e20a77c4074472a1fd088dc47d1@git.kernel.org>
 <20130802091247.GA26693@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130802091247.GA26693@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Aug 02, 2013 at 11:12:47AM +0200, Ingo Molnar wrote:
> * tip-bot for Rik van Riel <tipbot@zytor.com> wrote:
> 
> > Commit-ID:  8f898fbbe5ee5e20a77c4074472a1fd088dc47d1
> > Gitweb:     http://git.kernel.org/tip/8f898fbbe5ee5e20a77c4074472a1fd088dc47d1
> > Author:     Rik van Riel <riel@redhat.com>
> > AuthorDate: Wed, 31 Jul 2013 22:14:21 -0400
> > Committer:  Ingo Molnar <mingo@kernel.org>
> > CommitDate: Thu, 1 Aug 2013 09:10:26 +0200
> > 
> > sched/x86: Optimize switch_mm() for multi-threaded workloads
> > 
> > Dick Fowles, Don Zickus and Joe Mario have been working on
> > improvements to perf, and noticed heavy cache line contention
> > on the mm_cpumask, running linpack on a 60 core / 120 thread
> > system.
> > 
> > The cause turned out to be unnecessary atomic accesses to the
> > mm_cpumask. When in lazy TLB mode, the CPU is only removed from
> > the mm_cpumask if there is a TLB flush event.
> > 
> > Most of the time, no such TLB flush happens, and the kernel
> > skips the TLB reload. It can also skip the atomic memory
> > set & test.
> > 
> > Here is a summary of Joe's test results:
> > 
> >  * The __schedule function dropped from 24% of all program cycles down
> >    to 5.5%.
> > 
> >  * The cacheline contention/hotness for accesses to that bitmask went
> >    from being the 1st/2nd hottest - down to the 84th hottest (0.3% of
> >    all shared misses which is now quite cold)
> > 
> >  * The average load latency for the bit-test-n-set instruction in
> >    __schedule dropped from 10k-15k cycles down to an average of 600 cycles.
> > 
> >  * The linpack program results improved from 133 GFlops to 144 GFlops.
> >    Peak GFlops rose from 133 to 153.
> > 
> > Reported-by: Don Zickus <dzickus@redhat.com>
> > Reported-by: Joe Mario <jmario@redhat.com>
> > Tested-by: Joe Mario <jmario@redhat.com>
> > Signed-off-by: Rik van Riel <riel@redhat.com>
> > Reviewed-by: Paul Turner <pjt@google.com>
> > Acked-by: Linus Torvalds <torvalds@linux-foundation.org>
> > Link: http://lkml.kernel.org/r/20130731221421.616d3d20@annuminas.surriel.com
> > [ Made the comments consistent around the modified code. ]
> > Signed-off-by: Ingo Molnar <mingo@kernel.org>
> 
> > +	  else {
> >  		this_cpu_write(cpu_tlbstate.state, TLBSTATE_OK);
> >  		BUG_ON(this_cpu_read(cpu_tlbstate.active_mm) != next);
> >  
> > -		if (!cpumask_test_and_set_cpu(cpu, mm_cpumask(next))) {
> > +		if (!cpumask_test_cpu(cpu, mm_cpumask(next))) {
> > +			/*
> > +			 * On established mms, the mm_cpumask is only changed
> > +			 * from irq context, from ptep_clear_flush() while in
> > +			 * lazy tlb mode, and here. Irqs are blocked during
> > +			 * schedule, protecting us from simultaneous changes.
> > +			 */
> > +			cpumask_set_cpu(cpu, mm_cpumask(next));
> 
> Note, I marked this for v3.12 with no -stable backport tag as it's not a 
> regression fix.
> 
> Nevertheless if it's a real issue in production (and +20% of linpack 
> performance is certainly significant) feel free to forward it to -stable 
> once this hits Linus's tree in the v3.12 merge window - by that time the 
> patch will be reasonably well tested and it's a relatively simple change.

I'll watch for this as well and try to remember to pick it up for
-stable once it hits Linus's tree, as those type of benchmark
improvements are good to have in stable releases.

thanks,

greg k-h
