Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752827AbaJMFLh (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Oct 2014 01:11:37 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:50337 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750808AbaJMFLe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Oct 2014 01:11:34 -0400
MIME-Version: 1.0
In-Reply-To: <00f301cfe6a3$78e90ab0$6abb2010$%tikhomirov@samsung.com>
References: <1412677176-3850-1-git-send-email-gautam.vivek@samsung.com>
	<1412677176-3850-4-git-send-email-gautam.vivek@samsung.com>
	<00f301cfe6a3$78e90ab0$6abb2010$%tikhomirov@samsung.com>
Date: Mon, 13 Oct 2014 10:41:32 +0530
X-Google-Sender-Auth: cF1pzgFCKkA3xyBfzlm-7WNm6v8
Message-ID: <CAFp+6iEZhuxV=yTCh4WjApwpvpsr1fmjuACeDZiwPyZdX+5k=w@mail.gmail.com>
Subject: Re: [PATCH v2 3/4] phy: exynos5-usbdrd: Add facility for
 VBUS-BOOST-5V supply
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Anton Tikhomirov <av.tikhomirov@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-omap@vger.kernel.org" <linux-omap@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>,
        Mark Rutland <mark.rutland@arm.com>, Pawel Moll <pawel.moll@arm.com>,
        "robh+dt" <robh+dt@kernel.org>, kishon <kishon@ti.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Oct 13, 2014 at 10:36 AM, Anton Tikhomirov
<av.tikhomirov@samsung.com> wrote:
> Hi Vivek,
>
>> Some Exynos SoCs have a separate regulator controlling a
>
> I guess you meant the Exynos based *boards* instead of SoCs,
> since Exynos SoCs don't have any boost regulators.

Right, should be boards instead. Thanks for pointing it out.

>
>> Boost 5V supply which goes as input for VBUS regulator.
>> So adding a control for the same in driver, to enable
>> vbus supply on the port.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/phy/phy-exynos5-usbdrd.c |   30 ++++++++++++++++++++++++++++--
>>  1 file changed, 28 insertions(+), 2 deletions(-)
>>
>> diff --git a/drivers/phy/phy-exynos5-usbdrd.c b/drivers/phy/phy-
>> exynos5-usbdrd.c
>> index 013ee84..57e8a0a 100644
>> --- a/drivers/phy/phy-exynos5-usbdrd.c
>> +++ b/drivers/phy/phy-exynos5-usbdrd.c
>> @@ -176,6 +176,7 @@ struct exynos5_usbdrd_phy {
>>       u32 extrefclk;
>>       struct clk *ref_clk;
>>       struct regulator *vbus;
>> +     struct regulator *vbus_boost;
>>  };
>>
>>  static inline
>> @@ -455,11 +456,20 @@ static int exynos5_usbdrd_phy_power_on(struct phy
>> *phy)
>>       clk_prepare_enable(phy_drd->ref_clk);
>>
>>       /* Enable VBUS supply */
>> +     if (phy_drd->vbus_boost) {
>> +             ret = regulator_enable(phy_drd->vbus_boost);
>> +             if (ret) {
>> +                     dev_err(phy_drd->dev,
>> +                             "Failed to enable VBUS boost supply\n");
>> +                     goto fail_vbus;
>> +             }
>> +     }
>> +
>>       if (phy_drd->vbus) {
>>               ret = regulator_enable(phy_drd->vbus);
>>               if (ret) {
>>                       dev_err(phy_drd->dev, "Failed to enable VBUS
>> supply\n");
>> -                     goto fail_vbus;
>> +                     goto fail_vbus_boost;
>>               }
>>       }
>>
>> @@ -468,6 +478,10 @@ static int exynos5_usbdrd_phy_power_on(struct phy
>> *phy)
>>
>>       return 0;
>>
>> +fail_vbus_boost:
>> +     if (phy_drd->vbus_boost)
>> +             regulator_disable(phy_drd->vbus_boost);
>> +
>>  fail_vbus:
>>       clk_disable_unprepare(phy_drd->ref_clk);
>>       clk_disable_unprepare(phy_drd->pipeclk);
>> @@ -489,6 +503,8 @@ static int exynos5_usbdrd_phy_power_off(struct phy
>> *phy)
>>       /* Disable VBUS supply */
>>       if (phy_drd->vbus)
>>               regulator_disable(phy_drd->vbus);
>> +     if (phy_drd->vbus_boost)
>> +             regulator_disable(phy_drd->vbus_boost);
>>
>>       clk_disable_unprepare(phy_drd->ref_clk);
>>       clk_disable_unprepare(phy_drd->pipeclk);
>> @@ -644,7 +660,7 @@ static int exynos5_usbdrd_phy_probe(struct
>> platform_device *pdev)
>>               break;
>>       }
>>
>> -     /* Get Vbus regulator */
>> +     /* Get Vbus regulators */
>>       phy_drd->vbus = devm_regulator_get(dev, "vbus");
>>       if (IS_ERR(phy_drd->vbus)) {
>>               ret = PTR_ERR(phy_drd->vbus);
>> @@ -655,6 +671,16 @@ static int exynos5_usbdrd_phy_probe(struct
>> platform_device *pdev)
>>               phy_drd->vbus = NULL;
>>       }
>>
>> +     phy_drd->vbus_boost = devm_regulator_get(dev, "vbus-boost");
>> +     if (IS_ERR(phy_drd->vbus_boost)) {
>> +             ret = PTR_ERR(phy_drd->vbus_boost);
>> +             if (ret == -EPROBE_DEFER)
>> +                     return ret;
>> +
>> +             dev_warn(dev, "Failed to get VBUS boost supply
>> regulator\n");
>> +             phy_drd->vbus_boost = NULL;
>> +     }
>> +
>>       dev_vdbg(dev, "Creating usbdrd_phy phy\n");
>>
>>       for (i = 0; i < EXYNOS5_DRDPHYS_NUM; i++) {
>> --
>> 1.7.10.4
>>
>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-usb" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-samsung-soc" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html



-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
