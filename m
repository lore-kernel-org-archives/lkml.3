Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932506Ab3IPLHK (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 07:07:10 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:50631 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932431Ab3IPLHH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 07:07:07 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20130910171449.GA10812@gmail.com>
References: <20130903132933.GA24955@gmail.com>
	<CA+55aFxBTjfx304zstOVq3Hm3vmjgC5gOJaxXG5E_iWq_WXGTw@mail.gmail.com>
	<20130909100544.GI31370@twins.programming.kicks-ass.net>
	<CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
	<20130910115306.GA6091@gmail.com>
	<CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
	<20130910133845.GB7537@gmail.com>
	<CAMsRxfJ5HG+0AiooOUFh8TzvCoK3YcBFpeAF0eTzdkDm=wB84g@mail.gmail.com>
	<20130910142942.GB8388@gmail.com>
	<CAMsRxf+18qz_vOkEZ1a8D9Z7BywWZPNB=qEn0bHXMFg96sALTQ@mail.gmail.com>
	<20130910171449.GA10812@gmail.com>
Date: Mon, 16 Sep 2013 13:07:06 +0200
Message-ID: <CAMsRxfKdpK7Mmt=BSPnGCGGERTFbqTG0qe_cFDTvxsdLCO-A9g@mail.gmail.com>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was: Re:
 [GIT PULL] perf changes for v3.12)
From: Stephane Eranian <eranian@googlemail.com>
To: Ingo Molnar <mingo@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

Some updates on this problem.
I have been running tests all week-end long on my HSW.
I can reproduce the problem. What I know:

- It is not linked with callchain
- The extra entries are valid
- The reset values are still zeroes
- The problem does not happen on SNB with the same test case
- The PMU state looks sane when that happens.
- The problem occurs even when restricting to one CPU/core (taskset -c 0-3)

So it seems like the threshold is ignored. But I don't understand where
there reset values are coming from. So it looks more like a bug in micro-code
where under certain circumstances multiple entries get written.

[132537.622177] Unexpected number of pebs records 5
[132537.622177] CPU0 base=ffff88023681a000 index=ffff88023681a000
intr=ffff88023681a0c0 max=ffff88023681afc0
[132537.622181] CPU0 0 p=ffff88023681a000 ovf=1 rip=c3830b
[132537.622182] CPU0 1 p=ffff88023681a0c0 ovf=1 rip=c3ab65
[132537.622183] CPU0 2 p=ffff88023681a180 ovf=1 rip=4f1b72
[132537.622184] CPU0 3 p=ffff88023681a240 ovf=1 rip=8dde78
[132537.622185] CPU0 4 p=ffff88023681a300 ovf=1 rip=4d24aa
[132537.622185] CPU0 0 reset=0
[132537.622186] CPU0 1 reset=0
[132537.622186] CPU0 2 reset=0
[132537.622187] CPU0 3 reset=0
[132537.622187] CPU0 4 reset=0
[132537.622188] CPU0 5 reset=0
[132537.622188] CPU0 6 reset=0
[132537.622189] CPU0 7 reset=0
[132537.622189]
[132537.622190] CPU#0: ctrl:       0000000000000000
[132537.622191] CPU#0: status:     0000000000000000
[132537.622191] CPU#0: overflow:   0000000000000000
[132537.622192] CPU#0: fixed:      00000000000000b0
[132537.622192] CPU#0: pebs:       0000000000000000
[132537.622193] CPU#0: active:     0000000200000001
[132537.622194] CPU#0:   gen-PMC0 ctrl:  0000000010c301c2
[132537.622194] CPU#0:   gen-PMC0 count: 0000fffffff214ea
[132537.622195] CPU#0:   gen-PMC0 left:  00000000000deb16
[132537.622196] CPU#0:   gen-PMC1 ctrl:  0000000000000000
[132537.622196] CPU#0:   gen-PMC1 count: 0000000000000000
[132537.622197] CPU#0:   gen-PMC1 left:  0000000000000000
[132537.622197] CPU#0:   gen-PMC2 ctrl:  0000000000000000
[132537.622198] CPU#0:   gen-PMC2 count: 0000000000000000
[132537.622198] CPU#0:   gen-PMC2 left:  0000000000000000
[132537.622199] CPU#0:   gen-PMC3 ctrl:  0000000000000000
[132537.622199] CPU#0:   gen-PMC3 count: 0000000000000000
[132537.622200] CPU#0:   gen-PMC3 left:  0000000000000000
[132537.622200] CPU#0: fixed-PMC0 count: 0000000000000000
[132537.622201] CPU#0: fixed-PMC1 count: 0000fff819c21c2c
[132537.622202] CPU#0: fixed-PMC2 count: 0000000000000000

Something must be happening with the interrupt or HT. I will disable
HT next and also disable the NMI watchdog.


On Tue, Sep 10, 2013 at 7:14 PM, Ingo Molnar <mingo@kernel.org> wrote:
>
> * Stephane Eranian <eranian@googlemail.com> wrote:
>
>> On Tue, Sep 10, 2013 at 7:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >
>> > * Stephane Eranian <eranian@googlemail.com> wrote:
>> >
>> >> On Tue, Sep 10, 2013 at 6:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
>> >> >
>> >> > * Stephane Eranian <eranian@googlemail.com> wrote:
>> >> >
>> >> >> Hi,
>> >> >>
>> >> >> Ok, so I am able to reproduce the problem using a simpler
>> >> >> test case with a simple multithreaded program where
>> >> >> #threads >> #CPUs.
>> >> >
>> >> > Does it go away if you use 'perf record --all-cpus'?
>> >> >
>> >> Haven't tried that yet.
>> >>
>> >> But I verified the DS pointers:
>> >> init:
>> >> CPU6 pebs base=ffff8808262de000 index=ffff8808262de000
>> >> intr=ffff8808262de0c0 max=ffff8808262defc0
>> >> crash:
>> >> CPU6 pebs base=ffff8808262de000 index=ffff8808262de9c0
>> >> intr=ffff8808262de0c0 max=ffff8808262defc0
>> >>
>> >> Neither the base nor the max are modified.
>> >> The index simply goes beyond the threshold but that's not a bug.
>> >> It is 12 after the threshold of 1, so total 13 is my new crash report.
>> >>
>> >> Two things to try:
>> >> - measure only one thread/core
>> >> - move the threshold a bit farther away (to get 2 or 3 entries)
>> >>
>> >> The threshold is where to generate the interrupt. It does not mean where
>> >> to stop PEBS recording. So it is possible that in HSW, we may get into a
>> >> situation where it takes time to get to the handler to stop the PMU. I
>> >> don't know how given we use NMI. Well, unless we were already servicing
>> >> an NMI at the time. But given that we stop the PMU almost immediately in
>> >> the handler, I don't see how that would possible. The other oddity in
>> >> HSW is that we clear the NMI on entry to the handler and not at the end.
>> >> I never gotten an good explanation as to why that was necessary. So
>> >> maybe it is related...
>> >
>> > Do you mean:
>> >
>> >         if (!x86_pmu.late_ack)
>> >                 apic_write(APIC_LVTPC, APIC_DM_NMI);
>> >
>> > AFAICS that means the opposite: that we clear the NMI late, i.e. shortly
>> > before return, after we've processed the PMU.
>> >
>> Yeah, the opposity, I got confused.
>>
>> Let me try reverting that.
>> Also curious about the influence of the LBR here.
>
> You could exclude any LBR interaction by doing tests with "-e cycles:p".
>
> Thanks,
>
>         Ingo
