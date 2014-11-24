Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754530AbaKXT5b (ORCPT <rfc822;w@1wt.eu>);
	Mon, 24 Nov 2014 14:57:31 -0500
Received: from mail-qg0-f52.google.com ([209.85.192.52]:61356 "EHLO
	mail-qg0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751705AbaKXT53 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 24 Nov 2014 14:57:29 -0500
MIME-Version: 1.0
In-Reply-To: <CAL1qeaG+cmQDW3ceqq4kGgWBsf4RgfFpQ76OG0dg3SJy6nitgw@mail.gmail.com>
References: <1416796846-28149-1-git-send-email-cernekee@gmail.com>
 <1416796846-28149-12-git-send-email-cernekee@gmail.com> <CAL1qeaG+cmQDW3ceqq4kGgWBsf4RgfFpQ76OG0dg3SJy6nitgw@mail.gmail.com>
From: Kevin Cernekee <cernekee@gmail.com>
Date: Mon, 24 Nov 2014 11:57:08 -0800
Message-ID: <CAJiQ=7BRjxaGki515mZRUt7h9917DwUpkY6yVsz-WsF8WCpvEw@mail.gmail.com>
Subject: Re: [PATCH V3 11/11] MIPS: Add multiplatform BMIPS target
To: Andrew Bresticker <abrestic@google.com>
Cc: Ralf Baechle <ralf@linux-mips.org>,
        Florian Fainelli <f.fainelli@gmail.com>,
        Jon Fraser <jfraser@broadcom.com>, Dmitry Torokhov <dtor@chromium.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, Jonas Gorski <jogo@openwrt.org>,
        Arnd Bergmann <arnd@arndb.de>,
        Brian Norris <computersforpeace@gmail.com>,
        Linux-MIPS <linux-mips@linux-mips.org>,
        "devicetree@vger.kernel.org" <devicetree@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Nov 24, 2014 at 11:29 AM, Andrew Bresticker <abrestic@google.com> wrote:
>> diff --git a/arch/mips/bmips/setup.c b/arch/mips/bmips/setup.c
>
>> +void __init plat_time_init(void)
>> +{
>> +       struct device_node *np;
>> +       u32 freq;
>> +
>> +       np = of_find_node_by_name(NULL, "cpus");
>> +       if (!np)
>> +               panic("missing 'cpus' DT node");
>> +       if (of_property_read_u32(np, "mips-hpt-frequency", &freq) < 0)
>> +               panic("missing 'mips-hpt-frequency' property");
>> +       of_node_put(np);
>> +
>> +       mips_hpt_frequency = freq;
>> +}
>
> Could you use common clock framework for this?  Isn't the HPT just a
> fixed factor of the CPU clock?  I'm planning on doing something very
> similar for ImgTec MIPS SoCs, so perhaps this could go in a common
> place, like the r4k clocksource driver?

Jonas and I had tossed some ideas around earlier, and I included a few
random thoughts in the cover letter.

One concern is that this currently has to be set pretty early in the
boot process (prior to jiffies calibration IIRC), so it might still
need to be handled as a special case.

Regarding the "fixed factor" question: that is true on all of the
chips I've seen, with a few additional caveats:

 - Most MIPS cores use cpu_clk/2, but BMIPS5000 uses cpu_clk/8.

 - Some MIPS cores scale the CP0 counter frequency when the cpu_clk is
changed, but others do not.  Sometimes this depends on the core rev
(e.g. 65nm BMIPS438x cores do scale, but 40nm BMIPS438x cores do not).

 - We might not necessarily have a good way to determine cpu_clk on
every platform, either.
