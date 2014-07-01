Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758242AbaGASIH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 14:08:07 -0400
Received: from mta-out1.inet.fi ([62.71.2.198]:51223 "EHLO jenni2.inet.fi"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752065AbaGASIF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 14:08:05 -0400
Date: Tue, 1 Jul 2014 21:07:39 +0300
From: "Kirill A. Shutemov" <kirill@shutemov.name>
To: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
Cc: Andrew Morton <akpm@linux-foundation.org>,
        Joonsoo Kim <iamjoonsoo.kim@lge.com>, Hugh Dickins <hughd@google.com>,
        Rik van Riel <riel@redhat.com>, Hillf Danton <dhillf@gmail.com>,
        linux-kernel@vger.kernel.org, linux-mm@kvack.org,
        Naoya Horiguchi <nao.horiguchi@gmail.com>
Subject: Re: [PATCH] rmap: fix pgoff calculation to handle hugepage correctly
Message-ID: <20140701180739.GA4985@node.dhcp.inet.fi>
References: <1404225982-22739-1-git-send-email-n-horiguchi@ah.jp.nec.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1404225982-22739-1-git-send-email-n-horiguchi@ah.jp.nec.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, Jul 01, 2014 at 10:46:22AM -0400, Naoya Horiguchi wrote:
> I triggered VM_BUG_ON() in vma_address() when I try to migrate an anonymous
> hugepage with mbind() in the kernel v3.16-rc3. This is because pgoff's
> calculation in rmap_walk_anon() fails to consider compound_order() only to
> have an incorrect value. So this patch fixes it.
> 
> Signed-off-by: Naoya Horiguchi <n-horiguchi@ah.jp.nec.com>
> ---
>  mm/rmap.c | 2 +-
>  1 file changed, 1 insertion(+), 1 deletion(-)
> 
> diff --git v3.16-rc3.orig/mm/rmap.c v3.16-rc3/mm/rmap.c
> index b7e94ebbd09e..8cc964c6bd8d 100644
> --- v3.16-rc3.orig/mm/rmap.c
> +++ v3.16-rc3/mm/rmap.c
> @@ -1639,7 +1639,7 @@ static struct anon_vma *rmap_walk_anon_lock(struct page *page,
>  static int rmap_walk_anon(struct page *page, struct rmap_walk_control *rwc)
>  {
>  	struct anon_vma *anon_vma;
> -	pgoff_t pgoff = page->index << (PAGE_CACHE_SHIFT - PAGE_SHIFT);
> +	pgoff_t pgoff = page->index << compound_order(page);
>  	struct anon_vma_chain *avc;
>  	int ret = SWAP_AGAIN;

Hm. It will not work with THP: ->index there is in PAGE_SIZE units.

Why do we need this special case for hugetlb page ->index? Why not use
PAGE_SIZE units there too? Or I miss something?

-- 
 Kirill A. Shutemov
