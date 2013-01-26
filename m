Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755354Ab3AZBws (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jan 2013 20:52:48 -0500
Received: from terminus.zytor.com ([198.137.202.10]:48729 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754636Ab3AZBwq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jan 2013 20:52:46 -0500
Date: Fri, 25 Jan 2013 17:52:33 -0800
From: tip-bot for Dave Hansen <dave@linux.vnet.ibm.com>
Message-ID: <tip-4cbeb51b860c57ba8b2ae50c4016ee7a41f5fbd5@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        dave@linux.vnet.ibm.com, tglx@linutronix.de, hpa@linux.intel.com
In-Reply-To: <20130122212431.405D3A8C@kernel.stglabs.ibm.com>
References: <20130122212431.405D3A8C@kernel.stglabs.ibm.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/mm] x86, mm: Pagetable level size/shift/mask helpers
Git-Commit-ID: 4cbeb51b860c57ba8b2ae50c4016ee7a41f5fbd5
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 25 Jan 2013 17:52:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  4cbeb51b860c57ba8b2ae50c4016ee7a41f5fbd5
Gitweb:     http://git.kernel.org/tip/4cbeb51b860c57ba8b2ae50c4016ee7a41f5fbd5
Author:     Dave Hansen <dave@linux.vnet.ibm.com>
AuthorDate: Tue, 22 Jan 2013 13:24:31 -0800
Committer:  H. Peter Anvin <hpa@linux.intel.com>
CommitDate: Fri, 25 Jan 2013 16:33:22 -0800

x86, mm: Pagetable level size/shift/mask helpers

I plan to use lookup_address() to walk the kernel pagetables
in a later patch.  It returns a "pte" and the level in the
pagetables where the "pte" was found.  The level is just an
enum and needs to be converted to a useful value in order to
do address calculations with it.  These helpers will be used
in at least two places.

This also gives the anonymous enum a real name so that no one
gets confused about what they should be passing in to these
helpers.

"PTE_SHIFT" was chosen for naming consistency with the other
pagetable levels (PGD/PUD/PMD_SHIFT).

Cc: H. Peter Anvin <hpa@zytor.com>
Signed-off-by: Dave Hansen <dave@linux.vnet.ibm.com>
Link: http://lkml.kernel.org/r/20130122212431.405D3A8C@kernel.stglabs.ibm.com
Signed-off-by: H. Peter Anvin <hpa@linux.intel.com>
---
 arch/x86/include/asm/pgtable.h       | 14 ++++++++++++++
 arch/x86/include/asm/pgtable_types.h |  2 +-
 2 files changed, 15 insertions(+), 1 deletion(-)

diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5199db2..bc28e6f 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -390,6 +390,7 @@ pte_t *populate_extra_pte(unsigned long vaddr);
 
 #ifndef __ASSEMBLY__
 #include <linux/mm_types.h>
+#include <linux/log2.h>
 
 static inline int pte_none(pte_t pte)
 {
@@ -781,6 +782,19 @@ static inline void clone_pgd_range(pgd_t *dst, pgd_t *src, int count)
        memcpy(dst, src, count * sizeof(pgd_t));
 }
 
+#define PTE_SHIFT ilog2(PTRS_PER_PTE)
+static inline int page_level_shift(enum pg_level level)
+{
+	return (PAGE_SHIFT - PTE_SHIFT) + level * PTE_SHIFT;
+}
+static inline unsigned long page_level_size(enum pg_level level)
+{
+	return 1UL << page_level_shift(level);
+}
+static inline unsigned long page_level_mask(enum pg_level level)
+{
+	return ~(page_level_size(level) - 1);
+}
 
 #include <asm-generic/pgtable.h>
 #endif	/* __ASSEMBLY__ */
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 3c32db8..6c297e7 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -331,7 +331,7 @@ extern void native_pagetable_init(void);
 struct seq_file;
 extern void arch_report_meminfo(struct seq_file *m);
 
-enum {
+enum pg_level {
 	PG_LEVEL_NONE,
 	PG_LEVEL_4K,
 	PG_LEVEL_2M,
