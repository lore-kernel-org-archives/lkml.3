Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751138AbaDXD77 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 23:59:59 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:55506 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750719AbaDXD76 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 23:59:58 -0400
MIME-Version: 1.0
In-Reply-To: <5357EF4D.6080302@qti.qualcomm.com>
References: <000001417f6834f1-32b83f22-8bde-4b9e-b591-bc31329660e4-000000@email.amazonses.com>
	<CAOh2x==yrBdFDcObdz+La0y=jDERj=sxOBMvU-Kk6eGEvvwZQw@mail.gmail.com>
	<5357EF4D.6080302@qti.qualcomm.com>
Date: Thu, 24 Apr 2014 09:29:57 +0530
Message-ID: <CAKohponJFZcXSyGhGRVSr+T0iWvJowfBThnZxoWCvpitpQTGuw@mail.gmail.com>
Subject: Re: vmstat: On demand vmstat workers V3
From: Viresh Kumar <viresh.kumar@linaro.org>
To: Max Krasnyansky <maxk@qti.qualcomm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Kevin Hilman <khilman@linaro.org>
Cc: Christoph Lameter <cl@linux.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Gilad Ben-Yossef <gilad@benyossef.com>,
        Thomas Gleixner <tglx@linutronix.de>, Tejun Heo <tj@kernel.org>,
        John Stultz <johnstul@us.ibm.com>, Mike Frysinger <vapier@gentoo.org>,
        Minchan Kim <minchan.kim@gmail.com>,
        Hakan Akkan <hakanakkan@gmail.com>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-mm@kvack.org
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 23 April 2014 22:20, Max Krasnyansky <maxk@qti.qualcomm.com> wrote:
> On 04/22/2014 03:32 AM, Viresh Kumar wrote:
>> This vmstat interrupt is disturbing my core isolation :), have you got
>> any far with this patchset?
>
> You don't mean an interrupt, right?

Sorry for not being clear enough. I meant the interruption caused due to these
works.

> The updates are done via the regular priority workqueue.
>
> I'm playing with isolation as well (has been more or less a background thing
> for the last 6+ years). Our threads that run on the isolated cores are SCHED_FIFO
> and therefor low prio workqueue stuff, like vmstat, doesn't get in the way.

Initially I thought that's not enough. As there were queued with a delayed work
and so a timer+work. Because there is a timer to fire, kernel wouldn't stop
the tick for long  with NO_HZ_FULL as get_next_timer_interrupt() wouldn't
return KTIME_MAX. And so we will stop the tick for some time but will still
queue a hrtimer after say 'n' seconds. But the clockevent device will have
a max value of counter it is running and it will disturb isolation
with a interrupt
after end of counter, for me it is 90 seconds.

BUT, it looks there is something else as well here. For the first time this
theory would probably work, but because we wouldn't allow the work
to run, the timer wouldn't get queued again. And so things will start working
soon after.

While writing this mail, I got another vision at this point. Because there will
be one task running and another queued for the work, tick wouldn't be
stopped (nr_running > 1) :( .. And so isolation wouldn't work again.

@Frederic/Kevin: Did we ever had a discussion about stopping tick even if
we have more than a task in queue but are SCHED_FIFO ?

> I do have a few patches for the workqueues to make things better for isolation.

Please share them, even if they aren't mainlinable.
