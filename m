Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752573AbaBKMVz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Feb 2014 07:21:55 -0500
Received: from mail-wi0-f179.google.com ([209.85.212.179]:41940 "EHLO
	mail-wi0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751929AbaBKMVx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Feb 2014 07:21:53 -0500
Date: Tue, 11 Feb 2014 12:21:46 +0000
From: Lee Jones <lee.jones@linaro.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Sangbeom Kim <sbkim73@samsung.com>, Samuel Ortiz <sameo@linux.intel.com>,
        linux-kernel@vger.kernel.org, linux-samsung-soc@vger.kernel.org,
        Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        stable@vger.kernel.org
Subject: Re: [PATCH 1/7] mfd: 88pm860x: Fix possible NULL pointer dereference
 on i2c_new_dummy error
Message-ID: <20140211122146.GP32042@lee--X1>
References: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <1392113015-11180-1-git-send-email-k.kozlowski@samsung.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 11 Feb 2014, Krzysztof Kozlowski wrote:

> During probe the driver allocates dummy I2C device for companion chip
> with i2c_new_dummy() but it does not check the return value of this call.
> 
> In case of error (i2c_new_device(): memory allocation failure or I2C
> address cannot be used) this function returns NULL which is later used
> by regmap_init_i2c().
> 
> If i2c_new_dummy() fails for companion device, fail also the probe for
> main MFD driver.
> 
> Signed-off-by: Krzysztof Kozlowski <k.kozlowski@samsung.com>
> Cc: stable@vger.kernel.org
> ---
>  drivers/mfd/88pm860x-core.c |    5 +++++
>  1 file changed, 5 insertions(+)
> 
> diff --git a/drivers/mfd/88pm860x-core.c b/drivers/mfd/88pm860x-core.c
> index c9b1f6422941..e456be9a7c67 100644
> --- a/drivers/mfd/88pm860x-core.c
> +++ b/drivers/mfd/88pm860x-core.c
> @@ -1179,6 +1179,11 @@ static int pm860x_probe(struct i2c_client *client,
>  		chip->companion_addr = pdata->companion_addr;
>  		chip->companion = i2c_new_dummy(chip->client->adapter,
>  						chip->companion_addr);
> +		if (!chip->companion) {
> +			dev_err(&client->dev,
> +				"Failed to allocate I2C companion device\n");
> +			return -ENODEV;
> +		}
>  		chip->regmap_companion = regmap_init_i2c(chip->companion,
>  							&pm860x_regmap_config);
>  		if (IS_ERR(chip->regmap_companion)) {

Applied, thanks.

-- 
Lee Jones
Linaro STMicroelectronics Landing Team Lead
Linaro.org │ Open source software for ARM SoCs
Follow Linaro: Facebook | Twitter | Blog
