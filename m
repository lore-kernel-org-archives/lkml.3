Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753523Ab3A3Bne (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 20:43:34 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43909 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751856Ab3A3Bnb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 20:43:31 -0500
Date: Tue, 29 Jan 2013 17:43:18 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-9ebdc79f7a177d3098b89ba8ef2dd2b235163685@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <1359058816-7615-24-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-24-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, kexec:
  Replace ident_mapping_init and init_level4_page
Git-Commit-ID: 9ebdc79f7a177d3098b89ba8ef2dd2b235163685
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 17:43:26 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9ebdc79f7a177d3098b89ba8ef2dd2b235163685
Gitweb:     http://git.kernel.org/tip/9ebdc79f7a177d3098b89ba8ef2dd2b235163685
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:04 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 15:26:29 -0800

x86, kexec: Replace ident_mapping_init and init_level4_page

Now ident_mapping_init is checking if pgd/pud is present for every 2M,
so several 2Ms are in same PUD, it will keep checking if pud is there
with same pud.

init_level4_page just does not check existing pgd/pud.

We could use generic mapping_init with different settings in info to
replace those two local grown version functions.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-24-git-send-email-yinghai@kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/kernel/machine_kexec_64.c | 161 ++++++-------------------------------
 1 file changed, 26 insertions(+), 135 deletions(-)

diff --git a/arch/x86/kernel/machine_kexec_64.c b/arch/x86/kernel/machine_kexec_64.c
index be14ee1..d2d7e02 100644
--- a/arch/x86/kernel/machine_kexec_64.c
+++ b/arch/x86/kernel/machine_kexec_64.c
@@ -16,144 +16,12 @@
 #include <linux/io.h>
 #include <linux/suspend.h>
 
+#include <asm/init.h>
 #include <asm/pgtable.h>
 #include <asm/tlbflush.h>
 #include <asm/mmu_context.h>
 #include <asm/debugreg.h>
 
-static int init_one_level2_page(struct kimage *image, pgd_t *pgd,
-				unsigned long addr)
-{
-	pud_t *pud;
-	pmd_t *pmd;
-	struct page *page;
-	int result = -ENOMEM;
-
-	addr &= PMD_MASK;
-	pgd += pgd_index(addr);
-	if (!pgd_present(*pgd)) {
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page)
-			goto out;
-		pud = (pud_t *)page_address(page);
-		clear_page(pud);
-		set_pgd(pgd, __pgd(__pa(pud) | _KERNPG_TABLE));
-	}
-	pud = pud_offset(pgd, addr);
-	if (!pud_present(*pud)) {
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page)
-			goto out;
-		pmd = (pmd_t *)page_address(page);
-		clear_page(pmd);
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
-	}
-	pmd = pmd_offset(pud, addr);
-	if (!pmd_present(*pmd))
-		set_pmd(pmd, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
-	result = 0;
-out:
-	return result;
-}
-
-static int ident_mapping_init(struct kimage *image, pgd_t *level4p,
-				unsigned long mstart, unsigned long mend)
-{
-	int result;
-
-	mstart = round_down(mstart, PMD_SIZE);
-	mend   = round_up(mend - 1, PMD_SIZE);
-
-	while (mstart < mend) {
-		result = init_one_level2_page(image, level4p, mstart);
-		if (result)
-			return result;
-
-		mstart += PMD_SIZE;
-	}
-
-	return 0;
-}
-
-static void init_level2_page(pmd_t *level2p, unsigned long addr)
-{
-	unsigned long end_addr;
-
-	addr &= PAGE_MASK;
-	end_addr = addr + PUD_SIZE;
-	while (addr < end_addr) {
-		set_pmd(level2p++, __pmd(addr | __PAGE_KERNEL_LARGE_EXEC));
-		addr += PMD_SIZE;
-	}
-}
-
-static int init_level3_page(struct kimage *image, pud_t *level3p,
-				unsigned long addr, unsigned long last_addr)
-{
-	unsigned long end_addr;
-	int result;
-
-	result = 0;
-	addr &= PAGE_MASK;
-	end_addr = addr + PGDIR_SIZE;
-	while ((addr < last_addr) && (addr < end_addr)) {
-		struct page *page;
-		pmd_t *level2p;
-
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page) {
-			result = -ENOMEM;
-			goto out;
-		}
-		level2p = (pmd_t *)page_address(page);
-		init_level2_page(level2p, addr);
-		set_pud(level3p++, __pud(__pa(level2p) | _KERNPG_TABLE));
-		addr += PUD_SIZE;
-	}
-	/* clear the unused entries */
-	while (addr < end_addr) {
-		pud_clear(level3p++);
-		addr += PUD_SIZE;
-	}
-out:
-	return result;
-}
-
-
-static int init_level4_page(struct kimage *image, pgd_t *level4p,
-				unsigned long addr, unsigned long last_addr)
-{
-	unsigned long end_addr;
-	int result;
-
-	result = 0;
-	addr &= PAGE_MASK;
-	end_addr = addr + (PTRS_PER_PGD * PGDIR_SIZE);
-	while ((addr < last_addr) && (addr < end_addr)) {
-		struct page *page;
-		pud_t *level3p;
-
-		page = kimage_alloc_control_pages(image, 0);
-		if (!page) {
-			result = -ENOMEM;
-			goto out;
-		}
-		level3p = (pud_t *)page_address(page);
-		result = init_level3_page(image, level3p, addr, last_addr);
-		if (result)
-			goto out;
-		set_pgd(level4p++, __pgd(__pa(level3p) | _KERNPG_TABLE));
-		addr += PGDIR_SIZE;
-	}
-	/* clear the unused entries */
-	while (addr < end_addr) {
-		pgd_clear(level4p++);
-		addr += PGDIR_SIZE;
-	}
-out:
-	return result;
-}
-
 static void free_transition_pgtable(struct kimage *image)
 {
 	free_page((unsigned long)image->arch.pud);
@@ -203,15 +71,37 @@ err:
 	return result;
 }
 
+static void *alloc_pgt_page(void *data)
+{
+	struct kimage *image = (struct kimage *)data;
+	struct page *page;
+	void *p = NULL;
+
+	page = kimage_alloc_control_pages(image, 0);
+	if (page) {
+		p = page_address(page);
+		clear_page(p);
+	}
+
+	return p;
+}
+
 static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 {
+	struct x86_mapping_info info = {
+		.alloc_pgt_page	= alloc_pgt_page,
+		.context	= image,
+		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
+	};
 	unsigned long mstart, mend;
 	pgd_t *level4p;
 	int result;
 	int i;
 
 	level4p = (pgd_t *)__va(start_pgtable);
-	result = init_level4_page(image, level4p, 0, max_pfn << PAGE_SHIFT);
+	clear_page(level4p);
+	result = kernel_ident_mapping_init(&info, level4p,
+						0, max_pfn << PAGE_SHIFT);
 	if (result)
 		return result;
 
@@ -225,7 +115,8 @@ static int init_pgtable(struct kimage *image, unsigned long start_pgtable)
 		mstart = image->segment[i].mem;
 		mend   = mstart + image->segment[i].memsz;
 
-		result = ident_mapping_init(image, level4p, mstart, mend);
+		result = kernel_ident_mapping_init(&info,
+						 level4p, mstart, mend);
 
 		if (result)
 			return result;
