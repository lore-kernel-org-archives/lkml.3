Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753525Ab3IWRLX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 13:11:23 -0400
Received: from mail-ie0-f172.google.com ([209.85.223.172]:32961 "EHLO
	mail-ie0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752393Ab3IWRLW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 13:11:22 -0400
MIME-Version: 1.0
Reply-To: eranian@gmail.com
In-Reply-To: <20130923153357.GB9326@twins.programming.kicks-ass.net>
References: <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
	<20130910133845.GB7537@gmail.com>
	<CAMsRxfJ5HG+0AiooOUFh8TzvCoK3YcBFpeAF0eTzdkDm=wB84g@mail.gmail.com>
	<20130910142942.GB8388@gmail.com>
	<CAMsRxf+18qz_vOkEZ1a8D9Z7BywWZPNB=qEn0bHXMFg96sALTQ@mail.gmail.com>
	<20130910171449.GA10812@gmail.com>
	<CAMsRxfKdpK7Mmt=BSPnGCGGERTFbqTG0qe_cFDTvxsdLCO-A9g@mail.gmail.com>
	<20130916154146.GA6470@gmail.com>
	<20130916162926.GA12926@twins.programming.kicks-ass.net>
	<CAMsRxfKyXnep+uAyJcjy0SKVQkA6M-QCogVYnq4+PrCtw8B20Q@mail.gmail.com>
	<20130923153357.GB9326@twins.programming.kicks-ass.net>
Date: Mon, 23 Sep 2013 19:11:21 +0200
Message-ID: <CAMsRxfJxbnoFFkwCc3geOb579UpSaVxLc-Cp7mQES250daci-A@mail.gmail.com>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was: Re:
 [GIT PULL] perf changes for v3.12)
From: Stephane Eranian <eranian@googlemail.com>
To: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 5:33 PM, Peter Zijlstra <peterz@infradead.org> wrote:
> On Mon, Sep 23, 2013 at 05:25:19PM +0200, Stephane Eranian wrote:
>> > Its not just a broken threshold. When a PEBS event happens it can re-arm
>> > itself but only if you program a RESET value !0. We don't do that, so
>> > each counter should only ever fire once.
>> >
>> > We must do this because PEBS is broken on NHM+ in that the
>> > pebs_record::status is a direct copy of the overflow status field at
>> > time of the assist and if you use the RESET thing nothing will clear the
>> > status bits and you cannot demux the PEBS events back to the event that
>> > generated them.
>> >
>> Trying to understand this problem better. You are saying that in case you
>> are sampling multiple PEBS events there is a problem if you allow more
>> than one record per PEBS buffer because the overflow status is not reset
>> properly.
>
> That is what I wrote; but I'm not entire sure that's correct. I think it
> will reset the overflow bits once it does an actual reset after the PEBS
> assist triggers, but see below.
>
>> For instance, if first record is caused by counter 0, ovfl_status=0x1,
>> then counter
>> is reset. Then, if counter 1 is the cause of the next record, then
>> that record has the
>> ovfl_status=0x3 instead of ovfl_status=0x2? Is that what you are saying?
>>
>> If so then yes, I agree this is a serious bug and we need to have Intel fix it.
>
> But there's still the case where with 2 counters you can get:
>
> cnt0 overflows; sets status |= 1 << 0, arms PEBS0 assist
> cnt1 overflows; sets status |= 1 << 1, arms PEBS1 assist
>
> PEBS0 ready to trigger
> PEBS1 ready to trigger
>
> Cnt1 event -> PEBS1 trigger, writes entry with status := 0x03
> Cnt0 event -> PEBS0 trigger, writes entry with status := 0x03
>
> At which point you'll have 2 events with the same status overflow bits
> in 'reverse' order.
>
Ok so what you are saying is that the ovfl_status is not maintained private
to each counter but shared among all PEBS counters by ucode. That's
how you end up leaking between counters like that.

But the other thing I remember is that if two PEBS events overflow
at the same time, PEBS only write one record with 2 bits set  in the
ovfl_status field. No point in creating two because the machine state
will be the same for both. The kernel would just need to dispatch the
same PEBS record to all the events that overflowed.

Now, your case appears like that, except this is not what happened.
So you're misled to believe both counter overflowed at the same time
when they did not in reality.

I'd like to have a test case where I could reproduce this.

> If we'd set RESET, the second entry would have status : 0x01, which
> would be unambiguous again. But we'd still not know where to place the
> 0x03 entry.
>
> With more PEBSn counters enabled and a threshold > 1 the chance of
> having such scenarios is greatly increased.
>
> The threshold := 1 case tries to avoid these cases by getting them out
> as fast as possible and hopefully avoiding the second trigger.

I understand. We need to verify that the HSW problem is not related to
have 2 events running: cycles:pp and cycles for the NMI watchdog.
What if both interrupt at the same time. Normally, I'd expect the PEBS
code to drain the buffer for the PEBS event and then the regular handler
for the NMI watchdog event. But obviously, this does not happen that
way. Will continue to investigate.
