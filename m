Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933637AbaDIPFV (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:05:21 -0400
Received: from metis.ext.pengutronix.de ([92.198.50.35]:50969 "EHLO
	metis.ext.pengutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933079AbaDIPFT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:05:19 -0400
Date: Wed, 9 Apr 2014 17:04:48 +0200
From: Uwe =?iso-8859-1?Q?Kleine-K=F6nig?= 
	<u.kleine-koenig@pengutronix.de>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Message-ID: <20140409150448.GX29751@pengutronix.de>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com>
 <20131213095655.GB4360@n2100.arm.linux.org.uk>
 <CACmBeS1d-EX5oPD8f7P-ufmF=MutdTO+LgG23Cb0=biR8yQPCg@mail.gmail.com>
 <20131213113903.GE4360@n2100.arm.linux.org.uk>
 <CACmBeS3kC4dsdOrfANifgu8oQhLauFKcXhEu=iz8xbUxdhMq_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <CACmBeS3kC4dsdOrfANifgu8oQhLauFKcXhEu=iz8xbUxdhMq_A@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
X-SA-Exim-Connect-IP: 2001:6f8:1178:2:5054:ff:fec0:8e10
X-SA-Exim-Mail-From: ukl@pengutronix.de
X-SA-Exim-Scanned: No (on metis.ext.pengutronix.de); SAEximRunCond expanded to false
X-PTX-Original-Recipient: linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Apr 09, 2014 at 04:54:16PM +0200, Jonas Jensen wrote:
> On 13 December 2013 12:39, Russell King - ARM Linux
> <linux@arm.linux.org.uk> wrote:
> > I see what's causing this: the kuser helpers are using "bx lr" to return
> > which will be undefined on non-Thumb CPUs.  We generally cope fine with
> > non-Thumb CPUs, conditionalising where necessary on HWCAP_THUMB or the
> > T bit in the PSR being set.
> >
> > However, it looks like the kuser helpers got missed.  As a check, please
> > look at arch/arm/kernel/entry-armv.S, find the line with:
> >
> >         .macro  usr_ret, reg
> >
> > and ensure that the mov pc, \reg case always gets used.  Please report
> > back.
> 
> Uwe and Arnd came up with a solution except it doesn't work when I test it.
> 
> The suggested patch is:
> 
> diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
> index 1879e8d..de15bfd 100644
> --- a/arch/arm/kernel/entry-armv.S
> +++ b/arch/arm/kernel/entry-armv.S
> @@ -739,6 +739,18 @@ ENDPROC(__switch_to)
> 
>         .macro  usr_ret, reg
>  #ifdef CONFIG_ARM_THUMB
> +       /*
> +        * Having CONFIG_ARM_THUMB isn't a guarantee that the cpu has support
> +        * for Thumb and so the bx instruction. Use a mov if the address to
> +        * jump to is 32 bit aligned. (Note that this code is compiled in ARM
> +        * mode, so this is the right test.)
> +        */
> +#if defined(CONFIG_CPU_32v4)
> +       tst     \reg, #3
> +       moveq   pc, \reg
> +       b       .
> +#endif
> +
>         bx      \reg
>  #else
>         mov     pc, \reg
> 
> 
> With this applied, and the following two possibilities in next-20140403:
> 
> [1] ARCH_MULTI_V4 only (no CONFIG_ARM_THUMB)
>      CONFIG_CPU_32v4=y
> 
> [2] ARCH_MULTI_V4 and ARCH_MULTI_V4T
>      CONFIG_ARM_THUMB=y
>      CONFIG_CPU_32v4=y
>      CONFIG_CPU_32v4T=y
> 
> 
> Booting a kernel with either option [1] or [2] yield the following results:
> 
> [1] works
> [2] hangs after "[    2.730000] Freeing unused kernel memory: 104K
> (c02f5000 - c030f000)"
> 
> 
> Any help why the moveq doesn't work would be much appreciated.
doing s/moveq/mov/ does the trick on the machine in question, but this
is obviously not an option for mainline. But it means that even on this
non-Thumb capable machine \reg contains an address that is not aligned.

Where does \reg come from? Is it provided by userspace? If so, is it a
userspace bug?

Best regards
Uwe

-- 
Pengutronix e.K.                           | Uwe Kleine-König            |
Industrial Linux Solutions                 | http://www.pengutronix.de/  |
