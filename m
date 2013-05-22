Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756638Ab3EVT3m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 15:29:42 -0400
Received: from wolverine02.qualcomm.com ([199.106.114.251]:1105 "EHLO
	wolverine02.qualcomm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753577Ab3EVT3l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 15:29:41 -0400
X-IronPort-AV: E=Sophos;i="4.87,723,1363158000"; 
   d="scan'208";a="49800361"
Message-ID: <519D1CA4.9050506@codeaurora.org>
Date: Wed, 22 May 2013 12:29:40 -0700
From: Rohit Vaswani <rvaswani@codeaurora.org>
User-Agent: Mozilla/5.0 (Windows NT 6.1; WOW64; rv:17.0) Gecko/20130509 Thunderbird/17.0.6
MIME-Version: 1.0
To: Stephen Boyd <sboyd@codeaurora.org>
CC: Linus Walleij <linus.walleij@linaro.org>,
        Grant Likely <grant.likely@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>, linux-doc@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
References: <1369161163-6448-1-git-send-email-rvaswani@codeaurora.org> <1369161163-6448-4-git-send-email-rvaswani@codeaurora.org> <20130521210627.GA599@codeaurora.org>
In-Reply-To: <20130521210627.GA599@codeaurora.org>
Content-Type: text/plain; charset=ISO-8859-1; format=flowed
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 5/21/2013 2:06 PM, Stephen Boyd wrote:
>> diff --git a/drivers/gpio/Kconfig b/drivers/gpio/Kconfig
>> index 87d5670..f3c1978 100644
>> --- a/drivers/gpio/Kconfig
>> +++ b/drivers/gpio/Kconfig
>> @@ -165,7 +165,7 @@ config GPIO_MSM_V1
>>   
>>   config GPIO_MSM_V2
>>   	tristate "Qualcomm MSM GPIO v2"
>> -	depends on GPIOLIB && ARCH_MSM
>> +	depends on GPIOLIB && ARCH_MSM && OF
> This doesn't actually rely on ARCH_MSM anymore so I think we can
> drop that dependency.
Done.
>
>>   	help
>>   	  Say yes here to support the GPIO interface on ARM v7 based
>>   	  Qualcomm MSM chips.  Most of the pins on the MSM can be
>> @@ -222,7 +229,6 @@ static void msm_gpio_update_dual_edge_pos(unsigned gpio)
>>   		else
>>   			set_gpio_bits(BIT(INTR_POL_CTL), GPIO_INTR_CFG(gpio));
>>   		val2 = readl(GPIO_IN_OUT(gpio)) & BIT(GPIO_IN);
>> -		intstat = readl(GPIO_INTR_STATUS(gpio)) & BIT(INTR_STATUS);
>>   		if (intstat || val == val2)
> Looks like intstat is used uninitialized now?
Thanks for catching this. Will fix this.
>
>> +
>> +static int msm_gpio_probe(struct platform_device *pdev)
>> +{
>> +	int i, irq, ret, ngpio;
>> +	struct resource *res;
>> +
>> +	msm_gpio.gpio_chip.label = pdev->name;
>> +	msm_gpio.gpio_chip.dev = &pdev->dev;
>> +	of_property_read_u32(pdev->dev.of_node, "ngpio", &ngpio);
> Fail probe if the property isn't there?
Done.
>
>> +	msm_gpio.gpio_chip.ngpio = ngpio;
>> +
>> +	res = platform_get_resource(&pdev->dev, IORESOURCE_MEM, 0);
>> +	if (!res) {
>> +		dev_err(&pdev->dev, "%s: no mem resource\n", __func__);
>> +		return -EINVAL;
>> +	}
>> +
>> +	msm_tlmm_base = devm_ioremap_resource(pdev->dev, res);
>> +	if (!msm_tlmm_base) {
>> +		dev_err(&pdev->dev, "Couldn't allocate memory for msm tlmm base\n");
>> +		return -ENOMEM;
>> +	}
> devm_ioremap_resource() returns an ERR_PTR on failure, not NULL.
> Also, it already prints messages on errors so you can drop all the
> prints around this. Just do
>
> 	res = platform_get_resource(&pdev->dev, IORESOURCE_MEM, 0);
> 	msm_tlmm_base = devm_ioremap_resource(pdev->dev, res);
> 	if (IS_ERR(msm_tlmm_base))
> 		return ERR_PTR(msm_tlmm_base);
>    
Done.
>>   static int __init msm_gpio_init(void)
>>   {
>> -	int rc;
>> -
>> -	rc = platform_driver_register(&msm_gpio_driver);
>> -	if (!rc) {
>> -		rc = platform_device_register(&msm_device_gpio);
>> -		if (rc)
>> -			platform_driver_unregister(&msm_gpio_driver);
>> -	}
>> -
>> -	return rc;
>> +	return platform_driver_register(&msm_gpio_driver);
>>   }
>>   
>>   static void __exit msm_gpio_exit(void)
>>   {
>> -	platform_device_unregister(&msm_device_gpio);
>>   	platform_driver_unregister(&msm_gpio_driver);
>>   }
> You could use module_platform_driver here now too.
>
Done. Thanks for the comments.

Thanks,
Rohit Vaswani

-- 
The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum, hosted by The Linux Foundation

