Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758934Ab3DAS35 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Apr 2013 14:29:57 -0400
Received: from mail-pd0-f175.google.com ([209.85.192.175]:42692 "EHLO
	mail-pd0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757250Ab3DAS34 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Apr 2013 14:29:56 -0400
X-Greylist: delayed 3442 seconds by postgrey-1.27 at vger.kernel.org; Mon, 01 Apr 2013 14:29:56 EDT
Message-ID: <5159D221.70304@linaro.org>
Date: Mon, 01 Apr 2013 11:29:53 -0700
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
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com>  <1350408232.2336.42.camel@laptop>	<1359728280.8360.15.camel@hornet>  <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com>  <51118797.9080800@linaro.org>	<alpine.LFD.2.02.1302182132230.22263@ionos>  <5123C3AF.8060100@linaro.org>	<1361356160.10155.22.camel@laptop>  <51285BF1.2090208@linaro.org>	<1361801441.4007.40.camel@laptop>  <CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com> <1363291021.3100.144.camel@hornet> <51586315.7080006@gmail.com>
In-Reply-To: <51586315.7080006@gmail.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2013 09:23 AM, David Ahern wrote:
> On 3/14/13 1:57 PM, Pawel Moll wrote:
>> Ok, how about the code below? I must say I have some doubts about the
>> resolution, as there seem to be no generic way of figuring it out for
>> the sched_clock (the arch/arm/kernel/sched_clock.c is actually
>> calculating it, but than just prints it out and nothing more).
>>
>> And, to summarize, we went through 3 ideas:
>>
>> 1. ioctl() - http://article.gmane.org/gmane.linux.kernel/1433933
>> 2. syscall - http://article.gmane.org/gmane.linux.kernel/1437057
>> 3. POSIX clock - below
>>
>> John also suggested that maybe the perf could use CLOCK_MONOTONIC_RAW
>> instead of local/sched_clock().
>
> Any chance a decision can be reached in time for 3.10? Seems like the 
> simplest option is the perf event based ioctl.

I'm still not sold on the CLOCK_PERF posix clock. The semantics are 
still too hand-wavy and implementation specific.

While I'd prefer perf to export some existing semi-sane time domain 
(using interpolation if necessary), I realize the hardware constraints 
and performance optimizations make this unlikely (though I'm 
disappointed I've not seen any attempt or proof point that it won't work).

Thus if we must expose this kernel detail to userland, I think we should 
be careful about how publicly we expose such an interface, as it has the 
potential for misuse and eventual user-land breakage.

So while having a perf specific ioctl is still exposing what I expect 
will be non-static kernel internal behavior to userland, it at least it 
exposes it in a less generic fashion, which is preferable to me.



The next point of conflict is likely if the ioctl method will be 
sufficient given performance concerns. Something I'd be interested in 
hearing about from the folks pushing this. Right now it seems any method 
is preferable then not having an interface - but I want to make sure 
that's really true.

For example, if the ioctl interface is really too slow, its likely folks 
will end up using periodic perf ioctl samples and interpolating using 
normal vdso clock_gettime() timestamps.

If that is acceptable, then why not invert the solution and just have 
perf injecting periodic CLOCK_MONOTONIC timestamps into the log, then 
have perf report fast, but less-accurate sched_clock deltas from that 
CLOCK_MONOTONIC boundary.

Another alternative that might be a reasonable compromise: have perf 
register a dynamic posix clock id, which would be a driver specific, 
less public interface. That would provide the initial method to access 
the perf time domain. Then when it came time to optimize further, 
someone would have to sort out the difficulties of creating a vdso 
method for accessing dynamic posix clocks. It wouldn't be easy, but it 
wouldn't be impossible to do.


> Converting/correlating perf_clock timestamps to time-of-day is a 
> feature I have been trying to get into perf for over 2 years. This is 
> a big piece needed for that goal -- along with the xtime tracepoints:
>   https://lkml.org/lkml/2013/3/19/433

I sympathize with how long this process can take.  Having maintainers 
disagree without resolution can be a tar-pit. That said, its only been a 
few months where this has had proper visibility, and the discussion has 
paused for months at a time. Despite how long and slow this probably 
feels, the idea of maintaining a bad interface for the next decade seems 
much longer. ;)  So don't get discouraged yet.

thanks
-john
