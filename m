Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933454Ab3BSSZ4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Feb 2013 13:25:56 -0500
Received: from mail-pb0-f46.google.com ([209.85.160.46]:55591 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933285Ab3BSSZz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Feb 2013 13:25:55 -0500
Message-ID: <5123C3AF.8060100@linaro.org>
Date: Tue, 19 Feb 2013 10:25:51 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130106 Thunderbird/17.0.2
MIME-Version: 1.0
To: Thomas Gleixner <tglx@linutronix.de>
CC: Stephane Eranian <eranian@google.com>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>,
        Robert Richter <robert.richter@amd.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
References: <CABPqkBQALeD=iO9x-N0nw+shhqa1kmUaj=sCvx+MvoAPGQ-y9A@mail.gmail.com> <1350408232.2336.42.camel@laptop> <1359728280.8360.15.camel@hornet> <CABPqkBSVeU_JP2KpVZLepKDJX=-g6A45Y5MoNphd6+DaU2PQzQ@mail.gmail.com> <51118797.9080800@linaro.org> <alpine.LFD.2.02.1302182132230.22263@ionos>
In-Reply-To: <alpine.LFD.2.02.1302182132230.22263@ionos>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 02/18/2013 12:35 PM, Thomas Gleixner wrote:
> On Tue, 5 Feb 2013, John Stultz wrote:
>> On 02/05/2013 02:13 PM, Stephane Eranian wrote:
>>> But if people are strongly opposed to the clock_gettime() approach, then
>>> I can go with the ioctl() because the functionality is definitively needed
>>> ASAP.
>> I prefer the ioctl method, since its less likely to be re-purposed/misused.
> Urgh. No! With a dedicated CLOCK_PERF we might have a decent chance to
> put this into a vsyscall. With an ioctl not so much.
>   
>> Though I'd be most comfortable with finding some way for perf-timestamps to be
>> CLOCK_MONOTONIC based (or maybe CLOCK_MONOTONIC_RAW if it would be easier),
>> and just avoid all together adding another time domain that doesn't really
>> have clear definition (other then "what perf uses").
> What's wrong with that. We already have the infrastructure to create
> dynamic time domains which can be completely disconnected from
> everything else.

Right, but those are for actual hardware domains that we had no other 
way of interacting with.


> Tracing/perf/instrumentation is a different domain and the main issue
> there is performance. So going for a vsyscall enabled clock_gettime()
> approach is definitely the best thing to do.

So describe how the perf time domain is different then CLOCK_MONOTONIC_RAW.


My concern here is that we're basically creating a kernel interface that 
exports implementation-defined semantics (again: whatever perf does 
right now). And I think folks want to do this, because adding CLOCK_PERF 
is easier then trying to:

1) Get a lock-free method for accessing CLOCK_MONOTONIC_RAW

2) Having perf interpolate its timestamps to CLOCK_MONOTONIC, or 
CLOCKMONOTONIC_RAW when it exports the data


The semantics on sched_clock() have been very flexible and hand-wavy in 
the past. And I agree with the need for the kernel to have a 
"fast-and-loose" clock as well as the benefits to that flexibility as 
the scheduler code has evolved.  But non-the-less, the changes in its 
semantics have bitten us badly a few times.

So I totally understand why the vsyscall is attractive. I'm just very 
cautious about exporting a similarly fuzzily defined interface to 
userland. So until its clear what the semantics will need to be going 
forward (forever!), my preference will be that we not add it.


thanks
-john

