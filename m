Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751655AbbASEJh (ORCPT <rfc822;w@1wt.eu>);
	Sun, 18 Jan 2015 23:09:37 -0500
Received: from mail-ig0-f176.google.com ([209.85.213.176]:38133 "EHLO
	mail-ig0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751185AbbASEJf (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 18 Jan 2015 23:09:35 -0500
MIME-Version: 1.0
In-Reply-To: <CAAVeFuLGKUb2A1U9YiDmoS23sHC9ihr3h8DcSRbmNEXuu03mqw@mail.gmail.com>
References: <1420621722-7428-1-git-send-email-oliver+list@schinagl.nl>
 <1420621722-7428-5-git-send-email-oliver+list@schinagl.nl>
 <20150107235522.GA6670@dtor-ws> <54AE43A9.3020309@schinagl.nl>
 <CAL_JsqJE_PCXrejHO3vfdbbtC4FGyuPhJ8W-A=8nZMcu6aBxCw@mail.gmail.com>
 <20150108221249.GH23256@dtor-ws> <CACRpkdZZxAPecNfADzYLSz8S6tNBi9Jr4st==zxnNp2r2gPC2g@mail.gmail.com>
 <54B66D07.8040807@schinagl.nl> <CAAVeFuLGKUb2A1U9YiDmoS23sHC9ihr3h8DcSRbmNEXuu03mqw@mail.gmail.com>
From: Alexandre Courbot <gnurou@gmail.com>
Date: Mon, 19 Jan 2015 13:09:14 +0900
Message-ID: <CAAVeFuLjOkfDNn_djKcOQHE8cVbUML8nbM+9PdrBTVZ5bfe4Mg@mail.gmail.com>
Subject: Re: [PATCH v1 4/4] leds: no longer use unnamed gpios
To: Olliver Schinagl <oliver@schinagl.nl>
Cc: Linus Walleij <linus.walleij@linaro.org>,
        Dmitry Torokhov <dmitry.torokhov@gmail.com>,
        Rob Herring <robherring2@gmail.com>,
        Olliver Schinagl <oliver+list@schinagl.nl>,
        Rob Herring <robh+dt@kernel.org>, Pawel Moll <pawel.moll@arm.com>,
        Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>, Bryan Wu <cooloney@gmail.com>,
        Richard Purdie <rpurdie@rpsys.net>, Robin Gong <b38343@freescale.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Aaron Lu <aaron.lu@intel.com>,
        Mika Westerberg <mika.westerberg@linux.intel.com>,
        Grant Likely <grant.likely@linaro.org>,
        Wolfram Sang <wsa@the-dreams.de>, Alexander Shiyan <shc_work@mail.ru>,
        Jingoo Han <jg1.han@samsung.com>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        "linux-input@vger.kernel.org" <linux-input@vger.kernel.org>,
        "linux-leds@vger.kernel.org" <linux-leds@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 19, 2015 at 12:43 PM, Alexandre Courbot <gnurou@gmail.com> wrote:
> On Wed, Jan 14, 2015 at 10:20 PM, Olliver Schinagl <oliver@schinagl.nl> wrote:
>>
>> On 14-01-15 13:45, Linus Walleij wrote:
>>>
>>> On Thu, Jan 8, 2015 at 11:12 PM, Dmitry Torokhov
>>> <dmitry.torokhov@gmail.com> wrote:
>>>>
>>>> On Thu, Jan 08, 2015 at 08:40:20AM -0600, Rob Herring wrote:
>>>>>
>>>>> On Thu, Jan 8, 2015 at 2:45 AM, Olliver Schinagl <oliver@schinagl.nl>
>>>>> wrote:
>>>>>>>>
>>>>>>>> --- a/drivers/leds/leds-gpio.c
>>>>>>>> +++ b/drivers/leds/leds-gpio.c
>>>>>>>> @@ -184,7 +184,7 @@ static struct gpio_leds_priv
>>>>>>>> *gpio_leds_create(struct
>>>>>>>> platform_device *pdev)
>>>>>>>>                  struct gpio_led led = {};
>>>>>>>>                  const char *state = NULL;
>>>>>>>>    -             led.gpiod = devm_get_gpiod_from_child(dev, NULL,
>>>>>>>> child);
>>>>>>>> +               led.gpiod = devm_get_gpiod_from_child(dev, "led",
>>>>>>>> child);
>>>>>>>
>>>>>>> Would not this break existing boards using old bindings? You need to
>>>>>>> handle both cases: if you can't located "led-gpios" then you will have
>>>>>>> to
>>>>>>> try just "gpios".
>>>>>>
>>>>>> Very true. I was rather even hoping we could update all bindings, I
>>>>>> don't
>>>>>> mind going through the available dts files to fix them ... But need to
>>>>>> know
>>>>>> that that's the proper way to go before doing the work ;)
>>>>>
>>>>> That will not work. You cannot make changes that require a new dtb
>>>>> with a new kernel. This would also break for the other way around
>>>>> (i.e. a new dtb and old kernel).
>>>>>
>>>>> You would have to search for both led-gpios and gpios. I'm not sure if
>>>>> we can do that generically for all GPIOs. If you had a node with both
>>>>> "blah-gpios" and "gpios", it would break. I would hope there are no
>>>>> such cases like that. We also now have to consider how ACPI identifies
>>>>> GPIOs and whether this makes sense.
>>>>
>>>> I think only the driver itself can know about such "legacy" mappings and
>>>> make a decision.
>>>
>>> Yeah leds-gpio.c will need to be patched to check for "led-gpios" first
>>> and then fall back to "gpios" if not found.
>>
>> yeah I've done the work, just need to double check it and resend a v2.
>>
>> Linus, I assume you want the already applied patches omitted from v2?
>
> Yes, please base new revisions on Linus' devel branch, omitting any
> patches that he has already accepted.

Actually on top of breaking backward compatibility, I think the case
of LED GPIOs is one of thoses where it makes sense to not have a name
(the GPIO usage is obvious from the DT hierarchy, and there cannot be
another one). So I don't feel like this change is really needed (other
patches in this series are still useful though).
