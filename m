Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754809AbaHYIWJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 04:22:09 -0400
Received: from mail-we0-f176.google.com ([74.125.82.176]:64998 "EHLO
	mail-we0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753843AbaHYIWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 04:22:05 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=WC0h7fYm2QFqu3Zka7CsU4BtG-oyPpJav+ygC+gmCR+A@mail.gmail.com>
References: <1408350762-15520-1-git-send-email-javier.martinez@collabora.co.uk>
	<1408350762-15520-2-git-send-email-javier.martinez@collabora.co.uk>
	<CA+NduCDL65=Y=PyU3FfXsTz0FfbmYzicGrY4U7ji3_V+nXhtCQ@mail.gmail.com>
	<53F73472.8010609@collabora.co.uk>
	<20140822144531.GV24407@sirena.org.uk>
	<53F7838F.8060906@collabora.co.uk>
	<20140822183054.GY24407@sirena.org.uk>
	<53F7BDD8.7060500@collabora.co.uk>
	<CAD=FV=WC0h7fYm2QFqu3Zka7CsU4BtG-oyPpJav+ygC+gmCR+A@mail.gmail.com>
Date: Mon, 25 Aug 2014 13:52:04 +0530
Message-ID: <CA+NduCCT-KQ=gh7QWkBE4qkA2YOJ8KCVqbkC6Tkmb1aPvCsGFQ@mail.gmail.com>
Subject: Re: [PATCH v9 1/2] regulator: Add driver for max77802 PMIC PMIC regulators
From: Yuvaraj Cd <yuvaraj.lkml@gmail.com>
To: Doug Anderson <dianders@chromium.org>
Cc: Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mark Brown <broonie@kernel.org>, Olof Johansson <olof@lixom.net>,
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

On Sat, Aug 23, 2014 at 3:45 AM, Doug Anderson <dianders@chromium.org> wrote:
> Hi,
>
> On Fri, Aug 22, 2014 at 3:02 PM, Javier Martinez Canillas
> <javier.martinez@collabora.co.uk> wrote:
>> Hello Mark,
>>
>> On 08/22/2014 08:30 PM, Mark Brown wrote:
>>>
>>>> The problem is that one of these regulators is used as the vqmmc-supply
>>>> (VCCQ/VDD_IO) so the mmc host controller driver disables it on
>>>> MMC_POWER_OFF. Now AFAIK (Yuvaraj can correct me what I got wrong) this
>>>> shouldn't be an issue since on card detection, the vqmmc supply should be
>>>> enabled again but on Exynos the built-in card detect line is on the same
>>>> power rail as vqmmc. That means that disabling the regulator prevents card
>>>> insertions to be detected.
>>>
>>> If the MMC host controller needs a supply enabling in order to do card
>>> detection and it's supposed to be doing card detection I'd expect it to
>>> be enabling that supply.  Why is it not doing that?
>>>
>>
>> Good question. I'm not that familiar with the dw_mmc host controller nor
>> its driver implementation so I'll let Yuvaraj or Doug to answer that.
Well,here it goes!
1. Power ON the board LDO4CTRL1[7:6] 11b
2. dw_mmc driver enable the vqmmc.
3. checks for UHS support, complete the voltage switching t0 1.8V
4. Does warm reset by reboot command.
5. mmc core calls mmc_set_ios() with MMC_POWER_OFF.
6. dw_mmc driver cut-off the regulator with LDO4CTRL1[7:6] is 00b
7.dw_mmc driver enable the vqmmc.
 But after step 7 also, LD4CTRL[7:6] is 00b.
>
> I haven't seen the issue that Yuvaraj is reporting (but I also haven't
> picked up all of the relevant patches and tried to reproduce), so I'm
> going to have to leave it to Yuvaraj to answer.
    static int max77802_enable(struct regulator_dev *rdev)
    {
      struct max77802_regulator_prv *max77802 = rdev_get_drvdata(rdev);
     int id = rdev_get_id(rdev);
     int shift = max77802_get_opmode_shift(id);
     return regmap_update_bits(rdev->regmap,
rdev->desc->enable_reg,rdev->desc->enable_mask,max77802->opmode[id] <<
shift);
  }
I think in the above code snippet, the "val" is what we got it during
the probe.We always write that value for enabling this regulator(which
is LDO4CTRL1[7:6] 00b after warm reset) which is not correct according
the MAX77802 manual.
>
> As far as I know the dw_mmc driver ought to be enabling vqmmc when it
> needs it.  Perhaps there's a bug in your patch series that adds vqmmc
> support to dw_mmc?
>
> -Doug
