Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751446AbaHOQSB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Aug 2014 12:18:01 -0400
Received: from avon.wwwdotorg.org ([70.85.31.133]:39685 "EHLO
	avon.wwwdotorg.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750954AbaHOQR7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Aug 2014 12:17:59 -0400
Message-ID: <53EE32C7.6000500@wwwdotorg.org>
Date: Fri, 15 Aug 2014 10:18:15 -0600
From: Stephen Warren <swarren@wwwdotorg.org>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Thunderbird/31.0
MIME-Version: 1.0
To: Mikko Perttunen <mperttunen@nvidia.com>, ldewangan@nvidia.com,
        wsa@the-dreams.de, thierry.reding@gmail.com
CC: pdeschrijver@nvidia.com, linux-i2c@vger.kernel.org,
        linux-tegra@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] i2c: i2c-tegra: Move clk_prepare/clk_set_rate to probe
References: <1408096034-17270-1-git-send-email-mperttunen@nvidia.com>
In-Reply-To: <1408096034-17270-1-git-send-email-mperttunen@nvidia.com>
Content-Type: text/plain; charset=windows-1252; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 08/15/2014 03:47 AM, Mikko Perttunen wrote:
> Currently the i2c-tegra bus driver prepares, enables
> and set_rates its clocks separately for each transfer.
> This causes locking problems when doing I2C transfers
> from clock notifiers; see
> http://lists.infradead.org/pipermail/linux-arm-kernel/2014-July/268653.html
>
> This patch moves clk_prepare/unprepare and clk_set_rate calls to
> the probe function, leaving only clk_enable/disable to be
> done on each transfer. This solves the locking issue.

> diff --git a/drivers/i2c/busses/i2c-tegra.c b/drivers/i2c/busses/i2c-tegra.c

> @@ -380,34 +380,33 @@ static inline int tegra_i2c_clock_enable(struct tegra_i2c_dev *i2c_dev)
>   {
>   	int ret;
>   	if (!i2c_dev->hw->has_single_clk_source) {
> -		ret = clk_prepare_enable(i2c_dev->fast_clk);
> +		ret = clk_enable(i2c_dev->fast_clk);

Here, both the prepare and enable wrap just the I2C transfer, ...

> @@ -428,9 +427,6 @@ static int tegra_i2c_init(struct tegra_i2c_dev *i2c_dev)
>   	i2c_writel(i2c_dev, val, I2C_CNFG);
>   	i2c_writel(i2c_dev, 0, I2C_INT_MASK);
>
> -	clk_multiplier *= (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
> -	clk_set_rate(i2c_dev->div_clk, i2c_dev->bus_clk_rate * clk_multiplier);

... whereas the rate is set up when the controller is initialized, i.e. 
much earlier.

> @@ -777,17 +774,39 @@ static int tegra_i2c_probe(struct platform_device *pdev)

> +	if (!i2c_dev->hw->has_single_clk_source) {
> +		ret = clk_prepare(i2c_dev->fast_clk);
> +		if (ret < 0) {
> +			dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
> +			return ret;
> +		}
> +	}
> +
> +	ret = clk_prepare(i2c_dev->div_clk);
> +	if (ret < 0) {
> +		dev_err(i2c_dev->dev, "Clock prepare failed %d\n", ret);
> +		goto unprepare_fast_clk;
> +	}
> +
> +	clk_multiplier *= (i2c_dev->hw->clk_divisor_std_fast_mode + 1);
> +	ret = clk_set_rate(i2c_dev->div_clk,
> +			   i2c_dev->bus_clk_rate * clk_multiplier);
> +	if (ret) {
> +		dev_err(i2c_dev->dev, "Clock rate change failed %d\n", ret);
> +		goto unprepare_div_clk;
> +	}

However, the new code sets the clock rate after the clock is prepared. I 
think the rate should be set first, then the clock prepared. While this 
likely doesn't apply to the Tegra clock controller, prepare() is allowed 
to enable the clock if enable() can't be implemented in an atomic 
fashion (in which case enable/disable would be no-ops), and we should 
make sure that the driver correctly configures the clock before 
potentially enabling it.

I'm not sure if a similar change to our SPI drivers is possible; after 
all, the SPI transfer rate can vary per message, so if clk_set_rate() 
acquires a lock, it seems there's no way to avoid the issue there. 
Luckily, we don't have any SPI-based chips that do anything related to 
clocks on any of our current boards...

Aside from this issue, the patch looks fine to me.
