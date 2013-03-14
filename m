Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758085Ab3CNPeG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 11:34:06 -0400
Received: from mail-qe0-f47.google.com ([209.85.128.47]:62735 "EHLO
	mail-qe0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757968Ab3CNPeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 11:34:04 -0400
MIME-Version: 1.0
In-Reply-To: <1361801441.4007.40.camel@laptop>
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>
	<1350408232.2336.42.camel@laptop>
	<1359728280.8360.15.camel@hornet>
	<CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>
	<51118797.9080800@linaro.org>
	<alpine.LFD.2.02.1302182132230.22263@ionos>
	<5123C3AF.8060100@linaro.org>
	<1361356160.10155.22.camel@laptop>
	<51285BF1.2090208@linaro.org>
	<1361801441.4007.40.camel@laptop>
Date: Thu, 14 Mar 2013 16:34:02 +0100
Message-ID: <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
From: Stephane Eranian <eranian@google.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: John Stultz <john.stultz@linaro.org>, Thomas Gleixner <tglx@linutronix.de>,
        Pawel Moll <pawel.moll@arm.com>, LKML <linux-kernel@vger.kernel.org>,
        "mingo@elte.hu" <mingo@elte.hu>, Paul Mackerras <paulus@samba.org>,
        Anton Blanchard <anton@samba.org>, Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Feb 25, 2013 at 3:10 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Fri, 2013-02-22 at 22:04 -0800, John Stultz wrote:
>> On 02/20/2013 02:29 AM, Peter Zijlstra wrote:
>> > On Tue, 2013-02-19 at 10:25 -0800, John Stultz wrote:
>> >> So describe how the perf time domain is different then
>> >> CLOCK_MONOTONIC_RAW.
>> > The primary difference is that the trace/sched/perf time domain is not
>> > strictly monotonic, it is only locally monotonic -- that is two time
>> > stamps taken on the same cpu are guaranteed to be monotonic.
>>
>> So how would a clock_gettime(CLOCK_PERF,...) interface help you figure
>> out which cpu you got your timestamp from?
>
> I'm not sure we want to expose it that far.. The reason people want
> this clock exposed is to be able to do logging on the same time-line so
> we can correlate events from both sources (kernel and user-space).
>
> In case of parallel execution we cannot guarantee order and reading
> logs/reconstructing events things require a bit of human intelligence.
>
>> > Furthermore, to make it useful, there's an actual bound on the inter-cpu
>> > drift (implemented by limiting the drift to CLOCK_MONOTONIC).
>>
>> So this sounds like you're already sort of interpolating to
>> CLOCK_MONOTONIC, or am I just misunderstanding you?
>
> That's right, although there's modes where the TSC is guaranteed stable
> where we don't do this (it avoids some expensive bits), so we can not
> rely on this.
>
>> > Additionally -- to increase use -- we also added a monotonic sync point
>> > when cpu A queries time of cpu B.
>>
>> Not sure I'm following this bit. But I'll have to go look at the code
>> on Monday.
>
> It will basically pull the 'slowest' cpu forward so that for that
> 'event' we can say the two time-lines have a common point.
>
>> Right, and this I understand. We can can play a little fast and lose
>> with the rules for in-kernel uses, given the variety of hardware and the
>> fact that performance is more critical then perfect accuracy. Since
>> we're in-kernel we also have more information then userland does about
>> what cpu we're running on, so we can get away with only
>> locally-monotonic timestamps.
>>
>> But I want to be careful if we're exporting this out to userland that
>> its both useful and that there's an actual specification for how
>> CLOCK_PERF behaves, applications can rely upon not changing in the future.
>
> Well, the timestamps themselves are already exposed to userspace
> through the ftrace and perf data logs. All people want is to add
> secondary data stream in the same time-line.
>
I agree with Peter on this. The timestamps are already visible.
All we need is the ability to generate them for another user-level
level data stream.
