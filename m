Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752041AbaENTuz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 15:50:55 -0400
Received: from mout.kundenserver.de ([212.227.126.131]:53379 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751711AbaENTux (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 15:50:53 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: Florian Fainelli <f.fainelli@gmail.com>
Cc: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Marc Carino <marc.ceeeee@gmail.com>,
        Brian Norris <computersforpeace@gmail.com>,
        Gregory Fong <gregory.0xf0@gmail.com>,
        Randy Dunlap <rdunlap@infradead.org>, Rob Herring <robh+dt@kernel.org>,
        Pawel Moll <pawel.moll@arm.com>, Mark Rutland <mark.rutland@arm.com>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Kumar Gala <galak@codeaurora.org>,
        Grant Likely <grant.likely@linaro.org>,
        Shawn Guo <shawn.guo@linaro.org>,
        Sascha Hauer <s.hauer@pengutronix.de>,
        Nicolas Pitre <nicolas.pitre@linaro.org>,
        Lorenzo Pieralisi <lorenzo.pieralisi@arm.com>,
        Alexander Shiyan <shc_work@mail.ru>,
        Huang Shijie <b32955@freescale.com>,
        "open list:DOCUMENTATION" <linux-doc@vger.kernel.org>,
        "open list:OPEN FIRMWARE AND..." <devicetree@vger.kernel.org>
Subject: Re: [PATCH 1/3] bus: add Broadcom GISB arbiter bus timeout/error handler
Date: Wed, 14 May 2014 21:50:35 +0200
Message-ID: <22473479.pvlGq0ATOy@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <CAGVrzcag3aKiuuQsfZWrAJT+-cpO__kNF3Lc9XXkpswQxzL56A@mail.gmail.com>
References: <1400094649-11193-1-git-send-email-f.fainelli@gmail.com> <8057197.5nM8JDA8pQ@wuerfel> <CAGVrzcag3aKiuuQsfZWrAJT+-cpO__kNF3Lc9XXkpswQxzL56A@mail.gmail.com>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:SWCW4Vec7L2zrRkVX3pfQJ5K4oQtzNJdtOPCQ6dyDgx
 a+yLxWNdSsoZAl5H51kmI2NBi5UIie9L3oUjOlQ80Eb9awGnv1
 xvQN4qIykQwH9yDK6zj45te4O1GyvF0izyaYUqffm7fwSq2tkr
 QXTpdT1qXBWosZF0Au1siWlSEO62I+YdPSstjv8f3Z6AdsDWiX
 q6TuD4+S/OAurpKEgmaiglGzbO1EkRGLI/S2svQbLbHAzKkXjV
 ftrWyx16rrxNyDatC6k4sXMt831XsBpKN8cnFGjBcZOQ19qjTk
 ib2ulJdPlxaeabvXKVnG3pI2r2Z/kFI5o0sTGWLpPUVW+T+Wc7
 RC0dAebEG5gkNT8Nip/I=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 12:46:06 Florian Fainelli wrote:
> 2014-05-14 12:33 GMT-07:00 Arnd Bergmann <arnd@arndb.de>:
> > On Wednesday 14 May 2014 12:10:46 Florian Fainelli wrote:
> >> This patch adds support for the Broadcom GISB arbiter bus timeout/error
> >> handler. GISB is a proprietary bus used by Broadcom Set Top Box
> >> System-on-a-chip devices (BCM7xxx) which allows multiple masters and
> >> clients to be interfaced with each other.
> >>
> >> The bus arbiter offers support for generating two interrupts towards the
> >> host CPU, thus allowing us to "catch" clock gated masters, or masters
> >> being volontarily blocked for powersaving purposes, or do general system
> >> troubleshooting.
> >>
> >> We also register a hook with the ARM fault exception handling to allow
> >> printing a more informative message than "imprecise external abort at
> >> 0x00000000" for instance.
> >>
> >> Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
> >
> > Looks pretty good to me.
> 
> Cool, thanks!, BTW, which tree should we attempt to get this merged into?

We can probably take it through arm-soc along with the other platform
specific changes for bcm7xxx, since there is no maintainer for drivers/bus yet.

> >> +static int brcmstb_bus_error_handler(unsigned long addr, unsigned int fsr,
> >> +                                  struct pt_regs *regs)
> >> +{
> >> +     int ret = 0;
> >> +     struct brcmstb_gisb_arb_device *gdev;
> >> +
> >> +     /* iterate over each GISB arb registered handlers */
> >> +     list_for_each_entry(gdev, &brcmstb_gisb_arb_device_list, next)
> >> +             ret |= brcmstb_gisb_arb_decode_addr(gdev, "bus error");
> >> +     /*
> >> +      * If it was an imprecise abort, then we need to correct the
> >> +      * return address to be _after_ the instruction.
> >> +     */
> >> +     if (fsr & (1 << 10))
> >> +             regs->ARM_pc += 4;
> >> +
> >> +     return ret;
> >> +}
> >
> > This will cause the normal abort handler to trigger if the GISB
> > arbiter doesn't know what happened, right?
> 
> That's right, one of the very first things that the GISB arbiter
> checks is whether the faulting error is valid or not, if it is not, it
> bails out and so we keep on processing the other exception handlers.

Ok, good.

	Arnd
