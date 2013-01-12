Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755742Ab3ALAzy (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jan 2013 19:55:54 -0500
Received: from mail-lb0-f175.google.com ([209.85.217.175]:63038 "EHLO
	mail-lb0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753355Ab3ALAzx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jan 2013 19:55:53 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iHYRRS3uSWnmdqBvfOgUDKKJUzMvqoj1HP2uXS=Fdaifg@mail.gmail.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-3-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=WMjqszsTQja82_uZc4Ue50TfTmSNO2yOhSMCX1w1L5Dg@mail.gmail.com>
	<CAFp+6iHYRRS3uSWnmdqBvfOgUDKKJUzMvqoj1HP2uXS=Fdaifg@mail.gmail.com>
Date: Fri, 11 Jan 2013 16:50:45 -0800
Message-ID: <CAD=FV=XhMbWjCR5r=R3+zE1524NuUUvFDf2HZuCrXPmsei4BNA@mail.gmail.com>
Subject: Re: [PATCH v5 2/4] usb: phy: samsung: Add host phy support to
 samsung-phy driver
From: Doug Anderson <dianders@chromium.org>
To: Vivek Gautam <gautamvivek1987@gmail.com>
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        yulgon.kim@samsung.com, linux-samsung-soc@vger.kernel.org,
        Praveen Paneri <p.paneri@samsung.com>, gregkh@linuxfoundation.org,
        devicetree-discuss@lists.ozlabs.org, jg1.han@samsung.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        balbi@ti.com, kishon@ti.com, Kukjin Kim <kgene.kim@samsung.com>,
        Alan Stern <stern@rowland.harvard.edu>,
        Rob Herring <rob.herring@calxeda.com>,
        Sylwester Nawrocki <sylvester.nawrocki@gmail.com>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Vivek,

On Fri, Jan 11, 2013 at 4:40 AM, Vivek Gautam <gautamvivek1987@gmail.com> wrote:
>>> +#define HOST_CTRL0_REFCLKSEL_MASK              (0x3)
>>> +#define HOST_CTRL0_REFCLKSEL_XTAL              (0x0 << 19)
>>> +#define HOST_CTRL0_REFCLKSEL_EXTL              (0x1 << 19)
>>> +#define HOST_CTRL0_REFCLKSEL_CLKCORE           (0x2 << 19)
>>> +
>>> +#define HOST_CTRL0_FSEL_MASK                   (0x7 << 16)
>>> +#define HOST_CTRL0_FSEL(_x)                    ((_x) << 16)
>>> +#define HOST_CTRL0_FSEL_CLKSEL_50M             (0x7)
>>> +#define HOST_CTRL0_FSEL_CLKSEL_24M             (0x5)
>>> +#define HOST_CTRL0_FSEL_CLKSEL_20M             (0x4)
>>> +#define HOST_CTRL0_FSEL_CLKSEL_19200K          (0x3)
>>> +#define HOST_CTRL0_FSEL_CLKSEL_12M             (0x2)
>>> +#define HOST_CTRL0_FSEL_CLKSEL_10M             (0x1)
>>> +#define HOST_CTRL0_FSEL_CLKSEL_9600K           (0x0)
>>
>> Add the shifts to the #defines and remove HOST_CTRL0_FSEL(_x).  That
>> makes it match the older phy more closely.
>>
> Wouldn't it hamper the readability when shifts are used ??
> I mean if we have something like this -
>
> phyhost |= HOST_CTRL0_FSEL(phyclk)
>
> so, if we are using the shifts then
> phyhost |= (HOST_CTRL0_FSEL_CLKSEL_24M << HOST_CTRL0_FSEL_SHIFT)

I was actually suggesting modifying the #defines like this:

#define HOST_CTRL0_FSEL_SHIFT 16
#define HOST_CTRL0_FSEL_MASK                   (0x7 << HOST_CTRL0_FSEL_SHIFT)
#define HOST_CTRL0_FSEL_CLKSEL_50M             (0x7 << HOST_CTRL0_FSEL_SHIFT)
#define HOST_CTRL0_FSEL_CLKSEL_24M             (0x5 << HOST_CTRL0_FSEL_SHIFT)
#define HOST_CTRL0_FSEL_CLKSEL_20M             (0x4 << HOST_CTRL0_FSEL_SHIFT)
#define HOST_CTRL0_FSEL_CLKSEL_19200K          (0x3 << HOST_CTRL0_FSEL_SHIFT)
#define HOST_CTRL0_FSEL_CLKSEL_12M             (0x2 << HOST_CTRL0_FSEL_SHIFT)
#define HOST_CTRL0_FSEL_CLKSEL_10M             (0x1 << HOST_CTRL0_FSEL_SHIFT)
#define HOST_CTRL0_FSEL_CLKSEL_9600K           (0x0 << HOST_CTRL0_FSEL_SHIFT)

...then the code doesn't need to think about shifts, right?


>>>         if (IS_ERR(ref_clk)) {
>>>                 dev_err(sphy->dev, "Failed to get reference clock\n");
>>>                 return PTR_ERR(ref_clk);
>>>         }
>>>
>>> -       switch (clk_get_rate(ref_clk)) {
>>> -       case 12 * MHZ:
>>> -               refclk_freq = PHYCLK_CLKSEL_12M;
>>> -               break;
>>> -       case 24 * MHZ:
>>> -               refclk_freq = PHYCLK_CLKSEL_24M;
>>> -               break;
>>> -       case 48 * MHZ:
>>> -               refclk_freq = PHYCLK_CLKSEL_48M;
>>> -               break;
>>> -       default:
>>> -               if (sphy->cpu_type == TYPE_S3C64XX)
>>> -                       refclk_freq = PHYCLK_CLKSEL_48M;
>>> -               else
>>> +       if (sphy->cpu_type == TYPE_EXYNOS5250) {
>>> +               /* set clock frequency for PLL */
>>> +               switch (clk_get_rate(ref_clk)) {
>>> +               case 96 * 100000:
>>
>> nit: change to 9600 * KHZ to match; below too.
>>
> sure.
>
>>> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_9600K;
>>
>> Why |= with 0?
>>
> kept this just to keep things look similar :-). will remove this line,

My comment was about keeping things similar.  Right now the 5250 code
has the |= and the non-5250 code doesn't.  I don't care which is
picked but the two sides of the "if" should be symmetric.

See parts of the patch below.

>>> +                       break;
>>> +               case 10 * MHZ:
>>> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_10M;
>>> +                       break;
>>> +               case 12 * MHZ:
>>> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_12M;
>>> +                       break;
>>> +               case 192 * 100000:
>>> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_19200K;
>>> +                       break;
>>> +               case 20 * MHZ:
>>> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_20M;
>>> +                       break;
>>> +               case 50 * MHZ:
>>> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_50M;
>>> +                       break;
>>> +               case 24 * MHZ:
>>> +               default:
>>> +                       /* default reference clock */
>>> +                       refclk_freq |= HOST_CTRL0_FSEL_CLKSEL_24M;
>>> +                       break;
>>> +               }
>>> +       } else {
>>> +               switch (clk_get_rate(ref_clk)) {
>>> +               case 12 * MHZ:
>>> +                       refclk_freq = PHYCLK_CLKSEL_12M;
>>> +                       break;
>>> +               case 24 * MHZ:
>>>                         refclk_freq = PHYCLK_CLKSEL_24M;
>>> -               break;
>>> +                       break;
>>> +               case 48 * MHZ:
>>> +                       refclk_freq = PHYCLK_CLKSEL_48M;
>>> +                       break;
>>> +               default:
>>> +                       if (sphy->cpu_type == TYPE_S3C64XX)
>>> +                               refclk_freq = PHYCLK_CLKSEL_48M;
>>> +                       else
>>> +                               refclk_freq = PHYCLK_CLKSEL_24M;
>>> +                       break;
>>> +               }
>>>         }
>>>         clk_put(ref_clk);
>>>
>>>         return refclk_freq;
>>>  }

-Doug
