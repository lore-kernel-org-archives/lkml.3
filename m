Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756993Ab3ANXui (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jan 2013 18:50:38 -0500
Received: from mail-lb0-f173.google.com ([209.85.217.173]:35116 "EHLO
	mail-lb0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755811Ab3ANXuh (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jan 2013 18:50:37 -0500
MIME-Version: 1.0
In-Reply-To: <CAFp+6iF4Q2uUzJKf8d-jMZoxBcVzxBAxLyKDqF4B8=p+_JYuCQ@mail.gmail.com>
References: <1355841786-13307-1-git-send-email-gautam.vivek@samsung.com>
	<1355841786-13307-3-git-send-email-gautam.vivek@samsung.com>
	<CAD=FV=WMjqszsTQja82_uZc4Ue50TfTmSNO2yOhSMCX1w1L5Dg@mail.gmail.com>
	<CAFp+6iHYRRS3uSWnmdqBvfOgUDKKJUzMvqoj1HP2uXS=Fdaifg@mail.gmail.com>
	<CAD=FV=XhMbWjCR5r=R3+zE1524NuUUvFDf2HZuCrXPmsei4BNA@mail.gmail.com>
	<CAFp+6iHFw2orVOxxzb+daQJsA46zUk2ZOA=h6QwGAme18JngXw@mail.gmail.com>
	<CAFp+6iF4Q2uUzJKf8d-jMZoxBcVzxBAxLyKDqF4B8=p+_JYuCQ@mail.gmail.com>
Date: Mon, 14 Jan 2013 15:45:30 -0800
Message-ID: <CAD=FV=Vxo8D+W_=m1+ODEarMXgCgcT0cSs3KekTkGyvVVANyMA@mail.gmail.com>
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


On Mon, Jan 14, 2013 at 12:06 AM, Vivek Gautam
<gautamvivek1987@gmail.com> wrote:
>> Is it fine if we don't use macro for SHIFT, earlier code also doesn't use it.
>> Can we just do like this ..
>> #define HOST_CTRL0_FSEL_MASK                       (0x7 << 16)
>> #define HOST_CTRL0_FSEL_CLKSEL_50M            (0x7 << 16)
>> #define HOST_CTRL0_FSEL_CLKSEL_24M            (0x5 << 16)
>> #define HOST_CTRL0_FSEL_CLKSEL_20M            (0x4 << 16)
>> #define HOST_CTRL0_FSEL_CLKSEL_19200K       (0x3 << 16)
>> #define HOST_CTRL0_FSEL_CLKSEL_12M            (0x2 << 16)
>> #define HOST_CTRL0_FSEL_CLKSEL_10M            (0x1 << 16)
>> #define HOST_CTRL0_FSEL_CLKSEL_9600K         (0x0 << 16)

I don't have a problem with just putting the << 16 there...

> Actually missed one thing here, this "HOST_CTRL0_FSEL_CLKSEL_XX" is
> being used by
> HOST/OTG blocks to prepare reference clock, that's the reason we kept
>             #define HOST_CTRL0_FSEL(_x)                  ((_x) << 16)
> and       #define OTG_SYS_FSEL(_x)                       ((_x) << 4)
> where (_x) is the reference clock returned from
> samsung_usbphy_get_refclk_freq().

I feel like samsung_usbphy_get_refclk_freq() is supposed to be
returning an already shifted value.  ...at least that's how it appears
to work with existing code.  Why does it feel like that?  ...because
with existing code we have:

#define PHYCLK_CLKSEL_MASK (0x3 << 0)
#define PHYCLK_CLKSEL_48M (0x0 << 0)
#define PHYCLK_CLKSEL_12M (0x2 << 0)
#define PHYCLK_CLKSEL_24M (0x3 << 0)

Those #defines are what are returned by
samsung_usbphy_get_refclk_freq().  The fact that the "<< 0" is there
implies (to me) that the existing function would return shifted values
if it were applicable.

For exynos you are having the same function return things like:

#define FSEL_CLKSEL_50M (0x7)
#define FSEL_CLKSEL_24M (0x5)
#define FSEL_CLKSEL_20M (0x4)

...to me that means that the exynos code is returning unshifted values.


If you say that samsung_usbphy_get_refclk_freq() is in charge of
returning shifted values then you no longer need the HOST_CTRL0_FSEL()
macro.


In any case, I will defer to whatever Felipe thinks is best here (if
he has an opinion on it).  I am only pointing out that the exynos code
and existing code seem to be specifying things differently.  That's
weird to me.


> so we can change this to something like
>
>                            case 10 * MHZ:
>                                      refclk_freq = FSEL_CLKSEL_10M;
>                                      break;
> and so on.
> will this be fine ?

Seems good to me.


-Doug
