Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933268AbaFIQEH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 12:04:07 -0400
Received: from mail-vc0-f178.google.com ([209.85.220.178]:63898 "EHLO
	mail-vc0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752662AbaFIQEE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 12:04:04 -0400
MIME-Version: 1.0
In-Reply-To: <1402309011.17650.9.camel@AMDC1943>
References: <1402306670-17041-1-git-send-email-javier.martinez@collabora.co.uk>
	<1402309011.17650.9.camel@AMDC1943>
Date: Mon, 9 Jun 2014 09:04:02 -0700
X-Google-Sender-Auth: d62kEJ9OThEQE8-6xyXOxgS1biU
Message-ID: <CAD=FV=U2zPJ=NohDjGvJKfmwJzQhphtVMefM0p_hvFVoReauhQ@mail.gmail.com>
Subject: Re: [PATCH 0/5] Add Maxim 77802 PMIC support
From: Doug Anderson <dianders@chromium.org>
To: Krzysztof Kozlowski <k.kozlowski@samsung.com>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Lee Jones <lee.jones@linaro.org>,
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
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Krzystof,

On Mon, Jun 9, 2014 at 3:16 AM, Krzysztof Kozlowski
<k.kozlowski@samsung.com> wrote:
> On pon, 2014-06-09 at 11:37 +0200, Javier Martinez Canillas wrote:
>> MAX77802 is a PMIC that contains 10 high efficiency Buck regulators,
>> 32 Low-dropout (LDO) regulators, two 32kHz buffered clock outputs,
>> a Real-Time-Clock (RTC) and a I2C interface to program the individual
>> regulators, clocks and the RTC.
>>
>> This series are based on drivers added by Simon Glass to the Chrome OS
>> kernel and adds support for the Maxim 77802 Power Management IC, their
>> regulators, clocks, RTC and I2C interface. It is composed of patches:
>>
>> [PATCH 1/5] mfd: Add driver for Maxim 77802 Power Management IC
>> [PATCH 2/5] regulator: Add driver for Maxim 77802 PMIC regulators
>> [PATCH 3/5] clk: Add driver for Maxim 77802 PMIC clocks
>> [PATCH 4/5] rtc: Add driver for Maxim 77802 PMIC Real-Time-Clock
>> [PATCH 5/5] ARM: dts: Add max77802 device node for exynos5420-peach-pit
>>
>> Patches 1-4 add support for the different devices and Patch 5 enables
>> the MAX77802 PMIC on the Exynos5420 based Peach pit board.
>
>
> Hi,
>
> The main mfd, mfd irq, clk and rtc drivers look very similar to max77686
> drivers. I haven't checked other Maxim drivers but I think there will be
> a lot of similarities with them also. It is almost common for Maxim
> chipsets to share components between each other.
>
> I think there is no need in duplicating all that stuff once again in new
> driver for another Maxim-almost-the-same-as-others-XYZ chipset. Just
> merge it with max77686 (or other better candidate).
>
> The only difference is in regulator driver. I am not sure whether this
> is a result of differences in chip or differences in driver design.

Yes, we thought the same thing when we added support for the max77802
in the ChromeOS tree.  Unfortunately it didn't work out half as well
as we thought it would.  When Javier was asking advice about sending
things upstream we suggested that perhaps he should split the two up.


You can see the result of the combined driver the ChromeOS tree (the
code there is older, probably misnamed as max77xxx, and doesn't have
the proper clock pieces, but you can get the gist):

https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/regulator/max77xxx-regulator.c
https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/rtc/rtc-max77xxx.c


Specific problems that made it ugly to have a combined driver:

* The RTC has many subtle differences between the 77686 and 77802.
They expanded it to handle a 200 year timeframe instead of 100 and
that meant that they had to shuffle the bits around everywhere.  They
also moved it to have the same i2c address as the main PMIC so all
addresses are different (see max77686_map in the RTC link above).

* The regulator itself has similar concepts between the two, but the
list of bucks / ldos and how they behave is quite different.  Trying
to understand the complex tables in
<https://chromium.googlesource.com/chromiumos/third_party/kernel/+/chromeos-3.8/drivers/regulator/max77xxx-regulator.c>
was not easy.


If we really need to write a single driver it certainly can be done,
but please look at the above to be sure this is what you want.


NOTE: it's possible that things could be more sane with more driver
redesign, possibly making things more data driven.  The thing that
would be really nice to do would be to avoid all of the crazy
"regulator_zzz_desc_zzz" macros, maybe?  I'd have to actually try
doing it to be sure it's cleaner, though...


-Doug
