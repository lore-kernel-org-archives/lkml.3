Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755715Ab3IYM6y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 25 Sep 2013 08:58:54 -0400
Received: from arkanian.console-pimps.org ([212.110.184.194]:58893 "EHLO
	arkanian.console-pimps.org" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755111Ab3IYM6w (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 25 Sep 2013 08:58:52 -0400
Date: Wed, 25 Sep 2013 13:58:40 +0100
From: Matt Fleming <matt@console-pimps.org>
To: Linn Crosetto <linn@hp.com>
Cc: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        linux-efi@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: Re: [PATCHv3] x86: EFI stub support for large memory maps
Message-ID: <20130925125840.GK21381@console-pimps.org>
References: <1378487056-9857-1-git-send-email-linn@hp.com>
 <1379901548-70954-1-git-send-email-linn@hp.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1379901548-70954-1-git-send-email-linn@hp.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Sun, 22 Sep, at 07:59:08PM, Linn Crosetto wrote:
> This patch fixes a problem with EFI memory maps larger than 128 entries
> when booting using the EFI stub, which results in overflowing e820_map
> in boot_params and an eventual halt when checking the map size in
> sanitize_e820_map().
> 
> If the number of map entries is greater than what can fit in e820_map,
> add the extra entries to the setup_data list using type SETUP_E820_EXT.
> These extra entries are then picked up when the setup_data list is
> parsed in parse_e820_ext().
> 
> Signed-off-by: Linn Crosetto <linn@hp.com>
> ---
> Changes from v2:
>  * Removed unnecessary optimization in alloc_e820ext() (Matt Fleming)
>  * Fixed a bug where an incorrect buffer size may be passed to
>    get_memory_map when jumping to get_map
> 
>  arch/x86/boot/compressed/eboot.c | 239 +++++++++++++++++++++++++++------------
>  1 file changed, 167 insertions(+), 72 deletions(-)

Thanks Linn. I applied this to the 'next' branch at,

  git://git.kernel.org/pub/scm/linux/kernel/git/mfleming/efi.git

but it required a bit of massaging to apply on top of the changes
already there. Could you confirm that my changes are OK? I've included
the modified commit below.

---

>From 81c9e1df196ad531edabe726a2d7a610fb04fdd6 Mon Sep 17 00:00:00 2001
From: Linn Crosetto <linn@hp.com>
Date: Sun, 22 Sep 2013 19:59:08 -0600
Subject: [PATCH] x86: EFI stub support for large memory maps

This patch fixes a problem with EFI memory maps larger than 128 entries
when booting using the EFI stub, which results in overflowing e820_map
in boot_params and an eventual halt when checking the map size in
sanitize_e820_map().

If the number of map entries is greater than what can fit in e820_map,
add the extra entries to the setup_data list using type SETUP_E820_EXT.
These extra entries are then picked up when the setup_data list is
parsed in parse_e820_ext().

Signed-off-by: Linn Crosetto <linn@hp.com>
Signed-off-by: Matt Fleming <matt.fleming@intel.com>
---
 arch/x86/boot/compressed/eboot.c | 220 ++++++++++++++++++++++++++++-----------
 1 file changed, 159 insertions(+), 61 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index beb07a4..482006e 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -519,71 +519,47 @@ fail:
 	return NULL;
 }
 
-static efi_status_t exit_boot(struct boot_params *boot_params,
-			      void *handle)
+static void add_e820ext(struct boot_params *params,
+			struct setup_data *e820ext, u32 nr_entries)
 {
-	struct efi_info *efi = &boot_params->efi_info;
-	struct e820entry *e820_map = &boot_params->e820_map[0];
-	struct e820entry *prev = NULL;
-	unsigned long size, key, desc_size, _size;
-	efi_memory_desc_t *mem_map;
+	struct setup_data *data;
 	efi_status_t status;
-	__u32 desc_version;
-	bool called_exit = false;
-	u8 nr_entries;
-	int i;
+	unsigned long size;
 
-get_map:
-	status = efi_get_memory_map(sys_table, &mem_map, &size, &desc_size,
-				    &desc_version, &key);
+	e820ext->type = SETUP_E820_EXT;
+	e820ext->len = nr_entries * sizeof(struct e820entry);
+	e820ext->next = 0;
 
-	if (status != EFI_SUCCESS)
-		return status;
-
-	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
-	efi->efi_systab = (unsigned long)sys_table;
-	efi->efi_memdesc_size = desc_size;
-	efi->efi_memdesc_version = desc_version;
-	efi->efi_memmap = (unsigned long)mem_map;
-	efi->efi_memmap_size = size;
-
-#ifdef CONFIG_X86_64
-	efi->efi_systab_hi = (unsigned long)sys_table >> 32;
-	efi->efi_memmap_hi = (unsigned long)mem_map >> 32;
-#endif
+	data = (struct setup_data *)(unsigned long)params->hdr.setup_data;
 
-	/* Might as well exit boot services now */
-	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
-				handle, key);
-	if (status != EFI_SUCCESS) {
-		/*
-		 * ExitBootServices() will fail if any of the event
-		 * handlers change the memory map. In which case, we
-		 * must be prepared to retry, but only once so that
-		 * we're guaranteed to exit on repeated failures instead
-		 * of spinning forever.
-		 */
-		if (called_exit)
-			goto free_mem_map;
+	while (data && data->next)
+		data = (struct setup_data *)(unsigned long)data->next;
 
-		called_exit = true;
-		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
-		goto get_map;
-	}
+	if (data)
+		data->next = (unsigned long)e820ext;
+	else
+		params->hdr.setup_data = (unsigned long)e820ext;
+}
 
-	/* Historic? */
-	boot_params->alt_mem_k = 32 * 1024;
+static efi_status_t setup_e820(struct boot_params *params,
+			       struct setup_data *e820ext, u32 e820ext_size)
+{
+	struct e820entry *e820_map = &params->e820_map[0];
+	struct efi_info *efi = &params->efi_info;
+	struct e820entry *prev = NULL;
+	u32 nr_entries;
+	u32 nr_desc;
+	int i;
 
-	/*
-	 * Convert the EFI memory map to E820.
-	 */
 	nr_entries = 0;
-	for (i = 0; i < size / desc_size; i++) {
+	nr_desc = efi->efi_memmap_size / efi->efi_memdesc_size;
+
+	for (i = 0; i < nr_desc; i++) {
 		efi_memory_desc_t *d;
 		unsigned int e820_type = 0;
-		unsigned long m = (unsigned long)mem_map;
+		unsigned long m = efi->efi_memmap;
 
-		d = (efi_memory_desc_t *)(m + (i * desc_size));
+		d = (efi_memory_desc_t *)(m + (i * efi->efi_memdesc_size));
 		switch (d->type) {
 		case EFI_RESERVED_TYPE:
 		case EFI_RUNTIME_SERVICES_CODE:
@@ -620,18 +596,140 @@ get_map:
 
 		/* Merge adjacent mappings */
 		if (prev && prev->type == e820_type &&
-		    (prev->addr + prev->size) == d->phys_addr)
+		    (prev->addr + prev->size) == d->phys_addr) {
 			prev->size += d->num_pages << 12;
-		else {
-			e820_map->addr = d->phys_addr;
-			e820_map->size = d->num_pages << 12;
-			e820_map->type = e820_type;
-			prev = e820_map++;
-			nr_entries++;
+			continue;
 		}
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
 	}
 
-	boot_params->e820_entries = nr_entries;
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
+static efi_status_t exit_boot(struct boot_params *boot_params,
+			      void *handle)
+{
+	struct efi_info *efi = &boot_params->efi_info;
+	unsigned long map_sz, key, desc_size;
+	efi_memory_desc_t *mem_map;
+	struct setup_data *e820ext;
+	__u32 e820ext_size;
+	__u32 nr_desc, prev_nr_desc;
+	efi_status_t status;
+	__u32 desc_version;
+	bool called_exit = false;
+	u8 nr_entries;
+	int i;
+
+	nr_desc = 0;
+	e820ext = NULL;
+	e820ext_size = 0;
+
+get_map:
+	status = efi_get_memory_map(sys_table, &mem_map, &map_sz, &desc_size,
+				    &desc_version, &key);
+
+	if (status != EFI_SUCCESS)
+		return status;
+
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
+		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		goto get_map; /* Allocated memory, get map again */
+	}
+
+	memcpy(&efi->efi_loader_signature, EFI_LOADER_SIGNATURE, sizeof(__u32));
+	efi->efi_systab = (unsigned long)sys_table;
+	efi->efi_memdesc_size = desc_size;
+	efi->efi_memdesc_version = desc_version;
+	efi->efi_memmap = (unsigned long)mem_map;
+	efi->efi_memmap_size = map_sz;
+
+#ifdef CONFIG_X86_64
+	efi->efi_systab_hi = (unsigned long)sys_table >> 32;
+	efi->efi_memmap_hi = (unsigned long)mem_map >> 32;
+#endif
+
+	/* Might as well exit boot services now */
+	status = efi_call_phys2(sys_table->boottime->exit_boot_services,
+				handle, key);
+	if (status != EFI_SUCCESS) {
+		/*
+		 * ExitBootServices() will fail if any of the event
+		 * handlers change the memory map. In which case, we
+		 * must be prepared to retry, but only once so that
+		 * we're guaranteed to exit on repeated failures instead
+		 * of spinning forever.
+		 */
+		if (called_exit)
+			goto free_mem_map;
+
+		called_exit = true;
+		efi_call_phys1(sys_table->boottime->free_pool, mem_map);
+		goto get_map;
+	}
+
+	/* Historic? */
+	boot_params->alt_mem_k = 32 * 1024;
+
+	status = setup_e820(boot_params, e820ext, e820ext_size);
 
 	return EFI_SUCCESS;
 
-- 
1.8.1.4


-- 
Matt Fleming, Intel Open Source Technology Center
