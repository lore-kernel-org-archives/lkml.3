Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752223AbaBCJl7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 04:41:59 -0500
Received: from zoneX.GCU-Squad.org ([194.213.125.0]:12990 "EHLO
	services.gcu-squad.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751443AbaBCJl6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 04:41:58 -0500
Date: Mon, 3 Feb 2014 10:41:41 +0100
From: Jean Delvare <khali@linux-fr.org>
To: Mark Brown <broonie@kernel.org>
Cc: Liam Girdwood <lgirdwood@gmail.com>, linux-kernel@vger.kernel.org,
        linaro-kernel@lists.linaro.org, Guenter Roeck <linux@roeck-us.net>,
        Mark Brown <broonie@linaro.org>
Subject: Re: [PATCH] regulator: core: Correct default return value for full
 constraints
Message-ID: <20140203104141.40cc04e5@endymion.delvare>
In-Reply-To: <1390846075-17415-1-git-send-email-broonie@kernel.org>
References: <1390846075-17415-1-git-send-email-broonie@kernel.org>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-suse-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Liam,

Can you please review / apply this patch? It fixes a real bug. I also
think it should go to the 3.13-stable tree.

Thanks,
Jean

On Mon, 27 Jan 2014 18:07:55 +0000, Mark Brown wrote:
> From: Mark Brown <broonie@linaro.org>
> 
> Once we have full constraints then all supply mappings should be known to
> the regulator API. This means that we should treat failed lookups as fatal
> rather than deferring in the hope of further registrations but this was
> broken by commit 9b92da1f1205bd25 "regulator: core: Fix default return
> value for _get()" which was targeted at DT systems but unintentionally
> broke non-DT systems by changing the default return value.
> 
> Fix this by explicitly returning -EPROBE_DEFER from the DT lookup if we
> find a property but no corresponding regulator and by having the non-DT
> case default to -ENODEV when we have full constraints.
> 
> Fixes: 9b92da1f1205bd25 "regulator: core: Fix default return value for _get()"
> Signed-off-by: Mark Brown <broonie@linaro.org>
> ---
>  drivers/regulator/core.c | 9 ++++++++-
>  1 file changed, 8 insertions(+), 1 deletion(-)
> 
> diff --git a/drivers/regulator/core.c b/drivers/regulator/core.c
> index b38a6b669e8c..16a309e5c024 100644
> --- a/drivers/regulator/core.c
> +++ b/drivers/regulator/core.c
> @@ -1272,6 +1272,8 @@ static struct regulator_dev *regulator_dev_lookup(struct device *dev,
>  				if (r->dev.parent &&
>  					node == r->dev.of_node)
>  					return r;
> +			*ret = -EPROBE_DEFER;
> +			return NULL;
>  		} else {
>  			/*
>  			 * If we couldn't even get the node then it's
> @@ -1312,7 +1314,7 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  	struct regulator_dev *rdev;
>  	struct regulator *regulator = ERR_PTR(-EPROBE_DEFER);
>  	const char *devname = NULL;
> -	int ret = -EPROBE_DEFER;
> +	int ret;
>  
>  	if (id == NULL) {
>  		pr_err("get() with no identifier\n");
> @@ -1322,6 +1324,11 @@ static struct regulator *_regulator_get(struct device *dev, const char *id,
>  	if (dev)
>  		devname = dev_name(dev);
>  
> +	if (have_full_constraints())
> +		ret = -ENODEV;
> +	else
> +		ret = -EPROBE_DEFER;
> +
>  	mutex_lock(&regulator_list_mutex);
>  
>  	rdev = regulator_dev_lookup(dev, id, &ret);


-- 
Jean Delvare
