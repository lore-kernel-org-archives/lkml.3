Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754595Ab3GOIrn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 04:47:43 -0400
Received: from gate.crashing.org ([63.228.1.57]:47566 "EHLO gate.crashing.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754103Ab3GOIrl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 04:47:41 -0400
Message-ID: <1373878026.19894.335.camel@pasglop>
Subject: Re: [PATCH] module: ppc64 module CRC relocation fix causes perf
 issues
From: Benjamin Herrenschmidt <benh@kernel.crashing.org>
To: Scott Wood <scottwood@freescale.com>
Cc: Paul Mackerras <paulus@samba.org>, Rusty Russell <rusty@rustcorp.com.au>,
        Neil Horman <nhorman@tuxdriver.com>, linuxppc-dev@lists.ozlabs.org,
        linux-kernel@vger.kernel.org, Anton Blanchard <anton@samba.org>
Date: Mon, 15 Jul 2013 18:47:06 +1000
In-Reply-To: <20130715140450.573aab15@kryten>
References: <20130715140450.573aab15@kryten>
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.6.4-0ubuntu1 
Mime-Version: 1.0
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-07-15 at 14:04 +1000, Anton Blanchard wrote:
> Module CRCs are implemented as absolute symbols that get resolved by
> a linker script. We build an intermediate .o that contains an
> unresolved symbol for each CRC. genksysms parses this .o, calculates
> the CRCs and writes a linker script that "resolves" the symbols to
> the calc

Scott, can somebody from FSL test that on 32-bit and Ack it ?

Thanks !

Cheers,
Ben.

> Unfortunately the ppc64 relocatable kernel sees these CRCs as symbols
> that need relocating and relocates them at boot. Commit d4703aef
> (module: handle ppc64 relocating kcrctabs when CONFIG_RELOCATABLE=y)
> added a hook to reverse the bogus relocations. Part of this patch
> created a symbol at 0x0:
> 
> # head -2 /proc/kallsyms 
> 0000000000000000 T reloc_start
> c000000000000000 T .__start
> 
> This reloc_start symbol is causing lots of confusion to perf. It
> thinks reloc_start is a massive function that stretches from 0x0 to
> 0xc000000000000000 and we get various cryptic errors out of perf,
> including:
> 
> problem incrementing symbol count, skipping event
> 
> This patch removes the  reloc_start linker script label and instead
> defines it as PHYSICAL_START. We also need to wrap it with
> CONFIG_PPC64 because the ppc32 kernel can set a non zero
> PHYSICAL_START at compile time and we wouldn't want to subtract
> it from the CRCs in that case.
> 
> Signed-off-by: Anton Blanchard <anton@samba.org>
> Cc: <stable@kernel.org>
> ---
> 
> This bug was originally reported on Fedora 19 (3.9.x), so I've marked
> it for stable.
> 
> Index: b/arch/powerpc/include/asm/module.h
> ===================================================================
> --- a/arch/powerpc/include/asm/module.h
> +++ b/arch/powerpc/include/asm/module.h
> @@ -82,10 +82,9 @@ struct exception_table_entry;
>  void sort_ex_table(struct exception_table_entry *start,
>  		   struct exception_table_entry *finish);
>  
> -#ifdef CONFIG_MODVERSIONS
> +#if defined(CONFIG_MODVERSIONS) && defined(CONFIG_PPC64)
>  #define ARCH_RELOCATES_KCRCTAB
> -
> -extern const unsigned long reloc_start[];
> +#define reloc_start PHYSICAL_START
>  #endif
>  #endif /* __KERNEL__ */
>  #endif	/* _ASM_POWERPC_MODULE_H */
> Index: b/arch/powerpc/kernel/vmlinux.lds.S
> ===================================================================
> --- a/arch/powerpc/kernel/vmlinux.lds.S
> +++ b/arch/powerpc/kernel/vmlinux.lds.S
> @@ -38,9 +38,6 @@ jiffies = jiffies_64 + 4;
>  #endif
>  SECTIONS
>  {
> -	. = 0;
> -	reloc_start = .;
> -
>  	. = KERNELBASE;
>  
>  /*


