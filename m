Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754780AbaIBQIv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 12:08:51 -0400
Received: from mail-vc0-f176.google.com ([209.85.220.176]:63991 "EHLO
	mail-vc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753526AbaIBQIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 12:08:49 -0400
MIME-Version: 1.0
In-Reply-To: <5dfbace37c434be58ed26ea524aa0675@AM3PR06MB388.eurprd06.prod.outlook.com>
References: <5dfbace37c434be58ed26ea524aa0675@AM3PR06MB388.eurprd06.prod.outlook.com>
Date: Tue, 2 Sep 2014 09:08:48 -0700
X-Google-Sender-Auth: NKq6dbpR63VTyoCbPBe93XipauQ
Message-ID: <CA+55aFw9HL4E=3eofs4=hzY=LvWEcKzzJZOTDDTGkeF1_vDcog@mail.gmail.com>
Subject: Re: Race condition in HR timers that cause double insertion and hard
 lockup -- all latest versions
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Itzcak Pechtalt <itzcak@flashnetworks.com>,
        Thomas Gleixner <tglx@linutronix.de>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Sep 2, 2014 at 8:45 AM, Itzcak Pechtalt
<itzcak@flashnetworks.com> wrote:
>
> I opened a bug in https://bugzilla.kernel.org/show_bug.cgi?id=83601  for this subject with full description.
> There is also a short fix patch for kernel/hrtimer.c file.
> Even if this bug occurs rary, however it resolves system hard lockup option.

The patch is whitespace-damaged, but with a small oneliner like this
that doesn't much matter (the timer files moved to kernel/time/ during
this merge window, so the patch wouldn't apply as-is anyway).

It needs a sign-off (see Documentation/SubmittingPatches), but even
more importantly it needs to go to the right people for
double-checking.

But the patch is more broken than whitespace and even lack of
sign-off. It cannot even have compiled. I'm assuming "timer_state" was
intended to be "timer->state". Also, every caller but one already has
"HRTIMER_STATE_CALLBACK" set unconditionally or to the old state in
"newstate", so I suspect if this patch is the real fix (which I'll
leave for Thomas to comment more on), afaik the actual problem can
only happen through migrate_hrtimer_list() which uconditionally sets
the whole state to HRTIMER_STATE_MIGRATE.

Thomas? Leaving damaged patch quoted below.

           Linus

> I suspect that it was targeted by mistake to not active list (timers_realtime-clock@kernel-bugs.osdl.org).
> Following is the fix patch based on kernel 3.16.1 (just simple):
> diff -uNr a/kernel/hrtimer.c b/kernel/hrtimer.c
> --- a/kernel/hrtimer.c 2014-08-31 20:59:52.177452123 +0300
> +++ b/kernel/hrtimer.c 2014-08-31 21:02:14.972166540 +0300
> @@ -941,7 +941,7 @@
> if (!timerqueue_getnext(&base->active))
> base->cpu_base->active_bases &= ~(1 << base->index);
> out:
> - timer->state = newstate;
> + timer->state = (newstate | (timer_state & HRTIMER_STATE_CALLBACK));
> }
>
> /*
>
> Is there a chance for this patch fix to insert into next kernel release?
>
> Thanks
>
> Itzcak Pechtalt
>
