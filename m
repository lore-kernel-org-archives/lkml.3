Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751248Ab3HSUBx (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 16:01:53 -0400
Received: from g6t0187.atlanta.hp.com ([15.193.32.64]:11922 "EHLO
	g6t0187.atlanta.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751274Ab3HSUBI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 16:01:08 -0400
From: Linn Crosetto <linn@hp.com>
To: matt.fleming@intel.com, hpa@zytor.com, tglx@linutronix.de,
        mingo@redhat.com, x86@kernel.org, yinghai@kernel.org,
        penberg@kernel.org, jacob.shin@amd.com, linux-efi@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Linn Crosetto <linn@hp.com>
Subject: [RFC PATCH 4/4] x86: Fix EFI boot stub for large memory maps
Date: Mon, 19 Aug 2013 14:00:19 -0600
Message-Id: <1376942419-5684-5-git-send-email-linn@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1376942419-5684-1-git-send-email-linn@hp.com>
References: <1376942419-5684-1-git-send-email-linn@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds support for EFI memory maps larger than 128 entries when
booted using the EFI boot stub.

The e820 map in struct boot_params can only hold 128 entries, but the
memory map provided by EFI may be larger. If the map contained more than
128 entries, exit_boot() would write beyond the e820_map array in
boot_params and the system would eventually halt in the BUG_ON check in
sanitize_e820_map().

In the case we come in through efi_main(), the EFI memory map is used.
Instead of populating e820_map in boot_params, create the e820 from the
EFI memory map in setup_arch() via a memory_setup hook.

The EFI memory map may also be added in efi_init() if the command line
parameter "add_efi_memmap" is specified. This is left intact to allow
the command line parameter to remain effective.

Signed-off-by: Linn Crosetto <linn@hp.com>
---
 arch/x86/boot/compressed/eboot.c | 64 ++--------------------------------------
 arch/x86/kernel/setup.c          |  3 ++
 2 files changed, 6 insertions(+), 61 deletions(-)

diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index b7388a4..66b8d3d 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -973,6 +973,9 @@ struct boot_params *make_boot_params(void *handle, efi_system_table_t *_table)
 	if (status != EFI_SUCCESS)
 		goto fail2;
 
+	/* Use EFI memory map */
+	boot_params->e820_entries = 0;
+
 	return boot_params;
 fail2:
 	if (options_size)
@@ -986,8 +989,6 @@ static efi_status_t exit_boot(struct boot_params *boot_params,
 			      void *handle)
 {
 	struct efi_info *efi = &boot_params->efi_info;
-	struct e820entry *e820_map = &boot_params->e820_map[0];
-	struct e820entry *prev = NULL;
 	unsigned long size, key, desc_size, _size;
 	efi_memory_desc_t *mem_map;
 	efi_status_t status;
@@ -1049,65 +1050,6 @@ get_map:
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
-
 	return EFI_SUCCESS;
 
 free_mem_map:
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f8ec578..9682c8c 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -920,6 +920,9 @@ void __init setup_arch(char **cmdline_p)
 
 	if (efi_enabled(EFI_BOOT))
 		efi_memblock_x86_reserve_range();
+
+	if (efi_memmap_needed())
+		x86_init.resources.memory_setup = efi_memory_setup;
 #endif
 
 	x86_init.oem.arch_setup();
-- 
1.7.11.3

