Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753328AbaCaOfo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 31 Mar 2014 10:35:44 -0400
Received: from mail-wi0-f181.google.com ([209.85.212.181]:33984 "EHLO
	mail-wi0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751703AbaCaOfk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 31 Mar 2014 10:35:40 -0400
Date: Mon, 31 Mar 2014 16:35:35 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Matt Fleming <matt@console-pimps.org>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] EFI changes for v3.15
Message-ID: <20140331143535.GA11450@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

   # HEAD: 204b0a1a4b92612c957a042df1a3be0e9cc79391 x86, efi: Abstract x86 efi_early calls

The main changes:

 * Add debug code to the dump EFI pagetable - Borislav Petkov

 * Make 1:1 runtime mapping robust when booting on machines with lots of
   memory - Borislav Petkov

 * Move the EFI facilities bits out of 'x86_efi_facility' and into
   efi.flags which is the standard architecture independent place to
   keep EFI state, by Matt Fleming.

 * Add 'EFI mixed mode' support: this allows 64-bit kernels to be 
   booted from 32-bit firmware. This needs a bootloader that supports 
   the 'EFI handover protocol'. By Matt Fleming.


  out-of-topic modifications in x86-efi-for-linus:
  --------------------------------------------------
  arch/ia64/kernel/efi.c             # 0920638: ia64/efi: Implement efi_enabled()
  drivers/firmware/efi/efi-stub-helper.c# 204b0a1: x86, efi: Abstract x86 efi_early 
                                   # 54b52d8: x86/efi: Build our own EFI servic
  drivers/firmware/efi/efi.c         # 69e6084: efi: Use NULL instead of 0 for po
                                   # 0f8093a: efi: Set feature flags inside fea
  drivers/firmware/efi/efivars.c     # 69e6084: efi: Use NULL instead of 0 for po
  fs/efivarfs/file.c                 # aca32b5: efivarfs: 'efivarfs_file_write' f

 Thanks,

	Ingo

------------------>
Borislav Petkov (5):
      x86, ptdump: Add the functionality to dump an arbitrary pagetable
      x86/efi: Dump the EFI page table
      x86, pageattr: Export page unmapping interface
      x86/efi: Make efi virtual runtime map passing more robust
      x86/efi: Split efi_enter_virtual_mode

Daeseok Youn (1):
      efi: Use NULL instead of 0 for pointer

Geyslan G. Bem (1):
      efivarfs: 'efivarfs_file_write' function reorganization

Joe Perches (1):
      x86/efi: Style neatening

Madper Xie (1):
      x86/efi: Delete out-of-date comments of efi_query_variable_store

Matt Fleming (22):
      efi: Move facility flags to struct efi
      efi: Set feature flags inside feature init functions
      ia64/efi: Implement efi_enabled()
      x86/boot: Cleanup header.S by removing some #ifdefs
      x86, tools: Consolidate #ifdef code
      x86/mm/pageattr: Always dump the right page table in an oops
      x86/efi: Delete dead code when checking for non-native
      efi: Add separate 32-bit/64-bit definitions
      x86/efi: Build our own EFI services pointer table
      x86/efi: Add early thunk code to go from 64-bit to 32-bit
      x86/efi: Split the boot stub into 32/64 code paths
      x86/efi: Firmware agnostic handover entry points
      x86/efi: Add mixed runtime services support
      x86/efi: Wire up CONFIG_EFI_MIXED
      x86/boot: Don't overwrite cr4 when enabling PAE
      x86/efi: Re-disable interrupts after calling firmware services
      x86, tools: Fix up compiler warnings
      x86/boot: Fix non-EFI build
      x86/efi: Preserve segment registers in mixed mode
      x86/efi: Rip out phys_efi_get_time()
      x86/efi: Restore 'attr' argument to query_variable_info()
      x86, efi: Abstract x86 efi_early calls


 arch/ia64/kernel/efi.c                 |    7 +
 arch/x86/Kconfig                       |   14 +
 arch/x86/Kconfig.debug                 |    9 +
 arch/x86/boot/Makefile                 |    2 +-
 arch/x86/boot/compressed/eboot.c       | 1017 +++++++++++++++++++++++++-------
 arch/x86/boot/compressed/eboot.h       |   60 ++
 arch/x86/boot/compressed/efi_stub_64.S |   29 +
 arch/x86/boot/compressed/head_32.S     |   52 +-
 arch/x86/boot/compressed/head_64.S     |  111 +++-
 arch/x86/boot/header.S                 |   23 +-
 arch/x86/boot/tools/build.c            |   77 ++-
 arch/x86/include/asm/efi.h             |   43 +-
 arch/x86/include/asm/pgtable.h         |    3 +-
 arch/x86/include/asm/pgtable_types.h   |    4 +
 arch/x86/kernel/setup.c                |    6 +-
 arch/x86/mm/dump_pagetables.c          |   84 ++-
 arch/x86/mm/fault.c                    |    7 +-
 arch/x86/mm/pageattr.c                 |   56 +-
 arch/x86/platform/efi/Makefile         |    1 +
 arch/x86/platform/efi/efi.c            |  415 ++++++++-----
 arch/x86/platform/efi/efi_32.c         |    7 +-
 arch/x86/platform/efi/efi_64.c         |  368 +++++++++++-
 arch/x86/platform/efi/efi_stub_64.S    |  166 ++++++
 arch/x86/platform/efi/efi_thunk_64.S   |   65 ++
 drivers/firmware/efi/efi-stub-helper.c |  136 +----
 drivers/firmware/efi/efi.c             |    5 +-
 drivers/firmware/efi/efivars.c         |    2 +-
 fs/efivarfs/file.c                     |   13 +-
 include/linux/efi.h                    |  268 ++++++++-
 29 files changed, 2452 insertions(+), 598 deletions(-)
 create mode 100644 arch/x86/platform/efi/efi_thunk_64.S

diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index da5b462..741b99c 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -477,6 +477,9 @@ efi_init (void)
 	char *cp, vendor[100] = "unknown";
 	int i;
 
+	set_bit(EFI_BOOT, &efi.flags);
+	set_bit(EFI_64BIT, &efi.flags);
+
 	/*
 	 * It's too early to be able to use the standard kernel command line
 	 * support...
@@ -529,6 +532,8 @@ efi_init (void)
 	       efi.systab->hdr.revision >> 16,
 	       efi.systab->hdr.revision & 0xffff, vendor);
 
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
 	palo_phys      = EFI_INVALID_TABLE_ADDR;
 
 	if (efi_config_init(arch_tables) != 0)
@@ -657,6 +662,8 @@ efi_enter_virtual_mode (void)
 		return;
 	}
 
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
+
 	/*
 	 * Now that EFI is in virtual mode, we call the EFI functions more
 	 * efficiently:
diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index 0af5250..8453fe1 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -1585,6 +1585,20 @@ config EFI_STUB
 
 	  See Documentation/efi-stub.txt for more information.
 
+config EFI_MIXED
+	bool "EFI mixed-mode support"
+	depends on EFI_STUB && X86_64
+	---help---
+	   Enabling this feature allows a 64-bit kernel to be booted
+	   on a 32-bit firmware, provided that your CPU supports 64-bit
+	   mode.
+
+	   Note that it is not possible to boot a mixed-mode enabled
+	   kernel via the EFI boot stub - a bootloader that supports
+	   the EFI handover protocol must be used.
+
+	   If unsure, say N.
+
 config SECCOMP
 	def_bool y
 	prompt "Enable seccomp to safely compute untrusted bytecode"
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 321a52c..61bd2ad 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -81,6 +81,15 @@ config X86_PTDUMP
 	  kernel.
 	  If in doubt, say "N"
 
+config EFI_PGT_DUMP
+	bool "Dump the EFI pagetable"
+	depends on EFI && X86_PTDUMP
+	---help---
+	  Enable this if you want to dump the EFI page table before
+	  enabling virtual mode. This can be used to debug miscellaneous
+	  issues with the mapping of the EFI runtime regions into that
+	  table.
+
 config DEBUG_RODATA
 	bool "Write protect kernel read-only data structures"
 	default y
diff --git a/arch/x86/boot/Makefile b/arch/x86/boot/Makefile
index 878df7e..abb9eba 100644
--- a/arch/x86/boot/Makefile
+++ b/arch/x86/boot/Makefile
@@ -80,7 +80,7 @@ targets += voffset.h
 $(obj)/voffset.h: vmlinux FORCE
 	$(call if_changed,voffset)
 
-sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi_pe_entry\|efi_stub_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
+sed-zoffset := -e 's/^\([0-9a-fA-F]*\) . \(startup_32\|startup_64\|efi32_stub_entry\|efi64_stub_entry\|efi_pe_entry\|input_data\|_end\|z_.*\)$$/\#define ZO_\2 0x\1/p'
 
 quiet_cmd_zoffset = ZOFFSET $@
       cmd_zoffset = $(NM) $< | sed -n $(sed-zoffset) > $@
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index a7677ba..1e61461 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,10 +19,272 @@
 
 static efi_system_table_t *sys_table;
 
+static struct efi_config *efi_early;
+
+#define efi_call_early(f, ...)						\
+	efi_early->call(efi_early->f, __VA_ARGS__);
+
+#define BOOT_SERVICES(bits)						\
+static void setup_boot_services##bits(struct efi_config *c)		\
+{									\
+	efi_system_table_##bits##_t *table;				\
+	efi_boot_services_##bits##_t *bt;				\
+									\
+	table = (typeof(table))sys_table;				\
+									\
+	c->text_output = table->con_out;				\
+									\
+	bt = (typeof(bt))(unsigned long)(table->boottime);		\
+									\
+	c->allocate_pool = bt->allocate_pool;				\
+	c->allocate_pages = bt->allocate_pages;				\
+	c->get_memory_map = bt->get_memory_map;				\
+	c->free_pool = bt->free_pool;					\
+	c->free_pages = bt->free_pages;					\
+	c->locate_handle = bt->locate_handle;				\
+	c->handle_protocol = bt->handle_protocol;			\
+	c->exit_boot_services = bt->exit_boot_services;			\
+}
+BOOT_SERVICES(32);
+BOOT_SERVICES(64);
 
-#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
+static void efi_printk(efi_system_table_t *, char *);
+static void efi_char16_printk(efi_system_table_t *, efi_char16_t *);
+
+static efi_status_t
+__file_size32(void *__fh, efi_char16_t *filename_16,
+	      void **handle, u64 *file_sz)
+{
+	efi_file_handle_32_t *h, *fh = __fh;
+	efi_file_info_t *info;
+	efi_status_t status;
+	efi_guid_t info_guid = EFI_FILE_INFO_ID;
+	u32 info_sz;
+
+	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
+				 EFI_FILE_MODE_READ, (u64)0);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to open file: ");
+		efi_char16_printk(sys_table, filename_16);
+		efi_printk(sys_table, "\n");
+		return status;
+	}
+
+	*handle = h;
+
+	info_sz = 0;
+	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
+				 &info_sz, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		efi_printk(sys_table, "Failed to get file info size\n");
+		return status;
+	}
+
+grow:
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				info_sz, (void **)&info);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for file info\n");
+		return status;
+	}
+
+	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
+				 &info_sz, info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_call_early(free_pool, info);
+		goto grow;
+	}
+
+	*file_sz = info->file_size;
+	efi_call_early(free_pool, info);
+
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to get initrd info\n");
+
+	return status;
+}
+
+static efi_status_t
+__file_size64(void *__fh, efi_char16_t *filename_16,
+	      void **handle, u64 *file_sz)
+{
+	efi_file_handle_64_t *h, *fh = __fh;
+	efi_file_info_t *info;
+	efi_status_t status;
+	efi_guid_t info_guid = EFI_FILE_INFO_ID;
+	u32 info_sz;
 
+	status = efi_early->call((unsigned long)fh->open, fh, &h, filename_16,
+				 EFI_FILE_MODE_READ, (u64)0);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to open file: ");
+		efi_char16_printk(sys_table, filename_16);
+		efi_printk(sys_table, "\n");
+		return status;
+	}
 
+	*handle = h;
+
+	info_sz = 0;
+	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
+				 &info_sz, NULL);
+	if (status != EFI_BUFFER_TOO_SMALL) {
+		efi_printk(sys_table, "Failed to get file info size\n");
+		return status;
+	}
+
+grow:
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				info_sz, (void **)&info);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for file info\n");
+		return status;
+	}
+
+	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
+				 &info_sz, info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_call_early(free_pool, info);
+		goto grow;
+	}
+
+	*file_sz = info->file_size;
+	efi_call_early(free_pool, info);
+
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to get initrd info\n");
+
+	return status;
+}
+static efi_status_t
+efi_file_size(efi_system_table_t *sys_table, void *__fh,
+	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
+{
+	if (efi_early->is64)
+		return __file_size64(__fh, filename_16, handle, file_sz);
+
+	return __file_size32(__fh, filename_16, handle, file_sz);
+}
+
+static inline efi_status_t
+efi_file_read(void *__fh, void *handle, unsigned long *size, void *addr)
+{
+	unsigned long func;
+
+	if (efi_early->is64) {
+		efi_file_handle_64_t *fh = __fh;
+
+		func = (unsigned long)fh->read;
+		return efi_early->call(func, handle, size, addr);
+	} else {
+		efi_file_handle_32_t *fh = __fh;
+
+		func = (unsigned long)fh->read;
+		return efi_early->call(func, handle, size, addr);
+	}
+}
+
+static inline efi_status_t efi_file_close(void *__fh, void *handle)
+{
+	if (efi_early->is64) {
+		efi_file_handle_64_t *fh = __fh;
+
+		return efi_early->call((unsigned long)fh->close, handle);
+	} else {
+		efi_file_handle_32_t *fh = __fh;
+
+		return efi_early->call((unsigned long)fh->close, handle);
+	}
+}
+
+static inline efi_status_t __open_volume32(void *__image, void **__fh)
+{
+	efi_file_io_interface_t *io;
+	efi_loaded_image_32_t *image = __image;
+	efi_file_handle_32_t *fh;
+	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+	efi_status_t status;
+	void *handle = (void *)(unsigned long)image->device_handle;
+	unsigned long func;
+
+	status = efi_call_early(handle_protocol, handle,
+				&fs_proto, (void **)&io);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to handle fs_proto\n");
+		return status;
+	}
+
+	func = (unsigned long)io->open_volume;
+	status = efi_early->call(func, io, &fh);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to open volume\n");
+
+	*__fh = fh;
+	return status;
+}
+
+static inline efi_status_t __open_volume64(void *__image, void **__fh)
+{
+	efi_file_io_interface_t *io;
+	efi_loaded_image_64_t *image = __image;
+	efi_file_handle_64_t *fh;
+	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+	efi_status_t status;
+	void *handle = (void *)(unsigned long)image->device_handle;
+	unsigned long func;
+
+	status = efi_call_early(handle_protocol, handle,
+				&fs_proto, (void **)&io);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to handle fs_proto\n");
+		return status;
+	}
+
+	func = (unsigned long)io->open_volume;
+	status = efi_early->call(func, io, &fh);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to open volume\n");
+
+	*__fh = fh;
+	return status;
+}
+
+static inline efi_status_t
+efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
+{
+	if (efi_early->is64)
+		return __open_volume64(__image, __fh);
+
+	return __open_volume32(__image, __fh);
+}
+
+static void efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
+{
+	unsigned long output_string;
+	size_t offset;
+
+	if (efi_early->is64) {
+		struct efi_simple_text_output_protocol_64 *out;
+		u64 *func;
+
+		offset = offsetof(typeof(*out), output_string);
+		output_string = efi_early->text_output + offset;
+		func = (u64 *)output_string;
+
+		efi_early->call(*func, efi_early->text_output, str);
+	} else {
+		struct efi_simple_text_output_protocol_32 *out;
+		u32 *func;
+
+		offset = offsetof(typeof(*out), output_string);
+		output_string = efi_early->text_output + offset;
+		func = (u32 *)output_string;
+
+		efi_early->call(*func, efi_early->text_output, str);
+	}
+}
+
+#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
 
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
@@ -47,105 +309,97 @@ static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 	*size = len;
 }
 
-static efi_status_t setup_efi_pci(struct boot_params *params)
+static efi_status_t
+__setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 {
-	efi_pci_io_protocol *pci;
+	struct pci_setup_rom *rom = NULL;
 	efi_status_t status;
-	void **pci_handle;
-	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
-	unsigned long nr_pci, size = 0;
-	int i;
-	struct setup_data *data;
+	unsigned long size;
+	uint64_t attributes;
 
-	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
+	status = efi_early->call(pci->attributes, pci,
+				 EfiPciIoAttributeOperationGet, 0, 0,
+				 &attributes);
+	if (status != EFI_SUCCESS)
+		return status;
 
-	while (data && data->next)
-		data = (struct setup_data *)(unsigned long)data->next;
+	if (!pci->romimage || !pci->romsize)
+		return EFI_INVALID_PARAMETER;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-				NULL, &size, pci_handle);
+	size = pci->romsize + sizeof(*rom);
 
-	if (status == EFI_BUFFER_TOO_SMALL) {
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-					EFI_LOADER_DATA, size, &pci_handle);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
+	if (status != EFI_SUCCESS)
+		return status;
 
-		if (status != EFI_SUCCESS)
-			return status;
+	memset(rom, 0, sizeof(*rom));
 
-		status = efi_call_phys5(sys_table->boottime->locate_handle,
-					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-					NULL, &size, pci_handle);
-	}
+	rom->data.type = SETUP_PCI;
+	rom->data.len = size - sizeof(struct setup_data);
+	rom->data.next = 0;
+	rom->pcilen = pci->romsize;
+	*__rom = rom;
 
-	if (status != EFI_SUCCESS)
-		goto free_handle;
-
-	nr_pci = size / sizeof(void *);
-	for (i = 0; i < nr_pci; i++) {
-		void *h = pci_handle[i];
-		uint64_t attributes;
-		struct pci_setup_rom *rom;
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_VENDOR_ID, 1, &(rom->vendor));
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, &pci_proto, &pci);
+	if (status != EFI_SUCCESS)
+		goto free_struct;
 
-		if (status != EFI_SUCCESS)
-			continue;
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_DEVICE_ID, 1, &(rom->devid));
 
-		if (!pci)
-			continue;
+	if (status != EFI_SUCCESS)
+		goto free_struct;
 
-#ifdef CONFIG_X86_64
-		status = efi_call_phys4(pci->attributes, pci,
-					EfiPciIoAttributeOperationGet, 0,
-					&attributes);
-#else
-		status = efi_call_phys5(pci->attributes, pci,
-					EfiPciIoAttributeOperationGet, 0, 0,
-					&attributes);
-#endif
-		if (status != EFI_SUCCESS)
-			continue;
+	status = efi_early->call(pci->get_location, pci, &(rom->segment),
+				 &(rom->bus), &(rom->device), &(rom->function));
 
-		if (!pci->romimage || !pci->romsize)
-			continue;
+	if (status != EFI_SUCCESS)
+		goto free_struct;
 
-		size = pci->romsize + sizeof(*rom);
+	memcpy(rom->romdata, pci->romimage, pci->romsize);
+	return status;
 
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &rom);
+free_struct:
+	efi_call_early(free_pool, rom);
+	return status;
+}
 
-		if (status != EFI_SUCCESS)
-			continue;
+static efi_status_t
+setup_efi_pci32(struct boot_params *params, void **pci_handle,
+		unsigned long size)
+{
+	efi_pci_io_protocol_32 *pci = NULL;
+	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
+	u32 *handles = (u32 *)(unsigned long)pci_handle;
+	efi_status_t status;
+	unsigned long nr_pci;
+	struct setup_data *data;
+	int i;
 
-		rom->data.type = SETUP_PCI;
-		rom->data.len = size - sizeof(struct setup_data);
-		rom->data.next = 0;
-		rom->pcilen = pci->romsize;
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
-		status = efi_call_phys5(pci->pci.read, pci,
-					EfiPciIoWidthUint16, PCI_VENDOR_ID,
-					1, &(rom->vendor));
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
 
-		if (status != EFI_SUCCESS)
-			goto free_struct;
+	nr_pci = size / sizeof(u32);
+	for (i = 0; i < nr_pci; i++) {
+		struct pci_setup_rom *rom = NULL;
+		u32 h = handles[i];
 
-		status = efi_call_phys5(pci->pci.read, pci,
-					EfiPciIoWidthUint16, PCI_DEVICE_ID,
-					1, &(rom->devid));
+		status = efi_call_early(handle_protocol, h,
+					&pci_proto, (void **)&pci);
 
 		if (status != EFI_SUCCESS)
-			goto free_struct;
+			continue;
 
-		status = efi_call_phys5(pci->get_location, pci,
-					&(rom->segment), &(rom->bus),
-					&(rom->device), &(rom->function));
+		if (!pci)
+			continue;
 
+		status = __setup_efi_pci32(pci, &rom);
 		if (status != EFI_SUCCESS)
-			goto free_struct;
-
-		memcpy(rom->romdata, pci->romimage, pci->romsize);
+			continue;
 
 		if (data)
 			data->next = (unsigned long)rom;
@@ -154,105 +408,155 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 
 		data = (struct setup_data *)rom;
 
-		continue;
-	free_struct:
-		efi_call_phys1(sys_table->boottime->free_pool, rom);
 	}
 
-free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, pci_handle);
 	return status;
 }
 
-/*
- * See if we have Graphics Output Protocol
- */
-static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
-			      unsigned long size)
+static efi_status_t
+__setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
 {
-	struct efi_graphics_output_protocol *gop, *first_gop;
-	struct efi_pixel_bitmask pixel_info;
-	unsigned long nr_gops;
+	struct pci_setup_rom *rom;
 	efi_status_t status;
-	void **gop_handle;
-	u16 width, height;
-	u32 fb_base, fb_size;
-	u32 pixels_per_scan_line;
-	int pixel_format;
-	int i;
+	unsigned long size;
+	uint64_t attributes;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &gop_handle);
+	status = efi_early->call(pci->attributes, pci,
+				 EfiPciIoAttributeOperationGet, 0,
+				 &attributes);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, proto,
-				NULL, &size, gop_handle);
+	if (!pci->romimage || !pci->romsize)
+		return EFI_INVALID_PARAMETER;
+
+	size = pci->romsize + sizeof(*rom);
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
 	if (status != EFI_SUCCESS)
-		goto free_handle;
+		return status;
 
-	first_gop = NULL;
+	rom->data.type = SETUP_PCI;
+	rom->data.len = size - sizeof(struct setup_data);
+	rom->data.next = 0;
+	rom->pcilen = pci->romsize;
+	*__rom = rom;
 
-	nr_gops = size / sizeof(void *);
-	for (i = 0; i < nr_gops; i++) {
-		struct efi_graphics_output_mode_info *info;
-		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
-		bool conout_found = false;
-		void *dummy;
-		void *h = gop_handle[i];
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_VENDOR_ID, 1, &(rom->vendor));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
+				 PCI_DEVICE_ID, 1, &(rom->devid));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	status = efi_early->call(pci->get_location, pci, &(rom->segment),
+				 &(rom->bus), &(rom->device), &(rom->function));
+
+	if (status != EFI_SUCCESS)
+		goto free_struct;
+
+	memcpy(rom->romdata, pci->romimage, pci->romsize);
+	return status;
+
+free_struct:
+	efi_call_early(free_pool, rom);
+	return status;
+
+}
+
+static efi_status_t
+setup_efi_pci64(struct boot_params *params, void **pci_handle,
+		unsigned long size)
+{
+	efi_pci_io_protocol_64 *pci = NULL;
+	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
+	u64 *handles = (u64 *)(unsigned long)pci_handle;
+	efi_status_t status;
+	unsigned long nr_pci;
+	struct setup_data *data;
+	int i;
+
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
+
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
+
+	nr_pci = size / sizeof(u64);
+	for (i = 0; i < nr_pci; i++) {
+		struct pci_setup_rom *rom = NULL;
+		u64 h = handles[i];
+
+		status = efi_call_early(handle_protocol, h,
+					&pci_proto, (void **)&pci);
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, proto, &gop);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, &conout_proto, &dummy);
+		if (!pci)
+			continue;
 
-		if (status == EFI_SUCCESS)
-			conout_found = true;
+		status = __setup_efi_pci64(pci, &rom);
+		if (status != EFI_SUCCESS)
+			continue;
 
-		status = efi_call_phys4(gop->query_mode, gop,
-					gop->mode->mode, &size, &info);
-		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
-			/*
-			 * Systems that use the UEFI Console Splitter may
-			 * provide multiple GOP devices, not all of which are
-			 * backed by real hardware. The workaround is to search
-			 * for a GOP implementing the ConOut protocol, and if
-			 * one isn't found, to just fall back to the first GOP.
-			 */
-			width = info->horizontal_resolution;
-			height = info->vertical_resolution;
-			fb_base = gop->mode->frame_buffer_base;
-			fb_size = gop->mode->frame_buffer_size;
-			pixel_format = info->pixel_format;
-			pixel_info = info->pixel_information;
-			pixels_per_scan_line = info->pixels_per_scan_line;
+		if (data)
+			data->next = (unsigned long)rom;
+		else
+			params->hdr.setup_data = (unsigned long)rom;
+
+		data = (struct setup_data *)rom;
 
-			/*
-			 * Once we've found a GOP supporting ConOut,
-			 * don't bother looking any further.
-			 */
-			first_gop = gop;
-			if (conout_found)
-				break;
-		}
 	}
 
-	/* Did we find any GOPs? */
-	if (!first_gop)
+	return status;
+}
+
+static efi_status_t setup_efi_pci(struct boot_params *params)
+{
+	efi_status_t status;
+	void **pci_handle = NULL;
+	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
+	unsigned long size = 0;
+
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				&pci_proto, NULL, &size, pci_handle);
+
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		status = efi_call_early(allocate_pool,
+					EFI_LOADER_DATA,
+					size, (void **)&pci_handle);
+
+		if (status != EFI_SUCCESS)
+			return status;
+
+		status = efi_call_early(locate_handle,
+					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
+					NULL, &size, pci_handle);
+	}
+
+	if (status != EFI_SUCCESS)
 		goto free_handle;
 
-	/* EFI framebuffer */
-	si->orig_video_isVGA = VIDEO_TYPE_EFI;
+	if (efi_early->is64)
+		status = setup_efi_pci64(params, pci_handle, size);
+	else
+		status = setup_efi_pci32(params, pci_handle, size);
 
-	si->lfb_width = width;
-	si->lfb_height = height;
-	si->lfb_base = fb_base;
-	si->pages = 1;
+free_handle:
+	efi_call_early(free_pool, pci_handle);
+	return status;
+}
 
+static void
+setup_pixel_info(struct screen_info *si, u32 pixels_per_scan_line,
+		 struct efi_pixel_bitmask pixel_info, int pixel_format)
+{
 	if (pixel_format == PIXEL_RGB_RESERVED_8BIT_PER_COLOR) {
 		si->lfb_depth = 32;
 		si->lfb_linelength = pixels_per_scan_line * 4;
@@ -297,62 +601,319 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		si->rsvd_size = 0;
 		si->rsvd_pos = 0;
 	}
+}
+
+static efi_status_t
+__gop_query32(struct efi_graphics_output_protocol_32 *gop32,
+	      struct efi_graphics_output_mode_info **info,
+	      unsigned long *size, u32 *fb_base)
+{
+	struct efi_graphics_output_protocol_mode_32 *mode;
+	efi_status_t status;
+	unsigned long m;
+
+	m = gop32->mode;
+	mode = (struct efi_graphics_output_protocol_mode_32 *)m;
+
+	status = efi_early->call(gop32->query_mode, gop32,
+				 mode->mode, size, info);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*fb_base = mode->frame_buffer_base;
+	return status;
+}
+
+static efi_status_t
+setup_gop32(struct screen_info *si, efi_guid_t *proto,
+	    unsigned long size, void **gop_handle)
+{
+	struct efi_graphics_output_protocol_32 *gop32, *first_gop;
+	unsigned long nr_gops;
+	u16 width, height;
+	u32 pixels_per_scan_line;
+	u32 fb_base;
+	struct efi_pixel_bitmask pixel_info;
+	int pixel_format;
+	efi_status_t status;
+	u32 *handles = (u32 *)(unsigned long)gop_handle;
+	int i;
+
+	first_gop = NULL;
+	gop32 = NULL;
+
+	nr_gops = size / sizeof(u32);
+	for (i = 0; i < nr_gops; i++) {
+		struct efi_graphics_output_mode_info *info = NULL;
+		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
+		bool conout_found = false;
+		void *dummy = NULL;
+		u32 h = handles[i];
+
+		status = efi_call_early(handle_protocol, h,
+					proto, (void **)&gop32);
+		if (status != EFI_SUCCESS)
+			continue;
+
+		status = efi_call_early(handle_protocol, h,
+					&conout_proto, &dummy);
+		if (status == EFI_SUCCESS)
+			conout_found = true;
+
+		status = __gop_query32(gop32, &info, &size, &fb_base);
+		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+			/*
+			 * Systems that use the UEFI Console Splitter may
+			 * provide multiple GOP devices, not all of which are
+			 * backed by real hardware. The workaround is to search
+			 * for a GOP implementing the ConOut protocol, and if
+			 * one isn't found, to just fall back to the first GOP.
+			 */
+			width = info->horizontal_resolution;
+			height = info->vertical_resolution;
+			pixel_format = info->pixel_format;
+			pixel_info = info->pixel_information;
+			pixels_per_scan_line = info->pixels_per_scan_line;
+
+			/*
+			 * Once we've found a GOP supporting ConOut,
+			 * don't bother looking any further.
+			 */
+			first_gop = gop32;
+			if (conout_found)
+				break;
+		}
+	}
+
+	/* Did we find any GOPs? */
+	if (!first_gop)
+		goto out;
+
+	/* EFI framebuffer */
+	si->orig_video_isVGA = VIDEO_TYPE_EFI;
+
+	si->lfb_width = width;
+	si->lfb_height = height;
+	si->lfb_base = fb_base;
+	si->pages = 1;
+
+	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
 
 	si->lfb_size = si->lfb_linelength * si->lfb_height;
 
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
+out:
+	return status;
+}
 
-free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, gop_handle);
+static efi_status_t
+__gop_query64(struct efi_graphics_output_protocol_64 *gop64,
+	      struct efi_graphics_output_mode_info **info,
+	      unsigned long *size, u32 *fb_base)
+{
+	struct efi_graphics_output_protocol_mode_64 *mode;
+	efi_status_t status;
+	unsigned long m;
+
+	m = gop64->mode;
+	mode = (struct efi_graphics_output_protocol_mode_64 *)m;
+
+	status = efi_early->call(gop64->query_mode, gop64,
+				 mode->mode, size, info);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	*fb_base = mode->frame_buffer_base;
+	return status;
+}
+
+static efi_status_t
+setup_gop64(struct screen_info *si, efi_guid_t *proto,
+	    unsigned long size, void **gop_handle)
+{
+	struct efi_graphics_output_protocol_64 *gop64, *first_gop;
+	unsigned long nr_gops;
+	u16 width, height;
+	u32 pixels_per_scan_line;
+	u32 fb_base;
+	struct efi_pixel_bitmask pixel_info;
+	int pixel_format;
+	efi_status_t status;
+	u64 *handles = (u64 *)(unsigned long)gop_handle;
+	int i;
+
+	first_gop = NULL;
+	gop64 = NULL;
+
+	nr_gops = size / sizeof(u64);
+	for (i = 0; i < nr_gops; i++) {
+		struct efi_graphics_output_mode_info *info = NULL;
+		efi_guid_t conout_proto = EFI_CONSOLE_OUT_DEVICE_GUID;
+		bool conout_found = false;
+		void *dummy = NULL;
+		u64 h = handles[i];
+
+		status = efi_call_early(handle_protocol, h,
+					proto, (void **)&gop64);
+		if (status != EFI_SUCCESS)
+			continue;
+
+		status = efi_call_early(handle_protocol, h,
+					&conout_proto, &dummy);
+		if (status == EFI_SUCCESS)
+			conout_found = true;
+
+		status = __gop_query64(gop64, &info, &size, &fb_base);
+		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
+			/*
+			 * Systems that use the UEFI Console Splitter may
+			 * provide multiple GOP devices, not all of which are
+			 * backed by real hardware. The workaround is to search
+			 * for a GOP implementing the ConOut protocol, and if
+			 * one isn't found, to just fall back to the first GOP.
+			 */
+			width = info->horizontal_resolution;
+			height = info->vertical_resolution;
+			pixel_format = info->pixel_format;
+			pixel_info = info->pixel_information;
+			pixels_per_scan_line = info->pixels_per_scan_line;
+
+			/*
+			 * Once we've found a GOP supporting ConOut,
+			 * don't bother looking any further.
+			 */
+			first_gop = gop64;
+			if (conout_found)
+				break;
+		}
+	}
+
+	/* Did we find any GOPs? */
+	if (!first_gop)
+		goto out;
+
+	/* EFI framebuffer */
+	si->orig_video_isVGA = VIDEO_TYPE_EFI;
+
+	si->lfb_width = width;
+	si->lfb_height = height;
+	si->lfb_base = fb_base;
+	si->pages = 1;
+
+	setup_pixel_info(si, pixels_per_scan_line, pixel_info, pixel_format);
+
+	si->lfb_size = si->lfb_linelength * si->lfb_height;
+
+	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
+out:
 	return status;
 }
 
 /*
- * See if we have Universal Graphics Adapter (UGA) protocol
+ * See if we have Graphics Output Protocol
  */
-static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
+static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 			      unsigned long size)
 {
-	struct efi_uga_draw_protocol *uga, *first_uga;
-	unsigned long nr_ugas;
 	efi_status_t status;
-	u32 width, height;
-	void **uga_handle = NULL;
-	int i;
+	void **gop_handle = NULL;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &uga_handle);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)&gop_handle);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, uga_proto,
-				NULL, &size, uga_handle);
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				proto, NULL, &size, gop_handle);
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
+	if (efi_early->is64)
+		status = setup_gop64(si, proto, size, gop_handle);
+	else
+		status = setup_gop32(si, proto, size, gop_handle);
+
+free_handle:
+	efi_call_early(free_pool, gop_handle);
+	return status;
+}
+
+static efi_status_t
+setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
+{
+	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
+	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
+	unsigned long nr_ugas;
+	u32 *handles = (u32 *)uga_handle;;
+	efi_status_t status;
+	int i;
+
 	first_uga = NULL;
+	nr_ugas = size / sizeof(u32);
+	for (i = 0; i < nr_ugas; i++) {
+		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
+		u32 w, h, depth, refresh;
+		void *pciio;
+		u32 handle = handles[i];
+
+		status = efi_call_early(handle_protocol, handle,
+					&uga_proto, (void **)&uga);
+		if (status != EFI_SUCCESS)
+			continue;
+
+		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
+
+		status = efi_early->call((unsigned long)uga->get_mode, uga,
+					 &w, &h, &depth, &refresh);
+		if (status == EFI_SUCCESS && (!first_uga || pciio)) {
+			*width = w;
+			*height = h;
+
+			/*
+			 * Once we've found a UGA supporting PCIIO,
+			 * don't bother looking any further.
+			 */
+			if (pciio)
+				break;
 
-	nr_ugas = size / sizeof(void *);
+			first_uga = uga;
+		}
+	}
+
+	return status;
+}
+
+static efi_status_t
+setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
+{
+	struct efi_uga_draw_protocol *uga = NULL, *first_uga;
+	efi_guid_t uga_proto = EFI_UGA_PROTOCOL_GUID;
+	unsigned long nr_ugas;
+	u64 *handles = (u64 *)uga_handle;;
+	efi_status_t status;
+	int i;
+
+	first_uga = NULL;
+	nr_ugas = size / sizeof(u64);
 	for (i = 0; i < nr_ugas; i++) {
 		efi_guid_t pciio_proto = EFI_PCI_IO_PROTOCOL_GUID;
-		void *handle = uga_handle[i];
 		u32 w, h, depth, refresh;
 		void *pciio;
+		u64 handle = handles[i];
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					handle, uga_proto, &uga);
+		status = efi_call_early(handle_protocol, handle,
+					&uga_proto, (void **)&uga);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_call_phys3(sys_table->boottime->handle_protocol,
-			       handle, &pciio_proto, &pciio);
+		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
 
-		status = efi_call_phys5(uga->get_mode, uga, &w, &h,
-					&depth, &refresh);
+		status = efi_early->call((unsigned long)uga->get_mode, uga,
+					 &w, &h, &depth, &refresh);
 		if (status == EFI_SUCCESS && (!first_uga || pciio)) {
-			width = w;
-			height = h;
+			*width = w;
+			*height = h;
 
 			/*
 			 * Once we've found a UGA supporting PCIIO,
@@ -365,7 +926,39 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 		}
 	}
 
-	if (!first_uga)
+	return status;
+}
+
+/*
+ * See if we have Universal Graphics Adapter (UGA) protocol
+ */
+static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
+			      unsigned long size)
+{
+	efi_status_t status;
+	u32 width, height;
+	void **uga_handle = NULL;
+
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)&uga_handle);
+	if (status != EFI_SUCCESS)
+		return status;
+
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				uga_proto, NULL, &size, uga_handle);
+	if (status != EFI_SUCCESS)
+		goto free_handle;
+
+	height = 0;
+	width = 0;
+
+	if (efi_early->is64)
+		status = setup_uga64(uga_handle, size, &width, &height);
+	else
+		status = setup_uga32(uga_handle, size, &width, &height);
+
+	if (!width && !height)
 		goto free_handle;
 
 	/* EFI framebuffer */
@@ -384,9 +977,8 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 	si->rsvd_size = 8;
 	si->rsvd_pos = 24;
 
-
 free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, uga_handle);
+	efi_call_early(free_pool, uga_handle);
 	return status;
 }
 
@@ -404,29 +996,28 @@ void setup_graphics(struct boot_params *boot_params)
 	memset(si, 0, sizeof(*si));
 
 	size = 0;
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, &graphics_proto,
-				NULL, &size, gop_handle);
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				&graphics_proto, NULL, &size, gop_handle);
 	if (status == EFI_BUFFER_TOO_SMALL)
 		status = setup_gop(si, &graphics_proto, size);
 
 	if (status != EFI_SUCCESS) {
 		size = 0;
-		status = efi_call_phys5(sys_table->boottime->locate_handle,
-					EFI_LOCATE_BY_PROTOCOL, &uga_proto,
-					NULL, &size, uga_handle);
+		status = efi_call_early(locate_handle,
+					EFI_LOCATE_BY_PROTOCOL,
+					&uga_proto, NULL, &size, uga_handle);
 		if (status == EFI_BUFFER_TOO_SMALL)
 			setup_uga(si, &uga_proto, size);
 	}
 }
 
-
 /*
  * Because the x86 boot code expects to be passed a boot_params we
  * need to create one ourselves (usually the bootloader would create
  * one for us).
  */
-struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
+struct boot_params *make_boot_params(struct efi_config *c)
 {
 	struct boot_params *boot_params;
 	struct sys_desc_table *sdt;
@@ -434,7 +1025,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	struct setup_header *hdr;
 	struct efi_info *efi;
 	efi_loaded_image_t *image;
-	void *options;
+	void *options, *handle;
 	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
 	int options_size = 0;
 	efi_status_t status;
@@ -445,14 +1036,21 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	unsigned long ramdisk_addr;
 	unsigned long ramdisk_size;
 
-	sys_table = _table;
+	efi_early = c;
+	sys_table = (efi_system_table_t *)(unsigned long)efi_early->table;
+	handle = (void *)(unsigned long)efi_early->image_handle;
 
 	/* Check if we were booted by the EFI firmware */
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		return NULL;
 
-	status = efi_call_phys3(sys_table->boottime->handle_protocol,
-				handle, &proto, (void *)&image);
+	if (efi_early->is64)
+		setup_boot_services64(efi_early);
+	else
+		setup_boot_services32(efi_early);
+
+	status = efi_call_early(handle_protocol, handle,
+				&proto, (void *)&image);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
@@ -641,14 +1239,13 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 		sizeof(struct e820entry) * nr_desc;
 
 	if (*e820ext) {
-		efi_call_phys1(sys_table->boottime->free_pool, *e820ext);
+		efi_call_early(free_pool, *e820ext);
 		*e820ext = NULL;
 		*e820ext_size = 0;
 	}
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, e820ext);
-
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)e820ext);
 	if (status == EFI_SUCCESS)
 		*e820ext_size = size;
 
@@ -656,12 +1253,13 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 }
 
 static efi_status_t exit_boot(struct boot_params *boot_params,
-			      void *handle)
+			      void *handle, bool is64)
 {
 	struct efi_info *efi = &boot_params->efi_info;
 	unsigned long map_sz, key, desc_size;
 	efi_memory_desc_t *mem_map;
 	struct setup_data *e820ext;
+	const char *signature;
 	__u32 e820ext_size;
 	__u32 nr_desc, prev_nr_desc;
 	efi_status_t status;
@@ -691,11 +1289,13 @@ get_map:
 		if (status != EFI_SUCCESS)
 			goto free_mem_map;
 
-		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		efi_call_early(free_pool, mem_map);
 		goto get_map; /* Allocated memory, get map again */
 	}
 
-	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
+	signature = is64 ? EFI64_LOADER_SIGNATURE : EFI32_LOADER_SIGNATURE;
+	memcpy(&efi->efi_loader_signature, signature, sizeof(__u32));
+
 	efi->efi_systab = (unsigned long)sys_table;
 	efi->efi_memdesc_size = desc_size;
 	efi->efi_memdesc_version = desc_version;
@@ -708,8 +1308,7 @@ get_map:
 #endif
 
 	/* Might as well exit boot services now */
-	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
-				handle, key);
+	status = efi_call_early(exit_boot_services, handle, key);
 	if (status != EFI_SUCCESS) {
 		/*
 		 * ExitBootServices() will fail if any of the event
@@ -722,7 +1321,7 @@ get_map:
 			goto free_mem_map;
 
 		called_exit = true;
-		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		efi_call_early(free_pool, mem_map);
 		goto get_map;
 	}
 
@@ -736,23 +1335,31 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+	efi_call_early(free_pool, mem_map);
 	return status;
 }
 
-
 /*
  * On success we return a pointer to a boot_params structure, and NULL
  * on failure.
  */
-struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
+struct boot_params *efi_main(struct efi_config *c,
 			     struct boot_params *boot_params)
 {
-	struct desc_ptr *gdt;
+	struct desc_ptr *gdt = NULL;
 	efi_loaded_image_t *image;
 	struct setup_header *hdr = &boot_params->hdr;
 	efi_status_t status;
 	struct desc_struct *desc;
+	void *handle;
+	efi_system_table_t *_table;
+	bool is64;
+
+	efi_early = c;
+
+	_table = (efi_system_table_t *)(unsigned long)efi_early->table;
+	handle = (void *)(unsigned long)efi_early->image_handle;
+	is64 = efi_early->is64;
 
 	sys_table = _table;
 
@@ -760,13 +1367,17 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 	if (sys_table->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE)
 		goto fail;
 
+	if (is64)
+		setup_boot_services64(efi_early);
+	else
+		setup_boot_services32(efi_early);
+
 	setup_graphics(boot_params);
 
 	setup_efi_pci(boot_params);
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, sizeof(*gdt),
-				(void **)&gdt);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				sizeof(*gdt), (void **)&gdt);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt structure\n");
 		goto fail;
@@ -797,7 +1408,7 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 		hdr->code32_start = bzimage_addr;
 	}
 
-	status = exit_boot(boot_params, handle);
+	status = exit_boot(boot_params, handle, is64);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
diff --git a/arch/x86/boot/compressed/eboot.h b/arch/x86/boot/compressed/eboot.h
index 81b6b65..c88c31e 100644
--- a/arch/x86/boot/compressed/eboot.h
+++ b/arch/x86/boot/compressed/eboot.h
@@ -37,6 +37,24 @@ struct efi_graphics_output_mode_info {
 	u32 pixels_per_scan_line;
 } __packed;
 
+struct efi_graphics_output_protocol_mode_32 {
+	u32 max_mode;
+	u32 mode;
+	u32 info;
+	u32 size_of_info;
+	u64 frame_buffer_base;
+	u32 frame_buffer_size;
+} __packed;
+
+struct efi_graphics_output_protocol_mode_64 {
+	u32 max_mode;
+	u32 mode;
+	u64 info;
+	u64 size_of_info;
+	u64 frame_buffer_base;
+	u64 frame_buffer_size;
+} __packed;
+
 struct efi_graphics_output_protocol_mode {
 	u32 max_mode;
 	u32 mode;
@@ -46,6 +64,20 @@ struct efi_graphics_output_protocol_mode {
 	unsigned long frame_buffer_size;
 } __packed;
 
+struct efi_graphics_output_protocol_32 {
+	u32 query_mode;
+	u32 set_mode;
+	u32 blt;
+	u32 mode;
+};
+
+struct efi_graphics_output_protocol_64 {
+	u64 query_mode;
+	u64 set_mode;
+	u64 blt;
+	u64 mode;
+};
+
 struct efi_graphics_output_protocol {
 	void *query_mode;
 	unsigned long set_mode;
@@ -53,10 +85,38 @@ struct efi_graphics_output_protocol {
 	struct efi_graphics_output_protocol_mode *mode;
 };
 
+struct efi_uga_draw_protocol_32 {
+	u32 get_mode;
+	u32 set_mode;
+	u32 blt;
+};
+
+struct efi_uga_draw_protocol_64 {
+	u64 get_mode;
+	u64 set_mode;
+	u64 blt;
+};
+
 struct efi_uga_draw_protocol {
 	void *get_mode;
 	void *set_mode;
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
diff --git a/arch/x86/boot/compressed/efi_stub_64.S b/arch/x86/boot/compressed/efi_stub_64.S
index cedc60d..7ff3632 100644
--- a/arch/x86/boot/compressed/efi_stub_64.S
+++ b/arch/x86/boot/compressed/efi_stub_64.S
@@ -1 +1,30 @@
+#include <asm/segment.h>
+#include <asm/msr.h>
+#include <asm/processor-flags.h>
+
 #include "../../platform/efi/efi_stub_64.S"
+
+#ifdef CONFIG_EFI_MIXED
+	.code64
+	.text
+ENTRY(efi64_thunk)
+	push	%rbp
+	push	%rbx
+
+	subq	$16, %rsp
+	leaq	efi_exit32(%rip), %rax
+	movl	%eax, 8(%rsp)
+	leaq	efi_gdt64(%rip), %rax
+	movl	%eax, 4(%rsp)
+	movl	%eax, 2(%rax)		/* Fixup the gdt base address */
+	leaq	efi32_boot_gdt(%rip), %rax
+	movl	%eax, (%rsp)
+
+	call	__efi64_thunk
+
+	addq	$16, %rsp
+	pop	%rbx
+	pop	%rbp
+	ret
+ENDPROC(efi64_thunk)
+#endif /* CONFIG_EFI_MIXED */
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 9116aac..de9d420 100644
--- a/arch/x86/boot/compressed/head_32.S
+++ b/arch/x86/boot/compressed/head_32.S
@@ -42,26 +42,53 @@ ENTRY(startup_32)
 ENTRY(efi_pe_entry)
 	add	$0x4, %esp
 
+	call	1f
+1:	popl	%esi
+	subl	$1b, %esi
+
+	popl	%ecx
+	movl	%ecx, efi32_config(%esi)	/* Handle */
+	popl	%ecx
+	movl	%ecx, efi32_config+8(%esi)	/* EFI System table pointer */
+
+	/* Relocate efi_config->call() */
+	leal	efi32_config(%esi), %eax
+	add	%esi, 88(%eax)
+	pushl	%eax
+
 	call	make_boot_params
 	cmpl	$0, %eax
-	je	1f
-	movl	0x4(%esp), %esi
-	movl	(%esp), %ecx
+	je	fail
+	popl	%ecx
 	pushl	%eax
-	pushl	%esi
 	pushl	%ecx
-	sub	$0x4, %esp
+	jmp	2f		/* Skip efi_config initialization */
 
-ENTRY(efi_stub_entry)
+ENTRY(efi32_stub_entry)
 	add	$0x4, %esp
+	popl	%ecx
+	popl	%edx
+
+	call	1f
+1:	popl	%esi
+	subl	$1b, %esi
+
+	movl	%ecx, efi32_config(%esi)	/* Handle */
+	movl	%edx, efi32_config+8(%esi)	/* EFI System table pointer */
+
+	/* Relocate efi_config->call() */
+	leal	efi32_config(%esi), %eax
+	add	%esi, 88(%eax)
+	pushl	%eax
+2:
 	call	efi_main
 	cmpl	$0, %eax
 	movl	%eax, %esi
 	jne	2f
-1:
+fail:
 	/* EFI init failed, so hang. */
 	hlt
-	jmp	1b
+	jmp	fail
 2:
 	call	3f
 3:
@@ -202,6 +229,15 @@ relocated:
 	xorl	%ebx, %ebx
 	jmp	*%eax
 
+#ifdef CONFIG_EFI_STUB
+	.data
+efi32_config:
+	.fill 11,8,0
+	.long efi_call_phys
+	.long 0
+	.byte 0
+#endif
+
 /*
  * Stack and heap for uncompression
  */
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c5c1ae0..57e58a5 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -113,7 +113,8 @@ ENTRY(startup_32)
 	lgdt	gdt(%ebp)
 
 	/* Enable PAE mode */
-	movl	$(X86_CR4_PAE), %eax
+	movl	%cr4, %eax
+	orl	$X86_CR4_PAE, %eax
 	movl	%eax, %cr4
 
  /*
@@ -178,6 +179,13 @@ ENTRY(startup_32)
 	 */
 	pushl	$__KERNEL_CS
 	leal	startup_64(%ebp), %eax
+#ifdef CONFIG_EFI_MIXED
+	movl	efi32_config(%ebp), %ebx
+	cmp	$0, %ebx
+	jz	1f
+	leal	handover_entry(%ebp), %eax
+1:
+#endif
 	pushl	%eax
 
 	/* Enter paged protected Mode, activating Long Mode */
@@ -188,6 +196,30 @@ ENTRY(startup_32)
 	lret
 ENDPROC(startup_32)
 
+#ifdef CONFIG_EFI_MIXED
+	.org 0x190
+ENTRY(efi32_stub_entry)
+	add	$0x4, %esp		/* Discard return address */
+	popl	%ecx
+	popl	%edx
+	popl	%esi
+
+	leal	(BP_scratch+4)(%esi), %esp
+	call	1f
+1:	pop	%ebp
+	subl	$1b, %ebp
+
+	movl	%ecx, efi32_config(%ebp)
+	movl	%edx, efi32_config+8(%ebp)
+	sgdtl	efi32_boot_gdt(%ebp)
+
+	leal	efi32_config(%ebp), %eax
+	movl	%eax, efi_config(%ebp)
+
+	jmp	startup_32
+ENDPROC(efi32_stub_entry)
+#endif
+
 	.code64
 	.org 0x200
 ENTRY(startup_64)
@@ -209,26 +241,48 @@ ENTRY(startup_64)
 	jmp	preferred_addr
 
 ENTRY(efi_pe_entry)
-	mov	%rcx, %rdi
-	mov	%rdx, %rsi
-	pushq	%rdi
-	pushq	%rsi
+	movq	%rcx, efi64_config(%rip)	/* Handle */
+	movq	%rdx, efi64_config+8(%rip) /* EFI System table pointer */
+
+	leaq	efi64_config(%rip), %rax
+	movq	%rax, efi_config(%rip)
+
+	call	1f
+1:	popq	%rbp
+	subq	$1b, %rbp
+
+	/*
+	 * Relocate efi_config->call().
+	 */
+	addq	%rbp, efi64_config+88(%rip)
+
+	movq	%rax, %rdi
 	call	make_boot_params
 	cmpq	$0,%rax
-	je	1f
-	mov	%rax, %rdx
-	popq	%rsi
-	popq	%rdi
+	je	fail
+	mov	%rax, %rsi
+	jmp	2f		/* Skip the relocation */
 
-ENTRY(efi_stub_entry)
+handover_entry:
+	call	1f
+1:	popq	%rbp
+	subq	$1b, %rbp
+
+	/*
+	 * Relocate efi_config->call().
+	 */
+	movq	efi_config(%rip), %rax
+	addq	%rbp, 88(%rax)
+2:
+	movq	efi_config(%rip), %rdi
 	call	efi_main
 	movq	%rax,%rsi
 	cmpq	$0,%rax
 	jne	2f
-1:
+fail:
 	/* EFI init failed, so hang. */
 	hlt
-	jmp	1b
+	jmp	fail
 2:
 	call	3f
 3:
@@ -307,6 +361,20 @@ preferred_addr:
 	leaq	relocated(%rbx), %rax
 	jmp	*%rax
 
+#ifdef CONFIG_EFI_STUB
+	.org 0x390
+ENTRY(efi64_stub_entry)
+	movq	%rdi, efi64_config(%rip)	/* Handle */
+	movq	%rsi, efi64_config+8(%rip) /* EFI System table pointer */
+
+	leaq	efi64_config(%rip), %rax
+	movq	%rax, efi_config(%rip)
+
+	movq	%rdx, %rsi
+	jmp	handover_entry
+ENDPROC(efi64_stub_entry)
+#endif
+
 	.text
 relocated:
 
@@ -372,6 +440,25 @@ gdt:
 	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 
+#ifdef CONFIG_EFI_STUB
+efi_config:
+	.quad	0
+
+#ifdef CONFIG_EFI_MIXED
+	.global efi32_config
+efi32_config:
+	.fill	11,8,0
+	.quad	efi64_thunk
+	.byte	0
+#endif
+
+	.global efi64_config
+efi64_config:
+	.fill	11,8,0
+	.quad	efi_call6
+	.byte	1
+#endif /* CONFIG_EFI_STUB */
+
 /*
  * Stack and heap for uncompression
  */
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index ec3b8ba..2563882 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -283,7 +283,7 @@ _start:
 	# Part 2 of the header, from the old setup.S
 
 		.ascii	"HdrS"		# header signature
-		.word	0x020c		# header version number (>= 0x0105)
+		.word	0x020d		# header version number (>= 0x0105)
 					# or else old loadlin-1.5 will fail)
 		.globl realmode_swtch
 realmode_swtch:	.word	0, 0		# default_switch, SETUPSEG
@@ -375,7 +375,8 @@ xloadflags:
 # define XLF0 0
 #endif
 
-#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64)
+#if defined(CONFIG_RELOCATABLE) && defined(CONFIG_X86_64) && \
+	!defined(CONFIG_EFI_MIXED)
    /* kernel/boot_param/ramdisk could be loaded above 4g */
 # define XLF1 XLF_CAN_BE_LOADED_ABOVE_4G
 #else
@@ -383,10 +384,14 @@ xloadflags:
 #endif
 
 #ifdef CONFIG_EFI_STUB
-# ifdef CONFIG_X86_64
-#  define XLF23 XLF_EFI_HANDOVER_64		/* 64-bit EFI handover ok */
+# ifdef CONFIG_EFI_MIXED
+#  define XLF23 (XLF_EFI_HANDOVER_32|XLF_EFI_HANDOVER_64)
 # else
-#  define XLF23 XLF_EFI_HANDOVER_32		/* 32-bit EFI handover ok */
+#  ifdef CONFIG_X86_64
+#   define XLF23 XLF_EFI_HANDOVER_64		/* 64-bit EFI handover ok */
+#  else
+#   define XLF23 XLF_EFI_HANDOVER_32		/* 32-bit EFI handover ok */
+#  endif
 # endif
 #else
 # define XLF23 0
@@ -426,13 +431,7 @@ pref_address:		.quad LOAD_PHYSICAL_ADDR	# preferred load addr
 #define INIT_SIZE VO_INIT_SIZE
 #endif
 init_size:		.long INIT_SIZE		# kernel initialization size
-handover_offset:
-#ifdef CONFIG_EFI_STUB
-  			.long 0x30		# offset to the handover
-						# protocol entry point
-#else
-			.long 0
-#endif
+handover_offset:	.long 0			# Filled in by build.c
 
 # End of setup header #####################################################
 
diff --git a/arch/x86/boot/tools/build.c b/arch/x86/boot/tools/build.c
index 8e15b22..1a2f212 100644
--- a/arch/x86/boot/tools/build.c
+++ b/arch/x86/boot/tools/build.c
@@ -53,7 +53,8 @@ int is_big_kernel;
 
 #define PECOFF_RELOC_RESERVE 0x20
 
-unsigned long efi_stub_entry;
+unsigned long efi32_stub_entry;
+unsigned long efi64_stub_entry;
 unsigned long efi_pe_entry;
 unsigned long startup_64;
 
@@ -219,6 +220,52 @@ static void update_pecoff_text(unsigned int text_start, unsigned int file_sz)
 	update_pecoff_section_header(".text", text_start, text_sz);
 }
 
+static int reserve_pecoff_reloc_section(int c)
+{
+	/* Reserve 0x20 bytes for .reloc section */
+	memset(buf+c, 0, PECOFF_RELOC_RESERVE);
+	return PECOFF_RELOC_RESERVE;
+}
+
+static void efi_stub_defaults(void)
+{
+	/* Defaults for old kernel */
+#ifdef CONFIG_X86_32
+	efi_pe_entry = 0x10;
+#else
+	efi_pe_entry = 0x210;
+	startup_64 = 0x200;
+#endif
+}
+
+static void efi_stub_entry_update(void)
+{
+	unsigned long addr = efi32_stub_entry;
+
+#ifdef CONFIG_X86_64
+	/* Yes, this is really how we defined it :( */
+	addr = efi64_stub_entry - 0x200;
+#endif
+
+#ifdef CONFIG_EFI_MIXED
+	if (efi32_stub_entry != addr)
+		die("32-bit and 64-bit EFI entry points do not match\n");
+#endif
+	put_unaligned_le32(addr, &buf[0x264]);
+}
+
+#else
+
+static inline void update_pecoff_setup_and_reloc(unsigned int size) {}
+static inline void update_pecoff_text(unsigned int text_start,
+				      unsigned int file_sz) {}
+static inline void efi_stub_defaults(void) {}
+static inline void efi_stub_entry_update(void) {}
+
+static inline int reserve_pecoff_reloc_section(int c)
+{
+	return 0;
+}
 #endif /* CONFIG_EFI_STUB */
 
 
@@ -250,7 +297,8 @@ static void parse_zoffset(char *fname)
 	p = (char *)buf;
 
 	while (p && *p) {
-		PARSE_ZOFS(p, efi_stub_entry);
+		PARSE_ZOFS(p, efi32_stub_entry);
+		PARSE_ZOFS(p, efi64_stub_entry);
 		PARSE_ZOFS(p, efi_pe_entry);
 		PARSE_ZOFS(p, startup_64);
 
@@ -271,15 +319,7 @@ int main(int argc, char ** argv)
 	void *kernel;
 	u32 crc = 0xffffffffUL;
 
-	/* Defaults for old kernel */
-#ifdef CONFIG_X86_32
-	efi_pe_entry = 0x10;
-	efi_stub_entry = 0x30;
-#else
-	efi_pe_entry = 0x210;
-	efi_stub_entry = 0x230;
-	startup_64 = 0x200;
-#endif
+	efi_stub_defaults();
 
 	if (argc != 5)
 		usage();
@@ -302,11 +342,7 @@ int main(int argc, char ** argv)
 		die("Boot block hasn't got boot flag (0xAA55)");
 	fclose(file);
 
-#ifdef CONFIG_EFI_STUB
-	/* Reserve 0x20 bytes for .reloc section */
-	memset(buf+c, 0, PECOFF_RELOC_RESERVE);
-	c += PECOFF_RELOC_RESERVE;
-#endif
+	c += reserve_pecoff_reloc_section(c);
 
 	/* Pad unused space with zeros */
 	setup_sectors = (c + 511) / 512;
@@ -315,9 +351,7 @@ int main(int argc, char ** argv)
 	i = setup_sectors*512;
 	memset(buf+c, 0, i-c);
 
-#ifdef CONFIG_EFI_STUB
 	update_pecoff_setup_and_reloc(i);
-#endif
 
 	/* Set the default root device */
 	put_unaligned_le16(DEFAULT_ROOT_DEV, &buf[508]);
@@ -342,14 +376,9 @@ int main(int argc, char ** argv)
 	buf[0x1f1] = setup_sectors-1;
 	put_unaligned_le32(sys_size, &buf[0x1f4]);
 
-#ifdef CONFIG_EFI_STUB
 	update_pecoff_text(setup_sectors * 512, sz + i + ((sys_size * 16) - sz));
 
-#ifdef CONFIG_X86_64 /* Yes, this is really how we defined it :( */
-	efi_stub_entry -= 0x200;
-#endif
-	put_unaligned_le32(efi_stub_entry, &buf[0x264]);
-#endif
+	efi_stub_entry_update();
 
 	crc = partial_crc32(buf, i, crc);
 	if (fwrite(buf, 1, i, dest) != i)
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index acd86c8..0869434 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -19,9 +19,11 @@
  */
 #define EFI_OLD_MEMMAP		EFI_ARCH_1
 
+#define EFI32_LOADER_SIGNATURE	"EL32"
+#define EFI64_LOADER_SIGNATURE	"EL64"
+
 #ifdef CONFIG_X86_32
 
-#define EFI_LOADER_SIGNATURE	"EL32"
 
 extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
@@ -57,8 +59,6 @@ extern unsigned long asmlinkage efi_call_phys(void *, ...);
 
 #else /* !CONFIG_X86_32 */
 
-#define EFI_LOADER_SIGNATURE	"EL64"
-
 extern u64 efi_call0(void *fp);
 extern u64 efi_call1(void *fp, u64 arg1);
 extern u64 efi_call2(void *fp, u64 arg1, u64 arg2);
@@ -119,7 +119,6 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 #endif /* CONFIG_X86_32 */
 
 extern int add_efi_memmap;
-extern unsigned long x86_efi_facility;
 extern struct efi_scratch efi_scratch;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
@@ -130,10 +129,12 @@ extern void efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
-extern void efi_setup_page_tables(void);
+extern int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
+extern void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
+extern void __init efi_dump_pagetable(void);
 extern void __init efi_apply_memmap_quirks(void);
 
 struct efi_setup_data {
@@ -153,8 +154,40 @@ static inline bool efi_is_native(void)
 	return IS_ENABLED(CONFIG_X86_64) == efi_enabled(EFI_64BIT);
 }
 
+static inline bool efi_runtime_supported(void)
+{
+	if (efi_is_native())
+		return true;
+
+	if (IS_ENABLED(CONFIG_EFI_MIXED) && !efi_enabled(EFI_OLD_MEMMAP))
+		return true;
+
+	return false;
+}
+
 extern struct console early_efi_console;
 extern void parse_efi_setup(u64 phys_addr, u32 data_len);
+
+#ifdef CONFIG_EFI_MIXED
+extern void efi_thunk_runtime_setup(void);
+extern efi_status_t efi_thunk_set_virtual_address_map(
+	void *phys_set_virtual_address_map,
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map);
+#else
+static inline void efi_thunk_runtime_setup(void) {}
+static inline efi_status_t efi_thunk_set_virtual_address_map(
+	void *phys_set_virtual_address_map,
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map)
+{
+	return EFI_SUCCESS;
+}
+#endif /* CONFIG_EFI_MIXED */
 #else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
diff --git a/arch/x86/include/asm/pgtable.h b/arch/x86/include/asm/pgtable.h
index 5ad38ad..938ef1d 100644
--- a/arch/x86/include/asm/pgtable.h
+++ b/arch/x86/include/asm/pgtable.h
@@ -15,9 +15,10 @@
 	 : (prot))
 
 #ifndef __ASSEMBLY__
-
 #include <asm/x86_init.h>
 
+void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd);
+
 /*
  * ZERO_PAGE is a global shared page that is always zero: used
  * for zero-mapped memory areas etc..
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 1aa9ccd..708f19f 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -382,9 +382,13 @@ static inline void update_page_count(int level, unsigned long pages) { }
  * as a pte too.
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
+extern pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+				    unsigned int *level);
 extern phys_addr_t slow_virt_to_phys(void *__address);
 extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
 				   unsigned numpages, unsigned long page_flags);
+void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
+			       unsigned numpages);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index ce72964..fa511ac 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -926,11 +926,11 @@ void __init setup_arch(char **cmdline_p)
 #ifdef CONFIG_EFI
 	if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL32", 4)) {
-		set_bit(EFI_BOOT, &x86_efi_facility);
+		set_bit(EFI_BOOT, &efi.flags);
 	} else if (!strncmp((char *)&boot_params.efi_info.efi_loader_signature,
 		     "EL64", 4)) {
-		set_bit(EFI_BOOT, &x86_efi_facility);
-		set_bit(EFI_64BIT, &x86_efi_facility);
+		set_bit(EFI_BOOT, &efi.flags);
+		set_bit(EFI_64BIT, &efi.flags);
 	}
 
 	if (efi_enabled(EFI_BOOT))
diff --git a/arch/x86/mm/dump_pagetables.c b/arch/x86/mm/dump_pagetables.c
index 0002a3a..20621d7 100644
--- a/arch/x86/mm/dump_pagetables.c
+++ b/arch/x86/mm/dump_pagetables.c
@@ -30,6 +30,7 @@ struct pg_state {
 	unsigned long start_address;
 	unsigned long current_address;
 	const struct addr_marker *marker;
+	bool to_dmesg;
 };
 
 struct addr_marker {
@@ -88,10 +89,28 @@ static struct addr_marker address_markers[] = {
 #define PUD_LEVEL_MULT (PTRS_PER_PMD * PMD_LEVEL_MULT)
 #define PGD_LEVEL_MULT (PTRS_PER_PUD * PUD_LEVEL_MULT)
 
+#define pt_dump_seq_printf(m, to_dmesg, fmt, args...)		\
+({								\
+	if (to_dmesg)					\
+		printk(KERN_INFO fmt, ##args);			\
+	else							\
+		if (m)						\
+			seq_printf(m, fmt, ##args);		\
+})
+
+#define pt_dump_cont_printf(m, to_dmesg, fmt, args...)		\
+({								\
+	if (to_dmesg)					\
+		printk(KERN_CONT fmt, ##args);			\
+	else							\
+		if (m)						\
+			seq_printf(m, fmt, ##args);		\
+})
+
 /*
  * Print a readable form of a pgprot_t to the seq_file
  */
-static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
+static void printk_prot(struct seq_file *m, pgprot_t prot, int level, bool dmsg)
 {
 	pgprotval_t pr = pgprot_val(prot);
 	static const char * const level_name[] =
@@ -99,47 +118,47 @@ static void printk_prot(struct seq_file *m, pgprot_t prot, int level)
 
 	if (!pgprot_val(prot)) {
 		/* Not present */
-		seq_printf(m, "                          ");
+		pt_dump_cont_printf(m, dmsg, "                          ");
 	} else {
 		if (pr & _PAGE_USER)
-			seq_printf(m, "USR ");
+			pt_dump_cont_printf(m, dmsg, "USR ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 		if (pr & _PAGE_RW)
-			seq_printf(m, "RW ");
+			pt_dump_cont_printf(m, dmsg, "RW ");
 		else
-			seq_printf(m, "ro ");
+			pt_dump_cont_printf(m, dmsg, "ro ");
 		if (pr & _PAGE_PWT)
-			seq_printf(m, "PWT ");
+			pt_dump_cont_printf(m, dmsg, "PWT ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 		if (pr & _PAGE_PCD)
-			seq_printf(m, "PCD ");
+			pt_dump_cont_printf(m, dmsg, "PCD ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 
 		/* Bit 9 has a different meaning on level 3 vs 4 */
 		if (level <= 3) {
 			if (pr & _PAGE_PSE)
-				seq_printf(m, "PSE ");
+				pt_dump_cont_printf(m, dmsg, "PSE ");
 			else
-				seq_printf(m, "    ");
+				pt_dump_cont_printf(m, dmsg, "    ");
 		} else {
 			if (pr & _PAGE_PAT)
-				seq_printf(m, "pat ");
+				pt_dump_cont_printf(m, dmsg, "pat ");
 			else
-				seq_printf(m, "    ");
+				pt_dump_cont_printf(m, dmsg, "    ");
 		}
 		if (pr & _PAGE_GLOBAL)
-			seq_printf(m, "GLB ");
+			pt_dump_cont_printf(m, dmsg, "GLB ");
 		else
-			seq_printf(m, "    ");
+			pt_dump_cont_printf(m, dmsg, "    ");
 		if (pr & _PAGE_NX)
-			seq_printf(m, "NX ");
+			pt_dump_cont_printf(m, dmsg, "NX ");
 		else
-			seq_printf(m, "x  ");
+			pt_dump_cont_printf(m, dmsg, "x  ");
 	}
-	seq_printf(m, "%s\n", level_name[level]);
+	pt_dump_cont_printf(m, dmsg, "%s\n", level_name[level]);
 }
 
 /*
@@ -178,7 +197,8 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		st->current_prot = new_prot;
 		st->level = level;
 		st->marker = address_markers;
-		seq_printf(m, "---[ %s ]---\n", st->marker->name);
+		pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
+				   st->marker->name);
 	} else if (prot != cur || level != st->level ||
 		   st->current_address >= st->marker[1].start_address) {
 		const char *unit = units;
@@ -188,17 +208,17 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		/*
 		 * Now print the actual finished series
 		 */
-		seq_printf(m, "0x%0*lx-0x%0*lx   ",
-			   width, st->start_address,
-			   width, st->current_address);
+		pt_dump_seq_printf(m, st->to_dmesg,  "0x%0*lx-0x%0*lx   ",
+				   width, st->start_address,
+				   width, st->current_address);
 
 		delta = (st->current_address - st->start_address) >> 10;
 		while (!(delta & 1023) && unit[1]) {
 			delta >>= 10;
 			unit++;
 		}
-		seq_printf(m, "%9lu%c ", delta, *unit);
-		printk_prot(m, st->current_prot, st->level);
+		pt_dump_cont_printf(m, st->to_dmesg, "%9lu%c ", delta, *unit);
+		printk_prot(m, st->current_prot, st->level, st->to_dmesg);
 
 		/*
 		 * We print markers for special areas of address space,
@@ -207,7 +227,8 @@ static void note_page(struct seq_file *m, struct pg_state *st,
 		 */
 		if (st->current_address >= st->marker[1].start_address) {
 			st->marker++;
-			seq_printf(m, "---[ %s ]---\n", st->marker->name);
+			pt_dump_seq_printf(m, st->to_dmesg, "---[ %s ]---\n",
+					   st->marker->name);
 		}
 
 		st->start_address = st->current_address;
@@ -296,7 +317,7 @@ static void walk_pud_level(struct seq_file *m, struct pg_state *st, pgd_t addr,
 #define pgd_none(a)  pud_none(__pud(pgd_val(a)))
 #endif
 
-static void walk_pgd_level(struct seq_file *m)
+void ptdump_walk_pgd_level(struct seq_file *m, pgd_t *pgd)
 {
 #ifdef CONFIG_X86_64
 	pgd_t *start = (pgd_t *) &init_level4_pgt;
@@ -304,9 +325,12 @@ static void walk_pgd_level(struct seq_file *m)
 	pgd_t *start = swapper_pg_dir;
 #endif
 	int i;
-	struct pg_state st;
+	struct pg_state st = {};
 
-	memset(&st, 0, sizeof(st));
+	if (pgd) {
+		start = pgd;
+		st.to_dmesg = true;
+	}
 
 	for (i = 0; i < PTRS_PER_PGD; i++) {
 		st.current_address = normalize_addr(i * PGD_LEVEL_MULT);
@@ -331,7 +355,7 @@ static void walk_pgd_level(struct seq_file *m)
 
 static int ptdump_show(struct seq_file *m, void *v)
 {
-	walk_pgd_level(m);
+	ptdump_walk_pgd_level(m, NULL);
 	return 0;
 }
 
diff --git a/arch/x86/mm/fault.c b/arch/x86/mm/fault.c
index e7fa28b..a92c4c9 100644
--- a/arch/x86/mm/fault.c
+++ b/arch/x86/mm/fault.c
@@ -584,8 +584,13 @@ show_fault_oops(struct pt_regs *regs, unsigned long error_code,
 
 	if (error_code & PF_INSTR) {
 		unsigned int level;
+		pgd_t *pgd;
+		pte_t *pte;
 
-		pte_t *pte = lookup_address(address, &level);
+		pgd = __va(read_cr3() & PHYSICAL_PAGE_MASK);
+		pgd += pgd_index(address);
+
+		pte = lookup_address_in_pgd(pgd, address, &level);
 
 		if (pte && pte_present(*pte) && !pte_exec(*pte))
 			printk(nx_warning, from_kuid(&init_user_ns, current_uid()));
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index b3b19f4..1585da3 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -323,8 +323,12 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	return prot;
 }
 
-static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
-				      unsigned int *level)
+/*
+ * Lookup the page table entry for a virtual address in a specific pgd.
+ * Return a pointer to the entry and the level of the mapping.
+ */
+pte_t *lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+			     unsigned int *level)
 {
 	pud_t *pud;
 	pmd_t *pmd;
@@ -365,7 +369,7 @@ static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
  */
 pte_t *lookup_address(unsigned long address, unsigned int *level)
 {
-        return __lookup_address_in_pgd(pgd_offset_k(address), address, level);
+        return lookup_address_in_pgd(pgd_offset_k(address), address, level);
 }
 EXPORT_SYMBOL_GPL(lookup_address);
 
@@ -373,7 +377,7 @@ static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
 				  unsigned int *level)
 {
         if (cpa->pgd)
-		return __lookup_address_in_pgd(cpa->pgd + pgd_index(address),
+		return lookup_address_in_pgd(cpa->pgd + pgd_index(address),
 					       address, level);
 
         return lookup_address(address, level);
@@ -692,6 +696,18 @@ static bool try_to_free_pmd_page(pmd_t *pmd)
 	return true;
 }
 
+static bool try_to_free_pud_page(pud_t *pud)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PUD; i++)
+		if (!pud_none(pud[i]))
+			return false;
+
+	free_page((unsigned long)pud);
+	return true;
+}
+
 static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
 {
 	pte_t *pte = pte_offset_kernel(pmd, start);
@@ -805,6 +821,16 @@ static void unmap_pud_range(pgd_t *pgd, unsigned long start, unsigned long end)
 	 */
 }
 
+static void unmap_pgd_range(pgd_t *root, unsigned long addr, unsigned long end)
+{
+	pgd_t *pgd_entry = root + pgd_index(addr);
+
+	unmap_pud_range(pgd_entry, addr, end);
+
+	if (try_to_free_pud_page((pud_t *)pgd_page_vaddr(*pgd_entry)))
+		pgd_clear(pgd_entry);
+}
+
 static int alloc_pte_page(pmd_t *pmd)
 {
 	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
@@ -999,9 +1025,8 @@ static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
 static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 {
 	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
-	bool allocd_pgd = false;
-	pgd_t *pgd_entry;
 	pud_t *pud = NULL;	/* shut up gcc */
+	pgd_t *pgd_entry;
 	int ret;
 
 	pgd_entry = cpa->pgd + pgd_index(addr);
@@ -1015,7 +1040,6 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 			return -1;
 
 		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
-		allocd_pgd = true;
 	}
 
 	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
@@ -1023,19 +1047,11 @@ static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
 
 	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
 	if (ret < 0) {
-		unmap_pud_range(pgd_entry, addr,
+		unmap_pgd_range(cpa->pgd, addr,
 				addr + (cpa->numpages << PAGE_SHIFT));
-
-		if (allocd_pgd) {
-			/*
-			 * If I allocated this PUD page, I can just as well
-			 * free it in this error path.
-			 */
-			pgd_clear(pgd_entry);
-			free_page((unsigned long)pud);
-		}
 		return ret;
 	}
+
 	cpa->numpages = ret;
 	return 0;
 }
@@ -1861,6 +1877,12 @@ out:
 	return retval;
 }
 
+void kernel_unmap_pages_in_pgd(pgd_t *root, unsigned long address,
+			       unsigned numpages)
+{
+	unmap_pgd_range(root, address, address + (numpages << PAGE_SHIFT));
+}
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
diff --git a/arch/x86/platform/efi/Makefile b/arch/x86/platform/efi/Makefile
index b7b0b35..d51045a 100644
--- a/arch/x86/platform/efi/Makefile
+++ b/arch/x86/platform/efi/Makefile
@@ -1,3 +1,4 @@
 obj-$(CONFIG_EFI) 		+= efi.o efi_$(BITS).o efi_stub_$(BITS).o
 obj-$(CONFIG_ACPI_BGRT) += efi-bgrt.o
 obj-$(CONFIG_EARLY_PRINTK_EFI)	+= early_printk.o
+obj-$(CONFIG_EFI_MIXED)		+= efi_thunk_$(BITS).o
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index b97acec..3781dd3 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -68,9 +68,7 @@ struct efi_memory_map memmap;
 static struct efi efi_phys __initdata;
 static efi_system_table_t efi_systab __initdata;
 
-unsigned long x86_efi_facility;
-
-static __initdata efi_config_table_type_t arch_tables[] = {
+static efi_config_table_type_t arch_tables[] __initdata = {
 #ifdef CONFIG_X86_UV
 	{UV_SYSTEM_TABLE_GUID, "UVsystab", &efi.uv_systab},
 #endif
@@ -79,16 +77,7 @@ static __initdata efi_config_table_type_t arch_tables[] = {
 
 u64 efi_setup;		/* efi setup_data physical address */
 
-/*
- * Returns 1 if 'facility' is enabled, 0 otherwise.
- */
-int efi_enabled(int facility)
-{
-	return test_bit(facility, &x86_efi_facility) != 0;
-}
-EXPORT_SYMBOL(efi_enabled);
-
-static bool __initdata disable_runtime = false;
+static bool disable_runtime __initdata = false;
 static int __init setup_noefi(char *arg)
 {
 	disable_runtime = true;
@@ -257,27 +246,12 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 	return status;
 }
 
-static efi_status_t __init phys_efi_get_time(efi_time_t *tm,
-					     efi_time_cap_t *tc)
-{
-	unsigned long flags;
-	efi_status_t status;
-
-	spin_lock_irqsave(&rtc_lock, flags);
-	efi_call_phys_prelog();
-	status = efi_call_phys2(efi_phys.get_time, virt_to_phys(tm),
-				virt_to_phys(tc));
-	efi_call_phys_epilog();
-	spin_unlock_irqrestore(&rtc_lock, flags);
-	return status;
-}
-
 int efi_set_rtc_mmss(const struct timespec *now)
 {
 	unsigned long nowtime = now->tv_sec;
-	efi_status_t 	status;
-	efi_time_t 	eft;
-	efi_time_cap_t 	cap;
+	efi_status_t	status;
+	efi_time_t	eft;
+	efi_time_cap_t	cap;
 	struct rtc_time	tm;
 
 	status = efi.get_time(&eft, &cap);
@@ -295,9 +269,8 @@ int efi_set_rtc_mmss(const struct timespec *now)
 		eft.second = tm.tm_sec;
 		eft.nanosecond = 0;
 	} else {
-		printk(KERN_ERR
-		       "%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
-		       __FUNCTION__, nowtime);
+		pr_err("%s: Invalid EFI RTC value: write of %lx to EFI RTC failed\n",
+		       __func__, nowtime);
 		return -1;
 	}
 
@@ -413,8 +386,7 @@ static void __init print_efi_memmap(void)
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, "
-			"range=[0x%016llx-0x%016llx) (%lluMB)\n",
+		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
 			i, md->type, md->attribute, md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
@@ -446,9 +418,8 @@ void __init efi_reserve_boot_services(void)
 			memblock_is_region_reserved(start, size)) {
 			/* Could not reserve, skip it */
 			md->num_pages = 0;
-			memblock_dbg("Could not reserve boot range "
-					"[0x%010llx-0x%010llx]\n",
-						start, start+size-1);
+			memblock_dbg("Could not reserve boot range [0x%010llx-0x%010llx]\n",
+				     start, start+size-1);
 		} else
 			memblock_reserve(start, size);
 	}
@@ -456,7 +427,7 @@ void __init efi_reserve_boot_services(void)
 
 void __init efi_unmap_memmap(void)
 {
-	clear_bit(EFI_MEMMAP, &x86_efi_facility);
+	clear_bit(EFI_MEMMAP, &efi.flags);
 	if (memmap.map) {
 		early_iounmap(memmap.map, memmap.nr_map * memmap.desc_size);
 		memmap.map = NULL;
@@ -467,9 +438,6 @@ void __init efi_free_boot_services(void)
 {
 	void *p;
 
-	if (!efi_is_native())
-		return;
-
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		efi_memory_desc_t *md = p;
 		unsigned long long start = md->phys_addr;
@@ -584,45 +552,82 @@ static int __init efi_systab_init(void *phys)
 		return -EINVAL;
 	}
 	if ((efi.systab->hdr.revision >> 16) == 0)
-		pr_err("Warning: System table version "
-		       "%d.%02d, expected 1.00 or greater!\n",
+		pr_err("Warning: System table version %d.%02d, expected 1.00 or greater!\n",
 		       efi.systab->hdr.revision >> 16,
 		       efi.systab->hdr.revision & 0xffff);
 
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
+
 	return 0;
 }
 
-static int __init efi_runtime_init(void)
+static int __init efi_runtime_init32(void)
 {
-	efi_runtime_services_t *runtime;
+	efi_runtime_services_32_t *runtime;
+
+	runtime = early_ioremap((unsigned long)efi.systab->runtime,
+			sizeof(efi_runtime_services_32_t));
+	if (!runtime) {
+		pr_err("Could not map the runtime service table!\n");
+		return -ENOMEM;
+	}
 
 	/*
-	 * Check out the runtime services table. We need to map
-	 * the runtime services table so that we can grab the physical
-	 * address of several of the EFI runtime functions, needed to
-	 * set the firmware into virtual mode.
+	 * We will only need *early* access to the following two
+	 * EFI runtime services before set_virtual_address_map
+	 * is invoked.
 	 */
+	efi_phys.set_virtual_address_map =
+			(efi_set_virtual_address_map_t *)
+			(unsigned long)runtime->set_virtual_address_map;
+	early_iounmap(runtime, sizeof(efi_runtime_services_32_t));
+
+	return 0;
+}
+
+static int __init efi_runtime_init64(void)
+{
+	efi_runtime_services_64_t *runtime;
+
 	runtime = early_ioremap((unsigned long)efi.systab->runtime,
-				sizeof(efi_runtime_services_t));
+			sizeof(efi_runtime_services_64_t));
 	if (!runtime) {
 		pr_err("Could not map the runtime service table!\n");
 		return -ENOMEM;
 	}
+
 	/*
-	 * We will only need *early* access to the following
-	 * two EFI runtime services before set_virtual_address_map
+	 * We will only need *early* access to the following two
+	 * EFI runtime services before set_virtual_address_map
 	 * is invoked.
 	 */
-	efi_phys.get_time = (efi_get_time_t *)runtime->get_time;
 	efi_phys.set_virtual_address_map =
-		(efi_set_virtual_address_map_t *)
-		runtime->set_virtual_address_map;
+			(efi_set_virtual_address_map_t *)
+			(unsigned long)runtime->set_virtual_address_map;
+	early_iounmap(runtime, sizeof(efi_runtime_services_64_t));
+
+	return 0;
+}
+
+static int __init efi_runtime_init(void)
+{
+	int rv;
+
 	/*
-	 * Make efi_get_time can be called before entering
-	 * virtual mode.
+	 * Check out the runtime services table. We need to map
+	 * the runtime services table so that we can grab the physical
+	 * address of several of the EFI runtime functions, needed to
+	 * set the firmware into virtual mode.
 	 */
-	efi.get_time = phys_efi_get_time;
-	early_iounmap(runtime, sizeof(efi_runtime_services_t));
+	if (efi_enabled(EFI_64BIT))
+		rv = efi_runtime_init64();
+	else
+		rv = efi_runtime_init32();
+
+	if (rv)
+		return rv;
+
+	set_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 
 	return 0;
 }
@@ -641,6 +646,8 @@ static int __init efi_memmap_init(void)
 	if (add_efi_memmap)
 		do_add_efi_memmap();
 
+	set_bit(EFI_MEMMAP, &efi.flags);
+
 	return 0;
 }
 
@@ -723,7 +730,7 @@ void __init efi_init(void)
 	if (efi_systab_init(efi_phys.systab))
 		return;
 
-	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
+	set_bit(EFI_SYSTEM_TABLES, &efi.flags);
 
 	efi.config_table = (unsigned long)efi.systab->tables;
 	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
@@ -751,24 +758,21 @@ void __init efi_init(void)
 	if (efi_config_init(arch_tables))
 		return;
 
-	set_bit(EFI_CONFIG_TABLES, &x86_efi_facility);
-
 	/*
 	 * Note: We currently don't support runtime services on an EFI
 	 * that doesn't match the kernel 32/64-bit mode.
 	 */
 
-	if (!efi_is_native())
+	if (!efi_runtime_supported())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
 		if (disable_runtime || efi_runtime_init())
 			return;
-		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	}
 	if (efi_memmap_init())
 		return;
 
-	set_bit(EFI_MEMMAP, &x86_efi_facility);
+	set_bit(EFI_MEMMAP, &efi.flags);
 
 	print_efi_memmap();
 }
@@ -845,6 +849,22 @@ void __init old_map_region(efi_memory_desc_t *md)
 		       (unsigned long long)md->phys_addr);
 }
 
+static void native_runtime_setup(void)
+{
+	efi.get_time = virt_efi_get_time;
+	efi.set_time = virt_efi_set_time;
+	efi.get_wakeup_time = virt_efi_get_wakeup_time;
+	efi.set_wakeup_time = virt_efi_set_wakeup_time;
+	efi.get_variable = virt_efi_get_variable;
+	efi.get_next_variable = virt_efi_get_next_variable;
+	efi.set_variable = virt_efi_set_variable;
+	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
+	efi.reset_system = virt_efi_reset_system;
+	efi.query_variable_info = virt_efi_query_variable_info;
+	efi.update_capsule = virt_efi_update_capsule;
+	efi.query_capsule_caps = virt_efi_query_capsule_caps;
+}
+
 /* Merge contiguous regions of the same type and attribute */
 static void __init efi_merge_regions(void)
 {
@@ -892,8 +912,9 @@ static void __init get_systab_virt_addr(efi_memory_desc_t *md)
 	}
 }
 
-static int __init save_runtime_map(void)
+static void __init save_runtime_map(void)
 {
+#ifdef CONFIG_KEXEC
 	efi_memory_desc_t *md;
 	void *tmp, *p, *q = NULL;
 	int count = 0;
@@ -915,38 +936,44 @@ static int __init save_runtime_map(void)
 	}
 
 	efi_runtime_map_setup(q, count, memmap.desc_size);
+	return;
 
-	return 0;
 out:
 	kfree(q);
-	return -ENOMEM;
+	pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
+#endif
 }
 
-/*
- * Map efi regions which were passed via setup_data. The virt_addr is a fixed
- * addr which was used in first kernel of a kexec boot.
- */
-static void __init efi_map_regions_fixed(void)
+static void *realloc_pages(void *old_memmap, int old_shift)
 {
-	void *p;
-	efi_memory_desc_t *md;
+	void *ret;
 
-	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
-		md = p;
-		efi_map_region_fixed(md); /* FIXME: add error handling */
-		get_systab_virt_addr(md);
-	}
+	ret = (void *)__get_free_pages(GFP_KERNEL, old_shift + 1);
+	if (!ret)
+		goto out;
+
+	/*
+	 * A first-time allocation doesn't have anything to copy.
+	 */
+	if (!old_memmap)
+		return ret;
 
+	memcpy(ret, old_memmap, PAGE_SIZE << old_shift);
+
+out:
+	free_pages((unsigned long)old_memmap, old_shift);
+	return ret;
 }
 
 /*
- * Map efi memory ranges for runtime serivce and update new_memmap with virtual
- * addresses.
+ * Map the efi memory ranges of the runtime services and update new_mmap with
+ * virtual addresses.
  */
-static void * __init efi_map_regions(int *count)
+static void * __init efi_map_regions(int *count, int *pg_shift)
 {
+	void *p, *new_memmap = NULL;
+	unsigned long left = 0;
 	efi_memory_desc_t *md;
-	void *p, *tmp, *new_memmap = NULL;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -961,20 +988,80 @@ static void * __init efi_map_regions(int *count)
 		efi_map_region(md);
 		get_systab_virt_addr(md);
 
-		tmp = krealloc(new_memmap, (*count + 1) * memmap.desc_size,
-			       GFP_KERNEL);
-		if (!tmp)
-			goto out;
-		new_memmap = tmp;
+		if (left < memmap.desc_size) {
+			new_memmap = realloc_pages(new_memmap, *pg_shift);
+			if (!new_memmap)
+				return NULL;
+
+			left += PAGE_SIZE << *pg_shift;
+			(*pg_shift)++;
+		}
+
 		memcpy(new_memmap + (*count * memmap.desc_size), md,
 		       memmap.desc_size);
+
+		left -= memmap.desc_size;
 		(*count)++;
 	}
 
 	return new_memmap;
-out:
-	kfree(new_memmap);
-	return NULL;
+}
+
+static void __init kexec_enter_virtual_mode(void)
+{
+#ifdef CONFIG_KEXEC
+	efi_memory_desc_t *md;
+	void *p;
+
+	efi.systab = NULL;
+
+	/*
+	 * We don't do virtual mode, since we don't do runtime services, on
+	 * non-native EFI
+	 */
+	if (!efi_is_native()) {
+		efi_unmap_memmap();
+		return;
+	}
+
+	/*
+	* Map efi regions which were passed via setup_data. The virt_addr is a
+	* fixed addr which was used in first kernel of a kexec boot.
+	*/
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		efi_map_region_fixed(md); /* FIXME: add error handling */
+		get_systab_virt_addr(md);
+	}
+
+	save_runtime_map();
+
+	BUG_ON(!efi.systab);
+
+	efi_sync_low_kernel_mappings();
+
+	/*
+	 * Now that EFI is in virtual mode, update the function
+	 * pointers in the runtime service table to the new virtual addresses.
+	 *
+	 * Call EFI services through wrapper functions.
+	 */
+	efi.runtime_version = efi_systab.hdr.revision;
+
+	native_runtime_setup();
+
+	efi.set_virtual_address_map = NULL;
+
+	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
+		runtime_code_page_mkexec();
+
+	/* clean DUMMY object */
+	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
+			 EFI_VARIABLE_NON_VOLATILE |
+			 EFI_VARIABLE_BOOTSERVICE_ACCESS |
+			 EFI_VARIABLE_RUNTIME_ACCESS,
+			 0, NULL);
+#endif
 }
 
 /*
@@ -996,57 +1083,53 @@ out:
  *
  * Specially for kexec boot, efi runtime maps in previous kernel should
  * be passed in via setup_data. In that case runtime ranges will be mapped
- * to the same virtual addresses as the first kernel.
+ * to the same virtual addresses as the first kernel, see
+ * kexec_enter_virtual_mode().
  */
-void __init efi_enter_virtual_mode(void)
+static void __init __efi_enter_virtual_mode(void)
 {
-	efi_status_t status;
+	int count = 0, pg_shift = 0;
 	void *new_memmap = NULL;
-	int err, count = 0;
+	efi_status_t status;
 
 	efi.systab = NULL;
 
-	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
+	efi_merge_regions();
+	new_memmap = efi_map_regions(&count, &pg_shift);
+	if (!new_memmap) {
+		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
 		return;
 	}
 
-	if (efi_setup) {
-		efi_map_regions_fixed();
-	} else {
-		efi_merge_regions();
-		new_memmap = efi_map_regions(&count);
-		if (!new_memmap) {
-			pr_err("Error reallocating memory, EFI runtime non-functional!\n");
-			return;
-		}
-	}
-
-	err = save_runtime_map();
-	if (err)
-		pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
+	save_runtime_map();
 
 	BUG_ON(!efi.systab);
 
-	efi_setup_page_tables();
+	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
+		return;
+
 	efi_sync_low_kernel_mappings();
+	efi_dump_pagetable();
 
-	if (!efi_setup) {
+	if (efi_is_native()) {
 		status = phys_efi_set_virtual_address_map(
-			memmap.desc_size * count,
-			memmap.desc_size,
-			memmap.desc_version,
-			(efi_memory_desc_t *)__pa(new_memmap));
-
-		if (status != EFI_SUCCESS) {
-			pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
-				 status);
-			panic("EFI call to SetVirtualAddressMap() failed!");
-		}
+				memmap.desc_size * count,
+				memmap.desc_size,
+				memmap.desc_version,
+				(efi_memory_desc_t *)__pa(new_memmap));
+	} else {
+		status = efi_thunk_set_virtual_address_map(
+				efi_phys.set_virtual_address_map,
+				memmap.desc_size * count,
+				memmap.desc_size,
+				memmap.desc_version,
+				(efi_memory_desc_t *)__pa(new_memmap));
+	}
+
+	if (status != EFI_SUCCESS) {
+		pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
+			 status);
+		panic("EFI call to SetVirtualAddressMap() failed!");
 	}
 
 	/*
@@ -1056,23 +1139,43 @@ void __init efi_enter_virtual_mode(void)
 	 * Call EFI services through wrapper functions.
 	 */
 	efi.runtime_version = efi_systab.hdr.revision;
-	efi.get_time = virt_efi_get_time;
-	efi.set_time = virt_efi_set_time;
-	efi.get_wakeup_time = virt_efi_get_wakeup_time;
-	efi.set_wakeup_time = virt_efi_set_wakeup_time;
-	efi.get_variable = virt_efi_get_variable;
-	efi.get_next_variable = virt_efi_get_next_variable;
-	efi.set_variable = virt_efi_set_variable;
-	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
-	efi.reset_system = virt_efi_reset_system;
+
+	if (efi_is_native())
+		native_runtime_setup();
+	else
+		efi_thunk_runtime_setup();
+
 	efi.set_virtual_address_map = NULL;
-	efi.query_variable_info = virt_efi_query_variable_info;
-	efi.update_capsule = virt_efi_update_capsule;
-	efi.query_capsule_caps = virt_efi_query_capsule_caps;
 
 	efi_runtime_mkexec();
 
-	kfree(new_memmap);
+	/*
+	 * We mapped the descriptor array into the EFI pagetable above but we're
+	 * not unmapping it here. Here's why:
+	 *
+	 * We're copying select PGDs from the kernel page table to the EFI page
+	 * table and when we do so and make changes to those PGDs like unmapping
+	 * stuff from them, those changes appear in the kernel page table and we
+	 * go boom.
+	 *
+	 * From setup_real_mode():
+	 *
+	 * ...
+	 * trampoline_pgd[0] = init_level4_pgt[pgd_index(__PAGE_OFFSET)].pgd;
+	 *
+	 * In this particular case, our allocation is in PGD 0 of the EFI page
+	 * table but we've copied that PGD from PGD[272] of the EFI page table:
+	 *
+	 *	pgd_index(__PAGE_OFFSET = 0xffff880000000000) = 272
+	 *
+	 * where the direct memory mapping in kernel space is.
+	 *
+	 * new_memmap's VA comes from that direct mapping and thus clearing it,
+	 * it would get cleared in the kernel page table too.
+	 *
+	 * efi_cleanup_page_tables(__pa(new_memmap), 1 << pg_shift);
+	 */
+	free_pages((unsigned long)new_memmap, pg_shift);
 
 	/* clean DUMMY object */
 	efi.set_variable(efi_dummy_name, &EFI_DUMMY_GUID,
@@ -1082,6 +1185,14 @@ void __init efi_enter_virtual_mode(void)
 			 0, NULL);
 }
 
+void __init efi_enter_virtual_mode(void)
+{
+	if (efi_setup)
+		kexec_enter_virtual_mode();
+	else
+		__efi_enter_virtual_mode();
+}
+
 /*
  * Convenience functions to obtain memory types and attributes
  */
@@ -1119,9 +1230,8 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 }
 
 /*
- * Some firmware has serious problems when using more than 50% of the EFI
- * variable store, i.e. it triggers bugs that can brick machines. Ensure that
- * we never use more than this safe limit.
+ * Some firmware implementations refuse to boot if there's insufficient space
+ * in the variable store. Ensure that we never use more than a safe limit.
  *
  * Return EFI_SUCCESS if it is safe to write 'size' bytes to the variable
  * store.
@@ -1140,10 +1250,9 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 		return status;
 
 	/*
-	 * Some firmware implementations refuse to boot if there's insufficient
-	 * space in the variable store. We account for that by refusing the
-	 * write if permitting it would reduce the available space to under
-	 * 5KB. This figure was provided by Samsung, so should be safe.
+	 * We account for that by refusing the write if permitting it would
+	 * reduce the available space to under 5KB. This figure was provided by
+	 * Samsung, so should be safe.
 	 */
 	if ((remaining_size - size < EFI_MIN_RESERVE) &&
 		!efi_no_storage_paranoia) {
@@ -1206,7 +1315,7 @@ static int __init parse_efi_cmdline(char *str)
 		str++;
 
 	if (!strncmp(str, "old_map", 7))
-		set_bit(EFI_OLD_MEMMAP, &x86_efi_facility);
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 
 	return 0;
 }
@@ -1219,7 +1328,7 @@ void __init efi_apply_memmap_quirks(void)
 	 * firmware/kernel architectures since there is no support for runtime
 	 * services.
 	 */
-	if (!efi_is_native()) {
+	if (!efi_runtime_supported()) {
 		pr_info("efi: Setup done, disabling due to 32/64-bit mismatch\n");
 		efi_unmap_memmap();
 	}
@@ -1228,5 +1337,5 @@ void __init efi_apply_memmap_quirks(void)
 	 * UV doesn't support the new EFI pagetable mapping yet.
 	 */
 	if (is_uv_system())
-		set_bit(EFI_OLD_MEMMAP, &x86_efi_facility);
+		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 }
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 0b74cdf..9ee3491 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -40,7 +40,12 @@
 static unsigned long efi_rt_eflags;
 
 void efi_sync_low_kernel_mappings(void) {}
-void efi_setup_page_tables(void) {}
+void __init efi_dump_pagetable(void) {}
+int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+{
+	return 0;
+}
+void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages) {}
 
 void __init efi_map_region(efi_memory_desc_t *md)
 {
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 0c2a234..290d397 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -39,6 +39,7 @@
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
 #include <asm/realmode.h>
+#include <asm/time.h>
 
 static pgd_t *save_pgd __initdata;
 static unsigned long efi_flags __initdata;
@@ -58,7 +59,8 @@ struct efi_scratch {
 	u64 prev_cr3;
 	pgd_t *efi_pgt;
 	bool use_pgd;
-};
+	u64 phys_stack;
+} __packed;
 
 static void __init early_code_mapping_set_exec(int executable)
 {
@@ -137,12 +139,64 @@ void efi_sync_low_kernel_mappings(void)
 		sizeof(pgd_t) * num_pgds);
 }
 
-void efi_setup_page_tables(void)
+int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
+	unsigned long text;
+	struct page *page;
+	unsigned npages;
+	pgd_t *pgd;
+
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return 0;
+
 	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
+	pgd = __va(efi_scratch.efi_pgt);
 
-	if (!efi_enabled(EFI_OLD_MEMMAP))
-		efi_scratch.use_pgd = true;
+	/*
+	 * It can happen that the physical address of new_memmap lands in memory
+	 * which is not mapped in the EFI page table. Therefore we need to go
+	 * and ident-map those pages containing the map before calling
+	 * phys_efi_set_virtual_address_map().
+	 */
+	if (kernel_map_pages_in_pgd(pgd, pa_memmap, pa_memmap, num_pages, _PAGE_NX)) {
+		pr_err("Error ident-mapping new memmap (0x%lx)!\n", pa_memmap);
+		return 1;
+	}
+
+	efi_scratch.use_pgd = true;
+
+	/*
+	 * When making calls to the firmware everything needs to be 1:1
+	 * mapped and addressable with 32-bit pointers. Map the kernel
+	 * text and allocate a new stack because we can't rely on the
+	 * stack pointer being < 4GB.
+	 */
+	if (!IS_ENABLED(CONFIG_EFI_MIXED))
+		return 0;
+
+	page = alloc_page(GFP_KERNEL|__GFP_DMA32);
+	if (!page)
+		panic("Unable to allocate EFI runtime stack < 4GB\n");
+
+	efi_scratch.phys_stack = virt_to_phys(page_address(page));
+	efi_scratch.phys_stack += PAGE_SIZE; /* stack grows down */
+
+	npages = (_end - _text) >> PAGE_SHIFT;
+	text = __pa(_text);
+
+	if (kernel_map_pages_in_pgd(pgd, text >> PAGE_SHIFT, text, npages, 0)) {
+		pr_err("Failed to map kernel text 1:1\n");
+		return 1;
+	}
+
+	return 0;
+}
+
+void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	kernel_unmap_pages_in_pgd(pgd, pa_memmap, num_pages);
 }
 
 static void __init __map_region(efi_memory_desc_t *md, u64 va)
@@ -173,6 +227,16 @@ void __init efi_map_region(efi_memory_desc_t *md)
 	 */
 	__map_region(md, md->phys_addr);
 
+	/*
+	 * Enforce the 1:1 mapping as the default virtual address when
+	 * booting in EFI mixed mode, because even though we may be
+	 * running a 64-bit kernel, the firmware may only be 32-bit.
+	 */
+	if (!efi_is_native () && IS_ENABLED(CONFIG_EFI_MIXED)) {
+		md->virt_addr = md->phys_addr;
+		return;
+	}
+
 	efi_va -= size;
 
 	/* Is PA 2M-aligned? */
@@ -242,3 +306,299 @@ void __init efi_runtime_mkexec(void)
 	if (__supported_pte_mask & _PAGE_NX)
 		runtime_code_page_mkexec();
 }
+
+void __init efi_dump_pagetable(void)
+{
+#ifdef CONFIG_EFI_PGT_DUMP
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	ptdump_walk_pgd_level(NULL, pgd);
+#endif
+}
+
+#ifdef CONFIG_EFI_MIXED
+extern efi_status_t efi64_thunk(u32, ...);
+
+#define runtime_service32(func)						 \
+({									 \
+	u32 table = (u32)(unsigned long)efi.systab;			 \
+	u32 *rt, *___f;							 \
+									 \
+	rt = (u32 *)(table + offsetof(efi_system_table_32_t, runtime));	 \
+	___f = (u32 *)(*rt + offsetof(efi_runtime_services_32_t, func)); \
+	*___f;								 \
+})
+
+/*
+ * Switch to the EFI page tables early so that we can access the 1:1
+ * runtime services mappings which are not mapped in any other page
+ * tables. This function must be called before runtime_service32().
+ *
+ * Also, disable interrupts because the IDT points to 64-bit handlers,
+ * which aren't going to function correctly when we switch to 32-bit.
+ */
+#define efi_thunk(f, ...)						\
+({									\
+	efi_status_t __s;						\
+	unsigned long flags;						\
+	u32 func;							\
+									\
+	efi_sync_low_kernel_mappings();					\
+	local_irq_save(flags);						\
+									\
+	efi_scratch.prev_cr3 = read_cr3();				\
+	write_cr3((unsigned long)efi_scratch.efi_pgt);			\
+	__flush_tlb_all();						\
+									\
+	func = runtime_service32(f);					\
+	__s = efi64_thunk(func, __VA_ARGS__);			\
+									\
+	write_cr3(efi_scratch.prev_cr3);				\
+	__flush_tlb_all();						\
+	local_irq_restore(flags);					\
+									\
+	__s;								\
+})
+
+efi_status_t efi_thunk_set_virtual_address_map(
+	void *phys_set_virtual_address_map,
+	unsigned long memory_map_size,
+	unsigned long descriptor_size,
+	u32 descriptor_version,
+	efi_memory_desc_t *virtual_map)
+{
+	efi_status_t status;
+	unsigned long flags;
+	u32 func;
+
+	efi_sync_low_kernel_mappings();
+	local_irq_save(flags);
+
+	efi_scratch.prev_cr3 = read_cr3();
+	write_cr3((unsigned long)efi_scratch.efi_pgt);
+	__flush_tlb_all();
+
+	func = (u32)(unsigned long)phys_set_virtual_address_map;
+	status = efi64_thunk(func, memory_map_size, descriptor_size,
+			     descriptor_version, virtual_map);
+
+	write_cr3(efi_scratch.prev_cr3);
+	__flush_tlb_all();
+	local_irq_restore(flags);
+
+	return status;
+}
+
+static efi_status_t efi_thunk_get_time(efi_time_t *tm, efi_time_cap_t *tc)
+{
+	efi_status_t status;
+	u32 phys_tm, phys_tc;
+
+	spin_lock(&rtc_lock);
+
+	phys_tm = virt_to_phys(tm);
+	phys_tc = virt_to_phys(tc);
+
+	status = efi_thunk(get_time, phys_tm, phys_tc);
+
+	spin_unlock(&rtc_lock);
+
+	return status;
+}
+
+static efi_status_t efi_thunk_set_time(efi_time_t *tm)
+{
+	efi_status_t status;
+	u32 phys_tm;
+
+	spin_lock(&rtc_lock);
+
+	phys_tm = virt_to_phys(tm);
+
+	status = efi_thunk(set_time, phys_tm);
+
+	spin_unlock(&rtc_lock);
+
+	return status;
+}
+
+static efi_status_t
+efi_thunk_get_wakeup_time(efi_bool_t *enabled, efi_bool_t *pending,
+			  efi_time_t *tm)
+{
+	efi_status_t status;
+	u32 phys_enabled, phys_pending, phys_tm;
+
+	spin_lock(&rtc_lock);
+
+	phys_enabled = virt_to_phys(enabled);
+	phys_pending = virt_to_phys(pending);
+	phys_tm = virt_to_phys(tm);
+
+	status = efi_thunk(get_wakeup_time, phys_enabled,
+			     phys_pending, phys_tm);
+
+	spin_unlock(&rtc_lock);
+
+	return status;
+}
+
+static efi_status_t
+efi_thunk_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
+{
+	efi_status_t status;
+	u32 phys_tm;
+
+	spin_lock(&rtc_lock);
+
+	phys_tm = virt_to_phys(tm);
+
+	status = efi_thunk(set_wakeup_time, enabled, phys_tm);
+
+	spin_unlock(&rtc_lock);
+
+	return status;
+}
+
+
+static efi_status_t
+efi_thunk_get_variable(efi_char16_t *name, efi_guid_t *vendor,
+		       u32 *attr, unsigned long *data_size, void *data)
+{
+	efi_status_t status;
+	u32 phys_name, phys_vendor, phys_attr;
+	u32 phys_data_size, phys_data;
+
+	phys_data_size = virt_to_phys(data_size);
+	phys_vendor = virt_to_phys(vendor);
+	phys_name = virt_to_phys(name);
+	phys_attr = virt_to_phys(attr);
+	phys_data = virt_to_phys(data);
+
+	status = efi_thunk(get_variable, phys_name, phys_vendor,
+			   phys_attr, phys_data_size, phys_data);
+
+	return status;
+}
+
+static efi_status_t
+efi_thunk_set_variable(efi_char16_t *name, efi_guid_t *vendor,
+		       u32 attr, unsigned long data_size, void *data)
+{
+	u32 phys_name, phys_vendor, phys_data;
+	efi_status_t status;
+
+	phys_name = virt_to_phys(name);
+	phys_vendor = virt_to_phys(vendor);
+	phys_data = virt_to_phys(data);
+
+	/* If data_size is > sizeof(u32) we've got problems */
+	status = efi_thunk(set_variable, phys_name, phys_vendor,
+			   attr, data_size, phys_data);
+
+	return status;
+}
+
+static efi_status_t
+efi_thunk_get_next_variable(unsigned long *name_size,
+			    efi_char16_t *name,
+			    efi_guid_t *vendor)
+{
+	efi_status_t status;
+	u32 phys_name_size, phys_name, phys_vendor;
+
+	phys_name_size = virt_to_phys(name_size);
+	phys_vendor = virt_to_phys(vendor);
+	phys_name = virt_to_phys(name);
+
+	status = efi_thunk(get_next_variable, phys_name_size,
+			   phys_name, phys_vendor);
+
+	return status;
+}
+
+static efi_status_t
+efi_thunk_get_next_high_mono_count(u32 *count)
+{
+	efi_status_t status;
+	u32 phys_count;
+
+	phys_count = virt_to_phys(count);
+	status = efi_thunk(get_next_high_mono_count, phys_count);
+
+	return status;
+}
+
+static void
+efi_thunk_reset_system(int reset_type, efi_status_t status,
+		       unsigned long data_size, efi_char16_t *data)
+{
+	u32 phys_data;
+
+	phys_data = virt_to_phys(data);
+
+	efi_thunk(reset_system, reset_type, status, data_size, phys_data);
+}
+
+static efi_status_t
+efi_thunk_update_capsule(efi_capsule_header_t **capsules,
+			 unsigned long count, unsigned long sg_list)
+{
+	/*
+	 * To properly support this function we would need to repackage
+	 * 'capsules' because the firmware doesn't understand 64-bit
+	 * pointers.
+	 */
+	return EFI_UNSUPPORTED;
+}
+
+static efi_status_t
+efi_thunk_query_variable_info(u32 attr, u64 *storage_space,
+			      u64 *remaining_space,
+			      u64 *max_variable_size)
+{
+	efi_status_t status;
+	u32 phys_storage, phys_remaining, phys_max;
+
+	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
+		return EFI_UNSUPPORTED;
+
+	phys_storage = virt_to_phys(storage_space);
+	phys_remaining = virt_to_phys(remaining_space);
+	phys_max = virt_to_phys(max_variable_size);
+
+	status = efi_thunk(query_variable_info, attr, phys_storage,
+			   phys_remaining, phys_max);
+
+	return status;
+}
+
+static efi_status_t
+efi_thunk_query_capsule_caps(efi_capsule_header_t **capsules,
+			     unsigned long count, u64 *max_size,
+			     int *reset_type)
+{
+	/*
+	 * To properly support this function we would need to repackage
+	 * 'capsules' because the firmware doesn't understand 64-bit
+	 * pointers.
+	 */
+	return EFI_UNSUPPORTED;
+}
+
+void efi_thunk_runtime_setup(void)
+{
+	efi.get_time = efi_thunk_get_time;
+	efi.set_time = efi_thunk_set_time;
+	efi.get_wakeup_time = efi_thunk_get_wakeup_time;
+	efi.set_wakeup_time = efi_thunk_set_wakeup_time;
+	efi.get_variable = efi_thunk_get_variable;
+	efi.get_next_variable = efi_thunk_get_next_variable;
+	efi.set_variable = efi_thunk_set_variable;
+	efi.get_next_high_mono_count = efi_thunk_get_next_high_mono_count;
+	efi.reset_system = efi_thunk_reset_system;
+	efi.query_variable_info = efi_thunk_query_variable_info;
+	efi.update_capsule = efi_thunk_update_capsule;
+	efi.query_capsule_caps = efi_thunk_query_capsule_caps;
+}
+#endif /* CONFIG_EFI_MIXED */
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 88073b1..e0984ef 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -7,6 +7,10 @@
  */
 
 #include <linux/linkage.h>
+#include <asm/segment.h>
+#include <asm/msr.h>
+#include <asm/processor-flags.h>
+#include <asm/page_types.h>
 
 #define SAVE_XMM			\
 	mov %rsp, %rax;			\
@@ -164,7 +168,169 @@ ENTRY(efi_call6)
 	ret
 ENDPROC(efi_call6)
 
+#ifdef CONFIG_EFI_MIXED
+
+/*
+ * We run this function from the 1:1 mapping.
+ *
+ * This function must be invoked with a 1:1 mapped stack.
+ */
+ENTRY(__efi64_thunk)
+	movl	%ds, %eax
+	push	%rax
+	movl	%es, %eax
+	push	%rax
+	movl	%ss, %eax
+	push	%rax
+
+	subq	$32, %rsp
+	movl	%esi, 0x0(%rsp)
+	movl	%edx, 0x4(%rsp)
+	movl	%ecx, 0x8(%rsp)
+	movq	%r8, %rsi
+	movl	%esi, 0xc(%rsp)
+	movq	%r9, %rsi
+	movl	%esi,  0x10(%rsp)
+
+	sgdt	save_gdt(%rip)
+
+	leaq	1f(%rip), %rbx
+	movq	%rbx, func_rt_ptr(%rip)
+
+	/* Switch to gdt with 32-bit segments */
+	movl	64(%rsp), %eax
+	lgdt	(%rax)
+
+	leaq	efi_enter32(%rip), %rax
+	pushq	$__KERNEL_CS
+	pushq	%rax
+	lretq
+
+1:	addq	$32, %rsp
+
+	lgdt	save_gdt(%rip)
+
+	pop	%rbx
+	movl	%ebx, %ss
+	pop	%rbx
+	movl	%ebx, %es
+	pop	%rbx
+	movl	%ebx, %ds
+
+	/*
+	 * Convert 32-bit status code into 64-bit.
+	 */
+	test	%rax, %rax
+	jz	1f
+	movl	%eax, %ecx
+	andl	$0x0fffffff, %ecx
+	andl	$0xf0000000, %eax
+	shl	$32, %rax
+	or	%rcx, %rax
+1:
+	ret
+ENDPROC(__efi64_thunk)
+
+ENTRY(efi_exit32)
+	movq	func_rt_ptr(%rip), %rax
+	push	%rax
+	mov	%rdi, %rax
+	ret
+ENDPROC(efi_exit32)
+
+	.code32
+/*
+ * EFI service pointer must be in %edi.
+ *
+ * The stack should represent the 32-bit calling convention.
+ */
+ENTRY(efi_enter32)
+	movl	$__KERNEL_DS, %eax
+	movl	%eax, %ds
+	movl	%eax, %es
+	movl	%eax, %ss
+
+	/* Reload pgtables */
+	movl	%cr3, %eax
+	movl	%eax, %cr3
+
+	/* Disable paging */
+	movl	%cr0, %eax
+	btrl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+
+	/* Disable long mode via EFER */
+	movl	$MSR_EFER, %ecx
+	rdmsr
+	btrl	$_EFER_LME, %eax
+	wrmsr
+
+	call	*%edi
+
+	/* We must preserve return value */
+	movl	%eax, %edi
+
+	/*
+	 * Some firmware will return with interrupts enabled. Be sure to
+	 * disable them before we switch GDTs.
+	 */
+	cli
+
+	movl	68(%esp), %eax
+	movl	%eax, 2(%eax)
+	lgdtl	(%eax)
+
+	movl	%cr4, %eax
+	btsl	$(X86_CR4_PAE_BIT), %eax
+	movl	%eax, %cr4
+
+	movl	%cr3, %eax
+	movl	%eax, %cr3
+
+	movl	$MSR_EFER, %ecx
+	rdmsr
+	btsl	$_EFER_LME, %eax
+	wrmsr
+
+	xorl	%eax, %eax
+	lldt	%ax
+
+	movl	72(%esp), %eax
+	pushl	$__KERNEL_CS
+	pushl	%eax
+
+	/* Enable paging */
+	movl	%cr0, %eax
+	btsl	$X86_CR0_PG_BIT, %eax
+	movl	%eax, %cr0
+	lret
+ENDPROC(efi_enter32)
+
+	.data
+	.balign	8
+	.global	efi32_boot_gdt
+efi32_boot_gdt:	.word	0
+		.quad	0
+
+save_gdt:	.word	0
+		.quad	0
+func_rt_ptr:	.quad	0
+
+	.global efi_gdt64
+efi_gdt64:
+	.word	efi_gdt64_end - efi_gdt64
+	.long	0			/* Filled out by user */
+	.word	0
+	.quad	0x0000000000000000	/* NULL descriptor */
+	.quad	0x00af9a000000ffff	/* __KERNEL_CS */
+	.quad	0x00cf92000000ffff	/* __KERNEL_DS */
+	.quad	0x0080890000000000	/* TS descriptor */
+	.quad   0x0000000000000000	/* TS continued */
+efi_gdt64_end:
+#endif /* CONFIG_EFI_MIXED */
+
 	.data
 ENTRY(efi_scratch)
 	.fill 3,8,0
 	.byte 0
+	.quad 0
diff --git a/arch/x86/platform/efi/efi_thunk_64.S b/arch/x86/platform/efi/efi_thunk_64.S
new file mode 100644
index 0000000..8806fa7
--- /dev/null
+++ b/arch/x86/platform/efi/efi_thunk_64.S
@@ -0,0 +1,65 @@
+/*
+ * Copyright (C) 2014 Intel Corporation; author Matt Fleming
+ */
+
+#include <linux/linkage.h>
+#include <asm/page_types.h>
+
+	.text
+	.code64
+ENTRY(efi64_thunk)
+	push	%rbp
+	push	%rbx
+
+	/*
+	 * Switch to 1:1 mapped 32-bit stack pointer.
+	 */
+	movq	%rsp, efi_saved_sp(%rip)
+	movq	efi_scratch+25(%rip), %rsp
+
+	/*
+	 * Calculate the physical address of the kernel text.
+	 */
+	movq	$__START_KERNEL_map, %rax
+	subq	phys_base(%rip), %rax
+
+	/*
+	 * Push some physical addresses onto the stack. This is easier
+	 * to do now in a code64 section while the assembler can address
+	 * 64-bit values. Note that all the addresses on the stack are
+	 * 32-bit.
+	 */
+	subq	$16, %rsp
+	leaq	efi_exit32(%rip), %rbx
+	subq	%rax, %rbx
+	movl	%ebx, 8(%rsp)
+	leaq	efi_gdt64(%rip), %rbx
+	subq	%rax, %rbx
+	movl	%ebx, 2(%ebx)
+	movl	%ebx, 4(%rsp)
+	leaq	efi_gdt32(%rip), %rbx
+	subq	%rax, %rbx
+	movl	%ebx, 2(%ebx)
+	movl	%ebx, (%rsp)
+
+	leaq	__efi64_thunk(%rip), %rbx
+	subq	%rax, %rbx
+	call	*%rbx
+
+	movq	efi_saved_sp(%rip), %rsp
+	pop	%rbx
+	pop	%rbp
+	retq
+ENDPROC(efi64_thunk)
+
+	.data
+efi_gdt32:
+	.word 	efi_gdt32_end - efi_gdt32
+	.long	0			/* Filled out above */
+	.word	0
+	.quad	0x0000000000000000	/* NULL descriptor */
+	.quad	0x00cf9a000000ffff	/* __KERNEL_CS */
+	.quad	0x00cf93000000ffff	/* __KERNEL_DS */
+efi_gdt32_end:
+
+efi_saved_sp:		.quad 0
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index b6bffbf..ff50aee 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -16,18 +16,6 @@ struct file_info {
 	u64 size;
 };
 
-
-
-
-static void efi_char16_printk(efi_system_table_t *sys_table_arg,
-			      efi_char16_t *str)
-{
-	struct efi_simple_text_output_protocol *out;
-
-	out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
-	efi_call_phys2(out->output_string, out, str);
-}
-
 static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 {
 	char *s8;
@@ -65,20 +53,23 @@ again:
 	 * allocation which may be in a new descriptor region.
 	 */
 	*map_size += sizeof(*m);
-	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-				EFI_LOADER_DATA, *map_size, (void **)&m);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				*map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	status = efi_call_phys5(sys_table_arg->boottime->get_memory_map,
-				map_size, m, &key, desc_size, &desc_version);
+	*desc_size = 0;
+	key = 0;
+	status = efi_call_early(get_memory_map, map_size, m,
+				&key, desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+		efi_call_early(free_pool, m);
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
-		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+		efi_call_early(free_pool, m);
+
 	if (key_ptr && status == EFI_SUCCESS)
 		*key_ptr = key;
 	if (desc_ver && status == EFI_SUCCESS)
@@ -158,7 +149,7 @@ again:
 	if (!max_addr)
 		status = EFI_NOT_FOUND;
 	else {
-		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
+		status = efi_call_early(allocate_pages,
 					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					nr_pages, &max_addr);
 		if (status != EFI_SUCCESS) {
@@ -170,8 +161,7 @@ again:
 		*addr = max_addr;
 	}
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
-
+	efi_call_early(free_pool, map);
 fail:
 	return status;
 }
@@ -231,7 +221,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		if ((start + size) > end)
 			continue;
 
-		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
+		status = efi_call_early(allocate_pages,
 					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					nr_pages, &start);
 		if (status == EFI_SUCCESS) {
@@ -243,7 +233,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
+	efi_call_early(free_pool, map);
 fail:
 	return status;
 }
@@ -257,7 +247,7 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 		return;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
+	efi_call_early(free_pages, addr, nr_pages);
 }
 
 
@@ -276,9 +266,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 {
 	struct file_info *files;
 	unsigned long file_addr;
-	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
 	u64 file_size_total;
-	efi_file_io_interface_t *io;
 	efi_file_handle_t *fh;
 	efi_status_t status;
 	int nr_files;
@@ -319,10 +307,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	if (!nr_files)
 		return EFI_SUCCESS;
 
-	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-				EFI_LOADER_DATA,
-				nr_files * sizeof(*files),
-				(void **)&files);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				nr_files * sizeof(*files), (void **)&files);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
@@ -331,13 +317,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	str = cmd_line;
 	for (i = 0; i < nr_files; i++) {
 		struct file_info *file;
-		efi_file_handle_t *h;
-		efi_file_info_t *info;
 		efi_char16_t filename_16[256];
-		unsigned long info_sz;
-		efi_guid_t info_guid = EFI_FILE_INFO_ID;
 		efi_char16_t *p;
-		u64 file_sz;
 
 		str = strstr(str, option_string);
 		if (!str)
@@ -368,71 +349,18 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 		/* Only open the volume once. */
 		if (!i) {
-			efi_boot_services_t *boottime;
-
-			boottime = sys_table_arg->boottime;
-
-			status = efi_call_phys3(boottime->handle_protocol,
-					image->device_handle, &fs_proto,
-						(void **)&io);
-			if (status != EFI_SUCCESS) {
-				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
-				goto free_files;
-			}
-
-			status = efi_call_phys2(io->open_volume, io, &fh);
-			if (status != EFI_SUCCESS) {
-				efi_printk(sys_table_arg, "Failed to open volume\n");
+			status = efi_open_volume(sys_table_arg, image,
+						 (void **)&fh);
+			if (status != EFI_SUCCESS)
 				goto free_files;
-			}
 		}
 
-		status = efi_call_phys5(fh->open, fh, &h, filename_16,
-					EFI_FILE_MODE_READ, (u64)0);
-		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to open file: ");
-			efi_char16_printk(sys_table_arg, filename_16);
-			efi_printk(sys_table_arg, "\n");
+		status = efi_file_size(sys_table_arg, fh, filename_16,
+				       (void **)&file->handle, &file->size);
+		if (status != EFI_SUCCESS)
 			goto close_handles;
-		}
 
-		file->handle = h;
-
-		info_sz = 0;
-		status = efi_call_phys4(h->get_info, h, &info_guid,
-					&info_sz, NULL);
-		if (status != EFI_BUFFER_TOO_SMALL) {
-			efi_printk(sys_table_arg, "Failed to get file info size\n");
-			goto close_handles;
-		}
-
-grow:
-		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
-					EFI_LOADER_DATA, info_sz,
-					(void **)&info);
-		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
-			goto close_handles;
-		}
-
-		status = efi_call_phys4(h->get_info, h, &info_guid,
-					&info_sz, info);
-		if (status == EFI_BUFFER_TOO_SMALL) {
-			efi_call_phys1(sys_table_arg->boottime->free_pool,
-				       info);
-			goto grow;
-		}
-
-		file_sz = info->file_size;
-		efi_call_phys1(sys_table_arg->boottime->free_pool, info);
-
-		if (status != EFI_SUCCESS) {
-			efi_printk(sys_table_arg, "Failed to get file info\n");
-			goto close_handles;
-		}
-
-		file->size = file_sz;
-		file_size_total += file_sz;
+		file_size_total += file->size;
 	}
 
 	if (file_size_total) {
@@ -468,10 +396,10 @@ grow:
 					chunksize = EFI_READ_CHUNK_SIZE;
 				else
 					chunksize = size;
-				status = efi_call_phys3(fh->read,
-							files[j].handle,
-							&chunksize,
-							(void *)addr);
+
+				status = efi_file_read(fh, files[j].handle,
+						       &chunksize,
+						       (void *)addr);
 				if (status != EFI_SUCCESS) {
 					efi_printk(sys_table_arg, "Failed to read file\n");
 					goto free_file_total;
@@ -480,12 +408,12 @@ grow:
 				size -= chunksize;
 			}
 
-			efi_call_phys1(fh->close, files[j].handle);
+			efi_file_close(fh, files[j].handle);
 		}
 
 	}
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
+	efi_call_early(free_pool, files);
 
 	*load_addr = file_addr;
 	*load_size = file_size_total;
@@ -497,9 +425,9 @@ free_file_total:
 
 close_handles:
 	for (k = j; k < i; k++)
-		efi_call_phys1(fh->close, files[k].handle);
+		efi_file_close(fh, files[k].handle);
 free_files:
-	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
+	efi_call_early(free_pool, files);
 fail:
 	*load_addr = 0;
 	*load_size = 0;
@@ -545,7 +473,7 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * as possible while respecting the required alignment.
 	 */
 	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
+	status = efi_call_early(allocate_pages,
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 				nr_pages, &efi_addr);
 	new_addr = efi_addr;
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 4753bac..af20f17 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -233,7 +233,7 @@ static __initdata efi_config_table_type_t common_tables[] = {
 	{SAL_SYSTEM_TABLE_GUID, "SALsystab", &efi.sal_systab},
 	{SMBIOS_TABLE_GUID, "SMBIOS", &efi.smbios},
 	{UGA_IO_PROTOCOL_GUID, "UGA", &efi.uga},
-	{NULL_GUID, NULL, 0},
+	{NULL_GUID, NULL, NULL},
 };
 
 static __init int match_config_table(efi_guid_t *guid,
@@ -313,5 +313,8 @@ int __init efi_config_init(efi_config_table_type_t *arch_tables)
 	}
 	pr_cont("\n");
 	early_iounmap(config_tables, efi.systab->nr_tables * sz);
+
+	set_bit(EFI_CONFIG_TABLES, &efi.flags);
+
 	return 0;
 }
diff --git a/drivers/firmware/efi/efivars.c b/drivers/firmware/efi/efivars.c
index 3dc2482..50ea412 100644
--- a/drivers/firmware/efi/efivars.c
+++ b/drivers/firmware/efi/efivars.c
@@ -227,7 +227,7 @@ efivar_store_raw(struct efivar_entry *entry, const char *buf, size_t count)
 	memcpy(&entry->var, new_var, count);
 
 	err = efivar_entry_set(entry, new_var->Attributes,
-			       new_var->DataSize, new_var->Data, false);
+			       new_var->DataSize, new_var->Data, NULL);
 	if (err) {
 		printk(KERN_WARNING "efivars: set_variable() failed: status=%d\n", err);
 		return -EIO;
diff --git a/fs/efivarfs/file.c b/fs/efivarfs/file.c
index 8dd524f..cdb2971 100644
--- a/fs/efivarfs/file.c
+++ b/fs/efivarfs/file.c
@@ -21,7 +21,7 @@ static ssize_t efivarfs_file_write(struct file *file,
 	u32 attributes;
 	struct inode *inode = file->f_mapping->host;
 	unsigned long datasize = count - sizeof(attributes);
-	ssize_t bytes = 0;
+	ssize_t bytes;
 	bool set = false;
 
 	if (count < sizeof(attributes))
@@ -33,14 +33,9 @@ static ssize_t efivarfs_file_write(struct file *file,
 	if (attributes & ~(EFI_VARIABLE_MASK))
 		return -EINVAL;
 
-	data = kmalloc(datasize, GFP_KERNEL);
-	if (!data)
-		return -ENOMEM;
-
-	if (copy_from_user(data, userbuf + sizeof(attributes), datasize)) {
-		bytes = -EFAULT;
-		goto out;
-	}
+	data = memdup_user(userbuf + sizeof(attributes), datasize);
+	if (IS_ERR(data))
+		return PTR_ERR(data);
 
 	bytes = efivar_entry_set_get_size(var, attributes, &datasize,
 					  data, &set);
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 0a819e7..6c100ff 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -153,6 +153,102 @@ typedef struct {
 	u8 sets_to_zero;
 } efi_time_cap_t;
 
+typedef struct {
+	efi_table_hdr_t hdr;
+	u32 raise_tpl;
+	u32 restore_tpl;
+	u32 allocate_pages;
+	u32 free_pages;
+	u32 get_memory_map;
+	u32 allocate_pool;
+	u32 free_pool;
+	u32 create_event;
+	u32 set_timer;
+	u32 wait_for_event;
+	u32 signal_event;
+	u32 close_event;
+	u32 check_event;
+	u32 install_protocol_interface;
+	u32 reinstall_protocol_interface;
+	u32 uninstall_protocol_interface;
+	u32 handle_protocol;
+	u32 __reserved;
+	u32 register_protocol_notify;
+	u32 locate_handle;
+	u32 locate_device_path;
+	u32 install_configuration_table;
+	u32 load_image;
+	u32 start_image;
+	u32 exit;
+	u32 unload_image;
+	u32 exit_boot_services;
+	u32 get_next_monotonic_count;
+	u32 stall;
+	u32 set_watchdog_timer;
+	u32 connect_controller;
+	u32 disconnect_controller;
+	u32 open_protocol;
+	u32 close_protocol;
+	u32 open_protocol_information;
+	u32 protocols_per_handle;
+	u32 locate_handle_buffer;
+	u32 locate_protocol;
+	u32 install_multiple_protocol_interfaces;
+	u32 uninstall_multiple_protocol_interfaces;
+	u32 calculate_crc32;
+	u32 copy_mem;
+	u32 set_mem;
+	u32 create_event_ex;
+} __packed efi_boot_services_32_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
+	u64 raise_tpl;
+	u64 restore_tpl;
+	u64 allocate_pages;
+	u64 free_pages;
+	u64 get_memory_map;
+	u64 allocate_pool;
+	u64 free_pool;
+	u64 create_event;
+	u64 set_timer;
+	u64 wait_for_event;
+	u64 signal_event;
+	u64 close_event;
+	u64 check_event;
+	u64 install_protocol_interface;
+	u64 reinstall_protocol_interface;
+	u64 uninstall_protocol_interface;
+	u64 handle_protocol;
+	u64 __reserved;
+	u64 register_protocol_notify;
+	u64 locate_handle;
+	u64 locate_device_path;
+	u64 install_configuration_table;
+	u64 load_image;
+	u64 start_image;
+	u64 exit;
+	u64 unload_image;
+	u64 exit_boot_services;
+	u64 get_next_monotonic_count;
+	u64 stall;
+	u64 set_watchdog_timer;
+	u64 connect_controller;
+	u64 disconnect_controller;
+	u64 open_protocol;
+	u64 close_protocol;
+	u64 open_protocol_information;
+	u64 protocols_per_handle;
+	u64 locate_handle_buffer;
+	u64 locate_protocol;
+	u64 install_multiple_protocol_interfaces;
+	u64 uninstall_multiple_protocol_interfaces;
+	u64 calculate_crc32;
+	u64 copy_mem;
+	u64 set_mem;
+	u64 create_event_ex;
+} __packed efi_boot_services_64_t;
+
 /*
  * EFI Boot Services table
  */
@@ -231,6 +327,15 @@ typedef enum {
     EfiPciIoAttributeOperationMaximum
 } EFI_PCI_IO_PROTOCOL_ATTRIBUTE_OPERATION;
 
+typedef struct {
+	u32 read;
+	u32 write;
+} efi_pci_io_protocol_access_32_t;
+
+typedef struct {
+	u64 read;
+	u64 write;
+} efi_pci_io_protocol_access_64_t;
 
 typedef struct {
 	void *read;
@@ -238,6 +343,46 @@ typedef struct {
 } efi_pci_io_protocol_access_t;
 
 typedef struct {
+	u32 poll_mem;
+	u32 poll_io;
+	efi_pci_io_protocol_access_32_t mem;
+	efi_pci_io_protocol_access_32_t io;
+	efi_pci_io_protocol_access_32_t pci;
+	u32 copy_mem;
+	u32 map;
+	u32 unmap;
+	u32 allocate_buffer;
+	u32 free_buffer;
+	u32 flush;
+	u32 get_location;
+	u32 attributes;
+	u32 get_bar_attributes;
+	u32 set_bar_attributes;
+	uint64_t romsize;
+	void *romimage;
+} efi_pci_io_protocol_32;
+
+typedef struct {
+	u64 poll_mem;
+	u64 poll_io;
+	efi_pci_io_protocol_access_64_t mem;
+	efi_pci_io_protocol_access_64_t io;
+	efi_pci_io_protocol_access_64_t pci;
+	u64 copy_mem;
+	u64 map;
+	u64 unmap;
+	u64 allocate_buffer;
+	u64 free_buffer;
+	u64 flush;
+	u64 get_location;
+	u64 attributes;
+	u64 get_bar_attributes;
+	u64 set_bar_attributes;
+	uint64_t romsize;
+	void *romimage;
+} efi_pci_io_protocol_64;
+
+typedef struct {
 	void *poll_mem;
 	void *poll_io;
 	efi_pci_io_protocol_access_t mem;
@@ -292,6 +437,42 @@ typedef struct {
 
 typedef struct {
 	efi_table_hdr_t hdr;
+	u32 get_time;
+	u32 set_time;
+	u32 get_wakeup_time;
+	u32 set_wakeup_time;
+	u32 set_virtual_address_map;
+	u32 convert_pointer;
+	u32 get_variable;
+	u32 get_next_variable;
+	u32 set_variable;
+	u32 get_next_high_mono_count;
+	u32 reset_system;
+	u32 update_capsule;
+	u32 query_capsule_caps;
+	u32 query_variable_info;
+} efi_runtime_services_32_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
+	u64 get_time;
+	u64 set_time;
+	u64 get_wakeup_time;
+	u64 set_wakeup_time;
+	u64 set_virtual_address_map;
+	u64 convert_pointer;
+	u64 get_variable;
+	u64 get_next_variable;
+	u64 set_variable;
+	u64 get_next_high_mono_count;
+	u64 reset_system;
+	u64 update_capsule;
+	u64 query_capsule_caps;
+	u64 query_variable_info;
+} efi_runtime_services_64_t;
+
+typedef struct {
+	efi_table_hdr_t hdr;
 	void *get_time;
 	void *set_time;
 	void *get_wakeup_time;
@@ -485,6 +666,38 @@ struct efi_memory_map {
 
 typedef struct {
 	u32 revision;
+	u32 parent_handle;
+	u32 system_table;
+	u32 device_handle;
+	u32 file_path;
+	u32 reserved;
+	u32 load_options_size;
+	u32 load_options;
+	u32 image_base;
+	__aligned_u64 image_size;
+	unsigned int image_code_type;
+	unsigned int image_data_type;
+	unsigned long unload;
+} efi_loaded_image_32_t;
+
+typedef struct {
+	u32 revision;
+	u64 parent_handle;
+	u64 system_table;
+	u64 device_handle;
+	u64 file_path;
+	u64 reserved;
+	u32 load_options_size;
+	u64 load_options;
+	u64 image_base;
+	__aligned_u64 image_size;
+	unsigned int image_code_type;
+	unsigned int image_data_type;
+	unsigned long unload;
+} efi_loaded_image_64_t;
+
+typedef struct {
+	u32 revision;
 	void *parent_handle;
 	efi_system_table_t *system_table;
 	void *device_handle;
@@ -511,6 +724,34 @@ typedef struct {
 	efi_char16_t filename[1];
 } efi_file_info_t;
 
+typedef struct {
+	u64 revision;
+	u32 open;
+	u32 close;
+	u32 delete;
+	u32 read;
+	u32 write;
+	u32 get_position;
+	u32 set_position;
+	u32 get_info;
+	u32 set_info;
+	u32 flush;
+} efi_file_handle_32_t;
+
+typedef struct {
+	u64 revision;
+	u64 open;
+	u64 close;
+	u64 delete;
+	u64 read;
+	u64 write;
+	u64 get_position;
+	u64 set_position;
+	u64 get_info;
+	u64 set_info;
+	u64 flush;
+} efi_file_handle_64_t;
+
 typedef struct _efi_file_handle {
 	u64 revision;
 	efi_status_t (*open)(struct _efi_file_handle *,
@@ -573,6 +814,7 @@ extern struct efi {
 	efi_reset_system_t *reset_system;
 	efi_set_virtual_address_map_t *set_virtual_address_map;
 	struct efi_memory_map *memmap;
+	unsigned long flags;
 } efi;
 
 static inline int
@@ -659,18 +901,17 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_ARCH_1		6	/* First arch-specific bit */
 
 #ifdef CONFIG_EFI
-# ifdef CONFIG_X86
-extern int efi_enabled(int facility);
-# else
-static inline int efi_enabled(int facility)
+/*
+ * Test whether the above EFI_* bits are enabled.
+ */
+static inline bool efi_enabled(int feature)
 {
-	return 1;
+	return test_bit(feature, &efi.flags) != 0;
 }
-# endif
 #else
-static inline int efi_enabled(int facility)
+static inline bool efi_enabled(int feature)
 {
-	return 0;
+	return false;
 }
 #endif
 
@@ -809,6 +1050,17 @@ struct efivar_entry {
 	bool deleting;
 };
 
+struct efi_simple_text_output_protocol_32 {
+	u32 reset;
+	u32 output_string;
+	u32 test_string;
+};
+
+struct efi_simple_text_output_protocol_64 {
+	u64 reset;
+	u64 output_string;
+	u64 test_string;
+};
 
 struct efi_simple_text_output_protocol {
 	void *reset;
