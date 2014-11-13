Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753549AbaKMBMt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 12 Nov 2014 20:12:49 -0500
Received: from v094114.home.net.pl ([79.96.170.134]:51510 "HELO
	v094114.home.net.pl" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752830AbaKMBMs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 12 Nov 2014 20:12:48 -0500
From: "Rafael J. Wysocki" <rjw@rjwysocki.net>
To: Grygorii Strashko <grygorii.strashko@ti.com>
Cc: Len Brown <len.brown@intel.com>, Pavel Machek <pavel@ucw.cz>,
        linux-pm@vger.kernel.org, Ulf Hansson <ulf.hansson@linaro.org>,
        khilman@linaro.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org, k.kozlowski@samsung.com
Subject: Re: [PATCH] PM / Domains: restore calling of .suspend/resume_noirq() callbacks
Date: Thu, 13 Nov 2014 02:33:42 +0100
Message-ID: <2997289.NEH22PNoYM@vostro.rjw.lan>
User-Agent: KMail/4.11.5 (Linux/3.16.0-rc5+; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1415808047-23455-1-git-send-email-grygorii.strashko@ti.com>
References: <1415808047-23455-1-git-send-email-grygorii.strashko@ti.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="utf-8"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday, November 12, 2014 06:00:47 PM Grygorii Strashko wrote:
> Now .suspend/resume_noirq() callbacks will not be called during
> system wide suspend/resume for devices which belongs to some GPD.
> It seems, that this change was accidently introduced by
> commit d23b9b00cdde ("PM / Domains: Rework system suspend callback
>  routines (v2)").

I'm not sure if that was really accidentally.

Can you describe the problem that the change below is attempting to
address, without going to much into the history?  IOW, what's that
doesn't work right now?

> This patch restores calling of .suspend/resume_noirq() callbacks
> for devices from GPD during system wide suspend/resume.
> 
> Signed-off-by: Grygorii Strashko <grygorii.strashko@ti.com>
> ---
>  drivers/base/power/domain.c | 14 +++++++++++---
>  1 file changed, 11 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/base/power/domain.c b/drivers/base/power/domain.c
> index fb83d4a..f8c70e6 100644
> --- a/drivers/base/power/domain.c
> +++ b/drivers/base/power/domain.c
> @@ -1014,6 +1014,7 @@ static int pm_genpd_suspend_late(struct device *dev)
>  static int pm_genpd_suspend_noirq(struct device *dev)
>  {
>  	struct generic_pm_domain *genpd;
> +	int ret;
>  
>  	dev_dbg(dev, "%s()\n", __func__);
>  
> @@ -1021,8 +1022,14 @@ static int pm_genpd_suspend_noirq(struct device *dev)
>  	if (IS_ERR(genpd))
>  		return -EINVAL;
>  
> -	if (genpd->suspend_power_off
> -	    || (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev)))
> +	if (genpd->suspend_power_off)
> +		return 0;
> +
> +	ret = pm_generic_suspend_noirq(dev);
> +	if (ret)
> +		return ret;
> +
> +	if (dev->power.wakeup_path && genpd_dev_active_wakeup(genpd, dev))
>  		return 0;
>  
>  	genpd_stop_dev(genpd, dev);
> @@ -1065,8 +1072,9 @@ static int pm_genpd_resume_noirq(struct device *dev)
>  	 */
>  	pm_genpd_sync_poweron(genpd);
>  	genpd->suspended_count--;
> +	genpd_start_dev(genpd, dev);
>  
> -	return genpd_start_dev(genpd, dev);
> +	return pm_generic_resume_noirq(dev);
>  }
>  
>  /**
> 

-- 
I speak only for myself.
Rafael J. Wysocki, Intel Open Source Technology Center.
