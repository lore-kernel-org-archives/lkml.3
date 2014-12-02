Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaLBQd4 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Dec 2014 11:33:56 -0500
Received: from mail-qc0-f173.google.com ([209.85.216.173]:48493 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753928AbaLBQdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Dec 2014 11:33:54 -0500
MIME-Version: 1.0
In-Reply-To: <1417529606.3924.26.camel@maggy.simpson.net>
References: <CA+55aFz-JUX6CU-aO+cwLHYtH7BA+dgyUnEGoy8T4S62gEDFpA@mail.gmail.com>
	<20141127225637.GA24019@redhat.com>
	<m5dart$co$1@ger.gmane.org>
	<CA+55aFwm4hpyDjJ=GzrahOe2QtuO7im71sPky7U6Rh+18A0X0w@mail.gmail.com>
	<547b8a45.6e608c0a.20f9.1002@mx.google.com>
	<CA+55aFzQ0QZxL-PRnv4Db=wo1pDmBR45P-vpGxyeJnt1DFnSfA@mail.gmail.com>
	<547bbe36.48548c0a.105c.779c@mx.google.com>
	<20141201191431.GA17385@linux.vnet.ibm.com>
	<547ccf74.a5198c0a.25de.26d9@mx.google.com>
	<CA+55aFx0K=T8yvfRCYeaJG_5YO+Qm8EEQfA9Xp59xedbzj=f2A@mail.gmail.com>
	<20141201230339.GA20487@ret.masoncoding.com>
	<1417529606.3924.26.camel@maggy.simpson.net>
Date: Tue, 2 Dec 2014 08:33:53 -0800
X-Google-Sender-Auth: aD0Q38pm1F4XelxYyDF-N7OETeY
Message-ID: <CA+55aFw8smHBw9HiCiYL_ohkULLeunWo6qfayM19zhF1hKAxXg@mail.gmail.com>
Subject: Re: frequent lockups in 3.18rc4
From: Linus Torvalds <torvalds@linux-foundation.org>
To: Mike Galbraith <umgwanakikbuti@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>
Cc: Chris Mason <clm@fb.com>,
        =?UTF-8?Q?D=C3=A2niel_Fraga?= <fragabr@gmail.com>,
        Dave Jones <davej@redhat.com>, Sasha Levin <sasha.levin@oracle.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Dec 2, 2014 at 6:13 AM, Mike Galbraith <umgwanakikbuti@gmail.com> wrote:
>
> The bean counting problem below can contribute.
>
> https://lkml.org/lkml/2014/3/30/7

Hmm. That never got applied. I didn't apply it originally because of
timing and wanting clarifications, but apparently it never made it
into the -tip tree either.

Ingo, PeterZ - comments?

Looking again at that patch (the commit message still doesn't strike
me as wonderfully explanatory :^) makes me worry, though.

Is that

        if (rq->skip_clock_update-- > 0)
                return;

really right? If skip_clock_update was zero (normal), it now gets set
to -1, which has its own specific meaning (see "force clock update"
comment in kernel/sched/rt.c). Is that intentional? That seems insane.

Or should it be

        if (rq->skip_clock_update > 0) {
                rq->skip_clock_update = 0;
                return;
        }

or what? Maybe there was a reason the patch never got applied even to -tip.

At the same time, the whole "incapacitated by the rt throttle long
enough for the hard lockup detector to trigger" commentary about that
skip_clock_update issue does make me go "Hmmm..". It would certainly
explain Dave's incomprehensible watchdog messages..

               Linus
