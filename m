Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933754Ab3D3Vsh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Apr 2013 17:48:37 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:60439 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760674Ab3D3Vsc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Apr 2013 17:48:32 -0400
Date: Tue, 30 Apr 2013 14:48:26 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Dave Jones <davej@redhat.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        paul.mckenney@linaro.org, mmarek@suse.cz, linux-kbuild@vger.kernel.org
Subject: Re: rcu: Provide compile-time control for no-CBs CPUs
Message-ID: <20130430214826.GK3780@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <20130430152126.0C564660906@gitolite.kernel.org>
 <20130430184612.GA14568@redhat.com>
 <20130430192541.GE3780@linux.vnet.ibm.com>
 <20130430202440.GA18598@redhat.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130430202440.GA18598@redhat.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13043021-2876-0000-0000-00000824EAF4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 30, 2013 at 04:24:40PM -0400, Dave Jones wrote:
> On Tue, Apr 30, 2013 at 12:25:41PM -0700, Paul E. McKenney wrote:
>  > On Tue, Apr 30, 2013 at 02:46:12PM -0400, Dave Jones wrote:
> 
>  > > Additionally, nowhere in any of this text does it say what a "no-CB CPU" is,
>  > > or why I would care, or even what the downsides are for each option.
>  > 
>  > In the absence of any Kconfig change, would the following be more helpful?
> 
> A little. You've now documented the mechanism behind each choice,
> but there's still no real explanation why I would pick one over the other.
> The average reader of these texts isn't going to know whether running something
> from a kthread is a better/worse idea than running from softirq context.
> 
> Who doesn't like saving energy ? Why would I leave it at the NONE default ?
> Why is it even an option ? I'm assuming there's a reason we don't pick
> (one of the) energy efficient options by default (performance?) who knows,
> there's no explanation.
> 
> Why would I want to treat CPU0 differently ? What user-visible downsides
> are there ? Who knows..

OK, taking the questions one at a time...

o	Who doesn't like saving energy?

	That depends on what you lose when you save the energy.  In fact,
	there may come a time when RCU always invokes its context from
	kthread context.  But before I take that step, I need to see
	a year or two worth of experience with this for a lot of different
	workloads, especially workloads involving extremely heavy
	networking loads.

o	Why would I leave it at the NONE default?
o	Why is it even an option?

	Because if you are doing testing or running benchmarks to check
	the effects of setting different numbers of CPUs to no-CBs mode,
	and you might not want to incur the overhead of a kernel build
	between each run.  The NONE default is what you want for this
	case, because it allows complete freedom to choose an arbitrary
	no-CBs configuration on each boot.

o	I'm assuming there's a reason we don't pick (one of the) energy
	efficient options by default (performance)?

	The reason I picked NONE as default is because it gives the most
	boot-time flexibility.	I felt that flexibility was important
	at the moment because I expect most of the users to be kicking
	the tires rather than putting it into production.  I might well
	change the default later on, in fact, I might well eliminate
	the choice entirely (so that all CPUs are always no-CBs CPUs)
	if experience indicates that this is a reasonable approach.

o	Why would I want to treat CPU0 differently?

	I added this option because it ensures that the various people
	doing randconfig testing will at least sometimes test a mixed
	system that has only some of the CPUs be no-CBs CPUs.

o	What user-visible downsides are there?

	There might well not be any.  In theory, no-CBs CPUs will incur
	a little bit more overhead, especially if they are pinned to
	some CPU on the other side of the system from the CPU they
	are serving.  In practice, you would have to show me a workload
	where this difference was visible at the system level, but at
	the same time, I clearly cannot prove that there is no such
	workload.

Should I add this to the Kconfig help text?  My guess is "not all of it",
but figured I should ask.  See below for my current best guess.

>  > +choice
>  > +	prompt "Build-forced no-CBs CPUs"
>  > +	default RCU_NOCB_CPU_NONE
>  > +	help
>  > +	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
>  > +	  from kthreads rather than from softirq context) to be specified
>  > +	  at build time.  Additional no-CBs CPUs may be specified by
>  > +	  the rcu_nocbs= boot parameter.
>  > +
>  > +config RCU_NOCB_CPU_NONE
>  > +	bool "No build_forced no-CBs CPUs"
>  > +	depends on RCU_NOCB_CPU
>  > +	help
>  > +	  This option does not force any of the CPUs to be no-CBs CPUs.
>  > +	  Only CPUs designated by the rcu_nocbs= boot parameter will be
>  > +	  no-CBs CPUs, whose RCU callbacks will be invoked by per-CPU
>  > +	  rcuo kthreads.  All other CPUs will invoke their own RCU
>  > +	  callbacks in softirq context.
>  > +
>  > +config RCU_NOCB_CPU_ZERO
>  > +	bool "CPU 0 is a build_forced no-CBs CPU"
>  > +	depends on RCU_NOCB_CPU
>  > +	help
>  > +	  This option forces CPU 0 to be a no-CBs CPU, so that its
>  > +	  RCU callbacks are invoked by a per-CPU rcuo kthread.
>  > +	  Additional CPUs may be designated as no-CBs CPUs using the
>  > +	  rcu_nocbs= boot parameter will be no-CBs CPUs.  All other CPUs
>  > +	  will invoke their own RCU callbacks in softirq context.
>  > +
>  > +	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
>  > +	  or energy-efficiency reasons.
>  > +
>  > +config RCU_NOCB_CPU_ALL
>  > +	bool "All CPUs are build_forced no-CBs CPUs"
>  > +	depends on RCU_NOCB_CPU
>  > +	help
>  > +	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
>  > +	  boot parameter will be ignored.  All CPUs' RCU callbacks will
>  > +	  be executed in the context of per-CPU rcuo kthreads created
>  > +	  for this purpose.
>  > +
>  > +	  Select this if all CPUs need to be no-CBs CPUs for real-time
>  > +	  or energy-efficiency reasons.
> 
> I know how much IBMers love their acronyms. I thought you'd invented
> some new rcu variant for a moment. Perhaps "kthreads named 'rcuo'"
> would be clearer ?

Good point, changed as you suggest.  And I am trying to avoid
perpetrating^Winventing new RCU flavors, at least for the next
week or two.

Speaking as an IBMer, I can only hang my head in shame at my inability
thus far to come up with an acronym that is at least five letters long,
but consisting only of vowels.  ;-)

							Thanx, Paul

------------------------------------------------------------------------

config RCU_NOCB_CPU
	bool "Offload RCU callback processing from boot-selected CPUs"
	depends on TREE_RCU || TREE_PREEMPT_RCU
	default n
	help
	  Use this option to reduce OS jitter for aggressive HPC or
	  real-time workloads.	It can also be used to offload RCU
	  callback invocation to energy-efficient CPUs in battery-powered
	  asymmetric multiprocessors.

	  This option offloads callback invocation from the set of
	  CPUs specified at boot time by the rcu_nocbs parameter.
	  For each such CPU, a kthread ("rcuox/N") will be created to
	  invoke callbacks, where the "N" is the CPU being offloaded,
	  and where the "x" is "b" for RCU-bh, "p" for RCU-preempt, and
	  "s" for RCU-sched.  Nothing prevents this kthread from running
	  on the specified CPUs, but (1) the kthreads may be preempted
	  between each callback, and (2) affinity or cgroups can be used
	  to force the kthreads to run on whatever set of CPUs is desired.

	  Say Y here if you want to help to debug reduced OS jitter.
	  Say N here if you are unsure.

choice
	prompt "Build-forced no-CBs CPUs"
	default RCU_NOCB_CPU_NONE
	help
	  This option allows no-CBs CPUs (whose RCU callbacks are invoked
	  from kthreads rather than from softirq context) to be specified
	  at build time.  Additional no-CBs CPUs may be specified by
	  the rcu_nocbs= boot parameter.

config RCU_NOCB_CPU_NONE
	bool "No build_forced no-CBs CPUs"
	depends on RCU_NOCB_CPU
	help
	  This option does not force any of the CPUs to be no-CBs CPUs.
	  Only CPUs designated by the rcu_nocbs= boot parameter will be
	  no-CBs CPUs, whose RCU callbacks will be invoked by per-CPU
	  kthreads whose names begin with "rcuo".  All other CPUs will
	  invoke their own RCU callbacks in softirq context.

	  Select this option if you want to choose no-CBs CPUs at
	  boot time, for example, to allow testing of different no-CBs
	  configurations without having to rebuild the kernel each time.

config RCU_NOCB_CPU_ZERO
	bool "CPU 0 is a build_forced no-CBs CPU"
	depends on RCU_NOCB_CPU
	help
	  This option forces CPU 0 to be a no-CBs CPU, so that its RCU
	  callbacks are invoked by a per-CPU kthread whose name begins
	  with "rcuo".	Additional CPUs may be designated as no-CBs
	  CPUs using the rcu_nocbs= boot parameter will be no-CBs CPUs.
	  All other CPUs will invoke their own RCU callbacks in softirq
	  context.

	  Select this if CPU 0 needs to be a no-CBs CPU for real-time
	  or energy-efficiency reasons, but the real reason it exists
	  is to ensure that randconfig testing covers mixed systems.

config RCU_NOCB_CPU_ALL
	bool "All CPUs are build_forced no-CBs CPUs"
	depends on RCU_NOCB_CPU
	help
	  This option forces all CPUs to be no-CBs CPUs.  The rcu_nocbs=
	  boot parameter will be ignored.  All CPUs' RCU callbacks will
	  be executed in the context of per-CPU rcuo kthreads created for
	  this purpose.  Assuming that the kthreads whose names start with
	  "rcuo" are bound to "housekeeping" CPUs, this reduces OS jitter
	  on the remaining CPUs, but might decrease memory locality during
	  RCU-callback invocation, thus potentially degrading throughput.

	  Select this if all CPUs need to be no-CBs CPUs for real-time
	  or energy-efficiency reasons.

endchoice

