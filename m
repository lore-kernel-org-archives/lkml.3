Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752622Ab3LSLiW (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 06:38:22 -0500
Received: from 12.mo4.mail-out.ovh.net ([178.33.104.253]:40483 "EHLO
	mo4.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1751465Ab3LSLiU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:38:20 -0500
X-Greylist: delayed 151099 seconds by postgrey-1.27 at vger.kernel.org; Thu, 19 Dec 2013 06:38:20 EST
MIME-Version: 1.0
In-Reply-To: <CAAVeFuKAGfnnsbtBg=zfmciyMdZHgrX_EpecqPjG=oO6rZdWag@mail.gmail.com>
References: <1387239745-2890-1-git-send-email-jjhiblot@traphandler.com>
	<CAAVeFuKAGfnnsbtBg=zfmciyMdZHgrX_EpecqPjG=oO6rZdWag@mail.gmail.com>
Date: Thu, 19 Dec 2013 12:38:13 +0100
Message-ID: <CACh+v5MUsYW-=qaVubzt8CWRGxibKDB3PjMZ6AaeDYgeTNzONA@mail.gmail.com>
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
X-Ovh-Tracer-Id: 15802568144155793432
X-Ovh-Remote: 209.85.192.176 (mail-pd0-f176.google.com)
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeejtddrtddvucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

2013/12/19 Alexandre Courbot <gnurou@gmail.com>:
> On Tue, Dec 17, 2013 at 9:22 AM, Jean-Jacques Hiblot
> <jjhiblot@traphandler.com> wrote:
>>
>> This patch implements a new tracing mechanism based on kprobes and using GPIO.
>> Debugging with GPIO is very common in the embedded world. At least for those of us
>> fortunate enough to have an oscilloscope or a logic analyzer on their bench...
>> This is especially true if the issue results of a hardware/sofware interaction.
>>
>> Typical use cases are :
>> * mixed software/hardware debugging. For example when the software detects a
>>   situation of interest (typically an error) it toggles a GPIO to trigger the
>>   oscilloscope acquisition.
>> * direct latency/duration measurements.
>>
>> examples:
>> To trig the oscilloscope whenever a mmc command error:
>>   echo "p:my_mmc_blk_error mmc_blk_cmd_error gpiopulse@13" > /sys/kernel/debug/tracing/kprobe_events
>>   echo 1 > /sys/kernel/debug/tracing/events/kprobes/my_mmc_blk_error/enable
>
> I do like this idea, however I wonder if you could try and make it use
> the new gpio descriptor API (see Documentation/gpio/) instead of the
> GPIO integers we are trying to deprecate (well ok, we just *started*
> claiming they are deprecated).
>
I'll make the gpio event trigger work with the old API first. Then
I'll adapt it to use the gpio descriptor interface.

> This would probably make things a little bit more complicated on your
> side, due to the fact the gpiod API is new and probably does not cover
> all your needs. But it would also make your approach safer and more
> future proof, on top of helping us refine gpiod for various use cases.
>
> The problems I can see so far:
>
> - Using gpiod, GPIOs are not specified as integers, but are typically
> mapped to a given (device, function) pair (device can be NULL) using
> device tree/platform data/ACPI and obtained by the corresponding
> device driver through gpiod_get(). You would need to find a different
> way to specify GPIOs, maybe using the gpio_chip's label and the GPIO
> hardware number.
>
> - Even if you do so, there is currently no way to arbitrarily obtain a
> GPIO that has not been explicitly mapped to a (device, function), and
> IIUC you need to specify the tracing GPIO freely from user-space. This
> hints that we will need to add a function that is sensibly the same as
> gpio_request_one() to the gpiod API, but I wonder if that does not
> defeats the purpose somehow.

This is something I was wondering about for another reason. In many
cases the GPIOs that are physically available for probing will be
limited to the GPIOs already assigned a function (backlight control
for example), others are usually not routed except in eval boards or
early prototypes. And consequently those GPIOs will be requested by a
driver long before a probe is set.
It would be nice not to have to remove the driver to be able to use
this GPIO  as a probe. Maybe a gpiod_steal() interface and a flag
indicating that the GPIO can be safely stolen?

>
> So using gpiod we would have the dual problem of how to represent the
> GPIO you need from user-space, and how you can safely obtain it. It
> would be interesting to hear what Linus thinks about it, and if he has
> better ideas about how we could solve these issues (as he usually has
> ;) ).
>
> (note that it is *not* a hard requirement to use gpiod over the legacy
> integer API, but considering this is the direction we are taking, it
> would be nice to consider it and see how we could solve the issues
> mentioned above)
>
> Thanks,
> Alex.
