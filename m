Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753563AbaKLXdz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 18:33:55 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:39647 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798AbaKLXdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 18:33:54 -0500
MIME-Version: 1.0
In-Reply-To: <20141110111329.GA19706@gmail.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <20141030190841.GI23531@worktop.programming.kicks-ass.net>
 <CAMou1-12ggxAuaPQ8VG7Gf5BZM6CVj6773HRB1QJXagB-okuGg@mail.gmail.com>
 <20141105123354.GR3337@twins.programming.kicks-ass.net> <CAMou1-0VQW-P=wPiOmWKXRJV9cqe2OR3yppYG9j0irKwnb78uw@mail.gmail.com>
 <20141110111329.GA19706@gmail.com>
From: Robert Bragg <robert@sixbynine.org>
Date: Wed, 12 Nov 2014 23:33:32 +0000
X-Google-Sender-Auth: VzKko8lpWThDAuRSWGX2zIZsX-M
Message-ID: <CAMou1-1NTyym0fzyT-QmOTMEW-Bu=vX8jLM83+=hGktqd1+Q+A@mail.gmail.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
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

On Mon, Nov 10, 2014 at 11:13 AM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Robert Bragg <robert@sixbynine.org> wrote:
>

<snip>

>> On Haswell there are 8 different report layouts that basically trade
>> off how many counters to include from 13 to 61 32bit counters plus 1
>> 64bit timestamp. I exposed this format choice in the event
>> configuration. It's notable that all of the counter values written in
>> one report are captured atomically with respect to the gpu clock.
>>
>> Within the reports most of the counters are hard-wired and they are
>> referred to as Aggregating counters, including things like:
>>
>> * number of cycles the render engine was busy for
>> * number of cycles the gpu was active
>> * number of cycles the gpu was stalled
>> (i'll just gloss over what distinguishes each of these states)
>> * number of active cycles spent running a vertex shader
>> * number of stalled cycles spent running a vertex shader
>> * number of vertex shader threads spawned
>> * number of active cycles spent running a pixel shader
>> * number of stalled cycles spent running a pixel shader"
>> * number of pixel shader threads spawned
>> ...
>
> Just curious:
>
> Beyond aggregated counts, do the GPU reports also allow sampling
> the PC of the vertex shader and pixel shader execution?
>
> That would allow effective annotated disassembly of them and
> bottleneck analysis - much like 'perf annotate' and how you can
> drill into annotated assembly code in 'perf report' and 'perf
> top'.

No, I'm afraid these particular counter reports from the OA unit can't
give us access to EU instruction pointers or other EU registers, even
considering the set of configurable counters that can be exposed
besides the aggregate counters. These OA counters are more-or-less
just boolean event counters.

Because your train of thought got me wondering though if it would be
possible to sample instruction pointers of EU threads periodically; I
spent a bit of time investigating how it could potentially be
implemented, out of curiosity. I found at least one possible approach,
but one thing that became apparent is that it wouldn't really be
possible to handle neatly from the kernel and would need tightly
coupled support from Mesa in userspace too...

Gen EUs have some support for exception handling where an exception
could be triggered periodically (not internally by the gpu, but rather
by the cpu) and the EUs made to run a given 'system routine' which
would be able to sample the instruction pointer of the interrupted
threads. One of the difficulties is that it wouldn't be possible for
the kernel to directly setup a system routine for profiling like this,
since the pointer for the routine is set via a STATE_SIP command that
requires a pointer relative to the 'instruction base pointer' which is
state that's really owned and setup by userspace drivers.

Incidentally our current driver stack doesn't currently utilise system
routines for anything and so at least something like this wouldn't
conflict with an existing feature. Some experiments were done with
system routines by Ben Widawsky some years ago now, with the aim of
using them for debugging as opposed to profiling, and that means he
has some code knocking around (intel-gpu-tools/debugger) that could
make it possible to put together an experiment for this.

For now I'd like to continue with enabling access to the OA counters
via perf if possible, since that's much lower hanging fruit but should
still allow a decent range of profiling tools.  If I get a chance
though, I'm tempted to see if I can use Ben's code as a basis to
experiment with this idea.

>
> Secondly, do you also have cache hit/miss counters (with sampling
> ability) for the various caches the GPU utilizes: such as the LLC
> it shares with the CPU, or GPU-specific caches (if any) such as
> the vertex cache? Most GPU shader performance problems relate to
> memory access patterns and the above aggregate counts only tell
> us the global picture.

Right, we can expose some of these via OA counter reports, through the
configurable counters. E.g. we can get a counter for the number of L3
cache read/write transactions via the LLC which can be converted into
a throughput. There are also other interesting counters relating to
the texture samplers for example, that are a common bottleneck.

My initial i915_oa driver doesn't look at exposing those yet since we
still need to work through an approval process for some of the
details. My first interest was to start with creating a driver to
expose the features and counters we already have published public docs
for, which in turn let me send out this RFC sooner rather than later.

>
> Thirdly, if taken branch instructions block/stall non-taken
> threads within an execution unit (like it happens on other vector
> CPUs) then being able to measure/sample current effective thread
> concurrency within an execution unit is generally useful as well,
> to be able to analyze this major class of GPU/GPGPU performance
> problems.

Right, Gen EUs try to co-issue instructions from multiple threads at
the same time, so long as they aren't contending for the same units.

I'm not currently sure of a way to get insight into this for Haswell,
but for Broadwell we gain some more aggregate EU counters (actually
some of them become customisable) and then it's possible to count the
issuing of instructions for some of the sub-units that allow
co-issuing.

>
>> The values are aggregated across all of the gpu's execution
>> units (e.g. up to 40 units on Haswell)
>>
>> Besides these aggregating counters the reports also include a
>> gpu clock counter which allows us to normalize these values
>> into something more intuitive for profiling.
>
> Modern GPUs can also change their clock frequency depending on
> load - is the GPU clock normalized by the hardware to a known
> fixed frequency, or does it change as the GPU's clock changes?

Sadly on Haswell, while these OA counters are enabled we need to
disable RC6 and also render trunk clock gating, so this obviously has
an impact on profiling that needs to be take into account.

On Broadwell I think we should be able to enable both though and in
that case the gpu will automatically write additional counter
snapshots when transitioning in and out of RC6 as well as when the
clock frequency changes.

<snip>

>
>> One last thing to mention here is that this first pmu driver
>> that I have written only relates to one very specific
>> observation unit within the gpu that happens to expose counters
>> via reports/snapshots. There are other interesting gpu counters
>> I could imagine exposing through separate pmu drivers too where
>> the counters might simply be accessed via mmio and for those
>> cases I would imagine having a 1:1 mapping between event-ids
>> and counters.
>
> I'd strong suggest thinking about sampling as well, if the
> hardware exposes sample information: at least for profiling CPU
> loads the difference is like day and night, compared to
> aggregated counts and self-profiling.

Here I was thinking of counters or data that can be sampled via mmio
using a hrtimer. E.g. the current gpu frequency or the energy usage.
I'm not currently aware of any capability for the gpu to say trigger
an interrupt after a threshold number of events occurs (like clock
cycles) so I think we may generally be limited to a wall clock time
domain for sampling.

As above, I'll also keep in mind, experimenting with being able to
sample EU IPs at some point too.

>
>> > [...]
>> >
>> > If the GPU provides interrupts to notify you of new data or
>> > whatnot, you can make that drive the thing.
>>
>> Right, I'm already ensuring the events will be forwarded within
>> a finite time using a hrtimer, currently at 200Hz but there are
>> also times where userspace wants to pull at the driver too.
>>
>> The use case here is supporting the INTEL_performance_query
>> OpenGL extension, where an application which can submit work to
>> render on the gpu and can also start and stop performance
>> queries around specific work and then ask for the results.
>> Given how the queries are delimited Mesa can determine when the
>> work being queried has completed and at that point the
>> application can request the results of the query.
>>
>> In this model Mesa will have configured a perf event to deliver
>> periodic counter snapshots, but it only really cares about
>> snapshots that fall between the start and end of a query. For
>> this use case the periodic snapshots are just to detect
>> counters wrapping and so the period will be relatively low at
>> ~50milliseconds. At the end of a query Mesa won't know whether
>> there are any periodic snapshots that fell between the
>> start-end so it wants to explicitly flush at a point where it
>> knows any snapshots will be ready if there are any.
>>
>> Alternatively I think I could arrange it so that Mesa relies on
>> knowing the driver will forward snapshots @ 200Hz and we could
>> delay informing the application that results are ready until we
>> are certain they must have been forwarded. I think the api
>> could allow us to do that (except for one awkward case where
>> the application can demand a synchronous response where we'd
>> potentially have to sleep) My concern here is having to rely on
>> a fixed and relatively high frequency for forwarding events
>> which seems like it should be left as an implementation detail
>> that userspace shouldn't need to know.
>
> It's a very good idea to not expose such limitations to
> user-space - the GPU driver doing the necessary hrtimer polling
> to construct a proper count is a much higher quality solution.

That sounds preferable.

I'm open to suggestions for finding another way for userspace to
initiate a flush besides through read() in case there's a concern that
might be set a bad precedent. For the i915_oa driver it seems ok at
the moment since we don't currently report a useful counter through
read() and for the main use case where we want the flushing we expect
that most of the time there won't be any significant cost involved in
flushing since we'll be using a very low timer period. Maybe this will
bite us later though.

>
> The last thing you want to ask yourself when seeing some weird
> profiling result is 'did user-space properly poll the PMU or did
> we overflow??'. Instrumentation needs to be rock solid dependable
> and fast, in that order.

That sounds like good advice.

Thanks,
- Robert
