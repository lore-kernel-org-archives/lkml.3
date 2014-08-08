Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756150AbaHHKJz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:09:55 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35969 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755594AbaHHKJw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:09:52 -0400
Message-ID: <53E4A1E9.7090401@collabora.co.uk>
Date: Fri, 08 Aug 2014 12:09:45 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>,
        Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
CC: Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: max77686: fix support for devices without irq specified
References: <1457999.lNPdqEWCCR@amdc1032> <1407484788.21474.13.camel@AMDC1943> <53E49147.5060307@collabora.co.uk>
In-Reply-To: <53E49147.5060307@collabora.co.uk>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello,

On 08/08/2014 10:58 AM, Javier Martinez Canillas wrote:
> 
>> 
>> Not sufficient. You have to also fix RTC driver (OOPS from Trats2
>> attached). Also consider adding checks for (max77686->irq) to the
>> suspend and resume.
>> 
> 
> Right, the max77686 RTC driver assumes that an IRQ domain will be created on the
> mfd driver so a virtual IRQ can be mapped for the RTC alarm1 IRQ. This
> assumptions comes from the fact that the "interrupt" property is required
> according to the DT binding doc.
> 

Although for Trats2 I see that arch/arm/boot/dts/exynos4412-trats2.dts defines
an interrupt, so I wonder why regmap_irq_get_virq() is giving an oops there:

max77686_pmic@09 {
	compatible = "maxim,max77686";
	interrupt-parent = <&gpx0>;
	interrupts = <7 0>;
	reg = <0x09>;
	#clock-cells = <1>;
...


> So the max77686 RTC wakealarm was not working for these boards before?
> 
> Just to be sure that I understand the issue: these boards don't really have an
> IRQ connected to the PMIC, is not that this information is just missing in the
> Device Tree, right?
> 

By looking at Odroid's 3.8 based vendor tree I see that an IRQ for the max77686
PMIC is defined [0] using platform data:

static struct max77686_platform_data exynos4_max77686_info = {
	.irq_gpio	= 	EXYNOS4_GPX3(2),
	.ono		=	EXYNOS4_GPX1(2),
	.num_regulators = ARRAY_SIZE(max77686_regulators),
	.regulators = max77686_regulators,
...

So maybe this information is missing in
arch/arm/boot/dts/exynos4412-odroid-common.dtsi?

Best regards,
Javier

[0]:
https://github.com/hardkernel/linux/blob/odroid-3.8.y/arch/arm/mach-exynos/pmic-77686.h#L927

