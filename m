Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755311AbaICDxJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Sep 2014 23:53:09 -0400
Received: from mail-vc0-f170.google.com ([209.85.220.170]:62762 "EHLO
	mail-vc0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755093AbaICDxG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Sep 2014 23:53:06 -0400
MIME-Version: 1.0
In-Reply-To: <CAD=FV=Xq+EaSX=wqkpRVKg5e5Rf-CMWD8ZBJ_-SZqoo-KrX0LA@mail.gmail.com>
References: <1409562468-16586-1-git-send-email-zyw@rock-chips.com>
	<1409564586-18421-1-git-send-email-zyw@rock-chips.com>
	<CAD=FV=X-hSHKe4_QRxFLejok-qVYM_FyXO7L7X6AzW8sTaVPnQ@mail.gmail.com>
	<54067674.3040007@rock-chips.com>
	<CAD=FV=Xq+EaSX=wqkpRVKg5e5Rf-CMWD8ZBJ_-SZqoo-KrX0LA@mail.gmail.com>
Date: Tue, 2 Sep 2014 20:53:05 -0700
X-Google-Sender-Auth: LW4lvMesMzQ8sjuCLnicZXBz8vg
Message-ID: <CAD=FV=UXLUvvQfG4oEwcC3-ts8vVkUzZhcrfc9v6EvUvybfvOg@mail.gmail.com>
Subject: Re: [PATCH v7 3/5] RTC: RK808: add RTC driver for RK808
From: Doug Anderson <dianders@chromium.org>
To: Chris Zhong <zyw@rock-chips.com>
Cc: Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Lee Jones <lee.jones@linaro.org>,
        Liam Girdwood <lgirdwood@gmail.com>,
        Alessandro Zummo <a.zummo@towertech.it>,
        Mike Turquette <mturquette@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        rtc-linux@googlegroups.com, Grant Likely <grant.likely@linaro.org>,
        Lin Huang <hl@rock-chips.com>, Tao Huang <huangtao@rock-chips.com>,
        Eddie Cai <cf@rock-chips.com>, zhangqing <zhangqing@rock-chips.com>,
        xxx <xxx@rock-chips.com>,
        =?UTF-8?Q?Heiko_St=C3=BCbner?= <heiko@sntech.de>,
        Olof Johansson <olof@lixom.net>, Sonny Rao <sonnyrao@chromium.org>,
        Dmitry Torokhov <dtor@chromium.org>,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Kever Yang <kever.yang@rock-chips.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Tue, Sep 2, 2014 at 8:52 PM, Doug Anderson <dianders@chromium.org> wrote:
> Chris,
>
> On Tue, Sep 2, 2014 at 7:01 PM, Chris Zhong <zyw@rock-chips.com> wrote:
>>
>> On 09/02/2014 11:58 AM, Doug Anderson wrote:
>>>>
>>>> +static int rk808_rtc_probe(struct platform_device *pdev)
>>>> >+{
>>>> >+       struct rk808 *rk808 = dev_get_drvdata(pdev->dev.parent);
>>>> >+       struct rk808_rtc *rk808_rtc;
>>>> >+       struct rtc_time tm;
>>>> >+       int ret;
>>>> >+
>>>> >+       rk808_rtc = devm_kzalloc(&pdev->dev, sizeof(*rk808_rtc),
>>>> > GFP_KERNEL);
>>>> >+       if (rk808_rtc == NULL)
>>>> >+               return -ENOMEM;
>>>> >+
>>>> >+       platform_set_drvdata(pdev, rk808_rtc);
>>>> >+       rk808_rtc->rk808 = rk808;
>>>> >+
>>>> >+       /* start rtc running by default, and use shadowed timer. */
>>>> >+       ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
>>>> >+                                BIT_RTC_CTRL_REG_STOP_RTC_M |
>>>> >+                                BIT_RTC_CTRL_REG_RTC_READSEL_M,
>>>> >+                                BIT_RTC_CTRL_REG_RTC_READSEL_M);
>>>
>>> I think this should still be setting to 0, not to
>>> BIT_RTC_CTRL_REG_RTC_READSEL_M.  Otherwise the first read of the time
>>> will return that time that was frozen at probe time, right?  AKA: if
>>> probe happens at 11:00:00 and then we read the time at 11:00:05 we'll
>>> still read 11:00:00 the first time.
>>>
>>  Sorry, I did not describe correctly, in the previous mail.
>>  Actually, RK808 has a "GET_TIME" switch bit. When "GET_TIME" bit rising
>> thansiton to 1,
>>  the current time will save in a shadowed register.
>>  If "READSEL" = 1, read rtc time register, return the frozen time.
>>  If we need the real time, clr this "READSEL" bit.
>
> Ohhhhh!  I see.  I clearly didn't look closely enough at the whole
> register description in the user manual.  I think you've got it right,
> then.
>
> I think this would be more obvious if you added a comment and you set
> both the high and low bits at the same time.  AKA:
>
> +       /* Force an update of the shadowed registers right now */
> +       ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
> +                                BIT_RTC_CTRL_REG_RTC_GET_TIME,
> +                                BIT_RTC_CTRL_REG_RTC_GET_TIME);
> +       if (ret) {
> +               dev_err(dev, "Failed to update bits rtc_ctrl: %d\n", ret);
> +               return ret;
> +       }
> +
> +       ret = regmap_update_bits(rk808->regmap, RK808_RTC_CTRL_REG,
> +                                BIT_RTC_CTRL_REG_RTC_GET_TIME,
> +                                BIT_RTC_CTRL_REG_RTC_GET_TIME);

Doh, this one was supposed to be setting it back to 0.
