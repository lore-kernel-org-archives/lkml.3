Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751558AbaIUP1T (ORCPT <rfc822;w@1wt.eu>);
	Sun, 21 Sep 2014 11:27:19 -0400
Received: from mail-we0-f179.google.com ([74.125.82.179]:50635 "EHLO
	mail-we0-f179.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751421AbaIUP1N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 21 Sep 2014 11:27:13 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCHv2 3/3] x86, ptdump: Take parent page flags into account
Date: Sun, 21 Sep 2014 17:26:56 +0200
Message-Id: <1411313216-2641-4-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
References: <1411313216-2641-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We currently ignore the flags of parent entries when evaluating the
flags of a given page table entry in printk_prot(). This might lead to
wrong results when a particular flag in a parent entry differs from the
one of the current page table entry. So, we might show memory regions as
writable even if not all parent entries have the _PAGE_RW bit set. The
same is true for the _PAGE_USER and _PAGE_NX flags. There values in
upper levels of the hierarchy influence the effective access rights but
are ignored in printk_prot().

To handle those cases, track the effective flags for _PAGE_USER,
_PAGE_RW and _PAGE_NX throughout the page table walk and take them into
account when printing a page table entry's flags.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
The kernel currently does not do such a thing as having a parent page
table entry having stricter flags set than the final page table entry
itself. But we might start doing so in the future. Even if not, better
be correct and safe here, then sorry for printing wrong results. This is
a debugging tool that should aid the developer, not lie to him.

This patch, in fact, helped me to debug some EFI runtime service mapping
related problems where the _PAGE_NX bit was set in the PGD entry but
ignored when shown via /sys/kernel/debug/kernel_page_tables.

v2: - same as v1, beside s/ptd_/pt_dump_/
---
 arch/x86/mm/dump_pagetables.c |   72 ++++++++++++++++++++++-----------
 1 file changed, 48 insertions(+), 24 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0c3680332fcc..5c8b850a838d 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -118,11 +118,26 @@ static struct addr_marker address_markers[] = {
 				seq_printf(m, fmt, ##args);	\
 	} while (0)
 
+static pgprot_t effective_prot(pgprot_t parent_prot, pgprot_t new_prot)
+{
+	pgprotval_t pv_parent = pgprot_val(parent_prot) & PTE_FLAGS_MASK;
+	pgprotval_t pv_new = pgprot_val(new_prot) & PTE_FLAGS_MASK;
+	pgprotval_t pv_effective = 0;
+
+	pv_effective |= (pv_parent & pv_new) & _PAGE_USER;
+	pv_effective |= (pv_parent & pv_new) & _PAGE_RW;
+	pv_effective |= (pv_parent | pv_new) & _PAGE_NX;
+
+	return __pgprot(pv_effective);
+}
+
 /*
  * Print a readable form of a pgprot_t to the seq_file
  */
-static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
+static void printk_prot(struct seq_file *m, pgprot_t eff_prot, pgprot_t prot,
+			int level, bool dmsg)
 {
+	pgprotval_t pr_eff = pgprot_val(effective_prot(eff_prot, prot));
 	pgprotval_t pr = pgprot_val(prot);
 	static const char * const level_name[] =
 		{ "cr3", "pgd", "pud", "pmd", "pte" };
@@ -131,8 +146,8 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 		/* Not present */
 		pt_dump_cont(m, dmsg, "%-26s", "");
 	} else {
-		pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_USER ? "USR" : "");
-		pt_dump_cont(m, dmsg, "%-3s", pr & _PAGE_RW ? "RW" : "ro");
+		pt_dump_cont(m, dmsg, "%-4s", pr_eff & _PAGE_USER ? "USR" : "");
+		pt_dump_cont(m, dmsg, "%-3s", pr_eff & _PAGE_RW ? "RW" : "ro");
 		pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_PWT ? "PWT" : "");
 		pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_PCD ? "PCD" : "");
 
@@ -143,7 +158,7 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 			pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_PAT ? "pat" : "");
 
 		pt_dump_cont(m, dmsg, "%-4s", pr & _PAGE_GLOBAL ? "GLB" : "");
-		pt_dump_cont(m, dmsg, "%-3s", pr & _PAGE_NX ? "NX" : "x");
+		pt_dump_cont(m, dmsg, "%-3s", pr_eff & _PAGE_NX ? "NX" : "x");
 	}
 	pt_dump_cont(m, dmsg, "%s\n", level_name[level]);
 }
@@ -166,7 +181,7 @@ static unsigned long normalize_addr(unsigned long u)
  * print what we collected so far.
  */
 static void note_page(struct seq_file *m, struct pg_state *st,
-		      pgprot_t new_prot, int level)
+		      pgprot_t eff_prot, pgprot_t new_prot, int level)
 {
 	pgprotval_t prot, cur;
 	static const char units[] = "BKMGTPE";
@@ -208,7 +223,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 				unit++;
 			}
 			pt_dump_cont(m, st->to_dmesg, "%9lu%c ", delta, *unit);
-			printk_prot(m, st->current_prot, st->level,
+			printk_prot(m, eff_prot, st->current_prot, st->level,
 				    st->to_dmesg);
 		}
 		st->lines++;
@@ -240,7 +255,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 }
 
 static void walk_pte_level(struct seq_file *m, struct pg_state *st, pmd_t addr,
-							unsigned long P)
+			   pgprot_t eff_prot, unsigned long P)
 {
 	int i;
 	pte_t *start;
@@ -250,7 +265,7 @@ static void walk_pte_level(struct seq_file *m, struct pg_state *st, pmd_t addr,
 		pgprot_t prot = pte_pgprot(*start);
 
 		st->current_address = normalize_addr(P + i * PTE_LEVEL_MULT);
-		note_page(m, st, prot, 4);
+		note_page(m, st, eff_prot, prot, 4);
 		start++;
 	}
 }
@@ -258,7 +273,7 @@ static void walk_pte_level(struct seq_file *m, struct pg_state *st, pmd_t addr,
 #if PTRS_PER_PMD > 1
 
 static void walk_pmd_level(struct seq_file *m, struct pg_state *st, pud_t addr,
-							unsigned long P)
+			   pgprot_t eff_prot, unsigned long P)
 {
 	int i;
 	pmd_t *start;
@@ -267,21 +282,23 @@ static void walk_pmd_level(struct seq_file *m, struct pg_state *st, pud_t addr,
 	for (i = 0; i < PTRS_PER_PMD; i++) {
 		st->current_address = normalize_addr(P + i * PMD_LEVEL_MULT);
 		if (!pmd_none(*start)) {
-			pgprotval_t prot = pmd_val(*start) & PTE_FLAGS_MASK;
+			pgprotval_t prot_val = pmd_val(*start) & PTE_FLAGS_MASK;
+			pgprot_t prot = __pgprot(prot_val);
 
 			if (pmd_large(*start) || !pmd_present(*start))
-				note_page(m, st, __pgprot(prot), 3);
+				note_page(m, st, eff_prot, prot, 3);
 			else
 				walk_pte_level(m, st, *start,
+					       effective_prot(eff_prot, prot),
 					       P + i * PMD_LEVEL_MULT);
 		} else
-			note_page(m, st, __pgprot(0), 3);
+			note_page(m, st, eff_prot, __pgprot(0), 3);
 		start++;
 	}
 }
 
 #else
-#define walk_pmd_level(m,s,a,p) walk_pte_level(m,s,__pmd(pud_val(a)),p)
+#define walk_pmd_level(m,s,a,e,p) walk_pte_level(m,s,__pmd(pud_val(a)),e,p)
 #define pud_large(a) pmd_large(__pmd(pud_val(a)))
 #define pud_none(a)  pmd_none(__pmd(pud_val(a)))
 #endif
@@ -289,7 +306,7 @@ static void walk_pmd_level(struct seq_file *m, struct pg_state *st, pud_t addr,
 #if PTRS_PER_PUD > 1
 
 static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
-							unsigned long P)
+			   pgprot_t eff_prot, unsigned long P)
 {
 	int i;
 	pud_t *start;
@@ -299,22 +316,24 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
 	for (i = 0; i < PTRS_PER_PUD; i++) {
 		st->current_address = normalize_addr(P + i * PUD_LEVEL_MULT);
 		if (!pud_none(*start)) {
-			pgprotval_t prot = pud_val(*start) & PTE_FLAGS_MASK;
+			pgprotval_t prot_val = pud_val(*start) & PTE_FLAGS_MASK;
+			pgprot_t prot = __pgprot(prot_val);
 
 			if (pud_large(*start) || !pud_present(*start))
-				note_page(m, st, __pgprot(prot), 2);
+				note_page(m, st, eff_prot, prot, 2);
 			else
 				walk_pmd_level(m, st, *start,
+					       effective_prot(eff_prot, prot),
 					       P + i * PUD_LEVEL_MULT);
 		} else
-			note_page(m, st, __pgprot(0), 2);
+			note_page(m, st, eff_prot, __pgprot(0), 2);
 
 		start++;
 	}
 }
 
 #else
-#define walk_pud_level(m,s,a,p) walk_pmd_level(m,s,__pud(pgd_val(a)),p)
+#define walk_pud_level(m,s,a,e,p) walk_pmd_level(m,s,__pud(pgd_val(a)),e,p)
 #define pgd_large(a) pud_large(__pud(pgd_val(a)))
 #define pgd_none(a)  pud_none(__pud(pgd_val(a)))
 #endif
@@ -328,6 +347,7 @@ void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd)
 #endif
 	int i;
 	struct pg_state st = {};
+	pgprot_t eff_prot = __pgprot(0);
 
 	if (pgd) {
 		start = pgd;
@@ -337,22 +357,26 @@ void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd)
 	for (i = 0; i < PTRS_PER_PGD; i++) {
 		st.current_address = normalize_addr(i * PGD_LEVEL_MULT);
 		if (!pgd_none(*start)) {
-			pgprotval_t prot = pgd_val(*start) & PTE_FLAGS_MASK;
+			pgprotval_t prot_val = pgd_val(*start) & PTE_FLAGS_MASK;
+			pgprot_t prot = __pgprot(prot_val);
 
+			eff_prot = effective_prot(prot, prot);
 			if (pgd_large(*start) || !pgd_present(*start))
-				note_page(m, &st, __pgprot(prot), 1);
+				note_page(m, &st, eff_prot, prot, 1);
 			else
-				walk_pud_level(m, &st, *start,
+				walk_pud_level(m, &st, *start, eff_prot,
 					       i * PGD_LEVEL_MULT);
-		} else
-			note_page(m, &st, __pgprot(0), 1);
+		} else {
+			eff_prot = __pgprot(0);
+			note_page(m, &st, eff_prot, __pgprot(0), 1);
+		}
 
 		start++;
 	}
 
 	/* Flush out the last page */
 	st.current_address = normalize_addr(PTRS_PER_PGD*PGD_LEVEL_MULT);
-	note_page(m, &st, __pgprot(0), 0);
+	note_page(m, &st, eff_prot, __pgprot(0), 0);
 }
 
 static int ptdump_show(struct seq_file *m, void *v)
-- 
1.7.10.4

