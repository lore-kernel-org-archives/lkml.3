Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760414Ab3JPJ4k (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Oct 2013 05:56:40 -0400
Received: from mga03.intel.com ([143.182.124.21]:46289 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1760162Ab3JPJ4i (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Oct 2013 05:56:38 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,506,1378882800"; 
   d="scan'208";a="308449883"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Geert Uytterhoeven <geert@linux-m68k.org>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Linux MM <linux-mm@kvack.org>, Linux-Arch <linux-arch@vger.kernel.org>,
        Linux/m68k <linux-m68k@vger.kernel.org>
In-Reply-To: <CAMuHMdUqQVphjUbvPg+47ZjFmS8WUK_70VMb43w4jaBOcGfNxA@mail.gmail.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1381428359-14843-20-git-send-email-kirill.shutemov@linux.intel.com>
 <CAMuHMdUqQVphjUbvPg+47ZjFmS8WUK_70VMb43w4jaBOcGfNxA@mail.gmail.com>
Subject: Re: [PATCH 19/34] m68k: handle pgtable_page_ctor() fail
Content-Transfer-Encoding: 7bit
Message-Id: <20131016095612.34707E0090@blue.fi.intel.com>
Date: Wed, 16 Oct 2013 12:56:12 +0300 (EEST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Geert Uytterhoeven wrote:
> On Thu, Oct 10, 2013 at 8:05 PM, Kirill A. Shutemov
> <kirill.shutemov@linux.intel.com> wrote:
> > Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
> > Cc: Geert Uytterhoeven <geert@linux-m68k.org>
> > ---
> >  arch/m68k/include/asm/motorola_pgalloc.h | 5 ++++-
> >  arch/m68k/include/asm/sun3_pgalloc.h     | 5 ++++-
> >  2 files changed, 8 insertions(+), 2 deletions(-)
> >
> > diff --git a/arch/m68k/include/asm/motorola_pgalloc.h b/arch/m68k/include/asm/motorola_pgalloc.h
> > index 2f02f264e6..dd254eeb03 100644
> > --- a/arch/m68k/include/asm/motorola_pgalloc.h
> > +++ b/arch/m68k/include/asm/motorola_pgalloc.h
> > @@ -40,7 +40,10 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long addres
> >         flush_tlb_kernel_page(pte);
> >         nocache_page(pte);
>         ^^^^^^^^^^^^^^^^^^
> >         kunmap(page);
> > -       pgtable_page_ctor(page);
> > +       if (!pgtable_page_ctor(page)) {
> > +               __free_page(page);
> 
> Shouldn't you mark the page cacheable again, like is done in pte_free()?

Hm. You're right. Updated patch below.

BTW, what's the point of playing with kmap()/kunmap() there? Looks like
m68k doesn't support highmem.

And even if it will support, code in pte_alloc_one() doesn't make any
sense: kmap() creates temporary mapping for highmem page and it
nocache_page() sets flags in pte which will be destroyed by kunmap().

It think kmap() should be replaced by page_address() and kunmap() should
be dropped.

>From 2f9dce7982e4459e91cd49e38256c24d69786f8b Mon Sep 17 00:00:00 2001
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
Date: Wed, 9 Oct 2013 03:58:39 +0300
Subject: [PATCHv2] m68k: handle pgtable_page_ctor() fail

Signed-off-by: Kirill A. Shutemov <kirill.shutemov@linux.intel.com>
Cc: Geert Uytterhoeven <geert@linux-m68k.org>
---
 arch/m68k/include/asm/motorola_pgalloc.h | 8 ++++++--
 arch/m68k/include/asm/sun3_pgalloc.h     | 5 ++++-
 2 files changed, 10 insertions(+), 3 deletions(-)

diff --git a/arch/m68k/include/asm/motorola_pgalloc.h b/arch/m68k/include/asm/motorola_pgalloc.h
index 2f02f264e6..24bcba496c 100644
--- a/arch/m68k/include/asm/motorola_pgalloc.h
+++ b/arch/m68k/include/asm/motorola_pgalloc.h
@@ -29,18 +29,22 @@ static inline void pte_free_kernel(struct mm_struct *mm, pte_t *pte)
 
 static inline pgtable_t pte_alloc_one(struct mm_struct *mm, unsigned long address)
 {
-	struct page *page = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
+	struct page *page;
 	pte_t *pte;
 
+	page = alloc_pages(GFP_KERNEL|__GFP_REPEAT|__GFP_ZERO, 0);
 	if(!page)
 		return NULL;
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 
 	pte = kmap(page);
 	__flush_page_to_ram(pte);
 	flush_tlb_kernel_page(pte);
 	nocache_page(pte);
 	kunmap(page);
-	pgtable_page_ctor(page);
 	return page;
 }
 
diff --git a/arch/m68k/include/asm/sun3_pgalloc.h b/arch/m68k/include/asm/sun3_pgalloc.h
index 48d80d5a66..f868506e33 100644
--- a/arch/m68k/include/asm/sun3_pgalloc.h
+++ b/arch/m68k/include/asm/sun3_pgalloc.h
@@ -59,7 +59,10 @@ static inline pgtable_t pte_alloc_one(struct mm_struct *mm,
 		return NULL;
 
 	clear_highpage(page);
-	pgtable_page_ctor(page);
+	if (!pgtable_page_ctor(page)) {
+		__free_page(page);
+		return NULL;
+	}
 	return page;
 
 }
-- 
 Kirill A. Shutemov
