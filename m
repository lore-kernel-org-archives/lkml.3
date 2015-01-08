Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756834AbbAHRUR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 Jan 2015 12:20:17 -0500
Received: from gum.cmpxchg.org ([85.214.110.215]:56820 "EHLO gum.cmpxchg.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750825AbbAHRUP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 Jan 2015 12:20:15 -0500
Date: Thu, 8 Jan 2015 12:20:07 -0500
From: Johannes Weiner <hannes@cmpxchg.org>
To: David Vrabel <david.vrabel@citrix.com>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-kernel@vger.kernel.org,
        linux-mm@kvack.org, xen-devel@lists.xenproject.org,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>
Subject: Re: [PATCH 1/2] mm: allow for an alternate set of pages for
 userspace mappings
Message-ID: <20150108172007.GB32079@phnom.home.cmpxchg.org>
References: <1420730924-22811-1-git-send-email-david.vrabel@citrix.com>
 <1420730924-22811-2-git-send-email-david.vrabel@citrix.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1420730924-22811-2-git-send-email-david.vrabel@citrix.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Jan 08, 2015 at 03:28:43PM +0000, David Vrabel wrote:
> Add an optional array of pages to struct vm_area_struct that can be
> used find the page backing a VMA.  This is useful in cases where the
> normal mechanisms for finding the page don't work.  This array is only
> inspected if the PTE is special.
> 
> Splitting a VMA with such an array of pages is trivially done by
> adjusting vma->pages.  The original creator of the VMA must only free
> the page array once all sub-VMAs are closed (e.g., by ref-counting in
> vm_ops->open and vm_ops->close).
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
> ---
>  include/linux/mm_types.h |    8 ++++++++
>  mm/memory.c              |    2 ++
>  mm/mmap.c                |   12 +++++++++++-
>  3 files changed, 21 insertions(+), 1 deletion(-)
> 
> diff --git a/include/linux/mm_types.h b/include/linux/mm_types.h
> index 6d34aa2..4f34609 100644
> --- a/include/linux/mm_types.h
> +++ b/include/linux/mm_types.h
> @@ -309,6 +309,14 @@ struct vm_area_struct {
>  #ifdef CONFIG_NUMA
>  	struct mempolicy *vm_policy;	/* NUMA policy for the VMA */
>  #endif
> +	/*
> +	 * Array of pages to override the default vm_normal_page()
> +	 * result iff the PTE is special.
> +	 *
> +	 * The memory for this should be refcounted in vm_ops->open
> +	 * and vm_ops->close.
> +	 */
> +	struct page **pages;

Please make this configuration-dependent, not every Linux user should
have to pay for a Xen optimization.
