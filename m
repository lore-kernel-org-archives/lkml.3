Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759398Ab3DAXMs (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 19:12:48 -0400
Received: from mail-da0-f46.google.com ([209.85.210.46]:50762 "EHLO
	mail-da0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757445Ab3DAXMq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 19:12:46 -0400
Message-ID: <515A1468.9080109@linaro.org>
Date: Mon, 01 Apr 2013 16:12:40 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130308 Thunderbird/17.0.4
MIME-Version: 1.0
To: David Ahern <dsahern@gmail.com>
CC: Pawel Moll <pawel.moll@arm.com>, Stephane Eranian <eranian@google.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>  <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>  <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>  <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>  <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>  <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>  <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com> <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com> <5159D221.70304@linaro.org> <515A0A3A.2040105@gmail.com>
In-Reply-To: <515A0A3A.2040105@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/01/2013 03:29 PM, David Ahern wrote:
> On 4/1/13 12:29 PM, John Stultz wrote:
>>> Any chance a decision can be reached in time for 3.10? Seems like the
>>> simplest option is the perf event based ioctl.
>>
>> I'm still not sold on the CLOCK_PERF posix clock. The semantics are
>> still too hand-wavy and implementation specific.
>>
>> While I'd prefer perf to export some existing semi-sane time domain
>> (using interpolation if necessary), I realize the hardware constraints
>> and performance optimizations make this unlikely (though I'm
>> disappointed I've not seen any attempt or proof point that it won't 
>> work).
>>
>> Thus if we must expose this kernel detail to userland, I think we should
>> be careful about how publicly we expose such an interface, as it has the
>> potential for misuse and eventual user-land breakage.
>
> But perf_clock timestamps are already exposed to userland. This new 
> API -- be it a posix clock or an ioctl -- just allows retrieval of a 
> timestamp outside of a generated event.

Although perf_clock timestamps are not exposed to applications in a way 
they can use for their own purposes, no? Just as timestamp data 
correlated with other perf data.

My big concern here is that if we applications can retrieve these 
timestamps for their own use,  folks will see CLOCK_PERF as a cheaper 
alternative to CLOCK_MONOTONIC, and then end up getting bitten when the 
CLOCK_PERF semantics change. So until someone will hammer out exactly 
the behavior CLOCK_PERF should have forever going forward, I'd rather 
not add it as a generic clockid.

If we're going to have to expose the perf timestamps to userland, then 
I'd prefer we do it in a less public way, where its clearly tied to the 
perf interface and not as a generic clockid. (And either the ioctl or 
dynamic posix clock id would be a way to go there).


>
>>
>> So while having a perf specific ioctl is still exposing what I expect
>> will be non-static kernel internal behavior to userland, it at least it
>> exposes it in a less generic fashion, which is preferable to me.
>>
>>
>>
>> The next point of conflict is likely if the ioctl method will be
>> sufficient given performance concerns. Something I'd be interested in
>> hearing about from the folks pushing this. Right now it seems any method
>> is preferable then not having an interface - but I want to make sure
>> that's really true.
>>
>> For example, if the ioctl interface is really too slow, its likely folks
>> will end up using periodic perf ioctl samples and interpolating using
>> normal vdso clock_gettime() timestamps.
>
> The performance/speed depends on how often is called. I have no idea 
> what Stephane's use case is but for me it is to correlate perf_clock 
> timestamps to timeofday. In my perf-based daemon that tracks process 
> schedulings, I update the correlation every 5-10 minutes.

So that sounds like the ioctl approach would have no penalty from a 
performance perspective.


>
>>
>> If that is acceptable, then why not invert the solution and just have
>> perf injecting periodic CLOCK_MONOTONIC timestamps into the log, then
>> have perf report fast, but less-accurate sched_clock deltas from that
>> CLOCK_MONOTONIC boundary.
>
> Something similar to that approach has been discussed as well. i.e, 
> add a realtime clock event and have it injected into the stream e.g.,
> https://lkml.org/lkml/2011/2/27/158
>
> But there are cons to this approach -- e.g, you need that first event 
> generated that tells you realtime to perf_clock correlation and you 
> don't want to have to scan an unknown length of events looking for the 
> first one to get the correlation only to backup and process the events.
>
> And an ioctl to generate that first event was shot down as well...
>   https://lkml.org/lkml/2011/3/1/174
>   https://lkml.org/lkml/2011/3/2/186

Hrm.

So from my quick read of that thread, what it seems Thomas is getting at 
there is having the periodic CLOCK_REALTIME injection isn't valuable 
without the tracepoints on timekeeping changes. But once those are 
there, the periodic timestamp injection would seemingly provide _most_ 
of what you need.

The missing bit is the desire to inject arbitrary timestamp "fences" 
into the log, which Peter and Thomas apparently don't like, but actually 
sounds useful to me.

But maybe there is a way to do this without adding an ioctl?

For instance, and this is just spitballing here, if you had a tracepoint 
for clock_gettime() which returned the clockid and value, you could 
create these fences just by requesting the time from userland. The VDSO 
clock_gettime() would avoid the syscall, so you'd have to actually call 
the syscall directly from userland. But this would have the added 
benefit of not slowing down normal userspace that doesn't want to cause 
these fences in the log.

I realize these half-baked "brainstorming" ideas are probably a bit 
unwelcome after you've spent quite a bit of time trying different 
approaches without any decisive resolution from maintainers. But maybe 
Thomas and Peter can chime in here and maybe help to clarify their 
objections?

thanks
-john

