Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754877AbaHUUvT (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Aug 2014 16:51:19 -0400
Received: from mail-lb0-f182.google.com ([209.85.217.182]:46138 "EHLO
	mail-lb0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753658AbaHUUvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Aug 2014 16:51:18 -0400
Date: Fri, 22 Aug 2014 00:51:15 +0400
From: Cyrill Gorcunov <gorcunov@gmail.com>
To: Peter Feiner <pfeiner@google.com>
Cc: "Kirill A. Shutemov" <kirill@shutemov.name>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, Pavel Emelyanov <xemul@parallels.com>,
        Jamie Liu <jamieliu@google.com>, Hugh Dickins <hughd@google.com>,
        Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Magnus Damm <damm@opensource.se>
Subject: Re: [PATCH] mm: softdirty: write protect PTEs created for read
 faults after VM_SOFTDIRTY cleared
Message-ID: <20140821205115.GH14072@moon>
References: <1408571182-28750-1-git-send-email-pfeiner@google.com>
 <20140820234543.GA7987@node.dhcp.inet.fi>
 <20140821193737.GC16042@google.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20140821193737.GC16042@google.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 03:37:37PM -0400, Peter Feiner wrote:
>
> Thanks Kirill, I prefer your approach. I'll send a v2.
> 
> I believe you're right about c9d0bf241451. It seems like passing the old & new
> pgprot through pgprot_modify would handle the problem. Furthermore, as you
> suggest, mprotect_fixup should use pgprot_modify when it turns write
> notification on.  I think a patch like this is in order:
> 
> Not-signed-off-by: Peter Feiner <pfeiner@google.com>
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index c1f2ea4..86f89a1 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -1611,18 +1611,15 @@ munmap_back:
>  	}
>  
>  	if (vma_wants_writenotify(vma)) {
> -		pgprot_t pprot = vma->vm_page_prot;
> -
>  		/* Can vma->vm_page_prot have changed??
>  		 *
>  		 * Answer: Yes, drivers may have changed it in their
>  		 *         f_op->mmap method.
>  		 *
> -		 * Ensures that vmas marked as uncached stay that way.
> +		 * Ensures that vmas marked with special bits stay that way.
>  		 */
> -		vma->vm_page_prot = vm_get_page_prot(vm_flags & ~VM_SHARED);
> -		if (pgprot_val(pprot) == pgprot_val(pgprot_noncached(pprot)))
> -			vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
> +		vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
> +		                        vm_get_page_prot(vm_flags & ~VM_SHARED);
>  	}
>  
>  	vma_link(mm, vma, prev, rb_link, rb_parent);
> diff --git a/mm/mprotect.c b/mm/mprotect.c
> index c43d557..6826313 100644
> --- a/mm/mprotect.c
> +++ b/mm/mprotect.c
> @@ -324,7 +324,8 @@ success:
>  					  vm_get_page_prot(newflags));
>  
>  	if (vma_wants_writenotify(vma)) {
> -		vma->vm_page_prot = vm_get_page_prot(newflags & ~VM_SHARED);
> +		vma->vm_page_prot = pgprot_modify(vma->vm_page_prot,
> +		                       vm_get_page_prot(newflags & ~VM_SHARED));
>  		dirty_accountable = 1;
>  	}

Thanks a lot Peter and Kirill for catching it and providing the prelim. fixup. (Initial
patch doesn't look that right for me because vm-softdirty should involve into
account for newly created/expaned vmas only but not into some deep code such
as fault handlings). Peter does the patch above helps? (out of testing machine
at the moment so cant test myself).
