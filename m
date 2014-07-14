Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757466AbaGNWZV (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Jul 2014 18:25:21 -0400
Received: from terminus.zytor.com ([198.137.202.10]:47123 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756734AbaGNWZT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Jul 2014 18:25:19 -0400
Date: Mon, 14 Jul 2014 15:25:07 -0700
From: tip-bot for Boris Ostrovsky <tipbot@zytor.com>
Message-ID: <tip-8762e5092828c4dc0f49da5a47a644c670df77f3@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stable@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, boris.ostrovsky@oracle.com,
        stable@vger.kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1404926298-5565-1-git-send-email-boris.ostrovsky@oracle.com>
References: <1404926298-5565-1-git-send-email-boris.ostrovsky@oracle.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/espfix/xen:
  Fix allocation of pages for paravirt page tables
Git-Commit-ID: 8762e5092828c4dc0f49da5a47a644c670df77f3
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8762e5092828c4dc0f49da5a47a644c670df77f3
Gitweb:     http://git.kernel.org/tip/8762e5092828c4dc0f49da5a47a644c670df77f3
Author:     Boris Ostrovsky <boris.ostrovsky@oracle.com>
AuthorDate: Wed, 9 Jul 2014 13:18:18 -0400
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Mon, 14 Jul 2014 13:47:32 -0700

x86/espfix/xen: Fix allocation of pages for paravirt page tables

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
Cc: <stable@vger.kernel.org>
---
 arch/x86/kernel/espfix_64.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/arch/x86/kernel/espfix_64.c b/arch/x86/kernel/espfix_64.c
index 6afbb16..94d857f 100644
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
 
