Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755955Ab3EQNRl (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 09:17:41 -0400
Received: from mail-ie0-f177.google.com ([209.85.223.177]:42048 "EHLO
	mail-ie0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752319Ab3EQNRj convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 09:17:39 -0400
MIME-Version: 1.0
In-Reply-To: <26FBB324-AAA9-4C10-8978-C2EC1C26672E@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com>
	<1368332581-94691-5-git-send-email-dt.tangr@gmail.com>
	<CACRpkdZBFbOnQ9rCehO0yKDN7fH9VR3VYCa_NkOGJz7KN+02FQ@mail.gmail.com>
	<26FBB324-AAA9-4C10-8978-C2EC1C26672E@gmail.com>
Date: Fri, 17 May 2013 15:17:39 +0200
Message-ID: <CACRpkdaO7ieSdo5+Yq0+CLDfP==+DBOWn8+v0ap5iMOJy0Vf=Q@mail.gmail.com>
Subject: Re: [RFC PATCHv3 4/6] clocksource: Add TI-Nspire timer drivers
From: Linus Walleij <linus.walleij@linaro.org>
To: Daniel Tang <dt.tangr@gmail.com>
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=windows-1252
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 14, 2013 at 1:51 PM, Daniel Tang <dt.tangr@gmail.com> wrote:
> On 14/05/2013, at 6:03 PM, Linus Walleij <linus.walleij@linaro.org> wrote:
>
>>> +
>>> +       timer->interrupt_regs = of_iomap(node, 1);
>>
>> Check for errors.
>>
>>> +       timer->irqnr = irq_of_parse_and_map(node, 0);
>>
>> Check for errors.
>>> +       if (timer->interrupt_regs && timer->irqnr) {
>>>
>
> The idea with this is to make these properties optional. Each timer has two sub-timers
> but only one can generate interrupts.

I see now. Sorry, I was just being dumb, don't worry!

> Should I comment it in the code to make it apparent what's happening or is there a
> better way to express this?

Maybe. Maybe it's obvious to everyone else but me :-/

>>> +               writel(0x3F, timer->interrupt_regs + IO_INTR_ACK);
>>
>> Hm magic number, I guess it's clearing all IRQ lines…
>
> It's a bitmask of bits 0-5.

Yeah I figured so much... So 6 IRQ lines that get cleared.

>> If this timer is really just 16 bits, it's a *pretty* good idea to use
>> the prescaler (I guess this is what IO_DIVIDER is) beacuse else you
>> will get short sleep times with CONFIG_NO_HZ_IDLE on this system,
>> and wake up unnecessarily often.
>>
>> The same goes for the clock event.
>
> The clock frequency is 32768Hz. Should I be scaling it down at that frequency?

No. But that was *pretty* slow.

The thing is that the driver is getting "some clockfrequency" from
the clk subsystem and does not know what it is.

Usually (and I've seen this hardware design pattern a lot) when you
have a clock like this, and go talk to the clk implementation specialist
s/he will say "oh, yeah, I can mux in this 34 MHz clock to the timer
as well", and if that is possible then that is often what you want,
because it's good for things like HRtimers, and then it's useful to have
a prescaler och the clocksource/clockevent.

You can use that 32768 Hz for clock events and clocksource (but I
suspect that HRtimers will never be useful on this platform due to this).

Yours,
Linus Walleij
