Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757075Ab3A1L6h (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jan 2013 06:58:37 -0500
Received: from mail-bk0-f52.google.com ([209.85.214.52]:61773 "EHLO
	mail-bk0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754469Ab3A1L6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jan 2013 06:58:32 -0500
MIME-Version: 1.0
In-Reply-To: <20130128114755.GF28698@arwen.pp.htv.fi>
References: <1359373348-18320-1-git-send-email-gautam.vivek@samsung.com>
	<1359373348-18320-4-git-send-email-gautam.vivek@samsung.com>
	<20130128114755.GF28698@arwen.pp.htv.fi>
Date: Mon, 28 Jan 2013 17:28:30 +0530
Message-ID: <CAFp+6iEb4R3NQkvtrY8X4h8oMwPf7E+LDYfb_cS5z2WfdGHNWA@mail.gmail.com>
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

Hi Balbi,


On Mon, Jan 28, 2013 at 5:17 PM, Felipe Balbi <balbi@ti.com> wrote:
> On Mon, Jan 28, 2013 at 05:12:27PM +0530, Vivek Gautam wrote:
>> Enabling runtime power management on dwc3-exynos to save
>> power and allow its PHY's power to be managed at runtime.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> ---
>>  drivers/usb/dwc3/dwc3-exynos.c |   47 ++++++++++++++++++++++++++++++++++++++++
>>  1 files changed, 47 insertions(+), 0 deletions(-)
>>
>> diff --git a/drivers/usb/dwc3/dwc3-exynos.c b/drivers/usb/dwc3/dwc3-exynos.c
>> index aae5328..c51e8c1 100644
>> --- a/drivers/usb/dwc3/dwc3-exynos.c
>> +++ b/drivers/usb/dwc3/dwc3-exynos.c
>> @@ -157,11 +157,15 @@ static int dwc3_exynos_probe(struct platform_device *pdev)
>>               goto err4;
>>       }
>>
>> +     pm_runtime_set_active(&pdev->dev);
>> +     pm_runtime_enable(&pdev->dev);
>> +
>>       return 0;
>>
>>  err4:
>>       clk_disable(clk);
>>       clk_put(clk);
>> +     pm_runtime_disable(&pdev->dev);
>>  err3:
>>       platform_device_put(dwc3);
>>  err1:
>> @@ -174,6 +178,8 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
>>  {
>>       struct dwc3_exynos      *exynos = platform_get_drvdata(pdev);
>>
>> +     pm_runtime_disable(&pdev->dev);
>> +
>>       platform_device_unregister(exynos->dwc3);
>>       platform_device_unregister(exynos->usb2_phy);
>>       platform_device_unregister(exynos->usb3_phy);
>> @@ -186,6 +192,46 @@ static int dwc3_exynos_remove(struct platform_device *pdev)
>>       return 0;
>>  }
>>
>> +static int dwc3_exynos_runtime_suspend(struct device *dev)
>> +{
>> +     struct dwc3_exynos      *exynos = dev_get_drvdata(dev);
>> +     struct platform_device  *pdev_dwc = exynos->dwc3;
>> +     struct dwc3             *dwc = NULL;
>> +
>> +     dwc = platform_get_drvdata(pdev_dwc);
>> +
>> +     if (!dwc)
>> +             return 0;
>> +
>> +     pm_runtime_put_sync(dwc->usb3_phy->dev);
>> +
>> +     clk_disable(exynos->clk);
>> +
>> +     return 0;
>> +}
>> +static int dwc3_exynos_runtime_resume(struct device *dev)
>> +{
>> +     struct dwc3_exynos      *exynos = dev_get_drvdata(dev);
>> +     struct platform_device  *pdev_dwc = exynos->dwc3;
>> +     struct dwc3             *dwc = NULL;
>> +
>> +     dwc = platform_get_drvdata(pdev_dwc);
>> +
>> +     clk_enable(exynos->clk);
>> +
>> +     if (!dwc)
>> +             return 0;
>> +
>> +     pm_runtime_get_sync(dwc->usb3_phy->dev);
>
> dude, this is wrong :-)
>
> look at this:
>
> pm_runtime_get() -> dwc3_exynos_runtime_resume() ->
> pm_runtime_get_sync() -> dwc3_exynos_runtime_resume() -> ...
>
> only your clock enalbe should do
>

We want to wake up "dwc->usb3_phy" so tried to call pm_runtime_get_sync()
with "dwc->usb3_phy->dev".
Missing something ? :-(




-- 
Thanks & Regards
Vivek
