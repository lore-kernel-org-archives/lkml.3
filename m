Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757356Ab3ENLv0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 14 May 2013 07:51:26 -0400
Received: from mail-da0-f43.google.com ([209.85.210.43]:56599 "EHLO
	mail-da0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753138Ab3ENLvZ convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 14 May 2013 07:51:25 -0400
Content-Type: text/plain; charset=windows-1252
Mime-Version: 1.0 (Mac OS X Mail 6.3 \(1503\))
Subject: Re: [RFC PATCHv3 4/6] clocksource: Add TI-Nspire timer drivers
From: Daniel Tang <dt.tangr@gmail.com>
In-Reply-To: <CACRpkdZBFbOnQ9rCehO0yKDN7fH9VR3VYCa_NkOGJz7KN+02FQ@mail.gmail.com>
Date: Tue, 14 May 2013 21:51:10 +1000
Cc: Thomas Gleixner <tglx@linutronix.de>, John Stultz <john.stultz@linaro.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>,
        "fabian@ritter-vogt.de Vogt" <fabian@ritter-vogt.de>,
        Lionel Debroux <lionel_debroux@yahoo.fr>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Transfer-Encoding: 8BIT
Message-Id: <26FBB324-AAA9-4C10-8978-C2EC1C26672E@gmail.com>
References: <1368332581-94691-1-git-send-email-dt.tangr@gmail.com> <1368332581-94691-5-git-send-email-dt.tangr@gmail.com> <CACRpkdZBFbOnQ9rCehO0yKDN7fH9VR3VYCa_NkOGJz7KN+02FQ@mail.gmail.com>
To: Linus Walleij <linus.walleij@linaro.org>
X-Mailer: Apple Mail (2.1503)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


On 14/05/2013, at 6:03 PM, Linus Walleij <linus.walleij@linaro.org> wrote:

>> +
>> +       timer->interrupt_regs = of_iomap(node, 1);
> 
> Check for errors.
> 
>> +       timer->irqnr = irq_of_parse_and_map(node, 0);
> 
> Check for errors.
>> +       if (timer->interrupt_regs && timer->irqnr) {
>> 

The idea with this is to make these properties optional. Each timer has two sub-timers but only one can generate interrupts. One will be added as a clockevent device and the other as a clocksource. If an IRQ number or interrupt acknowledge address is not passed through the DT, then the clockevents device is not added but the clocksource still is.

Should I comment it in the code to make it apparent what's happening or is there a better way to express this?

> 
>> +               writel(0x3F, timer->interrupt_regs + IO_INTR_ACK);
> 
> Hm magic number, I guess it's clearing all IRQ lines…

It's a bitmask of bits 0-5. 

> 
>> +
>> +               /* Interrupt to occur when timer value matches 0 */
>> +               writel(0, timer->base + IO_MATCH1);
>> +
>> +               timer->clkevt_irq.name  = timer->clockevent_name;
>> +               timer->clkevt_irq.handler = nspire_timer_interrupt;
>> +               timer->clkevt_irq.dev_id = timer;
>> +               timer->clkevt_irq.flags =
>> +                       IRQF_DISABLED | IRQF_TIMER | IRQF_IRQPOLL;
>> +
>> +               setup_irq(timer->irqnr, &timer->clkevt_irq);
>> +
>> +               clockevents_config_and_register(&timer->clkevt,
>> +                               clk_get_rate(timer->clk), 0x0001, 0xfffe);
>> +               pr_info("Added %s as clockevent\n", timer->clockevent_name);
>> +       }
>> +
>> +       writel(CNTL_RUN_TIMER | CNTL_FOREVER | CNTL_INC,
>> +                       timer->timer2 + IO_CONTROL);
>> +
>> +       clocksource_mmio_init(timer->timer2 + IO_CURRENT_VAL,
>> +                       timer->clocksource_name,
>> +                       clk_get_rate(timer->clk),
>> +                       200, 16,
>> +                       clocksource_mmio_readw_up);
> 
> If this timer is really just 16 bits, it's a *pretty* good idea to use
> the prescaler (I guess this is what IO_DIVIDER is) beacuse else you
> will get short sleep times with CONFIG_NO_HZ_IDLE on this system,
> and wake up unnecessarily often.
> 
> The same goes for the clock event.

The clock frequency is 32768Hz. Should I be scaling it down at that frequency?

> 
> See how we calculate the prescaler in arch/arm/mach-integrator/integrator_ap.c
> for example.
> 
> Yours,
> Linus Walleij

Cheers,
Daniel Tang