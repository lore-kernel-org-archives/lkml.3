Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751614Ab3LLQYE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Dec 2013 11:24:04 -0500
Received: from mail.skyhub.de ([78.46.96.112]:49590 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751466Ab3LLQYB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Dec 2013 11:24:01 -0500
Date: Thu, 12 Dec 2013 17:23:51 +0100
From: Borislav Petkov <bp@alien8.de>
To: Toshi Kani <toshi.kani@hp.com>
Cc: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org, x86@kernel.org
Subject: Re: EFI tree kernel panic in phys_efi_set_virtual_address_map()
Message-ID: <20131212162351.GA26927@pd.tnic>
References: <1386806463.1791.295.camel@misato.fc.hp.com>
 <20131212002946.GF8863@pd.tnic>
 <1386808323.1791.299.camel@misato.fc.hp.com>
 <1386810484.1791.306.camel@misato.fc.hp.com>
 <1386810620.1791.307.camel@misato.fc.hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <1386810620.1791.307.camel@misato.fc.hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Dec 11, 2013 at 06:10:20PM -0700, Toshi Kani wrote:
> > Unfortunately, it did not work.  Hit the same panic again.
> 
> dmesg output attached.

Ok, thanks.

Let's have a look at the EFI pagetable then. Please apply the attached
patch, make sure CONFIG_X86_PTDUMP is enabled, build, boot and catch
full dmesg again and send it to me.

Thanks.

---
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 3d1999458709..39022e488c5d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -15,6 +15,7 @@
 	 : (prot))
 
 #ifndef __ASSEMBLY__
+int ptdump_show(struct seq_file *m, void *v);
 
 #include <asm/x86_init.h>
 
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0002a3a33081..744dc0dea3c9 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -99,47 +99,47 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
 
 	if (!pgprot_val(prot)) {
 		/* Not present */
-		seq_printf(m, "                          ");
+		pr_cont("                          ");
 	} else {
 		if (pr & _PAGE_USER)
-			seq_printf(m, "USR ");
+			pr_cont("USR ");
 		else
-			seq_printf(m, "    ");
+			pr_cont("    ");
 		if (pr & _PAGE_RW)
-			seq_printf(m, "RW ");
+			pr_cont("RW ");
 		else
-			seq_printf(m, "ro ");
+			pr_cont("ro ");
 		if (pr & _PAGE_PWT)
-			seq_printf(m, "PWT ");
+			pr_cont("PWT ");
 		else
-			seq_printf(m, "    ");
+			pr_cont("    ");
 		if (pr & _PAGE_PCD)
-			seq_printf(m, "PCD ");
+			pr_cont("PCD ");
 		else
-			seq_printf(m, "    ");
+			pr_cont("    ");
 
 		/* Bit 9 has a different meaning on level 3 vs 4 */
 		if (level <= 3) {
 			if (pr & _PAGE_PSE)
-				seq_printf(m, "PSE ");
+				pr_cont("PSE ");
 			else
-				seq_printf(m, "    ");
+				pr_cont("    ");
 		} else {
 			if (pr & _PAGE_PAT)
-				seq_printf(m, "pat ");
+				pr_cont("pat ");
 			else
-				seq_printf(m, "    ");
+				pr_cont("    ");
 		}
 		if (pr & _PAGE_GLOBAL)
-			seq_printf(m, "GLB ");
+			pr_cont("GLB ");
 		else
-			seq_printf(m, "    ");
+			pr_cont("    ");
 		if (pr & _PAGE_NX)
-			seq_printf(m, "NX ");
+			pr_cont("NX ");
 		else
-			seq_printf(m, "x  ");
+			pr_cont("x  ");
 	}
-	seq_printf(m, "%s\n", level_name[level]);
+	pr_cont("%s\n", level_name[level]);
 }
 
 /*
@@ -178,7 +178,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		st->current_prot = new_prot;
 		st->level = level;
 		st->marker = address_markers;
-		seq_printf(m, "---[ %s ]---\n", st->marker->name);
+		pr_info("---[ %s ]---\n", st->marker->name);
 	} else if (prot != cur || level != st->level ||
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
@@ -188,7 +188,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%0*lx-0x%0*lx   ",
+		pr_info("0x%0*lx-0x%0*lx   ",
 			   width, st->start_address,
 			   width, st->current_address);
 
@@ -197,7 +197,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 			delta >>= 10;
 			unit++;
 		}
-		seq_printf(m, "%9lu%c ", delta, *unit);
+		pr_cont("%9lu%c ", delta, *unit);
 		printk_prot(m, st->current_prot, st->level);
 
 		/*
@@ -207,7 +207,7 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		 */
 		if (st->current_address >= st->marker[1].start_address) {
 			st->marker++;
-			seq_printf(m, "---[ %s ]---\n", st->marker->name);
+			pr_info("---[ %s ]---\n", st->marker->name);
 		}
 
 		st->start_address = st->current_address;
@@ -298,14 +298,11 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
 
 static void walk_pgd_level(struct seq_file *m)
 {
-#ifdef CONFIG_X86_64
-	pgd_t *start = (pgd_t *) &init_level4_pgt;
-#else
-	pgd_t *start = swapper_pg_dir;
-#endif
 	int i;
 	struct pg_state st;
 
+	pgd_t *start = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
 	memset(&st, 0, sizeof(st));
 
 	for (i = 0; i < PTRS_PER_PGD; i++) {
@@ -329,7 +326,7 @@ static void walk_pgd_level(struct seq_file *m)
 	note_page(m, &st, __pgprot(0), 0);
 }
 
-static int ptdump_show(struct seq_file *m, void *v)
+int ptdump_show(struct seq_file *m, void *v)
 {
 	walk_pgd_level(m);
 	return 0;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index f8ec4dafc74e..f4920191ff8b 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -876,6 +876,11 @@ void __init efi_enter_virtual_mode(void)
 	efi_setup_page_tables();
 	efi_sync_low_kernel_mappings();
 
+	pr_info("desc_size: %lu, count: %d, new_memmap: %p, pa: 0x%lx\n",
+		memmap.desc_size, count, new_memmap, __pa(new_memmap));
+
+	ptdump_show(NULL, NULL);
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
