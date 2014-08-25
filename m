Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbaHYPkp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 11:40:45 -0400
Received: from mail-vc0-f169.google.com ([209.85.220.169]:60534 "EHLO
	mail-vc0-f169.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932606AbaHYPkm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 11:40:42 -0400
MIME-Version: 1.0
In-Reply-To: <53FAFCBC.2050407@collabora.co.uk>
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk>
	<CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com>
	<53F73472.8010609@collabora.co.uk>
	<20140822144531.GV24407@sirena.org.uk>
	<53F7838F.8060906@collabora.co.uk>
	<20140822183054.GY24407@sirena.org.uk>
	<53F7BDD8.7060500@collabora.co.uk>
	<CAD=FV=WC0h7fYm2QFqu3Zka7CsU4BtG-oyPpJav+ygC+gmCR+A@mail.gmail.com>
	<CA+NduCCT-KQ=gh7QWkBE4qkA2YOJ8KCVqbkC6Tkmb1aPvCsGFQ@mail.gmail.com>
	<53FAFCBC.2050407@collabora.co.uk>
Date: Mon, 25 Aug 2014 08:40:40 -0700
X-Google-Sender-Auth: ot-xL2uQRGznNkyXiP_U4lR8vXk
Message-ID: <CAD=FV=V4TSKsbjj3dXCdSzVrh3sxH-FkpFEbEo+JA1bN9R-XWA@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC regulators
From: Doug Anderson <dianders@chromium.org>
To: Javier Martinez Canillas <javier.martinez@collabora.co.uk>
Cc: Yuvaraj Cd <yuvaraj.lkml@gmail.com>, Mark Brown <broonie@kernel.org>,
        Olof Johansson <olof@lixom.net>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        linux-samsung-soc <linux-samsung-soc@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Abhilash Kesavan <a.kesavan@samsung.com>,
        Prashanth G <prashanth.g@samsung.com>,
        Alim Akhtar <alim.akhtar@samsung.com>, sunil joshi <joshi@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Javier,

On Mon, Aug 25, 2014 at 2:07 AM, Javier Martinez Canillas
<javier.martinez@collabora.co.uk> wrote:
> Hello Yuvaraj,
>
> On 08/25/2014 10:22 AM, Yuvaraj Cd wrote:
>>>> Good question. I'm not that familiar with the dw_mmc host controller nor
>>>> its driver implementation so I'll let Yuvaraj or Doug to answer that.
>> Well,here it goes!
>> 1. Power ON the board LDO4CTRL1[7:6] 11b
>> 2. dw_mmc driver enable the vqmmc.
>> 3. checks for UHS support, complete the voltage switching t0 1.8V
>> 4. Does warm reset by reboot command.
>> 5. mmc core calls mmc_set_ios() with MMC_POWER_OFF.
>> 6. dw_mmc driver cut-off the regulator with LDO4CTRL1[7:6] is 00b
>> 7.dw_mmc driver enable the vqmmc.
>>  But after step 7 also, LD4CTRL[7:6] is 00b.
>
> Ok, so the dw_mmc driver is enabling vqmmc, that's good.
>
>>>
>>> I haven't seen the issue that Yuvaraj is reporting (but I also haven't
>>> picked up all of the relevant patches and tried to reproduce), so I'm
>>> going to have to leave it to Yuvaraj to answer.
>>     static int max77802_enable(struct regulator_dev *rdev)
>>     {
>>       struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
>>      int id = rdev_get_id(rdev);
>>      int shift = max77802_get_opmode_shift(id);
>>      return regmap_update_bits(rdev->regmap,
>> rdev->desc->enable_reg,rdev->desc->enable_mask,max77802->opmode[id] <<
>> shift);
>>   }
>> I think in the above code snippet, the "val" is what we got it during
>> the probe.We always write that value for enabling this regulator(which
>> is LDO4CTRL1[7:6] 00b after warm reset) which is not correct according
>> the MAX77802 manual.
>>>
>
> I see, so probably until we have a way to define the operating mode for
> each regulator using DT we should set the opmode to normal when enabling a
> regulator independently of the value the hardware register reported on probe.
>
> Can you please test the following change [0] so I can post as a proper
> patch? Doug, Mark do you think that forcing the regulator to opmode normal
> when enabling is the right solution here?

IMHO that makes sense.
