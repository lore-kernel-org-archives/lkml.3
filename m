Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751821AbaBRTfr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Feb 2014 14:35:47 -0500
Received: from merlin.infradead.org ([205.233.59.134]:60446 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751851AbaBRTfp (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Feb 2014 14:35:45 -0500
Date: Tue, 18 Feb 2014 20:35:28 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: "Waskiewicz Jr, Peter P" <peter.p.waskiewicz.jr@intel.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>, Tejun Heo <tj@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        Li Zefan <lizefan@huawei.com>,
        "containers@lists.linux-foundation.org" 
	<containers@lists.linux-foundation.org>,
        "cgroups@vger.kernel.org" <cgroups@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Stephane Eranian <eranian@google.com>
Subject: Re: [PATCH 0/4] x86: Add Cache QoS Monitoring (CQM) support
Message-ID: <20140218193528.GQ14089@laptop.programming.kicks-ass.net>
References: <20140106221251.GJ30183@twins.programming.kicks-ass.net>
 <1389048315.32504.57.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140107083440.GL30183@twins.programming.kicks-ass.net>
 <1389107743.32504.69.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140107211229.GF2480@laptop.programming.kicks-ass.net>
 <1389380100.32504.172.camel@ppwaskie-mobl.amr.corp.intel.com>
 <20140113075528.GR7572@laptop.programming.kicks-ass.net>
 <52D57AC2.3090109@zytor.com>
 <20140127173420.GA9636@twins.programming.kicks-ass.net>
 <1392744567.3069.42.camel@ppwaskie-mobl.amr.corp.intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1392744567.3069.42.camel@ppwaskie-mobl.amr.corp.intel.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Feb 18, 2014 at 05:29:42PM +0000, Waskiewicz Jr, Peter P wrote:
> > Its not a problem that changing the task:RMID map is expensive, what is
> > a problem is that there's no deterministic fashion of doing it.
> 
> We are going to add to the SDM that changing RMID's often/frequently is
> not the intended use case for this feature, and can cause bogus data.
> The real intent is to land threads into an RMID, and run that until the
> threads are effectively done.
> 
> That being said, reassigning a thread to a new RMID is certainly
> supported, just "frequent" updates is not encouraged at all.

You don't even need really high frequency, just unsynchronized wrt
reading the counter. Suppose A flips the RMIDs about and just when its
done programming B reads them.

At that point you've got 0 guarantee the data makes any kind of sense.

> I do see that, however the userspace interface for this isn't ideal for
> how the feature is intended to be used.  I'm still planning to have this
> be managed per process in /proc/<pid>, I just had other priorities push
> this back a bit on my stovetop.

So I really don't like anything /proc/$pid/ nor do I really see a point in
doing that. What are you going to do in the /proc/$pid/ thing anyway?
Exposing raw RMIDs is an absolute no-no, and anything else is going to
end up being yet-another-grouping thing and thus not much different from
cgroups.

> Also, now that the new SDM is available

Can you guys please set up a mailing list already so we know when
there's new versions out? Ideally mailing out the actual PDF too so I
get the automagic download and archive for all versions.

> , there is a new feature added to
> the same family as CQM, called Memory Bandwidth Monitoring (MBM).  The
> original cgroup approach would have allowed another subsystem be added
> next to cacheqos; the perf-cgroup here is not easily expandable.
> The /proc/<pid> approach can add MBM pretty easily alongside CQM.

I'll have to go read up what you've done now, but if its also RMID based
I don't see why the proposed scheme won't work.

> > The below is a rough draft, most if not all XXXs should be
> > fixed/finished. But given I don't actually have hardware that supports
> > this stuff (afaik) I couldn't be arsed.
> 
> The hardware is not publicly available yet, but I know that Red Hat and
> others have some of these platforms for testing.

Yeah, not in my house therefore it doesn't exist :-)

> I really appreciate the patch.  There was a good amount of thought put
> into this, and gave a good set of different viewpoints.  I'll keep the
> comments all here in one place, it'll be easier to discuss than
> disjointed in the code.
> 
> The rotation idea to reclaim RMID's no longer in use is interesting.
> This differs from the original patch where the original patch would
> reclaim the RMID when monitoring was disabled for that group of
> processes.
> 
> I can see a merged sort of approach, where if monitoring for a group of
> processes is disabled, we can place that RMID onto a reclaim list.  The
> next time an RMID is requested (monitoring is enabled for a
> process/group of processes), the reclaim list is searched for an RMID
> that has 0 occupancy (i.e. not in use), or worst-case, find and assign
> one with the lowest occupancy.  I did discuss this with hpa offline and
> this seemed reasonable.
> 
> Thoughts?

So you have to wait for one 'freed' RMID to become empty before
'allowing' reads of the other RMIDs, otherwise the visible value can be
complete rubbish. Even for low frequency rotation, see the above
scenario about asynchronous operations.

This means you have to always have at least one free RMID.
