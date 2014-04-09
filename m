Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933802AbaDIPNe (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:13:34 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:47078 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933148AbaDIPNc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:13:32 -0400
Date: Wed, 9 Apr 2014 17:13:26 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Jonas Jensen <jonas.jensen@gmail.com>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Message-ID: <20140409151326.GY29751@pengutronix.de>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
 <20131213095655.GB4360@n2100.arm.linux.org.uk>
 <CACmBeS1d-EX5oPD8f7P-ufmF=MutdTO+LgG23Cb0=biR8yQPCg@mail.gmail.com>
 <20131213113903.GE4360@n2100.arm.linux.org.uk>
 <CACmBeS3kC4dsdOrfANifgu8oQhLauFKcXhEu=iz8xbUxdhMq_A@mail.gmail.com>
 <20140409150640.GQ16119@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20140409150640.GQ16119@n2100.arm.linux.org.uk>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hello Russell,

On Wed, Apr 09, 2014 at 04:06:40PM +0100, Russell King - ARM Linux wrote:
> On Wed, Apr 09, 2014 at 04:54:16PM +0200, Jonas Jensen wrote:
> > On 13 December 2013 12:39, Russell King - ARM Linux
> > <linux@arm.linux.org.uk> wrote:
> > > I see what's causing this: the kuser helpers are using "bx lr" to return
> > > which will be undefined on non-Thumb CPUs.  We generally cope fine with
> > > non-Thumb CPUs, conditionalising where necessary on HWCAP_THUMB or the
> > > T bit in the PSR being set.
> > >
> > > However, it looks like the kuser helpers got missed.  As a check, please
> > > look at arch/arm/kernel/entry-armv.S, find the line with:
> > >
> > >         .macro  usr_ret, reg
> > >
> > > and ensure that the mov pc, \reg case always gets used.  Please report
> > > back.
> > 
> > Uwe and Arnd came up with a solution except it doesn't work when I test it.
> > 
> > The suggested patch is:
> > 
> > diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> > index 1879e8d..de15bfd 100644
> > --- a/arch/arm/kernel/entry-armv.S
> > +++ b/arch/arm/kernel/entry-armv.S
> > @@ -739,6 +739,18 @@ ENDPROC(__switch_to)
> > 
> >         .macro  usr_ret, reg
> >  #ifdef CONFIG_ARM_THUMB
> > +       /*
> > +        * Having CONFIG_ARM_THUMB isn't a guarantee that the cpu has support
> > +        * for Thumb and so the bx instruction. Use a mov if the address to
> > +        * jump to is 32 bit aligned. (Note that this code is compiled in ARM
> > +        * mode, so this is the right test.)
> > +        */
> > +#if defined(CONFIG_CPU_32v4)
> > +       tst     \reg, #3
> > +       moveq   pc, \reg
> > +       b       .
> > +#endif
> > +
> >         bx      \reg
> 
> What's wrong with:
> 	tst	\reg, #3
> 	moveq	pc, \reg
> 	bx	\reg
> 
> rather than ending in an infinite loop?
The added b . was a test to check if the machine then hangs instead of
crashing. (And yes, that was the case, so it was tried to return to a
non-aligned address.)

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
