Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755656Ab3ENRYN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 13:24:13 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:41031 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751530Ab3ENRYM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 13:24:12 -0400
Message-ID: <51927339.5070402@linaro.org>
Date: Tue, 14 May 2013 10:24:09 -0700
From: John Stultz <john.stultz@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130404 Thunderbird/17.0.5
MIME-Version: 1.0
To: David Vrabel <david.vrabel@citrix.com>
CC: xen-devel@lists.xen.org, Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Thomas Gleixner <tglx@linutronix.de>, linux-kernel@vger.kernel.org
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

Sorry, just noticed one more thing while applying this. Do all Xen 
systems run on hardware that has the conventional CMOS clock?

What happens if the bare-metal needs to use efi_set_rtc() or 
vrtc_set_mmss() ?

thanks
-john


