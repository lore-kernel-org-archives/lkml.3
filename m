Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754359AbaHTMI0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 08:08:26 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:58910 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752505AbaHTLoJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:09 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 031/104] x86/espfix/xen: Fix allocation of pages for paravirt page tables
Date: Wed, 20 Aug 2014 13:42:54 +0200
Message-Id: <9377a0c19fd479731713fca0e653d9d0d55f4415.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Boris Ostrovsky <boris.ostrovsky@oracle.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 8762e5092828c4dc0f49da5a47a644c670df77f3 upstream.

init_espfix_ap() is currently off by one level when informing hypervisor
that allocated pages will be used for ministacks' page tables.

The most immediate effect of this on a PV guest is that if
'stack_page = __get_free_page()' returns a non-zeroed-out page the hypervisor
will refuse to use it for a page table (which it shouldn't be anyway). This will
result in warnings by both Xen and Linux.

More importantly, a subsequent write to that page (again, by a PV guest) is
likely to result in fatal page fault.

Signed-off-by: Boris Ostrovsky <boris.ostrovsky@oracle.com>
Link: http://lkml.kernel.org/r/1404926298-5565-1-git-send-email-boris.ostrovsky@oracle.com
Reviewed-by: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/x86/kernel/espfix_64.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 6afbb16e9b79..94d857fb1033 100644
--- a/arch/x86/kernel/espfix_64.c
+++ b/arch/x86/kernel/espfix_64.c
@@ -175,7 +175,7 @@ void init_espfix_ap(void)
 	if (!pud_present(pud)) {
 		pmd_p = (pmd_t *)__get_free_page(PGALLOC_GFP);
 		pud = __pud(__pa(pmd_p) | (PGTABLE_PROT & ptemask));
-		paravirt_alloc_pud(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
+		paravirt_alloc_pmd(&init_mm, __pa(pmd_p) >> PAGE_SHIFT);
 		for (n = 0; n < ESPFIX_PUD_CLONES; n++)
 			set_pud(&pud_p[n], pud);
 	}
@@ -185,7 +185,7 @@ void init_espfix_ap(void)
 	if (!pmd_present(pmd)) {
 		pte_p = (pte_t *)__get_free_page(PGALLOC_GFP);
 		pmd = __pmd(__pa(pte_p) | (PGTABLE_PROT & ptemask));
-		paravirt_alloc_pmd(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
+		paravirt_alloc_pte(&init_mm, __pa(pte_p) >> PAGE_SHIFT);
 		for (n = 0; n < ESPFIX_PMD_CLONES; n++)
 			set_pmd(&pmd_p[n], pmd);
 	}
@@ -193,7 +193,6 @@ void init_espfix_ap(void)
 	pte_p = pte_offset_kernel(&pmd, addr);
 	stack_page = (void *)__get_free_page(GFP_KERNEL);
 	pte = __pte(__pa(stack_page) | (__PAGE_KERNEL_RO & ptemask));
-	paravirt_alloc_pte(&init_mm, __pa(stack_page) >> PAGE_SHIFT);
 	for (n = 0; n < ESPFIX_PTE_CLONES; n++)
 		set_pte(&pte_p[n*PTE_STRIDE], pte);
 
-- 
2.0.4

