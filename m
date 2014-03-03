Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754272AbaCCStp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Mar 2014 13:49:45 -0500
Received: from mail-ve0-f182.google.com ([209.85.128.182]:61399 "EHLO
	mail-ve0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754005AbaCCStn convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Mar 2014 13:49:43 -0500
MIME-Version: 1.0
In-Reply-To: <20140303110747.01F2DE0098@blue.fi.intel.com>
References: <1393625931-2858-1-git-send-email-quning@google.com>
 <1393625931-2858-2-git-send-email-quning@google.com> <alpine.LSU.2.11.1402281657520.976@eggly.anvils>
 <CACQD4-4bbwk_LOUVamTyB6V+Fg_F+Q4q2g8DxroTM7YiA=eJzQ@mail.gmail.com> <20140303110747.01F2DE0098@blue.fi.intel.com>
From: Ning Qu <quning@google.com>
Date: Mon, 3 Mar 2014 10:49:02 -0800
X-Google-Sender-Auth: g2lLTeqlHWZRoD8Tj_w3sqtvMxA
Message-ID: <CACQD4-5FhMZ5c1+rFdSLHusK4gT4uE8D06FPUHJ9Exqw8KVYYQ@mail.gmail.com>
Subject: Re: [PATCH 1/1] mm: implement ->map_pages for shmem/tmpfs
To: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Cc: Hugh Dickins <hughd@google.com>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Andrew Morton <akpm@linux-foundation.org>,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andi Kleen <ak@linux.intel.com>,
        Matthew Wilcox <matthew.r.wilcox@intel.com>,
        Dave Hansen <dave.hansen@linux.intel.com>,
        Alexander Viro <viro@zeniv.linux.org.uk>,
        Dave Chinner <david@fromorbit.com>, linux-mm@kvack.org,
        linux-fsdevel@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8BIT
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Thanks for the updates!
Best wishes,
-- 
Ning Qu (曲宁) | Software Engineer | quning@google.com | +1-408-418-6066


On Mon, Mar 3, 2014 at 3:07 AM, Kirill A. Shutemov
<kirill.shutemov@linux.intel.com> wrote:
> Ning Qu wrote:
>> Btw, should we first check if page returned by radix_tree_deref_slot is NULL?
>
> Yes, we should. I don't know how I missed that. :(
>
> The patch below should address both issues.
>
> From dca24c9a1f31ee1599fe81e9a60d4f87a4eaf0ea Mon Sep 17 00:00:00 2001
> From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
> Date: Mon, 3 Mar 2014 12:07:03 +0200
> Subject: [PATCH] mm: filemap_map_pages() avoid dereference NULL/exception
>  slots
>
> radix_tree_deref_slot() can return NULL: add missed check.
>
> Do no dereference 'page': we can get there as result of
> radix_tree_exception(page) check.
>
> Reported-by: Hugh Dickins <hughd@google.com>
> Reported-by: Ning Qu <quning@google.com>
> Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> ---
>  mm/filemap.c | 4 +++-
>  1 file changed, 3 insertions(+), 1 deletion(-)
>
> diff --git a/mm/filemap.c b/mm/filemap.c
> index 5f4fe7f0c258..e48624634927 100644
> --- a/mm/filemap.c
> +++ b/mm/filemap.c
> @@ -1745,6 +1745,8 @@ void filemap_map_pages(struct vm_area_struct *vma, struct vm_fault *vmf)
>                         break;
>  repeat:
>                 page = radix_tree_deref_slot(slot);
> +               if (unlikely(!page))
> +                       goto next;
>                 if (radix_tree_exception(page)) {
>                         if (radix_tree_deref_retry(page))
>                                 break;
> @@ -1790,7 +1792,7 @@ unlock:
>  skip:
>                 page_cache_release(page);
>  next:
> -               if (page->index == vmf->max_pgoff)
> +               if (iter.index == vmf->max_pgoff)
>                         break;
>         }
>         rcu_read_unlock();
> --
>  Kirill A. Shutemov
>
> --
> To unsubscribe, send a message with 'unsubscribe linux-mm' in
> the body to majordomo@kvack.org.  For more info on Linux MM,
> see: http://www.linux-mm.org/ .
> Don't email: <a href=mailto:"dont@kvack.org"> email@kvack.org </a>
