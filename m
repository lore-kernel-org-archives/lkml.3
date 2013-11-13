Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757633Ab3KMQ3y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Nov 2013 11:29:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:34087 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755706Ab3KMQ3u (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Nov 2013 11:29:50 -0500
Date: Wed, 13 Nov 2013 17:29:19 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Dietmar Eggemann <dietmar.eggemann@arm.com>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Vincent Guittot <vincent.guittot@linaro.org>,
        linux-kernel <linux-kernel@vger.kernel.org>,
        Ingo Molnar <mingo@kernel.org>, Paul Turner <pjt@google.com>,
        Morten Rasmussen <Morten.Rasmussen@arm.com>,
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
Message-ID: <20131113162919.GM26898@twins.programming.kicks-ass.net>
References: <1382097147-30088-1-git-send-email-vincent.guittot@linaro.org>
 <1382097147-30088-2-git-send-email-vincent.guittot@linaro.org>
 <20131105140626.GP31370@twins.programming.kicks-ass.net>
 <CAKfTPtCYHKRv=w3b4tZV-2BW_a_T+tkO9Qpc0PhLD=uZY1yvfw@mail.gmail.com>
 <20131105222752.GD16117@laptop.programming.kicks-ass.net>
 <20131106145344.448d7733@mschwide>
 <20131106140807.GM10651@twins.programming.kicks-ass.net>
 <528268C8.8010501@arm.com>
 <20131112180844.GF21461@twins.programming.kicks-ass.net>
 <52839F04.60702@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <52839F04.60702@arm.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 13, 2013 at 03:47:16PM +0000, Dietmar Eggemann wrote:
> On 12/11/13 18:08, Peter Zijlstra wrote:
> > On Tue, Nov 12, 2013 at 05:43:36PM +0000, Dietmar Eggemann wrote:
> >> This patch removes the sched_domain initializer macros
> >> SD_[SIBLING|MC|BOOK|CPU]_INIT in core.c and in archs and replaces them
> >> with calls to the new function sd_init().  The function sd_init
> >> incorporates the already existing function sd_numa_init().
> > 
> > Your patch retains far too much of the weird behavioural variations we
> > have, nor does it create a proper separation between topology and
> > behaviour.
> 
> Could you please explain a little bit further on the weird behavioural
> variations. Are you referring to the specific SD_ flags or sd_domain levels?

+++ b/arch/ia64/kernel/topology.c
@@ -99,6 +99,14 @@ out:

 subsys_initcall(topology_init);

+void arch_sd_customize(int level, struct sched_domain *sd, int cpu)
+{
+       if (level == SD_LVL_CPU) {
+               sd->cache_nice_tries = 2;
+
+               sd->flags &= ~SD_PREFER_SIBLING;
+       }
+}

+++ b/arch/tile/kernel/smp.c
@@ -254,3 +254,15 @@ void smp_send_reschedule(int cpu)
 }

 #endif /* CHIP_HAS_IPI() */
+
+void arch_sd_customize(int level, struct sched_domain *sd, int cpu)
+{
+       if (level == SD_LVL_CPU) {
+               sd->min_interval = 4;
+               sd->max_interval = 128;
+
+               sd->flags &= ~(SD_WAKE_AFFINE | SD_PREFER_SIBLING);
+
+               sd->balance_interval = 32;
+       }
+}

Many of these differences are just bitrot / accidents, and the different
min interval for tile was already taken care of by basing the intervals
off of the domain weight.

On that, you should also not rely on these SD_LVL things; if we wanted
to inject an extra level they'd go all funny.

> I agree that this patch doesn't separate behaviour and topology and I
> will consider this going forward.

Please take the patch I did and work from there.

> > We might indeed have to have a single arch_() function that adds
> > SD_flags, but please restrict the flags it can set -- never allow it to
> > set behavioural flags.
> 
> Understood. Simply exporting an sd_domain pointer is a no-go.

I was more thinking along the lines of:

unsigned long arch_sd_flags(unsigned long sd_flags)
{
	return 0
}

Used like:

	extra_sd_flags = arch_sd_flags(sd->sd_flags);
	if (extra_sd_flags & FOO) {
		WARN("silly bugger: %x\n", extra_sd_flags);
		extra_sd_flags &= ~FOO;
	}
	sd->sd_flags |= extra_sd_flags;

Or something.

> > 
> > Furthermore, I think we want to allow the arch to override the base
> > topology; we've had desire to add per arch level in the past.. eg. add
> > an L2 level for some x86 variants.
> 
> I quite don't understand this one. Are you saying that one idea for the
> topology side of things is to have an extra arch specific sd level which
> would be the only sd_domain level which could be then overridden by the
> arch?

No allow an arch to fully override default_topology[] like I did in that
s390 case.

The case where the x86 cpu_core_map != cpu_llc_shared_map can currently
not be represented. Luckily no recent chips have had this, but there was
a time when this was a popular configuration (Intel Core2Quad).

There's been other 'fun' cases, like AMD putting two nodes in 1 package.
That's not something we can represent (not sure we need to but still).

And there's the AMD bulldozer shared core thing, which we currently
model the same as SMT but which could do with some tweaks - they're
distinct in that they share an 'large' L2.

Then there's the Xeon-7400 which is 'similar' to the AMD in that cores
share L2.

Anyway, all I'm saying is that even within one architecture there's
sufficient variation to allow for runtime topology creation. I'm sure
ARM has plenty weird configurations too.

And I'm not sure we need to represent all the weird variations, but in
the past we've had moments where we wanted to but could not (sanely) do
things.
