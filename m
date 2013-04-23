Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756139Ab3DWKvl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Apr 2013 06:51:41 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:49214 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755164Ab3DWKvj (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Apr 2013 06:51:39 -0400
Date: Tue, 23 Apr 2013 11:51:35 +0100
From: Luis Henriques <luis.henriques@canonical.com>
To: Jonghwan Choi <jhbird.choi@samsung.com>
Cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        "'Andrzej Hajda'" <a.hajda@samsung.com>,
        "'Liam Girdwood'" <lrg@ti.com>,
        "'Mark Brown'" <broonie@opensource.wolfsonmicro.com>
Subject: Re: [PATCH 3.8-stable] regulator: fixed regulator_bulk_enable
 unwinding code
Message-ID: <20130423105135.GD3471@hercules>
References: <006f01ce3fce$25072080$6f156180$%choi@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <006f01ce3fce$25072080$6f156180$%choi@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Apr 23, 2013 at 11:56:25AM +0900, Jonghwan Choi wrote:
> 3.8-stable review patch.  If anyone has any objections, please let me know.

Thanks, I believe this is also applicable to 3.4.y and 3.5.y.

Cheers,
--
Luis

> 
> ------------------
> 
> From: "Andrzej Hajda <a.hajda@samsung.com>"
> 
> commit fbe31057fafebdc2811a7101b8b4a0460f5417d1 upstream.
> 
> Unwinding code disables all successfully enabled regulators.
> Error is logged for every failed regulator.
> 
> Signed-off-by: Andrzej Hajda <a.hajda@samsung.com>
> Signed-off-by: Kyungmin Park <kyungmin.park@samsung.com>
> Signed-off-by: Mark Brown <broonie@opensource.wolfsonmicro.com>
> Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
> ---
>  drivers/regulator/core.c |   10 +++++++---
>  1 file changed, 7 insertions(+), 3 deletions(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index 5a0f54a..e56185b 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -3032,9 +3032,13 @@ int regulator_bulk_enable(int num_consumers,
>  	return 0;
>  
>  err:
> -	pr_err("Failed to enable %s: %d\n", consumers[i].supply, ret);
> -	while (--i >= 0)
> -		regulator_disable(consumers[i].consumer);
> +	for (i = 0; i < num_consumers; i++) {
> +		if (consumers[i].ret < 0)
> +			pr_err("Failed to enable %s: %d\n",
> consumers[i].supply,
> +			       consumers[i].ret);
> +		else
> +			regulator_disable(consumers[i].consumer);
> +	}
>  
>  	return ret;
>  }
> -- 
> 1.7.9.5
> 
> --
> To unsubscribe from this list: send the line "unsubscribe stable" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
