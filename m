Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753361Ab3IWB7d (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 21:59:33 -0400
Received: from g4t0015.houston.hp.com ([15.201.24.18]:25548 "EHLO
	g4t0015.houston.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753324Ab3IWB7b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 21:59:31 -0400
From: Linn Crosetto <linn@hp.com>
To: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org
Cc: linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org,
        Linn Crosetto <linn@hp.com>
Subject: [PATCHv3] x86: EFI stub support for large memory maps
Date: Sun, 22 Sep 2013 19:59:08 -0600
Message-Id: <1379901548-70954-1-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1378487056-9857-1-git-send-email-linn@hp.com>
References: <1378487056-9857-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes a problem with EFI memory maps larger than 128 entries
when booting using the EFI stub, which results in overflowing e820_map
in boot_params and an eventual halt when checking the map size in
sanitize_e820_map().

If the number of map entries is greater than what can fit in e820_map,
add the extra entries to the setup_data list using type SETUP_E820_EXT.
These extra entries are then picked up when the setup_data list is
parsed in parse_e820_ext().

Signed-off-by: Linn Crosetto <linn@hp.com>
---
Changes from v2:
 * Removed unnecessary optimization in alloc_e820ext() (Matt Fleming)
 * Fixed a bug where an incorrect buffer size may be passed to
   get_memory_map when jumping to get_map

 arch/x86/boot/compressed/eboot.c | 239 +++++++++++++++++++++++++++------------
 1 file changed, 167 insertions(+), 72 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..bfa177a 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -982,46 +982,198 @@ fail:
 	return NULL;
 }
 
+static void add_e820ext(struct boot_params *params,
+			struct setup_data *e820ext, u32 nr_entries)
+{
+	struct setup_data *data;
+	efi_status_t status;
+	unsigned long size;
+
+	e820ext->type = SETUP_E820_EXT;
+	e820ext->len = nr_entries * sizeof(struct e820entry);
+	e820ext->next = 0;
+
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
+
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
+
+	if (data)
+		data->next = (unsigned long)e820ext;
+	else
+		params->hdr.setup_data = (unsigned long)e820ext;
+}
+
+static efi_status_t setup_e820(struct boot_params *params,
+			       struct setup_data *e820ext, u32 e820ext_size)
+{
+	struct e820entry *e820_map = &params->e820_map[0];
+	struct efi_info *efi = &params->efi_info;
+	struct e820entry *prev = NULL;
+	u32 nr_entries;
+	u32 nr_desc;
+	int i;
+
+	nr_entries = 0;
+	nr_desc = efi->efi_memmap_size / efi->efi_memdesc_size;
+
+	for (i = 0; i < nr_desc; i++) {
+		efi_memory_desc_t *d;
+		unsigned int e820_type = 0;
+		unsigned long m = efi->efi_memmap;
+
+		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
+		switch (d->type) {
+		case EFI_RESERVED_TYPE:
+		case EFI_RUNTIME_SERVICES_CODE:
+		case EFI_RUNTIME_SERVICES_DATA:
+		case EFI_MEMORY_MAPPED_IO:
+		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
+		case EFI_PAL_CODE:
+			e820_type = E820_RESERVED;
+			break;
+
+		case EFI_UNUSABLE_MEMORY:
+			e820_type = E820_UNUSABLE;
+			break;
+
+		case EFI_ACPI_RECLAIM_MEMORY:
+			e820_type = E820_ACPI;
+			break;
+
+		case EFI_LOADER_CODE:
+		case EFI_LOADER_DATA:
+		case EFI_BOOT_SERVICES_CODE:
+		case EFI_BOOT_SERVICES_DATA:
+		case EFI_CONVENTIONAL_MEMORY:
+			e820_type = E820_RAM;
+			break;
+
+		case EFI_ACPI_MEMORY_NVS:
+			e820_type = E820_NVS;
+			break;
+
+		default:
+			continue;
+		}
+
+		/* Merge adjacent mappings */
+		if (prev && prev->type == e820_type &&
+		    (prev->addr + prev->size) == d->phys_addr) {
+			prev->size += d->num_pages << 12;
+			continue;
+		}
+
+		if (nr_entries == ARRAY_SIZE(params->e820_map)) {
+			u32 need = (nr_desc - i) * sizeof(struct e820entry) +
+				   sizeof(struct setup_data);
+
+			if (!e820ext || e820ext_size < need)
+				return EFI_BUFFER_TOO_SMALL;
+
+			/* boot_params map full, switch to e820 extended */
+			e820_map = (struct e820entry *)e820ext->data;
+		}
+
+		e820_map->addr = d->phys_addr;
+		e820_map->size = d->num_pages << PAGE_SHIFT;
+		e820_map->type = e820_type;
+		prev = e820_map++;
+		nr_entries++;
+	}
+
+	if (nr_entries > ARRAY_SIZE(params->e820_map)) {
+		u32 nr_e820ext = nr_entries - ARRAY_SIZE(params->e820_map);
+
+		add_e820ext(params, e820ext, nr_e820ext);
+		nr_entries -= nr_e820ext;
+	}
+
+	params->e820_entries = (u8)nr_entries;
+
+	return EFI_SUCCESS;
+}
+
+static efi_status_t alloc_e820ext(u32 nr_desc, struct setup_data **e820ext,
+				  u32 *e820ext_size)
+{
+	efi_status_t status;
+	unsigned long size;
+
+	size = sizeof(struct setup_data) +
+		sizeof(struct e820entry) * nr_desc;
+
+	if (*e820ext) {
+		efi_call_phys1(sys_table->boottime->free_pool, *e820ext);
+		*e820ext = NULL;
+		*e820ext_size = 0;
+	}
+
+	status = efi_call_phys3(sys_table->boottime->allocate_pool,
+				EFI_LOADER_DATA, size, e820ext);
+
+	if (status == EFI_SUCCESS)
+		*e820ext_size = size;
+
+	return status;
+}
+
 static efi_status_t exit_boot(struct boot_params *boot_params,
 			      void *handle)
 {
 	struct efi_info *efi = &boot_params->efi_info;
-	struct e820entry *e820_map = &boot_params->e820_map[0];
-	struct e820entry *prev = NULL;
-	unsigned long size, key, desc_size, _size;
+	unsigned long map_sz, key, desc_size, buf_sz;
 	efi_memory_desc_t *mem_map;
+	struct setup_data *e820ext;
+	__u32 e820ext_size;
+	__u32 nr_desc, prev_nr_desc;
 	efi_status_t status;
 	__u32 desc_version;
 	bool called_exit = false;
-	u8 nr_entries;
-	int i;
 
-	size = sizeof(*mem_map) * 32;
+	nr_desc = 0;
+	e820ext = NULL;
+	e820ext_size = 0;
+	map_sz = sizeof(*mem_map) * 32;
 
 again:
-	size += sizeof(*mem_map) * 2;
-	_size = size;
-	status = low_alloc(size, 1, (unsigned long *)&mem_map);
+	map_sz += sizeof(*mem_map) * 2;
+	buf_sz = map_sz;
+	status = low_alloc(buf_sz, 1, (unsigned long *)&mem_map);
 	if (status != EFI_SUCCESS)
 		return status;
 
 get_map:
-	status = efi_call_phys5(sys_table->boottime->get_memory_map, &size,
+	map_sz = buf_sz;
+	status = efi_call_phys5(sys_table->boottime->get_memory_map, &map_sz,
 				mem_map, &key, &desc_size, &desc_version);
 	if (status == EFI_BUFFER_TOO_SMALL) {
-		low_free(_size, (unsigned long)mem_map);
+		low_free(buf_sz, (unsigned long)mem_map);
 		goto again;
 	}
 
 	if (status != EFI_SUCCESS)
 		goto free_mem_map;
 
+	prev_nr_desc = nr_desc;
+	nr_desc = map_sz / desc_size;
+	if (nr_desc > prev_nr_desc &&
+	    nr_desc > ARRAY_SIZE(boot_params->e820_map)) {
+		u32 nr_e820ext = nr_desc - ARRAY_SIZE(boot_params->e820_map);
+
+		status = alloc_e820ext(nr_e820ext, &e820ext, &e820ext_size);
+		if (status != EFI_SUCCESS)
+			goto free_mem_map;
+
+		goto get_map; /* Allocated memory, get map again */
+	}
+
 	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
 	efi->efi_systab = (unsigned long)sys_table;
 	efi->efi_memdesc_size = desc_size;
 	efi->efi_memdesc_version = desc_version;
 	efi->efi_memmap = (unsigned long)mem_map;
-	efi->efi_memmap_size = size;
+	efi->efi_memmap_size = map_sz;
 
 #ifdef CONFIG_X86_64
 	efi->efi_systab_hi = (unsigned long)sys_table >> 32;
@@ -1049,69 +1201,12 @@ get_map:
 	/* Historic? */
 	boot_params->alt_mem_k = 32 * 1024;
 
-	/*
-	 * Convert the EFI memory map to E820.
-	 */
-	nr_entries = 0;
-	for (i = 0; i < size / desc_size; i++) {
-		efi_memory_desc_t *d;
-		unsigned int e820_type = 0;
-		unsigned long m = (unsigned long)mem_map;
-
-		d = (efi_memory_desc_t *)(m + (i * desc_size));
-		switch (d->type) {
-		case EFI_RESERVED_TYPE:
-		case EFI_RUNTIME_SERVICES_CODE:
-		case EFI_RUNTIME_SERVICES_DATA:
-		case EFI_MEMORY_MAPPED_IO:
-		case EFI_MEMORY_MAPPED_IO_PORT_SPACE:
-		case EFI_PAL_CODE:
-			e820_type = E820_RESERVED;
-			break;
-
-		case EFI_UNUSABLE_MEMORY:
-			e820_type = E820_UNUSABLE;
-			break;
-
-		case EFI_ACPI_RECLAIM_MEMORY:
-			e820_type = E820_ACPI;
-			break;
-
-		case EFI_LOADER_CODE:
-		case EFI_LOADER_DATA:
-		case EFI_BOOT_SERVICES_CODE:
-		case EFI_BOOT_SERVICES_DATA:
-		case EFI_CONVENTIONAL_MEMORY:
-			e820_type = E820_RAM;
-			break;
-
-		case EFI_ACPI_MEMORY_NVS:
-			e820_type = E820_NVS;
-			break;
-
-		default:
-			continue;
-		}
-
-		/* Merge adjacent mappings */
-		if (prev && prev->type == e820_type &&
-		    (prev->addr + prev->size) == d->phys_addr)
-			prev->size += d->num_pages << 12;
-		else {
-			e820_map->addr = d->phys_addr;
-			e820_map->size = d->num_pages << 12;
-			e820_map->type = e820_type;
-			prev = e820_map++;
-			nr_entries++;
-		}
-	}
-
-	boot_params->e820_entries = nr_entries;
+	status = setup_e820(boot_params, e820ext, e820ext_size);
 
-	return EFI_SUCCESS;
+	return status;
 
 free_mem_map:
-	low_free(_size, (unsigned long)mem_map);
+	low_free(buf_sz, (unsigned long)mem_map);
 	return status;
 }
 
-- 
1.7.11.3

