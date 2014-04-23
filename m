Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757332AbaDWHhc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Apr 2014 03:37:32 -0400
Received: from mail-qa0-f50.google.com ([209.85.216.50]:44818 "EHLO
	mail-qa0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751546AbaDWHh3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Apr 2014 03:37:29 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1404221350300.1326-100000@iolanthe.rowland.org>
References: <1397136261-16408-1-git-send-email-gautam.vivek@samsung.com>
	<Pine.LNX.4.44L0.1404221350300.1326-100000@iolanthe.rowland.org>
Date: Wed, 23 Apr 2014 13:07:28 +0530
X-Google-Sender-Auth: IQvLw7ClW4FTMYymCnV9QmUkaz8
Message-ID: <CAFp+6iGfsv7tLvaqCp6=BNSX3dtwuSLRGfOMDoFD4zSQHd9m3g@mail.gmail.com>
Subject: Re: [PATCH] usb: ohci-exynos: Add facility to use phy provided by the
 generic phy framework
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        linux-doc@vger.kernel.org,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        Kukjin Kim <kgene.kim@samsung.com>, "robh+dt" <robh+dt@kernel.org>,
        Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Alan,


On Tue, Apr 22, 2014 at 11:28 PM, Alan Stern <stern@rowland.harvard.edu> wrote:

Thanks for reviewing this. Please find my comments inline below.

> On Thu, 10 Apr 2014, Vivek Gautam wrote:
>
>> Add support to consume phy provided by Generic phy framework.
>> Keeping the support for older usb-phy intact right now, in order
>> to prevent any functionality break in absence of relevant
>> device tree side change for ohci-exynos.
>> Once we move to new phy in the device nodes for ohci, we can
>> remove the support for older phys.
>>
>> Signed-off-by: Vivek Gautam <gautam.vivek@samsung.com>
>> Cc: Jingoo Han <jg1.han@samsung.com>
>> Cc: Alan Stern <stern@rowland.harvard.edu>
>
>> +static int exynos_ohci_phyg_on(struct phy *phy, bool on)
>> +{
>> +     int ret = 0;
>> +
>> +     if (phy) {
>> +             if (on)
>> +                     ret = phy_power_on(phy);
>> +             else
>> +                     ret = phy_power_off(phy);
>> +     }
>> +
>> +     return ret;
>> +}
>
> This would be cleaner if you had separate routines for
> exynos_ohci_phyg_of and exynos_ohci_phyg_off.  For example:
>
> static int exynos_ohci_phyg_on(struct phy *phy)
> {
>         return phy ? phy_power_on(phy) : 0;
> }

Sure, i will make two separate routines here.

>
>> @@ -88,16 +104,49 @@ static int exynos_ohci_probe(struct platform_device *pdev)
>>                                       "samsung,exynos5440-ohci"))
>>               goto skip_phy;
>>
>> -     phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
>> -     if (IS_ERR(phy)) {
>> -             usb_put_hcd(hcd);
>> -             dev_warn(&pdev->dev, "no platform data or transceiver defined\n");
>> -             return -EPROBE_DEFER;
>> +     exynos_ohci->phy = devm_usb_get_phy(&pdev->dev, USB_PHY_TYPE_USB2);
>> +     if (IS_ERR(exynos_ohci->phy)) {
>> +             err = PTR_ERR(exynos_ohci->phy);
>> +             if (err == -ENXIO || err == -ENODEV) {
>> +                     exynos_ohci->phy = NULL;
>> +             } else if (err == -EPROBE_DEFER) {
>> +                     usb_put_hcd(hcd);
>> +                     return err;
>> +             } else {
>> +                     dev_err(&pdev->dev, "no usb2 phy configured\n");
>> +                     usb_put_hcd(hcd);
>> +                     return err;
>> +             }
>
> Instead of all the calls to usb_put_hcd() here and below, just goto
> fail_clk.  Or add a new fail_phy label at the same spot and goto it.

Sure, i can use a new label here.

>
> Otherwise this looks basically okay.

Sure, i will send the next version of this patch after rework.
