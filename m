Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933352AbaGSAqZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Jul 2014 20:46:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:46143 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932768AbaGSAqU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Jul 2014 20:46:20 -0400
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86 fixes for v3.16-rc6
Cc: <stable@vger.kernel.org>, Ard Biesheuvel <ard.biesheuvel@linaro.org>,
        Boris Ostrovsky <boris.ostrovsky@oracle.com>,
        Catalin Marinas <catalin.marinas@arm.com>,
        "H. Peter Anvin" <hpa@linux.intel.com>,
        "H. Peter Anvin" <hpa@zytor.com>, Ingo Molnar <mingo@elte.hu>,
        Ingo Molnar <mingo@kernel.org>, Jiri Kosina <jkosina@suse.cz>,
        Josh Boyer <jwboyer@fedoraproject.org>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Michael Brown <mbrown@fensystems.co.uk>,
        Paul Bolle <pebolle@tiscali.nl>, Peter Zijlstra <peterz@infradead.org>,
        <thomas@archlinux.org>, Thomas Gleixner <tglx@linutronix.de>,
        Will Deacon <will.deacon@arm.com>
Date: Fri, 18 Jul 2014 17:39:17 -0700
Message-Id: <201407190039.s6J0dHMW028633@terminus.zytor.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

A couple of key fixes and a few less critical ones.  The main ones
are:

1. to add a .bss section to the PE/COFF headers when building with EFI
   stub.  

2. to invoke the correct paravirt magic when building the espfix page
   tables.

Unfortunately both of these areas also have at least one additional
fix each still in thie pipeline, but which are not yet ready to push.

The following changes since commit 1795cd9b3a91d4b5473c97f491d63892442212ab:

  Linux 3.16-rc5 (2014-07-13 14:04:33 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

for you to fetch changes up to d3f44fbabe55132832e152606365adb640296378:

  x86: Remove unused variable "polling" (2014-07-16 12:58:47 +0200)

----------------------------------------------------------------
Ard Biesheuvel (1):
      efi/arm64: efistub: remove local copy of linux_banner

Boris Ostrovsky (1):
      x86/espfix/xen: Fix allocation of pages for paravirt page tables

Catalin Marinas (1):
      efi: fdt: Do not report an error during boot if UEFI is not available

H. Peter Anvin (1):
      Merge tag 'efi-urgent' into x86/urgent

Michael Brown (1):
      x86/efi: Include a .bss section within the PE/COFF headers

Paul Bolle (1):
      x86: Remove unused variable "polling"

 arch/arm64/kernel/efi-stub.c |  2 --
 arch/x86/boot/header.S       | 26 ++++++++++++++++++++++----
 arch/x86/boot/tools/build.c  | 38 ++++++++++++++++++++++++++++++--------
 arch/x86/kernel/apm_32.c     |  1 -
 arch/x86/kernel/espfix_64.c  |  5 ++---
 drivers/firmware/efi/efi.c   | 22 +++++++++++++++-------
 drivers/firmware/efi/fdt.c   | 10 ----------
 7 files changed, 69 insertions(+), 35 deletions(-)

diff --git a/arch/arm64/kernel/efi-stub.c b/arch/arm64/kernel/efi-stub.c
index 60e98a639ac5..e786e6cdc400 100644
--- a/arch/arm64/kernel/efi-stub.c
+++ b/arch/arm64/kernel/efi-stub.c
@@ -12,8 +12,6 @@
 #include <linux/efi.h>
 #include <linux/libfdt.h>
 #include <asm/sections.h>
-#include <generated/compile.h>
-#include <generated/utsrelease.h>
 
 /*
  * AArch64 requires the DTB to be 8-byte aligned in the first 512MiB from
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 84c223479e3c..7a6d43a554d7 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -91,10 +91,9 @@ bs_die:
 
 	.section ".bsdata", "a"
 bugger_off_msg:
-	.ascii	"Direct floppy boot is not supported. "
-	.ascii	"Use a boot loader program instead.\r\n"
+	.ascii	"Use a boot loader.\r\n"
 	.ascii	"\n"
-	.ascii	"Remove disk and press any key to reboot ...\r\n"
+	.ascii	"Remove disk and press any key to reboot...\r\n"
 	.byte	0
 
 #ifdef CONFIG_EFI_STUB
@@ -108,7 +107,7 @@ coff_header:
 #else
 	.word	0x8664				# x86-64
 #endif
-	.word	3				# nr_sections
+	.word	4				# nr_sections
 	.long	0 				# TimeDateStamp
 	.long	0				# PointerToSymbolTable
 	.long	1				# NumberOfSymbols
@@ -250,6 +249,25 @@ section_table:
 	.word	0				# NumberOfLineNumbers
 	.long	0x60500020			# Characteristics (section flags)
 
+	#
+	# The offset & size fields are filled in by build.c.
+	#
+	.ascii	".bss"
+	.byte	0
+	.byte	0
+	.byte	0
+	.byte	0
+	.long	0
+	.long	0x0
+	.long	0				# Size of initialized data
+						# on disk
+	.long	0x0
+	.long	0				# PointerToRelocations
+	.long	0				# PointerToLineNumbers
+	.word	0				# NumberOfRelocations
+	.word	0				# NumberOfLineNumbers
+	.long	0xc8000080			# Characteristics (section flags)
+
 #endif /* CONFIG_EFI_STUB */
 
 	# Kernel attributes; used by setup.  This is part 1 of the
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 1a2f2121cada..a7661c430cd9 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -143,7 +143,7 @@ static void usage(void)
 
 #ifdef CONFIG_EFI_STUB
 
-static void update_pecoff_section_header(char *section_name, u32 offset, u32 size)
+static void update_pecoff_section_header_fields(char *section_name, u32 vma, u32 size, u32 datasz, u32 offset)
 {
 	unsigned int pe_header;
 	unsigned short num_sections;
@@ -164,10 +164,10 @@ static void update_pecoff_section_header(char *section_name, u32 offset, u32 siz
 			put_unaligned_le32(size, section + 0x8);
 
 			/* section header vma field */
-			put_unaligned_le32(offset, section + 0xc);
+			put_unaligned_le32(vma, section + 0xc);
 
 			/* section header 'size of initialised data' field */
-			put_unaligned_le32(size, section + 0x10);
+			put_unaligned_le32(datasz, section + 0x10);
 
 			/* section header 'file offset' field */
 			put_unaligned_le32(offset, section + 0x14);
@@ -179,6 +179,11 @@ static void update_pecoff_section_header(char *section_name, u32 offset, u32 siz
 	}
 }
 
+static void update_pecoff_section_header(char *section_name, u32 offset, u32 size)
+{
+	update_pecoff_section_header_fields(section_name, offset, size, size, offset);
+}
+
 static void update_pecoff_setup_and_reloc(unsigned int size)
 {
 	u32 setup_offset = 0x200;
@@ -203,9 +208,6 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 
 	pe_header = get_unaligned_le32(&buf[0x3c]);
 
-	/* Size of image */
-	put_unaligned_le32(file_sz, &buf[pe_header + 0x50]);
-
 	/*
 	 * Size of code: Subtract the size of the first sector (512 bytes)
 	 * which includes the header.
@@ -220,6 +222,22 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 	update_pecoff_section_header(".text", text_start, text_sz);
 }
 
+static void update_pecoff_bss(unsigned int file_sz, unsigned int init_sz)
+{
+	unsigned int pe_header;
+	unsigned int bss_sz = init_sz - file_sz;
+
+	pe_header = get_unaligned_le32(&buf[0x3c]);
+
+	/* Size of uninitialized data */
+	put_unaligned_le32(bss_sz, &buf[pe_header + 0x24]);
+
+	/* Size of image */
+	put_unaligned_le32(init_sz, &buf[pe_header + 0x50]);
+
+	update_pecoff_section_header_fields(".bss", file_sz, bss_sz, 0, 0);
+}
+
 static int reserve_pecoff_reloc_section(int c)
 {
 	/* Reserve 0x20 bytes for .reloc section */
@@ -259,6 +277,8 @@ static void efi_stub_entry_update(void)
 static inline void update_pecoff_setup_and_reloc(unsigned int size) {}
 static inline void update_pecoff_text(unsigned int text_start,
 				      unsigned int file_sz) {}
+static inline void update_pecoff_bss(unsigned int file_sz,
+				     unsigned int init_sz) {}
 static inline void efi_stub_defaults(void) {}
 static inline void efi_stub_entry_update(void) {}
 
@@ -310,7 +330,7 @@ static void parse_zoffset(char *fname)
 
 int main(int argc, char ** argv)
 {
-	unsigned int i, sz, setup_sectors;
+	unsigned int i, sz, setup_sectors, init_sz;
 	int c;
 	u32 sys_size;
 	struct stat sb;
@@ -376,7 +396,9 @@ int main(int argc, char ** argv)
 	buf[0x1f1] = setup_sectors-1;
 	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
-	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) - sz));
+	update_pecoff_text(setup_sectors * 512, i + (sys_size * 16));
+	init_sz = get_unaligned_le32(&buf[0x260]);
+	update_pecoff_bss(i + (sys_size * 16), init_sz);
 
 	efi_stub_entry_update();
 
diff --git a/arch/x86/kernel/apm_32.c b/arch/x86/kernel/apm_32.c
index f3a1f04ed4cb..584874451414 100644
--- a/arch/x86/kernel/apm_32.c
+++ b/arch/x86/kernel/apm_32.c
@@ -841,7 +841,6 @@ static int apm_do_idle(void)
 	u32 eax;
 	u8 ret = 0;
 	int idled = 0;
-	int polling;
 	int err = 0;
 
 	if (!need_resched()) {
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
 
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index eff1a2f22f09..dc79346689e6 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -346,6 +346,7 @@ static __initdata struct {
 
 struct param_info {
 	int verbose;
+	int found;
 	void *params;
 };
 
@@ -362,16 +363,12 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 	    (strcmp(uname, "chosen") != 0 && strcmp(uname, "chosen@0") != 0))
 		return 0;
 
-	pr_info("Getting parameters from FDT:\n");
-
 	for (i = 0; i < ARRAY_SIZE(dt_params); i++) {
 		prop = of_get_flat_dt_prop(node, dt_params[i].propname, &len);
-		if (!prop) {
-			pr_err("Can't find %s in device tree!\n",
-			       dt_params[i].name);
+		if (!prop)
 			return 0;
-		}
 		dest = info->params + dt_params[i].offset;
+		info->found++;
 
 		val = of_read_number(prop, len / sizeof(u32));
 
@@ -390,10 +387,21 @@ static int __init fdt_find_uefi_params(unsigned long node, const char *uname,
 int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
 {
 	struct param_info info;
+	int ret;
+
+	pr_info("Getting EFI parameters from FDT:\n");
 
 	info.verbose = verbose;
+	info.found = 0;
 	info.params = params;
 
-	return of_scan_flat_dt(fdt_find_uefi_params, &info);
+	ret = of_scan_flat_dt(fdt_find_uefi_params, &info);
+	if (!info.found)
+		pr_info("UEFI not found.\n");
+	else if (!ret)
+		pr_err("Can't find '%s' in device tree!\n",
+		       dt_params[info.found].name);
+
+	return ret;
 }
 #endif /* CONFIG_EFI_PARAMS_FROM_FDT */
diff --git a/drivers/firmware/efi/fdt.c b/drivers/firmware/efi/fdt.c
index 82d774161cc9..507a3df46a5d 100644
--- a/drivers/firmware/efi/fdt.c
+++ b/drivers/firmware/efi/fdt.c
@@ -23,16 +23,6 @@ static efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 	u32 fdt_val32;
 	u64 fdt_val64;
 
-	/*
-	 * Copy definition of linux_banner here.  Since this code is
-	 * built as part of the decompressor for ARM v7, pulling
-	 * in version.c where linux_banner is defined for the
-	 * kernel brings other kernel dependencies with it.
-	 */
-	const char linux_banner[] =
-	    "Linux version " UTS_RELEASE " (" LINUX_COMPILE_BY "@"
-	    LINUX_COMPILE_HOST ") (" LINUX_COMPILER ") " UTS_VERSION "\n";
-
 	/* Do some checks on provided FDT, if it exists*/
 	if (orig_fdt) {
 		if (fdt_check_header(orig_fdt)) {
