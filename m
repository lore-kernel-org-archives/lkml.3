Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753445Ab3FNRlY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 14 Jun 2013 13:41:24 -0400
Received: from mail-pd0-f173.google.com ([209.85.192.173]:62722 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3FNRlX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 14 Jun 2013 13:41:23 -0400
Message-ID: <51BB55C0.7090603@linaro.org>
Date: Fri, 14 Jun 2013 10:41:20 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: Alexander Holler <holler@ahsoftware.de>
CC: linux-kernel@vger.kernel.org, Andrew Morton <akpm@linux-foundation.org>,
        rtc-linux@googlegroups.com, Thomas Gleixner <tglx@linutronix.de>,
        Alessandro Zummo <a.zummo@towertech.it>
Subject: Re: [PATCH 4/9 RESEND] RFC: timekeeping: introduce flag systime_was_set
References: <51BA1FF7.4000206@ahsoftware.de> <1371228732-5749-1-git-send-email-holler@ahsoftware.de> <1371228732-5749-5-git-send-email-holler@ahsoftware.de>
In-Reply-To: <1371228732-5749-5-git-send-email-holler@ahsoftware.de>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06/14/2013 09:52 AM, Alexander Holler wrote:
> In order to let an RTC set the time at boot without the problem that a
> second RTC overwrites it, the flag systime_was_set is introduced.
>
> systime_was_set will be true, if a persistent clock sets the time at boot,
> or if do_settimeofday() is called (e.g. by the RTC subsystem or userspace).
>
> Signed-off-by: Alexander Holler <holler@ahsoftware.de>
> ---
>   include/linux/time.h      |  6 ++++++
>   kernel/time/timekeeping.c | 10 +++++++++-
>   2 files changed, 15 insertions(+), 1 deletion(-)
>
> diff --git a/include/linux/time.h b/include/linux/time.h
> index d5d229b..888280f 100644
> --- a/include/linux/time.h
> +++ b/include/linux/time.h
> @@ -129,6 +129,12 @@ extern int update_persistent_clock(struct timespec now);
>   void timekeeping_init(void);
>   extern int timekeeping_suspended;
>   
> +/*
> + * Will be true if the system time was set at least once by
> + * a persistent clock, RTC or userspace.
> + */
> +extern bool systime_was_set;
> +

Probably should make this static to timekeeping.c and create an accessor 
function so you don't have to export locking rules on this.


>   unsigned long get_seconds(void);
>   struct timespec current_kernel_time(void);
>   struct timespec __current_kernel_time(void); /* does not take xtime_lock */
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index baeeb5c..07d8531 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -37,6 +37,9 @@ int __read_mostly timekeeping_suspended;
>   /* Flag for if there is a persistent clock on this platform */
>   bool __read_mostly persistent_clock_exist = false;
>   
> +/* Flag for if the system time was set at least once */
> +bool __read_mostly systime_was_set;
> +
Probably should also move this to be part of the timekeeper structure 
(since it will be protected by the timekeeper lock.

>   static inline void tk_normalize_xtime(struct timekeeper *tk)
>   {
>   	while (tk->xtime_nsec >= ((u64)NSEC_PER_SEC << tk->shift)) {
> @@ -498,6 +501,9 @@ int do_settimeofday(const struct timespec *tv)
>   	raw_spin_lock_irqsave(&timekeeper_lock, flags);
>   	write_seqcount_begin(&timekeeper_seq);
>   
> +	systime_was_set = true;
> +
> +
>   	timekeeping_forward_now(tk);
>   
>   	xt = tk_xtime(tk);

Might also want to add the flag to inject_offset as well, since that 
could be used to set the time.


thanks
-john

