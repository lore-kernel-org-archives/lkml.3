Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757746Ab3KMCBL (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Nov 2013 21:01:11 -0500
Received: from mail-pd0-f173.google.com ([209.85.192.173]:51320 "EHLO
	mail-pd0-f173.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755841Ab3KMCBH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Nov 2013 21:01:07 -0500
Date: Tue, 12 Nov 2013 18:01:03 -0800
From: Matt Wilson <msw@linux.com>
To: Anthony Liguori <anthony@codemonkey.ws>
Cc: xen-devel@lists.xen.org, Matt Wilson <msw@amazon.com>,
        Stefano Stabellini <stefano.stabellini@eu.citrix.com>,
        David Vrabel <david.vrabel@citrix.com>,
        Roger Pau Monne <roger.pau@citrix.com>, linux-kernel@vger.kernel.org,
        Konrad Wilk <konrad.wilk@oracle.com>,
        Anthony Liguori <aliguori@amazon.com>
Subject: Re: [PATCH] xen-gnttab: do not add m2p override entries for blkback
 mappings
Message-ID: <20131113020103.GA32239@u109add4315675089e695.ant.amazon.com>
References: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1384307336-5328-1-git-send-email-anthony@codemonkey.ws>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Nov 12, 2013 at 05:48:56PM -0800, Anthony Liguori wrote:
> From: Anthony Liguori <aliguori@amazon.com>
> 
> Commit 5dc03639 switched blkback to also add m2p override entries
> when mapping grant pages but history seems to have forgotten why
> this is useful if it ever was.
> 
> The blkback driver does not need m2p override entries to exist
> and there is significant overhead due to the locking in the m2p
> override table.  We see about a 10% improvement in IOP rate with
> this patch applied running FIO in the guest.
> 
> See http://article.gmane.org/gmane.linux.kernel/1590932 for a full
> analysis of current users.
> 
> Signed-off-by: Anthony Liguori <aliguori@amazon.com>

Reviewed-by: Matt Wilson <msw@amazon.com>

One comment for discussion below.

> ---
> A backported version of this has been heavily tested but the testing
> against the latest Linux tree is light so far.

[...]

> diff --git a/drivers/xen/grant-table.c b/drivers/xen/grant-table.c
> index c4d2298..081be8d 100644
> --- a/drivers/xen/grant-table.c
> +++ b/drivers/xen/grant-table.c
> @@ -881,7 +881,8 @@ EXPORT_SYMBOL_GPL(gnttab_batch_copy);
>  
>  int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  		    struct gnttab_map_grant_ref *kmap_ops,
> -		    struct page **pages, unsigned int count)
> +		    struct page **pages, unsigned int count,
> +		    int override)
>  {
>  	int i, ret;
>  	bool lazy = false;
> @@ -918,10 +919,29 @@ int gnttab_map_refs(struct gnttab_map_grant_ref *map_ops,
>  		} else {
>  			mfn = PFN_DOWN(map_ops[i].dev_bus_addr);
>  		}
> -		ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> -				       &kmap_ops[i] : NULL);
> -		if (ret)
> -			return ret;
> +
> +		if (override) {
> +			ret = m2p_add_override(mfn, pages[i], kmap_ops ?
> +					       &kmap_ops[i] : NULL);
> +			if (ret)
> +				return ret;

The original code, which remains unmodified by this patch, is
returning without calling arch_leave_lazy_mmu_mode() at the bottom of
this function.

> +		} else {
> +			unsigned long pfn, old_mfn;
> +
> +			pfn = page_to_pfn(pages[i]);
> +			old_mfn = pfn_to_mfn(pfn);
> +
> +			/* Save previous MFN in page private*/
> +			WARN_ON(PagePrivate(pages[i]));
> +			SetPagePrivate(pages[i]);
> +			set_page_private(pages[i], old_mfn);
> +
> +			if (!set_phys_to_machine(pfn, FOREIGN_FRAME(mfn))) {
> +				ret = -ENOMEM;
> +				break;

The new path doesn't repeat this error. I think that the override path
needs to be changed to do the same in a separate patch.

--msw

> +			}
> +		}
> +			
>  	}
>  
>  	if (lazy)
                arch_leave_lazy_mmu_mode();

        return ret;
}
