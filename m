Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755764Ab3ENAwP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 May 2013 20:52:15 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:37968 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755604Ab3ENAwN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 May 2013 20:52:13 -0400
Message-ID: <51918ABB.5030501@linaro.org>
Date: Mon, 13 May 2013 17:52:11 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org,
        Jeremy Fitzhardinge <jeremy.fitzhardinge@citrix.com>
Subject: Re: [PATCH 3/3] x86/xen: sync the CMOS RTC as well as the Xen wallclock
References: <1368467768-2316-1-git-send-email-david.vrabel@citrix.com> <1368467768-2316-4-git-send-email-david.vrabel@citrix.com>
In-Reply-To: <1368467768-2316-4-git-send-email-david.vrabel@citrix.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 05/13/2013 10:56 AM, David Vrabel wrote:
> From: David Vrabel <david.vrabel@citrix.com>
>
> If NTP is used in dom0 and it is synchronized to its clock source,
> then the kernel will periodically synchronize the Xen wallclock with
> the system time.  Updates to the Xen wallclock do not persist across
> reboots, so also synchronize the CMOS RTC (as on bare metal).

Sorry again, not getting this one either.

So normally in this case we're using the Xen wallclock as the underlying 
source for the persistent_clock here, my understanding is we use this 
instead of the standard cmos, because we get benefits of using the 
hypervisor's sense of time instead of the bare hardware, and allows for 
virtualization of the persistent clock.

But the problem is that even if Dom0 tries to set the xen persistent 
clock, it doesn't actually update anything in the underlying hardware?  
So here you instead try to sync the underlying hardware cmos from the 
same Xen dom0 environment?

Honestly, it seems a little strange to me. If you're running as dom0, 
why does HYPERVISOR_dom0_op() not cause the hypervisor to set the cmos 
its virtualizing? This seems to mess with the proper virtualization 
layering.

I'd appreciate some more details and maybe some feedback from other xen 
folks here to make sure this really makes sense.

thanks
-john


>
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>
> ---
>   arch/x86/xen/time.c |   11 ++++++++++-
>   1 files changed, 10 insertions(+), 1 deletions(-)
>
> diff --git a/arch/x86/xen/time.c b/arch/x86/xen/time.c
> index a1947ac..4656165 100644
> --- a/arch/x86/xen/time.c
> +++ b/arch/x86/xen/time.c
> @@ -14,6 +14,7 @@
>   #include <linux/kernel_stat.h>
>   #include <linux/math64.h>
>   #include <linux/gfp.h>
> +#include <linux/mc146818rtc.h>
>   
>   #include <asm/pvclock.h>
>   #include <asm/xen/hypervisor.h>
> @@ -199,17 +200,25 @@ static void xen_get_wallclock(struct timespec *now)
>   static int xen_set_wallclock(const struct timespec *now)
>   {
>   	struct xen_platform_op op;
> +	int ret;
>   
>   	/* do nothing for domU */
>   	if (!xen_initial_domain())
>   		return -1;
>   
> +	/* Set the Xen wallclock. */
>   	op.cmd = XENPF_settime;
>   	op.u.settime.secs = now->tv_sec;
>   	op.u.settime.nsecs = now->tv_nsec;
>   	op.u.settime.system_time = xen_clocksource_read();
>   
> -	return HYPERVISOR_dom0_op(&op);
> +	ret = HYPERVISOR_dom0_op(&op);
> +	if (ret)
> +		return ret;
> +
> +	/* Set the hardware RTC. */
> +	return mach_set_rtc_mmss(now);
> +
>   }
>   
>   static struct clocksource xen_clocksource __read_mostly = {

