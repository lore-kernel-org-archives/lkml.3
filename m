Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756420AbaHHKyP (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 06:54:15 -0400
Received: from mailout4.w1.samsung.com ([210.118.77.14]:31100 "EHLO
	mailout4.w1.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755395AbaHHKyK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 06:54:10 -0400
MIME-version: 1.0
Content-type: text/plain; charset=UTF-8
X-AuditID: cbfec7f5-b7f776d000003e54-94-53e4ac4f02d7
Content-transfer-encoding: 8BIT
Message-id: <1407495251.28710.2.camel@AMDC1943>
Subject: Re: [PATCH] mfd: max77686: fix support for devices without irq
 specified
From: Krzysztof Kozlowski <k.kozlowski@samsung.com>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Doug Anderson <dianders@chromium.org>,
        Kyungmin Park <kyungmin.park@samsung.com>,
        linux-samsung-soc@vger.kernel.org, linux-kernel@vger.kernel.org
Date: Fri, 08 Aug 2014 12:54:11 +0200
In-reply-to: <53E4A1E9.7090401@collabora.co.uk>
References: <1457999.lNPdqEWCCR@amdc1032> <1407484788.21474.13.camel@AMDC1943>
 <53E49147.5060307@collabora.co.uk> <53E4A1E9.7090401@collabora.co.uk>
X-Mailer: Evolution 3.10.4-0ubuntu1
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrKLMWRmVeSWpSXmKPExsVy+t/xy7r+a54EGzRPUbHYOGM9q8XZZQfZ
	LI7+LrA42/SG3eL+16OMFpd3zWGzmHF+H5PF6W5WBw6P2Q0XWTz+Pr/O4nHn2h42j3knAz36
	tqxi9Pi8SS6ALYrLJiU1J7MstUjfLoErY+L0B2wFpwQqvv3/wdzA2M7bxcjJISFgIvH4fQsT
	hC0mceHeerYuRi4OIYGljBIvVp1mBknwCghK/Jh8j6WLkYODWUBe4silbJAws4C6xKR5i5gh
	6j8zSryePBeqXl/i5ru17CC2sECwxJqTa9lAbDYBY4nNy5eA2SICdhI3Vj8Ea2YWmM0ksW/e
	VhaQBIuAqsTa2c1ggziBBr0+OQlqwzRGiVe3J7JBnKosMW//MaYJjAKzkBw4C+HAWUgOXMDI
	vIpRNLU0uaA4KT3XSK84Mbe4NC9dLzk/dxMjJOi/7mBceszqEKMAB6MSD6/C3rvBQqyJZcWV
	uYcYJTiYlUR4Ly9/EizEm5JYWZValB9fVJqTWnyIkYmDU6qBMeFNouaj7Yc4ZFiemHye+b1i
	EdMfxSOtl3e8+a68aMUCbt6/rrzevvcu6e8PYrjoqROU+v/GlgtH9U1yD8dLJix6x5dxInyx
	3p0jPez/rp245xv/PP3w52tpS6dP3zTT6mb0gy3X0kyEbUPOzFTrCahdOfdtygez+8eXTzlb
	1aZn5eDzi7GonlmJpTgj0VCLuag4EQDhM+sdWAIAAA==
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On pią, 2014-08-08 at 12:09 +0200, Javier Martinez Canillas wrote:
> Hello,
> 
> On 08/08/2014 10:58 AM, Javier Martinez Canillas wrote:
> > 
> >> 
> >> Not sufficient. You have to also fix RTC driver (OOPS from Trats2
> >> attached). Also consider adding checks for (max77686->irq) to the
> >> suspend and resume.
> >> 
> > 
> > Right, the max77686 RTC driver assumes that an IRQ domain will be created on the
> > mfd driver so a virtual IRQ can be mapped for the RTC alarm1 IRQ. This
> > assumptions comes from the fact that the "interrupt" property is required
> > according to the DT binding doc.
> > 
> 
> Although for Trats2 I see that arch/arm/boot/dts/exynos4412-trats2.dts defines
> an interrupt, so I wonder why regmap_irq_get_virq() is giving an oops there:
> 
> max77686_pmic@09 {
> 	compatible = "maxim,max77686";
> 	interrupt-parent = <&gpx0>;
> 	interrupts = <7 0>;
> 	reg = <0x09>;
> 	#clock-cells = <1>;
> ...

Because I am a nasty user :) and I removed the interrupts properties
manually (to test how the RTC will behave). Still the driver shouldn't
oops.

> 
> 
> > So the max77686 RTC wakealarm was not working for these boards before?

I don't know for Odroid but on Trats2 it works fine.

> > 
> > Just to be sure that I understand the issue: these boards don't really have an
> > IRQ connected to the PMIC, is not that this information is just missing in the
> > Device Tree, right?
> > 
> 
> By looking at Odroid's 3.8 based vendor tree I see that an IRQ for the max77686
> PMIC is defined [0] using platform data:
> 
> static struct max77686_platform_data exynos4_max77686_info = {
> 	.irq_gpio	= 	EXYNOS4_GPX3(2),
> 	.ono		=	EXYNOS4_GPX1(2),
> 	.num_regulators = ARRAY_SIZE(max77686_regulators),
> 	.regulators = max77686_regulators,
> ...
> 
> So maybe this information is missing in
> arch/arm/boot/dts/exynos4412-odroid-common.dtsi?

Yes, it seems it is missing.

Best regards,
Krzysztof

> 
> Best regards,
> Javier
> 
> [0]:
> https://github.com/hardkernel/linux/blob/odroid-3.8.y/arch/arm/mach-exynos/pmic-77686.h#L927

