Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757639AbaGWLqR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jul 2014 07:46:17 -0400
Received: from mta-out1.inet.fi ([62.71.2.202]:49143 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751295AbaGWLqP (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jul 2014 07:46:15 -0400
Date: Wed, 23 Jul 2014 14:45:40 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Matthew Wilcox <matthew.r.wilcox@intel.com>
Cc: linux-fsdevel@vger.kernel.org, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Matthew Wilcox <willy@linux.intel.com>
Subject: Re: [PATCH v8 05/22] Add vm_replace_mixed()
Message-ID: <20140723114540.GD10317@node.dhcp.inet.fi>
References: <cover.1406058387.git.matthew.r.wilcox@intel.com>
 <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <b1052af08b49965fd0e6b87b6733b89294c8cc1e.1406058387.git.matthew.r.wilcox@intel.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 22, 2014 at 03:47:53PM -0400, Matthew Wilcox wrote:
> From: Matthew Wilcox <willy@linux.intel.com>
> 
> vm_insert_mixed() will fail if there is already a valid PTE at that
> location.  The DAX code would rather replace the previous value with
> the new PTE.
> 
> Signed-off-by: Matthew Wilcox <willy@linux.intel.com>
> ---
>  include/linux/mm.h |  8 ++++++--
>  mm/memory.c        | 34 +++++++++++++++++++++-------------
>  2 files changed, 27 insertions(+), 15 deletions(-)
> 
> diff --git a/include/linux/mm.h b/include/linux/mm.h
> index e04f531..8d1194c 100644
> --- a/include/linux/mm.h
> +++ b/include/linux/mm.h
> @@ -1958,8 +1958,12 @@ int remap_pfn_range(struct vm_area_struct *, unsigned long addr,
>  int vm_insert_page(struct vm_area_struct *, unsigned long addr, struct page *);
>  int vm_insert_pfn(struct vm_area_struct *vma, unsigned long addr,
>  			unsigned long pfn);
> -int vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> -			unsigned long pfn);
> +int __vm_insert_mixed(struct vm_area_struct *vma, unsigned long addr,
> +			unsigned long pfn, bool replace);
> +#define vm_insert_mixed(vma, addr, pfn)	\
> +	__vm_insert_mixed(vma, addr, pfn, false)
> +#define vm_replace_mixed(vma, addr, pfn)	\
> +	__vm_insert_mixed(vma, addr, pfn, true)
>  int vm_iomap_memory(struct vm_area_struct *vma, phys_addr_t start, unsigned long len);
>  
>  
> diff --git a/mm/memory.c b/mm/memory.c
> index 42bf429..cf06c97 100644
> --- a/mm/memory.c
> +++ b/mm/memory.c
> @@ -1476,7 +1476,7 @@ pte_t *__get_locked_pte(struct mm_struct *mm, unsigned long addr,
>   * pages reserved for the old functions anyway.
>   */
>  static int insert_page(struct vm_area_struct *vma, unsigned long addr,
> -			struct page *page, pgprot_t prot)
> +			struct page *page, pgprot_t prot, bool replace)
>  {
>  	struct mm_struct *mm = vma->vm_mm;
>  	int retval;
> @@ -1492,8 +1492,12 @@ static int insert_page(struct vm_area_struct *vma, unsigned long addr,
>  	if (!pte)
>  		goto out;
>  	retval = -EBUSY;
> -	if (!pte_none(*pte))
> -		goto out_unlock;
> +	if (!pte_none(*pte)) {
> +		if (!replace)
> +			goto out_unlock;
> +		VM_BUG_ON(!mutex_is_locked(&vma->vm_file->f_mapping->i_mmap_mutex));
> +		zap_page_range_single(vma, addr, PAGE_SIZE, NULL);

zap_page_range_single() takes ptl by itself in zap_pte_range(). It's not
going to work.

And zap_page_range*() is pretty heavy weapon to shoot down one pte, which
we already have pointer to. Why?

-- 
 Kirill A. Shutemov
