Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757415AbaFSFYX (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 01:24:23 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:62273 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757303AbaFSFYW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 01:24:22 -0400
Message-ID: <1403155458.5189.54.camel@marge.simpson.net>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
From: Mike Galbraith <umgwanakikbuti@gmail.com>
To: paulmck@linux.vnet.ibm.com
Cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Date: Thu, 19 Jun 2014 07:24:18 +0200
In-Reply-To: <20140619041900.GD4669@linux.vnet.ibm.com>
References: <53A0CAE5.9000702@intel.com>
	 <20140618001836.GV4669@linux.vnet.ibm.com> <53A132D4.60408@intel.com>
	 <20140618125831.GB4669@linux.vnet.ibm.com> <53A1CE19.7040103@intel.com>
	 <20140618203052.GT4669@linux.vnet.ibm.com>
	 <20140618235131.GA25946@linux.vnet.ibm.com>
	 <20140619014200.GO8178@tassilo.jf.intel.com>
	 <20140619021337.GA4669@linux.vnet.ibm.com>
	 <20140619033816.GQ8178@tassilo.jf.intel.com>
	 <20140619041900.GD4669@linux.vnet.ibm.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, 2014-06-18 at 21:19 -0700, Paul E. McKenney wrote: 
> On Wed, Jun 18, 2014 at 08:38:16PM -0700, Andi Kleen wrote:
> > On Wed, Jun 18, 2014 at 07:13:37PM -0700, Paul E. McKenney wrote:
> > > On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> > > > 
> > > > I still think it's totally the wrong direction to pollute so 
> > > > many fast paths with this obscure debugging check workaround
> > > > unconditionally.
> > > 
> > > OOM prevention should count for something, I would hope.
> > 
> > OOM in what scenario? This is getting bizarre.
> 
> On the bizarre part, at least we agree on something.  ;-)
> 
> CONFIG_NO_HZ_FULL booted with at least one nohz_full CPU.  Said CPU
> gets into the kernel and stays there, not necessarily generating RCU
> callbacks.  The other CPUs are very likely generating RCU callbacks.
> Because the nohz_full CPU is in the kernel, and because there are no
> scheduling-clock interrupts on that CPU, grace periods do not complete.
> Eventually, the callbacks from the other CPUs (and perhaps also some
> from the nohz_full CPU, for that matter) OOM the machine.
> 
> Now this scenario constitutes an abuse of CONFIG_NO_HZ_FULL, because it
> is intended for CPUs that execute either in userspace (in which case
> those CPUs are in extended quiescent states so that RCU can happily
> ignore them) or for real-time workloads with low CPU untilization (in
> which case RCU sees them go idle, which is also a quiescent state).
> But that won't stop people from abusing their kernels and complaining
> when things break.

IMHO, those people can keep the pieces.

I don't even enable RCU_BOOST in -rt kernels, because that safety net
has a price.  The instant Joe User picks up the -rt shovel, it's his
grave, and he gets to do the digging.  Instead of trying to save his
bacon, I hand him a slightly better shovel, let him prioritize all
kthreads including workqueues.  Joe can dig all he wants to, and it's on
him, I just make sure he has the means to bury himself properly :)

> This same thing can also happen without CONFIG_NO_HZ full, though
> the system has to work a bit harder.  In this case, the CPU looping
> in the kernel has scheduling-clock interrupts, but if all it does
> is cond_resched(), RCU is never informed of any quiescent states.
> The whole point of this patch is to make those cond_resched() calls,
> which are quiescent states, visible to RCU.
> 
> > If something keeps looping forever in the kernel creating 
> > RCU callbacks without any real quiescent states it's simply broken.
> 
> I could get behind that.  But by that definition, there is a lot of
> breakage in the current kernel, especially as we move to larger CPU
> counts.

Not only larger CPU counts: skipping the -rq clock update on wakeup
(cycle saving optimization) turned out to be deadly to boxen with a
zillion disks because our wakeup latency can be so incredibly horrible
that falsely attributing wakeup latency to the next task to run
(watchdog) resulted in it being throttled for long enough that big IO
boxen panicked during boot.

The root cause of that wasn't the optimization, the root was the
horrific amounts of time we can spend locked up in the kernel.

-Mike

