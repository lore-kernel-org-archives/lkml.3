Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757399Ab3A1M1J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 07:27:09 -0500
Received: from mail-bk0-f53.google.com ([209.85.214.53]:54080 "EHLO
	mail-bk0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751895Ab3A1M1H (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 07:27:07 -0500
MIME-Version: 1.0
In-Reply-To: <20130128121231.GH28698@arwen.pp.htv.fi>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
	<1359373348-18320-4-git-send-email-gautam.vivek@samsung.com>
	<20130128114755.GF28698@arwen.pp.htv.fi>
	<CAFp+6iEb4R3NQkvtrY8X4h8oMwPf7E+LDYfb_cS5z2WfdGHNWA@mail.gmail.com>
	<20130128121231.GH28698@arwen.pp.htv.fi>
Date: Mon, 28 Jan 2013 17:57:04 +0530
Message-ID: <CAFp+6iHvH8ZXRGEb=5AsVX+Ks+mAaPqwWW9DhH9O7RNdKo+cgw@mail.gmail.com>
Subject: Re: [PATCH 3/4] usb: dwc3: exynos: Enable runtime power management
From: Vivek Gautam <gautamvivek1987@gmail.com>
To: balbi@ti.com
Cc: Vivek Gautam <gautam.vivek@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org, linux-omap@vger.kernel.org,
        linux-samsung-soc@vger.kernel.org, gregkh@linuxfoundation.org,
        sarah.a.sharp@linux.intel.com, kgene.kim@samsung.com,
        dianders@chromium.org, sylvester.nawrocki@gmail.com,
        tomasz.figa@gmail.com
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 28, 2013 at 5:42 PM, Felipe Balbi <balbi@ti.com> wrote:
> Hi,
>
> On Mon, Jan 28, 2013 at 05:28:30PM +0530, Vivek Gautam wrote:
>> >> +static int dwc3_exynos_runtime_resume(struct device *dev)
>> >> +{
>> >> +     struct dwc3_exynos      *exynos = dev_get_drvdata(dev);
>> >> +     struct platform_device  *pdev_dwc = exynos->dwc3;
>> >> +     struct dwc3             *dwc = NULL;
>> >> +
>> >> +     dwc = platform_get_drvdata(pdev_dwc);
>> >> +
>> >> +     clk_enable(exynos->clk);
>> >> +
>> >> +     if (!dwc)
>> >> +             return 0;
>> >> +
>> >> +     pm_runtime_get_sync(dwc->usb3_phy->dev);
>> >
>> > dude, this is wrong :-)
>> >
>> > look at this:
>> >
>> > pm_runtime_get() -> dwc3_exynos_runtime_resume() ->
>> > pm_runtime_get_sync() -> dwc3_exynos_runtime_resume() -> ...
>> >
>> > only your clock enalbe should do
>> >
>>
>> We want to wake up "dwc->usb3_phy" so tried to call pm_runtime_get_sync()
>> with "dwc->usb3_phy->dev".
>> Missing something ? :-(
>
> oh, my bad. That's the PHY... But we can't really do that for samsung
> only. It needs to be done generically for the entire dwc3 core driver,
> and for that we need to introduce usb_phy_autopm_get(),
> usb_phy_autopm_get_sync() and friends.
>

aah!! Ok. I definitely missed that part. :-(

> Then, from dwc_probe() we call:
>
> phy = usb_get_phy();
> usb_phy_autopm_enable(phy);
> usb_phy_autopm_get_sync(phy);
>
> or something similar ;-) Bottom line, you shouldn't fiddle with phy->dev
> directly.
>

Ok, the core should actually be handling the 'phy' not the glue layers.
Right ?

Will try putting these helper functions in place and come up with a
solution. :-)


-- 
Thanks & Regards
Vivek
