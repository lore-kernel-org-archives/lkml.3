Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S936254AbaFJHux (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Jun 2014 03:50:53 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:50417 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933692AbaFJHuv convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Jun 2014 03:50:51 -0400
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk> <1402309011.17650.9.camel@AMDC1943> <CAD=FV=U2zPJ=NohDjGvJKfmwJzQhphtVMefM0p_hvFVoReauhQ@mail.gmail.com> <1402385558.6989.11.camel@AMDC1943>
Mime-Version: 1.0 (1.0)
In-Reply-To: <1402385558.6989.11.camel@AMDC1943>
Content-Type: text/plain;
	charset=us-ascii
Content-Transfer-Encoding: 8BIT
Message-Id: <F27F8EB2-39C2-4A03-A5AC-E11C5A35BF9C@collabora.co.uk>
Cc: Doug Anderson <dianders@chromium.org>, Lee Jones <lee.jones@linaro.org>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mike Turquette <mturquette@linaro.org>,
        Samuel Ortiz <sameo@linux.intel.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        Sjoerd Simons <sjoerd.simons@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Daniel Stone <daniels@collabora.com>
X-Mailer: iPhone Mail (11D167)
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Subject: Re: [PATCH 0/5] Add Maxim 77802 PMIC support
Date: Tue, 10 Jun 2014 09:50:27 +0200
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzysztof,

> On 10/06/2014, at 09:32, Krzysztof Kozlowski <k.kozlowski@samsung.com> wrote:
> 
>> On pon, 2014-06-09 at 09:04 -0700, Doug Anderson wrote:
>> Krzystof,
>> 
>> On Mon, Jun 9, 2014 at 3:16 AM, Krzysztof Kozlowski
>> <k.kozlowski@samsung.com> wrote:
>>> On pon, 2014-06-09 at 11:37 +0200, Javier Martinez Canillas wrote:
>>>> MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
>>>> 32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
>>>> a Real-Time-Clock (RTC) and a I2C interface to program the individual
>>>> regulators, clocks and the RTC.
>>>> 
>>>> This series are based on drivers added by Simon Glass to the Chrome OS
>>>> kernel and adds support for the Maxim 77802 Power Management IC, their
>>>> regulators, clocks, RTC and I2C interface. It is composed of patches:
>>>> 
>>>> [PATCH 1/5] mfd: Add driver for Maxim 77802 Power Management IC
>>>> [PATCH 2/5] regulator: Add driver for Maxim 77802 PMIC regulators
>>>> [PATCH 3/5] clk: Add driver for Maxim 77802 PMIC clocks
>>>> [PATCH 4/5] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
>>>> [PATCH 5/5] ARM: dts: Add max77802 device node for exynos5420-peach-pit
>>>> 
>>>> Patches 1-4 add support for the different devices and Patch 5 enables
>>>> the MAX77802 PMIC on the Exynos5420 based Peach pit board.
>>> 
>>> 
>>> Hi,
>>> 
>>> The main mfd, mfd irq, clk and rtc drivers look very similar to max77686
>>> drivers. I haven't checked other Maxim drivers but I think there will be
>>> a lot of similarities with them also. It is almost common for Maxim
>>> chipsets to share components between each other.
>>> 
>>> I think there is no need in duplicating all that stuff once again in new
>>> driver for another Maxim-almost-the-same-as-others-XYZ chipset. Just
>>> merge it with max77686 (or other better candidate).
>>> 
>>> The only difference is in regulator driver. I am not sure whether this
>>> is a result of differences in chip or differences in driver design.
>> 
>> Yes, we thought the same thing when we added support for the max77802
>> in the ChromeOS tree.  Unfortunately it didn't work out half as well
>> as we thought it would.  When Javier was asking advice about sending
>> things upstream we suggested that perhaps he should split the two up.
>> 
>> 
>> You can see the result of the combined driver the ChromeOS tree (the
>> code there is older, probably misnamed as max77xxx, and doesn't have
>> the proper clock pieces, but you can get the gist):
>> 
>> https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/regulator/max77xxx-regulator.c
>> https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/rtc/rtc-max77xxx.c
>> 
>> 
>> Specific problems that made it ugly to have a combined driver:
>> 
>> * The RTC has many subtle differences between the 77686 and 77802.
>> They expanded it to handle a 200 year timeframe instead of 100 and
>> that meant that they had to shuffle the bits around everywhere.  They
>> also moved it to have the same i2c address as the main PMIC so all
>> addresses are different (see max77686_map in the RTC link above).
> 
> The difference in RTC registers seems the biggest but it can be solved
> in readable manner. I see other differences but there aren't many. It
> just hurts seeing so much code duplication:
> $ sed -e 's/max77686/max77802/g' -e 's/MAX77686/MAX77802/g' \
>  -i drivers/rtc/rtc-max77686.c
> $ diff -ubB drivers/rtc/rtc-max77686.c drivers/rtc/rtc-max77802.c
> 
> The combined RTC driver from ChromeOS seems fine to me... but I do not
> insist.
> 
>> * The regulator itself has similar concepts between the two, but the
>> list of bucks / ldos and how they behave is quite different.  Trying
>> to understand the complex tables in
>> <https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/regulator/max77xxx-regulator.c>
>> was not easy.
>> 
>> 
>> If we really need to write a single driver it certainly can be done,
>> but please look at the above to be sure this is what you want.
> 
> Sure, I don't stick to the idea of one merged driver where this
> increases code size and complexity. I see your point that merging
> regulator drivers won't bring benefits but please:
> $ sed -e 's/max77686/max77802/g' -e 's/MAX77686/MAX77802/g' \
>  -i drivers/clk/clk-max77686.c
> $ diff -ubB drivers/clk/clk-max77686.c drivers/clk/clk-max77802.c
> 

I agree that there is too much duplicated code between those two and others Maxim PMIC drivers.

I also agree that at some point we have to stop duplicating code and clean up all this.

So, I think that instead of trying to make a single driver support two similar but different PMIC I can factor out the generic code in a max-core driver so the PMIC specific code is small and well contained.

I'll work on that and post a v2.

Thanks a lot for your feedback and best regards,

Javier

> The difference in number of clocks (2 vs 3) is not an obstacle here.
> 
> The same applies to main MFD driver and IRQ code. However MAX77686
> doesn't use regmap_irq_chip so it needs changes before merging the IRQ
> code into one piece.
> 
> Best regards,
> Krzysztof
> 
>> 
>> NOTE: it's possible that things could be more sane with more driver
>> redesign, possibly making things more data driven.  The thing that
>> would be really nice to do would be to avoid all of the crazy
>> "regulator_zzz_desc_zzz" macros, maybe?  I'd have to actually try
>> doing it to be sure it's cleaner, though...
>> 
>> 
>> -Doug
> 
