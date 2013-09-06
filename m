Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753001Ab3IFPJn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Sep 2013 11:09:43 -0400
Received: from smtp.citrix.com ([66.165.176.89]:6596 "EHLO SMTP.CITRIX.COM"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751400Ab3IFPJm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Sep 2013 11:09:42 -0400
X-IronPort-AV: E=Sophos;i="4.90,854,1371081600"; 
   d="scan'208";a="51294999"
Date: Fri, 6 Sep 2013 16:09:22 +0100
From: Stefano Stabellini <stefano.stabellini@eu.citrix.com>
X-X-Sender: sstabellini@kaball.uk.xensource.com
To: Boris Ostrovsky <boris.ostrovsky@oracle.com>
CC: <stefano.stabellini@eu.citrix.com>, <david.vrabel@citrix.com>,
        <konrad.wilk@oracle.com>, <xen-devel@lists.xenproject.org>,
        <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] xen/p2m: Don't call get_balloon_scratch_page() twice,
 keep interrupts disabled for multicalls
In-Reply-To: <1378479646-12592-1-git-send-email-boris.ostrovsky@oracle.com>
Message-ID: <alpine.DEB.2.02.1309061607190.6397@kaball.uk.xensource.com>
References: <1378479646-12592-1-git-send-email-boris.ostrovsky@oracle.com>
User-Agent: Alpine 2.02 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: text/plain; charset="US-ASCII"
X-DLP: MIA1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 6 Sep 2013, Boris Ostrovsky wrote:
> m2p_remove_override() calls get_balloon_scratch_page() in
> MULTI_update_va_mapping() even though it already has pointer to this page from
> the earlier call (in scratch_page). This second call doesn't have a matching
> put_balloon_scratch_page() thus not restoring preempt count back. (Also, there
> is no put_balloon_scratch_page() in the error path.)
> 
> In addition, the second multicall uses __xen_mc_entry() which does not disable
> interrupts. Rearrange xen_mc_* calls to keep interrupts off while performing
> multicalls.
> 
> Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>

Reviewed-by: Stefano Stabellini <stefano.stabellini@eu.citrix.com>


>  arch/x86/xen/p2m.c | 10 ++++++----
>  1 file changed, 6 insertions(+), 4 deletions(-)
> 
> diff --git a/arch/x86/xen/p2m.c b/arch/x86/xen/p2m.c
> index 0d4ec35..8b901e8 100644
> --- a/arch/x86/xen/p2m.c
> +++ b/arch/x86/xen/p2m.c
> @@ -990,10 +990,13 @@ int m2p_remove_override(struct page *page,
>  				printk(KERN_WARNING "m2p_remove_override: "
>  						"pfn %lx mfn %lx, failed to modify kernel mappings",
>  						pfn, mfn);
> +				put_balloon_scratch_page();
>  				return -1;
>  			}
>  
> -			mcs = xen_mc_entry(
> +			xen_mc_batch();
> +
> +			mcs = __xen_mc_entry(
>  					sizeof(struct gnttab_unmap_and_replace));
>  			unmap_op = mcs.args;
>  			unmap_op->host_addr = kmap_op->host_addr;
> @@ -1003,12 +1006,11 @@ int m2p_remove_override(struct page *page,
>  			MULTI_grant_table_op(mcs.mc,
>  					GNTTABOP_unmap_and_replace, unmap_op, 1);
>  
> -			xen_mc_issue(PARAVIRT_LAZY_MMU);
> -
>  			mcs = __xen_mc_entry(0);
>  			MULTI_update_va_mapping(mcs.mc, scratch_page_address,
> -					pfn_pte(page_to_pfn(get_balloon_scratch_page()),
> +					pfn_pte(page_to_pfn(scratch_page),
>  					PAGE_KERNEL_RO), 0);
> +
>  			xen_mc_issue(PARAVIRT_LAZY_MMU);
>  
>  			kmap_op->host_addr = 0;
> -- 
> 1.8.3.1
> 
