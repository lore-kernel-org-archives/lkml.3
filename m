Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756546AbaHHK67 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:58:59 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35990 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756187AbaHHK64 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:58:56 -0400
Message-ID: <53E4AD6A.4000705@collabora.co.uk>
Date: Fri, 08 Aug 2014 12:58:50 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCH] mfd: max77686: fix support for devices without irq specified
References: <1457999.lNPdqEWCCR@amdc1032> <1407484788.21474.13.camel@AMDC1943> <53E49147.5060307@collabora.co.uk> <53E4A1E9.7090401@collabora.co.uk> <1407495251.28710.2.camel@AMDC1943>
In-Reply-To: <1407495251.28710.2.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

On 08/08/2014 12:54 PM, Krzysztof Kozlowski wrote:
>> >> 
>> >> Not sufficient. You have to also fix RTC driver (OOPS from Trats2
>> >> attached). Also consider adding checks for (max77686->irq) to the
>> >> suspend and resume.
>> >> 
>> > 
>> > Right, the max77686 RTC driver assumes that an IRQ domain will be created on the
>> > mfd driver so a virtual IRQ can be mapped for the RTC alarm1 IRQ. This
>> > assumptions comes from the fact that the "interrupt" property is required
>> > according to the DT binding doc.
>> > 
>> 
>> Although for Trats2 I see that arch/arm/boot/dts/exynos4412-trats2.dts defines
>> an interrupt, so I wonder why regmap_irq_get_virq() is giving an oops there:
>> 
>> max77686_pmic@09 {
>> 	compatible = "maxim,max77686";
>> 	interrupt-parent = <&gpx0>;
>> 	interrupts = <7 0>;
>> 	reg = <0x09>;
>> 	#clock-cells = <1>;
>> ...
> 
> Because I am a nasty user :) and I removed the interrupts properties
> manually (to test how the RTC will behave). Still the driver shouldn't
> oops.
> 

Oh, now it makes sense :)

Yes, I agree with you that the driver should not oops. The probe should fail
though if no IRQ domain was created on the MFD driver since that DT property is
required.

I'll send a fix for this today, thanks a lot for reporting it.

>> 
>> 
>> > So the max77686 RTC wakealarm was not working for these boards before?
> 
> I don't know for Odroid but on Trats2 it works fine.
> 
>> > 
>> > Just to be sure that I understand the issue: these boards don't really have an
>> > IRQ connected to the PMIC, is not that this information is just missing in the
>> > Device Tree, right?
>> > 
>> 
>> By looking at Odroid's 3.8 based vendor tree I see that an IRQ for the max77686
>> PMIC is defined [0] using platform data:
>> 
>> static struct max77686_platform_data exynos4_max77686_info = {
>> 	.irq_gpio	= 	EXYNOS4_GPX3(2),
>> 	.ono		=	EXYNOS4_GPX1(2),
>> 	.num_regulators = ARRAY_SIZE(max77686_regulators),
>> 	.regulators = max77686_regulators,
>> ...
>> 
>> So maybe this information is missing in
>> arch/arm/boot/dts/exynos4412-odroid-common.dtsi?
> 
> Yes, it seems it is missing.
> 

Indeed.

> Best regards,
> Krzysztof
> 

Best regards,
Javier
