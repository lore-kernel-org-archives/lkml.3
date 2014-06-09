Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934430AbaFIWzi (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 18:55:38 -0400
Received: from bhuna.collabora.co.uk ([93.93.135.160]:50195 "EHLO
	bhuna.collabora.co.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753727AbaFIWzf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 18:55:35 -0400
Message-ID: <53963B5D.8090908@collabora.co.uk>
Date: Tue, 10 Jun 2014 00:55:25 +0200
From: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Icedove/24.5.0
MIME-Version: 1.0
To: Doug Anderson <dianders@chromium.org>,
        Krzysztof Kozlowski <k.kozlowski@samsung.com>
CC: Lee Jones <lee.jones@linaro.org>, Alessandro Zummo <a.zummo@towertech.it>,
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
Subject: Re: [PATCH 0/5] Add Maxim 77802 PMIC support
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>	<1402309011.17650.9.camel@AMDC1943> <CAD=FV=U2zPJ=NohDjGvJKfmwJzQhphtVMefM0p_hvFVoReauhQ@mail.gmail.com>
In-Reply-To: <CAD=FV=U2zPJ=NohDjGvJKfmwJzQhphtVMefM0p_hvFVoReauhQ@mail.gmail.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Krzystof,

Thanks a lot for your feedback.

On 06/09/2014 06:04 PM, Doug Anderson wrote:
> Krzystof,
> 
> On Mon, Jun 9, 2014 at 3:16 AM, Krzysztof Kozlowski
> <k.kozlowski@samsung.com> wrote:
>> On pon, 2014-06-09 at 11:37 +0200, Javier Martinez Canillas wrote:
>>> MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
>>> 32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
>>> a Real-Time-Clock (RTC) and a I2C interface to program the individual
>>> regulators, clocks and the RTC.
>>>
>>> This series are based on drivers added by Simon Glass to the Chrome OS
>>> kernel and adds support for the Maxim 77802 Power Management IC, their
>>> regulators, clocks, RTC and I2C interface. It is composed of patches:
>>>
>>> [PATCH 1/5] mfd: Add driver for Maxim 77802 Power Management IC
>>> [PATCH 2/5] regulator: Add driver for Maxim 77802 PMIC regulators
>>> [PATCH 3/5] clk: Add driver for Maxim 77802 PMIC clocks
>>> [PATCH 4/5] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
>>> [PATCH 5/5] ARM: dts: Add max77802 device node for exynos5420-peach-pit
>>>
>>> Patches 1-4 add support for the different devices and Patch 5 enables
>>> the MAX77802 PMIC on the Exynos5420 based Peach pit board.
>>
>>
>> Hi,
>>
>> The main mfd, mfd irq, clk and rtc drivers look very similar to max77686
>> drivers. I haven't checked other Maxim drivers but I think there will be
>> a lot of similarities with them also. It is almost common for Maxim
>> chipsets to share components between each other.
>>
>> I think there is no need in duplicating all that stuff once again in new
>> driver for another Maxim-almost-the-same-as-others-XYZ chipset. Just
>> merge it with max77686 (or other better candidate).
>>
>> The only difference is in regulator driver. I am not sure whether this
>> is a result of differences in chip or differences in driver design.
> 
> Yes, we thought the same thing when we added support for the max77802
> in the ChromeOS tree.  Unfortunately it didn't work out half as well
> as we thought it would.  When Javier was asking advice about sending
> things upstream we suggested that perhaps he should split the two up.
> 
> 
> You can see the result of the combined driver the ChromeOS tree (the
> code there is older, probably misnamed as max77xxx, and doesn't have
> the proper clock pieces, but you can get the gist):
> 
> https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/regulator/max77xxx-regulator.c
> https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/rtc/rtc-max77xxx.c
> 
> 
> Specific problems that made it ugly to have a combined driver:
> 
> * The RTC has many subtle differences between the 77686 and 77802.
> They expanded it to handle a 200 year timeframe instead of 100 and
> that meant that they had to shuffle the bits around everywhere.  They
> also moved it to have the same i2c address as the main PMIC so all
> addresses are different (see max77686_map in the RTC link above).
>
> * The regulator itself has similar concepts between the two, but the
> list of bucks / ldos and how they behave is quite different.  Trying
> to understand the complex tables in
> <https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/regulator/max77xxx-regulator.c>
> was not easy.
> 
> 

There are other differences that were not mentioned:

- The max77802 uses a single register to enable RTC alarm while max77686 uses 1
bit from a set of registers.
- Each chip has some regulators that are not available and you have to take care
of those exceptions (e.g: LDO16, LDO22 and LD31 on max77802).
- The max77802 has 2 clocks outputs while the max77686 has three.

So, as Doug said there are many differences on these two chips besides the
regulators. It's true that these two drivers share a lot of the structure and
there is code duplication (this applies to most maxim drivers btw) but I have my
doubts that the combined approach will make the code more easy to maintain.

The biggest problem is the i2c addresses space being different so you need an
indirection level to access registers and have duplicated registers definition
for each chip.

> If we really need to write a single driver it certainly can be done,
> but please look at the above to be sure this is what you want.
> 
>

Yes, if the combined driver is preferred over having a separate driver for
max77802 then I will try to find the more elegant way to merge both drivers. But
I tried to do it already and I can't say I liked the end result more than having
two separate drivers.

> NOTE: it's possible that things could be more sane with more driver
> redesign, possibly making things more data driven.  The thing that
> would be really nice to do would be to avoid all of the crazy
> "regulator_zzz_desc_zzz" macros, maybe?  I'd have to actually try
> doing it to be sure it's cleaner, though...
> 

Another option is to use an hybrid approach. Merge the mfd core, irq and clk
drivers but have different platform drivers for rtc and regulators. Still the
end result is not great imho but better than trying merging the regulators and
RTC drivers where most of the differences are.

> 
> -Doug
> 

Best regards,
Javier
