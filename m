Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755626AbaISKk3 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Sep 2014 06:40:29 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:46439 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751223AbaISKk1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Sep 2014 06:40:27 -0400
Date: Fri, 19 Sep 2014 12:40:21 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86 fixes
Message-ID: <20140919104021.GA11552@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=iso-8859-1
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 5ac385d83525fb8924ef87c18a4dc49998366394 Merge tag 'efi-urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/urgent

Misc fixes: EFI fixes, a build fix, a page table dumping (debug) 
fix and a clang build fix.

  out-of-topic modifications in x86-urgent-for-linus:
  -----------------------------------------------------
  arch/arm64/mm/init.c               # 0ceac9e094b0: efi/arm64: Fix fdt-related m
  drivers/firmware/efi/libstub/fdt.c # 0ceac9e094b0: efi/arm64: Fix fdt-related m

 Thanks,

	Ingo

------------------>
Jan-Simon Möller (1):
      x86/mm: Apply the section attribute to the variable, not its type

Jiang Liu (1):
      x86, irq: Fix build error caused by 9eabc99a635a77cbf09

Mark Salter (1):
      efi/arm64: Fix fdt-related memory reservation

Mathias Krause (1):
      x86-64, ptdump: Mark espfix area only if existent

Matt Fleming (1):
      x86/efi: Fixup GOT in all boot code paths

Yinghai Lu (1):
      x86/efi: Only load initrd above 4g on second try


 arch/arm64/mm/init.c               |  3 +-
 arch/x86/boot/compressed/eboot.c   | 18 +++++++-----
 arch/x86/boot/compressed/head_32.S | 54 ++++++++++++++++++++++++++----------
 arch/x86/boot/compressed/head_64.S | 56 ++++++++++++++++++++++++++++----------
 arch/x86/include/asm/io_apic.h     |  1 +
 arch/x86/mm/dump_pagetables.c      |  4 +++
 arch/x86/mm/mmap.c                 |  2 +-
 drivers/firmware/efi/libstub/fdt.c | 10 ++++++-
 8 files changed, 108 insertions(+), 40 deletions(-)

diff --git a/arch/arm64/mm/init.c b/arch/arm64/mm/init.c
index 5472c2401876..a83061f37e43 100644
--- a/arch/arm64/mm/init.c
+++ b/arch/arm64/mm/init.c
@@ -149,8 +149,7 @@ void __init arm64_memblock_init(void)
 		memblock_reserve(__virt_to_phys(initrd_start), initrd_end - initrd_start);
 #endif
 
-	if (!efi_enabled(EFI_MEMMAP))
-		early_init_fdt_scan_reserved_mem();
+	early_init_fdt_scan_reserved_mem();
 
 	/* 4GB maximum for 32-bit only capable devices */
 	if (IS_ENABLED(CONFIG_ZONE_DMA))
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index f277184e2ac1..dca9842d8f91 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -1032,7 +1032,6 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	int i;
 	unsigned long ramdisk_addr;
 	unsigned long ramdisk_size;
-	unsigned long initrd_addr_max;
 
 	efi_early = c;
 	sys_table = (efi_system_table_t *)(unsigned long)efi_early->table;
@@ -1095,15 +1094,20 @@ struct boot_params *make_boot_params(struct efi_config *c)
 
 	memset(sdt, 0, sizeof(*sdt));
 
-	if (hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G)
-		initrd_addr_max = -1UL;
-	else
-		initrd_addr_max = hdr->initrd_addr_max;
-
 	status = handle_cmdline_files(sys_table, image,
 				      (char *)(unsigned long)hdr->cmd_line_ptr,
-				      "initrd=", initrd_addr_max,
+				      "initrd=", hdr->initrd_addr_max,
 				      &ramdisk_addr, &ramdisk_size);
+
+	if (status != EFI_SUCCESS &&
+	    hdr->xloadflags & XLF_CAN_BE_LOADED_ABOVE_4G) {
+		efi_printk(sys_table, "Trying to load files to higher address\n");
+		status = handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=", -1UL,
+				      &ramdisk_addr, &ramdisk_size);
+	}
+
 	if (status != EFI_SUCCESS)
 		goto fail2;
 	hdr->ramdisk_image = ramdisk_addr & 0xffffffff;
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index cbed1407a5cd..d6b8aa4c986c 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -30,6 +30,33 @@
 #include <asm/boot.h>
 #include <asm/asm-offsets.h>
 
+/*
+ * Adjust our own GOT
+ *
+ * The relocation base must be in %ebx
+ *
+ * It is safe to call this macro more than once, because in some of the
+ * code paths multiple invocations are inevitable, e.g. via the efi*
+ * entry points.
+ *
+ * Relocation is only performed the first time.
+ */
+.macro FIXUP_GOT
+	cmpb	$1, got_fixed(%ebx)
+	je	2f
+
+	leal	_got(%ebx), %edx
+	leal	_egot(%ebx), %ecx
+1:
+	cmpl	%ecx, %edx
+	jae	2f
+	addl	%ebx, (%edx)
+	addl	$4, %edx
+	jmp	1b
+2:
+	movb	$1, got_fixed(%ebx)
+.endm
+
 	__HEAD
 ENTRY(startup_32)
 #ifdef CONFIG_EFI_STUB
@@ -56,6 +83,9 @@ ENTRY(efi_pe_entry)
 	add	%esi, 88(%eax)
 	pushl	%eax
 
+	movl	%esi, %ebx
+	FIXUP_GOT
+
 	call	make_boot_params
 	cmpl	$0, %eax
 	je	fail
@@ -81,6 +111,10 @@ ENTRY(efi32_stub_entry)
 	leal	efi32_config(%esi), %eax
 	add	%esi, 88(%eax)
 	pushl	%eax
+
+	movl	%esi, %ebx
+	FIXUP_GOT
+
 2:
 	call	efi_main
 	cmpl	$0, %eax
@@ -190,19 +224,7 @@ ENDPROC(startup_32)
 	shrl	$2, %ecx
 	rep	stosl
 
-/*
- * Adjust our own GOT
- */
-	leal	_got(%ebx), %edx
-	leal	_egot(%ebx), %ecx
-1:
-	cmpl	%ecx, %edx
-	jae	2f
-	addl	%ebx, (%edx)
-	addl	$4, %edx
-	jmp	1b
-2:
-
+	FIXUP_GOT
 /*
  * Do the decompression, and jump to the new kernel..
  */
@@ -225,8 +247,12 @@ ENDPROC(startup_32)
 	xorl	%ebx, %ebx
 	jmp	*%eax
 
-#ifdef CONFIG_EFI_STUB
 	.data
+/* Have we relocated the GOT? */
+got_fixed:
+	.byte 0
+
+#ifdef CONFIG_EFI_STUB
 efi32_config:
 	.fill 11,8,0
 	.long efi_call_phys
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index 2884e0c3e8a5..50f69c7eaaf4 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -32,6 +32,33 @@
 #include <asm/processor-flags.h>
 #include <asm/asm-offsets.h>
 
+/*
+ * Adjust our own GOT
+ *
+ * The relocation base must be in %rbx
+ *
+ * It is safe to call this macro more than once, because in some of the
+ * code paths multiple invocations are inevitable, e.g. via the efi*
+ * entry points.
+ *
+ * Relocation is only performed the first time.
+ */
+.macro FIXUP_GOT
+	cmpb	$1, got_fixed(%rip)
+	je	2f
+
+	leaq	_got(%rip), %rdx
+	leaq	_egot(%rip), %rcx
+1:
+	cmpq	%rcx, %rdx
+	jae	2f
+	addq	%rbx, (%rdx)
+	addq	$8, %rdx
+	jmp	1b
+2:
+	movb	$1, got_fixed(%rip)
+.endm
+
 	__HEAD
 	.code32
 ENTRY(startup_32)
@@ -252,10 +279,13 @@ ENTRY(efi_pe_entry)
 	subq	$1b, %rbp
 
 	/*
-	 * Relocate efi_config->call().
+	 * Relocate efi_config->call() and the GOT entries.
 	 */
 	addq	%rbp, efi64_config+88(%rip)
 
+	movq	%rbp, %rbx
+	FIXUP_GOT
+
 	movq	%rax, %rdi
 	call	make_boot_params
 	cmpq	$0,%rax
@@ -271,10 +301,13 @@ ENTRY(efi_pe_entry)
 	subq	$1b, %rbp
 
 	/*
-	 * Relocate efi_config->call().
+	 * Relocate efi_config->call() and the GOT entries.
 	 */
 	movq	efi_config(%rip), %rax
 	addq	%rbp, 88(%rax)
+
+	movq	%rbp, %rbx
+	FIXUP_GOT
 2:
 	movq	efi_config(%rip), %rdi
 	call	efi_main
@@ -385,19 +418,8 @@ ENDPROC(efi64_stub_entry)
 	shrq	$3, %rcx
 	rep	stosq
 
-/*
- * Adjust our own GOT
- */
-	leaq	_got(%rip), %rdx
-	leaq	_egot(%rip), %rcx
-1:
-	cmpq	%rcx, %rdx
-	jae	2f
-	addq	%rbx, (%rdx)
-	addq	$8, %rdx
-	jmp	1b
-2:
-	
+	FIXUP_GOT
+
 /*
  * Do the decompression, and jump to the new kernel..
  */
@@ -437,6 +459,10 @@ ENDPROC(efi64_stub_entry)
 	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 
+/* Have we relocated the GOT? */
+got_fixed:
+	.byte	0
+
 #ifdef CONFIG_EFI_STUB
 efi_config:
 	.quad	0
diff --git a/arch/x86/include/asm/io_apic.h b/arch/x86/include/asm/io_apic.h
index 478c490f3654..1733ab49ac5e 100644
--- a/arch/x86/include/asm/io_apic.h
+++ b/arch/x86/include/asm/io_apic.h
@@ -239,6 +239,7 @@ static inline int mp_find_ioapic(u32 gsi) { return 0; }
 static inline u32 mp_pin_to_gsi(int ioapic, int pin) { return UINT_MAX; }
 static inline int mp_map_gsi_to_irq(u32 gsi, unsigned int flags) { return gsi; }
 static inline void mp_unmap_irq(int irq) { }
+static inline bool mp_should_keep_irq(struct device *dev) { return 1; }
 
 static inline int save_ioapic_entries(void)
 {
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 167ffcac16ed..95a427e57887 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -48,7 +48,9 @@ enum address_markers_idx {
 	LOW_KERNEL_NR,
 	VMALLOC_START_NR,
 	VMEMMAP_START_NR,
+# ifdef CONFIG_X86_ESPFIX64
 	ESPFIX_START_NR,
+# endif
 	HIGH_KERNEL_NR,
 	MODULES_VADDR_NR,
 	MODULES_END_NR,
@@ -71,7 +73,9 @@ static struct addr_marker address_markers[] = {
 	{ PAGE_OFFSET,		"Low Kernel Mapping" },
 	{ VMALLOC_START,        "vmalloc() Area" },
 	{ VMEMMAP_START,        "Vmemmap" },
+# ifdef CONFIG_X86_ESPFIX64
 	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
+# endif
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
 	{ MODULES_VADDR,        "Modules" },
 	{ MODULES_END,          "End Modules" },
diff --git a/arch/x86/mm/mmap.c b/arch/x86/mm/mmap.c
index 25e7e1372bb2..919b91205cd4 100644
--- a/arch/x86/mm/mmap.c
+++ b/arch/x86/mm/mmap.c
@@ -31,7 +31,7 @@
 #include <linux/sched.h>
 #include <asm/elf.h>
 
-struct __read_mostly va_alignment va_align = {
+struct va_alignment __read_mostly va_align = {
 	.flags = -1,
 };
 
diff --git a/drivers/firmware/efi/libstub/fdt.c b/drivers/firmware/efi/libstub/fdt.c
index a56bb3528755..c846a9608cbd 100644
--- a/drivers/firmware/efi/libstub/fdt.c
+++ b/drivers/firmware/efi/libstub/fdt.c
@@ -22,7 +22,7 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 			unsigned long map_size, unsigned long desc_size,
 			u32 desc_ver)
 {
-	int node, prev;
+	int node, prev, num_rsv;
 	int status;
 	u32 fdt_val32;
 	u64 fdt_val64;
@@ -73,6 +73,14 @@ efi_status_t update_fdt(efi_system_table_t *sys_table, void *orig_fdt,
 		prev = node;
 	}
 
+	/*
+	 * Delete all memory reserve map entries. When booting via UEFI,
+	 * kernel will use the UEFI memory map to find reserved regions.
+	 */
+	num_rsv = fdt_num_mem_rsv(fdt);
+	while (num_rsv-- > 0)
+		fdt_del_mem_rsv(fdt, num_rsv);
+
 	node = fdt_subnode_offset(fdt, 0, "chosen");
 	if (node < 0) {
 		node = fdt_add_subnode(fdt, 0, "chosen");
