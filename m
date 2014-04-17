Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161264AbaDQJ4m (ORCPT <rfc822;w@1wt.eu>);
	Thu, 17 Apr 2014 05:56:42 -0400
Received: from cantor2.suse.de ([195.135.220.15]:51689 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752203AbaDQJ4h (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 17 Apr 2014 05:56:37 -0400
Date: Thu, 17 Apr 2014 10:56:30 +0100
From: Mel Gorman <mgorman@suse.de>
To: Stephen Rothwell <sfr@canb.auug.org.au>
Cc: Andrew Morton <akpm@linux-foundation.org>, linux-next@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: Re: linux-next: build failure after merge of the akpm-current tree
Message-ID: <20140417095630.GA7292@suse.de>
References: <20140417170831.53f065b7aa4ff04d30a79469@canb.auug.org.au>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-15
Content-Disposition: inline
In-Reply-To: <20140417170831.53f065b7aa4ff04d30a79469@canb.auug.org.au>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Apr 17, 2014 at 05:08:31PM +1000, Stephen Rothwell wrote:
> Hi Andrew,
> 
> After merging the akpm-current tree, today's linux-next build (arm
> multi_v7_defconfig) failed like this:
> 
> In file included from mm/shmem.c:61:0:
> include/linux/swapops.h: In function 'is_swap_pte':
> include/linux/swapops.h:57:2: error: implicit declaration of function 'pte_present_nonuma' [-Werror=implicit-function-declaration]
> 
> And a couple more similar.
> 
> Caused by commit 851fe3337768 ("x86: define _PAGE_NUMA by reusing
> software bits on the PMD and PTE levels").
> 
> I have reverted this commit (and 7cb1c1eb682e "x86: define _PAGE_NUMA by
> reusing software bits on the PMD and PTE levels -fix") for today and
> wonder how many other architectures would be broken by this?  Everything
> else with CONFIG_MMU set?
> 

/me slaps self

Andrew, can you replace the broken fix with this version please?

---8<---
x86: define _PAGE_NUMA by reusing software bits on the PMD and PTE levels -fix

powerpc has NUMA_BALANCING and non-NUMA_BALANCING versions of pte_present
and I missed that when testing cross-compiling. This patch replaces
x86-define-_page_numa-by-reusing-software-bits-on-the-pmd-and-pte-levels-fix.patch

Signed-off-by: Mel Gorman <mgorman@suse.de>
---
 arch/powerpc/include/asm/pgtable.h | 1 +
 arch/x86/include/asm/pgtable.h     | 1 +
 include/asm-generic/pgtable.h      | 4 ++++
 3 files changed, 6 insertions(+)

diff --git a/arch/powerpc/include/asm/pgtable.h b/arch/powerpc/include/asm/pgtable.h
index cdf6679..d98c1ec 100644
--- a/arch/powerpc/include/asm/pgtable.h
+++ b/arch/powerpc/include/asm/pgtable.h
@@ -44,6 +44,7 @@ static inline int pte_present(pte_t pte)
 	return pte_val(pte) & (_PAGE_PRESENT | _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t pte)
 {
 	return pte_val(pte) & (_PAGE_PRESENT);
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 611dd32..d772c9c 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -452,6 +452,7 @@ static inline int pte_present(pte_t a)
 			       _PAGE_NUMA);
 }
 
+#define pte_present_nonuma pte_present_nonuma
 static inline int pte_present_nonuma(pte_t a)
 {
 	return pte_flags(a) & (_PAGE_PRESENT | _PAGE_PROTNONE);
diff --git a/include/asm-generic/pgtable.h b/include/asm-generic/pgtable.h
index d2b92be..8916a76 100644
--- a/include/asm-generic/pgtable.h
+++ b/include/asm-generic/pgtable.h
@@ -220,6 +220,10 @@ static inline int pmd_same(pmd_t pmd_a, pmd_t pmd_b)
 # define pte_accessible(mm, pte)	((void)(pte), 1)
 #endif
 
+#ifndef pte_present_nonuma
+#define pte_present_nonuma(pte) pte_present(pte)
+#endif
+
 #ifndef flush_tlb_fix_spurious_fault
 #define flush_tlb_fix_spurious_fault(vma, address) flush_tlb_page(vma, address)
 #endif
