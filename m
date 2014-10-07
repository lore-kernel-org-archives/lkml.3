Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753514AbaJGIqi (ORCPT <rfc822;w@1wt.eu>);
	Tue, 7 Oct 2014 04:46:38 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:57074 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753049AbaJGIqd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 7 Oct 2014 04:46:33 -0400
X-AuditID: cbfec7f4-b7f156d0000063c7-3c-5433a8667472
Message-id: <5433A863.1040206@samsung.com>
Date: Tue, 07 Oct 2014 10:46:27 +0200
From: =?UTF-8?B?S3J6eXN6dG9mIEtvesWCb3dza2k=?= <k.kozlowski@samsung.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101
 Thunderbird/31.1.2
MIME-version: 1.0
To: Markus Pargmann <mpa@pengutronix.de>, Mark Brown <broonie@kernel.org>
Cc: kernel@pengutronix.de, Liam Girdwood <lgirdwood@gmail.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH 2/5] regulator: Set ena_gpio_valid in regulator drivers
References: <1412626635-7404-1-git-send-email-mpa@pengutronix.de>
 <1412626635-7404-3-git-send-email-mpa@pengutronix.de>
In-reply-to: <1412626635-7404-3-git-send-email-mpa@pengutronix.de>
Content-type: text/plain; charset=UTF-8; format=flowed
Content-transfer-encoding: 7bit
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFtrPLMWRmVeSWpSXmKPExsVy+t/xy7ppK4xDDBb9UrOY+vAJm8XrF4YW
	q6buZLH4dqWDyWLT42usFpd3zWGzOHW7l92B3WPnrLvsHptWdbJ5bF5S79H/18Cjb8sqRo/P
	m+QC2KK4bFJSczLLUov07RK4Mu5MeM1U8Ia74vC6LsYGxnucXYwcHBICJhLfj0h2MXICmWIS
	F+6tZ+ti5OIQEljKKPFi9hEmkISQwGdGiYWPVEFsXgEtiaYT81lBbBYBVYlN+24wgthsAh4S
	0773MIPYogIREifv7mGHqBeU+DH5HguILSLgKbFu3V1WkAXMAi2MEjf3HwZbICzgLfHt/kZ2
	iGWVEovevwNr4BRwkrg4/QobiM0sYCbxqGUdM4QtL7F5zVvmCYwCs5DsmIWkbBaSsgWMzKsY
	RVNLkwuKk9JzDfWKE3OLS/PS9ZLzczcxQgL9yw7GxcesDjEKcDAq8fBuMDQOEWJNLCuuzD3E
	KMHBrCTCu6UCKMSbklhZlVqUH19UmpNafIiRiYNTqoExYX/v/ZiPNdwH9ZqeaZ04K7mmr7ix
	/PGNBdn+vEEOjnNlU9uNNY+rna739Te7I60Rqzwj2OPgOje1LQv/VRzuYrt8ieVO1KODygXr
	NK/MSMp3K7jsdv/3Y9v7PXwHmj7mWh2Y92qd3CzJBpGS2Y2Xi6/Mk7vA5ee3fa+T3G7J5/ms
	/5JbmGKUWIozEg21mIuKEwEcoke1UgIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 06.10.2014 22:17, Markus Pargmann wrote:
> This patch sets the new field ena_gpio_valid for all drivers which set a
> valid ena_gpio.
>
> Signed-off-by: Markus Pargmann <mpa@pengutronix.de>
> ---

(... looking only on s2m/s5m drivers)

> diff --git a/drivers/regulator/s2mps11.c b/drivers/regulator/s2mps11.c
> index b16c53a8272f..4d78477b9f57 100644
> --- a/drivers/regulator/s2mps11.c
> +++ b/drivers/regulator/s2mps11.c
> @@ -986,6 +986,7 @@ common_reg:
>   			config.of_node = rdata[i].of_node;
>   		}
>   		config.ena_gpio = s2mps11->ext_control_gpio[i];
> +		config.ena_gpio_valid = true;

This way you'll mark all regulators as GPIO enabled. This is won't 
produce an error (ena_gpio is initialized to -EINVAL by default) but I 
think it is misuse of the idea "ena_gpio_valid".

Instead maybe:
+		if (gpio_is_valid(s2mps11->ext_control_gpio[i]))
+			config.ena_gpio_valid = true;
?

>
>   		regulator = devm_regulator_register(&pdev->dev,
>   						&regulators[i], &config);
> diff --git a/drivers/regulator/s5m8767.c b/drivers/regulator/s5m8767.c
> index 0ab5cbeeb797..d258e6613831 100644
> --- a/drivers/regulator/s5m8767.c
> +++ b/drivers/regulator/s5m8767.c
> @@ -466,6 +466,7 @@ static void s5m8767_regulator_config_ext_control(struct s5m8767_info *s5m8767,
>   	}
>
>   	config->ena_gpio = rdata->ext_control_gpio;
> +	config->ena_gpio_valid = true;
>   	config->ena_gpio_flags = GPIOF_OUT_INIT_HIGH;
>   }

This looks fine.

Best regards,
Krzysztof

