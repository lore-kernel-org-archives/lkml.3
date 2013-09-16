Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641Ab3IPQ3o (ORCPT <rfc822;w@1wt.eu>);
	Mon, 16 Sep 2013 12:29:44 -0400
Received: from merlin.infradead.org ([205.233.59.134]:55401 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751002Ab3IPQ3n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 16 Sep 2013 12:29:43 -0400
Date: Mon, 16 Sep 2013 18:29:26 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: eranian@gmail.com, Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was:
 Re: [GIT PULL] perf changes for v3.12)
Message-ID: <20130916162926.GA12926@twins.programming.kicks-ass.net>
References: <CAMsRxfLEO15kKrbmtKKXuW-JTtCCgiuXS6wFs9kiLmG1wge24A@mail.gmail.com>
 <20130910115306.GA6091@gmail.com>
 <CAMsRxfLvbExOzjz8tQu7AchQgKBh5S4b7VMQmFtr1RxK4ksAvA@mail.gmail.com>
 <20130910133845.GB7537@gmail.com>
 <CAMsRxfJ5HG+0AiooOUFh8TzvCoK3YcBFpeAF0eTzdkDm=wB84g@mail.gmail.com>
 <20130910142942.GB8388@gmail.com>
 <CAMsRxf+18qz_vOkEZ1a8D9Z7BywWZPNB=qEn0bHXMFg96sALTQ@mail.gmail.com>
 <20130910171449.GA10812@gmail.com>
 <CAMsRxfKdpK7Mmt=BSPnGCGGERTFbqTG0qe_cFDTvxsdLCO-A9g@mail.gmail.com>
 <20130916154146.GA6470@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20130916154146.GA6470@gmail.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Sep 16, 2013 at 05:41:46PM +0200, Ingo Molnar wrote:
> 
> * Stephane Eranian <eranian@googlemail.com> wrote:
> 
> > Hi,
> > 
> > Some updates on this problem.
> > I have been running tests all week-end long on my HSW.
> > I can reproduce the problem. What I know:
> > 
> > - It is not linked with callchain
> > - The extra entries are valid
> > - The reset values are still zeroes
> > - The problem does not happen on SNB with the same test case
> > - The PMU state looks sane when that happens.
> > - The problem occurs even when restricting to one CPU/core (taskset -c 0-3)
> > 
> > So it seems like the threshold is ignored. But I don't understand where 
> > there reset values are coming from. So it looks more like a bug in 
> > micro-code where under certain circumstances multiple entries get 
> > written.
> 
> Either multiple entries are written, or the PMI/NMI is not asserted as it 
> should be?

No, both :-)

> > Something must be happening with the interrupt or HT. I will disable HT 
> > next and also disable the NMI watchdog.
> 
> Yes, interaction with the NMI watchdog events might also be possible.
> 
> If it's truly just the threshold that is broken occasionally in a 
> statistically insignificant manner then the bug is relatively benign and 
> we could work it around in the kernel by ignoring excess entries.
> 
> In that case we should probably not annoy users with the scary kernel 
> warning and instead increase a debug count somewhere so that it's still 
> detectable.

Its not just a broken threshold. When a PEBS event happens it can re-arm
itself but only if you program a RESET value !0. We don't do that, so
each counter should only ever fire once.

We must do this because PEBS is broken on NHM+ in that the
pebs_record::status is a direct copy of the overflow status field at
time of the assist and if you use the RESET thing nothing will clear the
status bits and you cannot demux the PEBS events back to the event that
generated them.

Worse, since its the overflow that arms the assist, and the assist
happens at some undefined amount of cycles after this event it is
possible for another assist to happen first.

That is, suppose both CNT0 and CNT1 have PEBS enabled and CNT0 overflows
first it is possible to find the CNT1 entry first in the buffer with
both of them having status := 0x03.

Complete and utter trainwreck.

This is why we have a threshold of 1 and use NMI for PMI even for pure
PEBS, it minimizes the complete clusterfuck described above.

