Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752002Ab3IQHAy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Sep 2013 03:00:54 -0400
Received: from mail-ee0-f53.google.com ([74.125.83.53]:61326 "EHLO
	mail-ee0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751338Ab3IQHAw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Sep 2013 03:00:52 -0400
Date: Tue, 17 Sep 2013 09:00:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Peter Zijlstra <peterz@infradead.org>
Cc: eranian@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was:
 Re: [GIT PULL] perf changes for v3.12)
Message-ID: <20130917070048.GB20661@gmail.com>
References: <20130910115306.GA6091@gmail.com>
 <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
 <20130910133845.GB7537@gmail.com>
 <CAMsRxfJ5HG+0AiooOUFh8TzvCoK3YcBFpeAF0eTzdkDm=wB84g@mail.gmail.com>
 <20130910142942.GB8388@gmail.com>
 <CAMsRxf+18qz_vOkEZ1a8D9Z7BywWZPNB=qEn0bHXMFg96sALTQ@mail.gmail.com>
 <20130910171449.GA10812@gmail.com>
 <CAMsRxfKdpK7Mmt=BSPnGCGGERTFbqTG0qe_cFDTvxsdLCO-A9g@mail.gmail.com>
 <20130916154146.GA6470@gmail.com>
 <20130916162926.GA12926@twins.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916162926.GA12926@twins.programming.kicks-ass.net>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Peter Zijlstra <peterz@infradead.org> wrote:

> On Mon, Sep 16, 2013 at 05:41:46PM +0200, Ingo Molnar wrote:
> > 
> > * Stephane Eranian <eranian@googlemail.com> wrote:
> > 
> > > Hi,
> > > 
> > > Some updates on this problem.
> > > I have been running tests all week-end long on my HSW.
> > > I can reproduce the problem. What I know:
> > > 
> > > - It is not linked with callchain
> > > - The extra entries are valid
> > > - The reset values are still zeroes
> > > - The problem does not happen on SNB with the same test case
> > > - The PMU state looks sane when that happens.
> > > - The problem occurs even when restricting to one CPU/core (taskset -c 0-3)
> > > 
> > > So it seems like the threshold is ignored. But I don't understand where 
> > > there reset values are coming from. So it looks more like a bug in 
> > > micro-code where under certain circumstances multiple entries get 
> > > written.
> > 
> > Either multiple entries are written, or the PMI/NMI is not asserted as it 
> > should be?
> 
> No, both :-)
> 
> > > Something must be happening with the interrupt or HT. I will disable HT 
> > > next and also disable the NMI watchdog.
> > 
> > Yes, interaction with the NMI watchdog events might also be possible.
> > 
> > If it's truly just the threshold that is broken occasionally in a 
> > statistically insignificant manner then the bug is relatively benign and 
> > we could work it around in the kernel by ignoring excess entries.
> > 
> > In that case we should probably not annoy users with the scary kernel 
> > warning and instead increase a debug count somewhere so that it's still 
> > detectable.
> 
> Its not just a broken threshold. When a PEBS event happens it can re-arm 
> itself but only if you program a RESET value !0. We don't do that, so 
> each counter should only ever fire once.
> 
> We must do this because PEBS is broken on NHM+ in that the 
> pebs_record::status is a direct copy of the overflow status field at 
> time of the assist and if you use the RESET thing nothing will clear the 
> status bits and you cannot demux the PEBS events back to the event that 
> generated them.
> 
> Worse, since its the overflow that arms the assist, and the assist 
> happens at some undefined amount of cycles after this event it is 
> possible for another assist to happen first.
> 
> That is, suppose both CNT0 and CNT1 have PEBS enabled and CNT0 overflows 
> first it is possible to find the CNT1 entry first in the buffer with 
> both of them having status := 0x03.
> 
> Complete and utter trainwreck.
> 
> This is why we have a threshold of 1 and use NMI for PMI even for pure 
> PEBS, it minimizes the complete clusterfuck described above.

What I mean that as per observations the problem seems to be statistical: 
it happens only once every couple of million records. So, as long as no 
memory is corrupted (the PEBS records don't go outside the DS area) it 
could be ignored when it happens, and still produce a valid, usable 
profile.

( Btw., we might want to introduce a 'error' event passed to tools, which 
  event they could process in a soft, statistical manner: only warn the 
  user if the erroneous events go beyond 1% or 5%, etc. Kernel warnings 
  are really not the best fit for such purposes. )

Thanks,

	Ingo
