Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967822Ab3HJQzp (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 12:55:45 -0400
Received: from cantor2.suse.de ([195.135.220.15]:39247 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S966710Ab3HJQzo (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 12:55:44 -0400
Date: Sat, 10 Aug 2013 18:55:39 +0200 (CEST)
From: Jiri Kosina <jkosina@suse.cz>
To: Tony Lu <zlu@tilera.com>
Cc: linux-kernel@vger.kernel.org
Subject: Re: [PATCH] tile: support ASLR fully
In-Reply-To: <201308091951.r79JppCI030998@farm-0021.internal.tilera.com>
Message-ID: <alpine.LNX.2.00.1308101849350.32627@pobox.suse.cz>
References: <201308091951.r79JppCI030998@farm-0021.internal.tilera.com>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 9 Aug 2013, Tony Lu wrote:

> With this change, tile Linux now supports address-space layout
> randomization for shared objects, stack, heap and vdso.
> 
> Signed-off-by: Tony Lu <zlu@tilera.com>
> Signed-off-by: Chris Metcalf <cmetcalf@tilera.com>
> ---
>  arch/tile/include/asm/elf.h |  4 ++++
>  arch/tile/mm/mmap.c         | 20 ++++++++++++++++++--
>  2 files changed, 22 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/tile/include/asm/elf.h b/arch/tile/include/asm/elf.h
> index 31d854f..e1da88e 100644
> --- a/arch/tile/include/asm/elf.h
> +++ b/arch/tile/include/asm/elf.h
> @@ -137,6 +137,10 @@ do { \
>  	NEW_AUX_ENT(AT_SYSINFO_EHDR, VDSO_BASE); \
>  } while (0)
>  
> +struct mm_struct;
> +extern unsigned long arch_randomize_brk(struct mm_struct *mm);
> +#define arch_randomize_brk arch_randomize_brk
> +
>  #ifdef CONFIG_COMPAT
>  
>  #define COMPAT_ELF_PLATFORM "tilegx-m32"
> diff --git a/arch/tile/mm/mmap.c b/arch/tile/mm/mmap.c
> index d67d91e..b3686ce 100644
> --- a/arch/tile/mm/mmap.c
> +++ b/arch/tile/mm/mmap.c
> @@ -58,16 +58,32 @@ void arch_pick_mmap_layout(struct mm_struct *mm)
>  #else
>  	int is_32bit = 0;
>  #endif
> +	unsigned long random_factor = 0UL;
> +
> +	if (current->flags & PF_RANDOMIZE) {
> +		random_factor = get_random_int();
> +		random_factor = random_factor << PAGE_SHIFT;
> +		if (is_32bit)
> +			random_factor &= 0xfffffful;
> +		else
> +			random_factor &= 0xffffffful;
> +	}

Hi Tony,

to me, the used math seems not to be immediatley understandable on a first 
sight. Instead of using full range of get_random_int() and then clamping 
it by anding with 0xffffffUL or fffffffUL, how about just using 
appropriate division reminder to the result of get_random_int()? (for 
inspiration and for understanding of what I mean, please see what 
mmap_rnd() is doing on x86).

>  
>  	/*
>  	 * Use standard layout if the expected stack growth is unlimited
>  	 * or we are running native 64 bits.
>  	 */
> -	if (!is_32bit || rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
> -		mm->mmap_base = TASK_UNMAPPED_BASE;
> +	if (rlimit(RLIMIT_STACK) == RLIM_INFINITY) {
> +		mm->mmap_base = TASK_UNMAPPED_BASE + random_factor;
>  		mm->get_unmapped_area = arch_get_unmapped_area;
>  	} else {
>  		mm->mmap_base = mmap_base(mm);
>  		mm->get_unmapped_area = arch_get_unmapped_area_topdown;
>  	}
>  }
> +
> +unsigned long arch_randomize_brk(struct mm_struct *mm)
> +{
> +	unsigned long range_end = mm->brk + 0x02000000;
> +	return randomize_range(mm->brk, range_end, 0) ? : mm->brk;
> +}

Otherwise the patch looks good to me, so once you either add some 
explanatory comment to the get_random_int() math, or convert it to use 
division reminder, I'll be happy to Ack it.

Thanks,

-- 
Jiri Kosina
SUSE Labs
