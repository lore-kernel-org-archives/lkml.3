Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752237AbaFFPah (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Jun 2014 11:30:37 -0400
Received: from casper.infradead.org ([85.118.1.10]:58095 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751692AbaFFPag convert rfc822-to-8bit (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Jun 2014 11:30:36 -0400
Date: Fri, 6 Jun 2014 17:30:33 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Andrey Ryabinin <a.ryabinin@samsung.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Linus Torvalds <torvalds@linux-foundation.org>, linux-mm@kvack.org,
        linux-kernel@vger.kernel.org, koct9i@gmail.com, stable@vger.kernel.org,
        Hugh Dickins <hughd@google.com>
Subject: Re: [PATCH v2] mm: rmap: fix use-after-free in __put_anon_vma
Message-ID: <20140606153033.GC11371@laptop.programming.kicks-ass.net>
References: <20140606115620.GS3213@twins.programming.kicks-ass.net>
 <1402067370-5773-1-git-send-email-a.ryabinin@samsung.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
Content-Transfer-Encoding: 8BIT
In-Reply-To: <1402067370-5773-1-git-send-email-a.ryabinin@samsung.com>
User-Agent: Mutt/1.5.21 (2012-12-30)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, Jun 06, 2014 at 07:09:30PM +0400, Andrey Ryabinin wrote:
> While working address sanitizer for kernel I've discovered use-after-free
> bug in __put_anon_vma.
> For the last anon_vma, anon_vma->root freed before child anon_vma.
> Later in anon_vma_free(anon_vma) we are referencing to already freed anon_vma->root
> to check rwsem.
> This patch puts freeing of child anon_vma before freeing of anon_vma->root.
> 
> Cc: <stable@vger.kernel.org> # v3.0+

Acked-by: Peter Zijlstra <peterz@infradead.org>

> Signed-off-by: Andrey Ryabinin <a.ryabinin@samsung.com>
> ---
> 
> Changes since v1:
>  - just made it more simple following Peter's suggestion
> 
>  mm/rmap.c | 4 ++--
>  1 file changed, 2 insertions(+), 2 deletions(-)
> 
> diff --git a/mm/rmap.c b/mm/rmap.c
> index 9c3e773..cb5f70a 100644
> --- a/mm/rmap.c
> +++ b/mm/rmap.c
> @@ -1564,10 +1564,10 @@ void __put_anon_vma(struct anon_vma *anon_vma)
>  {
>  	struct anon_vma *root = anon_vma->root;
>  
> +	anon_vma_free(anon_vma);
> +
>  	if (root != anon_vma && atomic_dec_and_test(&root->refcount))
>  		anon_vma_free(root);
> -
> -	anon_vma_free(anon_vma);
>  }
>  
>  static struct anon_vma *rmap_walk_anon_lock(struct page *page,
> -- 
> 1.8.5.5
> 
