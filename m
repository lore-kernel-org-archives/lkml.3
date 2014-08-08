Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756155AbaHHI7C (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Aug 2014 04:59:02 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:35931 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755391AbaHHI67 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Aug 2014 04:58:59 -0400
Message-ID: <53E49147.5060307@collabora.co.uk>
Date: Fri, 08 Aug 2014 10:58:47 +0200
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
References: <1457999.lNPdqEWCCR@amdc1032> <1407484788.21474.13.camel@AMDC1943>
In-Reply-To: <1407484788.21474.13.camel@AMDC1943>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof and Bartlomiej,

On 08/08/2014 09:59 AM, Krzysztof Kozlowski wrote:
> On czw, 2014-08-07 at 18:09 +0200, Bartlomiej Zolnierkiewicz wrote:
>> Before commit 6f1c1e71d933 ("mfd: max77686: Convert to use regmap_irq")
>> max77686_irq_init() return value was never checked so devices without
>> irq specified (like Hardkernel's Exynos4412 based ODROID-U3 board)
>> worked fine even though -ENODEV was returned by the function.  Add
>> handling for no irq specified case in max77686_i2c_probe() restoring
>> the previous driver's behavior.
>> 
>> The patch fixes boot for Hardkernel's Exynos4412 based ODROID-U3 board.
>> 
>> Error messages before the patch:
>> ...
>> [    0.163995] max77686 0-0009: Failed to request IRQ 0 for max77686-pmic: -22
>> [    0.164020] max77686 0-0009: failed to add PMIC irq chip: -22
>> [    0.164478] max77686: probe of 0-0009 failed with error -22
>> ...
>> 

I thought that not specifying an IRQ was not possible since the property says to
be required in Documentation/devicetree/bindings/mfd/max77686.txt:

Required properties:
- compatible : Must be "maxim,max77686";
- reg : Specifies the i2c slave address of PMIC block.
- interrupts : This i2c device has an IRQ line connected to the main SoC.
- interrupt-parent : The parent interrupt controller.

So if this change is necessary then we should also move "interrupt" to the
optional properties section.

> 
> Not sufficient. You have to also fix RTC driver (OOPS from Trats2
> attached). Also consider adding checks for (max77686->irq) to the
> suspend and resume.
> 

Right, the max77686 RTC driver assumes that an IRQ domain will be created on the
mfd driver so a virtual IRQ can be mapped for the RTC alarm1 IRQ. This
assumptions comes from the fact that the "interrupt" property is required
according to the DT binding doc.

So the max77686 RTC wakealarm was not working for these boards before?

Just to be sure that I understand the issue: these boards don't really have an
IRQ connected to the PMIC, is not that this information is just missing in the
Device Tree, right?

> Best regards,
> Krzysztof
> 
> 

Best regards,
Javier
