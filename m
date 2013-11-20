Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753591Ab3KTMxa (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 07:53:30 -0500
Received: from mga11.intel.com ([192.55.52.93]:2082 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751944Ab3KTMx2 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 07:53:28 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,736,1378882800"; 
   d="scan'208";a="436623713"
From: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>
To: Andrey Wagin <avagin@gmail.com>
Cc: "Kirill A. Shutemov" <kirill.shutemov@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@redhat.com>,
        LKML <linux-kernel@vger.kernel.org>, linux-mm@kvack.org,
        linux-arch@vger.kernel.org
In-Reply-To: <CANaxB-x3k8DPEaDCtCzhkuyPcwR1YcRJZwXW777+q+y2KBvzHg@mail.gmail.com>
References: <1381428359-14843-1-git-send-email-kirill.shutemov@linux.intel.com>
 <1381428359-14843-35-git-send-email-kirill.shutemov@linux.intel.com>
 <CANaxB-x3k8DPEaDCtCzhkuyPcwR1YcRJZwXW777+q+y2KBvzHg@mail.gmail.com>
Subject: Re: [PATCH 34/34] mm: dynamically allocate page->ptl if it cannot be
 embedded to struct page
Content-Transfer-Encoding: 7bit
Message-Id: <20131120125325.07A42E0090@blue.fi.intel.com>
Date: Wed, 20 Nov 2013 14:53:24 +0200 (EET)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Andrey Wagin wrote:
> Hi Kirill,
> 
> Looks like this patch adds memory leaks.
> [  116.188310] kmemleak: 15672 new suspected memory leaks (see
> /sys/kernel/debug/kmemleak)
> unreferenced object 0xffff8800da45a350 (size 96):
>   comm "dracut-initqueu", pid 93, jiffies 4294671391 (age 362.277s)
>   hex dump (first 32 bytes):
>     07 00 07 00 ad 4e ad de ff ff ff ff 6b 6b 6b 6b  .....N......kkkk
>     ff ff ff ff ff ff ff ff 80 24 b4 82 ff ff ff ff  .........$......
>   backtrace:
>     [<ffffffff817152fe>] kmemleak_alloc+0x5e/0xc0
>     [<ffffffff811c34f3>] kmem_cache_alloc_trace+0x113/0x290
>     [<ffffffff811920f7>] __ptlock_alloc+0x27/0x50
>     [<ffffffff81192849>] __pmd_alloc+0x59/0x170
>     [<ffffffff81195ffa>] copy_page_range+0x38a/0x3e0
>     [<ffffffff8105a013>] dup_mm+0x313/0x540
>     [<ffffffff8105b9da>] copy_process+0x161a/0x1880
>     [<ffffffff8105c01b>] do_fork+0x8b/0x360
>     [<ffffffff8105c306>] SyS_clone+0x16/0x20
>     [<ffffffff81727b79>] stub_clone+0x69/0x90
>     [<ffffffffffffffff>] 0xffffffffffffffff
> 
> It's quite serious, because my test host went to panic in a few hours.

Sorry for that.

Could you test patch below.

diff --git a/arch/x86/mm/pgtable.c b/arch/x86/mm/pgtable.c
index a7cccb6d7fec..7be5809754cf 100644
--- a/arch/x86/mm/pgtable.c
+++ b/arch/x86/mm/pgtable.c
@@ -61,6 +61,7 @@ void ___pte_free_tlb(struct mmu_gather *tlb, struct page *pte)
 #if PAGETABLE_LEVELS > 2
 void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 {
+	struct page *page = virt_to_page(pmd);
 	paravirt_release_pmd(__pa(pmd) >> PAGE_SHIFT);
 	/*
 	 * NOTE! For PAE, any changes to the top page-directory-pointer-table
@@ -69,7 +70,8 @@ void ___pmd_free_tlb(struct mmu_gather *tlb, pmd_t *pmd)
 #ifdef CONFIG_X86_PAE
 	tlb->need_flush_all = 1;
 #endif
-	tlb_remove_page(tlb, virt_to_page(pmd));
+	pgtable_pmd_page_dtor(page);
+	tlb_remove_page(tlb, page);
 }
 
 #if PAGETABLE_LEVELS > 3
-- 
 Kirill A. Shutemov
