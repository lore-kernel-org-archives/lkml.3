Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754935Ab3LROkd (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 09:40:33 -0500
Received: from smtp02.citrix.com ([66.165.176.63]:15125 "EHLO
	SMTP02.CITRIX.COM" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754679Ab3LROkc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 09:40:32 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="83506779"
Date: Wed, 18 Dec 2013 14:39:35 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 04/12] xen/pvh: Don't setup P2M tree.
In-Reply-To: <1387313503-31362-5-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181428340.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-5-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> P2M is not available for PVH. Fortunatly for us the
> P2M code already has mostly the support for auto-xlat guest thanks to
> commit 3d24bbd7dddbea54358a9795abaf051b0f18973c
> "grant-table: call set_phys_to_machine after mapping grant refs"
> which: "
> introduces set_phys_to_machine calls for auto_translated guests
> (even on x86) in gnttab_map_refs and gnttab_unmap_refs.
> translated by swiotlb-xen... " so we don't need to muck much.

Just a note: with 3d24bbd7dddbea54358a9795abaf051b0f18973c you'll get
set_phys_to_machine calls from gnttab_map_refs and gnttab_unmap_refs but
PVH guests won't do anything with them.

If we assume that an IOMMU is always present on the plaform and Xen is
going to make the appropriate IOMMU pagetable changes in the hypercall
implementation of GNTTABOP_map_grant_ref and GNTTABOP_unmap_grant_ref,
then eveything should be transparent from PVH Dom0 point of view and DMA
transfers involving foreign pages keep working with no issies. 

Otherwise we do need a P2M (and an M2P) for PVH Dom0 to track these
foreign pages: on ARM I introduced two redblack trees to do it (see
arch/arm/xen/p2m.c).



> But we still have to inhibit the building of the P2M tree.
> That had been done in the past by not calling
> xen_build_dynamic_phys_to_machine (which setups the P2M tree
> and gives us virtual address to access them). But we are missing
> a check for xen_build_mfn_list_list - which was continuing to setup
> the P2M tree and would blow up at trying to get the virtual
> address of p2m_missing (which would have been setup by
> xen_build_dynamic_phys_to_machine).
> 
> Hence a check is needed to not call xen_build_mfn_list_list when
> running in auto-xlat mode.
> 
> Instead of replicating the check for auto-xlat in enlighten.c
> do it in the p2m.c code. The reason is that the xen_build_mfn_list_list
> is called also in xen_arch_post_suspend without any checks for
> auto-xlat. So for PVH or PV with auto-xlat - we would needlessly
> allocate space for an P2M tree.
> 
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/enlighten.c |  3 +--
>  arch/x86/xen/p2m.c       | 12 ++++++++++--
>  2 files changed, 11 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/xen/enlighten.c b/arch/x86/xen/enlighten.c
> index 3b21c82..c7341d0 100644
> --- a/arch/x86/xen/enlighten.c
> +++ b/arch/x86/xen/enlighten.c
> @@ -1493,8 +1493,7 @@ asmlinkage void __init xen_start_kernel(void)
>  	x86_configure_nx();
>  
>  	/* Get mfn list */
> -	if (!xen_feature(XENFEAT_auto_translated_physmap))
> -		xen_build_dynamic_phys_to_machine();
> +	xen_build_dynamic_phys_to_machine();
>  
>  	/*
>  	 * Set up kernel GDT and segment registers, mainly so that
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 2ae8699..fb7ee0a 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -280,6 +280,9 @@ void __ref xen_build_mfn_list_list(void)
>  {
>  	unsigned long pfn;
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>  	/* Pre-initialize p2m_top_mfn to be completely missing */
>  	if (p2m_top_mfn == NULL) {
>  		p2m_mid_missing_mfn = extend_brk(PAGE_SIZE, PAGE_SIZE);
> @@ -346,10 +349,15 @@ void xen_setup_mfn_list_list(void)
>  /* Set up p2m_top to point to the domain-builder provided p2m pages */
>  void __init xen_build_dynamic_phys_to_machine(void)
>  {
> -	unsigned long *mfn_list = (unsigned long *)xen_start_info->mfn_list;
> -	unsigned long max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
> +	unsigned long *mfn_list;
> +	unsigned long max_pfn;
>  	unsigned long pfn;
>  
> +	 if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
> +	mfn_list = (unsigned long *)xen_start_info->mfn_list;
> +	max_pfn = min(MAX_DOMAIN_PAGES, xen_start_info->nr_pages);
>  	xen_max_p2m_pfn = max_pfn;
>  
>  	p2m_missing = extend_brk(PAGE_SIZE, PAGE_SIZE);
> -- 
> 1.8.3.1
> 
> 
> _______________________________________________
> Xen-devel mailing list
> Xen-devel@lists.xen.org
> http://lists.xen.org/xen-devel
> 
