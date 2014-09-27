Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751568AbaI0GCa (ORCPT <rfc822;w@1wt.eu>);
	Sat, 27 Sep 2014 02:02:30 -0400
Received: from mail-wi0-f182.google.com ([209.85.212.182]:40692 "EHLO
	mail-wi0-f182.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750949AbaI0GC2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 27 Sep 2014 02:02:28 -0400
Date: Sat, 27 Sep 2014 08:02:22 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>,
        Matt Fleming <matt.fleming@intel.com>
Subject: [GIT PULL] x86 fixes
Message-ID: <20140927060222.GA1326@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-urgent-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-urgent-for-linus

   # HEAD: 29282ac0bd6c0b0c4c893fe2c31863e50fea69f8 Merge tag 'efi-urgent' of git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi into x86/urgent

This has:

  - EFI revert to fix a boot regression
  - early_ioremap() fix for boot failure
  - KASLR fix for possible boot failures
  - EFI fix for corrupted string printing
  - remove a misleading EFI bootup 'failed!' error message

Unfortunately it's all rather close to the merge window.

  out-of-topic modifications in x86-urgent-for-linus:
  -----------------------------------------------------
  drivers/firmware/efi/Makefile      # 84be880560fb: Revert "efi/x86: efistub: Mo

 Thanks,

	Ingo

------------------>
Dave Young (1):
      x86 early_ioremap: Increase FIX_BTMAPS_SLOTS to 8

Kees Cook (1):
      x86/kaslr: Avoid the setup_data area when picking location

Matt Fleming (3):
      Revert "efi/x86: efistub: Move shared dependencies to <asm/efi.h>"
      x86/efi: Delete misleading efi_printk() error message
      x86/efi: Truncate 64-bit values when calling 32-bit OutputString()


 arch/x86/boot/compressed/Makefile |  3 +--
 arch/x86/boot/compressed/aslr.c   | 15 +++++++++++++
 arch/x86/boot/compressed/eboot.c  | 44 +++++++++++++++++++++++----------------
 arch/x86/boot/compressed/eboot.h  | 16 ++++++++++++++
 arch/x86/include/asm/efi.h        | 24 ---------------------
 arch/x86/include/asm/fixmap.h     |  6 +++---
 drivers/firmware/efi/Makefile     |  2 +-
 7 files changed, 62 insertions(+), 48 deletions(-)

diff --git a/arch/x86/boot/compressed/Makefile b/arch/x86/boot/compressed/Makefile
index 7a801a310e37..0fcd9133790c 100644
--- a/arch/x86/boot/compressed/Makefile
+++ b/arch/x86/boot/compressed/Makefile
@@ -33,8 +33,7 @@ VMLINUX_OBJS = $(obj)/vmlinux.lds $(obj)/head_$(BITS).o $(obj)/misc.o \
 $(obj)/eboot.o: KBUILD_CFLAGS += -fshort-wchar -mno-red-zone
 
 ifeq ($(CONFIG_EFI_STUB), y)
-	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o \
-				$(objtree)/drivers/firmware/efi/libstub/lib.a
+	VMLINUX_OBJS += $(obj)/eboot.o $(obj)/efi_stub_$(BITS).o
 endif
 
 $(obj)/vmlinux: $(VMLINUX_OBJS) FORCE
diff --git a/arch/x86/boot/compressed/aslr.c b/arch/x86/boot/compressed/aslr.c
index fc6091abedb7..d39189ba7f8e 100644
--- a/arch/x86/boot/compressed/aslr.c
+++ b/arch/x86/boot/compressed/aslr.c
@@ -183,12 +183,27 @@ static void mem_avoid_init(unsigned long input, unsigned long input_size,
 static bool mem_avoid_overlap(struct mem_vector *img)
 {
 	int i;
+	struct setup_data *ptr;
 
 	for (i = 0; i < MEM_AVOID_MAX; i++) {
 		if (mem_overlaps(img, &mem_avoid[i]))
 			return true;
 	}
 
+	/* Avoid all entries in the setup_data linked list. */
+	ptr = (struct setup_data *)(unsigned long)real_mode->hdr.setup_data;
+	while (ptr) {
+		struct mem_vector avoid;
+
+		avoid.start = (u64)ptr;
+		avoid.size = sizeof(*ptr) + ptr->len;
+
+		if (mem_overlaps(img, &avoid))
+			return true;
+
+		ptr = (struct setup_data *)(unsigned long)ptr->next;
+	}
+
 	return false;
 }
 
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index dca9842d8f91..de8eebd6f67c 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,7 +19,10 @@
 
 static efi_system_table_t *sys_table;
 
-struct efi_config *efi_early;
+static struct efi_config *efi_early;
+
+#define efi_call_early(f, ...)						\
+	efi_early->call(efi_early->f, __VA_ARGS__);
 
 #define BOOT_SERVICES(bits)						\
 static void setup_boot_services##bits(struct efi_config *c)		\
@@ -265,21 +268,25 @@ void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
 
 		offset = offsetof(typeof(*out), output_string);
 		output_string = efi_early->text_output + offset;
+		out = (typeof(out))(unsigned long)efi_early->text_output;
 		func = (u64 *)output_string;
 
-		efi_early->call(*func, efi_early->text_output, str);
+		efi_early->call(*func, out, str);
 	} else {
 		struct efi_simple_text_output_protocol_32 *out;
 		u32 *func;
 
 		offset = offsetof(typeof(*out), output_string);
 		output_string = efi_early->text_output + offset;
+		out = (typeof(out))(unsigned long)efi_early->text_output;
 		func = (u32 *)output_string;
 
-		efi_early->call(*func, efi_early->text_output, str);
+		efi_early->call(*func, out, str);
 	}
 }
 
+#include "../../../../drivers/firmware/efi/libstub/efi-stub-helper.c"
+
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
 	u8 first, len;
@@ -360,7 +367,7 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 	return status;
 }
 
-static efi_status_t
+static void
 setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
@@ -403,8 +410,6 @@ setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		data = (struct setup_data *)rom;
 
 	}
-
-	return status;
 }
 
 static efi_status_t
@@ -463,7 +468,7 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
 
 }
 
-static efi_status_t
+static void
 setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		unsigned long size)
 {
@@ -506,11 +511,18 @@ setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		data = (struct setup_data *)rom;
 
 	}
-
-	return status;
 }
 
-static efi_status_t setup_efi_pci(struct boot_params *params)
+/*
+ * There's no way to return an informative status from this function,
+ * because any analysis (and printing of error messages) needs to be
+ * done directly at the EFI function call-site.
+ *
+ * For example, EFI_INVALID_PARAMETER could indicate a bug or maybe we
+ * just didn't find any PCI devices, but there's no way to tell outside
+ * the context of the call.
+ */
+static void setup_efi_pci(struct boot_params *params)
 {
 	efi_status_t status;
 	void **pci_handle = NULL;
@@ -527,7 +539,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 					size, (void **)&pci_handle);
 
 		if (status != EFI_SUCCESS)
-			return status;
+			return;
 
 		status = efi_call_early(locate_handle,
 					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
@@ -538,13 +550,12 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		goto free_handle;
 
 	if (efi_early->is64)
-		status = setup_efi_pci64(params, pci_handle, size);
+		setup_efi_pci64(params, pci_handle, size);
 	else
-		status = setup_efi_pci32(params, pci_handle, size);
+		setup_efi_pci32(params, pci_handle, size);
 
 free_handle:
 	efi_call_early(free_pool, pci_handle);
-	return status;
 }
 
 static void
@@ -1380,10 +1391,7 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_graphics(boot_params);
 
-	status = setup_efi_pci(boot_params);
-	if (status != EFI_SUCCESS) {
-		efi_printk(sys_table, "setup_efi_pci() failed!\n");
-	}
+	setup_efi_pci(boot_params);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
 				sizeof(*gdt), (void **)&gdt);
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index d487e727f1ec..c88c31ecad12 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -103,4 +103,20 @@ struct efi_uga_draw_protocol {
 	void *blt;
 };
 
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
 #endif /* BOOT_COMPRESSED_EBOOT_H */
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 044a2fd3c5fe..0ec241ede5a2 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -159,30 +159,6 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 }
 #endif /* CONFIG_EFI_MIXED */
 
-
-/* arch specific definitions used by the stub code */
-
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
-extern struct efi_config *efi_early;
-
-#define efi_call_early(f, ...)						\
-	efi_early->call(efi_early->f, __VA_ARGS__);
-
 extern bool efi_reboot_required(void);
 
 #else
diff --git a/arch/x86/include/asm/fixmap.h b/arch/x86/include/asm/fixmap.h
index b0910f97a3ea..ffb1733ac91f 100644
--- a/arch/x86/include/asm/fixmap.h
+++ b/arch/x86/include/asm/fixmap.h
@@ -106,14 +106,14 @@ enum fixed_addresses {
 	__end_of_permanent_fixed_addresses,
 
 	/*
-	 * 256 temporary boot-time mappings, used by early_ioremap(),
+	 * 512 temporary boot-time mappings, used by early_ioremap(),
 	 * before ioremap() is functional.
 	 *
-	 * If necessary we round it up to the next 256 pages boundary so
+	 * If necessary we round it up to the next 512 pages boundary so
 	 * that we can have a single pgd entry and a single pte table:
 	 */
 #define NR_FIX_BTMAPS		64
-#define FIX_BTMAPS_SLOTS	4
+#define FIX_BTMAPS_SLOTS	8
 #define TOTAL_FIX_BTMAPS	(NR_FIX_BTMAPS * FIX_BTMAPS_SLOTS)
 	FIX_BTMAP_END =
 	 (__end_of_permanent_fixed_addresses ^
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index d8be608a9f3b..aef6a95adef5 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -7,4 +7,4 @@ obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
 obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
 obj-$(CONFIG_EFI_RUNTIME_WRAPPERS)	+= runtime-wrappers.o
-obj-$(CONFIG_EFI_STUB)			+= libstub/
+obj-$(CONFIG_EFI_ARM_STUB)		+= libstub/
