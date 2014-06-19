Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752125AbaFSETP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Jun 2014 00:19:15 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:34938 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750708AbaFSETO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Jun 2014 00:19:14 -0400
Date: Wed, 18 Jun 2014 21:19:00 -0700
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: Andi Kleen <ak@linux.intel.com>
Cc: Dave Hansen <dave.hansen@intel.com>, LKML <linux-kernel@vger.kernel.org>,
        Josh Triplett <josh@joshtriplett.org>,
        "Chen, Tim C" <tim.c.chen@intel.com>, Christoph Lameter <cl@linux.com>
Subject: Re: [bisected] pre-3.16 regression on open() scalability
Message-ID: <20140619041900.GD4669@linux.vnet.ibm.com>
Reply-To: paulmck@linux.vnet.ibm.com
References: <53A0CAE5.9000702@intel.com>
 <20140618001836.GV4669@linux.vnet.ibm.com>
 <53A132D4.60408@intel.com>
 <20140618125831.GB4669@linux.vnet.ibm.com>
 <53A1CE19.7040103@intel.com>
 <20140618203052.GT4669@linux.vnet.ibm.com>
 <20140618235131.GA25946@linux.vnet.ibm.com>
 <20140619014200.GO8178@tassilo.jf.intel.com>
 <20140619021337.GA4669@linux.vnet.ibm.com>
 <20140619033816.GQ8178@tassilo.jf.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140619033816.GQ8178@tassilo.jf.intel.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14061904-0928-0000-0000-000002CC5821
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Jun 18, 2014 at 08:38:16PM -0700, Andi Kleen wrote:
> On Wed, Jun 18, 2014 at 07:13:37PM -0700, Paul E. McKenney wrote:
> > On Wed, Jun 18, 2014 at 06:42:00PM -0700, Andi Kleen wrote:
> > > 
> > > I still think it's totally the wrong direction to pollute so 
> > > many fast paths with this obscure debugging check workaround
> > > unconditionally.
> > 
> > OOM prevention should count for something, I would hope.
> 
> OOM in what scenario? This is getting bizarre.

On the bizarre part, at least we agree on something.  ;-)

CONFIG_NO_HZ_FULL booted with at least one nohz_full CPU.  Said CPU
gets into the kernel and stays there, not necessarily generating RCU
callbacks.  The other CPUs are very likely generating RCU callbacks.
Because the nohz_full CPU is in the kernel, and because there are no
scheduling-clock interrupts on that CPU, grace periods do not complete.
Eventually, the callbacks from the other CPUs (and perhaps also some
from the nohz_full CPU, for that matter) OOM the machine.

Now this scenario constitutes an abuse of CONFIG_NO_HZ_FULL, because it
is intended for CPUs that execute either in userspace (in which case
those CPUs are in extended quiescent states so that RCU can happily
ignore them) or for real-time workloads with low CPU untilization (in
which case RCU sees them go idle, which is also a quiescent state).
But that won't stop people from abusing their kernels and complaining
when things break.

This same thing can also happen without CONFIG_NO_HZ full, though
the system has to work a bit harder.  In this case, the CPU looping
in the kernel has scheduling-clock interrupts, but if all it does
is cond_resched(), RCU is never informed of any quiescent states.
The whole point of this patch is to make those cond_resched() calls,
which are quiescent states, visible to RCU.

> If something keeps looping forever in the kernel creating 
> RCU callbacks without any real quiescent states it's simply broken.

I could get behind that.  But by that definition, there is a lot of
breakage in the current kernel, especially as we move to larger CPU
counts.

							Thanx, Paul

