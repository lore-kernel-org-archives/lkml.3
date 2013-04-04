Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1764272Ab3DDIMT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Apr 2013 04:12:19 -0400
Received: from mail-qa0-f53.google.com ([209.85.216.53]:47110 "EHLO
	mail-qa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1763487Ab3DDIMP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Apr 2013 04:12:15 -0400
MIME-Version: 1.0
In-Reply-To: <515C6D87.2060106@linaro.org>
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
	<CABPqkBS4TELhoUGrO+moca2fPUoqGjiYCdHJc=H8CjLomPWWDQ@mail.gmail.com>
	<1363291021.3100.144.camel@hornet>
	<51586315.7080006@gmail.com>
	<5159D221.70304@linaro.org>
	<515A0A3A.2040105@gmail.com>
	<CABPqkBStMd-VT8aoPhFV-rxiLOrH7h2HtS9O9FBkd+ggd5X+xQ@mail.gmail.com>
	<515C34BF.6060508@gmail.com>
	<CABPqkBS_z8zzSn=N_Q+AGbo1kV2EMOoF4dz2Aze=rPNB2n_n2g@mail.gmail.com>
	<515C393C.8030405@gmail.com>
	<CABPqkBQjur31gpPWTavjSP5nbc7u8mQwqsRRctYiHnPXz0d=_A@mail.gmail.com>
	<515C6D87.2060106@linaro.org>
Date: Thu, 4 Apr 2013 10:12:14 +0200
Message-ID: <CABPqkBRaCgb3Gp8_DT_S5rd9BcpTVeKgY2Ozk_yyAQP4W4SR1Q@mail.gmail.com>
Subject: Re: [RFC] perf: need to expose sched_clock to correlate user samples
 with kernel samples
From: Stephane Eranian <eranian@google.com>
To: John Stultz <john.stultz@linaro.org>
Cc: David Ahern <dsahern@gmail.com>, Pawel Moll <pawel.moll@arm.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        LKML <linux-kernel@vger.kernel.org>, "mingo@elte.hu" <mingo@elte.hu>,
        Paul Mackerras <paulus@samba.org>, Anton Blanchard <anton@samba.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "ak@linux.intel.com" <ak@linux.intel.com>,
        Pekka Enberg <penberg@gmail.com>, Steven Rostedt <rostedt@goodmis.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 3, 2013 at 7:57 PM, John Stultz <john.stultz@linaro.org> wrote:
> On 04/03/2013 07:22 AM, Stephane Eranian wrote:
>>
>> On Wed, Apr 3, 2013 at 4:14 PM, David Ahern <dsahern@gmail.com> wrote:
>>>
>>> On 4/3/13 8:00 AM, Stephane Eranian wrote:
>>>>>
>>>>> Why not have perf convert its
>>>>> perf_clock timestamps into monotonic or realtime when dumping events?
>
>
> So this is exactly what I've been wondering through all this.
>
> Perf can keep track of events using its own time domain (which is
> understandably required due to performance and locking issues), but when
> exporting those timestamps to userland, could it not do the same (likely
> imperfect) conversion to existing userland time domains (like
> CLOCK_MONOTONIC)?
>
>
>
>>>> Can monotonic timestamps be obtained from NMI context in the kernel?
>>>
>>>
>>> I don't understand the context of the question.
>>>
>>> I am not suggesting perf_clock be changed. I am working on correlating
>>> existing perf_clock timestamps to clocks typically used by apps (REALTIME
>>> and time-of-day but also applies to MONOTONIC).
>>>
>> But for that, you'd need to expose to users the correlation between
>> the two clocks.
>> And now you'd fixed two clock sources definitions not just one.
>
>
> I'm not sure I follow this. If perf exported data came with CLOCK_MONOTONIC
> timestamps, no correlation would need to be exposed.  perf would just have
> to do the extra overhead of doing the conversion on export.
>
There is no explicit export operation in perf.  You record a sample when
the counter overflows and generates an NMI interrupt. In the NMI interrupt
handler, the sample record is written to the sampling buffer. That is when
the timestamp is generated. The sampling buffer is directly accessible to
users via mmap(). The perf tool just dumps the raw sampling buffer into
a file, no sample record is modified or even looked at. The processing
of the samples is done offline (via perf report) and could be done on
another machine. In other words, the perf.data file is self-contained.

Are you suggesting that the perf tool or kernel could expose a constant
correlation factor between perf timestamp and MONOTONIC and that
this constant could be record by the perf tool in the perf.data file and
used later on by the perf report command?



>
>
>>> You are wanting the reverse -- have apps emit perf_clock timestamps. I
>>> was
>>> just wondering what is the advantage of this approach?
>>>
>> Well, that's how I interpreted your question ;-<
>>
>> If you could have perf_clock use monotonic then we would not have this
>> discussion.
>> The correlation would be trivial.
>
>
> I think the suggestion is not to have the perf_clock use CLOCK_MONOTONIC,
> but the perf interfaces export CLOCK_MONOTONIC.
>
> thanks
> -john
>
