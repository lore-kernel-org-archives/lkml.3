Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753310Ab3KNKvJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Nov 2013 05:51:09 -0500
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:53146 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752514Ab3KNKvH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Nov 2013 05:51:07 -0500
Date: Thu, 14 Nov 2013 10:49:02 +0000
From: Morten Rasmussen <morten.rasmussen@arm.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Dietmar Eggemann <Dietmar.Eggemann@arm.com>,
        Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        "cmetcalf@tilera.com" <cmetcalf@tilera.com>,
        "tony.luck@intel.com" <tony.luck@intel.com>,
        Alex Shi <alex.shi@intel.com>,
        Preeti U Murthy <preeti@linux.vnet.ibm.com>,
        "linaro-kernel@lists.linaro.org" <linaro-kernel@lists.linaro.org>,
        "Rafael J. Wysocki" <rjw@sisk.pl>,
        Paul McKenney <paulmck@linux.vnet.ibm.com>,
        Jonathan Corbet <corbet@lwn.net>, Thomas Gleixner <tglx@linutronix.de>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Amit Kucheria <amit.kucheria@linaro.org>,
        Lukasz Majewski <l.majewski@samsung.com>,
        "james.hogan@imgtec.com" <james.hogan@imgtec.com>,
        "heiko.carstens@de.ibm.com" <heiko.carstens@de.ibm.com>
Subject: Re: [RFC][PATCH v5 01/14] sched: add a new arch_sd_local_flags for
 sched_domain init
Message-ID: <20131114104902.GB5762@e103034-lin>
References: <1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
 <20131105140626.GP31370@twins.programming.kicks-ass.net>
 <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
 <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <20131106145344.448d7733@mschwide>
 <20131106140807.GM10651@twins.programming.kicks-ass.net>
 <528268C8.8010501@arm.com>
 <20131112180844.GF21461@twins.programming.kicks-ass.net>
 <52839F04.60702@arm.com>
 <20131113162919.GM26898@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20131113162919.GM26898@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 04:29:19PM +0000, Peter Zijlstra wrote:
> On Wed, Nov 13, 2013 at 03:47:16PM +0000, Dietmar Eggemann wrote:
> > On 12/11/13 18:08, Peter Zijlstra wrote:
> > > On Tue, Nov 12, 2013 at 05:43:36PM +0000, Dietmar Eggemann wrote:
> > >> This patch removes the sched_domain initializer macros
> > >> SD_[SIBLING|MC|BOOK|CPU]_INIT in core.c and in archs and replaces them
> > >> with calls to the new function sd_init().  The function sd_init
> > >> incorporates the already existing function sd_numa_init().
> > > 
> > > Your patch retains far too much of the weird behavioural variations we
> > > have, nor does it create a proper separation between topology and
> > > behaviour.
> > 
> > Could you please explain a little bit further on the weird behavioural
> > variations. Are you referring to the specific SD_ flags or sd_domain levels?
> 
> +++ b/arch/ia64/kernel/topology.c
> @@ -99,6 +99,14 @@ out:
> 
>  subsys_initcall(topology_init);
> 
> +void arch_sd_customize(int level, struct sched_domain *sd, int cpu)
> +{
> +       if (level == SD_LVL_CPU) {
> +               sd->cache_nice_tries = 2;
> +
> +               sd->flags &= ~SD_PREFER_SIBLING;
> +       }
> +}
> 
> +++ b/arch/tile/kernel/smp.c
> @@ -254,3 +254,15 @@ void smp_send_reschedule(int cpu)
>  }
> 
>  #endif /* CHIP_HAS_IPI() */
> +
> +void arch_sd_customize(int level, struct sched_domain *sd, int cpu)
> +{
> +       if (level == SD_LVL_CPU) {
> +               sd->min_interval = 4;
> +               sd->max_interval = 128;
> +
> +               sd->flags &= ~(SD_WAKE_AFFINE | SD_PREFER_SIBLING);
> +
> +               sd->balance_interval = 32;
> +       }
> +}
> 
> Many of these differences are just bitrot / accidents, and the different
> min interval for tile was already taken care of by basing the intervals
> off of the domain weight.
> 
> On that, you should also not rely on these SD_LVL things; if we wanted
> to inject an extra level they'd go all funny.
> 
> > I agree that this patch doesn't separate behaviour and topology and I
> > will consider this going forward.
> 
> Please take the patch I did and work from there.
> 
> > > We might indeed have to have a single arch_() function that adds
> > > SD_flags, but please restrict the flags it can set -- never allow it to
> > > set behavioural flags.
> > 
> > Understood. Simply exporting an sd_domain pointer is a no-go.
> 
> I was more thinking along the lines of:
> 
> unsigned long arch_sd_flags(unsigned long sd_flags)
> {
> 	return 0
> }
> 
> Used like:
> 
> 	extra_sd_flags = arch_sd_flags(sd->sd_flags);
> 	if (extra_sd_flags & FOO) {
> 		WARN("silly bugger: %x\n", extra_sd_flags);
> 		extra_sd_flags &= ~FOO;
> 	}
> 	sd->sd_flags |= extra_sd_flags;
> 
> Or something.

We need a way to know which group of cpus the flag applies to. If we
don't want to pass a pointer to the sched_domain and we want to replace
the current named sched_domain levels with something more flexible, the
only solution I can think of right now is to pass a cpumask to the arch
code. Better suggestions?

If we let arch generate the topology it could set the flags as well. But
that means that an arch would have to deal with generating the topology
even if it just needs to flip a single flag in the default topology.

Another thing is if we want to put energy related information into the
sched_domain hierarchy. If we want various energy costs (P and C state)
to be represented here we would need to modify more than just flags.

One way to do that is to put the energy information into a sub-struct and
have another arch_sd_energy() call that allows the arch to populate that
struct with relevant information.

Morten
