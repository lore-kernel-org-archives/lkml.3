Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752430Ab3GSVfI (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Jul 2013 17:35:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:40588 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751810Ab3GSVfG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Jul 2013 17:35:06 -0400
Date: Fri, 19 Jul 2013 23:34:58 +0200
From: Borislav Petkov <bp@alien8.de>
To: John Stultz <john.stultz@linaro.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Borislav Petkov <bp@suse.de>, Thomas Gleixner <tglx@linutronix.de>,
        Rabin Vincent <rabin.vincent@stericsson.com>
Subject: Re: [PATCH] RTC: Add an alarm disable quirk
Message-ID: <20130719213458.GF19581@pd.tnic>
References: <1374162294-29726-1-git-send-email-bp@alien8.de>
 <51E8194E.1030704@linaro.org>
 <20130718225349.GD15992@pd.tnic>
 <20130719142628.GC19581@pd.tnic>
 <20130719151321.GD19581@pd.tnic>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <20130719151321.GD19581@pd.tnic>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jul 19, 2013 at 05:13:21PM +0200, Borislav Petkov wrote:
> Nope, this doesn't help - box just rebooted. :(
> 
> So I'm back to the DMI quirk patch...

Ok, some more observations before I throw this box out the window:

So, we emulate RTC there with HPET:

$ cat /proc/driver/rtc
rtc_time        : 21:06:48
rtc_date        : 2013-07-19
alrm_time       : 20:59:59
alrm_date       : 2013-07-20
alarm_IRQ       : no
alrm_pending    : no
update IRQ enabled      : no
periodic IRQ enabled    : no
periodic IRQ frequency  : 1024
max user IRQ frequency  : 64
24hr            : yes
periodic_IRQ    : no
update_IRQ      : no
HPET_emulated   : yes
BCD             : yes
DST_enable      : no
periodic_freq   : 1024
batt_status     : okay

Now I added a bit debugging printks:

[   11.234652] rtc_cmos_read:  addr: 0xb, val: 0x2
[   11.239960] rtc_cmos_read:  addr: 0xc, val: 0x50
[   11.245360] rtc_cmos_write: addr: 0xb, val: 0x22

This is where we enable the RTC alarm irq.

[   11.250736] rtc_cmos_read:  addr: 0xc, val: 0x40
[   11.256104] rtc_cmos_read:  addr: 0xa, val: 0x26
[   11.261458] rtc_cmos_read:  addr: 0x0, val: 0x19
[   11.266792] rtc_cmos_read:  addr: 0x2, val: 0x6
[   11.272017] rtc_cmos_read:  addr: 0x4, val: 0x21
[   11.277307] rtc_cmos_read:  addr: 0x7, val: 0x19
[   11.282570] rtc_cmos_read:  addr: 0x8, val: 0x7
[   11.287729] rtc_cmos_read:  addr: 0x9, val: 0x13
[   11.292957] rtc_cmos_read:  addr: 0xb, val: 0x22
[   11.298168] hpet1: lost 1 rtc interrupts

And right when we read it out, we get an RTC irq (hpet_rtc_interrupt on
comparator 1) and we keep incrementing the comparator until we're ahead
of the hpet counter.

Normally we'll do it only once and not have lost interrupts but it
happens here.

And the strange thing is that it happens right after we read
RTC_CONTROL, i.e. 0xb, where the alarm irq bit resides. Coincidence...?

Hmm, I don't know what to make of it... Anyway, TGIF!

Thanks for listening. :)

[   11.302668] rtc_cmos_read:  addr: 0xa, val: 0x26
[   11.307852] rtc_cmos_read:  addr: 0x0, val: 0x19
[   11.313010] rtc_cmos_read:  addr: 0x2, val: 0x6
[   11.318056] rtc_cmos_read:  addr: 0x4, val: 0x21
[   11.323164] rtc_cmos_read:  addr: 0x7, val: 0x19
[   11.328253] rtc_cmos_read:  addr: 0x8, val: 0x7
[   11.333245] rtc_cmos_read:  addr: 0x9, val: 0x13
[   11.338319] rtc_cmos_read:  addr: 0xb, val: 0x22
[   11.343383] hpet1: lost 1 rtc interrupts
[   11.347753] rtc_cmos_read:  addr: 0xa, val: 0x26
[   11.352826] rtc_cmos_read:  addr: 0x0, val: 0x19
[   11.357899] rtc_cmos_read:  addr: 0x2, val: 0x6
[   11.362858] rtc_cmos_read:  addr: 0x4, val: 0x21
[   11.367887] rtc_cmos_read:  addr: 0x7, val: 0x19
[   11.372887] rtc_cmos_read:  addr: 0x8, val: 0x7
[   11.377797] rtc_cmos_read:  addr: 0x9, val: 0x13
[   11.382798] rtc_cmos_read:  addr: 0xb, val: 0x22
[   11.387803] hpet1: lost 2 rtc interrupts
[   11.392113] rtc_cmos_read:  addr: 0xa, val: 0x26
[   11.397132] rtc_cmos_read:  addr: 0x0, val: 0x19
[   11.402143] rtc_cmos_read:  addr: 0x2, val: 0x6
[   11.407077] rtc_cmos_read:  addr: 0x4, val: 0x21
[   11.412097] rtc_cmos_read:  addr: 0x7, val: 0x19
[   11.417116] rtc_cmos_read:  addr: 0x8, val: 0x7
[   11.422042] rtc_cmos_read:  addr: 0x9, val: 0x13
[   11.427063] rtc_cmos_read:  addr: 0xb, val: 0x22
[   11.432085] hpet1: lost 2 rtc interrupts
[   11.436419] rtc_cmos_read:  addr: 0xa, val: 0x26
[   11.441455] rtc_cmos_read:  addr: 0x0, val: 0x19
[   11.446494] rtc_cmos_read:  addr: 0x2, val: 0x6
[   11.451452] rtc_cmos_read:  addr: 0x4, val: 0x21
[   11.456500] rtc_cmos_read:  addr: 0x7, val: 0x19
[   11.461546] rtc_cmos_read:  addr: 0x8, val: 0x7
[   11.466504] rtc_cmos_read:  addr: 0x9, val: 0x13
[   11.471551] rtc_cmos_read:  addr: 0xb, val: 0x22
[   11.476599] hpet1: lost 2 rtc interrupts
[   11.480958] rtc_cmos_read:  addr: 0xa, val: 0x26
[   11.486023] rtc_cmos_read:  addr: 0x0, val: 0x19
[   11.491078] rtc_cmos_read:  addr: 0x2, val: 0x6
[   11.496047] rtc_cmos_read:  addr: 0x4, val: 0x21
[   11.501111] rtc_cmos_read:  addr: 0x7, val: 0x19
[   11.506172] rtc_cmos_read:  addr: 0x8, val: 0x7
[   11.511151] rtc_cmos_read:  addr: 0x9, val: 0x13
[   11.516222] rtc_cmos_read:  addr: 0xb, val: 0x22
[   11.521289] hpet1: lost 2 rtc interrupts
[   11.525664] rtc_cmos_read:  addr: 0xa, val: 0x26
[   11.530747] rtc_cmos_read:  addr: 0x0, val: 0x19
[   11.535818] rtc_cmos_read:  addr: 0x2, val: 0x6
[   11.540795] rtc_cmos_read:  addr: 0x4, val: 0x21
[   11.545859] rtc_cmos_read:  addr: 0x7, val: 0x19
[   11.550920] rtc_cmos_read:  addr: 0x8, val: 0x7
[   11.555897] rtc_cmos_read:  addr: 0x9, val: 0x13
[   11.560962] rtc_cmos_read:  addr: 0xb, val: 0x22
[   11.566028] hpet1: lost 2 rtc interrupts

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
