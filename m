Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754166Ab3IJROy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Sep 2013 13:14:54 -0400
Received: from mail-bk0-f49.google.com ([209.85.214.49]:41086 "EHLO
	mail-bk0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752803Ab3IJROx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Sep 2013 13:14:53 -0400
Date: Tue, 10 Sep 2013 19:14:49 +0200
From: Ingo Molnar <mingo@kernel.org>
To: eranian@gmail.com
Cc: Peter Zijlstra <peterz@infradead.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Andi Kleen <andi@firstfloor.org>
Subject: Re: PEBS bug on HSW: "Unexpected number of pebs records 10" (was:
 Re: [GIT PULL] perf changes for v3.12)
Message-ID: <20130910171449.GA10812@gmail.com>
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
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAMsRxf+18qz_vOkEZ1a8D9Z7BywWZPNB=qEn0bHXMFg96sALTQ@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


* Stephane Eranian <eranian@googlemail.com> wrote:

> On Tue, Sep 10, 2013 at 7:29 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >
> > * Stephane Eranian <eranian@googlemail.com> wrote:
> >
> >> On Tue, Sep 10, 2013 at 6:38 AM, Ingo Molnar <mingo@kernel.org> wrote:
> >> >
> >> > * Stephane Eranian <eranian@googlemail.com> wrote:
> >> >
> >> >> Hi,
> >> >>
> >> >> Ok, so I am able to reproduce the problem using a simpler
> >> >> test case with a simple multithreaded program where
> >> >> #threads >> #CPUs.
> >> >
> >> > Does it go away if you use 'perf record --all-cpus'?
> >> >
> >> Haven't tried that yet.
> >>
> >> But I verified the DS pointers:
> >> init:
> >> CPU6 pebs base=ffff8808262de000 index=ffff8808262de000
> >> intr=ffff8808262de0c0 max=ffff8808262defc0
> >> crash:
> >> CPU6 pebs base=ffff8808262de000 index=ffff8808262de9c0
> >> intr=ffff8808262de0c0 max=ffff8808262defc0
> >>
> >> Neither the base nor the max are modified.
> >> The index simply goes beyond the threshold but that's not a bug.
> >> It is 12 after the threshold of 1, so total 13 is my new crash report.
> >>
> >> Two things to try:
> >> - measure only one thread/core
> >> - move the threshold a bit farther away (to get 2 or 3 entries)
> >>
> >> The threshold is where to generate the interrupt. It does not mean where
> >> to stop PEBS recording. So it is possible that in HSW, we may get into a
> >> situation where it takes time to get to the handler to stop the PMU. I
> >> don't know how given we use NMI. Well, unless we were already servicing
> >> an NMI at the time. But given that we stop the PMU almost immediately in
> >> the handler, I don't see how that would possible. The other oddity in
> >> HSW is that we clear the NMI on entry to the handler and not at the end.
> >> I never gotten an good explanation as to why that was necessary. So
> >> maybe it is related...
> >
> > Do you mean:
> >
> >         if (!x86_pmu.late_ack)
> >                 apic_write(APIC_LVTPC, APIC_DM_NMI);
> >
> > AFAICS that means the opposite: that we clear the NMI late, i.e. shortly
> > before return, after we've processed the PMU.
> >
> Yeah, the opposity, I got confused.
> 
> Let me try reverting that.
> Also curious about the influence of the LBR here.

You could exclude any LBR interaction by doing tests with "-e cycles:p".

Thanks,

	Ingo
