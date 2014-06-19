Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934241AbaFSSOP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 14:14:15 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:54762 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933173AbaFSSON (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 14:14:13 -0400
Date: Thu, 19 Jun 2014 11:14:04 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Mike Galbraith <umgwanakikbuti@gmail.com>
Cc: Andi Kleen <ak@linux.intel.com>, Dave Hansen <dave.hansen@intel.com>,
        LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619181403.GF4904@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <20140619021337.GA4669@linux.vnet.ibm.com>
 <20140619033816.GQ8178@tassilo.jf.intel.com>
 <20140619041900.GD4669@linux.vnet.ibm.com>
 <1403155458.5189.54.camel@marge.simpson.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1403155458.5189.54.camel@marge.simpson.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061918-6688-0000-0000-000002AE1B56
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jun 19, 2014 at 07:24:18AM +0200, Mike Galbraith wrote:
> On Wed, 2014-06-18 at 21:19 -0700, Paul E. McKenney wrote: 
> > On Wed, Jun 18, 2014 at 08:38:16PM -0700, Andi Kleen wrote:
> > > On Wed, Jun 18, 2014 at 07:13:37PM -0700, Paul E. McKenney wrote:
> > > > On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> > > > > 
> > > > > I still think it's totally the wrong direction to pollute so 
> > > > > many fast paths with this obscure debugging check workaround
> > > > > unconditionally.
> > > > 
> > > > OOM prevention should count for something, I would hope.
> > > 
> > > OOM in what scenario? This is getting bizarre.
> > 
> > On the bizarre part, at least we agree on something.  ;-)
> > 
> > CONFIG_NO_HZ_FULL booted with at least one nohz_full CPU.  Said CPU
> > gets into the kernel and stays there, not necessarily generating RCU
> > callbacks.  The other CPUs are very likely generating RCU callbacks.
> > Because the nohz_full CPU is in the kernel, and because there are no
> > scheduling-clock interrupts on that CPU, grace periods do not complete.
> > Eventually, the callbacks from the other CPUs (and perhaps also some
> > from the nohz_full CPU, for that matter) OOM the machine.
> > 
> > Now this scenario constitutes an abuse of CONFIG_NO_HZ_FULL, because it
> > is intended for CPUs that execute either in userspace (in which case
> > those CPUs are in extended quiescent states so that RCU can happily
> > ignore them) or for real-time workloads with low CPU untilization (in
> > which case RCU sees them go idle, which is also a quiescent state).
> > But that won't stop people from abusing their kernels and complaining
> > when things break.
> 
> IMHO, those people can keep the pieces.
> 
> I don't even enable RCU_BOOST in -rt kernels, because that safety net
> has a price.  The instant Joe User picks up the -rt shovel, it's his
> grave, and he gets to do the digging.  Instead of trying to save his
> bacon, I hand him a slightly better shovel, let him prioritize all
> kthreads including workqueues.  Joe can dig all he wants to, and it's on
> him, I just make sure he has the means to bury himself properly :)

One of the nice things about NO_HZ_FULL is that it should reduce the
need for RCU_BOOST.  One of the purposes of RCU_BOOST is for the guy
who has an infinite-loop bug in a high-priority RT-priority process,
because such processes can starve out low-priority RCU readers.  But
with a properly configured NO_HZ_FULL system, the low-priority processes
aren't sharing CPUs with the RT-priority processes.

In fact, it might be worth making RCU_BOOST depend on !NO_HZ_FULL in -rt.

> > This same thing can also happen without CONFIG_NO_HZ full, though
> > the system has to work a bit harder.  In this case, the CPU looping
> > in the kernel has scheduling-clock interrupts, but if all it does
> > is cond_resched(), RCU is never informed of any quiescent states.
> > The whole point of this patch is to make those cond_resched() calls,
> > which are quiescent states, visible to RCU.
> > 
> > > If something keeps looping forever in the kernel creating 
> > > RCU callbacks without any real quiescent states it's simply broken.
> > 
> > I could get behind that.  But by that definition, there is a lot of
> > breakage in the current kernel, especially as we move to larger CPU
> > counts.
> 
> Not only larger CPU counts: skipping the -rq clock update on wakeup
> (cycle saving optimization) turned out to be deadly to boxen with a
> zillion disks because our wakeup latency can be so incredibly horrible
> that falsely attributing wakeup latency to the next task to run
> (watchdog) resulted in it being throttled for long enough that big IO
> boxen panicked during boot.
> 
> The root cause of that wasn't the optimization, the root was the
> horrific amounts of time we can spend locked up in the kernel.

Completely agreed!

							Thanx, Paul

