Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752261AbbALWff (ORCPT <rfc822;w@1wt.eu>);
	Mon, 12 Jan 2015 17:35:35 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:57207 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751000AbbALWfe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 12 Jan 2015 17:35:34 -0500
Date: Mon, 12 Jan 2015 17:35:28 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org
Subject: Re: [PATCH 1/2] mm: provide a find_page vma operation
Message-ID: <20150112223528.GD25609@phnom.home.cmpxchg.org>
References: <1421077993-7909-1-git-send-email-david.vrabel@citrix.com>
 <1421077993-7909-2-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1421077993-7909-2-git-send-email-david.vrabel@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Jan 12, 2015 at 03:53:12PM +0000, David Vrabel wrote:
> The optional find_page VMA operation is used to lookup the pages
> backing a VMA.  This is useful in cases where the normal mechanisms
> for finding the page don't work.  This is only called if the PTE is
> special.
> 
> One use case is a Xen PV guest mapping foreign pages into userspace.
> 
> In a Xen PV guest, the PTEs contain MFNs so get_user_pages() (for
> example) must do an MFN to PFN (M2P) lookup before it can get the
> page.  For foreign pages (those owned by another guest) the M2P lookup
> returns the PFN as seen by the foreign guest (which would be
> completely the wrong page for the local guest).
> 
> This cannot be fixed up improving the M2P lookup since one MFN may be
> mapped onto two or more pages so getting the right page is impossible
> given just the MFN.
> 
> Signed-off-by: David Vrabel <david.vrabel@citrix.com>

Looks much better to me, thanks.

> ---
>  include/linux/mm.h |    3 +++
>  mm/memory.c        |    2 ++
>  2 files changed, 5 insertions(+)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index 80fc92a..1306643 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -290,6 +290,9 @@ struct vm_operations_struct {
>  	/* called by sys_remap_file_pages() to populate non-linear mapping */
>  	int (*remap_pages)(struct vm_area_struct *vma, unsigned long addr,
>  			   unsigned long size, pgoff_t pgoff);
> +
> +	struct page * (*find_page)(struct vm_area_struct *vma,
> +				   unsigned long addr);

Could you please add a comment what that method is used for?

It would probably also be useful if the name reflected that this only
applies to special ptes.  find_special_page()?  lookup_special_pte()?
pte_special_page()?

Thanks

> @@ -754,6 +754,8 @@ struct page *vm_normal_page(struct vm_area_struct *vma, unsigned long addr,
>  	if (HAVE_PTE_SPECIAL) {
>  		if (likely(!pte_special(pte)))
>  			goto check_pfn;
> +		if (vma->vm_ops && vma->vm_ops->find_page)
> +			return vma->vm_ops->find_page(vma, addr);
>  		if (vma->vm_flags & (VM_PFNMAP | VM_MIXEDMAP))
>  			return NULL;
>  		if (!is_zero_pfn(pfn))
