Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752704AbbALRcF (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 12:32:05 -0500
Received: from mail-la0-f44.google.com ([209.85.215.44]:54045 "EHLO
	mail-la0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751281AbbALRcC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 12:32:02 -0500
MIME-Version: 1.0
In-Reply-To: <54B3F849.30001@oracle.com>
References: <1421078671-5920-1-git-send-email-geert+renesas@glider.be>
	<1421078671-5920-2-git-send-email-geert+renesas@glider.be>
	<54B3F849.30001@oracle.com>
Date: Mon, 12 Jan 2015 18:32:00 +0100
X-Google-Sender-Auth: iXjDWXt8Tc3hUj0VzdaUAY0z9HE
Message-ID: <CAMuHMdXiSEJqJiMF=YGSgbqRGFLhvFhKfwTwGbkxo-xxC4=-Jg@mail.gmail.com>
Subject: Re: [PATCH resend 2/2] [RFC] genirq: Set IRQCHIP_SKIP_SET_WAKE for
 no_irq_chip and dummy_irq_chip
From: Geert Uytterhoeven <geert@linux-m68k.org>
To: santosh shilimkar <santosh.shilimkar@oracle.com>
Cc: Geert Uytterhoeven <geert+renesas@glider.be>,
        Linus Walleij <linus.walleij@linaro.org>,
        Alexandre Courbot <gnurou@gmail.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Santosh Shilimkar <ssantosh@kernel.org>,
        "linux-gpio@vger.kernel.org" <linux-gpio@vger.kernel.org>,
        Linux-sh list <linux-sh@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Santosh,

On Mon, Jan 12, 2015 at 5:37 PM, santosh shilimkar
<santosh.shilimkar@oracle.com> wrote:
> On 1/12/2015 8:04 AM, Geert Uytterhoeven wrote:
>>
>> If no_irq_chip or dummy_irq_chip are used for wake up (e.g. gpio-keys
>> with a simple GPIO controller), the following warning is printed on
>> resume from s2ram:
>>
>>      WANING: CPU: 0 PID: 1046 at kernel/irq/manage.c:537
>> irq_set_irq_wake+0x9c/0xf8()
>>      Unbalanced IRQ 113 wake disable
>>
>> This happens because no_irq_chip and dummy_irq_chip do not implement
>> irq_chip.irq_set_wake(), causing set_irq_wake_real() to return -ENXIO,
>> and irq_set_irq_wake() to reset the wake_depth to zero.
>>
>> Set IRQCHIP_SKIP_SET_WAKE to indicate that irq_chip.irq_set_wake() is
>> not implemented.
>>
>> Signed-off-by: Geert Uytterhoeven <geert+renesas@glider.be>
>> ---
>> Alternatively, can't we remove IRQCHIP_SKIP_SET_WAKE, and just check for
>> the presence of irq_chip.irq_set_wake()?
>> I'll be happy to send a patch to do that instead...
>>
>> Is there anything that relies on this -ENXIO error code?
>> All irq_chip implementations that set IRQCHIP_SKIP_SET_WAKE do not
>> implement irq_chip.irq_set_wake(). There are probably more of them that
>> forgot to set IRQCHIP_SKIP_SET_WAKE though.
>> Am I missing something?
>> Commit 60f96b41f71d2a13 ("genirq: Add IRQCHIP_SKIP_SET_WAKE flag")
>> doesn't explain why adding the flag was chosen.
>>
> The flag was added to avoid dummy irq_set_wake() implementation
> as described in the commit.
>
> ------------------
> commit 60f96b41f71d2a13d1c0a457b8b77958f77142d1
> Author: Santosh Shilimkar <santosh.shilimkar@ti.com>
> Date:   Fri Sep 9 13:59:35 2011 +0530
>
>     genirq: Add IRQCHIP_SKIP_SET_WAKE flag
>
>     Some irq chips need the irq_set_wake() functionality, but do not
>     require a irq_set_wake() callback. Instead of forcing an empty
>     callback to be implemented add a flag which notes this fact. Check for
>     the flag in set_irq_wake_real() and return success when set.
>
>     Signed-off-by: Santosh Shilimkar <santosh.shilimkar@ti.com>
>     Cc: Thomas Gleixner <tglx@linutronix.de>
> ------------------

I had read that commit description.

> Here is the relevant thread.
> http://lists.infradead.org/pipermail/linux-arm-kernel/2011-September/064590.html
>
> As you can read from thread, the idea is to handle the need at
> genirq level. Either with a flag or a dummy function.

But it's not handled at genirq level. Every driver that doesn't implement the
.irq_set_wake() method has to set the flag. Several of these don't, causing
the warning.

Instead of having to fix them all, can't we remove IRQCHIP_SKIP_SET_WAKE,
and just check for the absence of irq_chip.irq_set_wake() instead?

Is there ever a valid use case for a driver to not provide a .irq_set_wake(),
and not set the flag?

Gr{oetje,eeting}s,

                        Geert

--
Geert Uytterhoeven -- There's lots of Linux beyond ia32 -- geert@linux-m68k.org

In personal conversations with technical people, I call myself a hacker. But
when I'm talking to journalists I just say "programmer" or something like that.
                                -- Linus Torvalds
