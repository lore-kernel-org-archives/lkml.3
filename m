Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754924AbaENK2g (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 06:28:36 -0400
Received: from mout.kundenserver.de ([212.227.17.13]:64863 "EHLO
	mout.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754332AbaENK2e (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 06:28:34 -0400
From: Arnd Bergmann <arnd@arndb.de>
To: linux-arm-kernel@lists.infradead.org
Cc: Paul Bolle <pebolle@tiscali.nl>, Russell King <linux@arm.linux.org.uk>,
        linux-kernel@vger.kernel.org
Subject: Re: [PATCH] ARM: remove check for CONFIG_DEBUG_LL_SER3
Date: Wed, 14 May 2014 12:28:25 +0200
Message-ID: <4192716.enNWAQ0hz5@wuerfel>
User-Agent: KMail/4.11.5 (Linux/3.11.0-18-generic; KDE/4.11.5; x86_64; ; )
In-Reply-To: <1400055127.31197.1.camel@x220>
References: <1400055127.31197.1.camel@x220>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
X-Provags-ID: V02:K0:Ee2ZkE8NwsBdq+DOUMXtvP+GSXTleROhFz4qYcC5VXT
 q/AOgwrg8+xEunNkT2QYe5ZEPvj4nAQT/1YdiDbJhQnfUzLovD
 BotiqbobiiWF+Uh5xh7aubx9tbE7YnJQobCZlK8uXXopSZF2XG
 BzV81+fOdyg49KZrwxh6+7MTaowG5oXFIfMfU6vnaZbbFTNe4I
 MHIONc4f1uafisOoHuC9pDPUdzw0Ja8NRE6TdprSQiXmbJbXC2
 tlIiLdnVjVyEpxiIZ/eqUicOqGeJDFYH0Wo6AdFfdGBu+xcby3
 hTiOxguk6f7x/lVcnR4iEXQqObzwuzbDOA47mGlUmhNJgENT4y
 2jazqSoAiDhbAU3XDVuo=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wednesday 14 May 2014 10:12:07 Paul Bolle wrote:
>  #if defined(CONFIG_ARCH_SA1100)
>                 .macro  loadsp, rb, tmp
>                 mov     \rb, #0x80000000        @ physical base address
> -#ifdef CONFIG_DEBUG_LL_SER3
> -               add     \rb, \rb, #0x00050000   @ Ser3
> -#else
>                 add     \rb, \rb, #0x00010000   @ Ser1
> -#endif
>                 .endm
>  #elif defined(CONFIG_ARCH_S3C24XX)
>                 .macro loadsp, rb, tmp

I wonder if the entire CONFIG_ARCH_SA1100 section here is actually needed
at all, or if it should just use the #else path that calls addruart, which
is defined as

                .macro  addruart, rp, rv, tmp
                mrc     p15, 0, \rp, c1, c0
                tst     \rp, #1                 @ MMU enabled?
                moveq   \rp, #0x80000000        @ physical base address
                movne   \rp, #0xf8000000        @ virtual address

                @ We probe for the active serial port here, coherently with
                @ the comment in arch/arm/mach-sa1100/include/mach/uncompress.h.
                @ We assume r1 can be clobbered.

                @ see if Ser3 is active
                add     \rp, \rp, #0x00050000
                ldr     \rv, [\rp, #UTCR3]
                tst     \rv, #UTCR3_TXE

                @ if Ser3 is inactive, then try Ser1
                addeq   \rp, \rp, #(0x00010000 - 0x00050000)
                ldreq   \rv, [\rp, #UTCR3]
                tsteq   \rv, #UTCR3_TXE

                @ if Ser1 is inactive, then try Ser2
                addeq   \rp, \rp, #(0x00030000 - 0x00010000)
                ldreq   \rv, [\rp, #UTCR3]
                tsteq   \rv, #UTCR3_TXE

                @ clear top bits, and generate both phys and virt addresses
                lsl     \rp, \rp, #8
                lsr     \rp, \rp, #8
                orr     \rv, \rp, #0xf8000000   @ virtual
                orr     \rp, \rp, #0x80000000   @ physical

                .endm


There is a CONFIG_ARCH_S3C24XX case just below it, and I'm pretty
sure that one can be removed, because the loadsp implementation
for s3c24xx is basically the same as the addruart code.

Russell removed most of the other cases in 5cd0c3442021 "ARM:
decompressor: use platform debug macros", but I can't find an
explanation for why s3c24xx, sa1100 and iop331 were left at the
time.

	Arnd
