Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757886Ab3EVWcf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 May 2013 18:32:35 -0400
Received: from filtteri5.pp.htv.fi ([213.243.153.188]:53535 "EHLO
	filtteri5.pp.htv.fi" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756634Ab3EVWcd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 May 2013 18:32:33 -0400
Date: Thu, 23 May 2013 01:32:25 +0300
From: Aaro Koskinen <aaro.koskinen@iki.fi>
To: David Daney <ddaney.cavm@gmail.com>
Cc: linux-mips@linux-mips.org, ralf@linux-mips.org,
        Linus Torvalds <torvalds@linux-foundation.org>,
        linux-kernel@vger.kernel.org, David Daney <david.daney@cavium.com>,
        Thomas Gleixner <tglx@linutronix.de>, Jonas Gorski <jogo@openwrt.org>
Subject: Re: [PATCH] MIPS: Enable interrupts before WAIT instruction.
Message-ID: <20130522223225.GH31836@blackmetal.musicnaut.iki.fi>
References: <CA+55aFwDGyHOzu=Qh7SJOBK6QvAwAh7pMDL6LfMUE=AW_kapAw@mail.gmail.com>
 <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1367527692-25809-1-git-send-email-ddaney.cavm@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi,

On Thu, May 02, 2013 at 01:48:12PM -0700, David Daney wrote:
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
> 
> Signed-off-by: David Daney <david.daney@cavium.com>
> Reported-by: EunBong Song <eunb.song@samsung.com>
> Cc: Thomas Gleixner <tglx@linutronix.de>
> Cc: Jonas Gorski <jogo@openwrt.org>
> ---
> 
> This is only very lightly tested, we need more testing before
> declaring it the definitive fix.

I wonder what is the status of this patch? Or is there some alternative
fix?

I have Octeon+ board that hangs during 3.10-rc2 boot in spawn_ksoftirqd()
without this. Also, this patch does not apply cleanly to 3.10-rc2
anymore...

A.

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
