Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753419Ab3A1Tix (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 14:38:53 -0500
Received: from wolverine02.qualcomm.com ([199.106.114.251]:22911 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751573Ab3A1Tiv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 14:38:51 -0500
X-IronPort-AV: E=Sophos;i="4.84,554,1355126400"; 
   d="scan'208";a="22862729"
Message-ID: <5106D3CA.4030203@codeaurora.org>
Date: Mon, 28 Jan 2013 11:38:50 -0800
From: Stephen Boyd <sboyd@codeaurora.org>
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:17.0) Gecko/17.0 Thunderbird/17.0
MIME-Version: 1.0
To: Mark Brown <broonie@opensource.wolfsonmicro.com>
CC: linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/2] regmap: spi: Support asynchronous I/O for SPI
References: <1359295954-5209-1-git-send-email-broonie@opensource.wolfsonmicro.com> <1359295954-5209-2-git-send-email-broonie@opensource.wolfsonmicro.com>
In-Reply-To: <1359295954-5209-2-git-send-email-broonie@opensource.wolfsonmicro.com>
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 01/27/13 06:12, Mark Brown wrote:
> diff --git a/drivers/base/regmap/regmap-spi.c b/drivers/base/regmap/regmap-spi.c
> index ffa46a9..bb19592 100644
> --- a/drivers/base/regmap/regmap-spi.c
> +++ b/drivers/base/regmap/regmap-spi.c
> @@ -15,6 +15,21 @@
>  #include <linux/init.h>
>  #include <linux/module.h>
>  
> +#include "internal.h"
> +
> +struct regmap_async_spi {
> +	struct regmap_async core;
> +	struct spi_message m;
> +	struct spi_transfer t[2];
> +};
> +
> +static void regmap_spi_complete(void *data)
> +{
> +	struct regmap_async_spi *async = data;
> +
> +	regmap_async_complete_cb(&async->core, async->m.status);
> +}
> +
>  static int regmap_spi_write(void *context, const void *data, size_t count)
>  {
>  	struct device *dev = context;
> @@ -40,6 +55,30 @@ static int regmap_spi_gather_write(void *context,
>  	return spi_sync(spi, &m);
>  }
>  
> +static int regmap_spi_async_write(void *context,
> +				  const void *reg, size_t reg_len,
> +				  const void *val, size_t val_len,
> +				  struct regmap_async *a)
> +{
> +	struct regmap_async_spi *async = (void *)a;

Can you use container_of() here?

-- 
Qualcomm Innovation Center, Inc. is a member of Code Aurora Forum,
hosted by The Linux Foundation

