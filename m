Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752897Ab3IWPeM (ORCPT <rfc822;w@1wt.eu>);
	Mon, 23 Sep 2013 11:34:12 -0400
Received: from merlin.infradead.org ([205.233.59.134]:53012 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752635Ab3IWPeK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 23 Sep 2013 11:34:10 -0400
Date: Mon, 23 Sep 2013 17:33:57 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: eranian@gmail.com
Cc: Ingo Molnar <mingo@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was:
 Re: [GIT PULL] perf changes for v3.12)
Message-ID: <20130923153357.GB9326@twins.programming.kicks-ass.net>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxfKyXnep+uAyJcjy0SKVQkA6M-QCogVYnq4+PrCtw8B20Q@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 23, 2013 at 05:25:19PM +0200, Stephane Eranian wrote:
> > Its not just a broken threshold. When a PEBS event happens it can re-arm
> > itself but only if you program a RESET value !0. We don't do that, so
> > each counter should only ever fire once.
> >
> > We must do this because PEBS is broken on NHM+ in that the
> > pebs_record::status is a direct copy of the overflow status field at
> > time of the assist and if you use the RESET thing nothing will clear the
> > status bits and you cannot demux the PEBS events back to the event that
> > generated them.
> >
> Trying to understand this problem better. You are saying that in case you
> are sampling multiple PEBS events there is a problem if you allow more
> than one record per PEBS buffer because the overflow status is not reset
> properly.

That is what I wrote; but I'm not entire sure that's correct. I think it
will reset the overflow bits once it does an actual reset after the PEBS
assist triggers, but see below.

> For instance, if first record is caused by counter 0, ovfl_status=0x1,
> then counter
> is reset. Then, if counter 1 is the cause of the next record, then
> that record has the
> ovfl_status=0x3 instead of ovfl_status=0x2? Is that what you are saying?
> 
> If so then yes, I agree this is a serious bug and we need to have Intel fix it.

But there's still the case where with 2 counters you can get:

cnt0 overflows; sets status |= 1 << 0, arms PEBS0 assist
cnt1 overflows; sets status |= 1 << 1, arms PEBS1 assist

PEBS0 ready to trigger
PEBS1 ready to trigger

Cnt1 event -> PEBS1 trigger, writes entry with status := 0x03
Cnt0 event -> PEBS0 trigger, writes entry with status := 0x03

At which point you'll have 2 events with the same status overflow bits
in 'reverse' order.

If we'd set RESET, the second entry would have status : 0x01, which
would be unambiguous again. But we'd still not know where to place the
0x03 entry.

With more PEBSn counters enabled and a threshold > 1 the chance of
having such scenarios is greatly increased.

The threshold := 1 case tries to avoid these cases by getting them out
as fast as possible and hopefully avoiding the second trigger.
