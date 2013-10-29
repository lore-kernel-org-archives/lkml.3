Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756852Ab3J2N0w (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 09:26:52 -0400
Received: from merlin.infradead.org ([205.233.59.134]:48918 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756783Ab3J2N0t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 09:26:49 -0400
Date: Tue, 29 Oct 2013 14:26:29 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        Ingo Molnar <mingo@kernel.org>,
        Vaidyanathan Srinivasan <svaidy@linux.vnet.ibm.com>,
        Mike Galbraith <bitbucket@online.de>, Paul Turner <pjt@google.com>,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Anton Blanchard <anton@samba.org>, linuxppc-dev@lists.ozlabs.org
Subject: Re: [PATCH 1/3] sched: Fix nohz_kick_needed to consider the nr_busy
 of the parent domain's group
Message-ID: <20131029132629.GC16117@laptop.programming.kicks-ass.net>
References: <20131021114002.13291.31478.stgit@drishya>
 <20131021114442.13291.99344.stgit@drishya>
 <20131022221138.GJ2490@laptop.programming.kicks-ass.net>
 <52679BD6.6090507@linux.vnet.ibm.com>
 <CAKfTPtAUFdmc7PasebNksYztMwRrWsGWPgN6JJJurddu+UP-hQ@mail.gmail.com>
 <5268D54A.9060604@linux.vnet.ibm.com>
 <20131028135043.GP19466@laptop.lan>
 <526F2BEC.3040207@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <526F2BEC.3040207@linux.vnet.ibm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Oct 29, 2013 at 09:00:52AM +0530, Preeti U Murthy wrote:
> > Oh nice, that gets rid of the multiple atomics, and it nicely splits
> > this nohz logic into per topology groups -- now if only we could split
> > the rest too :-)
> 
> I am sorry, I don't get you here. By the 'rest', do you refer to
> nohz_kick_needed() as below? Or am I missing something?

Nah, the rest of the NOHZ infrastructure. Currently its global state;
there were some patches a few years ago that attempted to make that
per-node state, but that work stalled due to people switching jobs.


> >> +	sd = highest_flag_domain(cpu, SD_ASYM_PACKING);
> >> +
> >> +	if (sd && (cpumask_first_and(nohz.idle_cpus_mask,
> >> +				  sched_domain_span(sd)) < cpu))
> >> +		goto need_kick_unlock;
> >> +
> >>  	rcu_read_unlock();
> >>  	return 0;
> > 
> > This again is a bit sad; most archs will not have SD_ASYM_PACKING set at
> > all; this means that they all will do a complete (and pointless) sched
> > domain tree walk here.
> 
> There will not be a 'complete' sched domain tree walk right? The
> iteration will break at the first level of the sched domain for those
> archs which do not have SD_ASYM_PACKING set at all.

Ah indeed; I think I got confused due to me modifying
highest_flag_domain() earlier to assume a flag is carried from the
lowest domain upwards.

> But it is true that doing a sched domain tree walk regularly is a bad
> idea, might as well update the domain with SD_ASYM_PACKING flag set once
> and query this domain when required.
> 
> I will send out the patch with sd_asym domain introduced rather than the
> above.

Thanks
