Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753633AbaCZJKX (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Mar 2014 05:10:23 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:43089 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750911AbaCZJKS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Mar 2014 05:10:18 -0400
Date: Wed, 26 Mar 2014 09:10:11 +0000
From: Matt Fleming <matt@console-pimps.org>
To: Roy Franz <roy.franz@linaro.org>
Cc: "linux-efi@vger.kernel.org" <linux-efi@vger.kernel.org>,
        "H. Peter Anvin" <hpa@zytor.com>, Borislav Petkov <bp@alien8.de>,
        Alan Cox <alan@lxorguk.ukuu.org.uk>,
        Matthew Garrett <mjg59@srcf.ucam.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Matt Fleming <matt.fleming@intel.com>,
        Leif Lindholm <leif.lindholm@linaro.org>,
        Ingo Molnar <mingo@kernel.org>
Subject: Re: [PATCH v2 06/13] x86/efi: Build our own EFI services pointer
 table
Message-ID: <20140326091011.GB2958@console-pimps.org>
References: <1393938861-16797-1-git-send-email-matt@console-pimps.org>
 <1393938861-16797-7-git-send-email-matt@console-pimps.org>
 <CAFECyb8QKy-r_2a7Dy8j9Nv=8pGUKJbnOzLoJhd6shvf0PmBCg@mail.gmail.com>
 <20140322110515.GF2815@console-pimps.org>
 <CAFECyb8VnNzwUEOY-jkO60_9yKw_sbp_K5UQZU5EECcNjAs+sg@mail.gmail.com>
 <CAFECyb-+uBtmPQZzsJBugROo-AjAwXEvX48-1pPKwiSJwfWGUg@mail.gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <CAFECyb-+uBtmPQZzsJBugROo-AjAwXEvX48-1pPKwiSJwfWGUg@mail.gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Tue, 25 Mar, at 03:47:23PM, Roy Franz wrote:
> 
> I have sent a patch (attempted to reply using git-send-email) that
> adds the macro for x86 and updates efi-stub-helper.c.  If you could
> add this to your series for 3.15 that would be great, as then we would
> not have any x86 changes in the ARM EFI stub series.

Normally my response would be "nope" because the time for getting stuff
into tip for the upcoming merge window has come and gone.

However, in this particular case I think we may be OK because it's
simple macro munging, and we can prove by looking at the generated
object code before and after that there's zero changes (which I did).

So it really comes down to what Peter and Ingo are comfortable with.

Peter, Ingo, I've attached the patch. Do you think this is something
that we could get in for the merge window, possibly the end so it gets
some time to bake in linux-next? It would help the ARM folks out for the
next cycle because it's one less dependency they need to track.

----- >8 -----

>From 0a64e62d455e7ff498d10d359b9cf2d136a7e1d7 Mon Sep 17 00:00:00 2001
From: Matt Fleming <matt.fleming@intel.com>
Date: Sat, 22 Mar 2014 10:09:01 +0000
Subject: [PATCH] efi: Abstract x86 efi_early calls

The ARM EFI boot stub doesn't need to care about the efi_early
infrastructure that x86 requires in order to do mixed mode thunking. So
wrap everything up in an efi_call_early() macro.

This allows x86 to do the necessary indirection jumps to call whatever
firmware interface is necessary (native or mixed mode), but also allows
the ARM folks to mask the fact that they don't support relocation in the
boot stub and need to pass 'sys_table_arg' to every function.

Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c       | 155 ++++++++++++++++-----------------
 drivers/firmware/efi/efi-stub-helper.c |  44 +++++-----
 2 files changed, 98 insertions(+), 101 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index 5e1ba4fa3f79..1e6146137f8e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -21,6 +21,9 @@ static efi_system_table_t *sys_table;
 
 static struct efi_config *efi_early;
 
+#define efi_call_early(f, ...)						\
+	efi_early->call(efi_early->f, __VA_ARGS__);
+
 #define BOOT_SERVICES(bits)						\
 static void setup_boot_services##bits(struct efi_config *c)		\
 {									\
@@ -78,8 +81,8 @@ __file_size32(void *__fh, efi_char16_t *filename_16,
 	}
 
 grow:
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 info_sz, (void **)&info);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				info_sz, (void **)&info);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for file info\n");
 		return status;
@@ -88,12 +91,12 @@ grow:
 	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
 				 &info_sz, info);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_early->call(efi_early->free_pool, info);
+		efi_call_early(free_pool, info);
 		goto grow;
 	}
 
 	*file_sz = info->file_size;
-	efi_early->call(efi_early->free_pool, info);
+	efi_call_early(free_pool, info);
 
 	if (status != EFI_SUCCESS)
 		efi_printk(sys_table, "Failed to get initrd info\n");
@@ -131,8 +134,8 @@ __file_size64(void *__fh, efi_char16_t *filename_16,
 	}
 
 grow:
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 info_sz, (void **)&info);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				info_sz, (void **)&info);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for file info\n");
 		return status;
@@ -141,12 +144,12 @@ grow:
 	status = efi_early->call((unsigned long)h->get_info, h, &info_guid,
 				 &info_sz, info);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_early->call(efi_early->free_pool, info);
+		efi_call_early(free_pool, info);
 		goto grow;
 	}
 
 	*file_sz = info->file_size;
-	efi_early->call(efi_early->free_pool, info);
+	efi_call_early(free_pool, info);
 
 	if (status != EFI_SUCCESS)
 		efi_printk(sys_table, "Failed to get initrd info\n");
@@ -204,8 +207,8 @@ static inline efi_status_t __open_volume32(void *__image, void **__fh)
 	void *handle = (void *)(unsigned long)image->device_handle;
 	unsigned long func;
 
-	status = efi_early->call(efi_early->handle_protocol, handle,
-				 &fs_proto, (void **)&io);
+	status = efi_call_early(handle_protocol, handle,
+				&fs_proto, (void **)&io);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to handle fs_proto\n");
 		return status;
@@ -230,8 +233,8 @@ static inline efi_status_t __open_volume64(void *__image, void **__fh)
 	void *handle = (void *)(unsigned long)image->device_handle;
 	unsigned long func;
 
-	status = efi_early->call(efi_early->handle_protocol, handle,
-				 &fs_proto, (void **)&io);
+	status = efi_call_early(handle_protocol, handle,
+				&fs_proto, (void **)&io);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to handle fs_proto\n");
 		return status;
@@ -325,9 +328,7 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 
 	size = pci->romsize + sizeof(*rom);
 
-	status = efi_early->call(efi_early->allocate_pool,
-				 EFI_LOADER_DATA, size, &rom);
-
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -361,7 +362,7 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 	return status;
 
 free_struct:
-	efi_early->call(efi_early->free_pool, rom);
+	efi_call_early(free_pool, rom);
 	return status;
 }
 
@@ -387,8 +388,8 @@ setup_efi_pci32(struct boot_params *params, void **pci_handle,
 		struct pci_setup_rom *rom = NULL;
 		u32 h = handles[i];
 
-		status = efi_early->call(efi_early->handle_protocol, h,
-					 &pci_proto, (void **)&pci);
+		status = efi_call_early(handle_protocol, h,
+					&pci_proto, (void **)&pci);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -431,9 +432,7 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
 
 	size = pci->romsize + sizeof(*rom);
 
-	status = efi_early->call(efi_early->allocate_pool,
-				 EFI_LOADER_DATA, size, &rom);
-
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -465,7 +464,7 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
 	return status;
 
 free_struct:
-	efi_early->call(efi_early->free_pool, rom);
+	efi_call_early(free_pool, rom);
 	return status;
 
 }
@@ -492,8 +491,8 @@ setup_efi_pci64(struct boot_params *params, void **pci_handle,
 		struct pci_setup_rom *rom = NULL;
 		u64 h = handles[i];
 
-		status = efi_early->call(efi_early->handle_protocol, h,
-					 &pci_proto, (void **)&pci);
+		status = efi_call_early(handle_protocol, h,
+					&pci_proto, (void **)&pci);
 
 		if (status != EFI_SUCCESS)
 			continue;
@@ -524,21 +523,21 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 	efi_guid_t pci_proto = EFI_PCI_IO_PROTOCOL_GUID;
 	unsigned long size = 0;
 
-	status = efi_early->call(efi_early->locate_handle,
-				 EFI_LOCATE_BY_PROTOCOL,
-				 &pci_proto, NULL, &size, pci_handle);
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				&pci_proto, NULL, &size, pci_handle);
 
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		status = efi_early->call(efi_early->allocate_pool,
-					 EFI_LOADER_DATA,
-					 size, (void **)&pci_handle);
+		status = efi_call_early(allocate_pool,
+					EFI_LOADER_DATA,
+					size, (void **)&pci_handle);
 
 		if (status != EFI_SUCCESS)
 			return status;
 
-		status = efi_early->call(efi_early->locate_handle,
-					 EFI_LOCATE_BY_PROTOCOL, &pci_proto,
-					 NULL, &size, pci_handle);
+		status = efi_call_early(locate_handle,
+					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
+					NULL, &size, pci_handle);
 	}
 
 	if (status != EFI_SUCCESS)
@@ -550,7 +549,7 @@ static efi_status_t setup_efi_pci(struct boot_params *params)
 		status = setup_efi_pci32(params, pci_handle, size);
 
 free_handle:
-	efi_early->call(efi_early->free_pool, pci_handle);
+	efi_call_early(free_pool, pci_handle);
 	return status;
 }
 
@@ -651,13 +650,13 @@ setup_gop32(struct screen_info *si, efi_guid_t *proto,
 		void *dummy = NULL;
 		u32 h = handles[i];
 
-		status = efi_early->call(efi_early->handle_protocol, h,
-					 proto, (void **)&gop32);
+		status = efi_call_early(handle_protocol, h,
+					proto, (void **)&gop32);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		status = efi_early->call(efi_early->handle_protocol, h,
-					 &conout_proto, &dummy);
+		status = efi_call_early(handle_protocol, h,
+					&conout_proto, &dummy);
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
@@ -754,13 +753,13 @@ setup_gop64(struct screen_info *si, efi_guid_t *proto,
 		void *dummy = NULL;
 		u64 h = handles[i];
 
-		status = efi_early->call(efi_early->handle_protocol, h,
-					 proto, (void **)&gop64);
+		status = efi_call_early(handle_protocol, h,
+					proto, (void **)&gop64);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		status = efi_early->call(efi_early->handle_protocol, h,
-					 &conout_proto, &dummy);
+		status = efi_call_early(handle_protocol, h,
+					&conout_proto, &dummy);
 		if (status == EFI_SUCCESS)
 			conout_found = true;
 
@@ -819,14 +818,14 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 	efi_status_t status;
 	void **gop_handle = NULL;
 
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 size, (void **)&gop_handle);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)&gop_handle);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_early->call(efi_early->locate_handle,
-				 EFI_LOCATE_BY_PROTOCOL,
-				 proto, NULL, &size, gop_handle);
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				proto, NULL, &size, gop_handle);
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
@@ -836,7 +835,7 @@ static efi_status_t setup_gop(struct screen_info *si, efi_guid_t *proto,
 		status = setup_gop32(si, proto, size, gop_handle);
 
 free_handle:
-	efi_early->call(efi_early->free_pool, gop_handle);
+	efi_call_early(free_pool, gop_handle);
 	return status;
 }
 
@@ -858,13 +857,12 @@ setup_uga32(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 		void *pciio;
 		u32 handle = handles[i];
 
-		status = efi_early->call(efi_early->handle_protocol, handle,
-					 &uga_proto, (void **)&uga);
+		status = efi_call_early(handle_protocol, handle,
+					&uga_proto, (void **)&uga);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_early->call(efi_early->handle_protocol, handle,
-				&pciio_proto, &pciio);
+		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
 
 		status = efi_early->call((unsigned long)uga->get_mode, uga,
 					 &w, &h, &depth, &refresh);
@@ -904,13 +902,12 @@ setup_uga64(void **uga_handle, unsigned long size, u32 *width, u32 *height)
 		void *pciio;
 		u64 handle = handles[i];
 
-		status = efi_early->call(efi_early->handle_protocol, handle,
-					 &uga_proto, (void **)&uga);
+		status = efi_call_early(handle_protocol, handle,
+					&uga_proto, (void **)&uga);
 		if (status != EFI_SUCCESS)
 			continue;
 
-		efi_early->call(efi_early->handle_protocol, handle,
-				&pciio_proto, &pciio);
+		efi_call_early(handle_protocol, handle, &pciio_proto, &pciio);
 
 		status = efi_early->call((unsigned long)uga->get_mode, uga,
 					 &w, &h, &depth, &refresh);
@@ -942,14 +939,14 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 	u32 width, height;
 	void **uga_handle = NULL;
 
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 size, (void **)&uga_handle);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)&uga_handle);
 	if (status != EFI_SUCCESS)
 		return status;
 
-	status = efi_early->call(efi_early->locate_handle,
-				 EFI_LOCATE_BY_PROTOCOL,
-				 uga_proto, NULL, &size, uga_handle);
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				uga_proto, NULL, &size, uga_handle);
 	if (status != EFI_SUCCESS)
 		goto free_handle;
 
@@ -981,7 +978,7 @@ static efi_status_t setup_uga(struct screen_info *si, efi_guid_t *uga_proto,
 	si->rsvd_pos = 24;
 
 free_handle:
-	efi_early->call(efi_early->free_pool, uga_handle);
+	efi_call_early(free_pool, uga_handle);
 	return status;
 }
 
@@ -999,17 +996,17 @@ void setup_graphics(struct boot_params *boot_params)
 	memset(si, 0, sizeof(*si));
 
 	size = 0;
-	status = efi_early->call(efi_early->locate_handle,
-				 EFI_LOCATE_BY_PROTOCOL,
-				 &graphics_proto, NULL, &size, gop_handle);
+	status = efi_call_early(locate_handle,
+				EFI_LOCATE_BY_PROTOCOL,
+				&graphics_proto, NULL, &size, gop_handle);
 	if (status == EFI_BUFFER_TOO_SMALL)
 		status = setup_gop(si, &graphics_proto, size);
 
 	if (status != EFI_SUCCESS) {
 		size = 0;
-		status = efi_early->call(efi_early->locate_handle,
-					 EFI_LOCATE_BY_PROTOCOL,
-					 &uga_proto, NULL, &size, uga_handle);
+		status = efi_call_early(locate_handle,
+					EFI_LOCATE_BY_PROTOCOL,
+					&uga_proto, NULL, &size, uga_handle);
 		if (status == EFI_BUFFER_TOO_SMALL)
 			setup_uga(si, &uga_proto, size);
 	}
@@ -1052,8 +1049,8 @@ struct boot_params *make_boot_params(struct efi_config *c)
 	else
 		setup_boot_services32(efi_early);
 
-	status = efi_early->call(efi_early->handle_protocol, handle,
-				 &proto, (void *)&image);
+	status = efi_call_early(handle_protocol, handle,
+				&proto, (void *)&image);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
@@ -1242,13 +1239,13 @@ static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
 		sizeof(struct e820entry) * nr_desc;
 
 	if (*e820ext) {
-		efi_early->call(efi_early->free_pool, *e820ext);
+		efi_call_early(free_pool, *e820ext);
 		*e820ext = NULL;
 		*e820ext_size = 0;
 	}
 
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 size, (void **)e820ext);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				size, (void **)e820ext);
 	if (status == EFI_SUCCESS)
 		*e820ext_size = size;
 
@@ -1292,7 +1289,7 @@ get_map:
 		if (status != EFI_SUCCESS)
 			goto free_mem_map;
 
-		efi_early->call(efi_early->free_pool, mem_map);
+		efi_call_early(free_pool, mem_map);
 		goto get_map; /* Allocated memory, get map again */
 	}
 
@@ -1311,7 +1308,7 @@ get_map:
 #endif
 
 	/* Might as well exit boot services now */
-	status = efi_early->call(efi_early->exit_boot_services, handle, key);
+	status = efi_call_early(exit_boot_services, handle, key);
 	if (status != EFI_SUCCESS) {
 		/*
 		 * ExitBootServices() will fail if any of the event
@@ -1324,7 +1321,7 @@ get_map:
 			goto free_mem_map;
 
 		called_exit = true;
-		efi_early->call(efi_early->free_pool, mem_map);
+		efi_call_early(free_pool, mem_map);
 		goto get_map;
 	}
 
@@ -1338,7 +1335,7 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	efi_early->call(efi_early->free_pool, mem_map);
+	efi_call_early(free_pool, mem_map);
 	return status;
 }
 
@@ -1379,8 +1376,8 @@ struct boot_params *efi_main(struct efi_config *c,
 
 	setup_efi_pci(boot_params);
 
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 sizeof(*gdt), (void **)&gdt);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				sizeof(*gdt), (void **)&gdt);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table, "Failed to alloc mem for gdt structure\n");
 		goto fail;
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index a0282872d97d..ff50aeebf0d9 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -53,22 +53,22 @@ again:
 	 * allocation which may be in a new descriptor region.
 	 */
 	*map_size += sizeof(*m);
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 *map_size, (void **)&m);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				*map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
 	*desc_size = 0;
 	key = 0;
-	status = efi_early->call(efi_early->get_memory_map, map_size, m,
-				 &key, desc_size, &desc_version);
+	status = efi_call_early(get_memory_map, map_size, m,
+				&key, desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_early->call(efi_early->free_pool, m);
+		efi_call_early(free_pool, m);
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
-		efi_early->call(efi_early->free_pool, m);
+		efi_call_early(free_pool, m);
 
 	if (key_ptr && status == EFI_SUCCESS)
 		*key_ptr = key;
@@ -149,9 +149,9 @@ again:
 	if (!max_addr)
 		status = EFI_NOT_FOUND;
 	else {
-		status = efi_early->call(efi_early->allocate_pages,
-					 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					 nr_pages, &max_addr);
+		status = efi_call_early(allocate_pages,
+					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+					nr_pages, &max_addr);
 		if (status != EFI_SUCCESS) {
 			max = max_addr;
 			max_addr = 0;
@@ -161,7 +161,7 @@ again:
 		*addr = max_addr;
 	}
 
-	efi_early->call(efi_early->free_pool, map);
+	efi_call_early(free_pool, map);
 fail:
 	return status;
 }
@@ -221,9 +221,9 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 		if ((start + size) > end)
 			continue;
 
-		status = efi_early->call(efi_early->allocate_pages,
-					 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-					 nr_pages, &start);
+		status = efi_call_early(allocate_pages,
+					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+					nr_pages, &start);
 		if (status == EFI_SUCCESS) {
 			*addr = start;
 			break;
@@ -233,7 +233,7 @@ static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-	efi_early->call(efi_early->free_pool, map);
+	efi_call_early(free_pool, map);
 fail:
 	return status;
 }
@@ -247,7 +247,7 @@ static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 		return;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_early->call(efi_early->free_pages, addr, nr_pages);
+	efi_call_early(free_pages, addr, nr_pages);
 }
 
 
@@ -307,8 +307,8 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 	if (!nr_files)
 		return EFI_SUCCESS;
 
-	status = efi_early->call(efi_early->allocate_pool, EFI_LOADER_DATA,
-				 nr_files * sizeof(*files), (void **)&files);
+	status = efi_call_early(allocate_pool, EFI_LOADER_DATA,
+				nr_files * sizeof(*files), (void **)&files);
 	if (status != EFI_SUCCESS) {
 		efi_printk(sys_table_arg, "Failed to alloc mem for file handle list\n");
 		goto fail;
@@ -413,7 +413,7 @@ static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 
 	}
 
-	efi_early->call(efi_early->free_pool, files);
+	efi_call_early(free_pool, files);
 
 	*load_addr = file_addr;
 	*load_size = file_size_total;
@@ -427,7 +427,7 @@ close_handles:
 	for (k = j; k < i; k++)
 		efi_file_close(fh, files[k].handle);
 free_files:
-	efi_early->call(efi_early->free_pool, files);
+	efi_call_early(free_pool, files);
 fail:
 	*load_addr = 0;
 	*load_size = 0;
@@ -473,9 +473,9 @@ static efi_status_t efi_relocate_kernel(efi_system_table_t *sys_table_arg,
 	 * as possible while respecting the required alignment.
 	 */
 	nr_pages = round_up(alloc_size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	status = efi_early->call(efi_early->allocate_pages,
-				 EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
-				 nr_pages, &efi_addr);
+	status = efi_call_early(allocate_pages,
+				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
+				nr_pages, &efi_addr);
 	new_addr = efi_addr;
 	/*
 	 * If preferred address allocation failed allocate as low as
-- 
1.8.5.3

-- 
Matt Fleming, Intel Open Source Technology Center
