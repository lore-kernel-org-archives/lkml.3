Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755821Ab3EBVEZ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 2 May 2013 17:04:25 -0400
Received: from www.linutronix.de ([62.245.132.108]:41933 "EHLO
	Galois.linutronix.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754505Ab3EBVEY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 2 May 2013 17:04:24 -0400
Date: Thu, 2 May 2013 23:04:19 +0200 (CEST)
From: Thomas Gleixner <tglx@linutronix.de>
To: David Daney <ddaney.cavm@gmail.com>
cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Jonas Gorski <jogo@openwrt.org>
Subject: Re: [PATCH] MIPS: Enable interrupts before WAIT instruction.
In-Reply-To: <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com>
Message-ID: <alpine.LFD.2.02.1305022303510.2891@ionos>
References: <CA+55aFwDGyHOzu=Qh7SJOBK6QvAwAh7pMDL6LfMUE=AW_kapAw@mail.gmail.com> <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Alpine 2.02 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
X-Linutronix-Spam-Score: -1.0
X-Linutronix-Spam-Level: -
X-Linutronix-Spam-Status: No , -1.0 points, 5.0 required,  ALL_TRUSTED=-1,SHORTCIRCUIT=-0.0001
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org



On Thu, 2 May 2013, David Daney wrote:

> From: David Daney <david.daney@cavium.com>
> 
> As noted by Thomas Gleixner:
> 
>    commit cdbedc61c8 (mips: Use generic idle loop) broke MIPS as I did
>    not realize that MIPS wants to invoke the wait instructions with
>    interrupts enabled.
> 
> Instead of enabling interrupts in arch_cpu_idle() as Thomas' initial
> patch does, we follow Linus' suggestion of doing it in the assembly
> code to prevent the compiler from rearranging things.

Yeah, that looks way more sane.

 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Reported-by: EunBong Song <eunb.song@samsung.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jonas Gorski <jogo@openwrt.org>
> ---
> 
> This is only very lightly tested, we need more testing before
> declaring it the definitive fix.
> 
>  arch/mips/kernel/genex.S | 7 ++++---
>  1 file changed, 4 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/mips/kernel/genex.S b/arch/mips/kernel/genex.S
> index ecb347c..57cda9a 100644
> --- a/arch/mips/kernel/genex.S
> +++ b/arch/mips/kernel/genex.S
> @@ -132,12 +132,13 @@ LEAF(r4k_wait)
>  	.set	noreorder
>  	/* start of rollback region */
>  	LONG_L	t0, TI_FLAGS($28)
> -	nop
>  	andi	t0, _TIF_NEED_RESCHED
>  	bnez	t0, 1f
>  	 nop
> -	nop
> -	nop
> +	/* Enable interrupts so WAIT will complete */
> +	mfc0	t0, CP0_STATUS
> +	ori	t0, ST0_IE
> +	mtc0	t0, CP0_STATUS
>  	.set	mips3
>  	wait
>  	/* end of rollback region (the region size must be power of two) */
> -- 
> 1.7.11.7
> 
> 
