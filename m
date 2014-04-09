Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964810AbaDIPHS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 11:07:18 -0400
Received: from gw-1.arm.linux.org.uk ([78.32.30.217]:55558 "EHLO
	pandora.arm.linux.org.uk" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S933372AbaDIPHQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 11:07:16 -0400
Date: Wed, 9 Apr 2014 16:06:40 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonas Jensen <jonas.jensen@gmail.com>
Cc: "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "arm@kernel.org" <arm@kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        ulli.kroll@googlemail.com, Arnd Bergmann <arnd@arndb.de>,
        Olof Johansson <olof@lixom.net>, u.kleine-koenig@pengutronix.de
Subject: Re: [PATCH] ARM: reinsert ARCH_MULTI_V4 Kconfig option
Message-ID: <20140409150640.GQ16119@n2100.arm.linux.org.uk>
References: <1386922149-4561-1-git-send-email-jonas.jensen@gmail.com> <20131213095655.GB4360@n2100.arm.linux.org.uk> <CACmBeS1d-EX5oPD8f7P-ufmF=MutdTO+LgG23Cb0=biR8yQPCg@mail.gmail.com> <20131213113903.GE4360@n2100.arm.linux.org.uk> <CACmBeS3kC4dsdOrfANifgu8oQhLauFKcXhEu=iz8xbUxdhMq_A@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CACmBeS3kC4dsdOrfANifgu8oQhLauFKcXhEu=iz8xbUxdhMq_A@mail.gmail.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
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

What's wrong with:
	tst	\reg, #3
	moveq	pc, \reg
	bx	\reg

rather than ending in an infinite loop?

-- 
FTTC broadband for 0.8mile line: now at 9.7Mbps down 460kbps up... slowly
improving, and getting towards what was expected from it.
