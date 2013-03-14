Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753256Ab3CNWKD (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 18:10:03 -0400
Received: from mail-qc0-f178.google.com ([209.85.216.178]:52843 "EHLO
	mail-qc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753140Ab3CNWKA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 18:10:00 -0400
MIME-Version: 1.0
In-Reply-To: <CA+55aFziwaP21NVyVb_UP3okiX7fXoo4DQ7zudhxAwPM10_Tuw@mail.gmail.com>
References: <20130226070247.GA14094@gmail.com>
	<CA+55aFxdR6_8734T9y2Edyotf0u-SgPPgjazFuQa1atSUGK9LA@mail.gmail.com>
	<CA+55aFziwaP21NVyVb_UP3okiX7fXoo4DQ7zudhxAwPM10_Tuw@mail.gmail.com>
Date: Thu, 14 Mar 2013 23:09:59 +0100
Message-ID: <CABPqkBR2HeDmuTVg5RA=5D0xXJbXxqSxMDf7MW0iCGnurQb7jw@mail.gmail.com>
Subject: Re: [GIT PULL] perf fixes
From: Stephane Eranian <eranian@google.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Ingo Molnar <mingo@kernel.org>,
        Arnaldo Carvalho de Melo <acme@infradead.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Mar 14, 2013 at 10:06 PM, Linus Torvalds
<torvalds@linux-foundation.org> wrote:
>
> On Thu, Mar 14, 2013 at 1:32 PM, Linus Torvalds
> <torvalds@linux-foundation.org> wrote:
> >
> > And to make things interesting, I seem to be able to only reproduce
> > this *after* a suspend cycle. That may be just happenstance, since it
> > seemed to be hard to replicate and most of the time it has happened
> > under X with no messages visible at all, but that *seems* to be the
> > pattern.
> >
> > And the one time I got it to happen on the text console, things
> > scrolled off (watchdog warnings due to lockups), but I did get a NULL
> > pointer dereference in intel_pmu_enable_all().
> >
> > I'll try to reproduce it and get a picture,
>
> Theory more or less confirmed.
>
> It does need a suspend/resume cycle, and I have a picture. The oops
> happens immediately when trying to do any perf work after the first
> suspend, before suspending I seem to be able to reliably use perf. It
> could still be just random flakiness, but I don't think so.
>
Could be related to suspend/resume. But were you running perf across
that resume/suspend cycle?



But still don't see how a wrmsrl could corrupt a cpuc.


>
> The NULL pointer dereference is at intel_pmu_enable_all+0x4d/0xa0 for
> me, which seems to be the load of the
>
>     if (test_bit(INTEL_PMC_IDX_FIXED_BTS, cpuc->active_mask))
>
> thing. It says
>
>    BUG: unable to handle NULL pointer dereference at 0000000000000028
>
> But that error makes no sense. The code at that EIP is
>
>   48 8b 83 00 02 00 00 mov    0x200(%rbx),%rax     <-- trapping instruction
>
> and the value printed out for %rbx is 0xffff80014f20b8e0, so it should
> *not* be a NULL pointer dereference (and "cpuc" was also used just
> before the wrmsrl).


>
> So I suspect that the "wrmsrl" that was just before that instruction
> does something odd, and the PMU is in some odd state, so that the NULL
> pointer dereference actually has something to do with *that*, rather
> than the instruction itself.
>
> The callchain looks normal. It's
>
>   finish_task_switch ->
>     __perf_event_task_sched_in ->
>       perf_event_context_sched_in ->
>         perf_pmu_enable ->
>           x86_pmu_enable ->
>             intel_pmu_enable_all()
>
> The immediately preceding wrmsrl was done with rax=0xf, rdx=0x7,
> rcx=0x38f according to the register dump (but the picture isn't great,
> so the numbers aren't 100% reliable).
>
Value 0x38f for GLOBAL_CTRL is valid. And 0x70000000f is valid too
for the counter bitmask (4 generic counters + 3 fixed counters).

Let's see if we can reproduce the problem on the same ChromeBook you
have. Don't have one myself.

> Does this give any clues?
>
>              Linus
