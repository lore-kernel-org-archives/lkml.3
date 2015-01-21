Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752606AbbAUSqc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 13:46:32 -0500
Received: from outbound-smtp05.blacknight.com ([81.17.249.38]:35484 "EHLO
	outbound-smtp05.blacknight.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752339AbbAUSqL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 13:46:11 -0500
From: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        dvhart@infradead.org, andy.shevchenko@gmail.com,
        boon.leong.ong@intel.com, linux-kernel@vger.kernel.org
Cc: "Bryan O'Donoghue" <pure.logic@nexus-software.ie>
Subject: [PATCH v2 1/1] x86: Add Isolated Memory Regions for Quark X1000
Date: Wed, 21 Jan 2015 18:46:08 +0000
Message-Id: <1421865968-7373-2-git-send-email-pure.logic@nexus-software.ie>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>
References: <1421865968-7373-1-git-send-email-pure.logic@nexus-software.ie>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Intel's Quark X1000 SoC contains a set of registers called Isolated Memory
Regions. IMRs are accessed over the IOSF mailbox interface. IMRs are areas
carved out of memory that define read/write access rights to the various
system agents within the Quark system. For a given agent in the system it is
possible to specify if that agent may read or write an area of memory
defined by an IMR with a granularity of 1 KiB.

Quark_SecureBootPRM_330234_001.pdf section 4.5 details the concept of IMRs
quark-x1000-datasheet.pdf section 12.7.4 details the implementation of IMRs
in silicon.

eSRAM flush, CPU Snoop, CPU SMM Mode, CPU non-SMM mode, RMU and PCIe Virtual
Channels (VC0 and VC1) can have individual read/write access masks applied
to them for a given memory region in Quark X1000. This enables IMRs to treat
each memory transaction type listed above on an individual basis and to
filter appropriately based on the IMR access mask for the memory region.
Quark supports eight IMRs.

Since all of the DMA capable SoC components in the X1000 are mapped to VC0
it is possible to define sections of memory as invalid for DMA write
operations originating from Ethernet, USB, SD and any other DMA capable
south-cluster component on VC0. Similarly it is possible to mark kernel
memory as non-SMM mode read/write only or to mark BIOS runtime memory as SMM
mode accessible only depending on the particular memory footprint on a given
system.

On an IMR violation Quark SoC X1000 systems are configured to reset the
system, so ensuring that the IMR memory map is consistent with the EFI
provided memory map is critical to ensure no IMR violations reset the
system.

The API for accessing IMRs is based on MTRR code but doesn't provide a /proc
or /sys interface to manipulate IMRs. Defining the size and extent of IMRs
is exclusively the domain of in-kernel code.

Quark firmware sets up a series of locked IMRs around pieces of memory that
firmware owns such as ACPI runtime data. During boot a series of unlocked
IMRs are placed around items in memory to guarantee no DMA modification of
those items can take place. Grub also places an unlocked IMR around the
kernel boot-params data structure and compressed kernel image. It is
necessary for the kernel to tear down all unlocked IMRs in order to ensure
that the kernel's view of memory passed via the EFI memory map is consistent
with the IMR memory map. Without tearing down all unlocked IMRs on boot
transitory IMRs such as those used to protect the compressed kernel image
will cause IMR violations and system reboots.

The IMR init code tears down all unlocked IMRs and sets a protective IMR
around the kernel .text and .rodata as one contiguous block. This sanitizes
the IMR memory map with respect to the EFI memory map and protects the
read-only portions of the kernel from unwarranted DMA access.

Signed-off-by: Bryan O'Donoghue <pure.logic@nexus-software.ie>
---
 arch/x86/Kconfig           |  25 ++
 arch/x86/Kconfig.debug     |  13 +
 arch/x86/include/asm/imr.h |  60 ++++
 arch/x86/kernel/Makefile   |   1 +
 arch/x86/kernel/imr.c      | 681 +++++++++++++++++++++++++++++++++++++++++++++
 5 files changed, 780 insertions(+)
 create mode 100644 arch/x86/include/asm/imr.h
 create mode 100644 arch/x86/kernel/imr.c

diff --git a/arch/x86/Kconfig b/arch/x86/Kconfig
index ba397bd..5af669c 100644
--- a/arch/x86/Kconfig
+++ b/arch/x86/Kconfig
@@ -526,6 +526,31 @@ config IOSF_MBI_DEBUG
 
 	  If you don't require the option or are in doubt, say N.
 
+config IMR
+	bool "Isolated Memory Region support"
+	default n
+	depends on IOSF_MBI
+	---help---
+	  This option provides a means to manipulate Isolated Memory Regions.
+	  IMRs are a set of registers that define read and write access masks
+	  to prohibit certain system agents from accessing memory with 1 KiB
+	  granularity.
+
+	  IMRs make it possible to control read/write access to an address
+	  by hardware agents inside the SoC. Read and write masks can be
+	  defined for:
+		- eSRAM flush
+		- Dirty CPU snoop (write only)
+		- RMU access
+		- PCI Virtual Channel 0/Virtual Channel 1
+		- SMM mode
+		- Non SMM mode
+
+	  Quark contains a set of eight IMR registers and makes use of those
+	  registers during its bootup process.
+
+	  If you are running on a Galileo/Quark say Y here.
+
 config X86_RDC321X
 	bool "RDC R-321x SoC"
 	depends on X86_32
diff --git a/arch/x86/Kconfig.debug b/arch/x86/Kconfig.debug
index 61bd2ad..be22820 100644
--- a/arch/x86/Kconfig.debug
+++ b/arch/x86/Kconfig.debug
@@ -313,6 +313,19 @@ config DEBUG_NMI_SELFTEST
 
 	  If unsure, say N.
 
+config DEBUG_IMR_SELFTEST
+	bool "Isolated Memory Region self test"
+	default n
+	depends on IMR
+	---help---
+	  This option enables automated sanity testing of the IMR code.
+	  Some simple tests are run to verify IMR bounds checking, alignment
+	  and overlapping. This option is really only useful if you are
+	  debugging an IMR memory map or are modifying the IMR code and want to
+	  test your changes.
+
+	  If unsure say N.
+
 config X86_DEBUG_STATIC_CPU_HAS
 	bool "Debug alternatives"
 	depends on DEBUG_KERNEL
diff --git a/arch/x86/include/asm/imr.h b/arch/x86/include/asm/imr.h
new file mode 100644
index 0000000..b572a81
--- /dev/null
+++ b/arch/x86/include/asm/imr.h
@@ -0,0 +1,60 @@
+/*
+ * imr.h: Isolated Memory Region API
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ * Copyright(c) 2015 Bryan O'Donoghue <pure.logic@nexus-software.ie>
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; version 2
+ * of the License.
+ */
+#ifndef _IMR_H
+#define _IMR_H
+
+#include <linux/types.h>
+
+/*
+ * IMR agent access mask bits
+ * See section 12.7.4.7 from quark-x1000-datasheet.pdf for register
+ * definitions
+ */
+#define IMR_ESRAM_FLUSH		BIT(31)
+#define IMR_CPU_SNOOP		BIT(30)		/* Applicable only to write */
+#define IMR_RMU			BIT(29)
+#define IMR_VC1_SAI_ID3		BIT(15)
+#define IMR_VC1_SAI_ID2		BIT(14)
+#define IMR_VC1_SAI_ID1		BIT(13)
+#define IMR_VC1_SAI_ID0		BIT(12)
+#define IMR_VC0_SAI_ID3		BIT(11)
+#define IMR_VC0_SAI_ID2		BIT(10)
+#define IMR_VC0_SAI_ID1		BIT(9)
+#define IMR_VC0_SAI_ID0		BIT(8)
+#define IMR_CPU_0		BIT(1)		/* SMM mode */
+#define IMR_CPU			BIT(0)		/* Non SMM mode */
+#define IMR_ACCESS_NONE		0
+
+/*
+ * Read/Write access-all bits here include some reserved bits
+ * These are the values firmware uses and are accepted by hardware.
+ * The kernel defines read/write access-all in the same was as firmware
+ * in order to have a consistent and crisp definition across firmware,
+ * bootloader and kernel
+ */
+#define IMR_READ_ACCESS_ALL	0xBFFFFFFF
+#define IMR_WRITE_ACCESS_ALL	0xFFFFFFFF
+
+/* Number of IMRs provided by Quark X1000 SoC */
+#define QUARK_X1000_IMR_MAX	0x08
+#define QUARK_X1000_IMR_REGBASE 0x40
+
+/* IMR alignment bits - only bits 31:10 are checked for IMR validity */
+#define IMR_ALIGN		0x400
+#define IMR_MASK		(IMR_ALIGN - 1)
+
+int imr_add_range(unsigned long base, unsigned long size,
+		  unsigned int rmask, unsigned int wmask, bool lock);
+
+int imr_remove_range(int reg, unsigned long base, unsigned long size);
+
+#endif /* _IMR_H */
diff --git a/arch/x86/kernel/Makefile b/arch/x86/kernel/Makefile
index 5d4502c..0252de5 100644
--- a/arch/x86/kernel/Makefile
+++ b/arch/x86/kernel/Makefile
@@ -104,6 +104,7 @@ obj-$(CONFIG_EFI)			+= sysfb_efi.o
 obj-$(CONFIG_PERF_EVENTS)		+= perf_regs.o
 obj-$(CONFIG_TRACING)			+= tracepoint.o
 obj-$(CONFIG_IOSF_MBI)			+= iosf_mbi.o
+obj-$(CONFIG_IMR)			+= imr.o
 obj-$(CONFIG_PMC_ATOM)			+= pmc_atom.o
 
 ###
diff --git a/arch/x86/kernel/imr.c b/arch/x86/kernel/imr.c
new file mode 100644
index 0000000..5d9bfc4
--- /dev/null
+++ b/arch/x86/kernel/imr.c
@@ -0,0 +1,681 @@
+/**
+ * intel_imr.c
+ *
+ * Copyright(c) 2013 Intel Corporation.
+ * Copyright(c) 2015 Bryan O'Donoghue <pure.logic@nexus-software.ie>
+ *
+ * IMR registers define an isolated region of memory that can
+ * be masked to prohibit certain system agents from accessing memory.
+ * When a device behind a masked port performs an access - snooped or
+ * not, an IMR may optionally prevent that transaction from changing
+ * the state of memory or from getting correct data in response to the
+ * operation.
+ *
+ * Write data will be dropped and reads will return 0xFFFFFFFF, the
+ * system will reset and system BIOS will print out an error message to
+ * inform the user that an IMR has been violated.
+ *
+ * This code is based on the Linux MTRR code and reference code from
+ * Intel's Quark BSP EFI, Linux and grub code.
+ *
+ * See quark-x1000-datasheet.pdf for register definitions
+ * http://www.intel.com/content/dam/www/public/us/en/documents/datasheets/quark-x1000-datasheet.pdf
+ */
+
+#define pr_fmt(fmt) "imr: " fmt
+
+#include <asm-generic/sections.h>
+#include <asm/cpu_device_id.h>
+#include <asm/imr.h>
+#include <asm/iosf_mbi.h>
+#include <linux/debugfs.h>
+#include <linux/init.h>
+#include <linux/mm.h>
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/types.h>
+
+struct imr_device {
+	struct dentry	*file;
+	bool		init;
+	struct mutex	lock;
+	int		max_imr;
+	int		reg_base;
+};
+
+static struct imr_device imr_dev;
+
+/*
+ * IMR read/write mask control registers.
+ * See quark-x1000-datasheet.pdf sections 12.7.4.5 and 12.7.4.6 for
+ * bit definitions.
+ *
+ * addr_hi
+ * 31		Lock bit
+ * 30:24	Reserved
+ * 23:2		1 KiB aligned lo address
+ * 1:0		Reserved
+ *
+ * addr_hi
+ * 31:24	Reserved
+ * 23:2		1 KiB aligned hi address
+ * 1:0		Reserved
+ */
+#define IMR_LOCK	BIT(31)
+
+struct imr_regs {
+	u32 addr_lo;
+	u32 addr_hi;
+	u32 rmask;
+	u32 wmask;
+};
+
+#define IMR_NUM_REGS	(sizeof(struct imr_regs)/sizeof(u32))
+#define IMR_LOCK_OFF	(IMR_NUM_REGS - 1)
+#define IMR_SHIFT	8
+#define imr_to_phys(x)	((x) << IMR_SHIFT)
+#define phys_to_imr(x)	((x) >> IMR_SHIFT)
+
+/**
+ * imr_enabled - true if an IMR is enabled false otherwise
+ *
+ * Determines if an IMR is enabled based on address range and read/write
+ * mask. An IMR set with an address range set to zero and a read/write
+ * access mask set to all is considered to be disabled. An IMR in any
+ * other state - for example set to zero but without read/write access
+ * all is considered to be enabled. This definition of disabled is how
+ * firmware switches off an IMR and is maintained in kernel for
+ * consistency.
+ *
+ * @imr:	pointer to IMR descriptor
+ * @return:	true if IMR enabled false if disabled
+ */
+static int imr_enabled(struct imr_regs *imr)
+{
+	return (imr->rmask != IMR_READ_ACCESS_ALL ||
+		imr->wmask != IMR_WRITE_ACCESS_ALL ||
+		imr_to_phys(imr->addr_lo) ||
+		imr_to_phys(imr->addr_hi));
+}
+
+/**
+ * imr_read - read an IMR at a given index.
+ *
+ * Requires caller to hold imr mutex
+ *
+ * @imr_id:	IMR entry to read
+ * @imr:	IMR structure representing address and access masks
+ * @return:	0 on success or error code passed from mbi_iosf on failure
+ */
+static int imr_read(u32 imr_id, struct imr_regs *imr)
+{
+	u32 reg = imr_id * IMR_NUM_REGS + imr_dev.reg_base;
+	int ret;
+
+	ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
+				reg++, &imr->addr_lo);
+	if (ret)
+		return ret;
+
+	ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
+				reg++, &imr->addr_hi);
+	if (ret)
+		return ret;
+
+	ret = iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
+				reg++, &imr->rmask);
+	if (ret)
+		return ret;
+
+	return iosf_mbi_read(QRK_MBI_UNIT_MM, QRK_MBI_MM_READ,
+				reg, &imr->wmask);
+}
+
+/**
+ * imr_write - write an IMR at a given index.
+ *
+ * Requires caller to hold imr mutex
+ * Note lock bits need to be written independently of address bits
+ *
+ * @imr_id:	IMR entry to write
+ * @imr:	IMR structure representing address and access masks
+ * @lock:	indicates if the IMR lock bit should be applied
+ * @return:	0 on success or error code passed from mbi_iosf on failure
+ */
+static int imr_write(u32 imr_id, struct imr_regs *imr, bool lock)
+{
+	unsigned long flags;
+	u32 reg = imr_id * IMR_NUM_REGS + imr_dev.reg_base;
+	int ret;
+
+	local_irq_save(flags);
+
+	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE, reg++,
+				imr->addr_lo);
+	if (ret)
+		goto done;
+
+	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
+				reg++, imr->addr_hi);
+	if (ret)
+		goto done;
+
+	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
+				reg++, imr->rmask);
+	if (ret)
+		goto done;
+
+	ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
+				reg, imr->wmask);
+	if (ret)
+		goto done;
+
+	/* Lock bit must be set separately to addr_lo address bits */
+	if (lock) {
+		imr->addr_lo |= IMR_LOCK;
+		ret = iosf_mbi_write(QRK_MBI_UNIT_MM, QRK_MBI_MM_WRITE,
+					reg - IMR_LOCK_OFF, imr->addr_lo);
+	}
+
+	local_irq_restore(flags);
+	return 0;
+done:
+	/*
+	 * If writing to the IOSF failed then we're in an unknown state,
+	 * likely a very bad state. An IMR in an invalid state will almost
+	 * certainly lead to a memory access violation.
+	 */
+	local_irq_restore(flags);
+	WARN(ret, "IOSF-MBI write fail range 0x%08x-0x%08x unreliable\n",
+		imr_to_phys(imr->addr_lo),
+		imr_to_phys(imr->addr_hi) + IMR_MASK);
+
+	return ret;
+}
+
+#ifdef CONFIG_DEBUG_FS
+/**
+ * imr_dbgfs_state_show
+ * Print state of IMR registers
+ *
+ * @s:		pointer to seq_file for output
+ * @unused:	unused parameter
+ * @return:	0 on success or error code passed from mbi_iosf on failure
+ */
+static int imr_dbgfs_state_show(struct seq_file *s, void *unused)
+{
+	int i;
+	struct imr_regs imr;
+	int ret = -ENODEV;
+	u32 size;
+
+	mutex_lock(&imr_dev.lock);
+
+	for (i = 0; i < imr_dev.max_imr; i++) {
+
+		ret = imr_read(i, &imr);
+		if (ret)
+			break;
+
+		/*
+		 * Remember to add IMR_ALIGN bytes to size to indicate the
+		 * inherent IMR_ALIGN size bytes contained in the masked away
+		 * lower ten bits
+		 */
+		size = imr_to_phys(imr.addr_hi) - imr_to_phys(imr.addr_lo) + IMR_ALIGN;
+		seq_printf(s, "imr%02i: base=0x%08x, end=0x%08x, size=0x%08x "
+			   "rmask=0x%08x, wmask=0x%08x, %s, %s\n", i,
+			   imr_to_phys(imr.addr_lo),
+			   imr_enabled(&imr) ? imr_to_phys(imr.addr_hi) + IMR_MASK : 0,
+			   imr_enabled(&imr) ? size : 0,
+			   imr.rmask, imr.wmask,
+			   imr_enabled(&imr) ? "enabled " : "disabled",
+			   imr.addr_lo & IMR_LOCK ? "locked" : "unlocked");
+	}
+
+	mutex_unlock(&imr_dev.lock);
+
+	return ret;
+}
+
+/**
+ * imr_state_open
+ * Debugfs open callback
+ *
+ * @inode:	pointer to struct inode
+ * @file:	pointer to struct file
+ * @return:	result of single open
+ */
+static int imr_state_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, imr_dbgfs_state_show, inode->i_private);
+}
+
+static const struct file_operations imr_state_ops = {
+	.open		= imr_state_open,
+	.read		= seq_read,
+	.llseek		= seq_lseek,
+	.release	= single_release,
+};
+
+/**
+ * imr_debugfs_register
+ * Register debugfs hooks
+ *
+ * @imr:	imr structure representing address and access masks
+ * @return:	0 on success - errno on failure
+ */
+static int imr_debugfs_register(void)
+{
+	imr_dev.file = debugfs_create_file("imr_state", S_IFREG | S_IRUGO, NULL,
+					   &imr_dev, &imr_state_ops);
+	if (!imr_dev.file)
+		return -ENODEV;
+
+	return 0;
+}
+
+/**
+ * imr_debugfs_unregister
+ * Unregister debugfs hooks
+ *
+ * @imr:	IMR structure representing address and access masks
+ * @return:
+ */
+static void imr_debugfs_unregister(void)
+{
+	if (!imr_dev.file)
+		return;
+
+	debugfs_remove(imr_dev.file);
+}
+#endif /* CONFIG_DEBUG_FS */
+
+/**
+ * imr_check_range
+ * Check the passed address range for an IMR is aligned
+ *
+ * @base:	base address of intended IMR
+ * @size:	size of intended IMR
+ * @return:	zero on valid range -EINVAL on unaligned base/size
+ */
+static int imr_check_range(unsigned long base, unsigned long size)
+{
+	if ((base & IMR_MASK) || (size & IMR_MASK)) {
+		pr_warn("base 0x%08lx size 0x%08lx must align to 1KiB\n",
+			base, size);
+		return -EINVAL;
+	}
+	return 0;
+}
+
+/**
+ * imr_fixup_size - account for the IMR_ALIGN bytes that addr_hi appends
+ *
+ * IMR addr_hi has a built in offset of plus IMR_ALIGN (0x400) bytes from the
+ * value in the register. We need to subtract IMR_ALIGN bytes from input sizes
+ * as a result
+ *
+ * @size:	input size bytes
+ * @return:	reduced size
+ */
+static unsigned long imr_fixup_size(unsigned long size)
+{
+	return size - IMR_ALIGN;
+}
+
+/**
+ * imr_address_overlap - detects an address overlap
+ *
+ * @addr:	address to check against an existing IMR
+ * @imr:	imr being checked
+ * @return:	true for overlap false for no overlap
+ */
+static int imr_address_overlap(unsigned long addr, struct imr_regs *imr)
+{
+	return addr >= imr_to_phys(imr->addr_lo) && addr <= imr_to_phys(imr->addr_hi);
+}
+
+/**
+ * imr_add_range - add an Isolated Memory Region
+ *
+ * @base:	physical base address of region aligned to 1KiB
+ * @size:	physical size of region in bytes must be aligned to 1KiB
+ * @read_mask:	read access mask
+ * @write_mask:	write access mask
+ * @lock:	indicates whether or not to permanently lock this region
+ * @return:	index of the IMR allocated or negative value indicating error
+ */
+int imr_add_range(unsigned long base, unsigned long size,
+	    unsigned int rmask, unsigned int wmask, bool lock)
+{
+	unsigned long end = base + size;
+	int i;
+	struct imr_regs imr;
+	int reg;
+	int ret;
+
+	if (imr_dev.init == false)
+		return -ENODEV;
+
+	ret = imr_check_range(base, size);
+	if (ret)
+		return ret;
+
+	if (size < IMR_ALIGN)
+		return -EINVAL;
+
+	/* Tweak the size value */
+	size = imr_fixup_size(size);
+
+	mutex_lock(&imr_dev.lock);
+
+	/*
+	 * Find a free IMR while checking for an existing overlapping range.
+	 * Note there's no restriction in silicon to prevent IMR overlaps.
+	 * For the sake of simplicity and ease in defining/debugging an IMR
+	 * memory map we exclude IMR overlaps.
+	 */
+	reg = -1;
+	for (i = 0; i < imr_dev.max_imr; i++) {
+		ret = imr_read(i, &imr);
+		if (ret)
+			goto done;
+
+		/* Find overlap @ base or end of requested range */
+		if (imr_enabled(&imr)) {
+			if (imr_address_overlap(base, &imr)) {
+				ret = -EINVAL;
+				goto done;
+			}
+			if (imr_address_overlap(end, &imr)) {
+				ret = -EINVAL;
+				goto done;
+			}
+		} else {
+			reg = i;
+		}
+	}
+
+	/* Error out if we have no free IMR entries */
+	if (reg == -1) {
+		ret = -ENODEV;
+		goto done;
+	}
+
+	pr_debug("IMR %d phys 0x%08lx-0x%08lx rmask 0x%08x wmask 0x%08x\n",
+		reg, base, end, rmask, wmask);
+
+	/* Allocate IMR */
+	imr.addr_lo = phys_to_imr(base);
+	imr.addr_hi = phys_to_imr(end);
+	imr.rmask = rmask;
+	imr.wmask = wmask;
+
+	ret = imr_write(reg, &imr, lock);
+
+done:
+	mutex_unlock(&imr_dev.lock);
+	return ret == 0 ? reg : ret;
+}
+EXPORT_SYMBOL(imr_add_range);
+
+/**
+ * imr_remove_range - delete an Isolated Memory Region
+ *
+ * This function allows you to delete an IMR by it's index specified by reg or
+ * by address range specified by base and size respectively. If you specify an
+ * index on it's own the base and size parameters are ignored.
+ * imr_remove_range(0, size, base); delete IMR at index 0 base/size ignored
+ * imr_remove_range(-1, base, size); delete IMR from base to base+size
+ *
+ * @reg:	imr index to remove
+ * @base:	physical base address of region aligned to 4k
+ * @size:	physical size of region in bytes
+ * @return:	-EINVAL on invalid range or out or range id
+ *		-ENODEV if reg is valid but no IMR exists or is locked
+ *		0 on success
+ */
+int imr_remove_range(int reg, unsigned long base, unsigned long size)
+{
+	struct imr_regs imr;
+	int found = 0, i, ret = 0;
+	unsigned long  max = base + size;
+
+	if (imr_dev.init == false)
+		return -ENODEV;
+
+	if (imr_check_range(base, size))
+		return -EINVAL;
+
+	if (reg >= imr_dev.max_imr)
+		return -EINVAL;
+
+	/* Tweak the size value */
+	size = imr_fixup_size(size);
+
+	mutex_lock(&imr_dev.lock);
+
+	if (reg >= 0) {
+		/* If a specific IMR is given try to use it */
+		ret = imr_read(reg, &imr);
+		if (ret)
+			goto done;
+
+		if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK) {
+			ret = -ENODEV;
+			goto done;
+		}
+		found = 1;
+
+	} else {
+		/* Search for match based on address range */
+		for (i = 0; i < imr_dev.max_imr; i++) {
+			ret = imr_read(reg, &imr);
+			if (ret)
+				goto done;
+
+			if (!imr_enabled(&imr) || imr.addr_lo & IMR_LOCK)
+				continue;
+
+			if ((imr_to_phys(imr.addr_lo) == base) &&
+			    (imr_to_phys(imr.addr_hi) == max)) {
+				found = 1;
+				reg = i;
+				break;
+			}
+		}
+	}
+
+	if (found == 0) {
+		ret = -ENODEV;
+		goto done;
+	}
+
+	/* Tear down the IMR */
+	imr.addr_lo = 0;
+	imr.addr_hi = 0;
+	imr.rmask = IMR_READ_ACCESS_ALL;
+	imr.wmask = IMR_WRITE_ACCESS_ALL;
+
+	ret = imr_write(reg, &imr, false);
+
+done:
+	mutex_unlock(&imr_dev.lock);
+	return ret;
+}
+EXPORT_SYMBOL(imr_remove_range);
+
+#ifdef CONFIG_DEBUG_IMR_SELFTEST
+
+#define SELFTEST "imr: self_test "
+
+/**
+ * imr_self_test_result - Print result string for self test
+ *
+ * @res:	result code - true if test passed false otherwise
+ * @fmt:	format string
+ * ...		variadic argument list
+ */
+static void __init imr_self_test_result(int res, const char *fmt, ...)
+{
+	va_list vlist;
+
+	va_start(vlist, fmt);
+	if (res)
+		printk(KERN_INFO SELFTEST "pass ");
+	else
+		printk(KERN_ERR SELFTEST "fail ");
+	vprintk(fmt, vlist);
+	va_end(vlist);
+}
+
+#undef SELFTEST
+
+/**
+ * imr_self_test
+ *
+ * Verify IMR self_test with some simple tests to verify overlap,
+ * zero sized allocations and 1 KiB sized areas.
+ *
+ * @base:	physical base address of the kernel text section
+ * @size:	extent of kernel memory to be covered from &_text to &__end_rodata
+ */
+static void __init imr_self_test(unsigned long base, unsigned long size)
+{
+	const char *fmt_over = "overlapped IMR @ (0x%08lx - 0x%08lx)\n";
+	int idx;
+
+	/* Test zero zero */
+	idx = imr_add_range(0, 0, 0, 0, false);
+	imr_self_test_result(idx < 0, "zero sized IMR\n");
+
+	/* Test exact overlap */
+	idx = imr_add_range(base, size, IMR_CPU, IMR_CPU, false);
+	imr_self_test_result(idx < 0, fmt_over, __va(base), __va(base + size));
+
+	/* Test overlap with base inside of existing */
+	base += size - IMR_ALIGN;
+	idx = imr_add_range(base, size, IMR_CPU, IMR_CPU, false);
+	imr_self_test_result(idx < 0, fmt_over, __va(base), __va(base + size));
+
+	/* Test overlap with end inside of existing */
+	base -= size + IMR_ALIGN * 2;
+	idx = imr_add_range(base, size, IMR_CPU, IMR_CPU, false);
+	imr_self_test_result(idx < 0, fmt_over, __va(base), __va(base + size));
+
+	/* Test 1 KiB works */
+	idx = imr_add_range(0, IMR_ALIGN, IMR_READ_ACCESS_ALL,
+			    IMR_WRITE_ACCESS_ALL, false);
+	imr_self_test_result(idx >= 0, "1KiB IMR @ 0x00000000\n");
+
+	/* Tear-tow 1 KiB if previous was successful */
+	if (idx >= 0) {
+		idx = imr_remove_range(idx, 0, 0);
+		imr_self_test_result(idx == 0, "teardown 1KiB @ 0x00000000\n");
+	}
+}
+#endif /* CONFIG_DEBUG_IMR_SELFTEST */
+
+/**
+ * imr_fixup_memmap - Tear down IMRs used during bootup.
+ *
+ * BIOS and Grub both setup IMRs around compressed kernel, initrd memory
+ * that need to be removed before the kernel hands out one of the IMR
+ * encased addresses to a downstream DMA agent such as the SD or Ethernet.
+ * IMRs on Galileo are setup to immediately reset the system on violation.
+ * As a result if you're running a root filesystem from SD - you'll need
+ * the boot-time IMRs torn down or you'll find seemingly random resets when
+ * using your filesystem.
+ */
+static void __init imr_fixup_memmap(void)
+{
+	unsigned long base  = virt_to_phys(&_text);
+	unsigned long size = virt_to_phys(&__end_rodata) - base;
+	int i, ret;
+
+	/* Tear down all existing unlocked IMRs */
+	for (i = 0; i < imr_dev.max_imr; i++)
+		imr_remove_range(i, 0, 0);
+
+	/*
+	 * Setup a locked IMR around the physical extent of the kernel
+	 * from the beginning of the .text secton to the end of the
+	 * .rodata section.
+	 *
+	 * This behaviour relies on the kernel .text and .rodata
+	 * sections being physically contiguous and .rodata ending on 1
+	 * KiB aligned boundary - such as a page boundary. Linker script
+	 * The definition of this memory map is in:
+	 * arch/x86/kernel/vmlinux.lds
+	 * .text begin = &_stext
+	 * .rodata end = &__end_rodata - aligned to 4KiB
+	 */
+	ret = imr_add_range(base, size, IMR_CPU, IMR_CPU, true);
+	if (ret < 0)
+		pr_err("unable to setup IMR for kernel: (%p - %p)\n",
+			&_text, &__end_rodata);
+	else
+		pr_info("protecting kernel .text - .rodata: %ldk (%p - %p)\n",
+			size / 1024, &_text, &__end_rodata);
+
+#ifdef CONFIG_DEBUG_IMR_SELFTEST
+	/* Run optional self test */
+	imr_self_test(base, size);
+#endif
+}
+
+static const struct x86_cpu_id imr_ids[] __initconst = {
+	{ X86_VENDOR_INTEL, 5, 9 },	/* Intel Quark SoC X1000 */
+	{}
+};
+MODULE_DEVICE_TABLE(x86cpu, imr_ids);
+
+/**
+ * imr_probe - entry point for IMR driver
+ *
+ * return: -ENODEV for no IMR support 0 if good to go
+ */
+static int __init imr_init(void)
+{
+	int ret;
+
+	if (!x86_match_cpu(imr_ids) || !iosf_mbi_available())
+		return -ENODEV;
+
+#ifdef CONFIG_DEBUG_FS
+	ret = imr_debugfs_register();
+	if (ret != 0)
+		return ret;
+#endif
+
+	imr_dev.max_imr = QUARK_X1000_IMR_MAX;
+	imr_dev.reg_base = QUARK_X1000_IMR_REGBASE;
+
+	mutex_init(&imr_dev.lock);
+
+	imr_dev.init = true;
+	imr_fixup_memmap();
+
+	return 0;
+}
+
+/**
+ * imr_exit - exit point for IMR code
+ * Deregisters debugfs, leave IMR state as-is.
+ *
+ * return:
+ */
+static void __exit imr_exit(void)
+{
+#ifdef CONFIG_DEBUG_FS
+	imr_debugfs_unregister();
+#endif
+}
+
+module_init(imr_init);
+module_exit(imr_exit);
+
+MODULE_AUTHOR("Bryan O'Donoghue <pure.logic@nexus-software.ie>");
+MODULE_DESCRIPTION("Intel Isolated Memory Region driver");
+MODULE_LICENSE("GPL");
-- 
1.9.1

