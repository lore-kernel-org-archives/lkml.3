Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753254AbaFMLd4 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 07:33:56 -0400
Received: from mail-qc0-f173.google.com ([209.85.216.173]:39846 "EHLO
	mail-qc0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751113AbaFMLdy (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 07:33:54 -0400
MIME-Version: 1.0
In-Reply-To: <Pine.LNX.4.44L0.1406111131200.890-100000@iolanthe.rowland.org>
References: <1402064411-18244-1-git-send-email-gautam.vivek@samsung.com>
	<Pine.LNX.4.44L0.1406111131200.890-100000@iolanthe.rowland.org>
Date: Fri, 13 Jun 2014 17:03:53 +0530
X-Google-Sender-Auth: JYoJmOTzc8nan6Afk4DGf7L7FhQ
Message-ID: <CAFp+6iF9GkKWDcqZNV58Z=U3ZDQdgYr8LJBF9t-BpJW90vsHdQ@mail.gmail.com>
Subject: Re: [PATCH v2 1/2] usb: ehci-exynos: Make provision for vdd regulators
From: Vivek Gautam <gautam.vivek@samsung.com>
To: Alan Stern <stern@rowland.harvard.edu>
Cc: Linux USB Mailing List <linux-usb@vger.kernel.org>,
        "linux-samsung-soc@vger.kernel.org" 
	<linux-samsung-soc@vger.kernel.org>,
        Greg KH <gregkh@linuxfoundation.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Kukjin Kim <kgene.kim@samsung.com>, Jingoo Han <jg1.han@samsung.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,


On Wed, Jun 11, 2014 at 9:09 PM, Alan Stern <stern@rowland.harvard.edu> wrote:
> On Fri, 6 Jun 2014, Vivek Gautam wrote:
>
>> Facilitate getting required 3.3V and 1.0V VDD supply for
>> EHCI controller on Exynos.
>>
>> With patches for regulators' nodes merged in 3.15:
>> c8c253f ARM: dts: Add regulator entries to smdk5420
>> 275dcd2 ARM: dts: add max77686 pmic node for smdk5250,
>>
>> certain perripherals will now need to ensure that,
>> they request VDD regulators in their drivers, and enable
>> them so as to make them working.
>
> "Certain peripherals"?  Don't you mean "certain controllers"?

Right, 'certain controllers'.

>
> Does this mean some controllers don't need to use the VDD regulators?

Actually until the two patches got merged, the USB controllers were
depending on bootloader
for the VDD supply, wherein it was enabled, which ofcourse was bad.
And by 'certain' i meant that above mentioned dt patches enable only the minimum
number of regulators for the system, however leaves other for the
drivers to enable.
Anyways, i will re-do this commit message.

>
>> @@ -193,7 +196,31 @@ static int exynos_ehci_probe(struct platform_device *pdev)
>>
>>       err = exynos_ehci_get_phy(&pdev->dev, exynos_ehci);
>>       if (err)
>> -             goto fail_clk;
>> +             goto fail_regulator1;
>> +
>> +     exynos_ehci->vdd33 = devm_regulator_get(&pdev->dev, "vdd33");
>> +     if (!IS_ERR(exynos_ehci->vdd33)) {
>> +             err = regulator_enable(exynos_ehci->vdd33);
>> +             if (err) {
>> +                     dev_err(&pdev->dev,
>> +                             "Failed to enable 3.3V Vdd supply\n");
>> +                     goto fail_regulator1;
>> +             }
>> +     } else {
>> +             dev_warn(&pdev->dev, "Regulator 3.3V Vdd supply not found\n");
>> +     }
>
> What if this is one of the controllers that don't need to use a VDD
> regulator?  Do you really want to print out a warning in that case?
> Should you call devm_regulator_get_optional() instead?

Right, better to use devm_regulator_get_optional(). Thanks for
pointing this out.




-- 
Best Regards
Vivek Gautam
Samsung R&D Institute, Bangalore
India
