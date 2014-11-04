Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751641AbaKDGEh (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 01:04:37 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:50663 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750968AbaKDGEd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 01:04:33 -0500
Date: Mon, 3 Nov 2014 22:04:24 -0800 (PST)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Davidlohr Bueso <dave@stgolabs.net>
cc: "Kirill A. Shutemov" <kirill.shutemov@intel.linux.com>,
        Michel Lespinasse <walken@google.com>, akpm@linux-foundation.org,
        hughd@google.com, riel@redhat.com, mgorman@suse.de,
        peterz@infradead.org, mingo@kernel.org, linux-kernel@vger.kernel.org,
        dbueso@suse.de, linux-mm@kvack.org
Subject: Re: [PATCH 08/10] mm/mremap: share the i_mmap_rwsem
In-Reply-To: <1414697657-1678-9-git-send-email-dave@stgolabs.net>
Message-ID: <alpine.LSU.2.11.1411032148230.15596@eggly.anvils>
References: <1414697657-1678-1-git-send-email-dave@stgolabs.net> <1414697657-1678-9-git-send-email-dave@stgolabs.net>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I'm glad to see this series back, and nicely presented: thank you.
Not worth respinning them, but consider 1,2,3,4,5,6,7 and 9 as
Acked-by: Hugh Dickins <hughd@google.com>

On Thu, 30 Oct 2014, Davidlohr Bueso wrote:

> As per the comment in move_ptes(), we only require taking the
> anon vma and i_mmap locks to ensure that rmap will always observe
> either the old or new ptes, in the case of need_rmap_lock=true.
> No modifications to the tree itself, thus share the i_mmap_rwsem.
> 
> Signed-off-by: Davidlohr Bueso <dbueso@suse.de>
> Acked-by: Kirill A. Shutemov <kirill.shutemov@intel.linux.com>

But this one is Nacked by me.  I don't understand how you and Kirill
could read Michel's painstaking comment on need_rmap_locks, then go
go ahead and remove the exclusion of rmap_walk().

I agree the code here does not modify the interval tree, but the
comment explains how we're moving a pte from one place in the tree
to another, and in some cases there's a danger that the rmap walk
might miss the pte from both places (which doesn't matter much to
most of its uses, but is critical in page migration).

Or am I the one missing something?

Hugh

> ---
>  mm/mremap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/mremap.c b/mm/mremap.c
> index c929324..09bd644 100644
> --- a/mm/mremap.c
> +++ b/mm/mremap.c
> @@ -119,7 +119,7 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
>  	if (need_rmap_locks) {
>  		if (vma->vm_file) {
>  			mapping = vma->vm_file->f_mapping;
> -			i_mmap_lock_write(mapping);
> +			i_mmap_lock_read(mapping);
>  		}
>  		if (vma->anon_vma) {
>  			anon_vma = vma->anon_vma;
> @@ -156,7 +156,7 @@ static void move_ptes(struct vm_area_struct *vma, pmd_t *old_pmd,
>  	if (anon_vma)
>  		anon_vma_unlock_read(anon_vma);
>  	if (mapping)
> -		i_mmap_unlock_write(mapping);
> +		i_mmap_unlock_read(mapping);
>  }
>  
>  #define LATENCY_LIMIT	(64 * PAGE_SIZE)
> -- 
> 1.8.4.5
