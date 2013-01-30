Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753699Ab3A3D4l (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 22:56:41 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44956 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753256Ab3A3D4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 22:56:40 -0500
Date: Tue, 29 Jan 2013 19:56:18 -0800
From: tip-bot for Yinghai Lu <yinghai@kernel.org>
Message-ID: <tip-8b78c21d72d9dbcb7230e97423a2cd8d8402c20c@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yinghai@kernel.org, pavel@ucw.cz, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yinghai@kernel.org, pavel@ucw.cz, tglx@linutronix.de, rjw@sisk.pl,
        hpa@linux.intel.com
In-Reply-To: <1359058816-7615-34-git-send-email-yinghai@kernel.org>
References: <1359058816-7615-34-git-send-email-yinghai@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm2] x86, 64bit, mm: hibernate use generic mapping_init
Git-Commit-ID: 8b78c21d72d9dbcb7230e97423a2cd8d8402c20c
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Tue, 29 Jan 2013 19:56:25 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  8b78c21d72d9dbcb7230e97423a2cd8d8402c20c
Gitweb:     http://git.kernel.org/tip/8b78c21d72d9dbcb7230e97423a2cd8d8402c20c
Author:     Yinghai Lu <yinghai@kernel.org>
AuthorDate: Thu, 24 Jan 2013 12:20:14 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Tue, 29 Jan 2013 19:32:59 -0800

x86, 64bit, mm: hibernate use generic mapping_init

We should set mappings only for usable memory ranges under max_pfn
Otherwise causes same problem that is fixed by

	x86, mm: Only direct map addresses that are marked as E820_RAM

Make it only map range in pfn_mapped array.

Signed-off-by: Yinghai Lu <yinghai@kernel.org>
Link: http://lkml.kernel.org/r/1359058816-7615-34-git-send-email-yinghai@kernel.org
Cc: Pavel Machek <pavel@ucw.cz>
Cc: Rafael J. Wysocki <rjw@sisk.pl>
Cc: linux-pm@vger.kernel.org
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/power/hibernate_64.c | 66 +++++++++++++++----------------------------
 1 file changed, 22 insertions(+), 44 deletions(-)

diff --git a/arch/x86/power/hibernate_64.c b/arch/x86/power/hibernate_64.c
index 460f314..a0fde91 100644
--- a/arch/x86/power/hibernate_64.c
+++ b/arch/x86/power/hibernate_64.c
@@ -11,6 +11,8 @@
 #include <linux/gfp.h>
 #include <linux/smp.h>
 #include <linux/suspend.h>
+
+#include <asm/init.h>
 #include <asm/proto.h>
 #include <asm/page.h>
 #include <asm/pgtable.h>
@@ -39,41 +41,21 @@ pgd_t *temp_level4_pgt;
 
 void *relocated_restore_code;
 
-static int res_phys_pud_init(pud_t *pud, unsigned long address, unsigned long end)
+static void *alloc_pgt_page(void *context)
 {
-	long i, j;
-
-	i = pud_index(address);
-	pud = pud + i;
-	for (; i < PTRS_PER_PUD; pud++, i++) {
-		unsigned long paddr;
-		pmd_t *pmd;
-
-		paddr = address + i*PUD_SIZE;
-		if (paddr >= end)
-			break;
-
-		pmd = (pmd_t *)get_safe_page(GFP_ATOMIC);
-		if (!pmd)
-			return -ENOMEM;
-		set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
-		for (j = 0; j < PTRS_PER_PMD; pmd++, j++, paddr += PMD_SIZE) {
-			unsigned long pe;
-
-			if (paddr >= end)
-				break;
-			pe = __PAGE_KERNEL_LARGE_EXEC | paddr;
-			pe &= __supported_pte_mask;
-			set_pmd(pmd, __pmd(pe));
-		}
-	}
-	return 0;
+	return (void *)get_safe_page(GFP_ATOMIC);
 }
 
 static int set_up_temporary_mappings(void)
 {
-	unsigned long start, end, next;
-	int error;
+	struct x86_mapping_info info = {
+		.alloc_pgt_page	= alloc_pgt_page,
+		.pmd_flag	= __PAGE_KERNEL_LARGE_EXEC,
+		.kernel_mapping = true,
+	};
+	unsigned long mstart, mend;
+	int result;
+	int i;
 
 	temp_level4_pgt = (pgd_t *)get_safe_page(GFP_ATOMIC);
 	if (!temp_level4_pgt)
@@ -84,21 +66,17 @@ static int set_up_temporary_mappings(void)
 		init_level4_pgt[pgd_index(__START_KERNEL_map)]);
 
 	/* Set up the direct mapping from scratch */
-	start = (unsigned long)pfn_to_kaddr(0);
-	end = (unsigned long)pfn_to_kaddr(max_pfn);
-
-	for (; start < end; start = next) {
-		pud_t *pud = (pud_t *)get_safe_page(GFP_ATOMIC);
-		if (!pud)
-			return -ENOMEM;
-		next = start + PGDIR_SIZE;
-		if (next > end)
-			next = end;
-		if ((error = res_phys_pud_init(pud, __pa(start), __pa(next))))
-			return error;
-		set_pgd(temp_level4_pgt + pgd_index(start),
-			mk_kernel_pgd(__pa(pud)));
+	for (i = 0; i < nr_pfn_mapped; i++) {
+		mstart = pfn_mapped[i].start << PAGE_SHIFT;
+		mend   = pfn_mapped[i].end << PAGE_SHIFT;
+
+		result = kernel_ident_mapping_init(&info, temp_level4_pgt,
+						   mstart, mend);
+
+		if (result)
+			return result;
 	}
+
 	return 0;
 }
 
