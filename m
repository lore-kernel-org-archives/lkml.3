Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755032Ab3BWGEi (ORCPT <rfc822;w@1wt.eu>);
	Sat, 23 Feb 2013 01:04:38 -0500
Received: from mail-da0-f48.google.com ([209.85.210.48]:62551 "EHLO
	mail-da0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754870Ab3BWGEh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 23 Feb 2013 01:04:37 -0500
Message-ID: <51285BF1.2090208@linaro.org>
Date: Fri, 22 Feb 2013 22:04:33 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Peter Zijlstra <peterz@infradead.org>
CC: Thomas Gleixner <tglx@linutronix.de>,
        Stephane Eranian <eranian@google.com>, Pawel Moll <pawel.moll@arm.com>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>  <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet>  <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>  <51118797.9080800@linaro.org> <alpine.LFD.2.02.1302182132230.22263@ionos>  <5123C3AF.8060100@linaro.org> <1361356160.10155.22.camel@laptop>
In-Reply-To: <1361356160.10155.22.camel@laptop>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/20/2013 02:29 AM, Peter Zijlstra wrote:
> On Tue, 2013-02-19 at 10:25 -0800, John Stultz wrote:
>> So describe how the perf time domain is different then
>> CLOCK_MONOTONIC_RAW.
> The primary difference is that the trace/sched/perf time domain is not
> strictly monotonic, it is only locally monotonic -- that is two time
> stamps taken on the same cpu are guaranteed to be monotonic.

So how would a clock_gettime(CLOCK_PERF,...) interface help you figure 
out which cpu you got your timestamp from?


> Furthermore, to make it useful, there's an actual bound on the inter-cpu
> drift (implemented by limiting the drift to CLOCK_MONOTONIC).

So this sounds like you're already sort of interpolating to 
CLOCK_MONOTONIC, or am I just misunderstanding you?

> Additionally -- to increase use -- we also added a monotonic sync point
> when cpu A queries time of cpu B.

Not sure I'm following this bit. But I'll have to go look at the code on 
Monday.

>
>> My concern here is that we're basically creating a kernel interface
>> that
>> exports implementation-defined semantics (again: whatever perf does
>> right now). And I think folks want to do this, because adding
>> CLOCK_PERF
>> is easier then trying to:
>>
>> 1) Get a lock-free method for accessing CLOCK_MONOTONIC_RAW
>>
>> 2) Having perf interpolate its timestamps to CLOCK_MONOTONIC, or
>> CLOCKMONOTONIC_RAW when it exports the data
> Mostly cheaper, not easier. Given unstable TSC, MONOTONIC will have to
> fall back to another clock source (hpet, acpi_pm and other assorted
> crap).
>
> In order to avoid this, we'd had to relax the requirements. Using
> anything other than TSC is simply not an option.

Right, and this I understand. We can can play a little fast and lose 
with the rules for in-kernel uses, given the variety of hardware and the 
fact that performance is more critical then perfect accuracy. Since 
we're in-kernel we also have more information then userland does about 
what cpu we're running on, so we can get away with only 
locally-monotonic timestamps.

But I want to be careful if we're exporting this out to userland that 
its both useful and that there's an actual specification for how 
CLOCK_PERF behaves, applications can rely upon not changing in the future.

thanks
-john


