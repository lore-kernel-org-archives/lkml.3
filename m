Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754085AbaENJSl (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 May 2014 05:18:41 -0400
Received: from mta-out1.inet.fi ([62.71.2.199]:54313 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753899AbaENJSf (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 May 2014 05:18:35 -0400
Date: Wed, 14 May 2014 12:15:46 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Sasha Levin <sasha.levin@oracle.com>
Cc: linux-mm@kvack.org, kirill.shutemov@linux.intel.com, davej@redhat.com,
        linux-kernel@vger.kernel.org, viro@zeniv.linux.org.uk,
        peterz@infradead.org, mingo@kernel.org
Subject: Re: [PATCH] mm: remap_file_pages: grab file ref to prevent race
 while mmaping
Message-ID: <20140514091546.GA29388@node.dhcp.inet.fi>
References: <1400038542-9705-1-git-send-email-sasha.levin@oracle.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1400038542-9705-1-git-send-email-sasha.levin@oracle.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, May 13, 2014 at 11:35:42PM -0400, Sasha Levin wrote:
> A file reference should be held while a file is mmaped, otherwise it might
> be freed while being used.
> 
> Suggested-by: Hugh Dickins <hughd@google.com>
> Signed-off-by: Sasha Levin <sasha.levin@oracle.com>

Sorry, again. :-/

Acked-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>

> ---
>  mm/mmap.c |    3 +++
>  1 file changed, 3 insertions(+)
> 
> diff --git a/mm/mmap.c b/mm/mmap.c
> index 2a0e0a8..da3c212 100644
> --- a/mm/mmap.c
> +++ b/mm/mmap.c
> @@ -2593,6 +2593,7 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
>  	struct vm_area_struct *vma;
>  	unsigned long populate = 0;
>  	unsigned long ret = -EINVAL;
> +	struct file *file;
>  
>  	pr_warn_once("%s (%d) uses deprecated remap_file_pages() syscall. "
>  			"See Documentation/vm/remap_file_pages.txt.\n",
> @@ -2636,8 +2637,10 @@ SYSCALL_DEFINE5(remap_file_pages, unsigned long, start, unsigned long, size,
>  		munlock_vma_pages_range(vma, start, start + size);
>  	}
>  
> +	file = get_file(vma->vm_file);
>  	ret = do_mmap_pgoff(vma->vm_file, start, size,
>  			prot, flags, pgoff, &populate);
> +	fput(file);
>  out:
>  	up_write(&mm->mmap_sem);
>  	if (populate)
> -- 
> 1.7.10.4
> 
> --
> To unsubscribe from this list: send the line "unsubscribe linux-kernel" in
> the body of a message to majordomo@vger.kernel.org
> More majordomo info at  http://vger.kernel.org/majordomo-info.html
> Please read the FAQ at  http://www.tux.org/lkml/

-- 
 Kirill A. Shutemov
