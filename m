Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752581Ab3DLBif (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Apr 2013 21:38:35 -0400
Received: from mga03.intel.com ([143.182.124.21]:25779 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752044Ab3DLBie (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Apr 2013 21:38:34 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,459,1363158000"; 
   d="scan'208";a="226231279"
Message-ID: <1365730710.2183.26.camel@rzhang1-mobl4>
Subject: Re: [PATCH] Thermal: Don't resolve THERMAL_NO_LIMIT to max_state.
From: Zhang Rui <rui.zhang@intel.com>
To: Yuxuan Shui <yshuiv7@gmail.com>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        Amit Kachhap <amit.kachhap@linaro.org>, durga <durgadoss.r@intel.com>,
        eduardo <eduardo.valentin@ti.com>
Date: Fri, 12 Apr 2013 09:38:30 +0800
In-Reply-To: <1364304589-24335-1-git-send-email-yshuiv7@gmail.com>
References: <1364304589-24335-1-git-send-email-yshuiv7@gmail.com>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.2.3-0ubuntu6 
Content-Transfer-Encoding: 7bit
Mime-Version: 1.0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 2013-03-26 at 21:29 +0800, Yuxuan Shui wrote:
> max_state may change at runtime, for example, when loading/unloading
> cpufreq policy.
> 
this seems to be a problem that we have not covered yet.

when loading/unloading the cpufreq policy, the cpufreq_frequency_table
will be changed as well, right?
what if we want to use p4 for trip point 2, and then there are only two
valid entries after reloading cpufreq policy?

To me, the real thing we missed here is a mechanism for dynamic
binding. 

thanks,
rui

> Signed-off-by: Yuxuan Shui <yshuiv7@gmail.com>
> ---
>  drivers/thermal/step_wise.c   | 11 ++++++++---
>  drivers/thermal/thermal_sys.c |  5 ++---
>  2 files changed, 10 insertions(+), 6 deletions(-)
> 
> diff --git a/drivers/thermal/step_wise.c b/drivers/thermal/step_wise.c
> index 407cde3..2edb7e9 100644
> --- a/drivers/thermal/step_wise.c
> +++ b/drivers/thermal/step_wise.c
> @@ -54,18 +54,23 @@ static unsigned long get_target_state(struct thermal_instance *instance,
>  {
>  	struct thermal_cooling_device *cdev = instance->cdev;
>  	unsigned long cur_state;
> +	unsigned long max_state;
> +	int upper;
>  
>  	cdev->ops->get_cur_state(cdev, &cur_state);
> +	cdev->ops->get_max_state(cdev, &max_state);
> +
> +	upper = instance->upper == THERMAL_NO_LIMIT ? max_state : instance->upper;
>  
>  	switch (trend) {
>  	case THERMAL_TREND_RAISING:
>  		if (throttle)
> -			cur_state = cur_state < instance->upper ?
> -				    (cur_state + 1) : instance->upper;
> +			cur_state = cur_state < upper ?
> +				    (cur_state + 1) : upper;
>  		break;
>  	case THERMAL_TREND_RAISE_FULL:
>  		if (throttle)
> -			cur_state = instance->upper;
> +			cur_state = upper;
>  		break;
>  	case THERMAL_TREND_DROPPING:
>  		if (cur_state == instance->lower) {
> diff --git a/drivers/thermal/thermal_sys.c b/drivers/thermal/thermal_sys.c
> index 5b7863a..f02e4d4 100644
> --- a/drivers/thermal/thermal_sys.c
> +++ b/drivers/thermal/thermal_sys.c
> @@ -1134,11 +1134,10 @@ int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
>  
>  	cdev->ops->get_max_state(cdev, &max_state);
>  
> -	/* lower default 0, upper default max_state */
> +	/* lower default 0 */
>  	lower = lower == THERMAL_NO_LIMIT ? 0 : lower;
> -	upper = upper == THERMAL_NO_LIMIT ? max_state : upper;
>  
> -	if (lower > upper || upper > max_state)
> +	if (lower > upper || (upper != THERMAL_NO_LIMIT && upper > max_state))
>  		return -EINVAL;
>  
>  	dev =


