Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932737AbaJVVNL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Oct 2014 17:13:11 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58350 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932210AbaJVVNI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Oct 2014 17:13:08 -0400
Date: Wed, 22 Oct 2014 14:11:18 -0700
Message-Id: <201410222111.s9MLBIQi012124@terminus.zytor.com>
From: "H. Peter Anvin" <hpa@linux.intel.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Subject: [GIT PULL] x86/efi for v3.18-rc2
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset="UTF-8"
Cc: a.zummo@towertech.it, andre.muller@web.de, ard.biesheuvel@linaro.org,
        bp@suse.de, dyoung@redhat.com, hpa@zytor.com,
        jeffrey.t.kirsher@intel.com, josh@joshtriplett.org,
        leif.lindholm@linaro.org, lersek@redhat.com,
        linux-kernel@vger.kernel.org, linux.bug.reporting@gmail.com,
        m.b.lankhorst@gmail.com, mark.d.rustad@intel.com,
        matt.fleming@intel.com, mingo@kernel.org, minipli@googlemail.com,
        mjg59@srcf.ucam.org, msalter@redhat.com, peterz@infradead.org,
        pj@sgi.com, roy.franz@linaro.org, tglx@linutronix.de, ulf@winkelvos.de,
        will.deacon@arm.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

This patchset falls under the "maintainers that grovel" clause in the
v3.18-rc1 announcement.  We had intended to push it late in the merge
window since we got it into the -tip tree relatively late.

Many of these are relatively simple things, but there are a couple of
key bits, especially Ard's and Matt's patches as listed below.

	-hpa

The following changes since commit fe82dcec644244676d55a1384c958d5f67979adb:

  Linux 3.17-rc7 (2014-09-28 14:29:07 -0700)

are available in the git repository at:

  git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-for-linus

for you to fetch changes up to 75b128573b275d5a5a7210b98c4b8cb3b39c12e7:

  Merge branch 'next' into efi-next-merge (2014-10-03 22:15:56 +0100)

----------------------------------------------------------------

Andre Müller (1):
      x86/efi: Adding efi_printks on memory allocationa and pci.reads

Ard Biesheuvel (2):
      efi: Implement mandatory locking for UEFI Runtime Services
      efi: rtc-efi: Export platform:rtc-efi as module alias

Dave Young (6):
      efi: Move noefi early param code out of x86 arch code
      lib: Add a generic cmdline parse function parse_option_str
      efi: Add kernel param efi=noruntime
      arm64/efi: uefi_init error handling fix
      arm64/efi: Do not enter virtual mode if booting with efi=noruntime or noefi
      x86/efi: Clear EFI_RUNTIME_SERVICES if failing to enter virtual mode

Josh Triplett (1):
      efi-bgrt: Add error handling; inform the user when ignoring the BGRT

Laszlo Ersek (5):
      efi: Add macro for EFI_MEMORY_UCE memory attribute
      efi: Introduce efi_md_typeattr_format()
      x86: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      ia64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()
      arm64: efi: Format EFI memory type & attrs with efi_md_typeattr_format()

Mark Rustad (1):
      efi: Resolve some shadow warnings

Mathias Krause (4):
      x86/efi: Remove unused efi_call* macros
      x86/efi: Unexport add_efi_memmap variable
      x86/efi: Update comment regarding required phys mapped EFI services
      x86/efi: Mark initialization code as such

Matt Fleming (5):
      efi: Add efi= parameter parsing to the EFI boot stub
      efi: Provide a non-blocking SetVariable() operation
      efi: Delete the in_nmi() conditional runtime locking
      rtc: Disable EFI rtc for x86
      Merge branch 'next' into efi-next-merge

 Documentation/kernel-parameters.txt            |   8 +-
 arch/arm64/kernel/efi.c                        |  44 +++----
 arch/ia64/kernel/efi.c                         |   6 +-
 arch/x86/boot/compressed/eboot.c               |  32 +++--
 arch/x86/include/asm/efi.h                     |  31 ++---
 arch/x86/platform/efi/efi-bgrt.c               |  36 +++++-
 arch/x86/platform/efi/efi.c                    |  52 ++++----
 arch/x86/platform/efi/efi_32.c                 |  12 +-
 arch/x86/platform/efi/efi_64.c                 |   6 +-
 arch/x86/platform/efi/efi_stub_32.S            |   4 +-
 drivers/firmware/efi/efi.c                     |  79 ++++++++++++
 drivers/firmware/efi/libstub/arm-stub.c        |   4 +
 drivers/firmware/efi/libstub/efi-stub-helper.c |  62 +++++++++-
 drivers/firmware/efi/runtime-wrappers.c        | 164 +++++++++++++++++++++++--
 drivers/firmware/efi/vars.c                    |  61 +++++++--
 drivers/rtc/Kconfig                            |   2 +-
 drivers/rtc/rtc-efi.c                          |   1 +
 include/linux/efi.h                            |  17 +++
 include/linux/kernel.h                         |   1 +
 lib/cmdline.c                                  |  29 +++++
 20 files changed, 528 insertions(+), 123 deletions(-)

diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index 10d51c2..b5e55aa 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -992,10 +992,14 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 			Format: {"off" | "on" | "skip[mbr]"}
 
 	efi=		[EFI]
-			Format: { "old_map" }
+			Format: { "old_map", "nochunk", "noruntime" }
 			old_map [X86-64]: switch to the old ioremap-based EFI
 			runtime services mapping. 32-bit still uses this one by
 			default.
+			nochunk: disable reading files in "chunks" in the EFI
+			boot stub, as chunking can cause problems with some
+			firmware implementations.
+			noruntime : disable EFI runtime services support
 
 	efi_no_storage_paranoia [EFI; X86]
 			Using this parameter you can use more than 50% of
@@ -2166,7 +2170,7 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 
 	nodsp		[SH] Disable hardware DSP at boot time.
 
-	noefi		[X86] Disable EFI runtime services support.
+	noefi		Disable EFI runtime services support.
 
 	noexec		[IA-64]
 
diff --git a/arch/arm64/kernel/efi.c b/arch/arm64/kernel/efi.c
index 03aaa99..95c49eb 100644
--- a/arch/arm64/kernel/efi.c
+++ b/arch/arm64/kernel/efi.c
@@ -89,7 +89,8 @@ static int __init uefi_init(void)
 	 */
 	if (efi.systab->hdr.signature != EFI_SYSTEM_TABLE_SIGNATURE) {
 		pr_err("System table signature incorrect\n");
-		return -EINVAL;
+		retval = -EINVAL;
+		goto out;
 	}
 	if ((efi.systab->hdr.revision >> 16) < 2)
 		pr_warn("Warning: EFI system table version %d.%02d, expected 2.00 or greater\n",
@@ -103,6 +104,7 @@ static int __init uefi_init(void)
 		for (i = 0; i < (int) sizeof(vendor) - 1 && *c16; ++i)
 			vendor[i] = c16[i];
 		vendor[i] = '\0';
+		early_memunmap(c16, sizeof(vendor));
 	}
 
 	pr_info("EFI v%u.%.02u by %s\n",
@@ -113,29 +115,11 @@ static int __init uefi_init(void)
 	if (retval == 0)
 		set_bit(EFI_CONFIG_TABLES, &efi.flags);
 
-	early_memunmap(c16, sizeof(vendor));
+out:
 	early_memunmap(efi.systab,  sizeof(efi_system_table_t));
-
 	return retval;
 }
 
-static __initdata char memory_type_name[][32] = {
-	{"Reserved"},
-	{"Loader Code"},
-	{"Loader Data"},
-	{"Boot Code"},
-	{"Boot Data"},
-	{"Runtime Code"},
-	{"Runtime Data"},
-	{"Conventional Memory"},
-	{"Unusable Memory"},
-	{"ACPI Reclaim Memory"},
-	{"ACPI Memory NVS"},
-	{"Memory Mapped I/O"},
-	{"MMIO Port Space"},
-	{"PAL Code"},
-};
-
 /*
  * Return true for RAM regions we want to permanently reserve.
  */
@@ -166,10 +150,13 @@ static __init void reserve_regions(void)
 		paddr = md->phys_addr;
 		npages = md->num_pages;
 
-		if (uefi_debug)
-			pr_info("  0x%012llx-0x%012llx [%s]",
+		if (uefi_debug) {
+			char buf[64];
+
+			pr_info("  0x%012llx-0x%012llx %s",
 				paddr, paddr + (npages << EFI_PAGE_SHIFT) - 1,
-				memory_type_name[md->type]);
+				efi_md_typeattr_format(buf, sizeof(buf), md));
+		}
 
 		memrange_efi_to_native(&paddr, &npages);
 		size = npages << PAGE_SHIFT;
@@ -393,11 +380,16 @@ static int __init arm64_enter_virtual_mode(void)
 		return -1;
 	}
 
-	pr_info("Remapping and enabling EFI services.\n");
-
-	/* replace early memmap mapping with permanent mapping */
 	mapsize = memmap.map_end - memmap.map;
 	early_memunmap(memmap.map, mapsize);
+
+	if (efi_runtime_disabled()) {
+		pr_info("EFI runtime services will be disabled.\n");
+		return -1;
+	}
+
+	pr_info("Remapping and enabling EFI services.\n");
+	/* replace early memmap mapping with permanent mapping */
 	memmap.map = (__force void *)ioremap_cache((phys_addr_t)memmap.phys_map,
 						   mapsize);
 	memmap.map_end = memmap.map + mapsize;
diff --git a/arch/ia64/kernel/efi.c b/arch/ia64/kernel/efi.c
index 741b99c..c52d754 100644
--- a/arch/ia64/kernel/efi.c
+++ b/arch/ia64/kernel/efi.c
@@ -568,6 +568,7 @@ efi_init (void)
 		{
 			const char *unit;
 			unsigned long size;
+			char buf[64];
 
 			md = p;
 			size = md->num_pages << EFI_PAGE_SHIFT;
@@ -586,9 +587,10 @@ efi_init (void)
 				unit = "KB";
 			}
 
-			printk("mem%02d: type=%2u, attr=0x%016lx, "
+			printk("mem%02d: %s "
 			       "range=[0x%016lx-0x%016lx) (%4lu%s)\n",
-			       i, md->type, md->attribute, md->phys_addr,
+			       i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			       md->phys_addr,
 			       md->phys_addr + efi_md_size(md), size, unit);
 		}
 	}
diff --git a/arch/x86/boot/compressed/eboot.c b/arch/x86/boot/compressed/eboot.c
index de8eebd..1acf605 100644
--- a/arch/x86/boot/compressed/eboot.c
+++ b/arch/x86/boot/compressed/eboot.c
@@ -330,8 +330,10 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 	size = pci->romsize + sizeof(*rom);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for rom\n");
 		return status;
+	}
 
 	memset(rom, 0, sizeof(*rom));
 
@@ -344,14 +346,18 @@ __setup_efi_pci32(efi_pci_io_protocol_32 *pci, struct pci_setup_rom **__rom)
 	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_VENDOR_ID, 1, &(rom->vendor));
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->vendor\n");
 		goto free_struct;
+	}
 
 	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_DEVICE_ID, 1, &(rom->devid));
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->devid\n");
 		goto free_struct;
+	}
 
 	status = efi_early->call(pci->get_location, pci, &(rom->segment),
 				 &(rom->bus), &(rom->device), &(rom->function));
@@ -432,8 +438,10 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
 	size = pci->romsize + sizeof(*rom);
 
 	status = efi_call_early(allocate_pool, EFI_LOADER_DATA, size, &rom);
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to alloc mem for rom\n");
 		return status;
+	}
 
 	rom->data.type = SETUP_PCI;
 	rom->data.len = size - sizeof(struct setup_data);
@@ -444,14 +452,18 @@ __setup_efi_pci64(efi_pci_io_protocol_64 *pci, struct pci_setup_rom **__rom)
 	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_VENDOR_ID, 1, &(rom->vendor));
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->vendor\n");
 		goto free_struct;
+	}
 
 	status = efi_early->call(pci->pci.read, pci, EfiPciIoWidthUint16,
 				 PCI_DEVICE_ID, 1, &(rom->devid));
 
-	if (status != EFI_SUCCESS)
+	if (status != EFI_SUCCESS) {
+		efi_printk(sys_table, "Failed to read rom->devid\n");
 		goto free_struct;
+	}
 
 	status = efi_early->call(pci->get_location, pci, &(rom->segment),
 				 &(rom->bus), &(rom->device), &(rom->function));
@@ -538,8 +550,10 @@ static void setup_efi_pci(struct boot_params *params)
 					EFI_LOADER_DATA,
 					size, (void **)&pci_handle);
 
-		if (status != EFI_SUCCESS)
+		if (status != EFI_SUCCESS) {
+			efi_printk(sys_table, "Failed to alloc mem for pci_handle\n");
 			return;
+		}
 
 		status = efi_call_early(locate_handle,
 					EFI_LOCATE_BY_PROTOCOL, &pci_proto,
@@ -1105,6 +1119,10 @@ struct boot_params *make_boot_params(struct efi_config *c)
 
 	memset(sdt, 0, sizeof(*sdt));
 
+	status = efi_parse_options(cmdline_ptr);
+	if (status != EFI_SUCCESS)
+		goto fail2;
+
 	status = handle_cmdline_files(sys_table, image,
 				      (char *)(unsigned long)hdr->cmd_line_ptr,
 				      "initrd=", hdr->initrd_addr_max,
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 0ec241e..9b11757 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -81,24 +81,23 @@ extern u64 asmlinkage efi_call(void *fp, ...);
  */
 #define __efi_call_virt(f, args...) efi_call_virt(f, args)
 
-extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
-				 u32 type, u64 attribute);
+extern void __iomem *__init efi_ioremap(unsigned long addr, unsigned long size,
+					u32 type, u64 attribute);
 
 #endif /* CONFIG_X86_32 */
 
-extern int add_efi_memmap;
 extern struct efi_scratch efi_scratch;
-extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
-extern int efi_memblock_x86_reserve_range(void);
-extern void efi_call_phys_prelog(void);
-extern void efi_call_phys_epilog(void);
-extern void efi_unmap_memmap(void);
-extern void efi_memory_uc(u64 addr, unsigned long size);
+extern void __init efi_set_executable(efi_memory_desc_t *md, bool executable);
+extern int __init efi_memblock_x86_reserve_range(void);
+extern void __init efi_call_phys_prolog(void);
+extern void __init efi_call_phys_epilog(void);
+extern void __init efi_unmap_memmap(void);
+extern void __init efi_memory_uc(u64 addr, unsigned long size);
 extern void __init efi_map_region(efi_memory_desc_t *md);
 extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
 extern void efi_sync_low_kernel_mappings(void);
-extern int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
-extern void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
+extern int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages);
+extern void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages);
 extern void __init old_map_region(efi_memory_desc_t *md);
 extern void __init runtime_code_page_mkexec(void);
 extern void __init efi_runtime_mkexec(void);
@@ -162,16 +161,6 @@ static inline efi_status_t efi_thunk_set_virtual_address_map(
 extern bool efi_reboot_required(void);
 
 #else
-/*
- * IF EFI is not configured, have the EFI calls return -ENOSYS.
- */
-#define efi_call0(_f)					(-ENOSYS)
-#define efi_call1(_f, _a1)				(-ENOSYS)
-#define efi_call2(_f, _a1, _a2)				(-ENOSYS)
-#define efi_call3(_f, _a1, _a2, _a3)			(-ENOSYS)
-#define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
-#define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
-#define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
 static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
 static inline bool efi_reboot_required(void)
 {
diff --git a/arch/x86/platform/efi/efi-bgrt.c b/arch/x86/platform/efi/efi-bgrt.c
index f15103d..d143d21 100644
--- a/arch/x86/platform/efi/efi-bgrt.c
+++ b/arch/x86/platform/efi/efi-bgrt.c
@@ -40,20 +40,40 @@ void __init efi_bgrt_init(void)
 	if (ACPI_FAILURE(status))
 		return;
 
-	if (bgrt_tab->header.length < sizeof(*bgrt_tab))
+	if (bgrt_tab->header.length < sizeof(*bgrt_tab)) {
+		pr_err("Ignoring BGRT: invalid length %u (expected %zu)\n",
+		       bgrt_tab->header.length, sizeof(*bgrt_tab));
 		return;
-	if (bgrt_tab->version != 1 || bgrt_tab->status != 1)
+	}
+	if (bgrt_tab->version != 1) {
+		pr_err("Ignoring BGRT: invalid version %u (expected 1)\n",
+		       bgrt_tab->version);
+		return;
+	}
+	if (bgrt_tab->status != 1) {
+		pr_err("Ignoring BGRT: invalid status %u (expected 1)\n",
+		       bgrt_tab->status);
+		return;
+	}
+	if (bgrt_tab->image_type != 0) {
+		pr_err("Ignoring BGRT: invalid image type %u (expected 0)\n",
+		       bgrt_tab->image_type);
 		return;
-	if (bgrt_tab->image_type != 0 || !bgrt_tab->image_address)
+	}
+	if (!bgrt_tab->image_address) {
+		pr_err("Ignoring BGRT: null image address\n");
 		return;
+	}
 
 	image = efi_lookup_mapped_addr(bgrt_tab->image_address);
 	if (!image) {
 		image = early_memremap(bgrt_tab->image_address,
 				       sizeof(bmp_header));
 		ioremapped = true;
-		if (!image)
+		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image header memory\n");
 			return;
+		}
 	}
 
 	memcpy_fromio(&bmp_header, image, sizeof(bmp_header));
@@ -61,14 +81,18 @@ void __init efi_bgrt_init(void)
 		early_iounmap(image, sizeof(bmp_header));
 	bgrt_image_size = bmp_header.size;
 
-	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL);
-	if (!bgrt_image)
+	bgrt_image = kmalloc(bgrt_image_size, GFP_KERNEL | __GFP_NOWARN);
+	if (!bgrt_image) {
+		pr_err("Ignoring BGRT: failed to allocate memory for image (wanted %zu bytes)\n",
+		       bgrt_image_size);
 		return;
+	}
 
 	if (ioremapped) {
 		image = early_memremap(bgrt_tab->image_address,
 				       bmp_header.size);
 		if (!image) {
+			pr_err("Ignoring BGRT: failed to map image memory\n");
 			kfree(bgrt_image);
 			bgrt_image = NULL;
 			return;
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index 850da94..dbc8627 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -70,17 +70,7 @@ static efi_config_table_type_t arch_tables[] __initdata = {
 
 u64 efi_setup;		/* efi setup_data physical address */
 
-static bool disable_runtime __initdata = false;
-static int __init setup_noefi(char *arg)
-{
-	disable_runtime = true;
-	return 0;
-}
-early_param("noefi", setup_noefi);
-
-int add_efi_memmap;
-EXPORT_SYMBOL(add_efi_memmap);
-
+static int add_efi_memmap __initdata;
 static int __init setup_add_efi_memmap(char *arg)
 {
 	add_efi_memmap = 1;
@@ -96,7 +86,7 @@ static efi_status_t __init phys_efi_set_virtual_address_map(
 {
 	efi_status_t status;
 
-	efi_call_phys_prelog();
+	efi_call_phys_prolog();
 	status = efi_call_phys(efi_phys.set_virtual_address_map,
 			       memory_map_size, descriptor_size,
 			       descriptor_version, virtual_map);
@@ -210,9 +200,12 @@ static void __init print_efi_memmap(void)
 	for (p = memmap.map, i = 0;
 	     p < memmap.map_end;
 	     p += memmap.desc_size, i++) {
+		char buf[64];
+
 		md = p;
-		pr_info("mem%02u: type=%u, attr=0x%llx, range=[0x%016llx-0x%016llx) (%lluMB)\n",
-			i, md->type, md->attribute, md->phys_addr,
+		pr_info("mem%02u: %s range=[0x%016llx-0x%016llx) (%lluMB)\n",
+			i, efi_md_typeattr_format(buf, sizeof(buf), md),
+			md->phys_addr,
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
@@ -344,9 +337,9 @@ static int __init efi_runtime_init32(void)
 	}
 
 	/*
-	 * We will only need *early* access to the following two
-	 * EFI runtime services before set_virtual_address_map
-	 * is invoked.
+	 * We will only need *early* access to the SetVirtualAddressMap
+	 * EFI runtime service. All other runtime services will be called
+	 * via the virtual mapping.
 	 */
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
@@ -368,9 +361,9 @@ static int __init efi_runtime_init64(void)
 	}
 
 	/*
-	 * We will only need *early* access to the following two
-	 * EFI runtime services before set_virtual_address_map
-	 * is invoked.
+	 * We will only need *early* access to the SetVirtualAddressMap
+	 * EFI runtime service. All other runtime services will be called
+	 * via the virtual mapping.
 	 */
 	efi_phys.set_virtual_address_map =
 			(efi_set_virtual_address_map_t *)
@@ -492,7 +485,7 @@ void __init efi_init(void)
 	if (!efi_runtime_supported())
 		pr_info("No EFI runtime due to 32/64-bit mismatch with kernel\n");
 	else {
-		if (disable_runtime || efi_runtime_init())
+		if (efi_runtime_disabled() || efi_runtime_init())
 			return;
 	}
 	if (efi_memmap_init())
@@ -537,7 +530,7 @@ void __init runtime_code_page_mkexec(void)
 	}
 }
 
-void efi_memory_uc(u64 addr, unsigned long size)
+void __init efi_memory_uc(u64 addr, unsigned long size)
 {
 	unsigned long page_shift = 1UL << EFI_PAGE_SHIFT;
 	u64 npages;
@@ -732,6 +725,7 @@ static void __init kexec_enter_virtual_mode(void)
 	 */
 	if (!efi_is_native()) {
 		efi_unmap_memmap();
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
 
@@ -805,6 +799,7 @@ static void __init __efi_enter_virtual_mode(void)
 	new_memmap = efi_map_regions(&count, &pg_shift);
 	if (!new_memmap) {
 		pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
 	}
 
@@ -812,8 +807,10 @@ static void __init __efi_enter_virtual_mode(void)
 
 	BUG_ON(!efi.systab);
 
-	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift))
+	if (efi_setup_page_tables(__pa(new_memmap), 1 << pg_shift)) {
+		clear_bit(EFI_RUNTIME_SERVICES, &efi.flags);
 		return;
+	}
 
 	efi_sync_low_kernel_mappings();
 	efi_dump_pagetable();
@@ -938,14 +935,11 @@ u64 efi_mem_attributes(unsigned long phys_addr)
 	return 0;
 }
 
-static int __init parse_efi_cmdline(char *str)
+static int __init arch_parse_efi_cmdline(char *str)
 {
-	if (*str == '=')
-		str++;
-
-	if (!strncmp(str, "old_map", 7))
+	if (parse_option_str(str, "old_map"))
 		set_bit(EFI_OLD_MEMMAP, &efi.flags);
 
 	return 0;
 }
-early_param("efi", parse_efi_cmdline);
+early_param("efi", arch_parse_efi_cmdline);
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 9ee3491..40e7cda 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -33,7 +33,7 @@
 
 /*
  * To make EFI call EFI runtime service in physical addressing mode we need
- * prelog/epilog before/after the invocation to disable interrupt, to
+ * prolog/epilog before/after the invocation to disable interrupt, to
  * claim EFI runtime service handler exclusively and to duplicate a memory in
  * low memory space say 0 - 3G.
  */
@@ -41,11 +41,13 @@ static unsigned long efi_rt_eflags;
 
 void efi_sync_low_kernel_mappings(void) {}
 void __init efi_dump_pagetable(void) {}
-int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	return 0;
 }
-void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages) {}
+void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+{
+}
 
 void __init efi_map_region(efi_memory_desc_t *md)
 {
@@ -55,7 +57,7 @@ void __init efi_map_region(efi_memory_desc_t *md)
 void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
 void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
 
-void efi_call_phys_prelog(void)
+void __init efi_call_phys_prolog(void)
 {
 	struct desc_ptr gdt_descr;
 
@@ -69,7 +71,7 @@ void efi_call_phys_prelog(void)
 	load_gdt(&gdt_descr);
 }
 
-void efi_call_phys_epilog(void)
+void __init efi_call_phys_epilog(void)
 {
 	struct desc_ptr gdt_descr;
 
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 290d397..35aecb6 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -79,7 +79,7 @@ static void __init early_code_mapping_set_exec(int executable)
 	}
 }
 
-void __init efi_call_phys_prelog(void)
+void __init efi_call_phys_prolog(void)
 {
 	unsigned long vaddress;
 	int pgd;
@@ -139,7 +139,7 @@ void efi_sync_low_kernel_mappings(void)
 		sizeof(pgd_t) * num_pgds);
 }
 
-int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+int __init efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	unsigned long text;
 	struct page *page;
@@ -192,7 +192,7 @@ int efi_setup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 	return 0;
 }
 
-void efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
+void __init efi_cleanup_page_tables(unsigned long pa_memmap, unsigned num_pages)
 {
 	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
 
diff --git a/arch/x86/platform/efi/efi_stub_32.S b/arch/x86/platform/efi/efi_stub_32.S
index fbe66e6..040192b 100644
--- a/arch/x86/platform/efi/efi_stub_32.S
+++ b/arch/x86/platform/efi/efi_stub_32.S
@@ -27,13 +27,13 @@ ENTRY(efi_call_phys)
 	 * set to 0x0010, DS and SS have been set to 0x0018. In EFI, I found
 	 * the values of these registers are the same. And, the corresponding
 	 * GDT entries are identical. So I will do nothing about segment reg
-	 * and GDT, but change GDT base register in prelog and epilog.
+	 * and GDT, but change GDT base register in prolog and epilog.
 	 */
 
 	/*
 	 * 1. Now I am running with EIP = <physical address> + PAGE_OFFSET.
 	 * But to make it smoothly switch from virtual mode to flat mode.
-	 * The mapping of lower virtual memory has been created in prelog and
+	 * The mapping of lower virtual memory has been created in prolog and
 	 * epilog.
 	 */
 	movl	$1f, %edx
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 64ecbb5..8590099 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -41,6 +41,28 @@ struct efi __read_mostly efi = {
 };
 EXPORT_SYMBOL(efi);
 
+static bool disable_runtime;
+static int __init setup_noefi(char *arg)
+{
+	disable_runtime = true;
+	return 0;
+}
+early_param("noefi", setup_noefi);
+
+bool efi_runtime_disabled(void)
+{
+	return disable_runtime;
+}
+
+static int __init parse_efi_cmdline(char *str)
+{
+	if (parse_option_str(str, "noruntime"))
+		disable_runtime = true;
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
+
 static struct kobject *efi_kobj;
 static struct kobject *efivars_kobj;
 
@@ -423,3 +445,60 @@ int __init efi_get_fdt_params(struct efi_fdt_params *params, int verbose)
 	return ret;
 }
 #endif /* CONFIG_EFI_PARAMS_FROM_FDT */
+
+static __initdata char memory_type_name[][20] = {
+	"Reserved",
+	"Loader Code",
+	"Loader Data",
+	"Boot Code",
+	"Boot Data",
+	"Runtime Code",
+	"Runtime Data",
+	"Conventional Memory",
+	"Unusable Memory",
+	"ACPI Reclaim Memory",
+	"ACPI Memory NVS",
+	"Memory Mapped I/O",
+	"MMIO Port Space",
+	"PAL Code"
+};
+
+char * __init efi_md_typeattr_format(char *buf, size_t size,
+				     const efi_memory_desc_t *md)
+{
+	char *pos;
+	int type_len;
+	u64 attr;
+
+	pos = buf;
+	if (md->type >= ARRAY_SIZE(memory_type_name))
+		type_len = snprintf(pos, size, "[type=%u", md->type);
+	else
+		type_len = snprintf(pos, size, "[%-*s",
+				    (int)(sizeof(memory_type_name[0]) - 1),
+				    memory_type_name[md->type]);
+	if (type_len >= size)
+		return buf;
+
+	pos += type_len;
+	size -= type_len;
+
+	attr = md->attribute;
+	if (attr & ~(EFI_MEMORY_UC | EFI_MEMORY_WC | EFI_MEMORY_WT |
+		     EFI_MEMORY_WB | EFI_MEMORY_UCE | EFI_MEMORY_WP |
+		     EFI_MEMORY_RP | EFI_MEMORY_XP | EFI_MEMORY_RUNTIME))
+		snprintf(pos, size, "|attr=0x%016llx]",
+			 (unsigned long long)attr);
+	else
+		snprintf(pos, size, "|%3s|%2s|%2s|%2s|%3s|%2s|%2s|%2s|%2s]",
+			 attr & EFI_MEMORY_RUNTIME ? "RUN" : "",
+			 attr & EFI_MEMORY_XP      ? "XP"  : "",
+			 attr & EFI_MEMORY_RP      ? "RP"  : "",
+			 attr & EFI_MEMORY_WP      ? "WP"  : "",
+			 attr & EFI_MEMORY_UCE     ? "UCE" : "",
+			 attr & EFI_MEMORY_WB      ? "WB"  : "",
+			 attr & EFI_MEMORY_WT      ? "WT"  : "",
+			 attr & EFI_MEMORY_WC      ? "WC"  : "",
+			 attr & EFI_MEMORY_UC      ? "UC"  : "");
+	return buf;
+}
diff --git a/drivers/firmware/efi/libstub/arm-stub.c b/drivers/firmware/efi/libstub/arm-stub.c
index 480339b..75ee059 100644
--- a/drivers/firmware/efi/libstub/arm-stub.c
+++ b/drivers/firmware/efi/libstub/arm-stub.c
@@ -226,6 +226,10 @@ unsigned long __init efi_entry(void *handle, efi_system_table_t *sys_table,
 		goto fail_free_image;
 	}
 
+	status = efi_parse_options(cmdline_ptr);
+	if (status != EFI_SUCCESS)
+		pr_efi_err(sys_table, "Failed to parse EFI cmdline options\n");
+
 	/*
 	 * Unauthenticated device tree data is a security hazard, so
 	 * ignore 'dtb=' unless UEFI Secure Boot is disabled.
diff --git a/drivers/firmware/efi/libstub/efi-stub-helper.c b/drivers/firmware/efi/libstub/efi-stub-helper.c
index 32d5cca..a920fec 100644
--- a/drivers/firmware/efi/libstub/efi-stub-helper.c
+++ b/drivers/firmware/efi/libstub/efi-stub-helper.c
@@ -15,8 +15,23 @@
 
 #include "efistub.h"
 
+/*
+ * Some firmware implementations have problems reading files in one go.
+ * A read chunk size of 1MB seems to work for most platforms.
+ *
+ * Unfortunately, reading files in chunks triggers *other* bugs on some
+ * platforms, so we provide a way to disable this workaround, which can
+ * be done by passing "efi=nochunk" on the EFI boot stub command line.
+ *
+ * If you experience issues with initrd images being corrupt it's worth
+ * trying efi=nochunk, but chunking is enabled by default because there
+ * are far more machines that require the workaround than those that
+ * break with it enabled.
+ */
 #define EFI_READ_CHUNK_SIZE	(1024 * 1024)
 
+static unsigned long __chunk_size = EFI_READ_CHUNK_SIZE;
+
 struct file_info {
 	efi_file_handle_t *handle;
 	u64 size;
@@ -281,6 +296,49 @@ void efi_free(efi_system_table_t *sys_table_arg, unsigned long size,
 	efi_call_early(free_pages, addr, nr_pages);
 }
 
+/*
+ * Parse the ASCII string 'cmdline' for EFI options, denoted by the efi=
+ * option, e.g. efi=nochunk.
+ *
+ * It should be noted that efi= is parsed in two very different
+ * environments, first in the early boot environment of the EFI boot
+ * stub, and subsequently during the kernel boot.
+ */
+efi_status_t efi_parse_options(char *cmdline)
+{
+	char *str;
+
+	/*
+	 * If no EFI parameters were specified on the cmdline we've got
+	 * nothing to do.
+	 */
+	str = strstr(cmdline, "efi=");
+	if (!str)
+		return EFI_SUCCESS;
+
+	/* Skip ahead to first argument */
+	str += strlen("efi=");
+
+	/*
+	 * Remember, because efi= is also used by the kernel we need to
+	 * skip over arguments we don't understand.
+	 */
+	while (*str) {
+		if (!strncmp(str, "nochunk", 7)) {
+			str += strlen("nochunk");
+			__chunk_size = -1UL;
+		}
+
+		/* Group words together, delimited by "," */
+		while (*str && *str != ',')
+			str++;
+
+		if (*str == ',')
+			str++;
+	}
+
+	return EFI_SUCCESS;
+}
 
 /*
  * Check the cmdline for a LILO-style file= arguments.
@@ -423,8 +481,8 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 			size = files[j].size;
 			while (size) {
 				unsigned long chunksize;
-				if (size > EFI_READ_CHUNK_SIZE)
-					chunksize = EFI_READ_CHUNK_SIZE;
+				if (size > __chunk_size)
+					chunksize = __chunk_size;
 				else
 					chunksize = size;
 
diff --git a/drivers/firmware/efi/runtime-wrappers.c b/drivers/firmware/efi/runtime-wrappers.c
index 10daa4b..228bbf9 100644
--- a/drivers/firmware/efi/runtime-wrappers.c
+++ b/drivers/firmware/efi/runtime-wrappers.c
@@ -14,11 +14,80 @@
  * This file is released under the GPLv2.
  */
 
+#include <linux/bug.h>
 #include <linux/efi.h>
-#include <linux/spinlock.h>             /* spinlock_t */
+#include <linux/mutex.h>
+#include <linux/spinlock.h>
 #include <asm/efi.h>
 
 /*
+ * According to section 7.1 of the UEFI spec, Runtime Services are not fully
+ * reentrant, and there are particular combinations of calls that need to be
+ * serialized. (source: UEFI Specification v2.4A)
+ *
+ * Table 31. Rules for Reentry Into Runtime Services
+ * +------------------------------------+-------------------------------+
+ * | If previous call is busy in	| Forbidden to call		|
+ * +------------------------------------+-------------------------------+
+ * | Any				| SetVirtualAddressMap()	|
+ * +------------------------------------+-------------------------------+
+ * | ConvertPointer()			| ConvertPointer()		|
+ * +------------------------------------+-------------------------------+
+ * | SetVariable()			| ResetSystem()			|
+ * | UpdateCapsule()			|				|
+ * | SetTime()				|				|
+ * | SetWakeupTime()			|				|
+ * | GetNextHighMonotonicCount()	|				|
+ * +------------------------------------+-------------------------------+
+ * | GetVariable()			| GetVariable()			|
+ * | GetNextVariableName()		| GetNextVariableName()		|
+ * | SetVariable()			| SetVariable()			|
+ * | QueryVariableInfo()		| QueryVariableInfo()		|
+ * | UpdateCapsule()			| UpdateCapsule()		|
+ * | QueryCapsuleCapabilities()		| QueryCapsuleCapabilities()	|
+ * | GetNextHighMonotonicCount()	| GetNextHighMonotonicCount()	|
+ * +------------------------------------+-------------------------------+
+ * | GetTime()				| GetTime()			|
+ * | SetTime()				| SetTime()			|
+ * | GetWakeupTime()			| GetWakeupTime()		|
+ * | SetWakeupTime()			| SetWakeupTime()		|
+ * +------------------------------------+-------------------------------+
+ *
+ * Due to the fact that the EFI pstore may write to the variable store in
+ * interrupt context, we need to use a spinlock for at least the groups that
+ * contain SetVariable() and QueryVariableInfo(). That leaves little else, as
+ * none of the remaining functions are actually ever called at runtime.
+ * So let's just use a single spinlock to serialize all Runtime Services calls.
+ */
+static DEFINE_SPINLOCK(efi_runtime_lock);
+
+/*
+ * Some runtime services calls can be reentrant under NMI, even if the table
+ * above says they are not. (source: UEFI Specification v2.4A)
+ *
+ * Table 32. Functions that may be called after Machine Check, INIT and NMI
+ * +----------------------------+------------------------------------------+
+ * | Function			| Called after Machine Check, INIT and NMI |
+ * +----------------------------+------------------------------------------+
+ * | GetTime()			| Yes, even if previously busy.		   |
+ * | GetVariable()		| Yes, even if previously busy		   |
+ * | GetNextVariableName()	| Yes, even if previously busy		   |
+ * | QueryVariableInfo()	| Yes, even if previously busy		   |
+ * | SetVariable()		| Yes, even if previously busy		   |
+ * | UpdateCapsule()		| Yes, even if previously busy		   |
+ * | QueryCapsuleCapabilities()	| Yes, even if previously busy		   |
+ * | ResetSystem()		| Yes, even if previously busy		   |
+ * +----------------------------+------------------------------------------+
+ *
+ * In order to prevent deadlocks under NMI, the wrappers for these functions
+ * may only grab the efi_runtime_lock or rtc_lock spinlocks if !efi_in_nmi().
+ * However, not all of the services listed are reachable through NMI code paths,
+ * so the the special handling as suggested by the UEFI spec is only implemented
+ * for QueryVariableInfo() and SetVariable(), as these can be reached in NMI
+ * context through efi_pstore_write().
+ */
+
+/*
  * As per commit ef68c8f87ed1 ("x86: Serialize EFI time accesses on rtc_lock"),
  * the EFI specification requires that callers of the time related runtime
  * functions serialize with other CMOS accesses in the kernel, as the EFI time
@@ -32,7 +101,9 @@ static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_time, tm, tc);
+	spin_unlock(&efi_runtime_lock);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -43,7 +114,9 @@ static efi_status_t virt_efi_set_time(efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(set_time, tm);
+	spin_unlock(&efi_runtime_lock);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -56,7 +129,9 @@ static efi_status_t virt_efi_get_wakeup_time(efi_bool_t *enabled,
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(get_wakeup_time, enabled, pending, tm);
+	spin_unlock(&efi_runtime_lock);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -67,7 +142,9 @@ static efi_status_t virt_efi_set_wakeup_time(efi_bool_t enabled, efi_time_t *tm)
 	efi_status_t status;
 
 	spin_lock_irqsave(&rtc_lock, flags);
+	spin_lock(&efi_runtime_lock);
 	status = efi_call_virt(set_wakeup_time, enabled, tm);
+	spin_unlock(&efi_runtime_lock);
 	spin_unlock_irqrestore(&rtc_lock, flags);
 	return status;
 }
@@ -78,14 +155,27 @@ static efi_status_t virt_efi_get_variable(efi_char16_t *name,
 					  unsigned long *data_size,
 					  void *data)
 {
-	return efi_call_virt(get_variable, name, vendor, attr, data_size, data);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(get_variable, name, vendor, attr, data_size,
+			       data);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_variable(unsigned long *name_size,
 					       efi_char16_t *name,
 					       efi_guid_t *vendor)
 {
-	return efi_call_virt(get_next_variable, name_size, name, vendor);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(get_next_variable, name_size, name, vendor);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_set_variable(efi_char16_t *name,
@@ -94,24 +184,61 @@ static efi_status_t virt_efi_set_variable(efi_char16_t *name,
 					  unsigned long data_size,
 					  void *data)
 {
-	return efi_call_virt(set_variable, name, vendor, attr, data_size, data);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
+			       data);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
+static efi_status_t
+virt_efi_set_variable_nonblocking(efi_char16_t *name, efi_guid_t *vendor,
+				  u32 attr, unsigned long data_size,
+				  void *data)
+{
+	unsigned long flags;
+	efi_status_t status;
+
+	if (!spin_trylock_irqsave(&efi_runtime_lock, flags))
+		return EFI_NOT_READY;
+
+	status = efi_call_virt(set_variable, name, vendor, attr, data_size,
+			       data);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
+}
+
+
 static efi_status_t virt_efi_query_variable_info(u32 attr,
 						 u64 *storage_space,
 						 u64 *remaining_space,
 						 u64 *max_variable_size)
 {
+	unsigned long flags;
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(query_variable_info, attr, storage_space,
-			     remaining_space, max_variable_size);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(query_variable_info, attr, storage_space,
+			       remaining_space, max_variable_size);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_get_next_high_mono_count(u32 *count)
 {
-	return efi_call_virt(get_next_high_mono_count, count);
+	unsigned long flags;
+	efi_status_t status;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(get_next_high_mono_count, count);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static void virt_efi_reset_system(int reset_type,
@@ -119,17 +246,27 @@ static void virt_efi_reset_system(int reset_type,
 				  unsigned long data_size,
 				  efi_char16_t *data)
 {
+	unsigned long flags;
+
+	spin_lock_irqsave(&efi_runtime_lock, flags);
 	__efi_call_virt(reset_system, reset_type, status, data_size, data);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
 }
 
 static efi_status_t virt_efi_update_capsule(efi_capsule_header_t **capsules,
 					    unsigned long count,
 					    unsigned long sg_list)
 {
+	unsigned long flags;
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(update_capsule, capsules, count, sg_list);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(update_capsule, capsules, count, sg_list);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
@@ -137,11 +274,17 @@ static efi_status_t virt_efi_query_capsule_caps(efi_capsule_header_t **capsules,
 						u64 *max_size,
 						int *reset_type)
 {
+	unsigned long flags;
+	efi_status_t status;
+
 	if (efi.runtime_version < EFI_2_00_SYSTEM_TABLE_REVISION)
 		return EFI_UNSUPPORTED;
 
-	return efi_call_virt(query_capsule_caps, capsules, count, max_size,
-			     reset_type);
+	spin_lock_irqsave(&efi_runtime_lock, flags);
+	status = efi_call_virt(query_capsule_caps, capsules, count, max_size,
+			       reset_type);
+	spin_unlock_irqrestore(&efi_runtime_lock, flags);
+	return status;
 }
 
 void efi_native_runtime_setup(void)
@@ -153,6 +296,7 @@ void efi_native_runtime_setup(void)
 	efi.get_variable = virt_efi_get_variable;
 	efi.get_next_variable = virt_efi_get_next_variable;
 	efi.set_variable = virt_efi_set_variable;
+	efi.set_variable_nonblocking = virt_efi_set_variable_nonblocking;
 	efi.get_next_high_mono_count = virt_efi_get_next_high_mono_count;
 	efi.reset_system = virt_efi_reset_system;
 	efi.query_variable_info = virt_efi_query_variable_info;
diff --git a/drivers/firmware/efi/vars.c b/drivers/firmware/efi/vars.c
index 5abe943..70a0fb1 100644
--- a/drivers/firmware/efi/vars.c
+++ b/drivers/firmware/efi/vars.c
@@ -321,11 +321,11 @@ static unsigned long var_name_strnsize(efi_char16_t *variable_name,
  * Print a warning when duplicate EFI variables are encountered and
  * disable the sysfs workqueue since the firmware is buggy.
  */
-static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
+static void dup_variable_bug(efi_char16_t *str16, efi_guid_t *vendor_guid,
 			     unsigned long len16)
 {
 	size_t i, len8 = len16 / sizeof(efi_char16_t);
-	char *s8;
+	char *str8;
 
 	/*
 	 * Disable the workqueue since the algorithm it uses for
@@ -334,16 +334,16 @@ static void dup_variable_bug(efi_char16_t *s16, efi_guid_t *vendor_guid,
 	 */
 	efivar_wq_enabled = false;
 
-	s8 = kzalloc(len8, GFP_KERNEL);
-	if (!s8)
+	str8 = kzalloc(len8, GFP_KERNEL);
+	if (!str8)
 		return;
 
 	for (i = 0; i < len8; i++)
-		s8[i] = s16[i];
+		str8[i] = str16[i];
 
 	printk(KERN_WARNING "efivars: duplicate variable: %s-%pUl\n",
-	       s8, vendor_guid);
-	kfree(s8);
+	       str8, vendor_guid);
+	kfree(str8);
 }
 
 /**
@@ -595,6 +595,39 @@ int efivar_entry_set(struct efivar_entry *entry, u32 attributes,
 }
 EXPORT_SYMBOL_GPL(efivar_entry_set);
 
+/*
+ * efivar_entry_set_nonblocking - call set_variable_nonblocking()
+ *
+ * This function is guaranteed to not block and is suitable for calling
+ * from crash/panic handlers.
+ *
+ * Crucially, this function will not block if it cannot acquire
+ * __efivars->lock. Instead, it returns -EBUSY.
+ */
+static int
+efivar_entry_set_nonblocking(efi_char16_t *name, efi_guid_t vendor,
+			     u32 attributes, unsigned long size, void *data)
+{
+	const struct efivar_operations *ops = __efivars->ops;
+	unsigned long flags;
+	efi_status_t status;
+
+	if (!spin_trylock_irqsave(&__efivars->lock, flags))
+		return -EBUSY;
+
+	status = check_var_size(attributes, size + ucs2_strsize(name, 1024));
+	if (status != EFI_SUCCESS) {
+		spin_unlock_irqrestore(&__efivars->lock, flags);
+		return -ENOSPC;
+	}
+
+	status = ops->set_variable_nonblocking(name, &vendor, attributes,
+					       size, data);
+
+	spin_unlock_irqrestore(&__efivars->lock, flags);
+	return efi_status_to_err(status);
+}
+
 /**
  * efivar_entry_set_safe - call set_variable() if enough space in firmware
  * @name: buffer containing the variable name
@@ -622,6 +655,20 @@ int efivar_entry_set_safe(efi_char16_t *name, efi_guid_t vendor, u32 attributes,
 	if (!ops->query_variable_store)
 		return -ENOSYS;
 
+	/*
+	 * If the EFI variable backend provides a non-blocking
+	 * ->set_variable() operation and we're in a context where we
+	 * cannot block, then we need to use it to avoid live-locks,
+	 * since the implication is that the regular ->set_variable()
+	 * will block.
+	 *
+	 * If no ->set_variable_nonblocking() is provided then
+	 * ->set_variable() is assumed to be non-blocking.
+	 */
+	if (!block && ops->set_variable_nonblocking)
+		return efivar_entry_set_nonblocking(name, vendor, attributes,
+						    size, data);
+
 	if (!block) {
 		if (!spin_trylock_irqsave(&__efivars->lock, flags))
 			return -EBUSY;
diff --git a/drivers/rtc/Kconfig b/drivers/rtc/Kconfig
index a168e96..54ef393 100644
--- a/drivers/rtc/Kconfig
+++ b/drivers/rtc/Kconfig
@@ -806,7 +806,7 @@ config RTC_DRV_DA9063
 
 config RTC_DRV_EFI
 	tristate "EFI RTC"
-	depends on EFI
+	depends on EFI && !X86
 	help
 	  If you say yes here you will get support for the EFI
 	  Real Time Clock.
diff --git a/drivers/rtc/rtc-efi.c b/drivers/rtc/rtc-efi.c
index c384fec..53b589d 100644
--- a/drivers/rtc/rtc-efi.c
+++ b/drivers/rtc/rtc-efi.c
@@ -236,3 +236,4 @@ MODULE_ALIAS("platform:rtc-efi");
 MODULE_AUTHOR("dann frazier <dannf@hp.com>");
 MODULE_LICENSE("GPL");
 MODULE_DESCRIPTION("EFI RTC driver");
+MODULE_ALIAS("platform:rtc-efi");
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 45cb4ff..0949f9c 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -92,6 +92,7 @@ typedef	struct {
 #define EFI_MEMORY_WC		((u64)0x0000000000000002ULL)	/* write-coalescing */
 #define EFI_MEMORY_WT		((u64)0x0000000000000004ULL)	/* write-through */
 #define EFI_MEMORY_WB		((u64)0x0000000000000008ULL)	/* write-back */
+#define EFI_MEMORY_UCE		((u64)0x0000000000000010ULL)	/* uncached, exported */
 #define EFI_MEMORY_WP		((u64)0x0000000000001000ULL)	/* write-protect */
 #define EFI_MEMORY_RP		((u64)0x0000000000002000ULL)	/* read-protect */
 #define EFI_MEMORY_XP		((u64)0x0000000000004000ULL)	/* execute-protect */
@@ -502,6 +503,10 @@ typedef efi_status_t efi_get_next_variable_t (unsigned long *name_size, efi_char
 typedef efi_status_t efi_set_variable_t (efi_char16_t *name, efi_guid_t *vendor, 
 					 u32 attr, unsigned long data_size,
 					 void *data);
+typedef efi_status_t
+efi_set_variable_nonblocking_t(efi_char16_t *name, efi_guid_t *vendor,
+			       u32 attr, unsigned long data_size, void *data);
+
 typedef efi_status_t efi_get_next_high_mono_count_t (u32 *count);
 typedef void efi_reset_system_t (int reset_type, efi_status_t status,
 				 unsigned long data_size, efi_char16_t *data);
@@ -821,6 +826,7 @@ extern struct efi {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_set_variable_nonblocking_t *set_variable_nonblocking;
 	efi_query_variable_info_t *query_variable_info;
 	efi_update_capsule_t *update_capsule;
 	efi_query_capsule_caps_t *query_capsule_caps;
@@ -886,6 +892,13 @@ extern bool efi_poweroff_required(void);
 	     (md) <= (efi_memory_desc_t *)((m)->map_end - (m)->desc_size); \
 	     (md) = (void *)(md) + (m)->desc_size)
 
+/*
+ * Format an EFI memory descriptor's type and attributes to a user-provided
+ * character buffer, as per snprintf(), and return the buffer.
+ */
+char * __init efi_md_typeattr_format(char *buf, size_t size,
+				     const efi_memory_desc_t *md);
+
 /**
  * efi_range_is_wc - check the WC bit on an address range
  * @start: starting kvirt address
@@ -1034,6 +1047,7 @@ struct efivar_operations {
 	efi_get_variable_t *get_variable;
 	efi_get_next_variable_t *get_next_variable;
 	efi_set_variable_t *set_variable;
+	efi_set_variable_nonblocking_t *set_variable_nonblocking;
 	efi_query_variable_store_t *query_variable_store;
 };
 
@@ -1227,4 +1241,7 @@ efi_status_t handle_cmdline_files(efi_system_table_t *sys_table_arg,
 				  unsigned long *load_addr,
 				  unsigned long *load_size);
 
+efi_status_t efi_parse_options(char *cmdline);
+
+bool efi_runtime_disabled(void);
 #endif /* _LINUX_EFI_H */
diff --git a/include/linux/kernel.h b/include/linux/kernel.h
index 95624be..f66427e 100644
--- a/include/linux/kernel.h
+++ b/include/linux/kernel.h
@@ -407,6 +407,7 @@ int vsscanf(const char *, const char *, va_list);
 extern int get_option(char **str, int *pint);
 extern char *get_options(const char *str, int nints, int *ints);
 extern unsigned long long memparse(const char *ptr, char **retptr);
+extern bool parse_option_str(const char *str, const char *option);
 
 extern int core_kernel_text(unsigned long addr);
 extern int core_kernel_data(unsigned long addr);
diff --git a/lib/cmdline.c b/lib/cmdline.c
index 76a712e..8f13cf7 100644
--- a/lib/cmdline.c
+++ b/lib/cmdline.c
@@ -160,3 +160,32 @@ unsigned long long memparse(const char *ptr, char **retptr)
 	return ret;
 }
 EXPORT_SYMBOL(memparse);
+
+/**
+ *	parse_option_str - Parse a string and check an option is set or not
+ *	@str: String to be parsed
+ *	@option: option name
+ *
+ *	This function parses a string containing a comma-separated list of
+ *	strings like a=b,c.
+ *
+ *	Return true if there's such option in the string, or return false.
+ */
+bool parse_option_str(const char *str, const char *option)
+{
+	while (*str) {
+		if (!strncmp(str, option, strlen(option))) {
+			str += strlen(option);
+			if (!*str || *str == ',')
+				return true;
+		}
+
+		while (*str && *str != ',')
+			str++;
+
+		if (*str == ',')
+			str++;
+	}
+
+	return false;
+}
