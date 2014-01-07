Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753876AbaAGVMs (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Jan 2014 16:12:48 -0500
Received: from merlin.infradead.org ([205.233.59.134]:41753 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751114AbaAGVMj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Jan 2014 16:12:39 -0500
Date: Tue, 7 Jan 2014 22:12:29 +0100
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
Message-ID: <20140107211229.GF2480@laptop.programming.kicks-ass.net>
References: <20140106164150.GQ31570@twins.programming.kicks-ass.net>
 <1389026867.32504.16.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106180636.GG30183@twins.programming.kicks-ass.net>
 <1389039035.32504.35.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106212623.GH30183@twins.programming.kicks-ass.net>
 <1389044899.32504.43.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140106221251.GJ30183@twins.programming.kicks-ass.net>
 <1389048315.32504.57.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140107083440.GL30183@twins.programming.kicks-ass.net>
 <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jan 07, 2014 at 03:15:52PM +0000, Waskiewicz Jr, Peter P wrote:
> > Still confused here. So what you're saying is that cachelines get tagged
> > with {CR3,RMID} and when they observe the same CR3 with a different RMID
> > the hardware will iterate the entire cache and update all tuples?
> > 
> > That seems both very expensive and undesirable. It would mean you could
> > never use the RMID to creates slices of a process since you're stuck to
> > the CR3.
> > 
> > It also makes me wonder why we have the RMID at all; because if you're
> > already tagging every line with the CR3, why not build the cache monitor
> > on that. Just query the occupancy for all CR3s in your group and add.
> 
> The reason is the RMID needs to be retained on the cache entry when it
> is promoted to another layer of cache, and (possibly) returns to the LLC
> later.  And the mechanism to return the occupancy is how you hope it is,
> query the occupancy for all CR3s and add.  If you didn't have the RMID
> tagged on the cache entry, then you couldn't do that.

Maybe its me (its late) but I can't follow.

So if every cacheline is tagged with both CR3 and RMID (on all levels --
I get that it needs to propagate etc..) then you can, upon observing a
new CR3,RMID pair, iterate the entire cache for the matching CR3 and
update its RMID.

This, while expensive, would fairly quickly propagate changes.

Now I'm not at all sure cachelines are CR3 tagged.

The above has downsides in that you cannot use RMIDs to slice into
processes, where a pure RMID (without CR3 relation, even if cachelines
are CR3 tagged) can slice processes -- note that process is an
address-space/CR3 collection of threads.

A pure RMID tagging solution would not allow the immediate update and
would require on demand updates on new cacheline usage.

This makes switching RMIDs effects slower to propagate.

> > The other possible interpretation is that it updates on-demand whenever
> > it touches a cacheline. But in that case, how do you deal with the
> > non-exclusive states? Does the last RMID to touch a non-exclusive
> > cacheline simply claim the entire line?
> 
> I don't believe it claims the whole line; I had that exact discussion
> awhile ago with the CPU architect, and this didn't appear broken before.
> I will ask him again though since that discussion was over a year ago.
> 
> > But that doesn't avoid the problem; because as soon as you change the
> > PQR_ASSOC RMID you still need to go run for a while to touch 'all' your
> > lines.
> > 
> > This duration is indeterminate; which again brings us back to needing to
> > first wipe the entire cache.
> 
> I asked hpa if there is a clean way to do that outside of a WBINVD, and
> the answer is no.
> 
> I've sent the two outstanding questions off to the CPU architect, I'll
> let you know what he says once I hear.

Much appreciated; so I'd like a complete description of how this thing
works, with in particular when exactly lines are tagged.

So my current mental model would tag a line with the current (ASSOC)
RMID on:
 - load from DRAM -> L*, even for non-exclusive
 - any to exclusive transition

The result of such rules is that when the effective RMID of a task
changes it takes an indeterminate amount of time before the residency
stats reflect reality again.

Furthermore; the IA32_QM_CTR is a misnomer as its a VALUE not a COUNTER.
Not to mention the entire SDM 17.14.2 section is a mess; it purports to
describe how to detect the thing using CPUID but then also maybe
describes how to program it.

