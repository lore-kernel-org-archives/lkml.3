Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1031667Ab3HIX0e (ORCPT <rfc822;w@1wt.eu>);
	Fri, 9 Aug 2013 19:26:34 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:64081 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1031650Ab3HIX0a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 9 Aug 2013 19:26:30 -0400
From: Roy Franz <roy.franz@linaro.org>
To: linux-kernel@vger.kernel.org, linux-efi@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, matt.fleming@intel.com,
        linux@arm.linux.org.uk
Cc: leif.lindholm@linaro.org, dave.martin@arm.com, msalter@redhat.com,
        Roy Franz <roy.franz@linaro.org>
Subject: [PATCH 02/16] Add system pointer argument to shared EFI stub related functions so they no longer use global system table pointer as they did when part of eboot.c. This code is now shared, so using a global variable as part of the interface is not that nice. Also, by avoiding any global variables in the ARM EFI stub, this allows the code to be position independent without requiring GOT fixups.
Date: Fri,  9 Aug 2013 16:26:03 -0700
Message-Id: <1376090777-20090-3-git-send-email-roy.franz@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
References: <1376090777-20090-1-git-send-email-roy.franz@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Signed-off-by: Roy Franz <roy.franz@linaro.org>
---
 arch/x86/boot/compressed/eboot.c       |   38 +++++++------
 drivers/firmware/efi/efi-stub-helper.c |   96 +++++++++++++++++---------------
 2 files changed, 72 insertions(+), 62 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index ab0eefc..65b6a34 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -453,13 +453,13 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	status = efi_call_phys3(sys_table->boottime->handle_protocol,
 				handle, &proto, (void *)&image);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
+		efi_printk(sys_table, "Failed to get handle for LOADED_IMAGE_PROTOCOL\n");
 		return NULL;
 	}
 
-	status = low_alloc(0x4000, 1, (unsigned long *)&boot_params);
+	status = low_alloc(sys_table, 0x4000, 1, (unsigned long *)&boot_params);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc lowmem for boot params\n");
+		efi_printk(sys_table, "Failed to alloc lowmem for boot params\n");
 		return NULL;
 	}
 
@@ -503,9 +503,10 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 			options_size++;	/* NUL termination */
 
-			status = low_alloc(options_size, 1, &cmdline);
+			status = low_alloc(sys_table, options_size, 1,
+					   &cmdline);
 			if (status != EFI_SUCCESS) {
-				efi_printk("Failed to alloc mem for cmdline\n");
+				efi_printk(sys_table, "Failed to alloc mem for cmdline\n");
 				goto fail;
 			}
 
@@ -529,16 +530,16 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 
 	memset(sdt, 0, sizeof(*sdt));
 
-	status = handle_ramdisks(image, hdr);
+	status = handle_ramdisks(sys_table, image, hdr);
 	if (status != EFI_SUCCESS)
 		goto fail2;
 
 	return boot_params;
 fail2:
 	if (options_size)
-		low_free(options_size, hdr->cmd_line_ptr);
+		low_free(sys_table, options_size, hdr->cmd_line_ptr);
 fail:
-	low_free(0x4000, (unsigned long)boot_params);
+	low_free(sys_table, 0x4000, (unsigned long)boot_params);
 	return NULL;
 }
 
@@ -561,7 +562,7 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 again:
 	size += sizeof(*mem_map) * 2;
 	_size = size;
-	status = low_alloc(size, 1, (unsigned long *)&mem_map);
+	status = low_alloc(sys_table, size, 1, (unsigned long *)&mem_map);
 	if (status != EFI_SUCCESS)
 		return status;
 
@@ -569,7 +570,7 @@ get_map:
 	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
 				mem_map, &key, &desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		low_free(_size, (unsigned long)mem_map);
+		low_free(sys_table, _size, (unsigned long)mem_map);
 		goto again;
 	}
 
@@ -671,7 +672,7 @@ get_map:
 	return EFI_SUCCESS;
 
 free_mem_map:
-	low_free(_size, (unsigned long)mem_map);
+	low_free(sys_table, _size, (unsigned long)mem_map);
 	return status;
 }
 
@@ -694,10 +695,10 @@ static efi_status_t relocate_kernel(struct setup_header *hdr)
 				EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 				nr_pages, &start);
 	if (status != EFI_SUCCESS) {
-		status = low_alloc(hdr->init_size, hdr->kernel_alignment,
-				   &start);
+		status = low_alloc(sys_table, hdr->init_size,
+				   hdr->kernel_alignment, &start);
 		if (status != EFI_SUCCESS)
-			efi_printk("Failed to alloc mem for kernel\n");
+			efi_printk(sys_table, "Failed to alloc mem for kernel\n");
 	}
 
 	if (status == EFI_SUCCESS)
@@ -737,14 +738,15 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 				EFI_LOADER_DATA, sizeof(*gdt),
 				(void **)&gdt);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for gdt structure\n");
+		efi_printk(sys_table, "Failed to alloc mem for gdt structure\n");
 		goto fail;
 	}
 
 	gdt->size = 0x800;
-	status = low_alloc(gdt->size, 8, (unsigned long *)&gdt->address);
+	status = low_alloc(sys_table, gdt->size, 8,
+			   (unsigned long *)&gdt->address);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for gdt\n");
+		efi_printk(sys_table, "Failed to alloc mem for gdt\n");
 		goto fail;
 	}
 
@@ -752,7 +754,7 @@ struct boot_params *efi_main(void *handle, efi_system_table_t *_table,
 				EFI_LOADER_DATA, sizeof(*idt),
 				(void **)&idt);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for idt structure\n");
+		efi_printk(sys_table, "Failed to alloc mem for idt structure\n");
 		goto fail;
 	}
 
diff --git a/drivers/firmware/efi/efi-stub-helper.c b/drivers/firmware/efi/efi-stub-helper.c
index 47891bd..bd6c1a2 100644
--- a/drivers/firmware/efi/efi-stub-helper.c
+++ b/drivers/firmware/efi/efi-stub-helper.c
@@ -19,15 +19,16 @@ struct initrd {
 
 
 
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
 
@@ -37,15 +38,17 @@ static void efi_printk(char *str)
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
+static efi_status_t __get_map(efi_system_table_t *sys_table_arg,
+			      efi_memory_desc_t **map,
+			      unsigned long *map_size,
 			      unsigned long *desc_size)
 {
 	efi_memory_desc_t *m = NULL;
@@ -60,20 +63,20 @@ again:
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
 
 fail:
 	*map = m;
@@ -83,8 +86,9 @@ fail:
 /*
  * Allocate at the highest possible address that is not above 'max'.
  */
-static efi_status_t high_alloc(unsigned long size, unsigned long align,
-			      unsigned long *addr, unsigned long max)
+static efi_status_t high_alloc(efi_system_table_t *sys_table_arg,
+			       unsigned long size, unsigned long align,
+			       unsigned long *addr, unsigned long max)
 {
 	unsigned long map_size, desc_size;
 	efi_memory_desc_t *map;
@@ -93,7 +97,7 @@ static efi_status_t high_alloc(unsigned long size, unsigned long align,
 	u64 max_addr = 0;
 	int i;
 
-	status = __get_map(&map, &map_size, &desc_size);
+	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -139,7 +143,7 @@ again:
 	if (!max_addr)
 		status = EFI_NOT_FOUND;
 	else {
-		status = efi_call_phys4(sys_table->boottime->allocate_pages,
+		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
 					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					nr_pages, &max_addr);
 		if (status != EFI_SUCCESS) {
@@ -152,7 +156,7 @@ again:
 	}
 
 free_pool:
-	efi_call_phys1(sys_table->boottime->free_pool, map);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 
 fail:
 	return status;
@@ -161,7 +165,8 @@ fail:
 /*
  * Allocate at the lowest possible address.
  */
-static efi_status_t low_alloc(unsigned long size, unsigned long align,
+static efi_status_t low_alloc(efi_system_table_t *sys_table_arg,
+		unsigned long size, unsigned long align,
 			      unsigned long *addr)
 {
 	unsigned long map_size, desc_size;
@@ -170,7 +175,7 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 	unsigned long nr_pages;
 	int i;
 
-	status = __get_map(&map, &map_size, &desc_size);
+	status = __get_map(sys_table_arg, &map, &map_size, &desc_size);
 	if (status != EFI_SUCCESS)
 		goto fail;
 
@@ -203,7 +208,7 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 		if ((start + size) > end)
 			continue;
 
-		status = efi_call_phys4(sys_table->boottime->allocate_pages,
+		status = efi_call_phys4(sys_table_arg->boottime->allocate_pages,
 					EFI_ALLOCATE_ADDRESS, EFI_LOADER_DATA,
 					nr_pages, &start);
 		if (status == EFI_SUCCESS) {
@@ -216,17 +221,18 @@ static efi_status_t low_alloc(unsigned long size, unsigned long align,
 		status = EFI_NOT_FOUND;
 
 free_pool:
-	efi_call_phys1(sys_table->boottime->free_pool, map);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, map);
 fail:
 	return status;
 }
 
-static void low_free(unsigned long size, unsigned long addr)
+static void low_free(efi_system_table_t *sys_table_arg, unsigned long size,
+		     unsigned long addr)
 {
 	unsigned long nr_pages;
 
 	nr_pages = round_up(size, EFI_PAGE_SIZE) / EFI_PAGE_SIZE;
-	efi_call_phys2(sys_table->boottime->free_pages, addr, nr_pages);
+	efi_call_phys2(sys_table_arg->boottime->free_pages, addr, nr_pages);
 }
 
 
@@ -236,7 +242,8 @@ static void low_free(unsigned long size, unsigned long addr)
  * We only support loading an initrd from the same filesystem as the
  * kernel image.
  */
-static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
+static efi_status_t handle_ramdisks(efi_system_table_t *sys_table_arg,
+				    efi_loaded_image_t *image,
 				    struct setup_header *hdr)
 {
 	struct initrd *initrds;
@@ -278,12 +285,12 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 	if (!nr_initrds)
 		return EFI_SUCCESS;
 
-	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+	status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
 				EFI_LOADER_DATA,
 				nr_initrds * sizeof(*initrds),
 				&initrds);
 	if (status != EFI_SUCCESS) {
-		efi_printk("Failed to alloc mem for initrds\n");
+		efi_printk(sys_table_arg, "Failed to alloc mem for initrds\n");
 		goto fail;
 	}
 
@@ -329,18 +336,18 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		if (!i) {
 			efi_boot_services_t *boottime;
 
-			boottime = sys_table->boottime;
+			boottime = sys_table_arg->boottime;
 
 			status = efi_call_phys3(boottime->handle_protocol,
 					image->device_handle, &fs_proto, &io);
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
@@ -348,9 +355,9 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		status = efi_call_phys5(fh->open, fh, &h, filename_16,
 					EFI_FILE_MODE_READ, (u64)0);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to open initrd file: ");
-			efi_char16_printk(filename_16);
-			efi_printk("\n");
+			efi_printk(sys_table_arg, "Failed to open initrd file: ");
+			efi_char16_printk(sys_table_arg, filename_16);
+			efi_printk(sys_table_arg, "\n");
 			goto close_handles;
 		}
 
@@ -360,30 +367,31 @@ static efi_status_t handle_ramdisks(efi_loaded_image_t *image,
 		status = efi_call_phys4(h->get_info, h, &info_guid,
 					&info_sz, NULL);
 		if (status != EFI_BUFFER_TOO_SMALL) {
-			efi_printk("Failed to get initrd info size\n");
+			efi_printk(sys_table_arg, "Failed to get initrd info size\n");
 			goto close_handles;
 		}
 
 grow:
-		status = efi_call_phys3(sys_table->boottime->allocate_pool,
+		status = efi_call_phys3(sys_table_arg->boottime->allocate_pool,
 					EFI_LOADER_DATA, info_sz, &info);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to alloc mem for initrd info\n");
+			efi_printk(sys_table_arg, "Failed to alloc mem for initrd info\n");
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
+			efi_printk(sys_table_arg, "Failed to get initrd info\n");
 			goto close_handles;
 		}
 
@@ -399,16 +407,16 @@ grow:
 		 * addresses in memory, so allocate enough memory for
 		 * all the initrd's.
 		 */
-		status = high_alloc(initrd_total, 0x1000,
+		status = high_alloc(sys_table_arg, initrd_total, 0x1000,
 				   &initrd_addr, hdr->initrd_addr_max);
 		if (status != EFI_SUCCESS) {
-			efi_printk("Failed to alloc highmem for initrds\n");
+			efi_printk(sys_table_arg, "Failed to alloc highmem for initrds\n");
 			goto close_handles;
 		}
 
 		/* We've run out of free low memory. */
 		if (initrd_addr > hdr->initrd_addr_max) {
-			efi_printk("We've run out of free low memory\n");
+			efi_printk(sys_table_arg, "We've run out of free low memory\n");
 			status = EFI_INVALID_PARAMETER;
 			goto free_initrd_total;
 		}
@@ -428,7 +436,7 @@ grow:
 							initrds[j].handle,
 							&chunksize, addr);
 				if (status != EFI_SUCCESS) {
-					efi_printk("Failed to read initrd\n");
+					efi_printk(sys_table_arg, "Failed to read initrd\n");
 					goto free_initrd_total;
 				}
 				addr += chunksize;
@@ -440,7 +448,7 @@ grow:
 
 	}
 
-	efi_call_phys1(sys_table->boottime->free_pool, initrds);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
 
 	hdr->ramdisk_image = initrd_addr;
 	hdr->ramdisk_size = initrd_total;
@@ -448,13 +456,13 @@ grow:
 	return status;
 
 free_initrd_total:
-	low_free(initrd_total, initrd_addr);
+	low_free(sys_table_arg, initrd_total, initrd_addr);
 
 close_handles:
 	for (k = j; k < i; k++)
 		efi_call_phys1(fh->close, initrds[k].handle);
 free_initrds:
-	efi_call_phys1(sys_table->boottime->free_pool, initrds);
+	efi_call_phys1(sys_table_arg->boottime->free_pool, initrds);
 fail:
 	hdr->ramdisk_image = 0;
 	hdr->ramdisk_size = 0;
-- 
1.7.10.4

