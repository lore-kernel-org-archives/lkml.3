Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751478AbaDUOaI (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 10:30:08 -0400
Received: from mail-la0-f53.google.com ([209.85.215.53]:53030 "EHLO
	mail-la0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751073AbaDUOaE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 10:30:04 -0400
MIME-Version: 1.0
In-Reply-To: <53551D0F.40906@linux.intel.com>
References: <1397649959-29762-1-git-send-email-yao.jin@linux.intel.com>
	<CAN+gG=E7jbpQxxVuhmY5E2msgdMhLLjMd=Kxn9JO57eCN+5nCQ@mail.gmail.com>
	<5353A1F6.60602@linux.intel.com>
	<5353B8A4.1080900@linux.intel.com>
	<1398007690.2674.0.camel@adam.happyassassin.net>
	<5354BA59.2000008@linux.intel.com>
	<53551D0F.40906@linux.intel.com>
Date: Mon, 21 Apr 2014 10:30:01 -0400
Message-ID: <CAN+gG=H2X9cUWMixCQakiWz45AOpDAJyEULB0Z9d2jyxy9hUNA@mail.gmail.com>
Subject: Re: [PATCH] pinctrl-baytrail: fix for irq descriptor conflict on ASUS T100TA
From: Benjamin Tissoires <benjamin.tissoires@gmail.com>
To: "Jin, Yao" <yao.jin@linux.intel.com>
Cc: Adam Williamson <awilliam@redhat.com>,
        Linus Walleij <linus.walleij@linaro.org>, alan@linux.intel.com,
        mathias.nyman@intel.com,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Mika Westerberg <mika.westerberg@linux.intel.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 21, 2014 at 9:28 AM, Jin, Yao <yao.jin@linux.intel.com> wrote:
>
>
> On 2014/4/21 14:27, Jin, Yao wrote:
>>
>>
>> On 2014/4/20 23:28, Adam Williamson wrote:
>>> On Sun, 2014-04-20 at 20:08 +0800, Jin, Yao wrote:
>>>> For the issue that touch screen doesn't work, could you check power
>>>> state of LPSS devices? For example:
>>>>
>>>> cd /sys/bus/acpi/devices
>>>> grep -H . */power_state
>>>>
>>>> If they are D3cold, it should be the reason why touch screen doesn't
>>>> work. That's another issue, unrelated to this gpio patch.
>>>
>>> The touch screen worked fine with kernel 3.14, and Benjamin looked at
>>> debug output from the attempt to load the touchscreen driver when
>>> diagnosing the problem, he's not just guessing. I am building a kernel
>>> without your patch to confirm that fixes it.
>>>
>>
>> I tried the clean kernel 3.14 with the boot option "nomodeset text" on
>> Dell Venue 11 Pro (If without "nomodeset",my ubuntu is being "black
>> screen", but that should be another i915 issue).
>>
>> After system starup, I executed the "startx" to launch the xwindow. In
>> xwindow, the touchscreen work.
>>
>> I tried the kernel 3.14 again with my gpio patch applied, the result was
>> the same, the touchscreen work.
>>
>> I also check the DSDT table of Dell Venue 11 Pro by searching the
>> keyword "Interrupt", I can't find any clue for the irq conflict.
>>
>> I'm sorry I don't have a Dell Venue 8 for testing, but I guess it's
>> similar to Dell Venue 11 Pro.

Sorry, my bad. Actually, this patch does not break the touchscreen,
but the other Adam applied does:
https://github.com/AdamWill/baytrail-m/blob/master/kernel/baytrail_gpio_quirk.patch

This one was to enable wifi, but it actually breaks the touchscreen.
I'll try to figure out which part of the patch breaks the touchscreen.

The good point is that I have a reproducer now on the Lenovo Miix 2,
so I'll be able to spot the pb easily.

Sorry for having been rude, and thanks for the tests.

Cheers,
Benjamin

>> --
>> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
>> the body of a message to majordomo@vger.kernel.org
>> More majordomo info at  http://vger.kernel.org/majordomo-info.html
>> Please read the FAQ at  http://www.tux.org/lkml/
>>
>
> Could you also add following change to disable the runtime PM of HSUART?
> After that then check if your touchscreen work? It's to solve a known
> issue.The change is based on 3.14.
>
> --- a/drivers/tty/serial/8250/8250_dw.c
> +++ b/drivers/tty/serial/8250/8250_dw.c
> @@ -368,8 +368,6 @@ static int dw8250_probe(struct platform_device *pdev)
>
>         platform_set_drvdata(pdev, data);
>
> -       pm_runtime_set_active(&pdev->dev);
> -       pm_runtime_enable(&pdev->dev);
>
>         return 0;
>  }
