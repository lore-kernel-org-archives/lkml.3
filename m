Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754628AbaKEMeI (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 07:34:08 -0500
Received: from casper.infradead.org ([85.118.1.10]:44898 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753888AbaKEMeF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 07:34:05 -0500
Date: Wed, 5 Nov 2014 13:33:54 +0100
From: Peter Zijlstra <peterz@infradead.org>
To: Robert Bragg <robert@sixbynine.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
Message-ID: <20141105123354.GR3337@twins.programming.kicks-ass.net>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <20141030190841.GI23531@worktop.programming.kicks-ass.net>
 <CAMou1-12ggxAuaPQ8VG7Gf5BZM6CVj6773HRB1QJXagB-okuGg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMou1-12ggxAuaPQ8VG7Gf5BZM6CVj6773HRB1QJXagB-okuGg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 03, 2014 at 09:47:17PM +0000, Robert Bragg wrote:

> > And do I take it right that if you're able/allowed/etc.. to open/have
> > the fd to the GPU/DRM/DRI whatever context you have the right
> > credentials to also observe these counters?
> 
> Right and in particular since we want to allow OpenGL clients to be
> able the profile their own gpu context with out any special privileges
> my current pmu driver accepts a device file descriptor via config1 + a
> context id via attr->config, both for checking credentials and
> uniquely identifying which context should be profiled. (A single
> client can open multiple contexts via one drm fd)

Ah interesting. So we've got fd+context_id+event_id to identify any one
number provided by the GPU.

> That said though; when running as root it is not currently a
> requirement to pass any fd when configuring an event to profile across
> all gpu contexts. I'm just mentioning this because although I think it
> should be ok for us to use an fd to determine credentials and help
> specify a gpu context, an fd might not be necessary for system wide
> profiling cases.

Hmm, how does root know what context_id to provide? Are those exposed
somewhere? Is there also a root context, one that encompasses all
others?

> >> Conceptually I suppose we want to be able to open an event that's not
> >> associated with any cpu or process, but to keep things simple and fit
> >> with perf's current design, the pmu I have a.t.m expects an event to be
> >> opened for a specific cpu and unspecified process.
> >
> > There are no actual scheduling ramifications right? Let me ponder his
> > for a little while more..
> 
> Ok, I can't say I'm familiar enough with the core perf infrastructure
> to entirely sure about this.

Yeah, so I don't think so. Its on the device, nothing the CPU/scheduler
does affects what the device does.

> I recall looking at how some of the uncore perf drivers were working
> and it looked like they had a similar issue where conceptually the pmu
> doesn't belong to a specific cpu and so the id would internally get
> mapped to some package state, shared by multiple cpus.

Yeah, we could try and map these devices to a cpu on their node -- PCI
devices are node local. But I'm not sure we need to start out by doing
that.

> My understanding had been that being associated with a specific cpu
> did have the side effect that most of the pmu methods for that event
> would then be invoked on that cpu through inter-process interrupts. At
> one point that had seemed slightly problematic because there weren't
> many places within my pmu driver where I could assume I was in process
> context and could sleep. This was a problem with an earlier version
> because the way I read registers had a slim chance of needing to sleep
> waiting for the gpu to come out of RC6, but isn't a problem any more.

Right, so I suppose we could make a new global context for these device
like things and avoid some that song and dance. But we can do that
later.

> One thing that does come to mind here though is that I am overloading
> pmu->read() as a mechanism for userspace to trigger a flush of all
> counter snapshots currently in the gpu circular buffer to userspace as
> perf events. Perhaps it would be best if that work (which might be
> relatively costly at times) were done in the context of the process
> issuing the flush(), instead of under an IPI (assuming that has some
> effect on scheduler accounting).

Right, so given you tell the GPU to periodically dump these stats (per
context I presume), you can at a similar interval schedule whatever to
flush this and update the relevant event->count values and have an NO-OP
pmu::read() method.

If the GPU provides interrupts to notify you of new data or whatnot, you
can make that drive the thing.

