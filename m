Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754014AbaATOnP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 20 Jan 2014 09:43:15 -0500
Received: from mail-ee0-f46.google.com ([74.125.83.46]:42720 "EHLO
	mail-ee0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751887AbaATOnJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 20 Jan 2014 09:43:09 -0500
Date: Mon, 20 Jan 2014 15:43:05 +0100
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>, Borislav Petkov <bp@alien8.de>,
        Matt Fleming <matt.fleming@intel.com>, Dave Young <dyoung@redhat.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/efi changes for v3.14
Message-ID: <20140120144305.GA14091@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-efi-kexec-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-efi-kexec-for-linus

   # HEAD: ef0b8b9a521c65201bfca9747ee1bf374296133c Merge tag 'v3.13-rc7' into x86/efi-kexec to resolve conflicts

It consists of two main parts:

  * New static EFI runtime services virtual mapping layout which is
    groundwork for kexec support on EFI. (Borislav Petkov)

  * EFI kexec support itself. (Dave Young)

 Thanks,

	Ingo

------------------>
Borislav Petkov (11):
      x86/efi: Simplify EFI_DEBUG
      x86/mm/pageattr: Lookup address in an arbitrary PGD
      x86/mm/pageattr: Add a PGD pagetable populating function
      x86/mm/pageattr: Add a PUD pagetable populating function
      x86/mm/pageattr: Add a PMD pagetable populating function
      x86/mm/pageattr: Add a PTE pagetable populating function
      x86/mm/pageattr: Add a PUD error unwinding path
      x86/mm/pageattr: Add last levels of error path
      x86/mm/cpa: Map in an arbitrary pgd
      x86/efi: Runtime services virtual mapping
      x86/efi: Check krealloc return value

Dave Young (12):
      x86/efi: Remove unused variables in __map_region()
      x86/efi: Add a wrapper function efi_map_region_fixed()
      x86/efi: Fix off-by-one bug in EFI Boot Services reservation
      x86/efi: Cleanup efi_enter_virtual_mode() function
      efi: Export more EFI table variables to sysfs
      efi: Export EFI runtime memory mapping to sysfs
      x86/efi: Pass necessary EFI data for kexec via setup_data
      x86: Add xloadflags bit for EFI runtime support on kexec
      x86: Export x86 boot_params to sysfs
      x86: Reserve setup_data ranges late after parsing memmap cmdline
      x86: ksysfs.c build fix
      x86/efi: parse_efi_setup() build fix

Matt Fleming (1):
      x86/efi: Delete superfluous global variables


 Documentation/ABI/testing/sysfs-firmware-efi       |  20 +
 .../ABI/testing/sysfs-firmware-efi-runtime-map     |  34 ++
 Documentation/ABI/testing/sysfs-kernel-boot_params |  38 ++
 Documentation/kernel-parameters.txt                |   6 +
 Documentation/x86/boot.txt                         |   3 +
 Documentation/x86/x86_64/mm.txt                    |   7 +
 arch/x86/boot/header.S                             |   9 +-
 arch/x86/include/asm/efi.h                         |  78 +++-
 arch/x86/include/asm/pgtable_types.h               |   3 +-
 arch/x86/include/uapi/asm/bootparam.h              |   2 +
 arch/x86/kernel/Makefile                           |   1 +
 arch/x86/kernel/ksysfs.c                           | 340 +++++++++++++++
 arch/x86/kernel/setup.c                            |   7 +-
 arch/x86/mm/pageattr.c                             | 461 ++++++++++++++++++++-
 arch/x86/platform/efi/efi.c                        | 355 ++++++++++++----
 arch/x86/platform/efi/efi_32.c                     |  12 +-
 arch/x86/platform/efi/efi_64.c                     | 120 ++++++
 arch/x86/platform/efi/efi_stub_64.S                |  54 +++
 drivers/firmware/efi/Kconfig                       |  11 +
 drivers/firmware/efi/Makefile                      |   1 +
 drivers/firmware/efi/efi.c                         |  45 +-
 drivers/firmware/efi/runtime-map.c                 | 181 ++++++++
 include/linux/efi.h                                |  17 +
 23 files changed, 1689 insertions(+), 116 deletions(-)
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi
 create mode 100644 Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
 create mode 100644 Documentation/ABI/testing/sysfs-kernel-boot_params
 create mode 100644 arch/x86/kernel/ksysfs.c
 create mode 100644 drivers/firmware/efi/runtime-map.c

diff --git a/Documentation/ABI/testing/sysfs-firmware-efi b/Documentation/ABI/testing/sysfs-firmware-efi
new file mode 100644
index 0000000..05874da
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-efi
@@ -0,0 +1,20 @@
+What:		/sys/firmware/efi/fw_vendor
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	It shows the physical address of firmware vendor field in the
+		EFI system table.
+Users:		Kexec
+
+What:		/sys/firmware/efi/runtime
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	It shows the physical address of runtime service table entry in
+		the EFI system table.
+Users:		Kexec
+
+What:		/sys/firmware/efi/config_table
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	It shows the physical address of config table entry in the EFI
+		system table.
+Users:		Kexec
diff --git a/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
new file mode 100644
index 0000000..c61b9b3
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-firmware-efi-runtime-map
@@ -0,0 +1,34 @@
+What:		/sys/firmware/efi/runtime-map/
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	Switching efi runtime services to virtual mode requires
+		that all efi memory ranges which have the runtime attribute
+		bit set to be mapped to virtual addresses.
+
+		The efi runtime services can only be switched to virtual
+		mode once without rebooting. The kexec kernel must maintain
+		the same physical to virtual address mappings as the first
+		kernel. The mappings are exported to sysfs so userspace tools
+		can reassemble them and pass them into the kexec kernel.
+
+		/sys/firmware/efi/runtime-map/ is the directory the kernel
+		exports that information in.
+
+		subdirectories are named with the number of the memory range:
+
+			/sys/firmware/efi/runtime-map/0
+			/sys/firmware/efi/runtime-map/1
+			/sys/firmware/efi/runtime-map/2
+			/sys/firmware/efi/runtime-map/3
+			...
+
+		Each subdirectory contains five files:
+
+		attribute : The attributes of the memory range.
+		num_pages : The size of the memory range in pages.
+		phys_addr : The physical address of the memory range.
+		type      : The type of the memory range.
+		virt_addr : The virtual address of the memory range.
+
+		Above values are all hexadecimal numbers with the '0x' prefix.
+Users:		Kexec
diff --git a/Documentation/ABI/testing/sysfs-kernel-boot_params b/Documentation/ABI/testing/sysfs-kernel-boot_params
new file mode 100644
index 0000000..eca38ce
--- /dev/null
+++ b/Documentation/ABI/testing/sysfs-kernel-boot_params
@@ -0,0 +1,38 @@
+What:		/sys/kernel/boot_params
+Date:		December 2013
+Contact:	Dave Young <dyoung@redhat.com>
+Description:	The /sys/kernel/boot_params directory contains two
+		files: "data" and "version" and one subdirectory "setup_data".
+		It is used to export the kernel boot parameters of an x86
+		platform to userspace for kexec and debugging purpose.
+
+		If there's no setup_data in boot_params the subdirectory will
+		not be created.
+
+		"data" file is the binary representation of struct boot_params.
+
+		"version" file is the string representation of boot
+		protocol version.
+
+		"setup_data" subdirectory contains the setup_data data
+		structure in boot_params. setup_data is maintained in kernel
+		as a link list. In "setup_data" subdirectory there's one
+		subdirectory for each link list node named with the number
+		of the list nodes. The list node subdirectory contains two
+		files "type" and "data". "type" file is the string
+		representation of setup_data type. "data" file is the binary
+		representation of setup_data payload.
+
+		The whole boot_params directory structure is like below:
+		/sys/kernel/boot_params
+		|__ data
+		|__ setup_data
+		|   |__ 0
+		|   |   |__ data
+		|   |   |__ type
+		|   |__ 1
+		|       |__ data
+		|       |__ type
+		|__ version
+
+Users:		Kexec
diff --git a/Documentation/kernel-parameters.txt b/Documentation/kernel-parameters.txt
index b9e9bd8..d7e736c 100644
--- a/Documentation/kernel-parameters.txt
+++ b/Documentation/kernel-parameters.txt
@@ -890,6 +890,12 @@ bytes respectively. Such letter suffixes can also be entirely omitted.
 	edd=		[EDD]
 			Format: {"off" | "on" | "skip[mbr]"}
 
+	efi=		[EFI]
+			Format: { "old_map" }
+			old_map [X86-64]: switch to the old ioremap-based EFI
+			runtime services mapping. 32-bit still uses this one by
+			default.
+
 	efi_no_storage_paranoia [EFI; X86]
 			Using this parameter you can use more than 50% of
 			your efi variable storage. Use this parameter only if
diff --git a/Documentation/x86/boot.txt b/Documentation/x86/boot.txt
index f4f268c..cb81741d 100644
--- a/Documentation/x86/boot.txt
+++ b/Documentation/x86/boot.txt
@@ -608,6 +608,9 @@ Protocol:       2.12+
 	- If 1, the kernel supports the 64-bit EFI handoff entry point
           given at handover_offset + 0x200.
 
+  Bit 4 (read): XLF_EFI_KEXEC
+	- If 1, the kernel supports kexec EFI boot with EFI runtime support.
+
 Field name:	cmdline_size
 Type:		read
 Offset/size:	0x238/4
diff --git a/Documentation/x86/x86_64/mm.txt b/Documentation/x86/x86_64/mm.txt
index 881582f..c584a51 100644
--- a/Documentation/x86/x86_64/mm.txt
+++ b/Documentation/x86/x86_64/mm.txt
@@ -28,4 +28,11 @@ reference.
 Current X86-64 implementations only support 40 bits of address space,
 but we support up to 46 bits. This expands into MBZ space in the page tables.
 
+->trampoline_pgd:
+
+We map EFI runtime services in the aforementioned PGD in the virtual
+range of 64Gb (arbitrarily set, can be raised if needed)
+
+0xffffffef00000000 - 0xffffffff00000000
+
 -Andi Kleen, Jul 2004
diff --git a/arch/x86/boot/header.S b/arch/x86/boot/header.S
index 9ec06a1..ec3b8ba 100644
--- a/arch/x86/boot/header.S
+++ b/arch/x86/boot/header.S
@@ -391,7 +391,14 @@ xloadflags:
 #else
 # define XLF23 0
 #endif
-			.word XLF0 | XLF1 | XLF23
+
+#if defined(CONFIG_X86_64) && defined(CONFIG_EFI) && defined(CONFIG_KEXEC)
+# define XLF4 XLF_EFI_KEXEC
+#else
+# define XLF4 0
+#endif
+
+			.word XLF0 | XLF1 | XLF23 | XLF4
 
 cmdline_size:   .long   COMMAND_LINE_SIZE-1     #length of the command line,
                                                 #added with boot protocol
diff --git a/arch/x86/include/asm/efi.h b/arch/x86/include/asm/efi.h
index 65c6e6e..3b978c4 100644
--- a/arch/x86/include/asm/efi.h
+++ b/arch/x86/include/asm/efi.h
@@ -1,6 +1,24 @@
 #ifndef _ASM_X86_EFI_H
 #define _ASM_X86_EFI_H
 
+/*
+ * We map the EFI regions needed for runtime services non-contiguously,
+ * with preserved alignment on virtual addresses starting from -4G down
+ * for a total max space of 64G. This way, we provide for stable runtime
+ * services addresses across kernels so that a kexec'd kernel can still
+ * use them.
+ *
+ * This is the main reason why we're doing stable VA mappings for RT
+ * services.
+ *
+ * This flag is used in conjuction with a chicken bit called
+ * "efi=old_map" which can be used as a fallback to the old runtime
+ * services mapping method in case there's some b0rkage with a
+ * particular EFI implementation (haha, it is hard to hold up the
+ * sarcasm here...).
+ */
+#define EFI_OLD_MEMMAP		EFI_ARCH_1
+
 #ifdef CONFIG_X86_32
 
 #define EFI_LOADER_SIGNATURE	"EL32"
@@ -69,24 +87,31 @@ extern u64 efi_call6(void *fp, u64 arg1, u64 arg2, u64 arg3,
 	efi_call6((f), (u64)(a1), (u64)(a2), (u64)(a3),		\
 		  (u64)(a4), (u64)(a5), (u64)(a6))
 
+#define _efi_call_virtX(x, f, ...)					\
+({									\
+	efi_status_t __s;						\
+									\
+	efi_sync_low_kernel_mappings();					\
+	preempt_disable();						\
+	__s = efi_call##x((void *)efi.systab->runtime->f, __VA_ARGS__);	\
+	preempt_enable();						\
+	__s;								\
+})
+
 #define efi_call_virt0(f)				\
-	efi_call0((efi.systab->runtime->f))
-#define efi_call_virt1(f, a1)					\
-	efi_call1((efi.systab->runtime->f), (u64)(a1))
-#define efi_call_virt2(f, a1, a2)					\
-	efi_call2((efi.systab->runtime->f), (u64)(a1), (u64)(a2))
-#define efi_call_virt3(f, a1, a2, a3)					\
-	efi_call3((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3))
-#define efi_call_virt4(f, a1, a2, a3, a4)				\
-	efi_call4((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3), (u64)(a4))
-#define efi_call_virt5(f, a1, a2, a3, a4, a5)				\
-	efi_call5((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3), (u64)(a4), (u64)(a5))
-#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)			\
-	efi_call6((efi.systab->runtime->f), (u64)(a1), (u64)(a2), \
-		  (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
+	_efi_call_virtX(0, f)
+#define efi_call_virt1(f, a1)				\
+	_efi_call_virtX(1, f, (u64)(a1))
+#define efi_call_virt2(f, a1, a2)			\
+	_efi_call_virtX(2, f, (u64)(a1), (u64)(a2))
+#define efi_call_virt3(f, a1, a2, a3)			\
+	_efi_call_virtX(3, f, (u64)(a1), (u64)(a2), (u64)(a3))
+#define efi_call_virt4(f, a1, a2, a3, a4)		\
+	_efi_call_virtX(4, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4))
+#define efi_call_virt5(f, a1, a2, a3, a4, a5)		\
+	_efi_call_virtX(5, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5))
+#define efi_call_virt6(f, a1, a2, a3, a4, a5, a6)	\
+	_efi_call_virtX(6, f, (u64)(a1), (u64)(a2), (u64)(a3), (u64)(a4), (u64)(a5), (u64)(a6))
 
 extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 				 u32 type, u64 attribute);
@@ -95,12 +120,28 @@ extern void __iomem *efi_ioremap(unsigned long addr, unsigned long size,
 
 extern int add_efi_memmap;
 extern unsigned long x86_efi_facility;
+extern struct efi_scratch efi_scratch;
 extern void efi_set_executable(efi_memory_desc_t *md, bool executable);
 extern int efi_memblock_x86_reserve_range(void);
 extern void efi_call_phys_prelog(void);
 extern void efi_call_phys_epilog(void);
 extern void efi_unmap_memmap(void);
 extern void efi_memory_uc(u64 addr, unsigned long size);
+extern void __init efi_map_region(efi_memory_desc_t *md);
+extern void __init efi_map_region_fixed(efi_memory_desc_t *md);
+extern void efi_sync_low_kernel_mappings(void);
+extern void efi_setup_page_tables(void);
+extern void __init old_map_region(efi_memory_desc_t *md);
+
+struct efi_setup_data {
+	u64 fw_vendor;
+	u64 runtime;
+	u64 tables;
+	u64 smbios;
+	u64 reserved[8];
+};
+
+extern u64 efi_setup;
 
 #ifdef CONFIG_EFI
 
@@ -110,7 +151,7 @@ static inline bool efi_is_native(void)
 }
 
 extern struct console early_efi_console;
-
+extern void parse_efi_setup(u64 phys_addr, u32 data_len);
 #else
 /*
  * IF EFI is not configured, have the EFI calls return -ENOSYS.
@@ -122,6 +163,7 @@ extern struct console early_efi_console;
 #define efi_call4(_f, _a1, _a2, _a3, _a4)		(-ENOSYS)
 #define efi_call5(_f, _a1, _a2, _a3, _a4, _a5)		(-ENOSYS)
 #define efi_call6(_f, _a1, _a2, _a3, _a4, _a5, _a6)	(-ENOSYS)
+static inline void parse_efi_setup(u64 phys_addr, u32 data_len) {}
 #endif /* CONFIG_EFI */
 
 #endif /* _ASM_X86_EFI_H */
diff --git a/arch/x86/include/asm/pgtable_types.h b/arch/x86/include/asm/pgtable_types.h
index 0ecac25..a83aa44 100644
--- a/arch/x86/include/asm/pgtable_types.h
+++ b/arch/x86/include/asm/pgtable_types.h
@@ -382,7 +382,8 @@ static inline void update_page_count(int level, unsigned long pages) { }
  */
 extern pte_t *lookup_address(unsigned long address, unsigned int *level);
 extern phys_addr_t slow_virt_to_phys(void *__address);
-
+extern int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
+				   unsigned numpages, unsigned long page_flags);
 #endif	/* !__ASSEMBLY__ */
 
 #endif /* _ASM_X86_PGTABLE_DEFS_H */
diff --git a/arch/x86/include/uapi/asm/bootparam.h b/arch/x86/include/uapi/asm/bootparam.h
index 9c3733c..225b098 100644
--- a/arch/x86/include/uapi/asm/bootparam.h
+++ b/arch/x86/include/uapi/asm/bootparam.h
@@ -6,6 +6,7 @@
 #define SETUP_E820_EXT			1
 #define SETUP_DTB			2
 #define SETUP_PCI			3
+#define SETUP_EFI			4
 
 /* ram_size flags */
 #define RAMDISK_IMAGE_START_MASK	0x07FF
@@ -23,6 +24,7 @@
 #define XLF_CAN_BE_LOADED_ABOVE_4G	(1<<1)
 #define XLF_EFI_HANDOVER_32		(1<<2)
 #define XLF_EFI_HANDOVER_64		(1<<3)
+#define XLF_EFI_KEXEC			(1<<4)
 
 #ifndef __ASSEMBLY__
 
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 9b0a34e..510cca5 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -29,6 +29,7 @@ obj-$(CONFIG_X86_64)	+= sys_x86_64.o x8664_ksyms_64.o
 obj-y			+= syscall_$(BITS).o
 obj-$(CONFIG_X86_64)	+= vsyscall_64.o
 obj-$(CONFIG_X86_64)	+= vsyscall_emu_64.o
+obj-$(CONFIG_SYSFS)	+= ksysfs.o
 obj-y			+= bootflag.o e820.o
 obj-y			+= pci-dma.o quirks.o topology.o kdebugfs.o
 obj-y			+= alternative.o i8253.o pci-nommu.o hw_breakpoint.o
diff --git a/arch/x86/kernel/ksysfs.c b/arch/x86/kernel/ksysfs.c
new file mode 100644
index 0000000..c2bedae
--- /dev/null
+++ b/arch/x86/kernel/ksysfs.c
@@ -0,0 +1,340 @@
+/*
+ * Architecture specific sysfs attributes in /sys/kernel
+ *
+ * Copyright (C) 2007, Intel Corp.
+ *      Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2013, 2013 Red Hat, Inc.
+ *      Dave Young <dyoung@redhat.com>
+ *
+ * This file is released under the GPLv2
+ */
+
+#include <linux/kobject.h>
+#include <linux/string.h>
+#include <linux/sysfs.h>
+#include <linux/init.h>
+#include <linux/stat.h>
+#include <linux/slab.h>
+#include <linux/mm.h>
+
+#include <asm/io.h>
+#include <asm/setup.h>
+
+static ssize_t version_show(struct kobject *kobj,
+			    struct kobj_attribute *attr, char *buf)
+{
+	return sprintf(buf, "0x%04x\n", boot_params.hdr.version);
+}
+
+static struct kobj_attribute boot_params_version_attr = __ATTR_RO(version);
+
+static ssize_t boot_params_data_read(struct file *fp, struct kobject *kobj,
+				     struct bin_attribute *bin_attr,
+				     char *buf, loff_t off, size_t count)
+{
+	memcpy(buf, (void *)&boot_params + off, count);
+	return count;
+}
+
+static struct bin_attribute boot_params_data_attr = {
+	.attr = {
+		.name = "data",
+		.mode = S_IRUGO,
+	},
+	.read = boot_params_data_read,
+	.size = sizeof(boot_params),
+};
+
+static struct attribute *boot_params_version_attrs[] = {
+	&boot_params_version_attr.attr,
+	NULL,
+};
+
+static struct bin_attribute *boot_params_data_attrs[] = {
+	&boot_params_data_attr,
+	NULL,
+};
+
+static struct attribute_group boot_params_attr_group = {
+	.attrs = boot_params_version_attrs,
+	.bin_attrs = boot_params_data_attrs,
+};
+
+static int kobj_to_setup_data_nr(struct kobject *kobj, int *nr)
+{
+	const char *name;
+
+	name = kobject_name(kobj);
+	return kstrtoint(name, 10, nr);
+}
+
+static int get_setup_data_paddr(int nr, u64 *paddr)
+{
+	int i = 0;
+	struct setup_data *data;
+	u64 pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		if (nr == i) {
+			*paddr = pa_data;
+			return 0;
+		}
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data)
+			return -ENOMEM;
+
+		pa_data = data->next;
+		iounmap(data);
+		i++;
+	}
+	return -EINVAL;
+}
+
+static int __init get_setup_data_size(int nr, size_t *size)
+{
+	int i = 0;
+	struct setup_data *data;
+	u64 pa_data = boot_params.hdr.setup_data;
+
+	while (pa_data) {
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data)
+			return -ENOMEM;
+		if (nr == i) {
+			*size = data->len;
+			iounmap(data);
+			return 0;
+		}
+
+		pa_data = data->next;
+		iounmap(data);
+		i++;
+	}
+	return -EINVAL;
+}
+
+static ssize_t type_show(struct kobject *kobj,
+			 struct kobj_attribute *attr, char *buf)
+{
+	int nr, ret;
+	u64 paddr;
+	struct setup_data *data;
+
+	ret = kobj_to_setup_data_nr(kobj, &nr);
+	if (ret)
+		return ret;
+
+	ret = get_setup_data_paddr(nr, &paddr);
+	if (ret)
+		return ret;
+	data = ioremap_cache(paddr, sizeof(*data));
+	if (!data)
+		return -ENOMEM;
+
+	ret = sprintf(buf, "0x%x\n", data->type);
+	iounmap(data);
+	return ret;
+}
+
+static ssize_t setup_data_data_read(struct file *fp,
+				    struct kobject *kobj,
+				    struct bin_attribute *bin_attr,
+				    char *buf,
+				    loff_t off, size_t count)
+{
+	int nr, ret = 0;
+	u64 paddr;
+	struct setup_data *data;
+	void *p;
+
+	ret = kobj_to_setup_data_nr(kobj, &nr);
+	if (ret)
+		return ret;
+
+	ret = get_setup_data_paddr(nr, &paddr);
+	if (ret)
+		return ret;
+	data = ioremap_cache(paddr, sizeof(*data));
+	if (!data)
+		return -ENOMEM;
+
+	if (off > data->len) {
+		ret = -EINVAL;
+		goto out;
+	}
+
+	if (count > data->len - off)
+		count = data->len - off;
+
+	if (!count)
+		goto out;
+
+	ret = count;
+	p = ioremap_cache(paddr + sizeof(*data), data->len);
+	if (!p) {
+		ret = -ENOMEM;
+		goto out;
+	}
+	memcpy(buf, p + off, count);
+	iounmap(p);
+out:
+	iounmap(data);
+	return ret;
+}
+
+static struct kobj_attribute type_attr = __ATTR_RO(type);
+
+static struct bin_attribute data_attr = {
+	.attr = {
+		.name = "data",
+		.mode = S_IRUGO,
+	},
+	.read = setup_data_data_read,
+};
+
+static struct attribute *setup_data_type_attrs[] = {
+	&type_attr.attr,
+	NULL,
+};
+
+static struct bin_attribute *setup_data_data_attrs[] = {
+	&data_attr,
+	NULL,
+};
+
+static struct attribute_group setup_data_attr_group = {
+	.attrs = setup_data_type_attrs,
+	.bin_attrs = setup_data_data_attrs,
+};
+
+static int __init create_setup_data_node(struct kobject *parent,
+					 struct kobject **kobjp, int nr)
+{
+	int ret = 0;
+	size_t size;
+	struct kobject *kobj;
+	char name[16]; /* should be enough for setup_data nodes numbers */
+	snprintf(name, 16, "%d", nr);
+
+	kobj = kobject_create_and_add(name, parent);
+	if (!kobj)
+		return -ENOMEM;
+
+	ret = get_setup_data_size(nr, &size);
+	if (ret)
+		goto out_kobj;
+
+	data_attr.size = size;
+	ret = sysfs_create_group(kobj, &setup_data_attr_group);
+	if (ret)
+		goto out_kobj;
+	*kobjp = kobj;
+
+	return 0;
+out_kobj:
+	kobject_put(kobj);
+	return ret;
+}
+
+static void __init cleanup_setup_data_node(struct kobject *kobj)
+{
+	sysfs_remove_group(kobj, &setup_data_attr_group);
+	kobject_put(kobj);
+}
+
+static int __init get_setup_data_total_num(u64 pa_data, int *nr)
+{
+	int ret = 0;
+	struct setup_data *data;
+
+	*nr = 0;
+	while (pa_data) {
+		*nr += 1;
+		data = ioremap_cache(pa_data, sizeof(*data));
+		if (!data) {
+			ret = -ENOMEM;
+			goto out;
+		}
+		pa_data = data->next;
+		iounmap(data);
+	}
+
+out:
+	return ret;
+}
+
+static int __init create_setup_data_nodes(struct kobject *parent)
+{
+	struct kobject *setup_data_kobj, **kobjp;
+	u64 pa_data;
+	int i, j, nr, ret = 0;
+
+	pa_data = boot_params.hdr.setup_data;
+	if (!pa_data)
+		return 0;
+
+	setup_data_kobj = kobject_create_and_add("setup_data", parent);
+	if (!setup_data_kobj) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = get_setup_data_total_num(pa_data, &nr);
+	if (ret)
+		goto out_setup_data_kobj;
+
+	kobjp = kmalloc(sizeof(*kobjp) * nr, GFP_KERNEL);
+	if (!kobjp) {
+		ret = -ENOMEM;
+		goto out_setup_data_kobj;
+	}
+
+	for (i = 0; i < nr; i++) {
+		ret = create_setup_data_node(setup_data_kobj, kobjp + i, i);
+		if (ret)
+			goto out_clean_nodes;
+	}
+
+	kfree(kobjp);
+	return 0;
+
+out_clean_nodes:
+	for (j = i - 1; j > 0; j--)
+		cleanup_setup_data_node(*(kobjp + j));
+	kfree(kobjp);
+out_setup_data_kobj:
+	kobject_put(setup_data_kobj);
+out:
+	return ret;
+}
+
+static int __init boot_params_ksysfs_init(void)
+{
+	int ret;
+	struct kobject *boot_params_kobj;
+
+	boot_params_kobj = kobject_create_and_add("boot_params",
+						  kernel_kobj);
+	if (!boot_params_kobj) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	ret = sysfs_create_group(boot_params_kobj, &boot_params_attr_group);
+	if (ret)
+		goto out_boot_params_kobj;
+
+	ret = create_setup_data_nodes(boot_params_kobj);
+	if (ret)
+		goto out_create_group;
+
+	return 0;
+out_create_group:
+	sysfs_remove_group(boot_params_kobj, &boot_params_attr_group);
+out_boot_params_kobj:
+	kobject_put(boot_params_kobj);
+out:
+	return ret;
+}
+
+arch_initcall(boot_params_ksysfs_init);
diff --git a/arch/x86/kernel/setup.c b/arch/x86/kernel/setup.c
index cb233bc..be4b456 100644
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
@@ -924,8 +927,6 @@ void __init setup_arch(char **cmdline_p)
 	iomem_resource.end = (1ULL << boot_cpu_data.x86_phys_bits) - 1;
 	setup_memory_map();
 	parse_setup_data();
-	/* update the e820_saved too */
-	e820_reserve_setup_data();
 
 	copy_edd();
 
@@ -987,6 +988,8 @@ void __init setup_arch(char **cmdline_p)
 		early_dump_pci_devices();
 #endif
 
+	/* update the e820_saved too */
+	e820_reserve_setup_data();
 	finish_e820_parsing();
 
 	if (efi_enabled(EFI_BOOT))
diff --git a/arch/x86/mm/pageattr.c b/arch/x86/mm/pageattr.c
index bb32480..b3b19f4 100644
--- a/arch/x86/mm/pageattr.c
+++ b/arch/x86/mm/pageattr.c
@@ -30,6 +30,7 @@
  */
 struct cpa_data {
 	unsigned long	*vaddr;
+	pgd_t		*pgd;
 	pgprot_t	mask_set;
 	pgprot_t	mask_clr;
 	int		numpages;
@@ -322,17 +323,9 @@ static inline pgprot_t static_protections(pgprot_t prot, unsigned long address,
 	return prot;
 }
 
-/*
- * Lookup the page table entry for a virtual address. Return a pointer
- * to the entry and the level of the mapping.
- *
- * Note: We return pud and pmd either when the entry is marked large
- * or when the present bit is not set. Otherwise we would return a
- * pointer to a nonexisting mapping.
- */
-pte_t *lookup_address(unsigned long address, unsigned int *level)
+static pte_t *__lookup_address_in_pgd(pgd_t *pgd, unsigned long address,
+				      unsigned int *level)
 {
-	pgd_t *pgd = pgd_offset_k(address);
 	pud_t *pud;
 	pmd_t *pmd;
 
@@ -361,8 +354,31 @@ pte_t *lookup_address(unsigned long address, unsigned int *level)
 
 	return pte_offset_kernel(pmd, address);
 }
+
+/*
+ * Lookup the page table entry for a virtual address. Return a pointer
+ * to the entry and the level of the mapping.
+ *
+ * Note: We return pud and pmd either when the entry is marked large
+ * or when the present bit is not set. Otherwise we would return a
+ * pointer to a nonexisting mapping.
+ */
+pte_t *lookup_address(unsigned long address, unsigned int *level)
+{
+        return __lookup_address_in_pgd(pgd_offset_k(address), address, level);
+}
 EXPORT_SYMBOL_GPL(lookup_address);
 
+static pte_t *_lookup_address_cpa(struct cpa_data *cpa, unsigned long address,
+				  unsigned int *level)
+{
+        if (cpa->pgd)
+		return __lookup_address_in_pgd(cpa->pgd + pgd_index(address),
+					       address, level);
+
+        return lookup_address(address, level);
+}
+
 /*
  * This is necessary because __pa() does not work on some
  * kinds of memory, like vmalloc() or the alloc_remap()
@@ -437,7 +453,7 @@ try_preserve_large_page(pte_t *kpte, unsigned long address,
 	 * Check for races, another CPU might have split this page
 	 * up already:
 	 */
-	tmp = lookup_address(address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte)
 		goto out_unlock;
 
@@ -543,7 +559,8 @@ out_unlock:
 }
 
 static int
-__split_large_page(pte_t *kpte, unsigned long address, struct page *base)
+__split_large_page(struct cpa_data *cpa, pte_t *kpte, unsigned long address,
+		   struct page *base)
 {
 	pte_t *pbase = (pte_t *)page_address(base);
 	unsigned long pfn, pfninc = 1;
@@ -556,7 +573,7 @@ __split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 	 * Check for races, another CPU might have split this page
 	 * up for us already:
 	 */
-	tmp = lookup_address(address, &level);
+	tmp = _lookup_address_cpa(cpa, address, &level);
 	if (tmp != kpte) {
 		spin_unlock(&pgd_lock);
 		return 1;
@@ -632,7 +649,8 @@ __split_large_page(pte_t *kpte, unsigned long address, struct page *base)
 	return 0;
 }
 
-static int split_large_page(pte_t *kpte, unsigned long address)
+static int split_large_page(struct cpa_data *cpa, pte_t *kpte,
+			    unsigned long address)
 {
 	struct page *base;
 
@@ -644,15 +662,390 @@ static int split_large_page(pte_t *kpte, unsigned long address)
 	if (!base)
 		return -ENOMEM;
 
-	if (__split_large_page(kpte, address, base))
+	if (__split_large_page(cpa, kpte, address, base))
 		__free_page(base);
 
 	return 0;
 }
 
+static bool try_to_free_pte_page(pte_t *pte)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PTE; i++)
+		if (!pte_none(pte[i]))
+			return false;
+
+	free_page((unsigned long)pte);
+	return true;
+}
+
+static bool try_to_free_pmd_page(pmd_t *pmd)
+{
+	int i;
+
+	for (i = 0; i < PTRS_PER_PMD; i++)
+		if (!pmd_none(pmd[i]))
+			return false;
+
+	free_page((unsigned long)pmd);
+	return true;
+}
+
+static bool unmap_pte_range(pmd_t *pmd, unsigned long start, unsigned long end)
+{
+	pte_t *pte = pte_offset_kernel(pmd, start);
+
+	while (start < end) {
+		set_pte(pte, __pte(0));
+
+		start += PAGE_SIZE;
+		pte++;
+	}
+
+	if (try_to_free_pte_page((pte_t *)pmd_page_vaddr(*pmd))) {
+		pmd_clear(pmd);
+		return true;
+	}
+	return false;
+}
+
+static void __unmap_pmd_range(pud_t *pud, pmd_t *pmd,
+			      unsigned long start, unsigned long end)
+{
+	if (unmap_pte_range(pmd, start, end))
+		if (try_to_free_pmd_page((pmd_t *)pud_page_vaddr(*pud)))
+			pud_clear(pud);
+}
+
+static void unmap_pmd_range(pud_t *pud, unsigned long start, unsigned long end)
+{
+	pmd_t *pmd = pmd_offset(pud, start);
+
+	/*
+	 * Not on a 2MB page boundary?
+	 */
+	if (start & (PMD_SIZE - 1)) {
+		unsigned long next_page = (start + PMD_SIZE) & PMD_MASK;
+		unsigned long pre_end = min_t(unsigned long, end, next_page);
+
+		__unmap_pmd_range(pud, pmd, start, pre_end);
+
+		start = pre_end;
+		pmd++;
+	}
+
+	/*
+	 * Try to unmap in 2M chunks.
+	 */
+	while (end - start >= PMD_SIZE) {
+		if (pmd_large(*pmd))
+			pmd_clear(pmd);
+		else
+			__unmap_pmd_range(pud, pmd, start, start + PMD_SIZE);
+
+		start += PMD_SIZE;
+		pmd++;
+	}
+
+	/*
+	 * 4K leftovers?
+	 */
+	if (start < end)
+		return __unmap_pmd_range(pud, pmd, start, end);
+
+	/*
+	 * Try again to free the PMD page if haven't succeeded above.
+	 */
+	if (!pud_none(*pud))
+		if (try_to_free_pmd_page((pmd_t *)pud_page_vaddr(*pud)))
+			pud_clear(pud);
+}
+
+static void unmap_pud_range(pgd_t *pgd, unsigned long start, unsigned long end)
+{
+	pud_t *pud = pud_offset(pgd, start);
+
+	/*
+	 * Not on a GB page boundary?
+	 */
+	if (start & (PUD_SIZE - 1)) {
+		unsigned long next_page = (start + PUD_SIZE) & PUD_MASK;
+		unsigned long pre_end	= min_t(unsigned long, end, next_page);
+
+		unmap_pmd_range(pud, start, pre_end);
+
+		start = pre_end;
+		pud++;
+	}
+
+	/*
+	 * Try to unmap in 1G chunks?
+	 */
+	while (end - start >= PUD_SIZE) {
+
+		if (pud_large(*pud))
+			pud_clear(pud);
+		else
+			unmap_pmd_range(pud, start, start + PUD_SIZE);
+
+		start += PUD_SIZE;
+		pud++;
+	}
+
+	/*
+	 * 2M leftovers?
+	 */
+	if (start < end)
+		unmap_pmd_range(pud, start, end);
+
+	/*
+	 * No need to try to free the PUD page because we'll free it in
+	 * populate_pgd's error path
+	 */
+}
+
+static int alloc_pte_page(pmd_t *pmd)
+{
+	pte_t *pte = (pte_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+	if (!pte)
+		return -1;
+
+	set_pmd(pmd, __pmd(__pa(pte) | _KERNPG_TABLE));
+	return 0;
+}
+
+static int alloc_pmd_page(pud_t *pud)
+{
+	pmd_t *pmd = (pmd_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+	if (!pmd)
+		return -1;
+
+	set_pud(pud, __pud(__pa(pmd) | _KERNPG_TABLE));
+	return 0;
+}
+
+static void populate_pte(struct cpa_data *cpa,
+			 unsigned long start, unsigned long end,
+			 unsigned num_pages, pmd_t *pmd, pgprot_t pgprot)
+{
+	pte_t *pte;
+
+	pte = pte_offset_kernel(pmd, start);
+
+	while (num_pages-- && start < end) {
+
+		/* deal with the NX bit */
+		if (!(pgprot_val(pgprot) & _PAGE_NX))
+			cpa->pfn &= ~_PAGE_NX;
+
+		set_pte(pte, pfn_pte(cpa->pfn >> PAGE_SHIFT, pgprot));
+
+		start	 += PAGE_SIZE;
+		cpa->pfn += PAGE_SIZE;
+		pte++;
+	}
+}
+
+static int populate_pmd(struct cpa_data *cpa,
+			unsigned long start, unsigned long end,
+			unsigned num_pages, pud_t *pud, pgprot_t pgprot)
+{
+	unsigned int cur_pages = 0;
+	pmd_t *pmd;
+
+	/*
+	 * Not on a 2M boundary?
+	 */
+	if (start & (PMD_SIZE - 1)) {
+		unsigned long pre_end = start + (num_pages << PAGE_SHIFT);
+		unsigned long next_page = (start + PMD_SIZE) & PMD_MASK;
+
+		pre_end   = min_t(unsigned long, pre_end, next_page);
+		cur_pages = (pre_end - start) >> PAGE_SHIFT;
+		cur_pages = min_t(unsigned int, num_pages, cur_pages);
+
+		/*
+		 * Need a PTE page?
+		 */
+		pmd = pmd_offset(pud, start);
+		if (pmd_none(*pmd))
+			if (alloc_pte_page(pmd))
+				return -1;
+
+		populate_pte(cpa, start, pre_end, cur_pages, pmd, pgprot);
+
+		start = pre_end;
+	}
+
+	/*
+	 * We mapped them all?
+	 */
+	if (num_pages == cur_pages)
+		return cur_pages;
+
+	while (end - start >= PMD_SIZE) {
+
+		/*
+		 * We cannot use a 1G page so allocate a PMD page if needed.
+		 */
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		pmd = pmd_offset(pud, start);
+
+		set_pmd(pmd, __pmd(cpa->pfn | _PAGE_PSE | massage_pgprot(pgprot)));
+
+		start	  += PMD_SIZE;
+		cpa->pfn  += PMD_SIZE;
+		cur_pages += PMD_SIZE >> PAGE_SHIFT;
+	}
+
+	/*
+	 * Map trailing 4K pages.
+	 */
+	if (start < end) {
+		pmd = pmd_offset(pud, start);
+		if (pmd_none(*pmd))
+			if (alloc_pte_page(pmd))
+				return -1;
+
+		populate_pte(cpa, start, end, num_pages - cur_pages,
+			     pmd, pgprot);
+	}
+	return num_pages;
+}
+
+static int populate_pud(struct cpa_data *cpa, unsigned long start, pgd_t *pgd,
+			pgprot_t pgprot)
+{
+	pud_t *pud;
+	unsigned long end;
+	int cur_pages = 0;
+
+	end = start + (cpa->numpages << PAGE_SHIFT);
+
+	/*
+	 * Not on a Gb page boundary? => map everything up to it with
+	 * smaller pages.
+	 */
+	if (start & (PUD_SIZE - 1)) {
+		unsigned long pre_end;
+		unsigned long next_page = (start + PUD_SIZE) & PUD_MASK;
+
+		pre_end   = min_t(unsigned long, end, next_page);
+		cur_pages = (pre_end - start) >> PAGE_SHIFT;
+		cur_pages = min_t(int, (int)cpa->numpages, cur_pages);
+
+		pud = pud_offset(pgd, start);
+
+		/*
+		 * Need a PMD page?
+		 */
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		cur_pages = populate_pmd(cpa, start, pre_end, cur_pages,
+					 pud, pgprot);
+		if (cur_pages < 0)
+			return cur_pages;
+
+		start = pre_end;
+	}
+
+	/* We mapped them all? */
+	if (cpa->numpages == cur_pages)
+		return cur_pages;
+
+	pud = pud_offset(pgd, start);
+
+	/*
+	 * Map everything starting from the Gb boundary, possibly with 1G pages
+	 */
+	while (end - start >= PUD_SIZE) {
+		set_pud(pud, __pud(cpa->pfn | _PAGE_PSE | massage_pgprot(pgprot)));
+
+		start	  += PUD_SIZE;
+		cpa->pfn  += PUD_SIZE;
+		cur_pages += PUD_SIZE >> PAGE_SHIFT;
+		pud++;
+	}
+
+	/* Map trailing leftover */
+	if (start < end) {
+		int tmp;
+
+		pud = pud_offset(pgd, start);
+		if (pud_none(*pud))
+			if (alloc_pmd_page(pud))
+				return -1;
+
+		tmp = populate_pmd(cpa, start, end, cpa->numpages - cur_pages,
+				   pud, pgprot);
+		if (tmp < 0)
+			return cur_pages;
+
+		cur_pages += tmp;
+	}
+	return cur_pages;
+}
+
+/*
+ * Restrictions for kernel page table do not necessarily apply when mapping in
+ * an alternate PGD.
+ */
+static int populate_pgd(struct cpa_data *cpa, unsigned long addr)
+{
+	pgprot_t pgprot = __pgprot(_KERNPG_TABLE);
+	bool allocd_pgd = false;
+	pgd_t *pgd_entry;
+	pud_t *pud = NULL;	/* shut up gcc */
+	int ret;
+
+	pgd_entry = cpa->pgd + pgd_index(addr);
+
+	/*
+	 * Allocate a PUD page and hand it down for mapping.
+	 */
+	if (pgd_none(*pgd_entry)) {
+		pud = (pud_t *)get_zeroed_page(GFP_KERNEL | __GFP_NOTRACK);
+		if (!pud)
+			return -1;
+
+		set_pgd(pgd_entry, __pgd(__pa(pud) | _KERNPG_TABLE));
+		allocd_pgd = true;
+	}
+
+	pgprot_val(pgprot) &= ~pgprot_val(cpa->mask_clr);
+	pgprot_val(pgprot) |=  pgprot_val(cpa->mask_set);
+
+	ret = populate_pud(cpa, addr, pgd_entry, pgprot);
+	if (ret < 0) {
+		unmap_pud_range(pgd_entry, addr,
+				addr + (cpa->numpages << PAGE_SHIFT));
+
+		if (allocd_pgd) {
+			/*
+			 * If I allocated this PUD page, I can just as well
+			 * free it in this error path.
+			 */
+			pgd_clear(pgd_entry);
+			free_page((unsigned long)pud);
+		}
+		return ret;
+	}
+	cpa->numpages = ret;
+	return 0;
+}
+
 static int __cpa_process_fault(struct cpa_data *cpa, unsigned long vaddr,
 			       int primary)
 {
+	if (cpa->pgd)
+		return populate_pgd(cpa, vaddr);
+
 	/*
 	 * Ignore all non primary paths.
 	 */
@@ -697,7 +1090,7 @@ static int __change_page_attr(struct cpa_data *cpa, int primary)
 	else
 		address = *cpa->vaddr;
 repeat:
-	kpte = lookup_address(address, &level);
+	kpte = _lookup_address_cpa(cpa, address, &level);
 	if (!kpte)
 		return __cpa_process_fault(cpa, address, primary);
 
@@ -761,7 +1154,7 @@ repeat:
 	/*
 	 * We have to split the large page:
 	 */
-	err = split_large_page(kpte, address);
+	err = split_large_page(cpa, kpte, address);
 	if (!err) {
 		/*
 	 	 * Do a global flush tlb after splitting the large page
@@ -910,6 +1303,8 @@ static int change_page_attr_set_clr(unsigned long *addr, int numpages,
 	int ret, cache, checkalias;
 	unsigned long baddr = 0;
 
+	memset(&cpa, 0, sizeof(cpa));
+
 	/*
 	 * Check, if we are requested to change a not supported
 	 * feature:
@@ -1356,6 +1751,7 @@ static int __set_pages_p(struct page *page, int numpages)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
+				.pgd = NULL,
 				.numpages = numpages,
 				.mask_set = __pgprot(_PAGE_PRESENT | _PAGE_RW),
 				.mask_clr = __pgprot(0),
@@ -1374,6 +1770,7 @@ static int __set_pages_np(struct page *page, int numpages)
 {
 	unsigned long tempaddr = (unsigned long) page_address(page);
 	struct cpa_data cpa = { .vaddr = &tempaddr,
+				.pgd = NULL,
 				.numpages = numpages,
 				.mask_set = __pgprot(0),
 				.mask_clr = __pgprot(_PAGE_PRESENT | _PAGE_RW),
@@ -1434,6 +1831,36 @@ bool kernel_page_present(struct page *page)
 
 #endif /* CONFIG_DEBUG_PAGEALLOC */
 
+int kernel_map_pages_in_pgd(pgd_t *pgd, u64 pfn, unsigned long address,
+			    unsigned numpages, unsigned long page_flags)
+{
+	int retval = -EINVAL;
+
+	struct cpa_data cpa = {
+		.vaddr = &address,
+		.pfn = pfn,
+		.pgd = pgd,
+		.numpages = numpages,
+		.mask_set = __pgprot(0),
+		.mask_clr = __pgprot(0),
+		.flags = 0,
+	};
+
+	if (!(__supported_pte_mask & _PAGE_NX))
+		goto out;
+
+	if (!(page_flags & _PAGE_NX))
+		cpa.mask_clr = __pgprot(_PAGE_NX);
+
+	cpa.mask_set = __pgprot(_PAGE_PRESENT | page_flags);
+
+	retval = __change_page_attr_set_clr(&cpa, 0);
+	__flush_tlb_all();
+
+out:
+	return retval;
+}
+
 /*
  * The testcases use internal knowledge of the implementation that shouldn't
  * be exposed to the rest of the kernel. Include these directly here.
diff --git a/arch/x86/platform/efi/efi.c b/arch/x86/platform/efi/efi.c
index cceb813..d62ec87 100644
--- a/arch/x86/platform/efi/efi.c
+++ b/arch/x86/platform/efi/efi.c
@@ -12,6 +12,8 @@
  *	Bibo Mao <bibo.mao@intel.com>
  *	Chandramouli Narayanan <mouli@linux.intel.com>
  *	Huang Ying <ying.huang@intel.com>
+ * Copyright (C) 2013 SuSE Labs
+ *	Borislav Petkov <bp@suse.de> - runtime services VA mapping
  *
  * Copied from efi_32.c to eliminate the duplicated code between EFI
  * 32/64 support code. --ying 2007-10-26
@@ -51,7 +53,7 @@
 #include <asm/x86_init.h>
 #include <asm/rtc.h>
 
-#define EFI_DEBUG	1
+#define EFI_DEBUG
 
 #define EFI_MIN_RESERVE 5120
 
@@ -74,6 +76,8 @@ static __initdata efi_config_table_type_t arch_tables[] = {
 	{NULL_GUID, NULL, NULL},
 };
 
+u64 efi_setup;		/* efi setup_data physical address */
+
 /*
  * Returns 1 if 'facility' is enabled, 0 otherwise.
  */
@@ -110,7 +114,6 @@ static int __init setup_storage_paranoia(char *arg)
 }
 early_param("efi_no_storage_paranoia", setup_storage_paranoia);
 
-
 static efi_status_t virt_efi_get_time(efi_time_t *tm, efi_time_cap_t *tc)
 {
 	unsigned long flags;
@@ -398,9 +401,9 @@ int __init efi_memblock_x86_reserve_range(void)
 	return 0;
 }
 
-#if EFI_DEBUG
 static void __init print_efi_memmap(void)
 {
+#ifdef EFI_DEBUG
 	efi_memory_desc_t *md;
 	void *p;
 	int i;
@@ -415,8 +418,8 @@ static void __init print_efi_memmap(void)
 			md->phys_addr + (md->num_pages << EFI_PAGE_SHIFT),
 			(md->num_pages >> (20 - EFI_PAGE_SHIFT)));
 	}
-}
 #endif  /*  EFI_DEBUG  */
+}
 
 void __init efi_reserve_boot_services(void)
 {
@@ -436,7 +439,7 @@ void __init efi_reserve_boot_services(void)
 		 * - Not within any part of the kernel
 		 * - Not the bios reserved area
 		*/
-		if ((start+size >= __pa_symbol(_text)
+		if ((start + size > __pa_symbol(_text)
 				&& start <= __pa_symbol(_end)) ||
 			!e820_all_mapped(start, start+size, E820_RAM) ||
 			memblock_is_region_reserved(start, size)) {
@@ -489,18 +492,27 @@ static int __init efi_systab_init(void *phys)
 {
 	if (efi_enabled(EFI_64BIT)) {
 		efi_system_table_64_t *systab64;
+		struct efi_setup_data *data = NULL;
 		u64 tmp = 0;
 
+		if (efi_setup) {
+			data = early_memremap(efi_setup, sizeof(*data));
+			if (!data)
+				return -ENOMEM;
+		}
 		systab64 = early_ioremap((unsigned long)phys,
 					 sizeof(*systab64));
 		if (systab64 == NULL) {
 			pr_err("Couldn't map the system table!\n");
+			if (data)
+				early_iounmap(data, sizeof(*data));
 			return -ENOMEM;
 		}
 
 		efi_systab.hdr = systab64->hdr;
-		efi_systab.fw_vendor = systab64->fw_vendor;
-		tmp |= systab64->fw_vendor;
+		efi_systab.fw_vendor = data ? (unsigned long)data->fw_vendor :
+					      systab64->fw_vendor;
+		tmp |= data ? data->fw_vendor : systab64->fw_vendor;
 		efi_systab.fw_revision = systab64->fw_revision;
 		efi_systab.con_in_handle = systab64->con_in_handle;
 		tmp |= systab64->con_in_handle;
@@ -514,15 +526,20 @@ static int __init efi_systab_init(void *phys)
 		tmp |= systab64->stderr_handle;
 		efi_systab.stderr = systab64->stderr;
 		tmp |= systab64->stderr;
-		efi_systab.runtime = (void *)(unsigned long)systab64->runtime;
-		tmp |= systab64->runtime;
+		efi_systab.runtime = data ?
+				     (void *)(unsigned long)data->runtime :
+				     (void *)(unsigned long)systab64->runtime;
+		tmp |= data ? data->runtime : systab64->runtime;
 		efi_systab.boottime = (void *)(unsigned long)systab64->boottime;
 		tmp |= systab64->boottime;
 		efi_systab.nr_tables = systab64->nr_tables;
-		efi_systab.tables = systab64->tables;
-		tmp |= systab64->tables;
+		efi_systab.tables = data ? (unsigned long)data->tables :
+					   systab64->tables;
+		tmp |= data ? data->tables : systab64->tables;
 
 		early_iounmap(systab64, sizeof(*systab64));
+		if (data)
+			early_iounmap(data, sizeof(*data));
 #ifdef CONFIG_X86_32
 		if (tmp >> 32) {
 			pr_err("EFI data located above 4GB, disabling EFI.\n");
@@ -626,6 +643,62 @@ static int __init efi_memmap_init(void)
 	return 0;
 }
 
+/*
+ * A number of config table entries get remapped to virtual addresses
+ * after entering EFI virtual mode. However, the kexec kernel requires
+ * their physical addresses therefore we pass them via setup_data and
+ * correct those entries to their respective physical addresses here.
+ *
+ * Currently only handles smbios which is necessary for some firmware
+ * implementation.
+ */
+static int __init efi_reuse_config(u64 tables, int nr_tables)
+{
+	int i, sz, ret = 0;
+	void *p, *tablep;
+	struct efi_setup_data *data;
+
+	if (!efi_setup)
+		return 0;
+
+	if (!efi_enabled(EFI_64BIT))
+		return 0;
+
+	data = early_memremap(efi_setup, sizeof(*data));
+	if (!data) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	if (!data->smbios)
+		goto out_memremap;
+
+	sz = sizeof(efi_config_table_64_t);
+
+	p = tablep = early_memremap(tables, nr_tables * sz);
+	if (!p) {
+		pr_err("Could not map Configuration table!\n");
+		ret = -ENOMEM;
+		goto out_memremap;
+	}
+
+	for (i = 0; i < efi.systab->nr_tables; i++) {
+		efi_guid_t guid;
+
+		guid = ((efi_config_table_64_t *)p)->guid;
+
+		if (!efi_guidcmp(guid, SMBIOS_TABLE_GUID))
+			((efi_config_table_64_t *)p)->table = data->smbios;
+		p += sz;
+	}
+	early_iounmap(tablep, nr_tables * sz);
+
+out_memremap:
+	early_iounmap(data, sizeof(*data));
+out:
+	return ret;
+}
+
 void __init efi_init(void)
 {
 	efi_char16_t *c16;
@@ -651,6 +724,10 @@ void __init efi_init(void)
 
 	set_bit(EFI_SYSTEM_TABLES, &x86_efi_facility);
 
+	efi.config_table = (unsigned long)efi.systab->tables;
+	efi.fw_vendor	 = (unsigned long)efi.systab->fw_vendor;
+	efi.runtime	 = (unsigned long)efi.systab->runtime;
+
 	/*
 	 * Show what we know for posterity
 	 */
@@ -667,6 +744,9 @@ void __init efi_init(void)
 		efi.systab->hdr.revision >> 16,
 		efi.systab->hdr.revision & 0xffff, vendor);
 
+	if (efi_reuse_config(efi.systab->tables, efi.systab->nr_tables))
+		return;
+
 	if (efi_config_init(arch_tables))
 		return;
 
@@ -684,15 +764,12 @@ void __init efi_init(void)
 			return;
 		set_bit(EFI_RUNTIME_SERVICES, &x86_efi_facility);
 	}
-
 	if (efi_memmap_init())
 		return;
 
 	set_bit(EFI_MEMMAP, &x86_efi_facility);
 
-#if EFI_DEBUG
 	print_efi_memmap();
-#endif
 }
 
 void __init efi_late_init(void)
@@ -741,36 +818,38 @@ void efi_memory_uc(u64 addr, unsigned long size)
 	set_memory_uc(addr, npages);
 }
 
-/*
- * This function will switch the EFI runtime services to virtual mode.
- * Essentially, look through the EFI memmap and map every region that
- * has the runtime attribute bit set in its memory descriptor and update
- * that memory descriptor with the virtual address obtained from ioremap().
- * This enables the runtime services to be called without having to
- * thunk back into physical mode for every invocation.
- */
-void __init efi_enter_virtual_mode(void)
+void __init old_map_region(efi_memory_desc_t *md)
 {
-	efi_memory_desc_t *md, *prev_md = NULL;
-	efi_status_t status;
+	u64 start_pfn, end_pfn, end;
 	unsigned long size;
-	u64 end, systab, start_pfn, end_pfn;
-	void *p, *va, *new_memmap = NULL;
-	int count = 0;
+	void *va;
 
-	efi.systab = NULL;
+	start_pfn = PFN_DOWN(md->phys_addr);
+	size	  = md->num_pages << PAGE_SHIFT;
+	end	  = md->phys_addr + size;
+	end_pfn   = PFN_UP(end);
 
-	/*
-	 * We don't do virtual mode, since we don't do runtime services, on
-	 * non-native EFI
-	 */
+	if (pfn_range_is_mapped(start_pfn, end_pfn)) {
+		va = __va(md->phys_addr);
 
-	if (!efi_is_native()) {
-		efi_unmap_memmap();
-		return;
-	}
+		if (!(md->attribute & EFI_MEMORY_WB))
+			efi_memory_uc((u64)(unsigned long)va, size);
+	} else
+		va = efi_ioremap(md->phys_addr, size,
+				 md->type, md->attribute);
+
+	md->virt_addr = (u64) (unsigned long) va;
+	if (!va)
+		pr_err("ioremap of 0x%llX failed!\n",
+		       (unsigned long long)md->phys_addr);
+}
+
+/* Merge contiguous regions of the same type and attribute */
+static void __init efi_merge_regions(void)
+{
+	void *p;
+	efi_memory_desc_t *md, *prev_md = NULL;
 
-	/* Merge contiguous regions of the same type and attribute */
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		u64 prev_size;
 		md = p;
@@ -796,6 +875,77 @@ void __init efi_enter_virtual_mode(void)
 		}
 		prev_md = md;
 	}
+}
+
+static void __init get_systab_virt_addr(efi_memory_desc_t *md)
+{
+	unsigned long size;
+	u64 end, systab;
+
+	size = md->num_pages << EFI_PAGE_SHIFT;
+	end = md->phys_addr + size;
+	systab = (u64)(unsigned long)efi_phys.systab;
+	if (md->phys_addr <= systab && systab < end) {
+		systab += md->virt_addr - md->phys_addr;
+		efi.systab = (efi_system_table_t *)(unsigned long)systab;
+	}
+}
+
+static int __init save_runtime_map(void)
+{
+	efi_memory_desc_t *md;
+	void *tmp, *p, *q = NULL;
+	int count = 0;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+
+		if (!(md->attribute & EFI_MEMORY_RUNTIME) ||
+		    (md->type == EFI_BOOT_SERVICES_CODE) ||
+		    (md->type == EFI_BOOT_SERVICES_DATA))
+			continue;
+		tmp = krealloc(q, (count + 1) * memmap.desc_size, GFP_KERNEL);
+		if (!tmp)
+			goto out;
+		q = tmp;
+
+		memcpy(q + count * memmap.desc_size, md, memmap.desc_size);
+		count++;
+	}
+
+	efi_runtime_map_setup(q, count, memmap.desc_size);
+
+	return 0;
+out:
+	kfree(q);
+	return -ENOMEM;
+}
+
+/*
+ * Map efi regions which were passed via setup_data. The virt_addr is a fixed
+ * addr which was used in first kernel of a kexec boot.
+ */
+static void __init efi_map_regions_fixed(void)
+{
+	void *p;
+	efi_memory_desc_t *md;
+
+	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
+		md = p;
+		efi_map_region_fixed(md); /* FIXME: add error handling */
+		get_systab_virt_addr(md);
+	}
+
+}
+
+/*
+ * Map efi memory ranges for runtime serivce and update new_memmap with virtual
+ * addresses.
+ */
+static void * __init efi_map_regions(int *count)
+{
+	efi_memory_desc_t *md;
+	void *p, *tmp, *new_memmap = NULL;
 
 	for (p = memmap.map; p < memmap.map_end; p += memmap.desc_size) {
 		md = p;
@@ -807,53 +957,95 @@ void __init efi_enter_virtual_mode(void)
 				continue;
 		}
 
-		size = md->num_pages << EFI_PAGE_SHIFT;
-		end = md->phys_addr + size;
+		efi_map_region(md);
+		get_systab_virt_addr(md);
 
-		start_pfn = PFN_DOWN(md->phys_addr);
-		end_pfn = PFN_UP(end);
-		if (pfn_range_is_mapped(start_pfn, end_pfn)) {
-			va = __va(md->phys_addr);
+		tmp = krealloc(new_memmap, (*count + 1) * memmap.desc_size,
+			       GFP_KERNEL);
+		if (!tmp)
+			goto out;
+		new_memmap = tmp;
+		memcpy(new_memmap + (*count * memmap.desc_size), md,
+		       memmap.desc_size);
+		(*count)++;
+	}
 
-			if (!(md->attribute & EFI_MEMORY_WB))
-				efi_memory_uc((u64)(unsigned long)va, size);
-		} else
-			va = efi_ioremap(md->phys_addr, size,
-					 md->type, md->attribute);
+	return new_memmap;
+out:
+	kfree(new_memmap);
+	return NULL;
+}
+
+/*
+ * This function will switch the EFI runtime services to virtual mode.
+ * Essentially, we look through the EFI memmap and map every region that
+ * has the runtime attribute bit set in its memory descriptor into the
+ * ->trampoline_pgd page table using a top-down VA allocation scheme.
+ *
+ * The old method which used to update that memory descriptor with the
+ * virtual address obtained from ioremap() is still supported when the
+ * kernel is booted with efi=old_map on its command line. Same old
+ * method enabled the runtime services to be called without having to
+ * thunk back into physical mode for every invocation.
+ *
+ * The new method does a pagetable switch in a preemption-safe manner
+ * so that we're in a different address space when calling a runtime
+ * function. For function arguments passing we do copy the PGDs of the
+ * kernel page table into ->trampoline_pgd prior to each call.
+ *
+ * Specially for kexec boot, efi runtime maps in previous kernel should
+ * be passed in via setup_data. In that case runtime ranges will be mapped
+ * to the same virtual addresses as the first kernel.
+ */
+void __init efi_enter_virtual_mode(void)
+{
+	efi_status_t status;
+	void *new_memmap = NULL;
+	int err, count = 0;
 
-		md->virt_addr = (u64) (unsigned long) va;
+	efi.systab = NULL;
 
-		if (!va) {
-			pr_err("ioremap of 0x%llX failed!\n",
-			       (unsigned long long)md->phys_addr);
-			continue;
-		}
+	/*
+	 * We don't do virtual mode, since we don't do runtime services, on
+	 * non-native EFI
+	 */
+	if (!efi_is_native()) {
+		efi_unmap_memmap();
+		return;
+	}
 
-		systab = (u64) (unsigned long) efi_phys.systab;
-		if (md->phys_addr <= systab && systab < end) {
-			systab += md->virt_addr - md->phys_addr;
-			efi.systab = (efi_system_table_t *) (unsigned long) systab;
+	if (efi_setup) {
+		efi_map_regions_fixed();
+	} else {
+		efi_merge_regions();
+		new_memmap = efi_map_regions(&count);
+		if (!new_memmap) {
+			pr_err("Error reallocating memory, EFI runtime non-functional!\n");
+			return;
 		}
-		new_memmap = krealloc(new_memmap,
-				      (count + 1) * memmap.desc_size,
-				      GFP_KERNEL);
-		memcpy(new_memmap + (count * memmap.desc_size), md,
-		       memmap.desc_size);
-		count++;
 	}
 
+	err = save_runtime_map();
+	if (err)
+		pr_err("Error saving runtime map, efi runtime on kexec non-functional!!\n");
+
 	BUG_ON(!efi.systab);
 
-	status = phys_efi_set_virtual_address_map(
-		memmap.desc_size * count,
-		memmap.desc_size,
-		memmap.desc_version,
-		(efi_memory_desc_t *)__pa(new_memmap));
+	efi_setup_page_tables();
+	efi_sync_low_kernel_mappings();
 
-	if (status != EFI_SUCCESS) {
-		pr_alert("Unable to switch EFI into virtual mode "
-			 "(status=%lx)!\n", status);
-		panic("EFI call to SetVirtualAddressMap() failed!");
+	if (!efi_setup) {
+		status = phys_efi_set_virtual_address_map(
+			memmap.desc_size * count,
+			memmap.desc_size,
+			memmap.desc_version,
+			(efi_memory_desc_t *)__pa(new_memmap));
+
+		if (status != EFI_SUCCESS) {
+			pr_alert("Unable to switch EFI into virtual mode (status=%lx)!\n",
+				 status);
+			panic("EFI call to SetVirtualAddressMap() failed!");
+		}
 	}
 
 	/*
@@ -876,7 +1068,8 @@ void __init efi_enter_virtual_mode(void)
 	efi.query_variable_info = virt_efi_query_variable_info;
 	efi.update_capsule = virt_efi_update_capsule;
 	efi.query_capsule_caps = virt_efi_query_capsule_caps;
-	if (__supported_pte_mask & _PAGE_NX)
+
+	if (efi_enabled(EFI_OLD_MEMMAP) && (__supported_pte_mask & _PAGE_NX))
 		runtime_code_page_mkexec();
 
 	kfree(new_memmap);
@@ -1006,3 +1199,15 @@ efi_status_t efi_query_variable_store(u32 attributes, unsigned long size)
 	return EFI_SUCCESS;
 }
 EXPORT_SYMBOL_GPL(efi_query_variable_store);
+
+static int __init parse_efi_cmdline(char *str)
+{
+	if (*str == '=')
+		str++;
+
+	if (!strncmp(str, "old_map", 7))
+		set_bit(EFI_OLD_MEMMAP, &x86_efi_facility);
+
+	return 0;
+}
+early_param("efi", parse_efi_cmdline);
diff --git a/arch/x86/platform/efi/efi_32.c b/arch/x86/platform/efi/efi_32.c
index 40e4469..249b183 100644
--- a/arch/x86/platform/efi/efi_32.c
+++ b/arch/x86/platform/efi/efi_32.c
@@ -37,9 +37,19 @@
  * claim EFI runtime service handler exclusively and to duplicate a memory in
  * low memory space say 0 - 3G.
  */
-
 static unsigned long efi_rt_eflags;
 
+void efi_sync_low_kernel_mappings(void) {}
+void efi_setup_page_tables(void) {}
+
+void __init efi_map_region(efi_memory_desc_t *md)
+{
+	old_map_region(md);
+}
+
+void __init efi_map_region_fixed(efi_memory_desc_t *md) {}
+void __init parse_efi_setup(u64 phys_addr, u32 data_len) {}
+
 void efi_call_phys_prelog(void)
 {
 	struct desc_ptr gdt_descr;
diff --git a/arch/x86/platform/efi/efi_64.c b/arch/x86/platform/efi/efi_64.c
index 39a0e7f..6284f15 100644
--- a/arch/x86/platform/efi/efi_64.c
+++ b/arch/x86/platform/efi/efi_64.c
@@ -38,10 +38,28 @@
 #include <asm/efi.h>
 #include <asm/cacheflush.h>
 #include <asm/fixmap.h>
+#include <asm/realmode.h>
 
 static pgd_t *save_pgd __initdata;
 static unsigned long efi_flags __initdata;
 
+/*
+ * We allocate runtime services regions bottom-up, starting from -4G, i.e.
+ * 0xffff_ffff_0000_0000 and limit EFI VA mapping space to 64G.
+ */
+static u64 efi_va	= -4 * (1UL << 30);
+#define EFI_VA_END	(-68 * (1UL << 30))
+
+/*
+ * Scratch space used for switching the pagetable in the EFI stub
+ */
+struct efi_scratch {
+	u64 r15;
+	u64 prev_cr3;
+	pgd_t *efi_pgt;
+	bool use_pgd;
+};
+
 static void __init early_code_mapping_set_exec(int executable)
 {
 	efi_memory_desc_t *md;
@@ -65,6 +83,9 @@ void __init efi_call_phys_prelog(void)
 	int pgd;
 	int n_pgds;
 
+	if (!efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
 	early_code_mapping_set_exec(1);
 	local_irq_save(efi_flags);
 
@@ -86,6 +107,10 @@ void __init efi_call_phys_epilog(void)
 	 */
 	int pgd;
 	int n_pgds = DIV_ROUND_UP((max_pfn << PAGE_SHIFT) , PGDIR_SIZE);
+
+	if (!efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
 	for (pgd = 0; pgd < n_pgds; pgd++)
 		set_pgd(pgd_offset_k(pgd * PGDIR_SIZE), save_pgd[pgd]);
 	kfree(save_pgd);
@@ -94,6 +119,96 @@ void __init efi_call_phys_epilog(void)
 	early_code_mapping_set_exec(0);
 }
 
+/*
+ * Add low kernel mappings for passing arguments to EFI functions.
+ */
+void efi_sync_low_kernel_mappings(void)
+{
+	unsigned num_pgds;
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return;
+
+	num_pgds = pgd_index(MODULES_END - 1) - pgd_index(PAGE_OFFSET);
+
+	memcpy(pgd + pgd_index(PAGE_OFFSET),
+		init_mm.pgd + pgd_index(PAGE_OFFSET),
+		sizeof(pgd_t) * num_pgds);
+}
+
+void efi_setup_page_tables(void)
+{
+	efi_scratch.efi_pgt = (pgd_t *)(unsigned long)real_mode_header->trampoline_pgd;
+
+	if (!efi_enabled(EFI_OLD_MEMMAP))
+		efi_scratch.use_pgd = true;
+}
+
+static void __init __map_region(efi_memory_desc_t *md, u64 va)
+{
+	pgd_t *pgd = (pgd_t *)__va(real_mode_header->trampoline_pgd);
+	unsigned long pf = 0;
+
+	if (!(md->attribute & EFI_MEMORY_WB))
+		pf |= _PAGE_PCD;
+
+	if (kernel_map_pages_in_pgd(pgd, md->phys_addr, va, md->num_pages, pf))
+		pr_warn("Error mapping PA 0x%llx -> VA 0x%llx!\n",
+			   md->phys_addr, va);
+}
+
+void __init efi_map_region(efi_memory_desc_t *md)
+{
+	unsigned long size = md->num_pages << PAGE_SHIFT;
+	u64 pa = md->phys_addr;
+
+	if (efi_enabled(EFI_OLD_MEMMAP))
+		return old_map_region(md);
+
+	/*
+	 * Make sure the 1:1 mappings are present as a catch-all for b0rked
+	 * firmware which doesn't update all internal pointers after switching
+	 * to virtual mode and would otherwise crap on us.
+	 */
+	__map_region(md, md->phys_addr);
+
+	efi_va -= size;
+
+	/* Is PA 2M-aligned? */
+	if (!(pa & (PMD_SIZE - 1))) {
+		efi_va &= PMD_MASK;
+	} else {
+		u64 pa_offset = pa & (PMD_SIZE - 1);
+		u64 prev_va = efi_va;
+
+		/* get us the same offset within this 2M page */
+		efi_va = (efi_va & PMD_MASK) + pa_offset;
+
+		if (efi_va > prev_va)
+			efi_va -= PMD_SIZE;
+	}
+
+	if (efi_va < EFI_VA_END) {
+		pr_warn(FW_WARN "VA address range overflow!\n");
+		return;
+	}
+
+	/* Do the VA map */
+	__map_region(md, efi_va);
+	md->virt_addr = efi_va;
+}
+
+/*
+ * kexec kernel will use efi_map_region_fixed to map efi runtime memory ranges.
+ * md->virt_addr is the original virtual address which had been mapped in kexec
+ * 1st kernel.
+ */
+void __init efi_map_region_fixed(efi_memory_desc_t *md)
+{
+	__map_region(md, md->virt_addr);
+}
+
 void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 				 u32 type, u64 attribute)
 {
@@ -113,3 +228,8 @@ void __iomem *__init efi_ioremap(unsigned long phys_addr, unsigned long size,
 
 	return (void __iomem *)__va(phys_addr);
 }
+
+void __init parse_efi_setup(u64 phys_addr, u32 data_len)
+{
+	efi_setup = phys_addr + sizeof(struct setup_data);
+}
diff --git a/arch/x86/platform/efi/efi_stub_64.S b/arch/x86/platform/efi/efi_stub_64.S
index 4c07cca..88073b1 100644
--- a/arch/x86/platform/efi/efi_stub_64.S
+++ b/arch/x86/platform/efi/efi_stub_64.S
@@ -34,10 +34,47 @@
 	mov %rsi, %cr0;			\
 	mov (%rsp), %rsp
 
+	/* stolen from gcc */
+	.macro FLUSH_TLB_ALL
+	movq %r15, efi_scratch(%rip)
+	movq %r14, efi_scratch+8(%rip)
+	movq %cr4, %r15
+	movq %r15, %r14
+	andb $0x7f, %r14b
+	movq %r14, %cr4
+	movq %r15, %cr4
+	movq efi_scratch+8(%rip), %r14
+	movq efi_scratch(%rip), %r15
+	.endm
+
+	.macro SWITCH_PGT
+	cmpb $0, efi_scratch+24(%rip)
+	je 1f
+	movq %r15, efi_scratch(%rip)		# r15
+	# save previous CR3
+	movq %cr3, %r15
+	movq %r15, efi_scratch+8(%rip)		# prev_cr3
+	movq efi_scratch+16(%rip), %r15		# EFI pgt
+	movq %r15, %cr3
+	1:
+	.endm
+
+	.macro RESTORE_PGT
+	cmpb $0, efi_scratch+24(%rip)
+	je 2f
+	movq efi_scratch+8(%rip), %r15
+	movq %r15, %cr3
+	movq efi_scratch(%rip), %r15
+	FLUSH_TLB_ALL
+	2:
+	.endm
+
 ENTRY(efi_call0)
 	SAVE_XMM
 	subq $32, %rsp
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -47,7 +84,9 @@ ENTRY(efi_call1)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -57,7 +96,9 @@ ENTRY(efi_call2)
 	SAVE_XMM
 	subq $32, %rsp
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -68,7 +109,9 @@ ENTRY(efi_call3)
 	subq $32, %rsp
 	mov  %rcx, %r8
 	mov  %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -80,7 +123,9 @@ ENTRY(efi_call4)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $32, %rsp
 	RESTORE_XMM
 	ret
@@ -93,7 +138,9 @@ ENTRY(efi_call5)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
@@ -109,8 +156,15 @@ ENTRY(efi_call6)
 	mov %r8, %r9
 	mov %rcx, %r8
 	mov %rsi, %rcx
+	SWITCH_PGT
 	call *%rdi
+	RESTORE_PGT
 	addq $48, %rsp
 	RESTORE_XMM
 	ret
 ENDPROC(efi_call6)
+
+	.data
+ENTRY(efi_scratch)
+	.fill 3,8,0
+	.byte 0
diff --git a/drivers/firmware/efi/Kconfig b/drivers/firmware/efi/Kconfig
index 6aecbc8..1e75f48 100644
--- a/drivers/firmware/efi/Kconfig
+++ b/drivers/firmware/efi/Kconfig
@@ -36,6 +36,17 @@ config EFI_VARS_PSTORE_DEFAULT_DISABLE
 	  backend for pstore by default. This setting can be overridden
 	  using the efivars module's pstore_disable parameter.
 
+config EFI_RUNTIME_MAP
+	bool "Export efi runtime maps to sysfs"
+	depends on X86 && EFI && KEXEC
+	default y
+	help
+	  Export efi runtime memory maps to /sys/firmware/efi/runtime-map.
+	  That memory map is used for example by kexec to set up efi virtual
+	  mapping the 2nd kernel, but can also be used for debugging purposes.
+
+	  See also Documentation/ABI/testing/sysfs-firmware-efi-runtime-map.
+
 endmenu
 
 config UEFI_CPER
diff --git a/drivers/firmware/efi/Makefile b/drivers/firmware/efi/Makefile
index 6c2a41e..9553496 100644
--- a/drivers/firmware/efi/Makefile
+++ b/drivers/firmware/efi/Makefile
@@ -5,3 +5,4 @@ obj-$(CONFIG_EFI)			+= efi.o vars.o
 obj-$(CONFIG_EFI_VARS)			+= efivars.o
 obj-$(CONFIG_EFI_VARS_PSTORE)		+= efi-pstore.o
 obj-$(CONFIG_UEFI_CPER)			+= cper.o
+obj-$(CONFIG_EFI_RUNTIME_MAP)		+= runtime-map.o
diff --git a/drivers/firmware/efi/efi.c b/drivers/firmware/efi/efi.c
index 2e2fbde..4753bac 100644
--- a/drivers/firmware/efi/efi.c
+++ b/drivers/firmware/efi/efi.c
@@ -32,6 +32,9 @@ struct efi __read_mostly efi = {
 	.hcdp       = EFI_INVALID_TABLE_ADDR,
 	.uga        = EFI_INVALID_TABLE_ADDR,
 	.uv_systab  = EFI_INVALID_TABLE_ADDR,
+	.fw_vendor  = EFI_INVALID_TABLE_ADDR,
+	.runtime    = EFI_INVALID_TABLE_ADDR,
+	.config_table  = EFI_INVALID_TABLE_ADDR,
 };
 EXPORT_SYMBOL(efi);
 
@@ -71,13 +74,49 @@ static ssize_t systab_show(struct kobject *kobj,
 static struct kobj_attribute efi_attr_systab =
 			__ATTR(systab, 0400, systab_show, NULL);
 
+#define EFI_FIELD(var) efi.var
+
+#define EFI_ATTR_SHOW(name) \
+static ssize_t name##_show(struct kobject *kobj, \
+				struct kobj_attribute *attr, char *buf) \
+{ \
+	return sprintf(buf, "0x%lx\n", EFI_FIELD(name)); \
+}
+
+EFI_ATTR_SHOW(fw_vendor);
+EFI_ATTR_SHOW(runtime);
+EFI_ATTR_SHOW(config_table);
+
+static struct kobj_attribute efi_attr_fw_vendor = __ATTR_RO(fw_vendor);
+static struct kobj_attribute efi_attr_runtime = __ATTR_RO(runtime);
+static struct kobj_attribute efi_attr_config_table = __ATTR_RO(config_table);
+
 static struct attribute *efi_subsys_attrs[] = {
 	&efi_attr_systab.attr,
-	NULL,	/* maybe more in the future? */
+	&efi_attr_fw_vendor.attr,
+	&efi_attr_runtime.attr,
+	&efi_attr_config_table.attr,
+	NULL,
 };
 
+static umode_t efi_attr_is_visible(struct kobject *kobj,
+				   struct attribute *attr, int n)
+{
+	umode_t mode = attr->mode;
+
+	if (attr == &efi_attr_fw_vendor.attr)
+		return (efi.fw_vendor == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_runtime.attr)
+		return (efi.runtime == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+	else if (attr == &efi_attr_config_table.attr)
+		return (efi.config_table == EFI_INVALID_TABLE_ADDR) ? 0 : mode;
+
+	return mode;
+}
+
 static struct attribute_group efi_subsys_attr_group = {
 	.attrs = efi_subsys_attrs,
+	.is_visible = efi_attr_is_visible,
 };
 
 static struct efivars generic_efivars;
@@ -128,6 +167,10 @@ static int __init efisubsys_init(void)
 		goto err_unregister;
 	}
 
+	error = efi_runtime_map_init(efi_kobj);
+	if (error)
+		goto err_remove_group;
+
 	/* and the standard mountpoint for efivarfs */
 	efivars_kobj = kobject_create_and_add("efivars", efi_kobj);
 	if (!efivars_kobj) {
diff --git a/drivers/firmware/efi/runtime-map.c b/drivers/firmware/efi/runtime-map.c
new file mode 100644
index 0000000..97cdd16
--- /dev/null
+++ b/drivers/firmware/efi/runtime-map.c
@@ -0,0 +1,181 @@
+/*
+ * linux/drivers/efi/runtime-map.c
+ * Copyright (C) 2013 Red Hat, Inc., Dave Young <dyoung@redhat.com>
+ *
+ * This file is released under the GPLv2.
+ */
+
+#include <linux/string.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/types.h>
+#include <linux/efi.h>
+#include <linux/slab.h>
+
+#include <asm/setup.h>
+
+static void *efi_runtime_map;
+static int nr_efi_runtime_map;
+static u32 efi_memdesc_size;
+
+struct efi_runtime_map_entry {
+	efi_memory_desc_t md;
+	struct kobject kobj;   /* kobject for each entry */
+};
+
+static struct efi_runtime_map_entry **map_entries;
+
+struct map_attribute {
+	struct attribute attr;
+	ssize_t (*show)(struct efi_runtime_map_entry *entry, char *buf);
+};
+
+static inline struct map_attribute *to_map_attr(struct attribute *attr)
+{
+	return container_of(attr, struct map_attribute, attr);
+}
+
+static ssize_t type_show(struct efi_runtime_map_entry *entry, char *buf)
+{
+	return snprintf(buf, PAGE_SIZE, "0x%x\n", entry->md.type);
+}
+
+#define EFI_RUNTIME_FIELD(var) entry->md.var
+
+#define EFI_RUNTIME_U64_ATTR_SHOW(name) \
+static ssize_t name##_show(struct efi_runtime_map_entry *entry, char *buf) \
+{ \
+	return snprintf(buf, PAGE_SIZE, "0x%llx\n", EFI_RUNTIME_FIELD(name)); \
+}
+
+EFI_RUNTIME_U64_ATTR_SHOW(phys_addr);
+EFI_RUNTIME_U64_ATTR_SHOW(virt_addr);
+EFI_RUNTIME_U64_ATTR_SHOW(num_pages);
+EFI_RUNTIME_U64_ATTR_SHOW(attribute);
+
+static inline struct efi_runtime_map_entry *to_map_entry(struct kobject *kobj)
+{
+	return container_of(kobj, struct efi_runtime_map_entry, kobj);
+}
+
+static ssize_t map_attr_show(struct kobject *kobj, struct attribute *attr,
+			      char *buf)
+{
+	struct efi_runtime_map_entry *entry = to_map_entry(kobj);
+	struct map_attribute *map_attr = to_map_attr(attr);
+
+	return map_attr->show(entry, buf);
+}
+
+static struct map_attribute map_type_attr = __ATTR_RO(type);
+static struct map_attribute map_phys_addr_attr   = __ATTR_RO(phys_addr);
+static struct map_attribute map_virt_addr_attr  = __ATTR_RO(virt_addr);
+static struct map_attribute map_num_pages_attr  = __ATTR_RO(num_pages);
+static struct map_attribute map_attribute_attr  = __ATTR_RO(attribute);
+
+/*
+ * These are default attributes that are added for every memmap entry.
+ */
+static struct attribute *def_attrs[] = {
+	&map_type_attr.attr,
+	&map_phys_addr_attr.attr,
+	&map_virt_addr_attr.attr,
+	&map_num_pages_attr.attr,
+	&map_attribute_attr.attr,
+	NULL
+};
+
+static const struct sysfs_ops map_attr_ops = {
+	.show = map_attr_show,
+};
+
+static void map_release(struct kobject *kobj)
+{
+	struct efi_runtime_map_entry *entry;
+
+	entry = to_map_entry(kobj);
+	kfree(entry);
+}
+
+static struct kobj_type __refdata map_ktype = {
+	.sysfs_ops	= &map_attr_ops,
+	.default_attrs	= def_attrs,
+	.release	= map_release,
+};
+
+static struct kset *map_kset;
+
+static struct efi_runtime_map_entry *
+add_sysfs_runtime_map_entry(struct kobject *kobj, int nr)
+{
+	int ret;
+	struct efi_runtime_map_entry *entry;
+
+	if (!map_kset) {
+		map_kset = kset_create_and_add("runtime-map", NULL, kobj);
+		if (!map_kset)
+			return ERR_PTR(-ENOMEM);
+	}
+
+	entry = kzalloc(sizeof(*entry), GFP_KERNEL);
+	if (!entry) {
+		kset_unregister(map_kset);
+		return entry;
+	}
+
+	memcpy(&entry->md, efi_runtime_map + nr * efi_memdesc_size,
+	       sizeof(efi_memory_desc_t));
+
+	kobject_init(&entry->kobj, &map_ktype);
+	entry->kobj.kset = map_kset;
+	ret = kobject_add(&entry->kobj, NULL, "%d", nr);
+	if (ret) {
+		kobject_put(&entry->kobj);
+		kset_unregister(map_kset);
+		return ERR_PTR(ret);
+	}
+
+	return entry;
+}
+
+void efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size)
+{
+	efi_runtime_map = map;
+	nr_efi_runtime_map = nr_entries;
+	efi_memdesc_size = desc_size;
+}
+
+int __init efi_runtime_map_init(struct kobject *efi_kobj)
+{
+	int i, j, ret = 0;
+	struct efi_runtime_map_entry *entry;
+
+	if (!efi_runtime_map)
+		return 0;
+
+	map_entries = kzalloc(nr_efi_runtime_map * sizeof(entry), GFP_KERNEL);
+	if (!map_entries) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	for (i = 0; i < nr_efi_runtime_map; i++) {
+		entry = add_sysfs_runtime_map_entry(efi_kobj, i);
+		if (IS_ERR(entry)) {
+			ret = PTR_ERR(entry);
+			goto out_add_entry;
+		}
+		*(map_entries + i) = entry;
+	}
+
+	return 0;
+out_add_entry:
+	for (j = i - 1; j > 0; j--) {
+		entry = *(map_entries + j);
+		kobject_put(&entry->kobj);
+	}
+	if (map_kset)
+		kset_unregister(map_kset);
+out:
+	return ret;
+}
diff --git a/include/linux/efi.h b/include/linux/efi.h
index 11ce678..0a819e7 100644
--- a/include/linux/efi.h
+++ b/include/linux/efi.h
@@ -556,6 +556,9 @@ extern struct efi {
 	unsigned long hcdp;		/* HCDP table */
 	unsigned long uga;		/* UGA table */
 	unsigned long uv_systab;	/* UV system table */
+	unsigned long fw_vendor;	/* fw_vendor */
+	unsigned long runtime;		/* runtime table */
+	unsigned long config_table;	/* config tables */
 	efi_get_time_t *get_time;
 	efi_set_time_t *set_time;
 	efi_get_wakeup_time_t *get_wakeup_time;
@@ -653,6 +656,7 @@ extern int __init efi_setup_pcdp_console(char *);
 #define EFI_RUNTIME_SERVICES	3	/* Can we use runtime services? */
 #define EFI_MEMMAP		4	/* Can we use EFI memory map? */
 #define EFI_64BIT		5	/* Is the firmware 64-bit? */
+#define EFI_ARCH_1		6	/* First arch-specific bit */
 
 #ifdef CONFIG_EFI
 # ifdef CONFIG_X86
@@ -872,4 +876,17 @@ int efivars_sysfs_init(void);
 
 #endif /* CONFIG_EFI_VARS */
 
+#ifdef CONFIG_EFI_RUNTIME_MAP
+int efi_runtime_map_init(struct kobject *);
+void efi_runtime_map_setup(void *, int, u32);
+#else
+static inline int efi_runtime_map_init(struct kobject *kobj)
+{
+	return 0;
+}
+
+static inline void
+efi_runtime_map_setup(void *map, int nr_entries, u32 desc_size) {}
+#endif
+
 #endif /* _LINUX_EFI_H */
