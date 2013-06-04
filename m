Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751546Ab3FDJUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 05:20:54 -0400
Received: from smtp.eu.citrix.com ([46.33.159.39]:44080 "EHLO
	SMTP.EU.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750972Ab3FDJUw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 05:20:52 -0400
X-IronPort-AV: E=Sophos;i="4.87,798,1363132800"; 
   d="scan'208";a="5292202"
Message-ID: <1370337650.24512.88.camel@zakaz.uk.xensource.com>
Subject: Re: [PATCH v2 1/5] arm/xen: define xen_remap as ioremap_cached
From: Ian Campbell <Ian.Campbell@citrix.com>
To: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
CC: <linux-arm-kernel@lists.infradead.org>, <linux-kernel@vger.kernel.org>,
        <xen-devel@lists.xensource.com>, <will.deacon@arm.com>,
        <catalin.marinas@arm.com>, <konrad.wilk@oracle.com>
Date: Tue, 4 Jun 2013 10:20:50 +0100
In-Reply-To: <1370273624-26976-1-git-send-email-stefano.stabellini@eu.citrix.com>
References: <alpine.DEB.2.02.1306031157020.4589@kaball.uk.xensource.com>
	 <1370273624-26976-1-git-send-email-stefano.stabellini@eu.citrix.com>
Organization: Citrix Systems, Inc.
Content-Type: text/plain; charset="UTF-8"
X-Mailer: Evolution 3.4.4-1 
MIME-Version: 1.0
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.30.203.1]
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 2013-06-03 at 16:33 +0100, Stefano Stabellini wrote:
> Define xen_remap as ioremap_cache (MT_MEMORY and MT_DEVICE_CACHED end up
> having the same AttrIndx encoding).

The entries in static struct mem_type mem_types[] look entirely
different to me.  What am I missing?
	[MT_DEVICE_CACHED] = {	  /* ioremap_cached */
		.prot_pte	= PROT_PTE_DEVICE | L_PTE_MT_DEV_CACHED,
		.prot_l1	= PMD_TYPE_TABLE,
		.prot_sect	= PROT_SECT_DEVICE | PMD_SECT_WB,
		.domain		= DOMAIN_IO,
	},
	[MT_MEMORY] = {
		.prot_pte  = L_PTE_PRESENT | L_PTE_YOUNG | L_PTE_DIRTY,
		.prot_l1   = PMD_TYPE_TABLE,
		.prot_sect = PMD_TYPE_SECT | PMD_SECT_AP_WRITE,
		.domain    = DOMAIN_KERNEL,
	},

I can see in pgtable-3level.h how L_PTE_MT_DEV_CACHED and
L_PTE_MT_WRITEBACK are the same but not where the MT_WRITEBACK comes
from for MT_MEMORY. Things are less clear in pgtable-2level.h, where one
is 0x3 and the other is 0xb. I can see that the entries are the same in
armv6_mt_table but how that would apply to a v7 processor?

Anyhow, even if I'm prepared to believe that MT_MEMORY and
MT_DEVICE_CACHED end up being the same thing (which TBH I am) it seems
that the level of abstraction involved makes us vulnerable to future
changes subtly breaking things for us. What about:

        /* Device shared memory */
        #define ioremap_shm(cookie,size)		__arm_ioremap((cookie), (size), MT_MEMORY)

Ian.

> Remove include asm/mach/map.h, not unneeded.
> 
> Signed-off-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
> ---
>  arch/arm/include/asm/xen/page.h |    3 +--
>  1 files changed, 1 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/arm/include/asm/xen/page.h b/arch/arm/include/asm/xen/page.h
> index 30cdacb..359a7b5 100644
> --- a/arch/arm/include/asm/xen/page.h
> +++ b/arch/arm/include/asm/xen/page.h
> @@ -1,7 +1,6 @@
>  #ifndef _ASM_ARM_XEN_PAGE_H
>  #define _ASM_ARM_XEN_PAGE_H
>  
> -#include <asm/mach/map.h>
>  #include <asm/page.h>
>  #include <asm/pgtable.h>
>  
> @@ -88,6 +87,6 @@ static inline bool set_phys_to_machine(unsigned long pfn, unsigned long mfn)
>  	return __set_phys_to_machine(pfn, mfn);
>  }
>  
> -#define xen_remap(cookie, size) __arm_ioremap((cookie), (size), MT_MEMORY);
> +#define xen_remap(cookie, size) ioremap_cached((cookie), (size));
>  
>  #endif /* _ASM_ARM_XEN_PAGE_H */


