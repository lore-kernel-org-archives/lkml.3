Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933978Ab3EGAA7 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 20:00:59 -0400
Received: from mail-pd0-f176.google.com ([209.85.192.176]:61988 "EHLO
	mail-pd0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933184Ab3EGAAz (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 20:00:55 -0400
Date: Mon, 6 May 2013 17:00:39 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Catalin Marinas <catalin.marinas@arm.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Russell King <rmk+kernel@arm.linux.org.uk>
Subject: Re: [ 067/115] ARM: 7702/1: Set the page table freeing ceiling to
 TASK_SIZE
In-Reply-To: <20130506203102.410919957@linuxfoundation.org>
Message-ID: <alpine.LNX.2.00.1305061628480.4387@eggly.anvils>
References: <20130506203055.537199268@linuxfoundation.org> <20130506203102.410919957@linuxfoundation.org>
User-Agent: Alpine 2.00 (LNX 1167 2008-08-23)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 6 May 2013, Greg Kroah-Hartman wrote:

> 3.9-stable review patch.  If anyone has any objections, please let me know.

NAK to 067/115 for 3.9, 063/104 for 3.8 and 38/63 for 3.4: they duplicate
       036/115 for 3.9, 034/104 for 3.8 and 16/63 for 3.4.

Commit 6aaa189f8712471a250bfdf8fc8d08277258b8ab upstream is a duplicate of
commit 104ad3b32d7a71941c8ab2dee78eea38e8a23309 upstream; but whereas git
resolves the duplication in Linus's tree, they show up as a repeated
definition block in patch-3.9.1-rc1.

Why choose the Signed-off-by akpm version over the Signed-off-by rmk
version?  No strong reason, and no disrespect to rmk: only because
036/115 etc pair with 057/115 etc, and rmk's version of that already
failed to apply in your tree because akpm's version got in first.

Hugh

> 
> ------------------
> 
> From: Catalin Marinas <catalin.marinas@arm.com>
> 
> commit 6aaa189f8712471a250bfdf8fc8d08277258b8ab upstream.
> 
> ARM processors with LPAE enabled use 3 levels of page tables, with an
> entry in the top level (pgd) covering 1GB of virtual space. Because of
> the branch relocation limitations on ARM, the loadable modules are
> mapped 16MB below PAGE_OFFSET, making the corresponding 1GB pgd shared
> between kernel modules and user space.
> 
> If free_pgtables() is called with the default ceiling 0,
> free_pgd_range() (and subsequently called functions) also frees the page
> table shared between user space and kernel modules (which is normally
> handled by the ARM-specific pgd_free() function). This patch changes
> defines the ARM USER_PGTABLES_CEILING to TASK_SIZE when CONFIG_ARM_LPAE
> is enabled.
> 
> Note that the pgd_free() function already checks the presence of the
> shared pmd page allocated by pgd_alloc() and frees it, though with
> ceiling 0 this wasn't necessary.
> 
> Signed-off-by: Catalin Marinas <catalin.marinas@arm.com>
> Cc: Hugh Dickins <hughd@google.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Russell King <rmk+kernel@arm.linux.org.uk>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  arch/arm/include/asm/pgtable.h |    9 +++++++++
>  1 file changed, 9 insertions(+)
> 
> --- a/arch/arm/include/asm/pgtable.h
> +++ b/arch/arm/include/asm/pgtable.h
> @@ -70,6 +70,15 @@ extern void __pgd_error(const char *file
>  #endif
>  
>  /*
> + * Use TASK_SIZE as the ceiling argument for free_pgtables() and
> + * free_pgd_range() to avoid freeing the modules pmd when LPAE is enabled (pmd
> + * page shared between user and kernel).
> + */
> +#ifdef CONFIG_ARM_LPAE
> +#define USER_PGTABLES_CEILING	TASK_SIZE
> +#endif
> +
> +/*
>   * The pgprot_* and protection_map entries will be fixed up in runtime
>   * to include the cachable and bufferable bits based on memory policy,
>   * as well as any architecture dependent bits like global/ASID and SMP
