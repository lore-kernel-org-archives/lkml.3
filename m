Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757423AbaC1DSI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Mar 2014 23:18:08 -0400
Received: from mail-ig0-f182.google.com ([209.85.213.182]:59657 "EHLO
	mail-ig0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751170AbaC1DSG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Mar 2014 23:18:06 -0400
MIME-Version: 1.0
In-Reply-To: <1395908241-6392-1-git-send-email-zhangwm@marvell.com>
References: <1395908241-6392-1-git-send-email-zhangwm@marvell.com>
Date: Thu, 27 Mar 2014 20:18:05 -0700
X-Google-Sender-Auth: Gqjs4yfV-xkI-nyJTAIIOJawC2s
Message-ID: <CANcMJZCG7CT_rOShK7jGo3xVZ0MiRD-jUJE=FCTW68tv88g-Bw@mail.gmail.com>
Subject: Re: [PATCH] printk: add sleep time into timestamp
From: John Stultz <john.stultz@linaro.org>
To: Neil Zhang <zhangwm@marvell.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Mar 27, 2014 at 1:17 AM, Neil Zhang <zhangwm@marvell.com> wrote:
> Add sleep time into timestamp to reflect the actual time since
> sched_clock will be stopped during suspend.

So why is this change necessary?

Further, since the sleep time may be updated a bit late in the resume
cycle (in many cases we cannot access the RTC until irqs are enabled
back on), you may see messages that show pre-suspend times when really
they occur after we resume (but before the sleep time is incremented).

More comments below....

> This patch depends on the following patch.
> timekeeping: check params before use them
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  kernel/printk/printk.c |   15 +++++++++++++--
>  1 file changed, 13 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 4dae9cb..2dc6145 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -250,6 +250,17 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
>
> +static u64 print_clock(void)
> +{
> +       struct timespec ts;
> +       u64 ts_nsec = local_clock();
> +
> +       get_xtime_and_monotonic_and_sleep_offset(NULL, NULL, &ts);

So this will cause deadlocks anytime we print from the timekeeping
core, since we may hold a write on the timekeeper lock, and this patch
makes every printk try to take a read-lock on the timekeeper lock.

I'd suggest you use monotonic_to_bootbased() here instead of hacking
up this hrtimer specific interface, but even so, right now that call
doesn't take the timekeeper lock, but probably should, so its not a
good long term plan.

I'm still not convinced this change needs to be done, but a  better
solution here would be to add infrastructure that when the sleep time
is updated we update an offset that the is adding to the local_clock()
however, you probably want to be careful since you don't want sleep
time in normal local_clock/sched_clock calls since it would mess up
scheduling.

thanks
-john
