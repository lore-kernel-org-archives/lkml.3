Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757582AbaDWR10 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 13:27:26 -0400
Received: from mail-gw2-out.broadcom.com ([216.31.210.63]:52327 "EHLO
	mail-gw2-out.broadcom.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754063AbaDWR1W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 13:27:22 -0400
X-IronPort-AV: E=Sophos;i="4.97,912,1389772800"; 
   d="scan'208";a="25946972"
Date: Wed, 23 Apr 2014 10:27:20 -0700
From: Zi Shen Lim <zlim@broadcom.com>
To: Mark Brown <broonie@kernel.org>
CC: Catalin Marinas <catalin.marinas@arm.com>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Mark Rutland <mark.rutland@arm.com>, Will Deacon <will.deacon@arm.com>,
        <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 2/2] arm64: topology: add MPIDR-based detection
Message-ID: <20140423172720.GA18588@lc-sj1-5012.sj.broadcom.com>
References: <1398217214-12204-1-git-send-email-zlim@broadcom.com> <1398217214-12204-3-git-send-email-zlim@broadcom.com> <20140423103648.GM12304@sirena.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset="us-ascii"
Content-Disposition: inline
In-Reply-To: <20140423103648.GM12304@sirena.org.uk>
User-Agent: Mutt/1.4.2.2i
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 23, 2014 at 11:36:48AM +0100, Mark Brown wrote:
> On Tue, Apr 22, 2014 at 06:40:14PM -0700, Zi Shen Lim wrote:
> 
> > +		/* Multiprocessor system */
> > +		if (mpidr & MPIDR_MT_BITMASK) {
> > +			/* Multi-threads per core */
> > +			cpuid_topo->thread_id  = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> > +			cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> > +			cpuid_topo->cluster_id = MPIDR_AFFINITY_LEVEL(mpidr, 2);
> > +		} else {
> > +			/* Single-thread per core */
> > +			cpuid_topo->thread_id  = -1;
> > +			cpuid_topo->core_id    = MPIDR_AFFINITY_LEVEL(mpidr, 0);
> > +			cpuid_topo->cluster_id = MPIDR_AFFINITY_LEVEL(mpidr, 1);
> > +		}
> > +	}
> 
> This means that we ignore affinity level 3 and on non-MT cores we ignore
> affinity level 2.  That means that if it runs on some system where we do
> have multiple levels of clustering (for example some future multi socket
> server) or if for some reason the hardware engineers have decided to use
> one of the higher affinity levels then we will incorrectly report cores
> from several clusters as being part of a single cluster.
> 

Good points.

"Cluster" in my case is actually "Socket".

I guess single-socket in b.L configuration could have multiple clusters,
in which case, a new 'socket_id' would map to aff3 in MT case.

	thread	= aff0
	core	= aff1
	cluster	= aff2
	socket	= aff3

For non-MT, it could very well be aff2?

	thread	= -1
	core	= aff0
	cluster	= aff1
	socket	= aff2

Or is it likely that some folks may opt to skip aff2, and simply use aff3?
Mark, is there precedence for such usage of affinity levels?

Maybe ARM folks can point us to documentation or conventions w.r.t.
usage of those affinity levels.  Otherwise, this has potential to become
a creative playground :)

> I had been intending to just combine all the bits from affinitly levels
> above the CPU number into a single number until we know what to do with
> them individually.  We shouldn't just ignore them.
> 

I agree we shouldn't ignore aff3 if someone is already using it.

I'm not sure how combining them into a single number helps with topology.
We already started out with a cpuid, no?

Perhaps we should just add a new 'socket_id' and that will accommodate
all cases (up to aff3).

> > +	pr_info("CPU%u: cluster %d core %d thread %d mpidr %llx\n",
> > +		cpuid, cpuid_topo->cluster_id, cpuid_topo->core_id,
> > +		cpuid_topo->thread_id, mpidr);
> > +
> 
> Catalin or Lorenzo asked for stuff like that to be taken out.

Is it ok to change it pr_debug instead? Or drop it completely?

