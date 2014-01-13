Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751451AbaAMHzn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 02:55:43 -0500
Received: from merlin.infradead.org ([205.233.59.134]:47559 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751227AbaAMHzk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 02:55:40 -0500
Date: Mon, 13 Jan 2014 08:55:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: Tejun Heo <tj@kernel.org>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Message-ID: <20140113075528.GR7572@laptop.programming.kicks-ass.net>
References: <20140106180636.GG30183@twins.programming.kicks-ass.net>
 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106212623.GH30183@twins.programming.kicks-ass.net>
 <1389044899.32504.43.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106221251.GJ30183@twins.programming.kicks-ass.net>
 <1389048315.32504.57.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140107083440.GL30183@twins.programming.kicks-ass.net>
 <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140107211229.GF2480@laptop.programming.kicks-ass.net>
 <1389380100.32504.172.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389380100.32504.172.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jan 10, 2014 at 06:55:11PM +0000, Waskiewicz Jr, Peter P wrote:
> I've spoken with the CPU architect, and he's set me straight.  I was
> getting some simulation data and reality mixed up, so apologies.
> 
> The cacheline is tagged with the RMID being tracked when it's brought
> into the cache.  That is the only time it's tagged, it does not get
> updated (I was looking at data showing impacts if it was updated).
> 
> If there are frequent RMID updates for a particular process, then there
> is the possibility that any remaining old data for that process can be
> accounted for on a different RMID.  This really is workload dependent,
> and my architect provided their data showing that this occurrence is
> pretty much in the noise.

What change frequency and what sided workloads did they test?

I can make it significant; take a multi-threaded workload that mostly
fits in cache, then assign all theads but one RMDI 0, then fairly
quickly rotate RMID 1 between the threads.

The problem is, since there's a limited number of RMIDs we have to
rotate at some point, but since changing RMIDs is nondeterministic we
can't.

> Also, I did ask about the granularity of the RMID, and it is
> per-cacheline.  So if there is a non-exclusive cacheline, then the
> occupancy data in the other part of the cacheline will count against the
> RMID.

One more question:

  u64 i;
  u64 rmid_val[];

  for (i = 0; i < rmid_max; i++) {
    wrmsr(IA32_QM_EVTSEL, 1 | (i << 32));
    rdmsr(IA32_QM_CTR, rmid_val[i]);
  }

Is this the right way of reading these values? I couldn't find anything
that says the event must 'run' to accumulate a value at all, so all it
seems it a direct value read with a multiplexer to the RMID.

> > So my current mental model would tag a line with the current (ASSOC)
> > RMID on:
> >  - load from DRAM -> L*, even for non-exclusive
> >  - any to exclusive transition
> > 
> > The result of such rules is that when the effective RMID of a task
> > changes it takes an indeterminate amount of time before the residency
> > stats reflect reality again.
> > 
> > Furthermore; the IA32_QM_CTR is a misnomer as its a VALUE not a COUNTER.
> > Not to mention the entire SDM 17.14.2 section is a mess; it purports to
> > describe how to detect the thing using CPUID but then also maybe
> > describes how to program it.
> 
> I've given this feedback to the section owner in the SDM.  There is an
> update due this month, and there will be some updates to this section
> (along with some additions).
> 
> I should have my alternate implementation sent out shortly, just working
> a few kinks out of it.  This is the proc-based and sysfs-based interface
> that will rely on a userspace program to handle the logic of grouping
> and assigning stuff together.

I've not figured out how to deal with this stuff yet; exposing RMIDs to
userspace is a guaranteed fail though. Any interface that disallows the
kernel to manage the RMIDs is broken.


