Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759301Ab3ICR0Y (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 13:26:24 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:47630 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755089Ab3ICR0X (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 13:26:23 -0400
Message-ID: <52261BBB.60904@linaro.org>
Date: Tue, 03 Sep 2013 10:26:19 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Gerlando Falauto <gerlando.falauto@keymile.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Richard Cochran <richardcochran@gmail.com>,
        Prarit Bhargava <prarit@redhat.com>,
        "Brunck, Holger" <Holger.Brunck@keymile.com>,
        "Longchamp, Valentin" <Valentin.Longchamp@keymile.com>,
        "Bigler, Stefan" <Stefan.Bigler@keymile.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: kernel deadlock
References: <521F6D06.1040107@keymile.com> <E92455D61233364C88CCD4A6DAB2E2850E09518110@SRVDEHAN1MX1.keymile.net> <521FDD12.7050000@linaro.org> <52212511.9050206@keymile.com> <5221264F.4070402@linaro.org> <5225F8EF.3040701@keymile.com>
In-Reply-To: <5225F8EF.3040701@keymile.com>
X-Enigmail-Version: 1.5.2
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 09/03/2013 07:57 AM, Gerlando Falauto wrote:
> Hi,
>
> I tried again from scratch, so let me recap the whole situation, so we
> can all view it from the same standpoint. This should make the problem
> easier to see and reproduce.
>
> I can confirm that running a stock 3.10 kernel with HRTICK enabled:
[snip]
> makes the following program (and the whole board, as a matter of fact)
> hang with no further notice:
>
[snip]
> If I then revert everything up to (and including) the offending commit
> (mind the '~'):
>
> $ git log --oneline ...06c017f~ -- kernel/time/timekeeping.c
> kernel/time/ntp.c | cut -f1 -d' ' | xargs git revert
>
> The problem disappears.
>
> If I then cherry-pick again the offending commit:
>
> $ git cherry-pick 06c017f; git log -1
>
> commit 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40
> Author: John Stultz <john.stultz@linaro.org>
> Date:   Fri Mar 22 11:37:28 2013 -0700
>
>      timekeeping: Hold timekeepering locks in do_adjtimex and hardpps
>
[snip]
> And as soon as I also cherry-pick (notice there is another commit in
> between, which seems not to be relevant on this matter):
>
> $ git cherry-pick a076b2146fabb0894cae5e0189a8ba3f1502d737; git show
>
> commit a076b2146fabb0894cae5e0189a8ba3f1502d737
> Author: John Stultz <john.stultz@linaro.org>
> Date:   Fri Mar 22 11:52:03 2013 -0700
>
>     ntp: Remove ntp_lock, using the timekeeping locks to protect ntp
> state
>
[snip]
>
> I end up in the situation where the system hangs completely and NO
> deadlock report whatsoever is output.
>
> So it looks like 06c017fdd4dc48451a29ac37fc1db4a3f86b7f40 introduces
> the deadlock, while a076b2146fabb0894cae5e0189a8ba3f1502d737 cares to
> hide the report.
>
> Notice how I tested the above on an ARM board; on PowerPC I get
> similar results, although I am not able to see the deadlock report
> under any circumstances (enabling CONFIG_PROVE_LOCKING, which is the
> flag that triggers the deadlock report, causes the kernel to hang at
> startup even on a vanilla 3.10 kernel).
>
> John, could you please confirm whether you're at least able to
> reproduce it somehow?

Thanks again for the detailed notes. I've so far been unable to
reproduce this, but I'm still looking at it.

Enabling the SCHED_FEAT(HRTICK, true) bit tends to cause lots of issues
on the various hardware I have, tripping the lockdep warnings on various
other issues:

[    4.224487] ======================================================
[    4.230987] [ INFO: possible circular locking dependency detected ]
[    4.237579] 3.9.0-rc2-00148-g06c017f-dirty #8 Not tainted
[    4.243255] -------------------------------------------------------
[    4.249847] kworker/0:1H/1329 is trying to acquire lock:
[    4.255432]  (&p->pi_lock){-.-.-.}, at: [<c006d184>]
try_to_wake_up+0x30/0x3c
[    4.263092]
[    4.263092] but task is already holding lock:
[    4.269226]  (&rq->lock){-.-.-.}, at: [<c0721f18>] __schedule+0xb8/0x7d0
[    4.276306]
[    4.276306] which lock already depends on the new lock.

and

[    2.360591] =============================================
[    2.363072] [ INFO: possible recursive locking detected ]
[    2.364882] 3.9.0-rc2+ #9 Not tainted
[    2.365486] ---------------------------------------------
[    2.366345] blkid/999 is trying to acquire lock:
[    2.367092]  (&p->pi_lock){-.-.-.}, at: [<ffffffff810c763c>]
try_to_wake_up+0x2c/0x300
[    2.367275]
[    2.367275] but task is already holding lock:
[    2.367275]  (&p->pi_lock){-.-.-.}, at: [<ffffffff810c763c>]
try_to_wake_up+0x2c/0x300
[    2.367275]
[    2.367275] other info that might help us debug this:
[    2.367275]  Possible unsafe locking scenario:
[    2.367275]

These warnings disable lockdep, so it may just be I'm not getting a
chance to see the warning you describe.


That said, the one system that doesn't throw those lockdep warnings,
doesn't seem to hit your lockdep warning either, and I've not been able
to trigger any hang using the test code you provided.

Just in case there's something else here at play, could you send me your
.config that you're using?

thanks
-john

