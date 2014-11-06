Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751208AbaKFApO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Nov 2014 19:45:14 -0500
Received: from mail-wg0-f48.google.com ([74.125.82.48]:55284 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750873AbaKFApJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Nov 2014 19:45:09 -0500
MIME-Version: 1.0
In-Reply-To: <20141105123354.GR3337@twins.programming.kicks-ass.net>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <20141030190841.GI23531@worktop.programming.kicks-ass.net>
 <CAMou1-12ggxAuaPQ8VG7Gf5BZM6CVj6773HRB1QJXagB-okuGg@mail.gmail.com> <20141105123354.GR3337@twins.programming.kicks-ass.net>
From: Robert Bragg <robert@sixbynine.org>
Date: Thu, 6 Nov 2014 00:37:49 +0000
X-Google-Sender-Auth: D4gDC01yObh_dhOyrXXmhDBud2E
Message-ID: <CAMou1-0VQW-P=wPiOmWKXRJV9cqe2OR3yppYG9j0irKwnb78uw@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
To: Peter Zijlstra <peterz@infradead.org>
Cc: linux-kernel@vger.kernel.org, Paul Mackerras <paulus@samba.org>,
        Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Nov 5, 2014 at 12:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Nov 03, 2014 at 09:47:17PM +0000, Robert Bragg wrote:
>
>> > And do I take it right that if you're able/allowed/etc.. to open/have
>> > the fd to the GPU/DRM/DRI whatever context you have the right
>> > credentials to also observe these counters?
>>
>> Right and in particular since we want to allow OpenGL clients to be
>> able the profile their own gpu context with out any special privileges
>> my current pmu driver accepts a device file descriptor via config1 + a
>> context id via attr->config, both for checking credentials and
>> uniquely identifying which context should be profiled. (A single
>> client can open multiple contexts via one drm fd)
>
> Ah interesting. So we've got fd+context_id+event_id to identify any one
> number provided by the GPU.

Roughly.

The fd represents the device we're interested in.

Since a single application can manage multiple unique gpu contexts for
submitting work we have the context_id to identify which one in
particular we want to collect metrics for.

The event_id here though really represents a set of counters that are
written out together in a hardware specific report layout.

On Haswell there are 8 different report layouts that basically trade
off how many counters to include from 13 to 61 32bit counters plus 1
64bit timestamp. I exposed this format choice in the event
configuration. It's notable that all of the counter values written in
one report are captured atomically with respect to the gpu clock.

Within the reports most of the counters are hard-wired and they are
referred to as Aggregating counters, including things like:

* number of cycles the render engine was busy for
* number of cycles the gpu was active
* number of cycles the gpu was stalled
(i'll just gloss over what distinguishes each of these states)
* number of active cycles spent running a vertex shader
* number of stalled cycles spent running a vertex shader
* number of vertex shader threads spawned
* number of active cycles spent running a pixel shader
* number of stalled cycles spent running a pixel shader"
* number of pixel shader threads spawned
...

The values are aggregated across all of the gpu's execution units
(e.g. up to 40 units on Haswell)

Besides these aggregating counters the reports also include a gpu
clock counter which allows us to normalize these values into something
more intuitive for profiling.

There is a further small set of counters referred to as B counters in
the public prms that are also included in these reports and the
hardware has some configurability for these counters but given the
constrains on configuring them, the expectation would be to just allow
userspace to specify a enum for certain pre-defined configurations.
(E.g. a configuration that exposes a well defined set of B counters
useful for OpenGL profiling vs GPGPU profiling)

I had considered uniquely identifying each of the A counters with
separate perf event ids, but I think the main reasons I decided
against that in the end are:

Since they are written atomically the counters in a snapshot are all
related and the analysis to derive useful values for benchmarking
typically needs to refer to multiple counters in a single snapshot at
a time. E.g. to report the "Average cycles per vertex shader thread"
would need to measure the number of cycles spent running a vertex
shader / the number of vertex shader threads spawned. If we split the
counters up we'd then need to do work to correlate them again in
userspace.

My other concern was actually with memory bandwidth, considering that
it's possible to request the gpu to write out periodic snapshots at a
very high frequency (we can program a period as low as 160
nanoseconds) and pushing this to the limit (running as root +
overriding perf_event_max_sample_rate) can start to expose some
interesting details about how the gpu is working - though notable
observer effects too. I was expecting memory bandwidth to be the
limiting factor for what resolution we can achieve this way and
splitting the counters up looked like it would have quite a big
impact, due to the extra sample headers and that the gpu timestamp
would need to be repeated with each counter. e.g. in the most extreme
case, instead of 8byte header + 61 counters * 4 bytes + 8byte
timestamp every 160ns ~= 1.6GB/s, each counter would need to be paired
with a gpu timestamp + header so we could have 61 * (8 + 4 + 8)bytes
~= 7.6GB/s. To be fair though it's likely that if the counters were
split up we probably wouldn't often need a full set of 61 counters.

One last thing to mention here is that this first pmu driver that I
have written only relates to one very specific observation unit within
the gpu that happens to expose counters via reports/snapshots. There
are other interesting gpu counters I could imagine exposing through
separate pmu drivers too where the counters might simply be accessed
via mmio and for those cases I would imagine having a 1:1 mapping
between event-ids and counters.

>
>> That said though; when running as root it is not currently a
>> requirement to pass any fd when configuring an event to profile across
>> all gpu contexts. I'm just mentioning this because although I think it
>> should be ok for us to use an fd to determine credentials and help
>> specify a gpu context, an fd might not be necessary for system wide
>> profiling cases.
>
> Hmm, how does root know what context_id to provide? Are those exposed
> somewhere? Is there also a root context, one that encompasses all
> others?

No, it's just that the observation unit has two modes of operation;
either we can ask the unit to only aggregate counters for a specific
context_id or tell it to aggregate across all contexts.

>
>> >> Conceptually I suppose we want to be able to open an event that's not
>> >> associated with any cpu or process, but to keep things simple and fit
>> >> with perf's current design, the pmu I have a.t.m expects an event to be
>> >> opened for a specific cpu and unspecified process.
>> >
>> > There are no actual scheduling ramifications right? Let me ponder his
>> > for a little while more..
>>
>> Ok, I can't say I'm familiar enough with the core perf infrastructure
>> to entirely sure about this.
>
> Yeah, so I don't think so. Its on the device, nothing the CPU/scheduler
> does affects what the device does.
>
>> I recall looking at how some of the uncore perf drivers were working
>> and it looked like they had a similar issue where conceptually the pmu
>> doesn't belong to a specific cpu and so the id would internally get
>> mapped to some package state, shared by multiple cpus.
>
> Yeah, we could try and map these devices to a cpu on their node -- PCI
> devices are node local. But I'm not sure we need to start out by doing
> that.
>
>> My understanding had been that being associated with a specific cpu
>> did have the side effect that most of the pmu methods for that event
>> would then be invoked on that cpu through inter-process interrupts. At
>> one point that had seemed slightly problematic because there weren't
>> many places within my pmu driver where I could assume I was in process
>> context and could sleep. This was a problem with an earlier version
>> because the way I read registers had a slim chance of needing to sleep
>> waiting for the gpu to come out of RC6, but isn't a problem any more.
>
> Right, so I suppose we could make a new global context for these device
> like things and avoid some that song and dance. But we can do that
> later.

sure, at least for now it seems workable.

>
>> One thing that does come to mind here though is that I am overloading
>> pmu->read() as a mechanism for userspace to trigger a flush of all
>> counter snapshots currently in the gpu circular buffer to userspace as
>> perf events. Perhaps it would be best if that work (which might be
>> relatively costly at times) were done in the context of the process
>> issuing the flush(), instead of under an IPI (assuming that has some
>> effect on scheduler accounting).
>
> Right, so given you tell the GPU to periodically dump these stats (per
> context I presume), you can at a similar interval schedule whatever to
> flush this and update the relevant event->count values and have an NO-OP
> pmu::read() method.
>
> If the GPU provides interrupts to notify you of new data or whatnot, you
> can make that drive the thing.
>

Right, I'm already ensuring the events will be forwarded within a
finite time using a hrtimer, currently at 200Hz but there are also
times where userspace wants to pull at the driver too.

The use case here is supporting the INTEL_performance_query OpenGL
extension, where an application which can submit work to render on the
gpu and can also start and stop performance queries around specific
work and then ask for the results. Given how the queries are delimited
Mesa can determine when the work being queried has completed and at
that point the application can request the results of the query.

In this model Mesa will have configured a perf event to deliver
periodic counter snapshots, but it only really cares about snapshots
that fall between the start and end of a query. For this use case the
periodic snapshots are just to detect counters wrapping and so the
period will be relatively low at ~50milliseconds. At the end of a
query Mesa won't know whether there are any periodic snapshots that
fell between the start-end so it wants to explicitly flush at a point
where it knows any snapshots will be ready if there are any.

Alternatively I think I could arrange it so that Mesa relies on
knowing the driver will forward snapshots @ 200Hz and we could delay
informing the application that results are ready until we are certain
they must have been forwarded. I think the api could allow us to do
that (except for one awkward case where the application can demand a
synchronous response where we'd potentially have to sleep) My concern
here is having to rely on a fixed and relatively high frequency for
forwarding events which seems like it should be left as an
implementation detail that userspace shouldn't need to know.

I'm guessing it could also be good at some point for the hrtimer
frequency to relate to the buffer size + report sizes + timer
frequency instead of being fixed, but this could be difficult to
change if userspace needs to make assumptions about it, it could also
increase the time userspace would have to wait before it could be sure
outstanding snapshots have been received.

Hopefully that explains why I'm overloading read() like this currently.

Regards
- Robert
