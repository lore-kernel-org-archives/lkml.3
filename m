Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754314AbaGTHTu (ORCPT <rfc822;w@1wt.eu>);
	Sun, 20 Jul 2014 03:19:50 -0400
Received: from mail-wi0-f171.google.com ([209.85.212.171]:42994 "EHLO
	mail-wi0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752481AbaGTHTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 20 Jul 2014 03:19:49 -0400
Message-ID: <1405840786.6512.55.camel@marge.simpson.net>
Subject: Re: 143e1e28 sched: Rework sched_domain topology definition
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Vincent Guittot <vincent.guittot@linaro.org>,
        LKML <linux-kernel@vger.kernel.org>
Date: Sun, 20 Jul 2014 09:19:46 +0200
In-Reply-To: <1405839950.6512.49.camel@marge.simpson.net>
References: <1405838616.6512.42.camel@marge.simpson.net>
	 <20140720065207.GU9918@twins.programming.kicks-ass.net>
	 <1405839950.6512.49.camel@marge.simpson.net>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 2014-07-20 at 09:05 +0200, Mike Galbraith wrote: 
> On Sun, 2014-07-20 at 08:52 +0200, Peter Zijlstra wrote: 
> > On Sun, Jul 20, 2014 at 08:43:36AM +0200, Mike Galbraith wrote:
> > > Hi,
> > > 
> > > +/*
> > > + * Topology list, bottom-up.
> > > + */
> > > +static struct sched_domain_topology_level default_topology[] = {
> > > +#ifdef CONFIG_SCHED_SMT
> > > +	{ cpu_smt_mask, cpu_smt_flags, SD_INIT_NAME(SMT) },
> > > +#endif
> > > +#ifdef CONFIG_SCHED_MC
> > > +	{ cpu_coregroup_mask, cpu_core_flags, SD_INIT_NAME(MC) },
> > > +#endif
> > > +#ifdef CONFIG_SCHED_BOOK
> > > +	{ cpu_book_mask, SD_INIT_NAME(BOOK) },
> > > +#endif
> > > +	{ cpu_cpu_mask, SD_INIT_NAME(DIE) },
> > > +	{ NULL, },
> > > +};
> > > 
> > > Why did this commit rename the CPU domain to DIE?
> > 
> > Because they're both wrong, but we found that DIE was less wrong than
> > CPU.
> 
> Ok, doesn't matter anyway, just looks peculiar.
> 
> > Seeing how CPU typically means 1 logical, well, CPU, in the scheduler,
> > and not the package you stick on your board.
> > 
> > We chose DIE over PACKAGE due to 1) its shorter name and 2) things like
> > interlagos which have multiple DIEs in one PACKAGE etc..
> 
> It's actually a good name for some NUMA topologies.  You don't ever want
> to see a CPU domain, that sucks cycles, so calling it DIE is fine :)

Like this 8 socket box.  CPU domain with weight 64 stings.

vogelweide:~/:[0]# tune-sched-domains
usage: tune-sched-domains <val>
{cpu0/domain0:MC} SD flag: 559
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
-  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
-  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
- 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
+ 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
-1024: SD_SERIALIZE:             Only a single load balancing instance
-2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
-4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
-8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice
{cpu0/domain1:CPU} SD flag: 4143
+   1: SD_LOAD_BALANCE:          Do load balancing on this domain
+   2: SD_BALANCE_NEWIDLE:       Balance when about to become idle
+   4: SD_BALANCE_EXEC:          Balance on exec
+   8: SD_BALANCE_FORK:          Balance on fork, clone
-  16: SD_BALANCE_WAKE:          Wake to idle CPU on task wakeup
+  32: SD_WAKE_AFFINE:           Wake task to waking CPU
-  64: SD_PREFER_LOCAL:          Prefer to keep tasks local to this domain
- 128: SD_SHARE_CPUPOWER:        Domain members share cpu power
- 256: SD_POWERSAVINGS_BALANCE:  Balance for power savings
- 512: SD_SHARE_PKG_RESOURCES:   Domain members share cpu pkg resources
-1024: SD_SERIALIZE:             Only a single load balancing instance
-2048: SD_ASYM_PACKING:          Place busy groups earlier in the domain
+4096: SD_PREFER_SIBLING:        Prefer to place tasks in a sibling domain
-8192: SD_PREFER_UTILIZATION:    Prefer utilization over SMP nice


