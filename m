Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752563Ab3BIJle (ORCPT <rfc822;w@1wt.eu>);
	Sat, 9 Feb 2013 04:41:34 -0500
Received: from mail.skyhub.de ([78.46.96.112]:45924 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752403Ab3BIJla (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 9 Feb 2013 04:41:30 -0500
Date: Sat, 9 Feb 2013 10:41:21 +0100
From: Borislav Petkov <bp@alien8.de>
To: Dave Hansen <dave@linux.vnet.ibm.com>
Cc: linux-kernel@vger.kernel.org, linux-mm@kvack.org, hpa@zytor.com,
        mingo@kernel.org, tglx@linutronix.de
Subject: Re: [PATCH 1/2] add helper for highmem checks
Message-ID: <20130209094121.GB17728@pd.tnic>
Mail-Followup-To: Borislav Petkov <bp@alien8.de>,
	Dave Hansen <dave@linux.vnet.ibm.com>, linux-kernel@vger.kernel.org,
	linux-mm@kvack.org, hpa@zytor.com, mingo@kernel.org,
	tglx@linutronix.de
References: <20130208202813.62965F25@kernel.stglabs.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
In-Reply-To: <20130208202813.62965F25@kernel.stglabs.ibm.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Feb 08, 2013 at 12:28:13PM -0800, Dave Hansen wrote:
> 
> Boris, could you check that this series also fixes the /dev/mem
> problem you were seeing?
> 
> --
> 
> We have a new debugging check on x86 that has caught a number
> of long-standing bugs.  However, there is a _bit_ of collateral
> damage with things that call __pa(high_memory).
> 
> We are now checking that any addresses passed to __pa() are
> *valid* and can be dereferenced.
> 
> "high_memory", however, is not valid.  It marks the start of
> highmem, and isn't itself a valid pointer.  But, those users
> are really just asking "is this vaddr mapped"?  So, give them
> a helper that does that, plus is also kind to our new
> debugging check.
> 
> 
> Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
> ---
> 
>  linux-2.6.git-dave/arch/x86/mm/pat.c     |   11 ++++++-----
>  linux-2.6.git-dave/drivers/char/mem.c    |    4 ++--
>  linux-2.6.git-dave/drivers/mtd/mtdchar.c |    2 +-
>  linux-2.6.git-dave/include/linux/mm.h    |   13 +++++++++++++
>  4 files changed, 22 insertions(+), 8 deletions(-)
> 
> diff -puN drivers/char/mem.c~clean-up-highmem-checks drivers/char/mem.c
> --- linux-2.6.git/drivers/char/mem.c~clean-up-highmem-checks	2013-02-08 08:42:37.291222110 -0800
> +++ linux-2.6.git-dave/drivers/char/mem.c	2013-02-08 12:27:27.837477867 -0800
> @@ -51,7 +51,7 @@ static inline unsigned long size_inside_
>  #ifndef ARCH_HAS_VALID_PHYS_ADDR_RANGE
>  static inline int valid_phys_addr_range(phys_addr_t addr, size_t count)
>  {
> -	return addr + count <= __pa(high_memory);
> +	return !phys_addr_is_highmem(addr + count);
>  }
>  
>  static inline int valid_mmap_phys_addr_range(unsigned long pfn, size_t size)
> @@ -250,7 +250,7 @@ static int uncached_access(struct file *
>  	 */
>  	if (file->f_flags & O_DSYNC)
>  		return 1;
> -	return addr >= __pa(high_memory);
> +	return phys_addr_is_highmem(addr);
>  #endif
>  }
>  #endif
> diff -puN include/linux/mm.h~clean-up-highmem-checks include/linux/mm.h
> --- linux-2.6.git/include/linux/mm.h~clean-up-highmem-checks	2013-02-08 08:42:37.295222148 -0800
> +++ linux-2.6.git-dave/include/linux/mm.h	2013-02-08 09:01:49.758254468 -0800
> @@ -1771,5 +1771,18 @@ static inline unsigned int debug_guardpa
>  static inline bool page_is_guard(struct page *page) { return false; }
>  #endif /* CONFIG_DEBUG_PAGEALLOC */
>  
> +static inline phys_addr_t last_lowmem_phys_addr(void)
> +{
> +	/*
> +	 * 'high_memory' is not a pointer that can be dereferenced, so
> +	 * avoid calling __pa() on it directly.
> +	 */
> +	return __pa(high_memory - 1);
> +}
> +static inline bool phys_addr_is_highmem(phys_addr_t addr)
> +{
> +	return addr > last_lowmem_paddr();

I think you mean last_lowmem_phys_addr() here:

include/linux/mm.h: In function ‘phys_addr_is_highmem’:
include/linux/mm.h:1764:2: error: implicit declaration of function ‘last_lowmem_paddr’ [-Werror=implicit-function-declaration]
cc1: some warnings being treated as errors
make[1]: *** [arch/x86/kernel/asm-offsets.s] Error 1

Changed.

-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
