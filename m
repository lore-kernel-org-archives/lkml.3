Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757410AbaCDNOp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Mar 2014 08:14:45 -0500
Received: from arkanian.console-pimps.org ([212.110.184.194]:58438 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1757355AbaCDNOi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Mar 2014 08:14:38 -0500
From: Matt Fleming <matt@console-pimps.org>
To: linux-efi@vger.kernel.org
Cc: "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>, linux-kernel@vger.kernel.org,
        Matt Fleming <matt.fleming@intel.com>
Subject: [PATCH v2 06/13] x86/efi: Build our own EFI services pointer table
Date: Tue,  4 Mar 2014 13:14:14 +0000
Message-Id: <1393938861-16797-7-git-send-email-matt@console-pimps.org>
X-Mailer: git-send-email 1.8.5.3
In-Reply-To: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Matt Fleming <matt.fleming@intel.com>

It's not possible to dereference the EFI System table directly when
booting a 64-bit kernel on a 32-bit EFI firmware because the size of
pointers don't match.

In preparation for supporting the above use case, build a list of
function pointers on boot so that callers don't have to worry about
converting pointer sizes through multiple levels of indirection.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c       | 319 ++++++++++++++++++++++++---------
 arch/x86/boot/compressed/eboot.h       |  16 ++
 arch/x86/boot/compressed/head_32.S     |  48 ++++-
 arch/x86/boot/compressed/head_64.S     |  57 ++++--
 drivers/firmware/efi/efi-stub-helper.c | 148 ++++-----------
 5 files changed, 377 insertions(+), 211 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index a7677babf946..42548168bdc3 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -19,10 +19,145 @@
 
 static efi_system_table_t *sys_table;
 
+static struct efi_config *efi_early;
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
+efi_file_size(efi_system_table_t *sys_table, void *__fh,
+	      efi_char16_t *filename_16, void **handle, u64 *file_sz)
+{
+	efi_file_handle_t *h, *fh = __fh;
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
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 info_sz, (void **)&info);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for file info\n");
+		return status;
+	}
+
+	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
+				 &info_sz, info);
+	if (status == EFI_BUFFER_TOO_SMALL) {
+		efi_early->call(efi_early->free_pool, info);
+		goto grow;
+	}
+
+	*file_sz = info->file_size;
+	efi_early->call(efi_early->free_pool, info);
+
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to get initrd info\n");
+
+	return status;
+}
+
+static inline efi_status_t
+efi_file_read(void *__fh, void *handle, unsigned long *size, void *addr)
+{
+	efi_file_handle_t *fh = __fh;
+	return efi_early->call((unsigned long)fh->read, handle, size, addr);
+}
+
+static inline efi_status_t efi_file_close(void *__fh, void *handle)
+{
+	efi_file_handle_t *fh = __fh;
 
+	return efi_early->call((unsigned long)fh->close, handle);
+}
+
+static inline efi_status_t
+efi_open_volume(efi_system_table_t *sys_table, void *__image, void **__fh)
+{
+	efi_file_io_interface_t *io;
+	efi_loaded_image_t *image = __image;
+	efi_file_handle_t *fh;
+	efi_guid_t fs_proto = EFI_FILE_SYSTEM_GUID;
+	efi_status_t status;
+	void *handle = (void *)(unsigned long)image->device_handle;
+	u32 func;
+
+	status = efi_early->call(efi_early->handle_protocol, handle,
+				 &fs_proto, (void **)&io);
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to handle fs_proto\n");
+		return status;
+	}
 
+	func = (unsigned long)io->open_volume;
+	status = efi_early->call(func, io, &fh);
+	if (status != EFI_SUCCESS)
+		efi_printk(sys_table, "Failed to open volume\n");
+
+	*__fh = fh;
+	return status;
+}
+
+static inline void
+efi_char16_printk(efi_system_table_t *table, efi_char16_t *str)
+{
+	struct efi_simple_text_output_protocol *out;
+	unsigned long output_string;
+	size_t offset;
+	unsigned long *func;
+
+	offset = offsetof(typeof(*out), output_string);
+	output_string = efi_early->text_output + offset;
+	func = (unsigned long *)output_string;
+
+	efi_early->call(*func, efi_early->text_output, str);
+}
+
+#include "../../../../drivers/firmware/efi/efi-stub-helper.c"
 
 static void find_bits(unsigned long mask, u8 *pos, u8 *size)
 {
@@ -51,7 +186,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 {
 	efi_pci_io_protocol *pci;
 	efi_status_t status;
-	void **pci_handle;
+	void **pci_handle = NULL;
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	unsigned long nr_pci, size = 0;
 	int i;
@@ -62,20 +197,21 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 	while (data && data->next)
 		data = (struct setup_data *)(unsigned long)data->next;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-				NULL, &size, pci_handle);
+	status = efi_early->call(efi_early->locate_handle,
+				 EFI_LOCATE_BY_PROTOCOL,
+				 &pci_proto, NULL, &size, pci_handle);
 
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-					EFI_LOADER_DATA, size, &pci_handle);
+		status = efi_early->call(efi_early->allocate_pool,
+					 EFI_LOADER_DATA,
+					 size, (void **)&pci_handle);
 
 		if (status != EFI_SUCCESS)
 			return status;
 
-		status = efi_call_phys5(sys_table->boottime->locate_handle,
-					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-					NULL, &size, pci_handle);
+		status = efi_early->call(efi_early->locate_handle,
+					 EFI_LOCATE_BY_PROTOCOL, &pci_proto,
+					 NULL, &size, pci_handle);
 	}
 
 	if (status != EFI_SUCCESS)
@@ -87,8 +223,8 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		uint64_t attributes;
 		struct pci_setup_rom *rom;
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, &pci_proto, &pci);
+		status = efi_early->call(efi_early->handle_protocol, h,
+					 &pci_proto, (void **)&pci);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -97,13 +233,13 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 			continue;
 
 #ifdef CONFIG_X86_64
-		status = efi_call_phys4(pci->attributes, pci,
-					EfiPciIoAttributeOperationGet, 0,
-					&attributes);
+		status = efi_early->call((unsigned long)pci->attributes, pci,
+					 EfiPciIoAttributeOperationGet, 0,
+					 &attributes);
 #else
-		status = efi_call_phys5(pci->attributes, pci,
-					EfiPciIoAttributeOperationGet, 0, 0,
-					&attributes);
+		status = efi_early->call((unsigned long)pci->attributes, pci,
+					 EfiPciIoAttributeOperationGet, 0, 0,
+					 &attributes);
 #endif
 		if (status != EFI_SUCCESS)
 			continue;
@@ -113,8 +249,8 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 
 		size = pci->romsize + sizeof(*rom);
 
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &rom);
+		status = efi_early->call(efi_early->allocate_pool,
+					 EFI_LOADER_DATA, size, &rom);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -124,23 +260,23 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		rom->data.next = 0;
 		rom->pcilen = pci->romsize;
 
-		status = efi_call_phys5(pci->pci.read, pci,
-					EfiPciIoWidthUint16, PCI_VENDOR_ID,
-					1, &(rom->vendor));
+		status = efi_early->call((unsigned long)pci->pci.read, pci,
+					 EfiPciIoWidthUint16, PCI_VENDOR_ID,
+					 1, &(rom->vendor));
 
 		if (status != EFI_SUCCESS)
 			goto free_struct;
 
-		status = efi_call_phys5(pci->pci.read, pci,
-					EfiPciIoWidthUint16, PCI_DEVICE_ID,
-					1, &(rom->devid));
+		status = efi_early->call((unsigned long)pci->pci.read, pci,
+					 EfiPciIoWidthUint16, PCI_DEVICE_ID,
+					 1, &(rom->devid));
 
 		if (status != EFI_SUCCESS)
 			goto free_struct;
 
-		status = efi_call_phys5(pci->get_location, pci,
-					&(rom->segment), &(rom->bus),
-					&(rom->device), &(rom->function));
+		status = efi_early->call((unsigned long)pci->get_location, pci,
+					 &(rom->segment), &(rom->bus),
+					 &(rom->device), &(rom->function));
 
 		if (status != EFI_SUCCESS)
 			goto free_struct;
@@ -156,11 +292,11 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 
 		continue;
 	free_struct:
-		efi_call_phys1(sys_table->boottime->free_pool, rom);
+		efi_early->call(efi_early->free_pool, rom);
 	}
 
 free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, pci_handle);
+	efi_early->call(efi_early->free_pool, pci_handle);
 	return status;
 }
 
@@ -174,21 +310,21 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	struct efi_pixel_bitmask pixel_info;
 	unsigned long nr_gops;
 	efi_status_t status;
-	void **gop_handle;
+	void **gop_handle = NULL;
 	u16 width, height;
 	u32 fb_base, fb_size;
 	u32 pixels_per_scan_line;
 	int pixel_format;
 	int i;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &gop_handle);
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 size, (void **)&gop_handle);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, proto,
-				NULL, &size, gop_handle);
+	status = efi_early->call(efi_early->locate_handle,
+				 EFI_LOCATE_BY_PROTOCOL,
+				 proto, NULL, &size, gop_handle);
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
@@ -202,19 +338,18 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		void *dummy;
 		void *h = gop_handle[i];
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, proto, &gop);
+		status = efi_early->call(efi_early->handle_protocol, h,
+					 proto, (void **)&gop);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					h, &conout_proto, &dummy);
-
+		status = efi_early->call(efi_early->handle_protocol, h,
+					 &conout_proto, &dummy);
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
-		status = efi_call_phys4(gop->query_mode, gop,
-					gop->mode->mode, &size, &info);
+		status = efi_early->call((unsigned long)gop->query_mode, gop,
+					 gop->mode->mode, &size, &info);
 		if (status == EFI_SUCCESS && (!first_gop || conout_found)) {
 			/*
 			 * Systems that use the UEFI Console Splitter may
@@ -303,7 +438,7 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	si->capabilities |= VIDEO_CAPABILITY_SKIP_QUIRKS;
 
 free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, gop_handle);
+	efi_early->call(efi_early->free_pool, gop_handle);
 	return status;
 }
 
@@ -320,14 +455,14 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 	void **uga_handle = NULL;
 	int i;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, &uga_handle);
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 size, (void **)&uga_handle);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, uga_proto,
-				NULL, &size, uga_handle);
+	status = efi_early->call(efi_early->locate_handle,
+				 EFI_LOCATE_BY_PROTOCOL,
+				 uga_proto, NULL, &size, uga_handle);
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
@@ -340,16 +475,16 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 		u32 w, h, depth, refresh;
 		void *pciio;
 
-		status = efi_call_phys3(sys_table->boottime->handle_protocol,
-					handle, uga_proto, &uga);
+		status = efi_early->call(efi_early->handle_protocol, handle,
+					 uga_proto, (void **)&uga);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_call_phys3(sys_table->boottime->handle_protocol,
-			       handle, &pciio_proto, &pciio);
+		efi_early->call(efi_early->handle_protocol, handle,
+				&pciio_proto, &pciio);
 
-		status = efi_call_phys5(uga->get_mode, uga, &w, &h,
-					&depth, &refresh);
+		status = efi_early->call((unsigned long)uga->get_mode, uga,
+					 &w, &h, &depth, &refresh);
 		if (status == EFI_SUCCESS && (!first_uga || pciio)) {
 			width = w;
 			height = h;
@@ -386,7 +521,7 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 
 
 free_handle:
-	efi_call_phys1(sys_table->boottime->free_pool, uga_handle);
+	efi_early->call(efi_early->free_pool, uga_handle);
 	return status;
 }
 
@@ -404,29 +539,28 @@ void setup_graphics(struct boot_params *boot_params)
 	memset(si, 0, sizeof(*si));
 
 	size = 0;
-	status = efi_call_phys5(sys_table->boottime->locate_handle,
-				EFI_LOCATE_BY_PROTOCOL, &graphics_proto,
-				NULL, &size, gop_handle);
+	status = efi_early->call(efi_early->locate_handle,
+				 EFI_LOCATE_BY_PROTOCOL,
+				 &graphics_proto, NULL, &size, gop_handle);
 	if (status == EFI_BUFFER_TOO_SMALL)
 		status = setup_gop(si, &graphics_proto, size);
 
 	if (status != EFI_SUCCESS) {
 		size = 0;
-		status = efi_call_phys5(sys_table->boottime->locate_handle,
-					EFI_LOCATE_BY_PROTOCOL, &uga_proto,
-					NULL, &size, uga_handle);
+		status = efi_early->call(efi_early->locate_handle,
+					 EFI_LOCATE_BY_PROTOCOL,
+					 &uga_proto, NULL, &size, uga_handle);
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
@@ -434,7 +568,7 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	struct setup_header *hdr;
 	struct efi_info *efi;
 	efi_loaded_image_t *image;
-	void *options;
+	void *options, *handle;
 	efi_guid_t proto = LOADED_IMAGE_PROTOCOL_GUID;
 	int options_size = 0;
 	efi_status_t status;
@@ -445,14 +579,21 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
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
+	status = efi_early->call(efi_early->handle_protocol, handle,
+				 &proto, (void *)&image);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
@@ -641,14 +782,13 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 		sizeof(struct e820entry) * nr_desc;
 
 	if (*e820ext) {
-		efi_call_phys1(sys_table->boottime->free_pool, *e820ext);
+		efi_early->call(efi_early->free_pool, *e820ext);
 		*e820ext = NULL;
 		*e820ext_size = 0;
 	}
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
-				EFI_LOADER_DATA, size, e820ext);
-
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 size, (void **)e820ext);
 	if (status == EFI_SUCCESS)
 		*e820ext_size = size;
 
@@ -691,7 +831,7 @@ get_map:
 		if (status != EFI_SUCCESS)
 			goto free_mem_map;
 
-		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		efi_early->call(efi_early->free_pool, mem_map);
 		goto get_map; /* Allocated memory, get map again */
 	}
 
@@ -708,8 +848,7 @@ get_map:
 #endif
 
 	/* Might as well exit boot services now */
-	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
-				handle, key);
+	status = efi_early->call(efi_early->exit_boot_services, handle, key);
 	if (status != EFI_SUCCESS) {
 		/*
 		 * ExitBootServices() will fail if any of the event
@@ -722,7 +861,7 @@ get_map:
 			goto free_mem_map;
 
 		called_exit = true;
-		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		efi_early->call(efi_early->free_pool, mem_map);
 		goto get_map;
 	}
 
@@ -736,23 +875,31 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+	efi_early->call(efi_early->free_pool, mem_map);
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
 
@@ -760,13 +907,17 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
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
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 sizeof(*gdt), (void **)&gdt);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt structure\n");
 		goto fail;
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
diff --git a/arch/x86/boot/compressed/head_32.S b/arch/x86/boot/compressed/head_32.S
index 9116aac232c7..eed23c087d6c 100644
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
 
 ENTRY(efi_stub_entry)
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
@@ -202,6 +229,13 @@ relocated:
 	xorl	%ebx, %ebx
 	jmp	*%eax
 
+	.data
+efi32_config:
+	.fill 11,8,0
+	.long efi_call_phys
+	.long 0
+	.byte 0
+
 /*
  * Stack and heap for uncompression
  */
diff --git a/arch/x86/boot/compressed/head_64.S b/arch/x86/boot/compressed/head_64.S
index c5c1ae0997e7..1bc206fa4bd0 100644
--- a/arch/x86/boot/compressed/head_64.S
+++ b/arch/x86/boot/compressed/head_64.S
@@ -209,26 +209,55 @@ ENTRY(startup_64)
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
 
 ENTRY(efi_stub_entry)
+	movq	%rdi, efi64_config(%rip)	/* Handle */
+	movq	%rsi, efi64_config+8(%rip) /* EFI System table pointer */
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
+	movq	efi_config(%rip), %rax
+	addq	%rbp, 88(%rax)
+	movq	%rdx, %rsi
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
@@ -372,6 +401,14 @@ gdt:
 	.quad   0x0000000000000000	/* TS continued */
 gdt_end:
 
+efi_config:
+	.quad	0
+
+	.global efi64_config
+efi64_config:
+	.fill	11,8,0
+	.quad	efi_call6
+	.byte	1
 /*
  * Stack and heap for uncompression
  */
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index b6bffbfd3be7..a0282872d97d 100644
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
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 *map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	status = efi_call_phys5(sys_table_arg->boottime->get_memory_map,
-				map_size, m, &key, desc_size, &desc_version);
+	*desc_size = 0;
+	key = 0;
+	status = efi_early->call(efi_early->get_memory_map, map_size, m,
+				 &key, desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+		efi_early->call(efi_early->free_pool, m);
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
-		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+		efi_early->call(efi_early->free_pool, m);
+
 	if (key_ptr && status == EFI_SUCCESS)
 		*key_ptr = key;
 	if (desc_ver && status == EFI_SUCCESS)
@@ -158,9 +149,9 @@ again:
 	if (!max_addr)
 		status = EFI_NOT_FOUND;
 	else {
-		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
-					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					nr_pages, &max_addr);
+		status = efi_early->call(efi_early->allocate_pages,
+					 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+					 nr_pages, &max_addr);
 		if (status != EFI_SUCCESS) {
 			max = max_addr;
 			max_addr = 0;
@@ -170,8 +161,7 @@ again:
 		*addr = max_addr;
 	}
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
-
+	efi_early->call(efi_early->free_pool, map);
 fail:
 	return status;
 }
@@ -231,9 +221,9 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		if ((start + size) > end)
 			continue;
 
-		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
-					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					nr_pages, &start);
+		status = efi_early->call(efi_early->allocate_pages,
+					 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+					 nr_pages, &start);
 		if (status == EFI_SUCCESS) {
 			*addr = start;
 			break;
@@ -243,7 +233,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
+	efi_early->call(efi_early->free_pool, map);
 fail:
 	return status;
 }
@@ -257,7 +247,7 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 		return;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
+	efi_early->call(efi_early->free_pages, addr, nr_pages);
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
+	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
+				 nr_files * sizeof(*files), (void **)&files);
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
+	efi_early->call(efi_early->free_pool, files);
 
 	*load_addr = file_addr;
 	*load_size = file_size_total;
@@ -497,9 +425,9 @@ free_file_total:
 
 close_handles:
 	for (k = j; k < i; k++)
-		efi_call_phys1(fh->close, files[k].handle);
+		efi_file_close(fh, files[k].handle);
 free_files:
-	efi_call_phys1(sys_table_arg->boottime->free_pool, files);
+	efi_early->call(efi_early->free_pool, files);
 fail:
 	*load_addr = 0;
 	*load_size = 0;
@@ -545,9 +473,9 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * as possible while respecting the required alignment.
 	 */
 	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
-				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				nr_pages, &efi_addr);
+	status = efi_early->call(efi_early->allocate_pages,
+				 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				 nr_pages, &efi_addr);
 	new_addr = efi_addr;
 	/*
 	 * If preferred address allocation failed allocate as low as
-- 
1.8.5.3

