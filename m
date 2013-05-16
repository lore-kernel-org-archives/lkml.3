Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754515Ab3EPOwN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 16 May 2013 10:52:13 -0400
Received: from moutng.kundenserver.de ([212.227.17.9]:57303 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752128Ab3EPOwK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 16 May 2013 10:52:10 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Jonas Jensen <jonas.jensen@gmail.com>, linux@arm.linux.org.uk,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: mach-moxart: platform port for MOXA ART SoC
Date: Thu, 16 May 2013 16:52:55 +0200
Message-ID: <4406410.DRdDEViWVK@wuerfel>
User-Agent: KMail/4.10.2 (Linux/3.8.0-17-generic; KDE/4.10.2; x86_64; ; )
In-Reply-To: <CACmBeS3JZ8bm6jJbmrKTfmZqshezN6QKdmyPCKdQ2HUwzY7ggA@mail.gmail.com>
References: <CACmBeS1NLFUYHBOVL28aCCzRrgXYGPZF9t3qj6AdcgaMkrPGoQ@mail.gmail.com> <201305151516.52389.arnd@arndb.de> <CACmBeS3JZ8bm6jJbmrKTfmZqshezN6QKdmyPCKdQ2HUwzY7ggA@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:S7CHGptcuLWv7lF3IX5c19EGI+JipafWS8WNVo/Tkzz
 46UkWW8Jt+H112ZfgHcdFUwjIJzOBeoyI2UwGVrg3Qw2Te9czJ
 l2pD31BwlaE6/8bFCG71dv7amuO/QiaFt2iTwYPiEzXLgwytzZ
 m2JuvW41z/K7vQKt8zMuywdyf3/w0Qdnu6PQN3MrC+3TZ+npdY
 XanPOKakjOEGHpPL2rVoXjog8p3SW1K0ccavdLufpwFTtsSUfP
 o9AXggHSJzbtSZPW+0d5pvby3rgAUEdbedlSG6rtorreoVe7Oa
 yIv14wJILXCsRPEM0Ha1nG7FiaF4hPvN7tT3LIqtoYtog5fNvl
 4MxGvjgabpYGyF3i81/g=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thursday 16 May 2013 15:37:16 Jonas Jensen wrote:
> On 15 May 2013 15:16, Arnd Bergmann <arnd@arndb.de> wrote:
> > The part that I don't understand at all is the "timer0" part. Is that a string
> > from the data sheet?
> 
> I have next to no data sheets or documentation on the SoC itself. What
> I know is from looking at old sources, which suggest there are more
> than one timer (the rest were never implemented).
> 
> It only needs one for timer_tick? Does it make sense to just call it "timer"?

Yes, I think just "moxa,moxart-timer" is fine. Chances are that if you have
more of them, they are actually compatible with one another. If they are not
and you need more than one, you can always pick a different name
if you need another one.

> > Can you provide some more detail why what PMU registers are used here? Is that
> > a "Performance Measurement Unit", "Power Management Unit" or something else?
> > Are you sure that those registers are only ever needed for GPIO?
> 
> It's "Power Management Unit". The MMC driver uses it to read system
> clock and write it to clock control, but I suspect it can be removed.
> It's code under #ifdef MSD_SUPPORT_GET_CLOCK but I think the else is
> perfectly acceptable.
> GPIO uses it only to enable or disable pins.

It sounds like this is used for what should be separate drivers/clk and
drivers/pinctrl drivers:

A pinctrl driver is often the superset of a gpio driver and can control
more aspects of a pin than the gpio interface can.

The clk driver is supposed to give an abstraction of the clock tree
to be used with interfaces like clk_get() and clk_set_rate(). It
can probably be really simple in case of moxart. Is the mmc driver
the only one that needs access to clocks?

Are the pinctrl and clk registers in different parts of the PMU, or are
they intermixed? In the former case, you can just turn it into separate
devices that have their own distinct "reg" properties, in the second
case, the best solution is likely to mark the pmu 'compatible="syscon"'
and use the drivers/mfd/syscon.c driver to get a regmap that is used
by the clock and pinctrl drivers, respectively.

	Arnd
