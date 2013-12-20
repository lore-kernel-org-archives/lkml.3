Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754805Ab3LTPO7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 10:14:59 -0500
Received: from 15.mo4.mail-out.ovh.net ([91.121.62.11]:43604 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1753070Ab3LTPO6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 10:14:58 -0500
X-Greylist: delayed 16799 seconds by postgrey-1.27 at vger.kernel.org; Fri, 20 Dec 2013 10:14:57 EST
MIME-Version: 1.0
In-Reply-To: <CAAVeFuJ=s8e8g5LG2CVAkS3guj-HRUYrwKxywFxq36sNpAjQGQ@mail.gmail.com>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	<CAAVeFuKAGfnnsbtBg=zfmciyMdZHgrX_EpecqPjG=oO6rZdWag@mail.gmail.com>
	<CACh+v5MUsYW-=qaVubzt8CWRGxibKDB3PjMZ6AaeDYgeTNzONA@mail.gmail.com>
	<CAAVeFuJ=s8e8g5LG2CVAkS3guj-HRUYrwKxywFxq36sNpAjQGQ@mail.gmail.com>
Date: Fri, 20 Dec 2013 09:40:04 +0100
Message-ID: <CACh+v5NhUzoRc4YuPJdSia21XTDh8tLo=oBZyo7Re7deOTjUdA@mail.gmail.com>
Subject: Re: [PATCH] Tracing events with GPIOs
From: Jean-Jacques Hiblot <jjhiblot@traphandler.com>
To: Alexandre Courbot <gnurou@gmail.com>
Cc: Jean-Jacques Hiblot <jjhiblot@traphandler.com>,
        Linus Walleij <linus.walleij@linaro.org>,
        Steven Rostedt <rostedt@goodmis.org>,
        Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=ISO-8859-1
X-Ovh-Tracer-Id: 173107112583059480
X-Ovh-Remote: 209.85.192.171 (mail-pd0-f171.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtdegucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/20 Alexandre Courbot <gnurou@gmail.com>:
> On Thu, Dec 19, 2013 at 8:38 PM, Jean-Jacques Hiblot
> <jjhiblot@traphandler.com> wrote:
>> 2013/12/19 Alexandre Courbot <gnurou@gmail.com>:
>>> The problems I can see so far:
>>>
>>> - Using gpiod, GPIOs are not specified as integers, but are typically
>>> mapped to a given (device, function) pair (device can be NULL) using
>>> device tree/platform data/ACPI and obtained by the corresponding
>>> device driver through gpiod_get(). You would need to find a different
>>> way to specify GPIOs, maybe using the gpio_chip's label and the GPIO
>>> hardware number.
>>>
>>> - Even if you do so, there is currently no way to arbitrarily obtain a
>>> GPIO that has not been explicitly mapped to a (device, function), and
>>> IIUC you need to specify the tracing GPIO freely from user-space. This
>>> hints that we will need to add a function that is sensibly the same as
>>> gpio_request_one() to the gpiod API, but I wonder if that does not
>>> defeats the purpose somehow.
>>
>> This is something I was wondering about for another reason. In many
>> cases the GPIOs that are physically available for probing will be
>> limited to the GPIOs already assigned a function (backlight control
>> for example), others are usually not routed except in eval boards or
>> early prototypes. And consequently those GPIOs will be requested by a
>> driver long before a probe is set.
>> It would be nice not to have to remove the driver to be able to use
>> this GPIO  as a probe. Maybe a gpiod_steal() interface and a flag
>> indicating that the GPIO can be safely stolen?
>
> Mmm an explicit way to hijack a GPIO does not sound very safe. Do you
> have concrete cases where you need to do so? I guess most boards you
> may want to use this patch with would have at least some spare GPIOs
> with pins somewhere on the board for this kind of purpose.
It's not always true. There are quite a few platforms where GPIOs is a
scarce resource (ppc for example). For example, the board I'm working
on at the moment is built around a APM powerpc which has only 16
GPIOs. Of those 16 GPIOS, some are not routed and most of the others
are hidden by the shielding so that I can probe only those that go to
external connectors.
IMHO it's probably the case for most of the boards that go into a
final product where EMI and space constraints are tight.
But I agree that's not safe. I thought that maybe a flag indicating
when it is safe would help (on my board that would be : ok to use the
GPIO that turns on or off the backlight, not ok to use the GPIO that
controls the power supply)
