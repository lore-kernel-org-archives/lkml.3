Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751936AbaDXGdB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 24 Apr 2014 02:33:01 -0400
Received: from mail-qg0-f44.google.com ([209.85.192.44]:43176 "EHLO
	mail-qg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751471AbaDXGc6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 24 Apr 2014 02:32:58 -0400
MIME-Version: 1.0
In-Reply-To: <002e01cf5f55$74aff060$5e0fd120$%tikhomirov@samsung.com>
References: <1398082604-3013-1-git-send-email-gautam.vivek@samsung.com>
	<002b01cf5f52$a7bc0d70$f7342850$%tikhomirov@samsung.com>
	<002e01cf5f55$74aff060$5e0fd120$%tikhomirov@samsung.com>
Date: Thu, 24 Apr 2014 12:02:57 +0530
X-Google-Sender-Auth: Rj-ekDI9bLO_WSDrwm749uLYgWc
Message-ID: <CAFp+6iFTVKHcF8zyfmFcrALHDaRHwXOC3Wbd7rv_X5LvjznPgg@mail.gmail.com>
Subject: Re: [PATCH 1/3] usb: ohci-exynos: Make provision for vdd regulators
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Anton Tikhomirov <av.tikhomirov@samsung.com>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        linux-omap@vger.kernel.org,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Alan Stern <stern@rowland.harvard.edu>, Felipe Balbi <balbi@ti.com>,
        Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Thu, Apr 24, 2014 at 6:08 AM, Anton Tikhomirov
<av.tikhomirov@samsung.com> wrote:
> Hi,
>
>> Hi,
>>
>> > -----Original Message-----
>> > From: linux-usb-owner@vger.kernel.org [mailto:linux-usb-
>> > owner@vger.kernel.org] On Behalf Of Vivek Gautam
>> > Sent: Monday, April 21, 2014 9:17 PM
>> >
>> > Facilitate getting required 3.3V and 1.0V VDD supply for
>> > OHCI controller on Exynos.
>> >
>> > With patches for regulators' nodes merged in 3.15:
>> > c8c253f ARM: dts: Add regulator entries to smdk5420
>> > 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
>> >
>> > certain perripherals will now need to ensure that,
>> > they request VDD regulators in their drivers, and enable
>> > them so as to make them working.
>> >
>> > Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> > Cc: Jingoo Han <jg1.han@samsung.com>
>> > ---
>> >
>> > Based on 'usb-next' branch of Greg's usb tree.
>> >
>> >  drivers/usb/host/ohci-exynos.c |   47
>> > ++++++++++++++++++++++++++++++++++++++++
>> >  1 file changed, 47 insertions(+)
>> >
>> > diff --git a/drivers/usb/host/ohci-exynos.c b/drivers/usb/host/ohci-
>> > exynos.c
>> > index 68588d8..e2e72a8 100644
>> > --- a/drivers/usb/host/ohci-exynos.c
>> > +++ b/drivers/usb/host/ohci-exynos.c

[snip]

>> >  static void exynos_ohci_phy_enable(struct platform_device *pdev)
>> > @@ -98,6 +101,28 @@ static int exynos_ohci_probe(struct
>> platform_device
>> > *pdev)
>> >             exynos_ohci->otg = phy->otg;
>> >     }
>> >
>> > +   exynos_ohci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
>> > +   if (IS_ERR(exynos_ohci->vdd33)) {
>> > +           err = PTR_ERR(exynos_ohci->vdd33);
>> > +           goto fail_regulator1;
>> > +   }
>> > +   err = regulator_enable(exynos_ohci->vdd33);
>> > +   if (err) {
>> > +           dev_err(&pdev->dev, "Failed to enable VDD33 supply\n");
>> > +           goto fail_regulator1;
>> > +   }
>> > +
>> > +   exynos_ohci->vdd10 = devm_regulator_get(&pdev->dev, "vdd10");
>> > +   if (IS_ERR(exynos_ohci->vdd10)) {
>> > +           err = PTR_ERR(exynos_ohci->vdd10);
>> > +           goto fail_regulator2;
>> > +   }
>> > +   err = regulator_enable(exynos_ohci->vdd10);
>> > +   if (err) {
>> > +           dev_err(&pdev->dev, "Failed to enable VDD10 supply\n");
>> > +           goto fail_regulator2;
>> > +   }
>> > +
>>
>> Do we need to skip regulator settings together with PHY configuration
>> in case of exynos5440?
>>
>> >  skip_phy:
>> >     exynos_ohci->clk = devm_clk_get(&pdev->dev, "usbhost");
>> >

[snip]

>> > @@ -218,6 +253,18 @@ static int exynos_ohci_resume(struct device *dev)
>> >     struct usb_hcd *hcd                     = dev_get_drvdata(dev);
>> >     struct exynos_ohci_hcd *exynos_ohci     = to_exynos_ohci(hcd);
>> >     struct platform_device *pdev            = to_platform_device(dev);
>> > +   int ret;
>> > +
>> > +   ret = regulator_enable(exynos_ohci->vdd33);
>> > +   if (ret) {
>> > +           dev_err(dev, "Failed to enable VDD33 supply\n");
>> > +           return ret;
>>
>> Not sure, but shall we continue resuming and do everything
>> we can in case of error? At least it will avoid
>> WARN_ON(clk->enable_count == 0) on next system suspend.

True, i will modify it.
>
> On the other hand, if power is not applied to the controller,
> register access in ohci_resume() may lead to undefined behavior.
> What's your opinion?

AFA i think, it is obvious that the regulators would not work without
a VDD supply.
So the question is, do we have VDD LDOs available on all Exynos
systems for usb ?
>From the schemata of Exynos5250 and Exynos5420 boards, i can see the
required VDD LDOs
for USB. Unfortunately at present i don't have a Exynos4* schemata.

If regulator is not a mandatory, then we can make it option similar to
what Jingoo has also suggested
in subsequent mail.

[snip]


-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
