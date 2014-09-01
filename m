Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754076AbaIAOrH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Sep 2014 10:47:07 -0400
Received: from opensource.wolfsonmicro.com ([80.75.67.52]:44389 "EHLO
	opensource.wolfsonmicro.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753815AbaIAOrE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Sep 2014 10:47:04 -0400
Date: Mon, 1 Sep 2014 15:47:00 +0100
From: Richard Fitzgerald <rf@opensource.wolfsonmicro.com>
To: broonie@kernel.org, lee.jones@linaro.org, sameo@linux.intel.com,
        lgirdwood@gmail.com, perex@perex.cz, tiwai@suse.de
Cc: alsa-devel@alsa-project.org, patches@opensource.wolfsonmicro.com,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 1/3 v4 RESEND] mfd: arizona: Export function to control
	subsystem DVFS
Message-ID: <20140901144700.GA18134@opensource.wolfsonmicro.com>
References: <20140808133233.GA2665@opensource.wolfsonmicro.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140808133233.GA2665@opensource.wolfsonmicro.com>
User-Agent: Mutt/1.5.17+20080114 (2008-01-14)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>  
> +
> +int arizona_dvfs_down(struct arizona *arizona, unsigned int flags)
> +{
> +	int ret = 0;
> +
> +	mutex_lock(&arizona->subsys_max_lock);
> +
> +	if ((arizona->subsys_max_rq & flags) != flags)
> +		dev_warn(arizona->dev, "Unbalanced DVFS down: %x\n", flags);

This warning is bogus and should be removed. These are just simple on/off bit
flags, not a reference count. If a requestor is already at the lower DVFS
state we just do nothing.

It was done this way to keep the code simple and lower risk. None of the
blocks that need to move the DVFS frequency up and down have multiple users
so they are simple either/or cases that don't currently reference count
themselves. So having a boolean flag to match the state of each block
keeps the change set smaller.

> +
> +	arizona->subsys_max_rq &= ~flags;
> +
> +	if (arizona->subsys_max_rq == 0) {
> +		switch (arizona->type) {
> +		case WM5102:
> +		case WM8997:
> +			ret = regmap_update_bits(arizona->regmap,
> +					ARIZONA_DYNAMIC_FREQUENCY_SCALING_1,
> +					ARIZONA_SUBSYS_MAX_FREQ, 0);
> +			if (ret != 0)
> +				dev_err(arizona->dev,
> +					"Failed to disable subsys max: %d\n",
> +					ret);
> +
> +			ret = regulator_set_voltage(arizona->dcvdd,
> +						    1200000, 1800000);
> +			if (ret != 0)
> +				dev_err(arizona->dev,
> +					"Failed to set DCVDD (DVFS down): %d\n",
> +					ret);
> +			break;
> +
> +		default:
> +			break;
> +		}
> +	}
> +
> +	mutex_unlock(&arizona->subsys_max_lock);
> +	return ret;
> +}
> +EXPORT_SYMBOL_GPL(arizona_dvfs_down);
> +
