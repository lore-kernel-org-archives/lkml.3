Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752411Ab3DRSFm (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 14:05:42 -0400
Received: from mail-da0-f50.google.com ([209.85.210.50]:36014 "EHLO
	mail-da0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751731Ab3DRSFl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 14:05:41 -0400
From: Kevin Hilman <khilman@linaro.org>
To: Sourav Poddar <sourav.poddar@ti.com>
Cc: <gregkh@linuxfoundation.org>, <tony@atomide.com>,
        <rmk+kernel@arm.linux.org.uk>, <linux-serial@vger.kernel.org>,
        <linux-omap@vger.kernel.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH 4/6] arm: mach-omap2: remove "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check
References: <1366198467-6757-1-git-send-email-sourav.poddar@ti.com>
	<1366198467-6757-5-git-send-email-sourav.poddar@ti.com>
Date: Thu, 18 Apr 2013 11:05:37 -0700
In-Reply-To: <1366198467-6757-5-git-send-email-sourav.poddar@ti.com> (Sourav
	Poddar's message of "Wed, 17 Apr 2013 17:04:25 +0530")
Message-ID: <87li8f4sum.fsf@linaro.org>
User-Agent: Gnus/5.13 (Gnus v5.13) Emacs/24.1 (gnu/linux)
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Sourav Poddar <sourav.poddar@ti.com> writes:

> Remove the "OMAP_DEVICE_NO_IDLE_ON_SUSPEND" check, since UART was the only one making
> use of it. Now serial core/driver takes care of the case when "no_console_suspend" 
> is used in the bootargs and you need to keep the clock enable for console even while suspend.
>
> Signed-off-by: Sourav Poddar <sourav.poddar@ti.com>

NAK.  This patch will break many things...

> ---
>  arch/arm/mach-omap2/omap_device.c |    7 +------
>  1 files changed, 1 insertions(+), 6 deletions(-)
>
> diff --git a/arch/arm/mach-omap2/omap_device.c b/arch/arm/mach-omap2/omap_device.c
> index 381be7a..d6dce8f 100644
> --- a/arch/arm/mach-omap2/omap_device.c
> +++ b/arch/arm/mach-omap2/omap_device.c
> @@ -620,11 +620,8 @@ static int _od_suspend_noirq(struct device *dev)
>  	ret = pm_generic_suspend_noirq(dev);
>  
>  	if (!ret && !pm_runtime_status_suspended(dev)) {
> -		if (pm_generic_runtime_suspend(dev) == 0) {
> -			if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
> -				omap_device_idle(pdev);

Why did you remove the omap_device_idle() here?

> +		if (pm_generic_runtime_suspend(dev) == 0)
>  			od->flags |= OMAP_DEVICE_SUSPENDED;
> -		}
>  	}
>  
>  	return ret;
> @@ -638,8 +635,6 @@ static int _od_resume_noirq(struct device *dev)
>  	if ((od->flags & OMAP_DEVICE_SUSPENDED) &&
>  	    !pm_runtime_status_suspended(dev)) {
>  		od->flags &= ~OMAP_DEVICE_SUSPENDED;
> -		if (!(od->flags & OMAP_DEVICE_NO_IDLE_ON_SUSPEND))
> -			omap_device_enable(pdev);

And the _enable() here?

>  		pm_generic_runtime_resume(dev);
>  	}

Note that the check is for when the flag is *not* set, so this patch
changes behavior for all the drivers that do not use
_NO_IDLE_ON_SUSPEND.  I think that's the opposite of what you intended.

Kevin
