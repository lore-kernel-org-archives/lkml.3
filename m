Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751521AbaABMHe (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 Jan 2014 07:07:34 -0500
Received: from ni.piap.pl ([195.187.100.4]:54378 "EHLO ni.piap.pl"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751028AbaABMHd (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 Jan 2014 07:07:33 -0500
From: khalasa@piap.pl (Krzysztof =?utf-8?Q?Ha=C5=82asa?=)
To: Uwe =?utf-8?Q?Kleine-K=C3=B6nig?= <u.kleine-koenig@pengutronix.de>
Cc: Willy Tarreau <w@1wt.eu>, John Stultz <john.stultz@linaro.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        lkml <linux-kernel@vger.kernel.org>,
        linux-arm-kernel@lists.infradead.org, Ingo Molnar <mingo@kernel.org>,
        Stephen Boyd <sboyd@codeaurora.org>
References: <m3mwjhux0e.fsf@t19.piap.pl> <20131231104511.GA9688@1wt.eu>
	<m3txdmu2ez.fsf@t19.piap.pl> <20140102101455.GG10158@pengutronix.de>
Date: Thu, 02 Jan 2014 13:07:30 +0100
In-Reply-To: <20140102101455.GG10158@pengutronix.de> ("Uwe =?utf-8?Q?Klein?=
 =?utf-8?Q?e-K=C3=B6nig=22's?=
	message of "Thu, 2 Jan 2014 11:14:55 +0100")
MIME-Version: 1.0
Message-ID: <m3ppoatwn1.fsf@t19.piap.pl>
Content-Type: text/plain
Subject: Re: v3.13-rc6+ regression (ARM board)
X-Anti-Virus: Kaspersky Anti-Virus for Linux Mail Server 5.6.44/RELEASE,
	 bases: 20140102 #7222383, check: 20140102 clean
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Uwe,

>> >> There seems to be a regression in v3.13-rc6+ (up to current tip =
>> >> 71ce176ee6ed1735b9a1160a5704a915d13849b1).
>> >>
>> >> Board is Gateworks Cambria, CPU Intel IXP435 ARM big endian, gcc 4.7.3.
>> >> The board boots correctly and works (shell mostly, and SSHD) for about
>> >> 50 seconds. After 52-54 seconds, it frozes dead without any console
>> >> (UART) output.

Merging 1ca7d67cf5d5a2aef26a8d9afd789006fa098347 with
85c3d2dd15be4d577a37ffb8bbbd019fc8e3280a = issue, but

merging 1ca7d67cf5d5a2aef26a8d9afd789006fa098347 with
85c3d2dd15be4d577a37ffb8bbbd019fc8e3280a~1 = no issue.

This means these two commits don't like each other:

commit 1ca7d67cf5d5a2aef26a8d9afd789006fa098347
Author: John Stultz <john.stultz@linaro.org>
Date:   Mon Oct 7 15:51:59 2013 -0700

    seqcount: Add lockdep functionality to seqcount/seqlock structures

    Currently seqlocks and seqcounts don't support lockdep.

    After running across a seqcount related deadlock in the timekeeping
    code, I used a less-refined and more focused variant of this patch
    to narrow down the cause of the issue.

    This is a first-pass attempt to properly enable lockdep functionality
    on seqlocks and seqcounts.

    Since seqcounts are used in the vdso gettimeofday code, I've provided
    non-lockdep accessors for those needs.

    I've also handled one case where there were nested seqlock writers
    and there may be more edge cases.

    Comments and feedback would be appreciated!

    Signed-off-by: John Stultz <john.stultz@linaro.org>
    Signed-off-by: Peter Zijlstra <peterz@infradead.org>
    Cc: Eric Dumazet <eric.dumazet@gmail.com>
    Cc: Li Zefan <lizefan@huawei.com>
    Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
    Cc: Steven Rostedt <rostedt@goodmis.org>
    Cc: "David S. Miller" <davem@davemloft.net>
    Cc: netdev@vger.kernel.org
    Link: http://lkml.kernel.org/r/1381186321-4906-3-git-send-email-john.stultz@linaro.org
    Signed-off-by: Ingo Molnar <mingo@kernel.org>

 arch/x86/vdso/vclock_gettime.c |  8 ++++---- (not used on this machine)
 fs/dcache.c                    |  4 ++--
 fs/fs_struct.c                 |  2 +-
 include/linux/init_task.h      |  8 ++++----
 include/linux/lockdep.h        |  8 ++++++--
 include/linux/seqlock.h        | 79 ++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++++-------
 mm/filemap_xip.c               |  2 +-       (not used on this machine)
 7 files changed, 90 insertions(+), 21 deletions(-)

and:

commit 85c3d2dd15be4d577a37ffb8bbbd019fc8e3280a
Author: Stephen Boyd <sboyd@codeaurora.org>
Date:   Thu Jul 18 16:21:15 2013 -0700

    sched_clock: Use seqcount instead of rolling our own

    We're going to increase the cyc value to 64 bits in the near
    future. Doing that is going to break the custom seqcount
    implementation in the sched_clock code because 64 bit numbers
    aren't guaranteed to be atomic. Replace the cyc_copy with a
    seqcount to avoid this problem.

    Cc: Russell King <linux@arm.linux.org.uk>
    Acked-by: Will Deacon <will.deacon@arm.com>
    Signed-off-by: Stephen Boyd <sboyd@codeaurora.org>
    Signed-off-by: John Stultz <john.stultz@linaro.org>

 kernel/time/sched_clock.c | 27 ++++++++-------------------
 1 file changed, 8 insertions(+), 19 deletions(-)
-- 
Krzysztof Halasa

Research Institute for Automation and Measurements PIAP
Al. Jerozolimskie 202, 02-486 Warsaw, Poland
