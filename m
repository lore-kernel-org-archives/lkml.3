Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933951AbaFJBRT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Jun 2014 21:17:19 -0400
Received: from mail-pd0-f182.google.com ([209.85.192.182]:36468 "EHLO
	mail-pd0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754213AbaFJBRR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Jun 2014 21:17:17 -0400
Date: Mon, 9 Jun 2014 18:15:56 -0700 (PDT)
From: Hugh Dickins <hughd@google.com>
X-X-Sender: hugh@eggly.anvils
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
cc: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        Mel Gorman <mgorman@suse.de>, Rik van Riel <riel@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yijing Wang <wangyijing@huawei.com>, Will Deacon <will.deacon@arm.com>
Subject: Re: [PATCH 3.4 47/88] mm: add kmap_to_page()
In-Reply-To: <20140610002426.089246636@linuxfoundation.org>
Message-ID: <alpine.LSU.2.11.1406091806230.8481@eggly.anvils>
References: <20140610002424.500996570@linuxfoundation.org> <20140610002426.089246636@linuxfoundation.org>
User-Agent: Alpine 2.11 (LSU 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 9 Jun 2014, Greg Kroah-Hartman wrote:

> 3.4-stable review patch.  If anyone has any objections, please let me know.
> 
> ------------------
> 
> From: Ben Hutchings <ben@decadent.org.uk>
> 
> commit fcb8996728fb59eddf84678df7cb213b2c9a2e26 upstream.
> 
> This is extracted from Mel Gorman's commit 5a178119b0fb ('mm: add
> support for direct_IO to highmem pages') upstream.
> 
> Required to backport commit b9cdc88df8e6 ('virtio: 9p: correctly pass
> physical address to userspace for high pages').
> 
> Cc: Mel Gorman <mgorman@suse.de>
> Cc: Rik van Riel <riel@redhat.com>
> Cc: Andrew Morton <akpm@linux-foundation.org>
> Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
> Cc: Yijing Wang <wangyijing@huawei.com>
> Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
> 
> ---
>  include/linux/highmem.h |    7 +++++++
>  mm/highmem.c            |   12 ++++++++++++
>  2 files changed, 19 insertions(+)
> 
> --- a/include/linux/highmem.h
> +++ b/include/linux/highmem.h
> @@ -39,10 +39,17 @@ extern unsigned long totalhigh_pages;
>  
>  void kmap_flush_unused(void);
>  
> +struct page *kmap_to_page(void *addr);
> +
>  #else /* CONFIG_HIGHMEM */
>  
>  static inline unsigned int nr_free_highpages(void) { return 0; }
>  
> +static inline struct page *kmap_to_page(void *addr)
> +{
> +	return virt_to_page(addr);
> +}
> +
>  #define totalhigh_pages 0UL
>  
>  #ifndef ARCH_HAS_KMAP
> --- a/mm/highmem.c
> +++ b/mm/highmem.c
> @@ -94,6 +94,18 @@ static DECLARE_WAIT_QUEUE_HEAD(pkmap_map
>  		do { spin_unlock(&kmap_lock); (void)(flags); } while (0)
>  #endif
>  
> +struct page *kmap_to_page(void *vaddr)
> +{
> +	unsigned long addr = (unsigned long)vaddr;
> +
> +	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
> +		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
> +		return pte_page(pkmap_page_table[i]);
> +	}
> +
> +	return virt_to_page(addr);
> +}
> +
>  static void flush_all_zero_pkmaps(void)
>  {
>  	int i;

I think this needs the following on top:

commit 498c2280212327858e521e9d21345d4cc2637f54
Author: Will Deacon <will.deacon@arm.com>
Date:   Fri Nov 16 14:15:00 2012 -0800

    mm: highmem: don't treat PKMAP_ADDR(LAST_PKMAP) as a highmem address
    
    kmap_to_page returns the corresponding struct page for a virtual address
    of an arbitrary mapping.  This works by checking whether the address
    falls in the pkmap region and using the pkmap page tables instead of the
    linear mapping if appropriate.
    
    Unfortunately, the bounds checking means that PKMAP_ADDR(LAST_PKMAP) is
    incorrectly treated as a highmem address and we can end up walking off
    the end of pkmap_page_table and subsequently passing junk to pte_page.
    
    This patch fixes the bound check to stay within the pkmap tables.
    
    Signed-off-by: Will Deacon <will.deacon@arm.com>
    Cc: Mel Gorman <mgorman@suse.de>
    Signed-off-by: Andrew Morton <akpm@linux-foundation.org>
    Signed-off-by: Linus Torvalds <torvalds@linux-foundation.org>

diff --git a/mm/highmem.c b/mm/highmem.c
index d517cd16a6eb..2da13a5c50e2 100644
--- a/mm/highmem.c
+++ b/mm/highmem.c
@@ -98,7 +98,7 @@ struct page *kmap_to_page(void *vaddr)
 {
 	unsigned long addr = (unsigned long)vaddr;
 
-	if (addr >= PKMAP_ADDR(0) && addr <= PKMAP_ADDR(LAST_PKMAP)) {
+	if (addr >= PKMAP_ADDR(0) && addr < PKMAP_ADDR(LAST_PKMAP)) {
 		int i = (addr - PKMAP_ADDR(0)) >> PAGE_SHIFT;
 		return pte_page(pkmap_page_table[i]);
 	}

