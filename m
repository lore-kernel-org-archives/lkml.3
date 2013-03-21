Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751394Ab3CURRI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 13:17:08 -0400
Received: from mail.skyhub.de ([78.46.96.112]:36398 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1750916Ab3CURRF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 13:17:05 -0400
From: Borislav Petkov <bp@alien8.de>
To: X86 ML <x86@kernel.org>
Cc: LKML <linux-kernel@vger.kernel.org>, Borislav Petkov <bp@suse.de>
Subject: [PATCH] x86, cpa: Cleanup split_large_page and its callee
Date: Thu, 21 Mar 2013 18:16:57 +0100
Message-Id: <1363886217-24703-1-git-send-email-bp@alien8.de>
X-Mailer: git-send-email 1.8.1.3.535.ga923c31
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@suse.de>

So basically we're generating the pte_t * from a struct page and we're
handing it down to the __split_large_page internal version which then
goes and gets back struct page * from it because it needs it.

Change the caller to hand down struct page * directly and the callee can
compute the pte_t itself.

Net save is one virt_to_page() call and simpler code. While at it, make
__split_large_page static.

Signed-off-by: Borislav Petkov <bp@suse.de>
---
 arch/x86/include/asm/pgtable_types.h | 1 -
 arch/x86/mm/pageattr.c               | 9 ++++-----
 2 files changed, 4 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 567b5d0632b2..e6423002c10b 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -351,7 +351,6 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
-extern int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 
 #endif	/* !__ASSEMBLY__ */
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index 091934e1d0d9..25b1d35c76cb 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -542,13 +542,14 @@ out_unlock:
 	return do_split;
 }
 
-int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
+static int
+__split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 {
+	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned long pfn, pfninc = 1;
 	unsigned int i, level;
 	pte_t *tmp;
 	pgprot_t ref_prot;
-	struct page *base = virt_to_page(pbase);
 
 	spin_lock(&pgd_lock);
 	/*
@@ -633,7 +634,6 @@ int __split_large_page(pte_t *kpte, unsigned long address, pte_t *pbase)
 
 static int split_large_page(pte_t *kpte, unsigned long address)
 {
-	pte_t *pbase;
 	struct page *base;
 
 	if (!debug_pagealloc)
@@ -644,8 +644,7 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	pbase = (pte_t *)page_address(base);
-	if (__split_large_page(kpte, address, pbase))
+	if (__split_large_page(kpte, address, base))
 		__free_page(base);
 
 	return 0;
-- 
1.8.1.3.535.ga923c31

