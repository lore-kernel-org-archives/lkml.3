Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752184AbaDXGka (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:40:30 -0400
Received: from mail-qa0-f49.google.com ([209.85.216.49]:46632 "EHLO
	mail-qa0-f49.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751475AbaDXGk2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:40:28 -0400
MIME-Version: 1.0
In-Reply-To: <000001cf5f5c$2f6c2440$8e446cc0$%han@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
	<002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
	<001a01cf5f54$af090810$0d1b1830$%han@samsung.com>
	<000001cf5f5c$2f6c2440$8e446cc0$%han@samsung.com>
Date: Thu, 24 Apr 2014 12:10:27 +0530
X-Google-Sender-Auth: p-aBg8MjQ4Pjw3J2mEPjDlJJ5iw
Message-ID: <CAFp+6iGo-Rk8d28=dosVW63f-ZrZjmxj9fsm7D7Vn4-HdhSgjw@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Jingoo Han <jg1.han@samsung.com>
Cc: Anton Tikhomirov <av.tikhomirov@samsung.com>,
        Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Jingoo,


On Thu, Apr 24, 2014 at 6:56 AM, Jingoo Han <jg1.han@samsung.com> wrote:
> On Thursday, April 24, 2014 9:33 AM, Jingoo Han wrote:
>> On Thursday, April 24, 2014 9:18 AM, Anton Tikhomirov wrote:
>> > On Monday, April 21, 2014 9:17 PM, Vivek Gautam wrote:
>> > >
>> > > Facilitate getting required 3.3V and 1.0V VDD supply for
>> > > OHCI controller on Exynos.
>> > >
>> > > With patches for regulators' nodes merged in 3.15:
>> > > c8c253f ARM: dts: Add regulator entries to smdk5420
>> > > 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
>> > >
>> > > certain perripherals will now need to ensure that,
>> > > they request VDD regulators in their drivers, and enable
>> > > them so as to make them working.
>> > >
>> > > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> > > Cc: Jingoo Han <jg1.han@samsung.com>
>> > > ---
>> > >
>> > > Based on 'usb-next' branch of Greg's usb tree.
>> > >
>> > >  drivers/usb/host/ohci-exynos.c |   47
>> > > ++++++++++++++++++++++++++++++++++++++++
>> > >  1 file changed, 47 insertions(+)
>> > >
>> > > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-
>> > > exynos.c
>> > > index 68588d8..e2e72a8 100644
>> > > --- a/drivers/usb/host/ohci-exynos.c
>> > > +++ b/drivers/usb/host/ohci-exynos.c

[snip]

>> > > @@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct platform_device
>> > > *pdev)
>> > >           exynos_ohci->otg = phy->otg;
>> > >   }
>> > >
>> > > + exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
>> > > + if (IS_ERR(exynos_ohci->vdd33)) {
>> > > +         err = PTR_ERR(exynos_ohci->vdd33);
>> > > +         goto fail_regulator1;
>> > > + }
>> > > + err = regulator_enable(exynos_ohci->vdd33);
>> > > + if (err) {
>> > > +         dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
>> > > +         goto fail_regulator1;
>> > > + }
>> > > +
>> > > + exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
>> > > + if (IS_ERR(exynos_ohci->vdd10)) {
>> > > +         err = PTR_ERR(exynos_ohci->vdd10);
>> > > +         goto fail_regulator2;
>> > > + }
>> > > + err = regulator_enable(exynos_ohci->vdd10);
>> > > + if (err) {
>> > > +         dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
>> > > +         goto fail_regulator2;
>> > > + }
>> > > +
>> >
>> > Do we need to skip regulator settings together with PHY configuration
>> > in case of exynos5440?
>>
>> Oh, right. In the case of exynos5440, regulator settings is not
>> necessary. Vivek, would you fix it in order skip regulator settings
>> in exynos5440? It also applies to ehci-exynos.
>
> Sorry, in the case of exynos5440, this patch already skips
> regulator settings.
>
> In the case of exynos5440, there is no need to set PHY setting
> and regulator setting.

Right, in case of exynos5440, we are skipping PHY setting and regulator setting.
Actually i had missed taking into account 5440, so just curious. Do we
really not need a regulator
settings for Exynos5440 ?

>
> How about making regulator setting "optional"?
> Then, regulator setting can be done, only when regulator
> is supported.

True, so with Exynos5440 not needing the regulator, we should make the
regulator settings optional.

>
> exynos_ohci_probe()
>         exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
>         if (IS_ERR(exynos_ohci->vdd33)) {
>                 dev_err(&pdev->dev, "Failed to get VDD33 supply\n");
>         } else {
>                 err = regulator_enable(exynos_ohci->vdd33);
>                 if (err) {
>                         dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
>                         goto fail_regulator1;
>                 }
>         }
>
>         exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
>         if (IS_ERR(exynos_ohci->vdd10)) {
>                 dev_err(&pdev->dev, "Failed to get VDD10 supply\n");
>         } else {
>                 err = regulator_enable(exynos_ohci->vdd10);
>                 if (err) {
>                         dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
>                         goto fail_regulator2;
>                 }
>         }
>
> In this case, suspend/resume can be fixed as below.
>
> exynos_ohci_suspend()
>         if (exynos_ohci->vdd10)
>                 regulator_disable(exynos_ohci->vdd10);
>         if (exynos_ohci->vdd33)
>                 regulator_disable(exynos_ohci->vdd33);
>
> exynos_ohci_resume()
>
>         if (exynos_ohci->vdd33) {
>                 ret = regulator_enable(exynos_ohci->vdd33);
>                 if (ret) {
>                         dev_err(dev, "Failed to enable VDD33 supply\n");
>                         return ret;
>                 }
>         }
>         if (exynos_ohci->vdd10) {
>                 ret = regulator_enable(exynos_ohci->vdd10);
>                 if (ret) {
>                         dev_err(dev, "Failed to enable VDD10 supply\n");
>                         return ret;
>                 }
>         }

Thanks for the suggestion.
I will make the required changes, and post the patchset again.

[snip]


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
