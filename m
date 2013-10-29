Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754603Ab3J2LRC (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:17:02 -0400
Received: from mail-lb0-f170.google.com ([209.85.217.170]:61675 "EHLO
	mail-lb0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751634Ab3J2LRA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:17:00 -0400
Message-ID: <526F992D.2000309@cogentembedded.com>
Date: Tue, 29 Oct 2013 15:17:01 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
CC: linux-sh@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 03/12] clocksource: sh_tmu: Add clk_prepare/unprepare
 support
References: <1383000569-8916-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1383000569-8916-4-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 29-10-2013 2:49, Laurent Pinchart wrote:

> Prepare the clock at probe time, as there is no other appropriate place
> in the driver where we're allowed to sleep.

> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>   drivers/clocksource/sh_tmu.c | 20 +++++++++++++++++---
>   1 file changed, 17 insertions(+), 3 deletions(-)

> diff --git a/drivers/clocksource/sh_tmu.c b/drivers/clocksource/sh_tmu.c
> index 78b8dae..63557cd 100644
> --- a/drivers/clocksource/sh_tmu.c
> +++ b/drivers/clocksource/sh_tmu.c
> @@ -472,12 +472,26 @@ static int sh_tmu_setup(struct sh_tmu_priv *p, struct platform_device *pdev)
>   		ret = PTR_ERR(p->clk);
>   		goto err1;
>   	}
> +
> +	ret = clk_prepare(p->clk);
> +	if (ret < 0)
> +		goto err2;
> +
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
> +		goto err3;
> +
> +	return 0;
> +
> + err3:
> +	clk_unprepare(p->clk);
> + err2:
> +	clk_put(p->clk);

    This one seems to be a fix, and should be done separately.

WBR, Sergei

