Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752643Ab3LMKog (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 05:44:36 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:18817 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562Ab3LMKoe (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 05:44:34 -0500
X-IronPort-AV: E=Sophos;i="4.95,477,1384300800"; 
   d="scan'208";a="81931598"
Message-ID: <52AAE50F.3000009@citrix.com>
Date: Fri, 13 Dec 2013 10:44:31 +0000
From: David Vrabel <david.vrabel@citrix.com>
User-Agent: Mozilla/5.0 (X11; U; Linux x86_64; en-US; rv:1.9.1.16) Gecko/20121215 Iceowl/1.0b1 Icedove/3.0.11
MIME-Version: 1.0
To: Konrad Rzeszutek Wilk <konrad@kernel.org>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <george.dunlap@eu.citrix.com>, <ian.jackson@eu.citrix.com>,
        <mukesh.rathor@oracle.com>, <tim@xen.org>, <jbeulich@suse.com>,
        <boris.ostrovsky@oracle.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Subject: Re: [PATCH V10 01/14] xen/pvh: Support ParaVirtualized Hardware extensions.
References: <1386900621-27528-1-git-send-email-konrad.wilk@oracle.com> <1386900621-27528-2-git-send-email-konrad.wilk@oracle.com>
In-Reply-To: <1386900621-27528-2-git-send-email-konrad.wilk@oracle.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
X-Originating-IP: [10.80.2.76]
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On 13/12/13 02:10, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> PVH allows PV linux guest to utilize hardware extended capabilities, such
> as running MMU updates in a HVM container.
> 
> This patch allows it to be configured and enabled. Also, basic header file
> changes to add new subcalls to physmap hypercall.
> 
> Lastly, mfn_to_local_pfn must return mfn for paging mode translate
> (since we let the hypervisor - or CPU - do them for us).
[...]
> --- a/arch/x86/include/asm/xen/page.h
> +++ b/arch/x86/include/asm/xen/page.h
> @@ -168,6 +168,9 @@ static inline xpaddr_t machine_to_phys(xmaddr_t machine)
>  static inline unsigned long mfn_to_local_pfn(unsigned long mfn)
>  {
>  	unsigned long pfn = mfn_to_pfn(mfn);
> +
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return mfn;

This does the mfn_to_pfn() call first and then ignores the result.

>  	if (get_phys_to_machine(pfn) != mfn)
>  		return -1; /* force !pfn_valid() */
>  	return pfn;
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index 1a3c765..4d890c3 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -51,3 +51,13 @@ config XEN_DEBUG_FS
>  	  Enable statistics output and various tuning options in debugfs.
>  	  Enabling this option may incur a significant performance overhead.
>  
> +config XEN_X86_PVH
> +	bool "Support for running as a PVH guest (EXPERIMENTAL)"
> +	depends on X86_64 && XEN && EXPERIMENTAL

Drop EXPERIMENTAL here (not in the follow up patch).

> +	default n

default y or don't provide this as a user selectable choice.

> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 7faed58..1a6bca1 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -13,6 +13,15 @@
>  #include <xen/interface/elfnote.h>
>  #include <asm/xen/interface.h>
>  
> +#ifdef CONFIG_XEN_X86_PVH
> +#define FEATURES_PVH "|writable_descriptor_tables" \
> +		     "|auto_translated_physmap" \
> +		     "|supervisor_mode_kernel" \
> +		     "|hvm_callback_vector"
> +#else
> +#define FEATURES_PVH /* Not supported */
> +#endif
> +
>  	__INIT
>  ENTRY(startup_xen)
>  	cld
> @@ -95,7 +104,7 @@ NEXT_HYPERCALL(arch_6)
>  #endif
>  	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
>  	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
> -	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
> +	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb"FEATURES_PVH)
>  	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
>  	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,

Not clear how this can be part of the first patch.  A guest with only
this patch cannot actually work in PVH mode, right?

> diff --git a/include/xen/interface/memory.h b/include/xen/interface/memory.h
> index 2ecfe4f..a122164 100644
> --- a/include/xen/interface/memory.h
> +++ b/include/xen/interface/memory.h
> @@ -175,7 +175,10 @@ struct xen_add_to_physmap {
>      uint16_t    size;
>  
>      /* Source mapping space. */
> -    unsigned int space;
> +    uint16_t space;
> +    domid_t foreign_domid;         /* IFF XENMAPSPACE_gmfn_foreign */
> +
> +#define XENMAPIDX_grant_table_status 0x80000000

What's this change?  It doesn't match the hypervisor.

> --- a/include/xen/interface/physdev.h
> +++ b/include/xen/interface/physdev.h
> @@ -291,6 +291,16 @@ struct physdev_dbgp_op {
>      } u;
>  };
>  
> +#define PHYSDEVOP_map_iomem        30
> +struct physdev_map_iomem {
> +    /* IN */
> +    uint64_t first_gfn;
> +    uint64_t first_mfn;
> +    uint32_t nr_mfns;
> +    uint32_t add_mapping; /* 1 == add mapping;  0 == unmap */
> +
> +};
> +

Not provided by the hypervisor.

David
