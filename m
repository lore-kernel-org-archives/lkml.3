Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755544Ab3LRS0B (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 13:26:01 -0500
Received: from smtp.citrix.com ([66.165.176.89]:44179 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750815Ab3LRS0A (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 13:26:00 -0500
X-IronPort-AV: E=Sophos;i="4.95,508,1384300800"; 
   d="scan'208";a="85857583"
Date: Wed, 18 Dec 2013 18:25:15 +0000
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
CC: <xen-devel@lists.xenproject.org>, <linux-kernel@vger.kernel.org>,
        <boris.ostrovsky@oracle.com>, <david.vrabel@citrix.com>,
        <mukesh.rathor@oracle.com>, <jbeulich@suse.com>
Subject: Re: [Xen-devel] [PATCH v11 05/12] xen/pvh: Update E820 to work with
 PVH
In-Reply-To: <1387313503-31362-6-git-send-email-konrad.wilk@oracle.com>
Message-ID: <alpine.DEB.2.02.1312181813260.8667@kaball.uk.xensource.com>
References: <1387313503-31362-1-git-send-email-konrad.wilk@oracle.com> <1387313503-31362-6-git-send-email-konrad.wilk@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 17 Dec 2013, Konrad Rzeszutek Wilk wrote:
> From: Mukesh Rathor <mukesh.rathor@oracle.com>
> 
> In xen_add_extra_mem() we can skip updating P2M as it's managed
> by Xen. PVH maps the entire IO space, but only RAM pages need
> to be repopulated.
> 
> Signed-off-by: Mukesh Rathor <mukesh.rathor@oracle.com>
> Signed-off-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
> ---
>  arch/x86/xen/setup.c | 19 +++++++++++++++++--
>  1 file changed, 17 insertions(+), 2 deletions(-)
> 
> diff --git a/arch/x86/xen/setup.c b/arch/x86/xen/setup.c
> index 2137c51..f93bca1 100644
> --- a/arch/x86/xen/setup.c
> +++ b/arch/x86/xen/setup.c
> @@ -27,6 +27,7 @@
>  #include <xen/interface/memory.h>
>  #include <xen/interface/physdev.h>
>  #include <xen/features.h>
> +#include "mmu.h"
>  #include "xen-ops.h"
>  #include "vdso.h"
>  
> @@ -81,6 +82,9 @@ static void __init xen_add_extra_mem(u64 start, u64 size)
>  
>  	memblock_reserve(start, size);
>  
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return;
> +
>  	xen_max_p2m_pfn = PFN_DOWN(start + size);
>  	for (pfn = PFN_DOWN(start); pfn < xen_max_p2m_pfn; pfn++) {
>  		unsigned long mfn = pfn_to_mfn(pfn);
> @@ -103,6 +107,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
>  		.domid        = DOMID_SELF
>  	};
>  	unsigned long len = 0;
> +	int xlated_phys = xen_feature(XENFEAT_auto_translated_physmap);
>  	unsigned long pfn;
>  	int ret;
>  
> @@ -116,7 +121,7 @@ static unsigned long __init xen_do_chunk(unsigned long start,
>  				continue;
>  			frame = mfn;
>  		} else {
> -			if (mfn != INVALID_P2M_ENTRY)
> +			if (!xlated_phys && mfn != INVALID_P2M_ENTRY)
>  				continue;
>  			frame = pfn;
>  		}
> @@ -154,6 +159,13 @@ static unsigned long __init xen_do_chunk(unsigned long start,
>  static unsigned long __init xen_release_chunk(unsigned long start,
>  					      unsigned long end)
>  {
> +	/*
> +	 * Xen already ballooned out the E820 non RAM regions for us
> +	 * and set them up properly in EPT.
> +	 */
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		return end - start;
> +
>  	return xen_do_chunk(start, end, true);
>  }
>  
> @@ -222,6 +234,9 @@ static void __init xen_set_identity_and_release_chunk(
>  	 * (except for the ISA region which must be 1:1 mapped) to
>  	 * release the refcounts (in Xen) on the original frames.
>  	 */
> +	if (xen_feature(XENFEAT_auto_translated_physmap))
> +		goto skip;
> +
>  	for (pfn = start_pfn; pfn <= max_pfn_mapped && pfn < end_pfn; pfn++) {
>  		pte_t pte = __pte_ma(0);
>  
> @@ -231,7 +246,7 @@ static void __init xen_set_identity_and_release_chunk(
>  		(void)HYPERVISOR_update_va_mapping(
>  			(unsigned long)__va(pfn << PAGE_SHIFT), pte, 0);
>  	}
> -
> +skip:
>  	if (start_pfn < nr_pages)
>  		*released += xen_release_chunk(
>  			start_pfn, min(end_pfn, nr_pages));

A goto? Really? What's wrong with an if?
Also considering that you are turning xen_release_chunk into a nop, the
only purpose of this function on PVH is to call set_phys_range_identity.
Can't we just do that?
