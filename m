Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756307Ab3KGXo4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 18:44:56 -0500
Received: from mail-pd0-f179.google.com ([209.85.192.179]:39147 "EHLO
	mail-pd0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753524Ab3KGXoh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 18:44:37 -0500
From: Kevin Hilman <khilman@linaro.org>
To: Nishanth Menon <nm@ti.com>
Cc: Tony Lindgren <tony@atomide.com>, <paul@pwsan.com>, <rnayak@ti.com>,
        <linux-omap@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] ARM: OMAP2+: omap_device: maintain sane runtime pm status around suspend/resume
References: <1383857942-23630-1-git-send-email-nm@ti.com>
Date: Thu, 07 Nov 2013 15:44:33 -0800
In-Reply-To: <1383857942-23630-1-git-send-email-nm@ti.com> (Nishanth Menon's
	message of "Thu, 7 Nov 2013 14:59:01 -0600")
Message-ID: <87iow3rd3y.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Nishanth Menon <nm@ti.com> writes:

> OMAP device hooks around suspend|resume_noirq ensures that hwmod
> devices are forced to idle using omap_device_idle/enable as part of
> the last stage of suspend activity.
>
> For a device such as i2c who uses autosuspend, it is possible to enter
> the suspend path with dev->power.runtime_status = RPM_ACTIVE.
>
> As part of the suspend flow, the generic runtime logic would increment
> it's dev->power.disable_depth to 1. This should prevent further
> pm_runtime_get_sync from succeeding once the runtime_status has been
> set to RPM_SUSPENDED.
>
> Now, as part of the suspend_noirq handler in omap_device, we force the
> following: if the device status is !suspended, we force the device
> to idle using omap_device_idle (clocks are cut etc..). This ensures
> that from a hardware perspective, the device is "suspended". However,
> runtime_status is left to be active.
>
> *if* an operation is attempted after this point to
> pm_runtime_get_sync, runtime framework depends on runtime_status to
> indicate accurately the device status, and since it sees it to be
> ACTIVE, it assumes the module is functional and returns a non-error
> value. As a result the user will see pm_runtime_get succeed, however a
> register access will crash due to the lack of clocks.

Ouch.

Dumb Q: who is requesting an i2c transaction after ->suspend_noirq().
The i2c driver itself should be able to detect that it's being accessed
after this point and return an error.

That being said, I agree that omap_device should still be catching this
case in order to find/fix driver races like this.

> To prevent this from happening, we should ensure that runtime_status
> exactly indicates the device status. As a result of this change
> any further calls to pm_runtime_get* would return -EACCES (since
> disable_depth is 1). On resume, we restore the clocks and runtime
> status exactly as we suspended with.
>
> Reported-by: J Keerthy <j-keerthy@ti.com>
> Signed-off-by: Nishanth Menon <nm@ti.com>
> Acked-by: Rajendra Nayak <rnayak@ti.com>
> ---
> patch baseline: V3.12 tag (also applies on linux-next next-20131107 tag)
>
> Logs from 3.12 based vendor kernel:
> Before: http://pastebin.com/m5KxnB7a
> After: http://pastebin.com/8AfX4e7r
>
> The discussion on cpufreq side of the story which triggered this scenario:
> 	http://marc.info/?l=linux-pm&m=138263811321921&w=2
>
> Tested on TI vendor kernel (with dt boot):
> 	AM335x: evm, BBB, sk, BBW
> 	OMAP5uEVM, DRA7-evm
>
>  arch/arm/mach-omap2/omap_device.c |   16 ++++++++++++++--
>  arch/arm/mach-omap2/omap_device.h |    1 +
>  2 files changed, 15 insertions(+), 2 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> index b69dd9a..87ecbb0 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -621,6 +621,13 @@ static int _od_suspend_noirq(struct device *dev)
>  
>  	if (!ret && !pm_runtime_status_suspended(dev)) {
>  		if (pm_generic_runtime_suspend(dev) == 0) {
> +			if (!pm_runtime_suspended(dev)) {

Why the addition check for supended here?

This version (as opposed to the _status_suspended() version above will
fail if runtime PM has been disabled from userspace (via
/sys/devices/.../power/control), and will thus prevent low power states
from being hit in suspend if runtime suspend has been disabled from
userspace.  That's a bug.

> +				/* NOTE: *might* indicate driver race */

Yes, a driver race which should then be fixed in the driver.

> +				dev_dbg(dev, "%s: Force suspending\n",
> +					__func__);
> +				pm_runtime_set_suspended(dev);
> +				od->flags |= OMAP_DEVICE_SUSPEND_FORCED;

Not sure why you need an additonal flag.  Why not just always do this
and use the existin OMAP_DEVICE_SUSPENDED flag.

Kevin

> +			}
>  			omap_device_idle(pdev);
>  			od->flags |= OMAP_DEVICE_SUSPENDED;
>  		}
> @@ -634,10 +641,15 @@ static int _od_resume_noirq(struct device *dev)
>  	struct platform_device *pdev = to_platform_device(dev);
>  	struct omap_device *od = to_omap_device(pdev);
>  
> -	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
> -	    !pm_runtime_status_suspended(dev)) {
> +	if (od->flags & OMAP_DEVICE_SUSPENDED) {
>  		od->flags &= ~OMAP_DEVICE_SUSPENDED;
>  		omap_device_enable(pdev);
> +
> +		if (od->flags & OMAP_DEVICE_SUSPEND_FORCED) {
> +			pm_runtime_set_active(dev);
> +			od->flags &= ~OMAP_DEVICE_SUSPEND_FORCED;
> +		}
> +
>  		pm_generic_runtime_resume(dev);
>  	}
>  
> diff --git a/arch/arm/mach-omap2/omap_device.h b/arch/arm/mach-omap2/omap_device.h
> index 17ca1ae..45885b0 100644
> --- a/arch/arm/mach-omap2/omap_device.h
> +++ b/arch/arm/mach-omap2/omap_device.h
> @@ -38,6 +38,7 @@ extern struct dev_pm_domain omap_device_pm_domain;
>  
>  /* omap_device.flags values */
>  #define OMAP_DEVICE_SUSPENDED		BIT(0)
> +#define OMAP_DEVICE_SUSPEND_FORCED	BIT(1)
>  
>  /**
>   * struct omap_device - omap_device wrapper for platform_devices
