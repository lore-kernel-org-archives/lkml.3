Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752933AbaDDVzl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 17:55:41 -0400
Received: from mail-pd0-f170.google.com ([209.85.192.170]:33697 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752283AbaDDVzj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 17:55:39 -0400
Message-ID: <533F2A57.1060808@linaro.org>
Date: Fri, 04 Apr 2014 14:55:35 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Lei Wen <leiwen@marvell.com>, Thomas Gleixner <tglx@linutronix.de>,
        Stephen Boyd <sboyd@codeaurora.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Michael Opdenacker <michael.opdenacker@free-electrons.com>,
        Joe Perches <joe@perches.com>, Tejun Heo <tj@kernel.org>,
        Petr Mladek <pmladek@suse.cz>, linux-kernel@vger.kernel.org,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH 3/3] printk: using booting time as the timestamp
References: <1396581522-3309-1-git-send-email-leiwen@marvell.com> <1396581522-3309-4-git-send-email-leiwen@marvell.com>
In-Reply-To: <1396581522-3309-4-git-send-email-leiwen@marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 04/03/2014 08:18 PM, Lei Wen wrote:
> As people may want to align the kernel log with some other processor
> running over the same machine but not the same copy of linux, we
> need to keep their log aligned, so that it would not make debug
> process hard and confused.
>
> Signed-off-by: Lei Wen <leiwen@marvell.com>
> ---
>  kernel/printk/printk.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index a45b509..af96fbd 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -349,7 +349,7 @@ static void log_store(int facility, int level,
>  	if (ts_nsec > 0)
>  		msg->ts_nsec = ts_nsec;
>  	else
> -		msg->ts_nsec = local_clock();
> +		msg->ts_nsec = ktime_to_ns(ktime_get_boottime());

No no... Since ktime_get_boottime() takes the timekeeping seqlock, this
will cause any printk (or WARN_ON, etc) that is done while holding a
write in the timekeeping seqlock to deadlock (which I mentioned last time).

I think the better solution here is to have the timekeeping code provide
the printk logic the offset value whenever the sleep time is updated.
That way the printk logic can manage its own values w/o having to take
any timekeeping locks.

That said, I'm still not really fond of trying to add this
functionality. The printk timestamping code was always a little fuzzy,
using jiffies or sched_clock in order to give a rough estimate of boot
delays (and didn't include ntp freq correction, etc). When it was
introduced, I feel like folks were concerned about this, but folks
agreed the rough estimates were worth it, and it didn't have to involve
the real timekeeping code.  Now, trying to raise the bar here to make
printk timestamps actually correlate with
CLOCK_BOOTTIME/REALTIME/MONOTONIC (which I'll admit, seems quite
reasonable given we have timestamps already - but ends up being feature
creep) will add quite a bit of complexity due to the fact that printk is
supposed to be safe to call from everywhere.

And again, syslog can add timestamps to the kernel messages relatively
well in userland. So I'm not sure the need is clear.

thanks
-john

