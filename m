Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754258Ab3KZGAH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 01:00:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:56492 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753121Ab3KZGAA (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 01:00:00 -0500
From: Dave Young <dyoung@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: linux-efi@vger.kernel.org, x86@kernel.org, mjg59@srcf.ucam.org,
        hpa@zytor.com, James.Bottomley@HansenPartnership.com,
        vgoyal@redhat.com, ebiederm@xmission.com, horms@verge.net.au,
        kexec@lists.infradead.org, bp@alien8.de, greg@kroah.com,
        matt@console-pimps.org, toshi.kani@hp.com
Subject: [PATCH v4 07/12] efi: passing kexec necessary efi data via setup_data
Date: Tue, 26 Nov 2013 13:57:52 +0800
Message-Id: <1385445477-9665-8-git-send-email-dyoung@redhat.com>
In-Reply-To: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
References: <1385445477-9665-1-git-send-email-dyoung@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a new setup_data type SETUP_EFI for kexec use.
Passing the saved fw_vendor, runtime, config tables and
efi runtime mappings.

When entering virtual mode, directly mapping the efi
runtime ragions which we passed in previously. And skip
the step to call SetVirtualAddressMap.

Specially for HP z420 workstation it need another variable
saving, it's the smbios physical address, the HP bios
also update the SMBIOS address after entering virtual mode
besides of the standard fw_vendor,runtime and config table.

Tested on ovmf+qemu, lenovo thinkpad, a dell laptop and an
HP z420 workstation.

v2: refresh based on previous patch changes, code cleanup.
v3: use ioremap instead of phys_to_virt for esdata

Signed-off-by: Dave Young <dyoung@redhat.com>
---
 arch/x86/include/asm/efi.h            |  12 +++
 arch/x86/include/uapi/asm/bootparam.h |   1 +
 arch/x86/kernel/setup.c               |   3 +
 arch/x86/platform/efi/efi.c           | 161 ++++++++++++++++++++++++++++++----
 4 files changed, 160 insertions(+), 17 deletions(-)

diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 9fbaeb2..73d5643 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -133,6 +133,18 @@ extern void efi_sync_low_kernel_mappings(void);
 extern void efi_setup_page_tables(void);
 extern void __init old_map_region(efi_memory_desc_t *md);
 
+struct efi_setup_data {
+	u64 fw_vendor;
+	u64 runtime;
+	u64 tables;
+	u64 smbios;
+	u64 reserved[8];
+	efi_memory_desc_t map[0];
+};
+
+extern void parse_efi_setup(u64 phys_addr, u32 data_len);
+extern struct efi_setup_data *esdata;
+
 #ifdef CONFIG_EFI
 
 static inline bool efi_is_native(void)
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index c15ddaf..ed6afc9 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -6,6 +6,7 @@
 #define SETUP_E820_EXT			1
 #define SETUP_DTB			2
 #define SETUP_PCI			3
+#define SETUP_EFI			4
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index f0de629..ecf225e 100644
--- a/arch/x86/kernel/setup.c
+++ b/arch/x86/kernel/setup.c
@@ -447,6 +447,9 @@ static void __init parse_setup_data(void)
 		case SETUP_DTB:
 			add_dtb(pa_data);
 			break;
+		case SETUP_EFI:
+			parse_efi_setup(pa_data, data_len);
+			break;
 		default:
 			break;
 		}
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index c3a2aaa..fafeb40 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -78,6 +78,7 @@ static __initdata efi_config_table_type_t arch_tables[] = {
 
 void *efi_runtime_map;
 int nr_efi_runtime_map;
+struct efi_setup_data *esdata;
 
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
@@ -115,6 +116,32 @@ static int __init setup_storage_paranoia(char *arg)
 }
 early_param("efi_no_storage_paranoia", setup_storage_paranoia);
 
+void __init parse_efi_setup(u64 phys_addr, u32 data_len)
+{
+	int size;
+	struct setup_data *sdata;
+	u64 esdata_phys;
+
+	if (!efi_enabled(EFI_64BIT)) {
+		pr_warn("skipping setup_data on EFI 32BIT!");
+		return;
+	}
+
+	sdata = early_memremap(phys_addr, data_len);
+	if (!sdata)
+		return;
+
+	size = data_len - sizeof(struct setup_data);
+
+	esdata_phys = phys_addr + sizeof(struct setup_data);
+
+	nr_efi_runtime_map = (size - sizeof(struct efi_setup_data)) /
+			sizeof(efi_memory_desc_t);
+	early_iounmap(sdata, data_len);
+
+	/* iounmap esdata in function efi_enter_virtual_mode */
+	esdata = early_memremap(esdata_phys, size);
+}
 
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
@@ -504,8 +531,12 @@ static int __init efi_systab_init(void *phys)
 		}
 
 		efi_systab.hdr = systab64->hdr;
-		efi_systab.fw_vendor = systab64->fw_vendor;
-		tmp |= systab64->fw_vendor;
+
+		if (esdata)
+			efi_systab.fw_vendor = (unsigned long)esdata->fw_vendor;
+		else
+			efi_systab.fw_vendor = systab64->fw_vendor;
+		tmp |= efi_systab.fw_vendor;
 		efi_systab.fw_revision = systab64->fw_revision;
 		efi_systab.con_in_handle = systab64->con_in_handle;
 		tmp |= systab64->con_in_handle;
@@ -519,13 +550,21 @@ static int __init efi_systab_init(void *phys)
 		tmp |= systab64->stderr_handle;
 		efi_systab.stderr = systab64->stderr;
 		tmp |= systab64->stderr;
-		efi_systab.runtime = (void *)(unsigned long)systab64->runtime;
-		tmp |= systab64->runtime;
+		if (esdata)
+			efi_systab.runtime =
+				(void *)(unsigned long)esdata->runtime;
+		else
+			efi_systab.runtime =
+				(void *)(unsigned long)systab64->runtime;
+		tmp |= (unsigned long)efi_systab.runtime;
 		efi_systab.boottime = (void *)(unsigned long)systab64->boottime;
 		tmp |= systab64->boottime;
 		efi_systab.nr_tables = systab64->nr_tables;
-		efi_systab.tables = systab64->tables;
-		tmp |= systab64->tables;
+		if (esdata)
+			efi_systab.tables = (unsigned long)esdata->tables;
+		else
+			efi_systab.tables = systab64->tables;
+		tmp |= efi_systab.tables;
 
 		early_iounmap(systab64, sizeof(*systab64));
 #ifdef CONFIG_X86_32
@@ -631,6 +670,41 @@ static int __init efi_memmap_init(void)
 	return 0;
 }
 
+static int __init efi_reuse_config(u64 tables, int nr_tables)
+{
+	void *p, *tablep;
+	int i, sz;
+
+	if (!efi_enabled(EFI_64BIT))
+		return 0;
+
+	sz = sizeof(efi_config_table_64_t);
+
+	p = tablep = early_memremap(tables, nr_tables * sz);
+	if (!p) {
+		pr_err("Could not map Configuration table!\n");
+		return -ENOMEM;
+	}
+
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		efi_guid_t guid;
+
+		guid = ((efi_config_table_64_t *)p)->guid;
+
+		/*
+		HP z420 workstation smbios will be convert to
+		virtual address after enter virtual mode.
+		Thus in case kexec/kdump the physical address
+		will be passed in setup_data.
+		*/
+		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
+			((efi_config_table_64_t *)p)->table = esdata->smbios;
+		p += sz;
+	}
+	early_iounmap(tablep, nr_tables * sz);
+	return 0;
+}
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -676,6 +750,9 @@ void __init efi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
 
+	if (esdata && esdata->smbios)
+		efi_reuse_config(efi.systab->tables, efi.systab->nr_tables);
+
 	if (efi_config_init(arch_tables))
 		return;
 
@@ -886,6 +963,43 @@ ret:
 }
 
 /*
+ * map efi regions which was passed via setup_data
+ * the virt_addr is a fixed addr which was used in
+ * 1st kernel of kexec boot.
+ */
+static void __init efi_map_regions_fixed(void)
+{
+	int i;
+	unsigned long size;
+	efi_memory_desc_t *md;
+	u64 end, systab;
+	void *p;
+
+	efi_runtime_map = kzalloc(nr_efi_runtime_map * memmap.desc_size,
+				GFP_KERNEL);
+	if (!efi_runtime_map)
+		pr_err("Out of memory, EFI runtime on nested kexec non-functional!\n");
+
+	for (i = 0, p = efi_runtime_map; i < nr_efi_runtime_map; i++) {
+		md = esdata->map + i;
+		efi_map_region_fixed(md);
+		size = md->num_pages << PAGE_SHIFT;
+		end = md->phys_addr + size;
+
+		systab = (u64) (unsigned long) efi_phys.systab;
+		if (md->phys_addr <= systab && systab < end) {
+			systab += md->virt_addr - md->phys_addr;
+			efi.systab =
+				(efi_system_table_t *) (unsigned long) systab;
+		}
+		if (efi_runtime_map) {
+			memcpy(p, md, memmap.desc_size);
+			p += memmap.desc_size;
+		}
+	}
+}
+
+/*
  * This function will switch the EFI runtime services to virtual mode.
  * Essentially, we look through the EFI memmap and map every region that
  * has the runtime attribute bit set in its memory descriptor into the
@@ -901,6 +1015,10 @@ ret:
  * so that we're in a different address space when calling a runtime
  * function. For function arguments passing we do copy the PGDs of the
  * kernel page table into ->trampoline_pgd prior to each call.
+ *
+ * Specially for kexec boot efi runtime maps in previous kernel should
+ * be passed in via setup_data. In that case runtime ranges will be mapped
+ * to fixed virtual addresses exactly same as the ones in previous kernel.
  */
 void __init efi_enter_virtual_mode(void)
 {
@@ -919,12 +1037,15 @@ void __init efi_enter_virtual_mode(void)
 		return;
 	}
 
-	efi_merge_regions();
-
-	new_memmap = efi_map_regions(&count);
-	if (!new_memmap) {
-		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
-		return;
+	if (esdata)
+		efi_map_regions_fixed();
+	else {
+		efi_merge_regions();
+		new_memmap = efi_map_regions(&count);
+		if (!new_memmap) {
+			pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+			return;
+		}
 	}
 
 	BUG_ON(!efi.systab);
@@ -932,11 +1053,17 @@ void __init efi_enter_virtual_mode(void)
 	efi_setup_page_tables();
 	efi_sync_low_kernel_mappings();
 
-	status = phys_efi_set_virtual_address_map(
-		memmap.desc_size * count,
-		memmap.desc_size,
-		memmap.desc_version,
-		(efi_memory_desc_t *)__pa(new_memmap));
+	if (esdata) {
+		status = EFI_SUCCESS;
+		early_iounmap(esdata, sizeof(struct efi_setup_data) +
+			      nr_efi_runtime_map *
+			      sizeof(efi_memory_desc_t));
+	} else
+		status = phys_efi_set_virtual_address_map(
+			memmap.desc_size * count,
+			memmap.desc_size,
+			memmap.desc_version,
+			(efi_memory_desc_t *)__pa(new_memmap));
 
 	if (status != EFI_SUCCESS) {
 		pr_alert("Unable to switch EFI into virtual mode "
-- 
1.8.3.1

