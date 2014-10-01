Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaJAT1I (ORCPT <rfc822;w@1wt.eu>);
	Wed, 1 Oct 2014 15:27:08 -0400
Received: from v094114.home.net.pl ([79.96.170.134]:54440 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1751185AbaJAT1G (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 1 Oct 2014 15:27:06 -0400
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Geert Uytterhoeven <geert+renesas@glider.be>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        Simon Horman <horms@verge.net.au>, Magnus Damm <magnus.damm@gmail.com>,
        Grygorii Strashko <grygorii.strashko@ti.com>,
        Ulf Hansson <ulf.hansson@linaro.org>, linux-pm@vger.kernel.org,
        linux-sh@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] PM / clock_ops: Fix crash in clocks management code if !CONFIG_PM_RUNTIME
Date: Wed, 01 Oct 2014 21:47:03 +0200
Message-ID: <23953734.KObJ4iLFUI@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1412188697-15317-1-git-send-email-geert+renesas@glider.be>
References: <1412188697-15317-1-git-send-email-geert+renesas@glider.be>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, October 01, 2014 08:38:17 PM Geert Uytterhoeven wrote:
> Unlike the clocks management code for runtime PM, the code used for
> system suspend does not check the pm_clock_entry.status field.
> If pm_clk_acquire() failed, ce->status will be PCE_STATUS_ERROR, and
> ce->clk will be a negative error code (e.g. 0xfffffffe = -2 = -ENOENT).
> 
> Depending on the clock implementation, suspend or resume may crash with:
> 
>     Unable to handle kernel NULL pointer dereference at virtual address 00000026
> 
> (CCF clk_disable() has an IS_ERR_OR_NULL() check, while CCF clk_enable()
>  only has a NULL check; pre-CCF implementations may behave differently)
> 
> While just checking for PCE_STATUS_ERROR would be sufficient, it doesn't
> hurt to use the same state machine as is done for runtime PM, as this
> makes the two versions more similar, and eligible for a future
> consolidation.
> 
> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
> ---
> This crash started to happen on armadillo-legacy during s2ram if
> CONFIG_PM_RUNTIME is not set after applying "[PATCH v2 07/11] ARM:
> shmobile: r8a7740/armadillo legacy: Add A4MP pm domain support"
> (http://www.spinics.net/linux/lists/arm-kernel/msg365438.html), as
> there's no NULL clock for the HDMI device.
> 
> Most existing code calling pm_clk_suspend()/pm_clk_resume() is protected
> by a check for CONFIG_PM_RUNTIME (davinci, keystone, omap1,
> drivers/sh/pm_runtime.c), so it was not affected by this bug.
> 
> Exceptions are:
>   - arch/arm/mach-shmobile/pm-r8a7779.c (marzen),
>   - arch/arm/mach-shmobile/pm-rmobile.c (r8a7740/armadillo and
>     sh7372/mackerel),
> but it's difficult to assess from the code whether the bug is really
> triggered on these platforms.
> 
> Grygorii Strashko's "[PATCH v1 2/4] ARM: keystone: pm: switch to use
> generic pm domains" is not affected, as pm_clk_add_clk() is only called
> for existing clocks.
> 
> If it crashes on marzen or mackerel, I think this fix needs to be
> applied to stable, too. I don't have access to marzen or mackerel boards,
> though.
> 
> How to test:
>   - Build a kernel with CONFIG_PM_SLEEP/CONFIG_SUSPEND enabled, but
>     CONFIG_PM_RUNTIME disabled,
>   - echo 0 > /sys/module/printk/parameters/console_suspend,
>   - echo mem > /sys/power/state,
>   - wake up using e.g. gpio-keys or serial console activity.

Do I think correctly that this would be 3.18 material?


> ---
>  drivers/base/power/clock_ops.c | 19 +++++++++++++++----
>  1 file changed, 15 insertions(+), 4 deletions(-)
> 
> diff --git a/drivers/base/power/clock_ops.c b/drivers/base/power/clock_ops.c
> index b99e6c06ee678ecb..78369305e0698109 100644
> --- a/drivers/base/power/clock_ops.c
> +++ b/drivers/base/power/clock_ops.c
> @@ -368,8 +368,13 @@ int pm_clk_suspend(struct device *dev)
>  
>  	spin_lock_irqsave(&psd->lock, flags);
>  
> -	list_for_each_entry_reverse(ce, &psd->clock_list, node)
> -		clk_disable(ce->clk);
> +	list_for_each_entry_reverse(ce, &psd->clock_list, node) {
> +		if (ce->status < PCE_STATUS_ERROR) {
> +			if (ce->status == PCE_STATUS_ENABLED)
> +				clk_disable(ce->clk);
> +			ce->status = PCE_STATUS_ACQUIRED;
> +		}
> +	}
>  
>  	spin_unlock_irqrestore(&psd->lock, flags);
>  
> @@ -385,6 +390,7 @@ int pm_clk_resume(struct device *dev)
>  	struct pm_subsys_data *psd = dev_to_psd(dev);
>  	struct pm_clock_entry *ce;
>  	unsigned long flags;
> +	int ret;
>  
>  	dev_dbg(dev, "%s()\n", __func__);
>  
> @@ -394,8 +400,13 @@ int pm_clk_resume(struct device *dev)
>  
>  	spin_lock_irqsave(&psd->lock, flags);
>  
> -	list_for_each_entry(ce, &psd->clock_list, node)
> -		__pm_clk_enable(dev, ce->clk);
> +	list_for_each_entry(ce, &psd->clock_list, node) {
> +		if (ce->status < PCE_STATUS_ERROR) {
> +			ret = __pm_clk_enable(dev, ce->clk);
> +			if (!ret)
> +				ce->status = PCE_STATUS_ENABLED;
> +		}
> +	}
>  
>  	spin_unlock_irqrestore(&psd->lock, flags);
>  
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
