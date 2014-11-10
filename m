Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752665AbaKJLNh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 06:13:37 -0500
Received: from mail-wi0-f176.google.com ([209.85.212.176]:64820 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751837AbaKJLNe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 06:13:34 -0500
Date: Mon, 10 Nov 2014 12:13:29 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Robert Bragg <robert@sixbynine.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Daniel Vetter <daniel.vetter@ffwll.ch>,
        Chris Wilson <chris@chris-wilson.co.uk>,
        Rob Clark <robdclark@gmail.com>,
        Samuel Pitoiset <samuel.pitoiset@gmail.com>,
        Ben Skeggs <bskeggs@redhat.com>
Subject: Re: [RFC PATCH 0/3] Expose gpu counters via perf pmu driver
Message-ID: <20141110111329.GA19706@gmail.com>
References: <1413991731-20628-1-git-send-email-robert@sixbynine.org>
 <20141030190841.GI23531@worktop.programming.kicks-ass.net>
 <CAMou1-12ggxAuaPQ8VG7Gf5BZM6CVj6773HRB1QJXagB-okuGg@mail.gmail.com>
 <20141105123354.GR3337@twins.programming.kicks-ass.net>
 <CAMou1-0VQW-P=wPiOmWKXRJV9cqe2OR3yppYG9j0irKwnb78uw@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMou1-0VQW-P=wPiOmWKXRJV9cqe2OR3yppYG9j0irKwnb78uw@mail.gmail.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Robert Bragg <robert@sixbynine.org> wrote:

> On Wed, Nov 5, 2014 at 12:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> > On Mon, Nov 03, 2014 at 09:47:17PM +0000, Robert Bragg wrote:
> >
> >> > And do I take it right that if you're able/allowed/etc.. to open/have
> >> > the fd to the GPU/DRM/DRI whatever context you have the right
> >> > credentials to also observe these counters?
> >>
> >> Right and in particular since we want to allow OpenGL clients to be
> >> able the profile their own gpu context with out any special privileges
> >> my current pmu driver accepts a device file descriptor via config1 + a
> >> context id via attr->config, both for checking credentials and
> >> uniquely identifying which context should be profiled. (A single
> >> client can open multiple contexts via one drm fd)
> >
> > Ah interesting. So we've got fd+context_id+event_id to identify any one
> > number provided by the GPU.
> 
> Roughly.
> 
> The fd represents the device we're interested in.
> 
> Since a single application can manage multiple unique gpu contexts for
> submitting work we have the context_id to identify which one in
> particular we want to collect metrics for.
> 
> The event_id here though really represents a set of counters that are
> written out together in a hardware specific report layout.
> 
> On Haswell there are 8 different report layouts that basically trade
> off how many counters to include from 13 to 61 32bit counters plus 1
> 64bit timestamp. I exposed this format choice in the event
> configuration. It's notable that all of the counter values written in
> one report are captured atomically with respect to the gpu clock.
> 
> Within the reports most of the counters are hard-wired and they are
> referred to as Aggregating counters, including things like:
> 
> * number of cycles the render engine was busy for
> * number of cycles the gpu was active
> * number of cycles the gpu was stalled
> (i'll just gloss over what distinguishes each of these states)
> * number of active cycles spent running a vertex shader
> * number of stalled cycles spent running a vertex shader
> * number of vertex shader threads spawned
> * number of active cycles spent running a pixel shader
> * number of stalled cycles spent running a pixel shader"
> * number of pixel shader threads spawned
> ...

Just curious:

Beyond aggregated counts, do the GPU reports also allow sampling 
the PC of the vertex shader and pixel shader execution?

That would allow effective annotated disassembly of them and 
bottleneck analysis - much like 'perf annotate' and how you can 
drill into annotated assembly code in 'perf report' and 'perf 
top'.

Secondly, do you also have cache hit/miss counters (with sampling 
ability) for the various caches the GPU utilizes: such as the LLC 
it shares with the CPU, or GPU-specific caches (if any) such as 
the vertex cache? Most GPU shader performance problems relate to 
memory access patterns and the above aggregate counts only tell 
us the global picture.

Thirdly, if taken branch instructions block/stall non-taken 
threads within an execution unit (like it happens on other vector 
CPUs) then being able to measure/sample current effective thread 
concurrency within an execution unit is generally useful as well, 
to be able to analyze this major class of GPU/GPGPU performance 
problems.

> The values are aggregated across all of the gpu's execution 
> units (e.g. up to 40 units on Haswell)
> 
> Besides these aggregating counters the reports also include a 
> gpu clock counter which allows us to normalize these values 
> into something more intuitive for profiling.

Modern GPUs can also change their clock frequency depending on 
load - is the GPU clock normalized by the hardware to a known 
fixed frequency, or does it change as the GPU's clock changes?

> [...]
> 
> I had considered uniquely identifying each of the A counters 
> with separate perf event ids, but I think the main reasons I 
> decided against that in the end are:
> 
> Since they are written atomically the counters in a snapshot 
> are all related and the analysis to derive useful values for 
> benchmarking typically needs to refer to multiple counters in a 
> single snapshot at a time. E.g. to report the "Average cycles 
> per vertex shader thread" would need to measure the number of 
> cycles spent running a vertex shader / the number of vertex 
> shader threads spawned. If we split the counters up we'd then 
> need to do work to correlate them again in userspace.
> 
> My other concern was actually with memory bandwidth, 
> considering that it's possible to request the gpu to write out 
> periodic snapshots at a very high frequency (we can program a 
> period as low as 160 nanoseconds) and pushing this to the limit 
> (running as root + overriding perf_event_max_sample_rate) can 
> start to expose some interesting details about how the gpu is 
> working - though notable observer effects too. I was expecting 
> memory bandwidth to be the limiting factor for what resolution 
> we can achieve this way and splitting the counters up looked 
> like it would have quite a big impact, due to the extra sample 
> headers and that the gpu timestamp would need to be repeated 
> with each counter. e.g. in the most extreme case, instead of 
> 8byte header + 61 counters * 4 bytes + 8byte timestamp every 
> 160ns ~= 1.6GB/s, each counter would need to be paired with a 
> gpu timestamp + header so we could have 61 * (8 + 4 + 8)bytes 
> ~= 7.6GB/s. To be fair though it's likely that if the counters 
> were split up we probably wouldn't often need a full set of 61 
> counters.

If you really want to collect such high frequency data then you 
are probably right in trying to compress the report format as 
much as possible.

> One last thing to mention here is that this first pmu driver 
> that I have written only relates to one very specific 
> observation unit within the gpu that happens to expose counters 
> via reports/snapshots. There are other interesting gpu counters 
> I could imagine exposing through separate pmu drivers too where 
> the counters might simply be accessed via mmio and for those 
> cases I would imagine having a 1:1 mapping between event-ids 
> and counters.

I'd strong suggest thinking about sampling as well, if the 
hardware exposes sample information: at least for profiling CPU 
loads the difference is like day and night, compared to 
aggregated counts and self-profiling.

> > [...]
> >
> > If the GPU provides interrupts to notify you of new data or 
> > whatnot, you can make that drive the thing.
> 
> Right, I'm already ensuring the events will be forwarded within 
> a finite time using a hrtimer, currently at 200Hz but there are 
> also times where userspace wants to pull at the driver too.
> 
> The use case here is supporting the INTEL_performance_query 
> OpenGL extension, where an application which can submit work to 
> render on the gpu and can also start and stop performance 
> queries around specific work and then ask for the results. 
> Given how the queries are delimited Mesa can determine when the 
> work being queried has completed and at that point the 
> application can request the results of the query.
> 
> In this model Mesa will have configured a perf event to deliver 
> periodic counter snapshots, but it only really cares about 
> snapshots that fall between the start and end of a query. For 
> this use case the periodic snapshots are just to detect 
> counters wrapping and so the period will be relatively low at 
> ~50milliseconds. At the end of a query Mesa won't know whether 
> there are any periodic snapshots that fell between the 
> start-end so it wants to explicitly flush at a point where it 
> knows any snapshots will be ready if there are any.
> 
> Alternatively I think I could arrange it so that Mesa relies on 
> knowing the driver will forward snapshots @ 200Hz and we could 
> delay informing the application that results are ready until we 
> are certain they must have been forwarded. I think the api 
> could allow us to do that (except for one awkward case where 
> the application can demand a synchronous response where we'd 
> potentially have to sleep) My concern here is having to rely on 
> a fixed and relatively high frequency for forwarding events 
> which seems like it should be left as an implementation detail 
> that userspace shouldn't need to know.

It's a very good idea to not expose such limitations to 
user-space - the GPU driver doing the necessary hrtimer polling 
to construct a proper count is a much higher quality solution.

The last thing you want to ask yourself when seeing some weird 
profiling result is 'did user-space properly poll the PMU or did 
we overflow??'. Instrumentation needs to be rock solid dependable 
and fast, in that order.

Thanks,

	Ingo
