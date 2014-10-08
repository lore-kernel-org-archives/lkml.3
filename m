Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756413AbaJHOxi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 10:53:38 -0400
Received: from mailout3.w1.samsung.com ([210.118.77.13]:25984 "EHLO
	mailout3.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753833AbaJHOxh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 10:53:37 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f4-b7f156d0000063c7-c2-54354fee37a9
Content-transfer-encoding: 8BIT
Message-id: <1412780013.31093.7.camel@AMDC1943>
Subject: Re: [PATCH v2 2/4] regulator: Set ena_gpio_initialized in regulator
 drivers
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Markus Pargmann <mpa@pengutronix.de>
Cc: Mark Brown <broonie@kernel.org>, Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        kernel@pengutronix.de
Date: Wed, 08 Oct 2014 16:53:33 +0200
In-reply-to: <1412776028-15655-3-git-send-email-mpa@pengutronix.de>
References: <1412776028-15655-1-git-send-email-mpa@pengutronix.de>
 <1412776028-15655-3-git-send-email-mpa@pengutronix.de>
X-Mailer: Evolution 3.10.4-0ubuntu2
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrKLMWRmVeSWpSXmKPExsVy+t/xq7rv/E1DDGb81LeY+vAJm8WqqTtZ
	LL5d6WCy2PT4GqvF5V1z2CxO3e5ld2Dz2DnrLrvHplWdbB6bl9R79P818Pi8SS6ANYrLJiU1
	J7MstUjfLoErY9fdCSwF2/gr5j9fxNzA+JGni5GTQ0LARGL3scssELaYxIV769m6GLk4hASW
	MkrsuPGEHSTBKyAo8WPyPaAiDg5mAXmJI5eyQcLMAuoSk+YtYoao/8wo8fjvciaIen2Jrdve
	g9nCAmESaydfA1vAJmAssXn5EjYQW0RAQ+L695Vgy5gFljNK/DtzHizBIqAqsXj7CWYQm1PA
	WWLz3DVgRwgJVEv0TZrODHKEhICyRGO/2wRGgVlIzpuFcN4sJOctYGRexSiaWppcUJyUnmuo
	V5yYW1yal66XnJ+7iRES1F92MC4+ZnWIUYCDUYmH16DZJESINbGsuDL3EKMEB7OSCC+/u2mI
	EG9KYmVValF+fFFpTmrxIUYmDk6pBkbPZY1PI0zWLy888rck9esR6zpf/8WW7DFHXPMc8vcq
	pXS43f9Q0xEhuOH8q4Y39nKSxwITVlYVWbZqXTFaHvvuV9r+2N916wyOXv/ItfjMQ+XvLE9v
	pXSt6xPtrmdg5HI6cyXyVtK6tc+DP7u2aS5ffqwiJqR6VYCrTw+v2kSWHea728/clFZiKc5I
	NNRiLipOBABaAsn5SAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On śro, 2014-10-08 at 15:47 +0200, Markus Pargmann wrote:
> This patch sets ena_gpio_initialized for all drivers which set a
> ena_gpio from parsed DT properties. Drivers using pdata may get zero
> initialized pdata and therefore copy a 0 into the regulator_config
> ena_gpio field.
> 
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>

(... rewind to s2m/s5m... I think Mark asked for splitting this per
driver)

> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index adab82d5279f..49b9e1ddc87e 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -897,6 +897,7 @@ common_reg:
>  			config.of_node = rdata[i].of_node;
>  		}
>  		config.ena_gpio = s2mps11->ext_control_gpio[i];
> +		config.ena_gpio_initialized = true;
>  
>  		regulator = devm_regulator_register(&pdev->dev,
>  						&regulators[i], &config);

Looks good.

> diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
> index 0ab5cbeeb797..7f176cdb7e37 100644
> --- a/drivers/regulator/s5m8767.c
> +++ b/drivers/regulator/s5m8767.c
> @@ -466,6 +466,7 @@ static void s5m8767_regulator_config_ext_control(struct s5m8767_info *s5m8767,
>  	}
>  
>  	config->ena_gpio = rdata->ext_control_gpio;
> +	config->ena_gpio_initialized = true;
>  	config->ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
>  }

It will work fine but a little messy. The 'config' is re-used in loop
for next regulators, so:
1. regulator X with GPIO=-ENODEV, ena_gpio_initialized=false
2. regulator X+1 with real GPIO, ena_gpio_initialized=true
3. regulator X+2 with GPIO=-ENODEV, ena_gpio_initialized=true


Instead do this in probe around line 950:
 config.ena_gpio = -EINVAL;
 config.ena_gpio_flags = 0;
+config->ena_gpio_initialized = true;
 if (gpio_is_valid(pdata->regulators[i].ext_control_gpio))
 	s5m8767_regulator_config_ext_control(s5m8767,
 			&pdata->regulators[i], &config);


Best regards,
Krzysztof

