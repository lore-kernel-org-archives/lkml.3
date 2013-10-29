Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754320Ab3J2LPL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Oct 2013 07:15:11 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:37026 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751497Ab3J2LPI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Oct 2013 07:15:08 -0400
Message-ID: <526F98BD.9000904@cogentembedded.com>
Date: Tue, 29 Oct 2013 15:15:09 +0400
From: Sergei Shtylyov <sergei.shtylyov@cogentembedded.com>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:24.0) Gecko/20100101 Thunderbird/24.0.1
MIME-Version: 1.0
To: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>,
        linux-arm-kernel@lists.infradead.org
CC: linux-sh@vger.kernel.org, Mike Turquette <mturquette@linaro.org>,
        Daniel Lezcano <daniel.lezcano@linaro.org>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 02/12] clocksource: sh_mtu2: Add clk_prepare/unprepare
 support
References: <1383000569-8916-1-git-send-email-laurent.pinchart+renesas@ideasonboard.com> <1383000569-8916-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
In-Reply-To: <1383000569-8916-3-git-send-email-laurent.pinchart+renesas@ideasonboard.com>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello.

On 29-10-2013 2:49, Laurent Pinchart wrote:

> Prepare the clock at probe time, as there is no other appropriate place
> in the driver where we're allowed to sleep.

> Cc: Daniel Lezcano <daniel.lezcano@linaro.org>
> Cc: linux-kernel@vger.kernel.org
> Signed-off-by: Laurent Pinchart <laurent.pinchart+renesas@ideasonboard.com>
> ---
>   drivers/clocksource/sh_mtu2.c | 16 ++++++++++++++--
>   1 file changed, 14 insertions(+), 2 deletions(-)

> diff --git a/drivers/clocksource/sh_mtu2.c b/drivers/clocksource/sh_mtu2.c
> index 4aac9ee..3cf1283 100644
> --- a/drivers/clocksource/sh_mtu2.c
> +++ b/drivers/clocksource/sh_mtu2.c
> @@ -313,8 +313,20 @@ static int sh_mtu2_setup(struct sh_mtu2_priv *p, struct platform_device *pdev)
>   		goto err1;
>   	}
>
> -	return sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
> -				cfg->clockevent_rating);
> +	ret = clk_prepare(p->clk);
> +	if (ret < 0)
> +		goto err2;
> +
> +	ret = sh_mtu2_register(p, (char *)dev_name(&p->pdev->dev),
> +			       cfg->clockevent_rating);
> +	if (ret < 0)
> +		goto err3;
> +
> +	return 0;
> + err3:
> +	clk_unprepare(p->clk);
> + err2:
> +	clk_put(p->clk);

    This one seems to be a fix and so needs to be in a separate patch...

WBR, Sergei

