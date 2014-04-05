Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753939AbaDEA6Q (ORCPT <rfc822;w@1wt.eu>);
	Fri, 4 Apr 2014 20:58:16 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:52254 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752860AbaDEA6O (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 4 Apr 2014 20:58:14 -0400
Message-ID: <533F5524.8050500@linaro.org>
Date: Fri, 04 Apr 2014 17:58:12 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.4.0
MIME-Version: 1.0
To: Neil Zhang <zhangwm@marvell.com>, akpm@linux-foundation.org
CC: linux-kernel@vger.kernel.org, Lei Wen <leiwen@marvell.com>,
        Peter Zijlstra <peterz@infradead.org>
Subject: Re: [PATCH V2] printk: add sleep time into timestamp
References: <1396322456-5195-1-git-send-email-zhangwm@marvell.com>
In-Reply-To: <1396322456-5195-1-git-send-email-zhangwm@marvell.com>
X-Enigmail-Version: 1.6
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 03/31/2014 08:20 PM, Neil Zhang wrote:
> Add sleep time into timestamp to reflect the actual time since
> sched_clock will be stopped during suspend.
>
> Thanks John Stultz for suggestion to use monotonic_to_bootbased.
>
> Signed-off-by: Neil Zhang <zhangwm@marvell.com>
> ---
>  kernel/printk/printk.c |   16 ++++++++++++++--
>  1 file changed, 14 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/printk/printk.c b/kernel/printk/printk.c
> index 4dae9cb..121f792 100644
> --- a/kernel/printk/printk.c
> +++ b/kernel/printk/printk.c
> @@ -250,6 +250,18 @@ static char __log_buf[__LOG_BUF_LEN] __aligned(LOG_ALIGN);
>  static char *log_buf = __log_buf;
>  static u32 log_buf_len = __LOG_BUF_LEN;
>  
> +static u64 print_clock(void)
> +{
> +	struct timespec	ts;
> +	u64 ts_nsec = local_clock();
> +
> +	ts = ns_to_timespec(ts_nsec);
> +	monotonic_to_bootbased(&ts);
> +	ts_nsec = timespec_to_ns(&ts);
> +

Note that this is still problematic as monotonic_to_bootbased currently
doesn't take the required locks to ensure it reads the data atomically.

If it were fixed to take the proper locks, this would risk a deadlock
since there are places where the timekeeping code takes a write on the
seqlock and then may call printk (or WARN_ON).

I suspect if this is going to be done, we need to have the timekeeping
provide the print_clock subsystem the boottime offset when it is changed
so the print_clock logic can manage this w/o grabbing timekeeping locks.
But as I mentioned in reply to Lei's similar patches, I'm not a huge fan
of the added complexity that will be required here when userspace like
syslog can timestamps kernel messages already (so additional rational
will be needed to move this forward).

thanks
-john
