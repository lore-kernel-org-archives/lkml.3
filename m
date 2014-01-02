Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752529AbaABWPM (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:15:12 -0500
Received: from mail-ee0-f49.google.com ([74.125.83.49]:60492 "EHLO
	mail-ee0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750765AbaABWPK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:15:10 -0500
MIME-Version: 1.0
In-Reply-To: <1388699686-4834-1-git-send-email-john.stultz@linaro.org>
References: <52C5DB5B.9050604@linaro.org>
	<1388699686-4834-1-git-send-email-john.stultz@linaro.org>
Date: Thu, 2 Jan 2014 14:15:08 -0800
X-Google-Sender-Auth: Rq5-qTOne9wrZCiJJwtglpyRI7k
Message-ID: <CA+55aFxGQkChbFj=GMWAANmbJ512S5KAcFNvKoQJsQCiMfvxqA@mail.gmail.com>
Subject: Re: [PATCH] sched_clock: Disable seqlock lockdep usage in sched_clock
From: Linus Torvalds <torvalds@linux-foundation.org>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?Q?Krzysztof_Ha=C5=82asa?= <khalasa@piap.pl>,
        =?UTF-8?Q?Uwe_Kleine=2DK=C3=B6nig?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 2, 2014 at 1:54 PM, John Stultz <john.stultz@linaro.org> wrote:
> Unforunately the seqlock lockdep enablmenet can't be used
> in sched_clock, since the lockdep infrastructure eventually
> calls into sched_clock, which causes a deadlock.
>
> Thus, this patch adds _no_lockdep() seqlock methods for the
> writer side, and changes all generic sched_clock usage to use
> the _no_lockdep methods.

Ugh.

On the x86 vclock_gettime() side, we only do this for the reader. Why
did you make the generic version do it for the writer too, adding the
necessity for those new operations? It's only the reader side that
doesn't want it.

Talking about the new operations, that "*_no_lockdep()" naming annoys
me. It doesn't match the spinlock naming, which is to just use
"raw_*()" instead. Wouldn't it be nice to make the naming be
consistent too? Especially when it's paired with raw_local_irq_save()
that shares that "raw_" model for non-checking stuff.

             Linus
