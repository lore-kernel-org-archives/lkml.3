Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756867Ab3EaU5A (ORCPT <rfc822;w@1wt.eu>);
	Fri, 31 May 2013 16:57:00 -0400
Received: from mail-ie0-f179.google.com ([209.85.223.179]:62499 "EHLO
	mail-ie0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754909Ab3EaU4l (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 31 May 2013 16:56:41 -0400
MIME-Version: 1.0
In-Reply-To: <CAHp75Ve1rSf6McAJXFohDJF9yWzhpSx3fbKp0ewxC9tpJOMhBw@mail.gmail.com>
References: <1369268964-28304-1-git-send-email-rvaswani@codeaurora.org>
 <1369268964-28304-4-git-send-email-rvaswani@codeaurora.org> <CAHp75Ve1rSf6McAJXFohDJF9yWzhpSx3fbKp0ewxC9tpJOMhBw@mail.gmail.com>
From: Grant Likely <grant.likely@linaro.org>
Date: Fri, 31 May 2013 21:56:20 +0100
X-Google-Sender-Auth: DQf90zpt_oBP0vjsUicVEGBDbOw
Message-ID: <CACxGe6vSBWSUp+p=UMsLpWcmr-b559p6xa3kPiKpvs+D4Kubiw@mail.gmail.com>
Subject: Re: [PATCHv2 3/3] gpio: msm: Add device tree and irqdomain support
 for gpio-msm-v2
To: Andy Shevchenko <andy.shevchenko@gmail.com>
Cc: Rohit Vaswani <rvaswani@codeaurora.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Rob Herring <rob.herring@calxeda.com>, Rob Landley <rob@landley.net>,
        Russell King <linux@arm.linux.org.uk>,
        David Brown <davidb@codeaurora.org>,
        Bryan Huntsman <bryanh@codeaurora.org>,
        Linux Documentation List <linux-doc@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-msm@vger.kernel.org" <linux-arm-msm@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 31, 2013 at 9:01 PM, Andy Shevchenko
<andy.shevchenko@gmail.com> wrote:
> On Thu, May 23, 2013 at 3:29 AM, Rohit Vaswani <rvaswani@codeaurora.org> wrote:
>> This cleans up the gpio-msm-v2 driver of all the global define usage.
>> The number of gpios are now defined in the device tree. This enables
>> adding irqdomain support as well.
>
> Besides the other comments, I have one important here.
>
>> -static int __init msm_gpio_init(void)
>> -{
>> -       int rc;
>> -
>> -       rc = platform_driver_register(&msm_gpio_driver);
>> -       if (!rc) {
>> -               rc = platform_device_register(&msm_device_gpio);
>> -               if (rc)
>> -                       platform_driver_unregister(&msm_gpio_driver);
>> -       }
>> -
>> -       return rc;
>> -}
>> -
>> -static void __exit msm_gpio_exit(void)
>> -{
>> -       platform_device_unregister(&msm_device_gpio);
>> -       platform_driver_unregister(&msm_gpio_driver);
>> -}
>> -
>> -postcore_initcall(msm_gpio_init);
>> -module_exit(msm_gpio_exit);
>> +module_platform_driver(msm_gpio_driver)
>
> It's a really big mistake to do this.
> GPIO nowadays is used in many hardware subsystems to support early
> stages of booting and initializing.
>
> postcore_initcall is early enough to support mostly anything that
> hardware wants from GPIO (for example, ACPI events, though it seems
> not a case here).

Actually, we're going the other way in the kernel. I do agree that for
existing drivers you need to be careful and make sure that switching
the initcall level won't cause any breakage with existing systems, but
new platform support must not rely on the initcall order for setting
up gpios. That's what deferred probe is intended to solve.

g.
