Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751396AbaDOKAr (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Apr 2014 06:00:47 -0400
Received: from mail-qa0-f43.google.com ([209.85.216.43]:65210 "EHLO
	mail-qa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750838AbaDOKAk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Apr 2014 06:00:40 -0400
MIME-Version: 1.0
In-Reply-To: <CAOLUe6aPWmkJJSiBLL8tmw2MNfpaeLpSp3CSwP1u7q+qXxCh9Q@mail.gmail.com>
References: <1393842463-5206-1-git-send-email-thloh@altera.com>
	<20140307151455.GI18529@joshc.qualcomm.com>
	<CAOLUe6aspffO1PUjKWW7ejpbxnYtb+RKRQrK=y30kuF7KXUUhA@mail.gmail.com>
	<CAOLUe6aPWmkJJSiBLL8tmw2MNfpaeLpSp3CSwP1u7q+qXxCh9Q@mail.gmail.com>
Date: Tue, 15 Apr 2014 18:00:39 +0800
X-Google-Sender-Auth: GKQAEcXImgbflHiCZr8V--v6iFw
Message-ID: <CAOLUe6bFyizanij68a1866QKGSHE=1_+V2yeqxjfamjxjFUUfQ@mail.gmail.com>
Subject: Re: [PATCH V7 1/1] drivers/gpio: Altera soft IP GPIO driver and
 devicetree binding
From: Tien Hock Loh <thloh@altera.com>
To: Tien Hock Loh <thloh@altera.com>
Cc: Josh Cartwright <joshc@codeaurora.org>, robh+dt@kernel.org,
        pawel.moll@arm.com, Mark Rutland <mark.rutland@arm.com>,
        ijc+devicetree@hellion.org.uk, Kumar Gala <galak@codeaurora.org>,
        Rob Landley <rob@landley.net>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Grant Likely <grant.likely@linaro.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        linux-kernel@vger.kernel.org, linux-gpio@vger.kernel.org,
        dinguyen@altera.com, "lftan@altera.com" <lftan@altera.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

>>>>> Add driver support for Altera GPIO soft IP, including interrupts and I/O.
>>>>> Tested on Altera CV SoC board using dipsw and LED using LED framework.
>>>>>
>>>>> Signed-off-by: Tien Hock Loh <thloh@altera.com>
>>>>> ---
>>>>
>>>>> +             return -ENOMEM;
>>>>> +     }
>>>>> +     altera_gc->domain = 0;
>>>>> +
>>>>> +     spin_lock_init(&altera_gc->gpio_lock);
>>>>> +
>>>>> +     id = pdev->id;
>>>>> +
>>>>> +     if (of_property_read_u32(node, "altr,gpio-bank-width", &reg))
>>>>> +             /*By default assume full GPIO controller*/
>>>>> +             altera_gc->mmchip.gc.ngpio = 32;
>>>>> +     else
>>>>> +             altera_gc->mmchip.gc.ngpio = reg;
>>>>> +
>>>>> +     if (altera_gc->mmchip.gc.ngpio > 32) {
>>>>> +             dev_warn(&pdev->dev,
>>>>> +                     "ngpio is greater than 32, defaulting to 32\n");
>>>>> +             altera_gc->mmchip.gc.ngpio = 32;
>>>>> +     }
>>>>> +
>>>>> +     altera_gc->mmchip.gc.direction_input    = altera_gpio_direction_input;
>>>>> +     altera_gc->mmchip.gc.direction_output   = altera_gpio_direction_output;
>>>>> +     altera_gc->mmchip.gc.get                = altera_gpio_get;
>>>>> +     altera_gc->mmchip.gc.set                = altera_gpio_set;
>>>>> +     altera_gc->mmchip.gc.to_irq             = altera_gpio_to_irq;
>>>>> +     altera_gc->mmchip.gc.owner              = THIS_MODULE;
>>>>> +
>>>>> +     ret = of_mm_gpiochip_add(node, &altera_gc->mmchip);
>>>>> +     if (ret) {
>>>>> +             dev_err(&pdev->dev, "Failed adding memory mapped gpiochip\n");
>>>>> +             return ret;
>>>>> +     }
>>>>> +
>>>>> +     platform_set_drvdata(pdev, altera_gc);
>>>>> +
>>>>> +     altera_gc->mapped_irq = irq_of_parse_and_map(node, 0);
>>>>>
>>>>
>>>> platform_get_irq(pdev, 0);
>>>>
>>> OK.
>>>
>>
>> platform_get_irq doesn't create the irq mapping which is needed by the
>> driver. Since this driver is targeted at using of, should I be using
>> irq_of_parse_and_map or should I still redo the codes with
>> platform_get_irq and irq_create_mapping? I think the latter would be
>> introducing code redundancy. Please advice.
>
> Yes, it is technically true that platform_get_irq() doesn't do the mapping directly, but that's
> because the mapping is setup earlier, when
> of_device_alloc() (drivers/of/platform.c) allocates resources for your platform device.
>
> Calling irq_of_parse_and_map() should be unnecessary.

I checked and tried running the without irq_create_mapping but it
seems the mapping is not done.
What I've seen other GPIO driver is doing is to create the mapping
during the gpio_to_irq call. However Linus suggested we are avoiding
that route, thus the use of irq_of_parse_and_map. Do you agree with my
findings?

>>
>> Thanks.
