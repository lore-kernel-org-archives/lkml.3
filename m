Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757210AbaLINWT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Dec 2014 08:22:19 -0500
Received: from mail-wg0-f42.google.com ([74.125.82.42]:50176 "EHLO
	mail-wg0-f42.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756982AbaLINWR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Dec 2014 08:22:17 -0500
Date: Tue, 9 Dec 2014 14:22:11 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Borislav Petkov <bp@alien8.de>,
        Ricardo Neri <ricardo.neri-calderon@linux.intel.com>,
        Matt Fleming <matt@console-pimps.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] EFI tree changes for v3.19
Message-ID: <20141209132211.GA30775@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

   # HEAD: 595247f61f9840222a4dec4baefd66ad6d5b0d6a Merge tag 'efi-next' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/efi

Changes in this cycle are:

     - Support module unload for efivarfs (Mathias Krause)

     - Another attempt at moving x86 to libstub taking advantage of the
       __pure attribute (Ard Biesheuvel)

     - Add EFI runtime services section to ptdump (Mathias Krause)

 Thanks,

	Ingo

------------------>
Ard Biesheuvel (1):
      efi/x86: Move x86 back to libstub

Mathias Krause (2):
      efivarfs: Allow unloading when build as module
      x86, ptdump: Add section for EFI runtime services


 arch/x86/boot/compressed/Makefile       |  3 ++-
 arch/x86/boot/compressed/eboot.c        |  8 ++++----
 arch/x86/boot/compressed/eboot.h        | 16 ----------------
 arch/x86/include/asm/efi.h              | 24 ++++++++++++++++++++++++
 arch/x86/include/asm/pgtable_64_types.h |  2 ++
 arch/x86/mm/dump_pagetables.c           |  3 +++
 arch/x86/platform/efi/efi_64.c          |  3 +--
 drivers/firmware/efi/Makefile           |  2 +-
 fs/efivarfs/super.c                     | 11 +++++++++--
 9 files changed, 46 insertions(+), 26 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 704f58aa79cd..20db5b3609de 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -35,7 +35,8 @@ vmlinux-objs-$(CONFIG_RANDOMIZE_BASE) += $(obj)/aslr.o
 
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
-vmlinux-objs-$(CONFIG_EFI_STUB) += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
+vmlinux-objs-$(CONFIG_EFI_STUB) += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
+	$(objtree)/drivers/firmware/efi/libstub/lib.a
 
 $(obj)/vmlinux: $(vmlinux-objs-y) FORCE
 	$(call if_changed,ld)
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 1acf605a646d..92b9a5f2aed6 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -21,8 +21,10 @@ static efi_system_table_t *sys_table;
 
 static struct efi_config *efi_early;
 
-#define efi_call_early(f, ...)						\
-	efi_early->call(efi_early->f, __VA_ARGS__);
+__pure const struct efi_config *__efi_early(void)
+{
+	return efi_early;
+}
 
 #define BOOT_SERVICES(bits)						\
 static void setup_boot_services##bits(struct efi_config *c)		\
@@ -285,8 +287,6 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 	}
 }
 
-#include "../../../../drivers/firmware/efi/libstub/efi-stub-helper.c"
-
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
 	u8 first, len;
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index c88c31ecad12..d487e727f1ec 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -103,20 +103,4 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
-struct efi_config {
-	u64 image_handle;
-	u64 table;
-	u64 allocate_pool;
-	u64 allocate_pages;
-	u64 get_memory_map;
-	u64 free_pool;
-	u64 free_pages;
-	u64 locate_handle;
-	u64 handle_protocol;
-	u64 exit_boot_services;
-	u64 text_output;
-	efi_status_t (*call)(unsigned long, ...);
-	bool is64;
-} __packed;
-
 #endif /* BOOT_COMPRESSED_EBOOT_H */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 9b11757975d0..25bce45c6fc4 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -158,6 +158,30 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 }
 #endif /* CONFIG_EFI_MIXED */
 
+
+/* arch specific definitions used by the stub code */
+
+struct efi_config {
+	u64 image_handle;
+	u64 table;
+	u64 allocate_pool;
+	u64 allocate_pages;
+	u64 get_memory_map;
+	u64 free_pool;
+	u64 free_pages;
+	u64 locate_handle;
+	u64 handle_protocol;
+	u64 exit_boot_services;
+	u64 text_output;
+	efi_status_t (*call)(unsigned long, ...);
+	bool is64;
+} __packed;
+
+__pure const struct efi_config *__efi_early(void);
+
+#define efi_call_early(f, ...)						\
+	__efi_early()->call(__efi_early()->f, __VA_ARGS__);
+
 extern bool efi_reboot_required(void);
 
 #else
diff --git a/arch/x86/include/asm/pgtable_64_types.h b/arch/x86/include/asm/pgtable_64_types.h
index 7166e25ecb57..602b6028c5b6 100644
--- a/arch/x86/include/asm/pgtable_64_types.h
+++ b/arch/x86/include/asm/pgtable_64_types.h
@@ -63,6 +63,8 @@ typedef struct { pteval_t pte; } pte_t;
 #define MODULES_LEN   (MODULES_END - MODULES_VADDR)
 #define ESPFIX_PGD_ENTRY _AC(-2, UL)
 #define ESPFIX_BASE_ADDR (ESPFIX_PGD_ENTRY << PGDIR_SHIFT)
+#define EFI_VA_START	 ( -4 * (_AC(1, UL) << 30))
+#define EFI_VA_END	 (-68 * (_AC(1, UL) << 30))
 
 #define EARLY_DYNAMIC_PAGE_TABLES	64
 
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 95a427e57887..1a8053d1012e 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -76,6 +76,9 @@ static struct addr_marker address_markers[] = {
 # ifdef CONFIG_X86_ESPFIX64
 	{ ESPFIX_BASE_ADDR,	"ESPfix Area", 16 },
 # endif
+# ifdef CONFIG_EFI
+	{ EFI_VA_END,		"EFI Runtime Services" },
+# endif
 	{ __START_KERNEL_map,   "High Kernel Mapping" },
 	{ MODULES_VADDR,        "Modules" },
 	{ MODULES_END,          "End Modules" },
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 35aecb6042fb..17e80d829df0 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -48,8 +48,7 @@ static unsigned long efi_flags __initdata;
  * We allocate runtime services regions bottom-up, starting from -4G, i.e.
  * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
  */
-static u64 efi_va	= -4 * (1UL << 30);
-#define EFI_VA_END	(-68 * (1UL << 30))
+static u64 efi_va = EFI_VA_START;
 
 /*
  * Scratch space used for switching the pagetable in the EFI stub
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index aef6a95adef5..d8be608a9f3b 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
-obj-$(CONFIG_EFI_ARM_STUB)		+= libstub/
+obj-$(CONFIG_EFI_STUB)			+= libstub/
diff --git a/fs/efivarfs/super.c b/fs/efivarfs/super.c
index 0a48886e069c..6dad1176ec52 100644
--- a/fs/efivarfs/super.c
+++ b/fs/efivarfs/super.c
@@ -236,6 +236,7 @@ static void efivarfs_kill_sb(struct super_block *sb)
 }
 
 static struct file_system_type efivarfs_type = {
+	.owner   = THIS_MODULE,
 	.name    = "efivarfs",
 	.mount   = efivarfs_mount,
 	.kill_sb = efivarfs_kill_sb,
@@ -244,17 +245,23 @@ static struct file_system_type efivarfs_type = {
 static __init int efivarfs_init(void)
 {
 	if (!efi_enabled(EFI_RUNTIME_SERVICES))
-		return 0;
+		return -ENODEV;
 
 	if (!efivars_kobject())
-		return 0;
+		return -ENODEV;
 
 	return register_filesystem(&efivarfs_type);
 }
 
+static __exit void efivarfs_exit(void)
+{
+	unregister_filesystem(&efivarfs_type);
+}
+
 MODULE_AUTHOR("Matthew Garrett, Jeremy Kerr");
 MODULE_DESCRIPTION("EFI Variable Filesystem");
 MODULE_LICENSE("GPL");
 MODULE_ALIAS_FS("efivarfs");
 
 module_init(efivarfs_init);
+module_exit(efivarfs_exit);
