Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753226AbaGHXnx (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 19:43:53 -0400
Received: from mail-oa0-f47.google.com ([209.85.219.47]:60943 "EHLO
	mail-oa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752169AbaGHXnv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 19:43:51 -0400
MIME-Version: 1.0
In-Reply-To: <53BC7CBD.2060901@codeaurora.org>
References: <1404782785-1824-1-git-send-email-bjorn.andersson@sonymobile.com>
	<1404782785-1824-2-git-send-email-bjorn.andersson@sonymobile.com>
	<53BC7CBD.2060901@codeaurora.org>
Date: Tue, 8 Jul 2014 16:43:50 -0700
Message-ID: <CAJAp7Ogy3=tZvMAUojbf5sy8EMmQOT+imA3=TRVcGXXA_y7CtA@mail.gmail.com>
Subject: Re: [PATCH 1/3] mfd: pm8921: Expose pm8xxx_read_irq_status
From: Bjorn Andersson <bjorn@kryo.se>
To: Stephen Boyd <sboyd@codeaurora.org>
Cc: Bjorn Andersson <bjorn.andersson@sonymobile.com>,
        Lee Jones <lee.jones@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        linux-arm-msm <linux-arm-msm@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        Linus Walleij <linus.walleij@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 8, 2014 at 4:20 PM, Stephen Boyd <sboyd@codeaurora.org> wrote:
> On 07/07/14 18:26, Bjorn Andersson wrote:
>> @@ -65,6 +66,41 @@ struct pm_irq_chip {
>>       u8                      config[0];
>>  };
>>
>> +int pm8xxx_read_irq_status(int irq)
>> +{
>> +     struct irq_data *d = irq_get_irq_data(irq);
>> +     struct pm_irq_chip *chip = irq_data_get_irq_chip_data(d);
>> +     unsigned int pmirq = irqd_to_hwirq(d);
>> +     unsigned int bits;
>> +     int irq_bit;
>> +     u8 block;
>> +     int rc;
>> +
>> +     if (!chip) {
>> +             pr_err("Failed to resolve pm_irq_chip\n");
>> +             return -EINVAL;
>> +     }
>
> Is this actually necessary? Presumably the driver wouldn't have even
> probed unless there was a pmic to begin with.
>

I had a bug in the calling driver, passing the wrong irq down to this
function. But now that I think more about it I should probably check
for "d" being non-NULL. On the other hand, that will still just catch
a minor set of bugs as both of those will in most cases produce
"valid" pointers.

Maybe it's okay to just trust the caller to pass a valid irq? Or do
you have any other suggestion of sanity checking the input value?
Preferably without also passing the pm_irq_chip pointer.

[...]
> Sad, the header file came back. I guess there isn't a way to put the
> pinctrl driver inside the core mfd driver? Then we wouldn't need to
> expose an "irq read line" function.
>

I continued my search and this needs to be accessed by gpio, mpp, adc,
charger, bms and usb(?). So we have to expose it in some form.

> Actually Abhijeet proposed such an API in 2011 but it didn't go
> anywhere[1]. If we had that API we should be able to call
> read_irq_line() from the pinctrl driver whenever we want to get the
> state of the gpio, plus the API is generic. We're going to need that API
> anyway for things like USB insertion detection so it might make sense to
> add it sooner rather than later.
>
> [1]
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-April/048319.html

>From what I can see of this thread it was exposed as a way for drivers
to be able to query if an interrupt handler was called on raising or
falling edge. And based on the locking limitations of the
implementation we couldn't have used it anyways.

Our use case is different in that we're at any point in time
interested in reading out the status of the irq line, as the only way
of getting that status.

It might be a long shot, but let's spin a patch for our purpose and
run it by Tomas again.

Regards,
Bjorn
