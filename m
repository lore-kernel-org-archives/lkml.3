Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757047Ab3KHKKl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 05:10:41 -0500
Received: from mail-bk0-f46.google.com ([209.85.214.46]:64177 "EHLO
	mail-bk0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753051Ab3KHKKe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 05:10:34 -0500
Message-ID: <527CB897.8070107@linaro.org>
Date: Fri, 08 Nov 2013 11:10:31 +0100
From: Daniel Lezcano <daniel.lezcano@linaro.org>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.0
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
CC: linux-sh@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH v2 1/2] clocksource: sh_tmu: Release clock when sh_tmu_register()
 fails
References: <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383057097-22689-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1383057097-22689-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=UTF-8; format=flowed
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 10/29/2013 03:31 PM, Laurent Pinchart wrote:
> Fix the probe error path to release the clock resource when the
> sh_tmu_register() call fails.
>
> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>

Applied in my tree as 3.13 fixes

> ---
>   drivers/clocksource/sh_tmu.c | 13 ++++++++++---
>   1 file changed, 10 insertions(+), 3 deletions(-)
>
> diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
> index 78b8dae..1597837 100644
> --- a/drivers/clocksource/sh_tmu.c
> +++ b/drivers/clocksource/sh_tmu.c
> @@ -475,9 +475,16 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
>   	p->cs_enabled = false;
>   	p->enable_count = 0;
>
> -	return sh_tmu_register(p, (char *)dev_name(&p->pdev->dev),
> -			       cfg->clockevent_rating,
> -			       cfg->clocksource_rating);
> +	ret = sh_tmu_register(p, (char *)dev_name(&p->pdev->dev),
> +			      cfg->clockevent_rating,
> +			      cfg->clocksource_rating);
> +	if (ret < 0)
> +		goto err2;
> +
> +	return 0;
> +
> + err2:
> +	clk_put(p->clk);
>    err1:
>   	iounmap(p->mapbase);
>    err0:
>


-- 
  <http://www.linaro.org/> Linaro.org │ Open source software for ARM SoCs

Follow Linaro:  <http://www.facebook.com/pages/Linaro> Facebook |
<http://twitter.com/#!/linaroorg> Twitter |
<http://www.linaro.org/linaro-blog/> Blog

