Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759396AbaJ3LvB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 30 Oct 2014 07:51:01 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:33369 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759338AbaJ3Lu7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 30 Oct 2014 07:50:59 -0400
Message-ID: <54522615.7040002@collabora.co.uk>
Date: Thu, 30 Oct 2014 12:50:45 +0100
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:31.0) Gecko/20100101 Icedove/31.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>, Mark Brown <broonie@kernel.org>,
        linux-kernel@vger.kernel.org, Ben Dooks <ben-linux@fluff.org>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Russell King <linux@arm.linux.org.uk>,
        linux-arm-kernel@lists.infradead.org,
        linux-samsung-soc@vger.kernel.org, devicetree@vger.kernel.org
CC: Kyungmin Park <kyungmin.park@samsung.com>,
        Marek Szyprowski <m.szyprowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Chanwoo Choi <cw00.choi@samsung.com>
Subject: Re: [RFT v3 06/14] regulator: max77802: Remove support for board
 files
References: <1414668053-31370-1-git-send-email-k.kozlowski@samsung.com> <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com>
In-Reply-To: <1414668053-31370-7-git-send-email-k.kozlowski@samsung.com>
Content-Type: text/plain; charset=utf-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 10/30/2014 12:20 PM, Krzysztof Kozlowski wrote:
>  static int max77802_pmic_probe(struct platform_device *pdev)
>  {
>  	struct max77686_dev *iodev = dev_get_drvdata(pdev->dev.parent);
> -	struct max77686_platform_data *pdata = dev_get_platdata(iodev->dev);
>  	struct max77802_regulator_prv *max77802;
> -	int i, ret = 0, val;
> +	int i, val;
>  	struct regulator_config config = { };
>  
> -	/* This is allocated by the MFD driver */
> -	if (!pdata) {
> -		dev_err(&pdev->dev, "no platform data found for regulator\n");
> -		return -ENODEV;
> -	}
> -
>  	max77802 = devm_kzalloc(&pdev->dev,
>  				sizeof(struct max77802_regulator_prv),
>  				GFP_KERNEL);
>  	if (!max77802)
>  		return -ENOMEM;
>  
> -	if (iodev->dev->of_node) {
> -		ret = max77802_pmic_dt_parse_pdata(pdev, pdata);
> -		if (ret)
> -			return ret;
> +	if (!pdev->dev.of_node) {
> +		/*
> +		 * Backward DTS compatiblity where regulator driver had not
> +		 * a compatible property for itself.
> +		 */
> +		if (!iodev->dev->of_node) {
> +			dev_err(&pdev->dev, "No OF node for driver and its parent\n");
> +			return -EINVAL;
> +		}
> +		pdev->dev.of_node = of_get_child_by_name(iodev->dev->of_node,
> +								"regulators");
> +		max77802->missing_of_node = true;
>  	}

I may be missing something but I don't understand why a compatible string
for the regulators sub-node is needed. Isn't enough to just fill the
.regulators_node field in the struct regulator_desc? e.g:

    .regulators_node = of_match_ptr("regulators") for max77802
    .regulators_node = of_match_ptr("voltage-regulators") for max77686

AFAIU this should be enough for the core to extract the init_data and will
make your change much more simpler and you can drop patches 1-3 and 13-14.

Or maybe I misread the regulator_of_get_init_data() function?

Best regards,
Javier
