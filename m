Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756561Ab3BEV1o (ORCPT <rfc822;w@1wt.eu>);
	Tue, 5 Feb 2013 16:27:44 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:41802 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3BEV1m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 5 Feb 2013 16:27:42 -0500
Date: Tue, 5 Feb 2013 13:27:41 -0800
From: Andrew Morton <akpm@linux-foundation.org>
To: Huang Shijie <b32955@freescale.com>
Cc: <linux-mm@kvack.org>, <linux-kernel@vger.kernel.org>
Subject: Re: [PATCH] mm: introduce __linear_page_index()
Message-Id: <20130205132741.1e1a4e04.akpm@linux-foundation.org>
In-Reply-To: <1360047819-6669-1-git-send-email-b32955@freescale.com>
References: <1360047819-6669-1-git-send-email-b32955@freescale.com>
X-Mailer: Sylpheed 3.0.2 (GTK+ 2.20.1; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 5 Feb 2013 15:03:39 +0800
Huang Shijie <b32955@freescale.com> wrote:

> There are many places we should get the offset(in PAGE_SIZE unit) of
> an address within a non-hugetlb vma.
> 
> In order to simplify the code, add a new helper __linear_page_index()
> to do the work.
> 

Seems nice.

> --- a/include/linux/pagemap.h
> +++ b/include/linux/pagemap.h
> @@ -310,15 +310,23 @@ static inline loff_t page_file_offset(struct page *page)
>  extern pgoff_t linear_hugepage_index(struct vm_area_struct *vma,
>  				     unsigned long address);
>  
> -static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
> +/* The offset for an address within a non-hugetlb vma, in PAGE_SIZE unit. */

"The offset into the mapped file for ..."

> +static inline pgoff_t __linear_page_index(struct vm_area_struct *vma,
>  					unsigned long address)
>  {
>  	pgoff_t pgoff;
> +
> +	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
> +	return pgoff + vma->vm_pgoff;
> +}
> +
> +static inline pgoff_t linear_page_index(struct vm_area_struct *vma,
> +					unsigned long address)
> +{
>  	if (unlikely(is_vm_hugetlb_page(vma)))
>  		return linear_hugepage_index(vma, address);
> -	pgoff = (address - vma->vm_start) >> PAGE_SHIFT;
> -	pgoff += vma->vm_pgoff;
> -	return pgoff >> (PAGE_CACHE_SHIFT - PAGE_SHIFT);
> +	return __linear_page_index(vma, address) >>
> +				(PAGE_CACHE_SHIFT - PAGE_SHIFT);
>  }

I don't think we need bother creating both linear_page_index() and
__linear_page_index().  Realistically, we won't be supporting
PAGE_SHIFT!=PAGE_CACHE_SHIFT.  And most (or all?) of the sites which
you changed should have been using PAGE_CACHE_SHIFT anyway!

> @@ -1201,8 +1199,7 @@ SYSCALL_DEFINE1(shmdt, char __user *, shmaddr)
>  
>  		/* finding a matching vma now does not alter retval */
>  		if ((vma->vm_ops == &shm_vm_ops) &&
> -			(vma->vm_start - addr)/PAGE_SIZE == vma->vm_pgoff)
> -
> +			0 == __linear_page_index(vma, addr))

erk, please don't do this - it makes kernel developers fall over in
shock.  Let's do

			__linear_page_index(vma, addr) == 0

(This won't compile if someone forgets a `=', so the usual reason for
the backward comparison isn't valid).


