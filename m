Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932173AbaITVX3 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Sep 2014 17:23:29 -0400
Received: from mail-wg0-f48.google.com ([74.125.82.48]:52769 "EHLO
	mail-wg0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757945AbaITVXP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Sep 2014 17:23:15 -0400
From: Mathias Krause <minipli@googlemail.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>
Cc: linux-kernel@vger.kernel.org, x86@kernel.org,
        Mathias Krause <minipli@googlemail.com>,
        Arjan van de Ven <arjan@linux.intel.com>
Subject: [PATCH 2/3] x86, ptdump: Simplify page flag evaluation code
Date: Sat, 20 Sep 2014 23:22:21 +0200
Message-Id: <1411248142-28951-3-git-send-email-minipli@googlemail.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1411248142-28951-1-git-send-email-minipli@googlemail.com>
References: <1411248142-28951-1-git-send-email-minipli@googlemail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The code evaluating the page flags is rather scattered. Simplify it by
folding the 'if .. else ..' part into the actual print call. Make use
of appropriate format strings to get the desired string width.

Also change the pt_dump_seq_printf() and pt_dump_cont_printf() macros to
use the common 'do ... while(0)' pattern instead of a compound statement
expression. We don't need no expression, just the statement.

Last, but not least, fix the checkpatch warnings for the lines touched.

Signed-off-by: Mathias Krause <minipli@googlemail.com>
Cc: Arjan van de Ven <arjan@linux.intel.com>
Cc: H. Peter Anvin <hpa@zytor.com>
---
 arch/x86/mm/dump_pagetables.c |  106 ++++++++++++---------------------
 1 file changed, 39 insertions(+), 67 deletions(-)

diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 1a8053d1012e..f7af11c7e83f 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -100,23 +100,23 @@ static struct addr_marker address_markers[] = {
 #define PUD_LEVEL_MULT (PTRS_PER_PMD * PMD_LEVEL_MULT)
 #define PGD_LEVEL_MULT (PTRS_PER_PUD * PUD_LEVEL_MULT)
 
-#define pt_dump_seq_printf(m, to_dmesg, fmt, args...)		\
-({								\
-	if (to_dmesg)					\
-		printk(KERN_INFO fmt, ##args);			\
-	else							\
-		if (m)						\
-			seq_printf(m, fmt, ##args);		\
-})
-
-#define pt_dump_cont_printf(m, to_dmesg, fmt, args...)		\
-({								\
-	if (to_dmesg)					\
-		printk(KERN_CONT fmt, ##args);			\
-	else							\
-		if (m)						\
-			seq_printf(m, fmt, ##args);		\
-})
+#define ptd_print(m, to_dmesg, fmt, args...)			\
+	do {							\
+		if (to_dmesg)					\
+			pr_info(fmt, ##args);			\
+		else						\
+			if (m)					\
+				seq_printf(m, fmt, ##args);	\
+	} while (0)
+
+#define ptd_cont(m, to_dmesg, fmt, args...)			\
+	do {							\
+		if (to_dmesg)					\
+			pr_cont(fmt, ##args);			\
+		else						\
+			if (m)					\
+				seq_printf(m, fmt, ##args);	\
+	} while (0)
 
 /*
  * Print a readable form of a pgprot_t to the seq_file
@@ -129,47 +129,23 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 
 	if (!pgprot_val(prot)) {
 		/* Not present */
-		pt_dump_cont_printf(m, dmsg, "                          ");
+		ptd_cont(m, dmsg, "%-26s", "");
 	} else {
-		if (pr & _PAGE_USER)
-			pt_dump_cont_printf(m, dmsg, "USR ");
-		else
-			pt_dump_cont_printf(m, dmsg, "    ");
-		if (pr & _PAGE_RW)
-			pt_dump_cont_printf(m, dmsg, "RW ");
-		else
-			pt_dump_cont_printf(m, dmsg, "ro ");
-		if (pr & _PAGE_PWT)
-			pt_dump_cont_printf(m, dmsg, "PWT ");
-		else
-			pt_dump_cont_printf(m, dmsg, "    ");
-		if (pr & _PAGE_PCD)
-			pt_dump_cont_printf(m, dmsg, "PCD ");
-		else
-			pt_dump_cont_printf(m, dmsg, "    ");
+		ptd_cont(m, dmsg, "%-4s", pr & _PAGE_USER ? "USR" : "");
+		ptd_cont(m, dmsg, "%-3s", pr & _PAGE_RW ? "RW" : "ro");
+		ptd_cont(m, dmsg, "%-4s", pr & _PAGE_PWT ? "PWT" : "");
+		ptd_cont(m, dmsg, "%-4s", pr & _PAGE_PCD ? "PCD" : "");
 
 		/* Bit 9 has a different meaning on level 3 vs 4 */
-		if (level <= 3) {
-			if (pr & _PAGE_PSE)
-				pt_dump_cont_printf(m, dmsg, "PSE ");
-			else
-				pt_dump_cont_printf(m, dmsg, "    ");
-		} else {
-			if (pr & _PAGE_PAT)
-				pt_dump_cont_printf(m, dmsg, "pat ");
-			else
-				pt_dump_cont_printf(m, dmsg, "    ");
-		}
-		if (pr & _PAGE_GLOBAL)
-			pt_dump_cont_printf(m, dmsg, "GLB ");
+		if (level <= 3)
+			ptd_cont(m, dmsg, "%-4s", pr & _PAGE_PSE ? "PSE" : "");
 		else
-			pt_dump_cont_printf(m, dmsg, "    ");
-		if (pr & _PAGE_NX)
-			pt_dump_cont_printf(m, dmsg, "NX ");
-		else
-			pt_dump_cont_printf(m, dmsg, "x  ");
+			ptd_cont(m, dmsg, "%-4s", pr & _PAGE_PAT ? "pat" : "");
+
+		ptd_cont(m, dmsg, "%-4s", pr & _PAGE_GLOBAL ? "GLB" : "");
+		ptd_cont(m, dmsg, "%-3s", pr & _PAGE_NX ? "NX" : "x");
 	}
-	pt_dump_cont_printf(m, dmsg, "%s\n", level_name[level]);
+	ptd_cont(m, dmsg, "%s\n", level_name[level]);
 }
 
 /*
@@ -209,8 +185,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		st->level = level;
 		st->marker = address_markers;
 		st->lines = 0;
-		pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
-				   st->marker->name);
+		ptd_print(m, st->to_dmesg, "---[ %s ]---\n", st->marker->name);
 	} else if (prot != cur || level != st->level ||
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
@@ -222,18 +197,16 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		 */
 		if (!st->marker->max_lines ||
 		    st->lines < st->marker->max_lines) {
-			pt_dump_seq_printf(m, st->to_dmesg,
-					   "0x%0*lx-0x%0*lx   ",
-					   width, st->start_address,
-					   width, st->current_address);
+			ptd_print(m, st->to_dmesg, "0x%0*lx-0x%0*lx   ",
+				  width, st->start_address,
+				  width, st->current_address);
 
 			delta = st->current_address - st->start_address;
 			while (!(delta & 1023) && unit[1]) {
 				delta >>= 10;
 				unit++;
 			}
-			pt_dump_cont_printf(m, st->to_dmesg, "%9lu%c ",
-					    delta, *unit);
+			ptd_cont(m, st->to_dmesg, "%9lu%c ", delta, *unit);
 			printk_prot(m, st->current_prot, st->level,
 				    st->to_dmesg);
 		}
@@ -249,15 +222,14 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 			    st->lines > st->marker->max_lines) {
 				unsigned long nskip =
 					st->lines - st->marker->max_lines;
-				pt_dump_seq_printf(m, st->to_dmesg,
-						   "... %lu entr%s skipped ... \n",
-						   nskip,
-						   nskip == 1 ? "y" : "ies");
+				ptd_print(m, st->to_dmesg,
+					  "... %lu entr%s skipped ...\n",
+					  nskip, nskip == 1 ? "y" : "ies");
 			}
 			st->marker++;
 			st->lines = 0;
-			pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
-					   st->marker->name);
+			ptd_print(m, st->to_dmesg, "---[ %s ]---\n",
+				  st->marker->name);
 		}
 
 		st->start_address = st->current_address;
-- 
1.7.10.4

