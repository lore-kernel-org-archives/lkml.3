Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751987AbaABWVq (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 17:21:46 -0500
Received: from mail-pb0-f54.google.com ([209.85.160.54]:41508 "EHLO
	mail-pb0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751845AbaABWVo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 17:21:44 -0500
Message-ID: <52C5E675.80701@linaro.org>
Date: Thu, 02 Jan 2014 14:21:41 -0800
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Linus Torvalds <torvalds@linux-foundation.org>
CC: LKML <linux-kernel@vger.kernel.org>,
        =?UTF-8?B?S3J6eXN6dG9mIEhhxYJhc2E=?= <khalasa@piap.pl>,
        =?UTF-8?B?VXdlIEtsZWluZS1Lw7ZuaWc=?= 
	<u.kleine-koenig@pengutronix.de>,
        Willy Tarreau <w@1wt.eu>, Ingo Molnar <mingo@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephen Boyd <sboyd@codeaurora.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCH] sched_clock: Disable seqlock lockdep usage in sched_clock
References: <52C5DB5B.9050604@linaro.org>	<1388699686-4834-1-git-send-email-john.stultz@linaro.org> <CA+55aFxGQkChbFj=GMWAANmbJ512S5KAcFNvKoQJsQCiMfvxqA@mail.gmail.com>
In-Reply-To: <CA+55aFxGQkChbFj=GMWAANmbJ512S5KAcFNvKoQJsQCiMfvxqA@mail.gmail.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/02/2014 02:15 PM, Linus Torvalds wrote:
> On Thu, Jan 2, 2014 at 1:54 PM, John Stultz <john.stultz@linaro.org> wrote:
>> Unforunately the seqlock lockdep enablmenet can't be used
>> in sched_clock, since the lockdep infrastructure eventually
>> calls into sched_clock, which causes a deadlock.
>>
>> Thus, this patch adds _no_lockdep() seqlock methods for the
>> writer side, and changes all generic sched_clock usage to use
>> the _no_lockdep methods.
> Ugh.
>
> On the x86 vclock_gettime() side, we only do this for the reader. Why
> did you make the generic version do it for the writer too, adding the
> necessity for those new operations? It's only the reader side that
> doesn't want it.

So the problem is that the update side calls the lockdep code which
calls sched_clock, which then deadlocks because the seqcount is odd
(held by the updater).

Thus we have to drop the lockdep usage in the updater as well.

On x86 vclock_gettime, we're in userspace, and that's why we can't call
the lockdep code. The update for that code however happens in kernel
space, so it doesn't have the same problem.


> Talking about the new operations, that "*_no_lockdep()" naming annoys
> me. It doesn't match the spinlock naming, which is to just use
> "raw_*()" instead. Wouldn't it be nice to make the naming be
> consistent too? Especially when it's paired with raw_local_irq_save()
> that shares that "raw_" model for non-checking stuff.

Sure, I can change the naming. New patch to follow in a bit.

thanks
-john

