Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754860AbaGULJn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Jul 2014 07:09:43 -0400
Received: from mail-qg0-f54.google.com ([209.85.192.54]:53976 "EHLO
	mail-qg0-f54.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754663AbaGULJk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Jul 2014 07:09:40 -0400
MIME-Version: 1.0
In-Reply-To: <alpine.DEB.2.10.1407151152310.24854@nanos>
References: <1405413956-2772-1-git-send-email-lftan@altera.com>
	<1405413956-2772-20-git-send-email-lftan@altera.com>
	<alpine.DEB.2.10.1407151152310.24854@nanos>
Date: Mon, 21 Jul 2014 19:09:39 +0800
X-Google-Sender-Auth: 9LksLj35b2JY8WeCJO2LDi3kZEk
Message-ID: <CAFiDJ5_AQ7Rby5Ta=mhzwQ28hiR_VbxbxXemSHqP9OyJmJx+Kw@mail.gmail.com>
Subject: Re: [PATCH v2 19/29] nios2: Time keeping
From: Ley Foon Tan <lftan@altera.com>
To: Thomas Gleixner <tglx@linutronix.de>
Cc: Linux-Arch <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-doc@vger.kernel.org" <linux-doc@vger.kernel.org>,
        Chung-Lin Tang <cltang@codesourcery.com>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 15, 2014 at 6:00 PM, Thomas Gleixner <tglx@linutronix.de> wrote:

>> +     count =
>> +             readw(timer_membase + ALTERA_TIMER_SNAPH_REG) << 16 |
>> +             readw(timer_membase + ALTERA_TIMER_SNAPL_REG);
>
> So you're serious about having a new architecture with a timer
> implementation which cant read 32bit in one go? I'm impressed ...
This is to compatible with 16-bit and 32-bit processors. The older
version of Nios is 16-bit and Nios II is 32-bit.
But this timer core doesn't get updated after Nios is end of life.


>> +irqreturn_t timer_interrupt(int irq, void *dummy)
>> +{
>> +     /* Clear the interrupt condition */
>> +     writew(0, timer_membase + ALTERA_TIMER_STATUS_REG);
>> +     nios2_timer_count += NIOS2_TIMER_PERIOD;
>> +
>> +     profile_tick(CPU_PROFILING);
>> +
>> +     xtime_update(1);
>> +
>> +     update_process_times(user_mode(get_irq_regs()));
>> +
>> +     return IRQ_HANDLED;
>
> Please use the clock events infrastructure. New users of the old style
> timer management are not welcome.
Okay, will change this.

>
>> +}
>> +
>> +static cycle_t nios2_timer_read(struct clocksource *cs)
>> +{
>> +     unsigned long flags;
>> +     u32 cycles;
>> +     u32 tcn;
>> +
>> +     local_irq_save(flags);
>> +     tcn = NIOS2_TIMER_PERIOD - 1 - read_timersnapshot();
>> +     cycles = nios2_timer_count;
>
> This is wrong and completely pointless. The core code takes care about
> the offset.
This offset is different from the core code. The core code is handling
cycle counter overlapping.
But this is for the offset between last timer interrupt counter and
current counter (read_timersnapshot()).

Thanks.

Regards
Ley Foon
