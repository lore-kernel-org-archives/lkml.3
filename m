Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757470AbaJIPVH (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 11:21:07 -0400
Received: from e23smtp07.au.ibm.com ([202.81.31.140]:35866 "EHLO
	e23smtp07.au.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757249AbaJIPVC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 11:21:02 -0400
From: "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
To: Michael Neuling <mikey@neuling.org>, greg@kroah.com, arnd@arndb.de,
        mpe@ellerman.id.au, benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au1.ibm.com,
        cbe-oss-dev@lists.ozlabs.org
Subject: Re: [PATCH v4 11/16] powerpc/mm: Add hooks for cxl
In-Reply-To: <1412758505-23495-12-git-send-email-mikey@neuling.org>
References: <1412758505-23495-1-git-send-email-mikey@neuling.org> <1412758505-23495-12-git-send-email-mikey@neuling.org>
User-Agent: Notmuch/0.18.1 (http://notmuchmail.org) Emacs/24.3.91.1 (x86_64-unknown-linux-gnu)
Date: Thu, 09 Oct 2014 20:50:49 +0530
Message-ID: <87wq891d7y.fsf@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14100915-0025-0000-0000-0000004C378F
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Michael Neuling <mikey@neuling.org> writes:

> From: Ian Munsie <imunsie@au1.ibm.com>
>
> This adds hooks into the core powerpc mm code for cxl.
>
> The core powerpc code sometimes uses local tlbie. Unfortunately this won't
> work with the current cxl driver as it relies on snooping tlbie broadcasts.
>
> The cxl hardware can have TLB entries invalidated via MMIO but this is not
> currently supported by the driver. In future we can make local tlbie smarter so
> that it invalidates cxl contexts via MMIO when it needs to but for now we have
> this workaround.
>
> This workaround checks for any active cxl contexts and if so, disables local
> tlbie.
>
> This also adds a hook for when SLBs are invalidated. This ensures any
> corresponding SLBs in cxl are also invalidated at the same time. This is
> required for segment demotion.
>
> Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
> Signed-off-by: Michael Neuling <mikey@neuling.org>
> ---
>  arch/powerpc/mm/copro_fault.c    | 2 ++
>  arch/powerpc/mm/hash_native_64.c | 6 +++++-
>  2 files changed, 7 insertions(+), 1 deletion(-)
>
> diff --git a/arch/powerpc/mm/copro_fault.c b/arch/powerpc/mm/copro_fault.c
> index f2aa5a8..0f9939e 100644
> --- a/arch/powerpc/mm/copro_fault.c
> +++ b/arch/powerpc/mm/copro_fault.c
> @@ -26,6 +26,7 @@
>  #include <asm/reg.h>
>  #include <asm/copro.h>
>  #include <asm/spu.h>
> +#include <misc/cxl.h>
>  
>  /*
>   * This ought to be kept in sync with the powerpc specific do_page_fault
> @@ -143,5 +144,6 @@ void copro_flush_all_slbs(struct mm_struct *mm)
>  #ifdef CONFIG_SPU_BASE
>  	spu_flush_all_slbs(mm);
>  #endif
> +	cxl_slbia(mm);
>  }

If you split this patch into two and move the above hunk in a patch
before "[PATCH v4 09/16] powerpc/mm: Add new hash_page_mm()", it would
make it much easier to follow. We could then update the commit of the
09th patch to carry additional information that talk about how the
hash_page_mm really work as I replied to that patch.


>  EXPORT_SYMBOL_GPL(copro_flush_all_slbs);
> diff --git a/arch/powerpc/mm/hash_native_64.c b/arch/powerpc/mm/hash_native_64.c
> index afc0a82..ae4962a 100644
> --- a/arch/powerpc/mm/hash_native_64.c
> +++ b/arch/powerpc/mm/hash_native_64.c
> @@ -29,6 +29,8 @@
>  #include <asm/kexec.h>
>  #include <asm/ppc-opcode.h>
>  
> +#include <misc/cxl.h>
> +
>  #ifdef DEBUG_LOW
>  #define DBG_LOW(fmt...) udbg_printf(fmt)
>  #else
> @@ -149,9 +151,11 @@ static inline void __tlbiel(unsigned long vpn, int psize, int apsize, int ssize)
>  static inline void tlbie(unsigned long vpn, int psize, int apsize,
>  			 int ssize, int local)
>  {
> -	unsigned int use_local = local && mmu_has_feature(MMU_FTR_TLBIEL);
> +	unsigned int use_local;
>  	int lock_tlbie = !mmu_has_feature(MMU_FTR_LOCKLESS_TLBIE);
>  
> +	use_local = local && mmu_has_feature(MMU_FTR_TLBIEL) && !cxl_ctx_in_use();
> +
>  	if (use_local)
>  		use_local = mmu_psize_defs[psize].tlbiel;
>  	if (lock_tlbie && !use_local)
> -- 
> 1.9.1
>
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

