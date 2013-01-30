Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753357Ab3A3Bas (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:30:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43726 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751818Ab3A3Bap (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:30:45 -0500
Date: Tue, 29 Jan 2013 17:30:32 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-6b9c75aca6cba4d99a6e8d8274b1788d4d4b50d9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, alexander.h.duyck@intel.com, tglx@linutronix.de,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-13-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-13-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, 64bit:
  #PF handler set page to cover only 2M per #PF
Git-Commit-ID: 6b9c75aca6cba4d99a6e8d8274b1788d4d4b50d9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:30:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  6b9c75aca6cba4d99a6e8d8274b1788d4d4b50d9
Gitweb:     http://git.kernel.org/tip/6b9c75aca6cba4d99a6e8d8274b1788d4d4b50d9
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:19:53 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:20:13 -0800

x86, 64bit: #PF handler set page to cover only 2M per #PF

We only map a single 2 MiB page per #PF, even though we should be able
to do this a full gigabyte at a time with no additional memory cost.
This is a workaround for a broken AMD reference BIOS (and its
derivatives in shipping system) which maps a large chunk of memory as
WB in the MTRR system but will #MC if the processor wanders off and
tries to prefetch that memory, which can happen any time the memory is
mapped in the TLB.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-13-git-send-email-yinghai@kernel.org
Cc: Alexander Duyck <alexander.h.duyck@intel.com>
[ hpa: rewrote the patch description ]
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/head64.c | 42 +++++++++++++++++++++++++-----------------
 1 file changed, 25 insertions(+), 17 deletions(-)

diff --git a/arch/x86/kernel/head64.c b/arch/x86/kernel/head64.c
index f57df05..816fc85 100644
--- a/arch/x86/kernel/head64.c
+++ b/arch/x86/kernel/head64.c
@@ -53,15 +53,15 @@ int __init early_make_pgtable(unsigned long address)
 	unsigned long physaddr = address - __PAGE_OFFSET;
 	unsigned long i;
 	pgdval_t pgd, *pgd_p;
-	pudval_t *pud_p;
+	pudval_t pud, *pud_p;
 	pmdval_t pmd, *pmd_p;
 
 	/* Invalid address or early pgt is done ?  */
 	if (physaddr >= MAXMEM || read_cr3() != __pa(early_level4_pgt))
 		return -1;
 
-	i = (address >> PGDIR_SHIFT) & (PTRS_PER_PGD - 1);
-	pgd_p = &early_level4_pgt[i].pgd;
+again:
+	pgd_p = &early_level4_pgt[pgd_index(address)].pgd;
 	pgd = *pgd_p;
 
 	/*
@@ -69,29 +69,37 @@ int __init early_make_pgtable(unsigned long address)
 	 * critical -- __PAGE_OFFSET would point us back into the dynamic
 	 * range and we might end up looping forever...
 	 */
-	if (pgd && next_early_pgt < EARLY_DYNAMIC_PAGE_TABLES) {
+	if (pgd)
 		pud_p = (pudval_t *)((pgd & PTE_PFN_MASK) + __START_KERNEL_map - phys_base);
-	} else {
-		if (next_early_pgt >= EARLY_DYNAMIC_PAGE_TABLES-1)
+	else {
+		if (next_early_pgt >= EARLY_DYNAMIC_PAGE_TABLES) {
 			reset_early_page_tables();
+			goto again;
+		}
 
 		pud_p = (pudval_t *)early_dynamic_pgts[next_early_pgt++];
 		for (i = 0; i < PTRS_PER_PUD; i++)
 			pud_p[i] = 0;
-
 		*pgd_p = (pgdval_t)pud_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
 	}
-	i = (address >> PUD_SHIFT) & (PTRS_PER_PUD - 1);
-	pud_p += i;
-
-	pmd_p = (pmdval_t *)early_dynamic_pgts[next_early_pgt++];
-	pmd = (physaddr & PUD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
-	for (i = 0; i < PTRS_PER_PMD; i++) {
-		pmd_p[i] = pmd;
-		pmd += PMD_SIZE;
-	}
+	pud_p += pud_index(address);
+	pud = *pud_p;
 
-	*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
+	if (pud)
+		pmd_p = (pmdval_t *)((pud & PTE_PFN_MASK) + __START_KERNEL_map - phys_base);
+	else {
+		if (next_early_pgt >= EARLY_DYNAMIC_PAGE_TABLES) {
+			reset_early_page_tables();
+			goto again;
+		}
+
+		pmd_p = (pmdval_t *)early_dynamic_pgts[next_early_pgt++];
+		for (i = 0; i < PTRS_PER_PMD; i++)
+			pmd_p[i] = 0;
+		*pud_p = (pudval_t)pmd_p - __START_KERNEL_map + phys_base + _KERNPG_TABLE;
+	}
+	pmd = (physaddr & PMD_MASK) + (__PAGE_KERNEL_LARGE & ~_PAGE_GLOBAL);
+	pmd_p[pmd_index(address)] = pmd;
 
 	return 0;
 }
