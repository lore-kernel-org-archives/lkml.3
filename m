Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755541Ab3ENAkv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:40:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:36369 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754468Ab3ENAku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:40:50 -0400
Message-ID: <5191880F.3030308@linaro.org>
Date: Mon, 13 May 2013 17:40:47 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/3] timekeeping: sync persistent clock and RTC on system
 time step changes
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1368467768-2316-3-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 10:56 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> The persistent clock or the RTC is only synchronized with system time
> every 11 minutes if NTP is running.  This gives a window where the
> persistent clock may be incorrect after a step change in the time
> (such as on first boot).
>
> This particularly affects Xen guests as until an update to the control
> domain's persistent clock, new guests will start with the incorrect
> system time.
>
> When there is a step change in the system time, call
> update_persistent_clock or rtc_set_ntp_time() to synchronize the
> persistent clock or RTC to the new system time.

I'm sorry, this isn't quite making sense to me. Could you further 
describe the exact problematic behavior you're seeing here, and why its 
a problem?

You seem to be saying we should always set the RTC any time settimeofday 
is called (regardless of the NTP sync state), which doesn't seem right 
to me. Also I worry that this would cause the RTC to be set when the RTC 
hctosys() code (or hwclock) sets the time to the RTC clock, which is a 
bit circular.

I suspect once the problem is better understood, there will be a better 
solution then trying to always set the RTC on any settimeofday() call.

thanks
-john



>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>   kernel/time/timekeeping.c |   46 +++++++++++++++++++++++++++++++++++++++++++-
>   1 files changed, 44 insertions(+), 2 deletions(-)
>
> diff --git a/kernel/time/timekeeping.c b/kernel/time/timekeeping.c
> index 98cd470..56f2349 100644
> --- a/kernel/time/timekeeping.c
> +++ b/kernel/time/timekeeping.c
> @@ -240,12 +240,54 @@ int pvclock_gtod_unregister_notifier(struct notifier_block *nb)
>   }
>   EXPORT_SYMBOL_GPL(pvclock_gtod_unregister_notifier);
>   
> +#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
> +
> +static void __sync_persistent_clock(struct work_struct *work)
> +{
> +	struct timespec now;
> +	int ret = 0;
> +
> +	getnstimeofday(&now);
> +
> +#ifdef CONFIG_GENERIC_CMOS_UPDATE
> +	ret = update_persistent_clock(now);
> +#endif
> +#ifdef CONFIG_RTC_SYSTOHC
> +	if (ret == -ENODEV)
> +		rtc_set_ntp_time(now);
> +#endif
> +}
> +
> +static DECLARE_DELAYED_WORK(sync_persistent_clock_work, __sync_persistent_clock);
> +
> +static void sync_persistent_clock(struct timekeeper *tk)
> +{
> +	u64 nsecs;
> +	u32 remainder;
> +
> +	/* Many RTCs require updates 500 ms before the next second. */
> +	nsecs = timekeeping_get_ns(tk);
> +	div_u64_rem(nsecs, NSEC_PER_SEC, &remainder);
> +	if (remainder > NSEC_PER_SEC / 2)
> +		nsecs = remainder - NSEC_PER_SEC / 2;
> +	else
> +		nsecs = remainder + NSEC_PER_SEC / 2;
> +
> +	if (system_wq)
> +		schedule_delayed_work(&sync_persistent_clock_work, nsecs_to_jiffies(nsecs));
> +}
> +
> +#endif
> +
>   /* must hold timekeeper_lock */
> -static void timekeeping_update(struct timekeeper *tk, bool clearntp, bool mirror)
> +static void timekeeping_update(struct timekeeper *tk, bool step, bool mirror)
>   {
> -	if (clearntp) {
> +	if (step) {
>   		tk->ntp_error = 0;
>   		ntp_clear();
> +#if defined(CONFIG_GENERIC_CMOS_UPDATE) || defined(CONFIG_RTC_SYSTOHC)
> +		sync_persistent_clock(tk);
> +#endif
>   	}
>   	update_vsyscall(tk);
>   	update_pvclock_gtod(tk);

