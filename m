Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751969Ab3LLUfs (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 15:35:48 -0500
Received: from mail.skyhub.de ([78.46.96.112]:51523 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751674Ab3LLUfp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 15:35:45 -0500
Date: Thu, 12 Dec 2013 21:35:34 +0100
From: Borislav Petkov <bp@alien8.de>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
Message-ID: <20131212203533.GB26927@pd.tnic>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
 <20131212002946.GF8863@pd.tnic>
 <1386808323.1791.299.camel@misato.fc.hp.com>
 <1386810484.1791.306.camel@misato.fc.hp.com>
 <1386810620.1791.307.camel@misato.fc.hp.com>
 <20131212162351.GA26927@pd.tnic>
 <1386866583.1791.310.camel@misato.fc.hp.com>
 <1386869221.1791.311.camel@misato.fc.hp.com>
 <1386869777.1791.314.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386869777.1791.314.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Dec 12, 2013 at 10:36:17AM -0700, Toshi Kani wrote:
> BTW, the test system is shared and will be used by other test for a
> couple of hours or so. So, please take your time. :-)

Yeah, ok :-)

I went and polished the debugging patch a bit more - it seems we're
going to need it more often now, should probably send it up too :)

Right, so the pagetable dump shows that the new_memmap is not mapped in
it, thus the #PF.

Ok, so next try: let's dump the pagetable after we've copied the pgd
containing new_memmap. Same exercise as before, please.

Thanks.

---
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3d1999458709..507f62647e39 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -16,6 +16,12 @@
 
 #ifndef __ASSEMBLY__
 
+struct ptdump_desc {
+	pgd_t *pgd;
+	bool to_dmesg;
+};
+int ptdump_show(struct seq_file *m, void *v);
+
 #include <asm/x86_init.h>
 
 /*
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0002a3a33081..29e55d644727 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -19,6 +19,8 @@
 
 #include <asm/pgtable.h>
 
+bool dump_to_dmesg;
+
 /*
  * The dumper groups pagetable entries of the same type into one, and for
  * that it needs to keep some state when walking, and flush this state
@@ -88,6 +90,24 @@ static struct addr_marker address_markers[] = {
 #define PUD_LEVEL_MULT (PTRS_PER_PMD * PMD_LEVEL_MULT)
 #define PGD_LEVEL_MULT (PTRS_PER_PUD * PUD_LEVEL_MULT)
 
+#define pt_dump_seq_printf(m, fmt, args...)			\
+({								\
+	if (dump_to_dmesg)					\
+		printk(KERN_INFO fmt, ##args);			\
+	else							\
+		if (m)						\
+			seq_printf(m, fmt, ##args);		\
+})
+
+#define pt_dump_cont_printf(m, fmt, args...)			\
+({								\
+	if (dump_to_dmesg)					\
+		printk(KERN_CONT fmt, ##args);			\
+	else							\
+		if (m)						\
+			seq_printf(m, fmt, ##args);		\
+})
+
 /*
  * Print a readable form of a pgprot_t to the seq_file
  */
@@ -99,47 +119,47 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
 
 	if (!pgprot_val(prot)) {
 		/* Not present */
-		seq_printf(m, "                          ");
+		pt_dump_cont_printf(m, "                          ");
 	} else {
 		if (pr & _PAGE_USER)
-			seq_printf(m, "USR ");
+			pt_dump_cont_printf(m, "USR ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, "    ");
 		if (pr & _PAGE_RW)
-			seq_printf(m, "RW ");
+			pt_dump_cont_printf(m, "RW ");
 		else
-			seq_printf(m, "ro ");
+			pt_dump_cont_printf(m, "ro ");
 		if (pr & _PAGE_PWT)
-			seq_printf(m, "PWT ");
+			pt_dump_cont_printf(m, "PWT ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, "    ");
 		if (pr & _PAGE_PCD)
-			seq_printf(m, "PCD ");
+			pt_dump_cont_printf(m, "PCD ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, "    ");
 
 		/* Bit 9 has a different meaning on level 3 vs 4 */
 		if (level <= 3) {
 			if (pr & _PAGE_PSE)
-				seq_printf(m, "PSE ");
+				pt_dump_cont_printf(m, "PSE ");
 			else
-				seq_printf(m, "    ");
+				pt_dump_cont_printf(m, "    ");
 		} else {
 			if (pr & _PAGE_PAT)
-				seq_printf(m, "pat ");
+				pt_dump_cont_printf(m, "pat ");
 			else
-				seq_printf(m, "    ");
+				pt_dump_cont_printf(m, "    ");
 		}
 		if (pr & _PAGE_GLOBAL)
-			seq_printf(m, "GLB ");
+			pt_dump_cont_printf(m, "GLB ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, "    ");
 		if (pr & _PAGE_NX)
-			seq_printf(m, "NX ");
+			pt_dump_cont_printf(m, "NX ");
 		else
-			seq_printf(m, "x  ");
+			pt_dump_cont_printf(m, "x  ");
 	}
-	seq_printf(m, "%s\n", level_name[level]);
+	pt_dump_cont_printf(m, "%s\n", level_name[level]);
 }
 
 /*
@@ -178,7 +198,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		st->current_prot = new_prot;
 		st->level = level;
 		st->marker = address_markers;
-		seq_printf(m, "---[ %s ]---\n", st->marker->name);
+		pt_dump_seq_printf(m, "---[ %s ]---\n", st->marker->name);
 	} else if (prot != cur || level != st->level ||
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
@@ -188,16 +208,16 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%0*lx-0x%0*lx   ",
-			   width, st->start_address,
-			   width, st->current_address);
+		pt_dump_seq_printf(m, "0x%0*lx-0x%0*lx   ",
+				   width, st->start_address,
+				   width, st->current_address);
 
 		delta = (st->current_address - st->start_address) >> 10;
 		while (!(delta & 1023) && unit[1]) {
 			delta >>= 10;
 			unit++;
 		}
-		seq_printf(m, "%9lu%c ", delta, *unit);
+		pt_dump_cont_printf(m, "%9lu%c ", delta, *unit);
 		printk_prot(m, st->current_prot, st->level);
 
 		/*
@@ -207,7 +227,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		 */
 		if (st->current_address >= st->marker[1].start_address) {
 			st->marker++;
-			seq_printf(m, "---[ %s ]---\n", st->marker->name);
+			pt_dump_seq_printf(m, "---[ %s ]---\n", st->marker->name);
 		}
 
 		st->start_address = st->current_address;
@@ -296,7 +316,7 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
 #define pgd_none(a)  pud_none(__pud(pgd_val(a)))
 #endif
 
-static void walk_pgd_level(struct seq_file *m)
+static void walk_pgd_level(struct seq_file *m, pgd_t *pgd)
 {
 #ifdef CONFIG_X86_64
 	pgd_t *start = (pgd_t *) &init_level4_pgt;
@@ -306,6 +326,9 @@ static void walk_pgd_level(struct seq_file *m)
 	int i;
 	struct pg_state st;
 
+	if (pgd)
+		start = pgd;
+
 	memset(&st, 0, sizeof(st));
 
 	for (i = 0; i < PTRS_PER_PGD; i++) {
@@ -329,9 +352,13 @@ static void walk_pgd_level(struct seq_file *m)
 	note_page(m, &st, __pgprot(0), 0);
 }
 
-static int ptdump_show(struct seq_file *m, void *v)
+int ptdump_show(struct seq_file *m, void *v)
 {
-	walk_pgd_level(m);
+	struct ptdump_desc *d = (struct ptdump_desc *)v;
+
+	dump_to_dmesg = d->to_dmesg;
+
+	walk_pgd_level(m, d->pgd);
 	return 0;
 }
 
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f8ec4dafc74e..7af028a853e8 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -792,6 +792,8 @@ void __init old_map_region(efi_memory_desc_t *md)
  */
 void __init efi_enter_virtual_mode(void)
 {
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	struct ptdump_desc pt = { pgd, true };
 	efi_memory_desc_t *md, *prev_md = NULL;
 	void *p, *new_memmap = NULL;
 	unsigned long size;
@@ -876,6 +878,15 @@ void __init efi_enter_virtual_mode(void)
 	efi_setup_page_tables();
 	efi_sync_low_kernel_mappings();
 
+	memcpy(pgd + pgd_index(__pa(new_memmap)),
+	       init_mm.pgd + pgd_index(__pa(new_memmap)),
+	       sizeof(pgd_t));
+
+	pr_info("desc_size: %lu, count: %d, new_memmap: %p, pa: 0x%lx\n",
+		memmap.desc_size, count, new_memmap, __pa(new_memmap));
+
+	ptdump_show(NULL, &pt);
+
 	status = phys_efi_set_virtual_address_map(
 		memmap.desc_size * count,
 		memmap.desc_size,
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index bf286c386d33..0e2ccca2c7ce 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -160,6 +160,9 @@ static void __init __map_region(efi_memory_desc_t *md, u64 va)
 	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
 		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
 			   md->phys_addr, va);
+	else
+		pr_info("PA: 0x%llx -> VA: 0x%llx\n",
+			 md->phys_addr, va);
 }
 
 void __init efi_map_region(efi_memory_desc_t *md)


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
