Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754393Ab3HBVao (ORCPT <rfc822;w@1wt.eu>);
	Fri, 2 Aug 2013 17:30:44 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:64969 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754090Ab3HBV3U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 2 Aug 2013 17:29:20 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 3/7] Change EFI helper APIs to be more flexible
Date: Fri,  2 Aug 2013 14:29:04 -0700
Message-Id: <1375478948-22562-4-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
References: <1375478948-22562-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

* Change the EFI helper functions to be more flexible to allow their use
by other architectures.
* Pass system table pointer as argument to all functions that use it,
rather than use a global variable.
* Change name of __get_map to efi_get_memory_map, and add key pointer argument
so it can be used to get final memory map before the EFI exitBootServices()
function is called.
* Change the handle_ramdisks() to handle_cmdline_files(), and make it more
generic by taking string to match rather than hardcoding 'initrd='
so it can be used to load device tree files as well.
* Add 'min' address parameter to limit low_alloc() alloctions
* Fix type of chunksize to match EFI function (not checked in x86 code
as wrappers break type checking.)
* rename alloc/free functions - low_free() is usable by both low_alloc()
and high_alloc(), so rename them to be more consistent - efi_low_alloc()
efi_high_alloc(), and efi_free()
* Enforce minimum pagesize alignment as expected by EFI allocate_pages().
* check for 0 size in efi_free.


Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |   46 ++++----
 drivers/firmware/efi/efi-stub-helper.c |  181 ++++++++++++++++++++------------
 2 files changed, 140 insertions(+), 87 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ab0eefc..d15cf47 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -443,6 +443,8 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	u16 *s2;
 	u8 *s1;
 	int i;
+	u64 ramdisk_addr;
+	u64 ramdisk_size;
 
 	sys_table = _table;
 
@@ -453,13 +455,14 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	status = efi_call_phys3(sys_table->boottime->handle_protocol,
 				handle, &proto, (void *)&image);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
+		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
 	}
 
-	status = low_alloc(0x4000, 1, (unsigned long *)&boot_params);
+	status = efi_low_alloc(sys_table, 0x4000, 1,
+			   (unsigned long *)&boot_params, 0);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc lowmem for boot params\n");
+		efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
 		return NULL;
 	}
 
@@ -503,9 +506,10 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 			options_size++;	/* NUL termination */
 
-			status = low_alloc(options_size, 1, &cmdline);
+			status = efi_low_alloc(sys_table, options_size, 1,
+					   &cmdline, 0);
 			if (status != EFI_SUCCESS) {
-				efi_printk("Failed to alloc mem for cmdline\n");
+				efi_printk(sys_table, "Failed to alloc mem for cmdline\n");
 				goto fail;
 			}
 
@@ -529,16 +533,21 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 	memset(sdt, 0, sizeof(*sdt));
 
-	status = handle_ramdisks(image, hdr);
+	status = handle_cmdline_files(sys_table, image,
+				      (char *)(unsigned long)hdr->cmd_line_ptr,
+				      "initrd=", hdr->initrd_addr_max,
+				      &ramdisk_addr, &ramdisk_size);
 	if (status != EFI_SUCCESS)
 		goto fail2;
+	hdr->ramdisk_image = ramdisk_addr;
+	hdr->ramdisk_size = ramdisk_size;
 
 	return boot_params;
 fail2:
 	if (options_size)
-		low_free(options_size, hdr->cmd_line_ptr);
+		efi_free(sys_table, options_size, hdr->cmd_line_ptr);
 fail:
-	low_free(0x4000, (unsigned long)boot_params);
+	efi_free(sys_table, 0x4000, (unsigned long)boot_params);
 	return NULL;
 }
 
@@ -561,7 +570,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 again:
 	size += sizeof(*mem_map) * 2;
 	_size = size;
-	status = low_alloc(size, 1, (unsigned long *)&mem_map);
+	status = efi_low_alloc(sys_table, size, 1, (unsigned long *)&mem_map, 0);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -569,7 +578,7 @@ get_map:
 	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
 				mem_map, &key, &desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		low_free(_size, (unsigned long)mem_map);
+		efi_free(sys_table, _size, (unsigned long)mem_map);
 		goto again;
 	}
 
@@ -671,7 +680,7 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	low_free(_size, (unsigned long)mem_map);
+	efi_free(sys_table, _size, (unsigned long)mem_map);
 	return status;
 }
 
@@ -694,10 +703,10 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 				nr_pages, &start);
 	if (status != EFI_SUCCESS) {
-		status = low_alloc(hdr->init_size, hdr->kernel_alignment,
-				   &start);
+		status = efi_low_alloc(sys_table, hdr->init_size,
+				   hdr->kernel_alignment, &start, 0);
 		if (status != EFI_SUCCESS)
-			efi_printk("Failed to alloc mem for kernel\n");
+			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
 	}
 
 	if (status == EFI_SUCCESS)
@@ -737,14 +746,15 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 				EFI_LOADER_DATA, sizeof(*gdt),
 				(void **)&gdt);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for gdt structure\n");
+		efi_printk(sys_table, "Failed to alloc mem for gdt structure\n");
 		goto fail;
 	}
 
 	gdt->size = 0x800;
-	status = low_alloc(gdt->size, 8, (unsigned long *)&gdt->address);
+	status = efi_low_alloc(sys_table, gdt->size, 8,
+			   (unsigned long *)&gdt->address, 0);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for gdt\n");
+		efi_printk(sys_table, "Failed to alloc mem for gdt\n");
 		goto fail;
 	}
 
@@ -752,7 +762,7 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 				EFI_LOADER_DATA, sizeof(*idt),
 				(void **)&idt);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for idt structure\n");
+		efi_printk(sys_table, "Failed to alloc mem for idt structure\n");
 		goto fail;
 	}
 
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 47891bd..3dd9b76 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -11,6 +11,8 @@
  */
 
 
+#define EFI_READ_CHUNK_SIZE	(1024 * 1024)
+
 struct initrd {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -19,15 +21,16 @@ struct initrd {
 
 
 
-static void efi_char16_printk(efi_char16_t *str)
+static void efi_char16_printk(efi_system_table_t *sys_table_arg,
+			      efi_char16_t *str)
 {
 	struct efi_simple_text_output_protocol *out;
 
-	out = (struct efi_simple_text_output_protocol *)sys_table->con_out;
+	out = (struct efi_simple_text_output_protocol *)sys_table_arg->con_out;
 	efi_call_phys2(out->output_string, out, str);
 }
 
-static void efi_printk(char *str)
+static void efi_printk(efi_system_table_t *sys_table_arg, char *str)
 {
 	char *s8;
 
@@ -37,16 +40,19 @@ static void efi_printk(char *str)
 		ch[0] = *s8;
 		if (*s8 == '\n') {
 			efi_char16_t nl[2] = { '\r', 0 };
-			efi_char16_printk(nl);
+			efi_char16_printk(sys_table_arg, nl);
 		}
 
-		efi_char16_printk(ch);
+		efi_char16_printk(sys_table_arg, ch);
 	}
 }
 
 
-static efi_status_t __get_map(efi_memory_desc_t **map, unsigned long *map_size,
-			      unsigned long *desc_size)
+static efi_status_t efi_get_memory_map(efi_system_table_t *sys_table_arg,
+				       efi_memory_desc_t **map,
+				       unsigned long *map_size,
+				       unsigned long *desc_size,
+				       unsigned long *key_ptr)
 {
 	efi_memory_desc_t *m = NULL;
 	efi_status_t status;
@@ -60,20 +66,22 @@ again:
 	 * allocation which may be in a new descriptor region.
 	 */
 	*map_size += sizeof(*m);
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
 				EFI_LOADER_DATA, *map_size, (void **)&m);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
-	status = efi_call_phys5(sys_table->boottime->get_memory_map, map_size,
-				m, &key, desc_size, &desc_version);
+	status = efi_call_phys5(sys_table_arg->boottime->get_memory_map,
+				map_size, m, &key, desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		efi_call_phys1(sys_table->boottime->free_pool, m);
+		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
-		efi_call_phys1(sys_table->boottime->free_pool, m);
+		efi_call_phys1(sys_table_arg->boottime->free_pool, m);
+	if (key_ptr && status == EFI_SUCCESS)
+		*key_ptr = key;
 
 fail:
 	*map = m;
@@ -83,8 +91,9 @@ fail:
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
-static efi_status_t high_alloc(unsigned long size, unsigned long align,
-			      unsigned long *addr, unsigned long max)
+static efi_status_t efi_high_alloc(efi_system_table_t *sys_table_arg,
+			       unsigned long size, unsigned long align,
+			       unsigned long *addr, unsigned long max)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -93,10 +102,18 @@ static efi_status_t high_alloc(unsigned long size, unsigned long align,
 	u64 max_addr = 0;
 	int i;
 
-	status = __get_map(&map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
+	/* Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 again:
 	for (i = 0; i < map_size / desc_size; i++) {
@@ -139,7 +156,7 @@ again:
 	if (!max_addr)
 		status = EFI_NOT_FOUND;
 	else {
-		status = efi_call_phys4(sys_table->boottime->allocate_pages,
+		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
 					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					nr_pages, &max_addr);
 		if (status != EFI_SUCCESS) {
@@ -151,18 +168,18 @@ again:
 		*addr = max_addr;
 	}
 
-free_pool:
-	efi_call_phys1(sys_table->boottime->free_pool, map);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 
 fail:
 	return status;
 }
 
 /*
- * Allocate at the lowest possible address.
+ * Allocate at the lowest possible address, that is not below 'min'
  */
-static efi_status_t low_alloc(unsigned long size, unsigned long align,
-			      unsigned long *addr)
+static efi_status_t efi_low_alloc(efi_system_table_t *sys_table_arg,
+			      unsigned long size, unsigned long align,
+			      unsigned long *addr, unsigned long min)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -170,16 +187,23 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 	unsigned long nr_pages;
 	int i;
 
-	status = __get_map(&map, &map_size, &desc_size);
+	status = efi_get_memory_map(sys_table_arg, &map, &map_size, &desc_size,
+				    NULL);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
+	/* Enforce minimum alignment that EFI requires when requesting
+	 * a specific address.  We are doing page-based allocations,
+	 * so we must be aligned to a page.
+	 */
+	if (align < EFI_PAGE_SIZE)
+		align = EFI_PAGE_SIZE;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
 	for (i = 0; i < map_size / desc_size; i++) {
 		efi_memory_desc_t *desc;
 		unsigned long m = (unsigned long)map;
 		u64 start, end;
-
 		desc = (efi_memory_desc_t *)(m + (i * desc_size));
 
 		if (desc->type != EFI_CONVENTIONAL_MEMORY)
@@ -199,11 +223,14 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 		if (start == 0x0)
 			start += 8;
 
+		if (start < min)
+			start = min;
+
 		start = round_up(start, align);
 		if ((start + size) > end)
 			continue;
 
-		status = efi_call_phys4(sys_table->boottime->allocate_pages,
+		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
 					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					nr_pages, &start);
 		if (status == EFI_SUCCESS) {
@@ -215,18 +242,21 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 	if (i == map_size / desc_size)
 		status = EFI_NOT_FOUND;
 
-free_pool:
-	efi_call_phys1(sys_table->boottime->free_pool, map);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 fail:
 	return status;
 }
 
-static void low_free(unsigned long size, unsigned long addr)
+static void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
+		     unsigned long addr)
 {
 	unsigned long nr_pages;
 
+	if (!size)
+		return;
+
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
+	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
 }
 
 
@@ -236,8 +266,11 @@ static void low_free(unsigned long size, unsigned long addr)
  * We only support loading an initrd from the same filesystem as the
  * kernel image.
  */
-static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
-				    struct setup_header *hdr)
+static efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
+					 efi_loaded_image_t *image,
+					 char *cmd_line, char *option_string,
+					 u64 max_addr,
+					 u64 *load_addr, u64 *load_size)
 {
 	struct initrd *initrds;
 	unsigned long initrd_addr;
@@ -253,19 +286,25 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 	initrd_addr = 0;
 	initrd_total = 0;
 
-	str = (char *)(unsigned long)hdr->cmd_line_ptr;
+	str = cmd_line;
 
 	j = 0;			/* See close_handles */
 
+	if (!load_addr || !load_size)
+		return EFI_INVALID_PARAMETER;
+
+	*load_addr = 0;
+	*load_size = 0;
+
 	if (!str || !*str)
 		return EFI_SUCCESS;
 
 	for (nr_initrds = 0; *str; nr_initrds++) {
-		str = strstr(str, "initrd=");
+		str = strstr(str, option_string);
 		if (!str)
 			break;
 
-		str += 7;
+		str += strlen(option_string);
 
 		/* Skip any leading slashes */
 		while (*str == '/' || *str == '\\')
@@ -278,16 +317,16 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 	if (!nr_initrds)
 		return EFI_SUCCESS;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
 				EFI_LOADER_DATA,
 				nr_initrds * sizeof(*initrds),
-				&initrds);
+				(void **)&initrds);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for initrds\n");
+		efi_printk(sys_table_arg, "Failed to alloc mem for file load\n");
 		goto fail;
 	}
 
-	str = (char *)(unsigned long)hdr->cmd_line_ptr;
+	str = cmd_line;
 	for (i = 0; i < nr_initrds; i++) {
 		struct initrd *initrd;
 		efi_file_handle_t *h;
@@ -298,11 +337,11 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		efi_char16_t *p;
 		u64 file_sz;
 
-		str = strstr(str, "initrd=");
+		str = strstr(str, option_string);
 		if (!str)
 			break;
 
-		str += 7;
+		str += strlen(option_string);
 
 		initrd = &initrds[i];
 		p = filename_16;
@@ -317,7 +356,7 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 
 			if (*str == '/') {
 				*p++ = '\\';
-				*str++;
+				str++;
 			} else {
 				*p++ = *str++;
 			}
@@ -329,18 +368,19 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		if (!i) {
 			efi_boot_services_t *boottime;
 
-			boottime = sys_table->boottime;
+			boottime = sys_table_arg->boottime;
 
 			status = efi_call_phys3(boottime->handle_protocol,
-					image->device_handle, &fs_proto, &io);
+						image->device_handle, &fs_proto,
+						(void **)&io);
 			if (status != EFI_SUCCESS) {
-				efi_printk("Failed to handle fs_proto\n");
+				efi_printk(sys_table_arg, "Failed to handle fs_proto\n");
 				goto free_initrds;
 			}
 
 			status = efi_call_phys2(io->open_volume, io, &fh);
 			if (status != EFI_SUCCESS) {
-				efi_printk("Failed to open volume\n");
+				efi_printk(sys_table_arg, "Failed to open volume\n");
 				goto free_initrds;
 			}
 		}
@@ -348,9 +388,9 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to open initrd file: ");
-			efi_char16_printk(filename_16);
-			efi_printk("\n");
+			efi_printk(sys_table_arg, "Failed to open file file: ");
+			efi_char16_printk(sys_table_arg, filename_16);
+			efi_printk(sys_table_arg, "\n");
 			goto close_handles;
 		}
 
@@ -360,30 +400,32 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, NULL);
 		if (status != EFI_BUFFER_TOO_SMALL) {
-			efi_printk("Failed to get initrd info size\n");
+			efi_printk(sys_table_arg, "Failed to get file info size\n");
 			goto close_handles;
 		}
 
 grow:
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
-					EFI_LOADER_DATA, info_sz, &info);
+		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
+					EFI_LOADER_DATA, info_sz,
+					(void **)&info);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to alloc mem for initrd info\n");
+			efi_printk(sys_table_arg, "Failed to alloc mem for file info\n");
 			goto close_handles;
 		}
 
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, info);
 		if (status == EFI_BUFFER_TOO_SMALL) {
-			efi_call_phys1(sys_table->boottime->free_pool, info);
+			efi_call_phys1(sys_table_arg->boottime->free_pool,
+				       info);
 			goto grow;
 		}
 
 		file_sz = info->file_size;
-		efi_call_phys1(sys_table->boottime->free_pool, info);
+		efi_call_phys1(sys_table_arg->boottime->free_pool, info);
 
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to get initrd info\n");
+			efi_printk(sys_table_arg, "Failed to get file info\n");
 			goto close_handles;
 		}
 
@@ -399,16 +441,16 @@ grow:
 		 * addresses in memory, so allocate enough memory for
 		 * all the initrd's.
 		 */
-		status = high_alloc(initrd_total, 0x1000,
-				   &initrd_addr, hdr->initrd_addr_max);
+		status = efi_high_alloc(sys_table_arg, initrd_total, 0x1000,
+				    &initrd_addr, max_addr);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to alloc highmem for initrds\n");
+			efi_printk(sys_table_arg, "Failed to alloc highmem for initrds\n");
 			goto close_handles;
 		}
 
 		/* We've run out of free low memory. */
-		if (initrd_addr > hdr->initrd_addr_max) {
-			efi_printk("We've run out of free low memory\n");
+		if (initrd_addr > max_addr) {
+			efi_printk(sys_table_arg, "We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
 			goto free_initrd_total;
 		}
@@ -419,16 +461,17 @@ grow:
 
 			size = initrds[j].size;
 			while (size) {
-				u64 chunksize;
+				unsigned long chunksize;
 				if (size > EFI_READ_CHUNK_SIZE)
 					chunksize = EFI_READ_CHUNK_SIZE;
 				else
 					chunksize = size;
 				status = efi_call_phys3(fh->read,
 							initrds[j].handle,
-							&chunksize, addr);
+							&chunksize,
+							(void *)addr);
 				if (status != EFI_SUCCESS) {
-					efi_printk("Failed to read initrd\n");
+					efi_printk(sys_table_arg, "Failed to read file\n");
 					goto free_initrd_total;
 				}
 				addr += chunksize;
@@ -440,24 +483,24 @@ grow:
 
 	}
 
-	efi_call_phys1(sys_table->boottime->free_pool, initrds);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
 
-	hdr->ramdisk_image = initrd_addr;
-	hdr->ramdisk_size = initrd_total;
+	*load_addr = initrd_addr;
+	*load_size = initrd_total;
 
 	return status;
 
 free_initrd_total:
-	low_free(initrd_total, initrd_addr);
+	efi_free(sys_table_arg, initrd_total, initrd_addr);
 
 close_handles:
 	for (k = j; k < i; k++)
 		efi_call_phys1(fh->close, initrds[k].handle);
 free_initrds:
-	efi_call_phys1(sys_table->boottime->free_pool, initrds);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
 fail:
-	hdr->ramdisk_image = 0;
-	hdr->ramdisk_size = 0;
+	*load_addr = 0;
+	*load_size = 0;
 
 	return status;
 }
-- 
1.7.10.4

