Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754086Ab3E1SyF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 28 May 2013 14:54:05 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:57356 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752798Ab3E1SyC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 28 May 2013 14:54:02 -0400
Message-ID: <51A4FD47.2030301@linaro.org>
Date: Tue, 28 May 2013 11:53:59 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130510 Thunderbird/17.0.6
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] x86/xen: sync the wallclock when the system time
 changes
References: <1369765368-10823-1-git-send-email-david.vrabel@citrix.com> <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1369765368-10823-3-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/28/2013 11:22 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> Currently the Xen wallclock is only updated every 11 minutes if NTP is
> synchronized to its clock source.  If a guest is started before NTP is
> synchronized it may see an incorrect wallclock time.
>
> Use the pvclock_gtod notifier chain to receive a notification when the
> system time has changed and update the wallclock to match.
>
> This chain is called on every timer tick and we want to avoid an extra
> (expensive) hypercall on every tick.  Because dom0 has historically
> never provided a very accurate wallclock and guests do not expect one,
> we can do this simply.  The wallclock is only updated if the
> difference between now and the last update is more than 0.5 s.
>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>   arch/x86/xen/time.c |   54 ++++++++++++++++++++++++++++++++++++++++++--------
>   1 files changed, 45 insertions(+), 9 deletions(-)
>
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index 4656165..81027b5 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -15,6 +15,8 @@
>   #include <linux/math64.h>
>   #include <linux/gfp.h>
>   #include <linux/mc146818rtc.h>
> +#include <linux/timekeeper_internal.h>

Nope. You shouldn't be including this.

> +#include <linux/pvclock_gtod.h>
>   
>   #include <asm/pvclock.h>
>   #include <asm/xen/hypervisor.h>
> @@ -199,28 +201,59 @@ static void xen_get_wallclock(struct timespec *now)
>   
>   static int xen_set_wallclock(const struct timespec *now)
>   {
> -	struct xen_platform_op op;
> -	int ret;
> -
>   	/* do nothing for domU */
>   	if (!xen_initial_domain())
>   		return -1;
>   
> -	/* Set the Xen wallclock. */
> +	/* Set the hardware RTC. */
> +	return mach_set_rtc_mmss(now);
> +
> +}
> +
> +static int xen_pvclock_gtod_notify(struct notifier_block *nb, unsigned long unused,
> +				   void *priv)
> +{
> +	static struct timespec last, next;
> +	struct timespec now;
> +	struct timekeeper *tk = priv;

Noooo.. don't export the timekeeper like that.


> +	struct xen_platform_op op;
> +	int ret;
> +
> +	/*
> +	 * Set the Xen wallclock from Linux system time.
> +	 *
> +	 * dom0 hasn't historically maintained a very accurate
> +	 * wallclock so guests don't expect it. We can therefore
> +	 * reduce the number of expensive hypercalls by only updating
> +	 * the wallclock every 0.5 s.
> +	 */
> +
> +	now.tv_sec = tk->xtime_sec;
> +	now.tv_nsec = tk->xtime_nsec >> tk->shift;

You probably want current_kernel_time() here.

> +
> +	if (timespec_compare(&now, &last) > 0
> +	    && timespec_compare(&now, &next) < 0)
> +		return 0;
> +
>   	op.cmd = XENPF_settime;
> -	op.u.settime.secs = now->tv_sec;
> -	op.u.settime.nsecs = now->tv_nsec;
> +	op.u.settime.secs = now.tv_sec;
> +	op.u.settime.nsecs = now.tv_nsec;
>   	op.u.settime.system_time = xen_clocksource_read();
>   
>   	ret = HYPERVISOR_dom0_op(&op);
>   	if (ret)
> -		return ret;
> +		return 0;
>   
> -	/* Set the hardware RTC. */
> -	return mach_set_rtc_mmss(now);
> +	last = now;
> +	next = timespec_add(now, ns_to_timespec(NSEC_PER_SEC / 2));
>   

Am I missing the xen_set_wallclock hook here? Your previous patch wanted 
to call the dom0 op and then set the hardware RTC.

And this notifier get called every timer tick? This seems out there...

thanks
-john

