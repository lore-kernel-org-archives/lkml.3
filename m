Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752990Ab3ILOid (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 10:38:33 -0400
Received: from mail-de.keymile.com ([195.8.104.250]:59911 "EHLO
	mail-de.keymile.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751034Ab3ILOib (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 10:38:31 -0400
Message-ID: <5231D1E0.9000800@keymile.com>
Date: Thu, 12 Sep 2013 16:38:24 +0200
From: Gerlando Falauto <gerlando.falauto@keymile.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130807 Thunderbird/17.0.8
MIME-Version: 1.0
To: John Stultz <john.stultz@linaro.org>
CC: LKML <linux-kernel@vger.kernel.org>, Ingo Molnar <mingo@kernel.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Mathieu Desnoyers <mathieu.desnoyers@efficios.com>,
        stable <stable@vger.kernel.org>
Subject: Re: [PATCH] timekeeping: Fix HRTICK related deadlock from ntp lock
 changes
References: <1378943457-27314-1-git-send-email-john.stultz@linaro.org>
In-Reply-To: <1378943457-27314-1-git-send-email-john.stultz@linaro.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On 09/12/2013 01:50 AM, John Stultz wrote:
[...]
>
> The deadlock was introduced by 06c017fdd4dc48451a (timekeeping:
> Hold timekeepering locks in do_adjtimex and hardpps) in 3.10
>
> This patch avoids this deadlock, by moving the call to
> schedule_delayed_work() outside of the timekeeper lock
> critical section.
>
> Cc: Ingo Molnar <mingo@kernel.org>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Gerlando Falauto <gerlando.falauto@keymile.com>
> Cc: Mathieu Desnoyers <mathieu.desnoyers@efficios.com>
> Cc: stable <stable@vger.kernel.org> #3.11, 3.10
> Reported-by: Gerlando Falauto <gerlando.falauto@keymile.com>
> Tested-by: Lin Ming <minggr@gmail.com>
> Signed-off-by: John Stultz <john.stultz@linaro.org>

For what it's worth (I guess it's a bit late now):

Tested-by: Gerlando Falauto <gerlando.falauto@keymile.com>

Thanks!
Gerlando

> ---
>   include/linux/timex.h     | 1 +
>   kernel/time/ntp.c         | 6 ++----
>   kernel/time/timekeeping.c | 2 ++
>   3 files changed, 5 insertions(+), 4 deletions(-)
>
> diff --git a/include/linux/timex.h b/include/linux/timex.h
> index b3726e6..dd3edd7 100644
> --- a/include/linux/timex.h
> +++ b/include/linux/timex.h
> @@ -141,6 +141,7 @@ extern int do_adjtimex(struct timex *);
>   extern void hardpps(const struct timespec *, const struct timespec *);
>
>   int read_current_timer(unsigned long *timer_val);
> +void ntp_notify_cmos_timer(void);
>
>   /* The clock frequency of the i8253/i8254 PIT */
>   #define PIT_TICK_RATE 1193182ul
> diff --git a/kernel/time/ntp.c b/kernel/time/ntp.c
> index 8f5b3b9..bb22151 100644
> --- a/kernel/time/ntp.c
> +++ b/kernel/time/ntp.c
> @@ -516,13 +516,13 @@ static void sync_cmos_clock(struct work_struct *work)
>   	schedule_delayed_work(&sync_cmos_work, timespec_to_jiffies(&next));
>   }
>
> -static void notify_cmos_timer(void)
> +void ntp_notify_cmos_timer(void)
>   {
>   	schedule_delayed_work(&sync_cmos_work, 0);
>   }
>
>   #else
> -static inline void notify_cmos_timer(void) { }
> +void ntp_notify_cmos_timer(void) { }
>   #endif
>
>
> @@ -687,8 +687,6 @@ int __do_adjtimex(struct timex *txc, struct timespec *ts, s32 *time_tai)
>   	if (!(time_status & STA_NANO))
>   		txc->time.tv_usec /= NSEC_PER_USEC;
>
> -	notify_cmos_timer();
> -
>   	return result;
>   }
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 48b9fff..947ba25 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -1703,6 +1703,8 @@ int do_adjtimex(struct timex *txc)
>   	write_seqcount_end(&timekeeper_seq);
>   	raw_spin_unlock_irqrestore(&timekeeper_lock, flags);
>
> +	ntp_notify_cmos_timer();
> +
>   	return ret;
>   }
>
>

