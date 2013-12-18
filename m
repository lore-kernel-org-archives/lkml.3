Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755143Ab3LROx0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:53:26 -0500
Received: from smtp.citrix.com ([66.165.176.89]:34351 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755124Ab3LROxZ (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:53:25 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85760150"
Date: Wed, 18 Dec 2013 14:52:51 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 12/12] xen/pvh: Support ParaVirtualized
 Hardware extensions.
In-Reply-To: <1387313503-31362-13-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181452400.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-13-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> PVH allows PV linux guest to utilize hardware extended capabilities,
> such as running MMU updates in a HVM container.
> 
> The Xen side defines PVH as (from docs/misc/pvh-readme.txt,
> with modifications):
> 
> "* the guest uses auto translate:
>  - p2m is managed by Xen
>  - pagetables are owned by the guest
>  - mmu_update hypercall not available
> * it uses event callback and not vlapic emulation,
> * IDT is native, so set_trap_table hcall is also N/A for a PVH guest.
> 
> For a full list of hcalls supported for PVH, see pvh_hypercall64_table
> in arch/x86/hvm/hvm.c in xen.  From the ABI prespective, it's mostly a
> PV guest with auto translate, although it does use hvm_op for setting
> callback vector."
> 
> Use .ascii and .asciz to define xen feature string. Note, the PVH
> string must be in a single line (not multiple lines with \) to keep the
> assembler from putting null char after each string before \.
> This patch allows it to be configured and enabled.
> 
> Lastly remove some of the scaffolding.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>

Acked-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/Kconfig    | 8 ++++++++
>  arch/x86/xen/xen-head.S | 8 +++++++-
>  include/xen/xen.h       | 3 +--
>  3 files changed, 16 insertions(+), 3 deletions(-)
> 
> diff --git a/arch/x86/xen/Kconfig b/arch/x86/xen/Kconfig
> index 1a3c765..161cc34 100644
> --- a/arch/x86/xen/Kconfig
> +++ b/arch/x86/xen/Kconfig
> @@ -51,3 +51,11 @@ config XEN_DEBUG_FS
>  	  Enable statistics output and various tuning options in debugfs.
>  	  Enabling this option may incur a significant performance overhead.
>  
> +config XEN_PVH
> +	bool "Support for running as a PVH guest"
> +	depends on X86_64 && XEN && XEN_PVHVM
> +	default n
> +	help
> +	   This option enables support for running as a PVH guest (PV guest
> +	   using hardware extensions) under a suitably capable hypervisor.
> +	   If unsure, say N.
> diff --git a/arch/x86/xen/xen-head.S b/arch/x86/xen/xen-head.S
> index 7faed58..56f42c0 100644
> --- a/arch/x86/xen/xen-head.S
> +++ b/arch/x86/xen/xen-head.S
> @@ -13,6 +13,12 @@
>  #include <xen/interface/elfnote.h>
>  #include <asm/xen/interface.h>
>  
> +#ifdef CONFIG_XEN_PVH
> +#define PVH_FEATURES_STR  "|writable_descriptor_tables|auto_translated_physmap|supervisor_mode_kernel|hvm_callback_vector"
> +#else
> +#define PVH_FEATURES_STR  ""
> +#endif
> +
>  	__INIT
>  ENTRY(startup_xen)
>  	cld
> @@ -95,7 +101,7 @@ NEXT_HYPERCALL(arch_6)
>  #endif
>  	ELFNOTE(Xen, XEN_ELFNOTE_ENTRY,          _ASM_PTR startup_xen)
>  	ELFNOTE(Xen, XEN_ELFNOTE_HYPERCALL_PAGE, _ASM_PTR hypercall_page)
> -	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .asciz "!writable_page_tables|pae_pgdir_above_4gb")
> +	ELFNOTE(Xen, XEN_ELFNOTE_FEATURES,       .ascii "!writable_page_tables|pae_pgdir_above_4gb"; .asciz PVH_FEATURES_STR)
>  	ELFNOTE(Xen, XEN_ELFNOTE_PAE_MODE,       .asciz "yes")
>  	ELFNOTE(Xen, XEN_ELFNOTE_LOADER,         .asciz "generic")
>  	ELFNOTE(Xen, XEN_ELFNOTE_L1_MFN_VALID,
> diff --git a/include/xen/xen.h b/include/xen/xen.h
> index 1d6a237..a248002 100644
> --- a/include/xen/xen.h
> +++ b/include/xen/xen.h
> @@ -29,8 +29,7 @@ extern enum xen_domain_type xen_domain_type;
>  #define xen_initial_domain()	(0)
>  #endif	/* CONFIG_XEN_DOM0 */
>  
> -#ifdef CONFIG_XEN_PVHVM
> -/* Temporarily under XEN_PVHVM, but will be under CONFIG_XEN_PVH */
> +#ifdef CONFIG_XEN_PVH
>  #include <xen/features.h>
>  #define xen_pvh_domain() (xen_pv_domain() && \
>  			  xen_feature(XENFEAT_auto_translated_physmap) && \
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
