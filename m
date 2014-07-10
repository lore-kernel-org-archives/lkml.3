Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753338AbaGJVvY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 17:51:24 -0400
Received: from mail-we0-f177.google.com ([74.125.82.177]:32932 "EHLO
	mail-we0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752861AbaGJVvS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 17:51:18 -0400
From: Oded Gabbay <oded.gabbay@gmail.com>
X-Google-Original-From: Oded Gabbay <oded.gabbay@amd.com>
To: David Airlie <airlied@linux.ie>, Alex Deucher <alexander.deucher@amd.com>,
        Jerome Glisse <j.glisse@gmail.com>
Cc: linux-kernel@vger.kernel.org, dri-devel@lists.freedesktop.org,
        John Bridgman <John.Bridgman@amd.com>,
        Andrew Lewycky <Andrew.Lewycky@amd.com>,
        Joerg Roedel <joro@8bytes.org>, Oded Gabbay <oded.gabbay@amd.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kishon Vijay Abraham I <kishon@ti.com>,
        Sandeep Nair <sandeep_n@ti.com>,
        Kenneth Heitke <kheitke@codeaurora.org>,
        Srinivas Pandruvada <srinivas.pandruvada@linux.intel.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Andreas Noever <andreas.noever@gmail.com>,
        Lucas Stach <l.stach@pengutronix.de>,
        Philipp Zabel <p.zabel@pengutronix.de>
Subject: [PATCH 09/83] hsa/radeon: Add code base of hsa driver for AMD's GPUs
Date: Fri, 11 Jul 2014 00:50:09 +0300
Message-Id: <1405029027-6085-8-git-send-email-oded.gabbay@amd.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
References: <1405029027-6085-1-git-send-email-oded.gabbay@amd.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds the code base of the hsa driver for
AMD's GPUs.

This driver is called kfd.

This initial version supports the first HSA chip, Kaveri.

This driver is located in a new directory structure under drivers/gpu.

Signed-off-by: Oded Gabbay <oded.gabbay@amd.com>
---
 drivers/Kconfig                        |    2 +
 drivers/gpu/Makefile                   |    1 +
 drivers/gpu/hsa/Kconfig                |   20 +
 drivers/gpu/hsa/Makefile               |    1 +
 drivers/gpu/hsa/radeon/Makefile        |    8 +
 drivers/gpu/hsa/radeon/kfd_chardev.c   |  133 ++++
 drivers/gpu/hsa/radeon/kfd_crat.h      |  292 ++++++++
 drivers/gpu/hsa/radeon/kfd_device.c    |  162 +++++
 drivers/gpu/hsa/radeon/kfd_module.c    |  117 ++++
 drivers/gpu/hsa/radeon/kfd_pasid.c     |   92 +++
 drivers/gpu/hsa/radeon/kfd_priv.h      |  232 ++++++
 drivers/gpu/hsa/radeon/kfd_process.c   |  400 +++++++++++
 drivers/gpu/hsa/radeon/kfd_scheduler.h |   62 ++
 drivers/gpu/hsa/radeon/kfd_topology.c  | 1201 ++++++++++++++++++++++++++++++++
 drivers/gpu/hsa/radeon/kfd_topology.h  |  168 +++++
 15 files changed, 2891 insertions(+)
 create mode 100644 drivers/gpu/hsa/Kconfig
 create mode 100644 drivers/gpu/hsa/Makefile
 create mode 100644 drivers/gpu/hsa/radeon/Makefile
 create mode 100644 drivers/gpu/hsa/radeon/kfd_chardev.c
 create mode 100644 drivers/gpu/hsa/radeon/kfd_crat.h
 create mode 100644 drivers/gpu/hsa/radeon/kfd_device.c
 create mode 100644 drivers/gpu/hsa/radeon/kfd_module.c
 create mode 100644 drivers/gpu/hsa/radeon/kfd_pasid.c
 create mode 100644 drivers/gpu/hsa/radeon/kfd_priv.h
 create mode 100644 drivers/gpu/hsa/radeon/kfd_process.c
 create mode 100644 drivers/gpu/hsa/radeon/kfd_scheduler.h
 create mode 100644 drivers/gpu/hsa/radeon/kfd_topology.c
 create mode 100644 drivers/gpu/hsa/radeon/kfd_topology.h

diff --git a/drivers/Kconfig b/drivers/Kconfig
index 9b2dcc2..c1ac8f8 100644
--- a/drivers/Kconfig
+++ b/drivers/Kconfig
@@ -178,4 +178,6 @@ source "drivers/mcb/Kconfig"
 
 source "drivers/thunderbolt/Kconfig"
 
+source "drivers/gpu/hsa/Kconfig"
+
 endmenu
diff --git a/drivers/gpu/Makefile b/drivers/gpu/Makefile
index 70da9eb..749a7ea 100644
--- a/drivers/gpu/Makefile
+++ b/drivers/gpu/Makefile
@@ -1,3 +1,4 @@
 obj-y			+= drm/ vga/
 obj-$(CONFIG_TEGRA_HOST1X)	+= host1x/
 obj-$(CONFIG_IMX_IPUV3_CORE)	+= ipu-v3/
+obj-$(CONFIG_HSA)	+= hsa/
\ No newline at end of file
diff --git a/drivers/gpu/hsa/Kconfig b/drivers/gpu/hsa/Kconfig
new file mode 100644
index 0000000..ee7bb28
--- /dev/null
+++ b/drivers/gpu/hsa/Kconfig
@@ -0,0 +1,20 @@
+#
+# Heterogenous system architecture configuration
+#
+
+menuconfig HSA
+	bool "Heterogenous System Architecture"
+	default y
+	help
+	  Say Y here if you want Heterogenous System Architecture support.
+
+if HSA
+
+config HSA_RADEON
+	tristate "HSA kernel driver for AMD Radeon devices"
+	depends on HSA && AMD_IOMMU_V2 && X86_64
+	default m
+	help
+	  Enable this if you want to support HSA on AMD Radeon devices.
+
+endif # HSA
diff --git a/drivers/gpu/hsa/Makefile b/drivers/gpu/hsa/Makefile
new file mode 100644
index 0000000..0951584
--- /dev/null
+++ b/drivers/gpu/hsa/Makefile
@@ -0,0 +1 @@
+obj-$(CONFIG_HSA_RADEON)	+= radeon/
diff --git a/drivers/gpu/hsa/radeon/Makefile b/drivers/gpu/hsa/radeon/Makefile
new file mode 100644
index 0000000..ba16a09
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/Makefile
@@ -0,0 +1,8 @@
+#
+# Makefile for Heterogenous System Architecture support for AMD Radeon devices
+#
+
+radeon_kfd-y	:= kfd_module.o kfd_device.o kfd_chardev.o \
+		kfd_pasid.o kfd_topology.o kfd_process.o
+
+obj-$(CONFIG_HSA_RADEON)	+= radeon_kfd.o
diff --git a/drivers/gpu/hsa/radeon/kfd_chardev.c b/drivers/gpu/hsa/radeon/kfd_chardev.c
new file mode 100644
index 0000000..7a56a8f
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_chardev.c
@@ -0,0 +1,133 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/device.h>
+#include <linux/export.h>
+#include <linux/err.h>
+#include <linux/fs.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/uaccess.h>
+#include "kfd_priv.h"
+#include "kfd_scheduler.h"
+
+static long kfd_ioctl(struct file *, unsigned int, unsigned long);
+static int kfd_open(struct inode *, struct file *);
+
+static const char kfd_dev_name[] = "kfd";
+
+static const struct file_operations kfd_fops = {
+	.owner = THIS_MODULE,
+	.unlocked_ioctl = kfd_ioctl,
+	.open = kfd_open,
+};
+
+static int kfd_char_dev_major = -1;
+static struct class *kfd_class;
+struct device *kfd_device;
+
+int
+radeon_kfd_chardev_init(void)
+{
+	int err = 0;
+
+	kfd_char_dev_major = register_chrdev(0, kfd_dev_name, &kfd_fops);
+	err = kfd_char_dev_major;
+	if (err < 0)
+		goto err_register_chrdev;
+
+	kfd_class = class_create(THIS_MODULE, kfd_dev_name);
+	err = PTR_ERR(kfd_class);
+	if (IS_ERR(kfd_class))
+		goto err_class_create;
+
+	kfd_device = device_create(kfd_class, NULL, MKDEV(kfd_char_dev_major, 0), NULL, kfd_dev_name);
+	err = PTR_ERR(kfd_device);
+	if (IS_ERR(kfd_device))
+		goto err_device_create;
+
+	return 0;
+
+err_device_create:
+	class_destroy(kfd_class);
+err_class_create:
+	unregister_chrdev(kfd_char_dev_major, kfd_dev_name);
+err_register_chrdev:
+	return err;
+}
+
+void
+radeon_kfd_chardev_exit(void)
+{
+	device_destroy(kfd_class, MKDEV(kfd_char_dev_major, 0));
+	class_destroy(kfd_class);
+	unregister_chrdev(kfd_char_dev_major, kfd_dev_name);
+}
+
+struct device*
+radeon_kfd_chardev(void)
+{
+	return kfd_device;
+}
+
+
+static int
+kfd_open(struct inode *inode, struct file *filep)
+{
+	struct kfd_process *process;
+
+	if (iminor(inode) != 0)
+		return -ENODEV;
+
+	process = radeon_kfd_create_process(current);
+	if (IS_ERR(process))
+		return PTR_ERR(process);
+
+	pr_debug("\nkfd: process %d opened dev/kfd", process->pasid);
+
+	return 0;
+}
+
+
+static long
+kfd_ioctl(struct file *filep, unsigned int cmd, unsigned long arg)
+{
+	long err = -EINVAL;
+
+	dev_info(kfd_device,
+		 "ioctl cmd 0x%x (#%d), arg 0x%lx\n",
+		 cmd, _IOC_NR(cmd), arg);
+
+	switch (cmd) {
+	default:
+		dev_err(kfd_device,
+			"unknown ioctl cmd 0x%x, arg 0x%lx)\n",
+			cmd, arg);
+		err = -EINVAL;
+		break;
+	}
+
+	if (err < 0)
+		dev_err(kfd_device, "ioctl error %ld\n", err);
+
+	return err;
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_crat.h b/drivers/gpu/hsa/radeon/kfd_crat.h
new file mode 100644
index 0000000..587455d
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_crat.h
@@ -0,0 +1,292 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef KFD_CRAT_H_INCLUDED
+#define KFD_CRAT_H_INCLUDED
+
+#include <linux/types.h>
+
+#pragma pack(1)
+
+/*
+ * 4CC signature values for the CRAT and CDIT ACPI tables
+ */
+
+#define CRAT_SIGNATURE	"CRAT"
+#define CDIT_SIGNATURE	"CDIT"
+
+/*
+ * Component Resource Association Table (CRAT)
+ */
+
+#define CRAT_OEMID_LENGTH	6
+#define CRAT_OEMTABLEID_LENGTH	8
+#define CRAT_RESERVED_LENGTH	6
+
+struct crat_header {
+	uint32_t	signature;
+	uint32_t	length;
+	uint8_t		revision;
+	uint8_t		checksum;
+	uint8_t		oem_id[CRAT_OEMID_LENGTH];
+	uint8_t		oem_table_id[CRAT_OEMTABLEID_LENGTH];
+	uint32_t	oem_revision;
+	uint32_t	creator_id;
+	uint32_t	creator_revision;
+	uint32_t	total_entries;
+	uint16_t	num_domains;
+	uint8_t		reserved[CRAT_RESERVED_LENGTH];
+};
+
+/*
+ * The header structure is immediately followed by total_entries of the
+ * data definitions
+ */
+
+/*
+ * The currently defined subtype entries in the CRAT
+ */
+#define CRAT_SUBTYPE_COMPUTEUNIT_AFFINITY	0
+#define CRAT_SUBTYPE_MEMORY_AFFINITY		1
+#define CRAT_SUBTYPE_CACHE_AFFINITY		2
+#define CRAT_SUBTYPE_TLB_AFFINITY		3
+#define CRAT_SUBTYPE_CCOMPUTE_AFFINITY		4
+#define CRAT_SUBTYPE_IOLINK_AFFINITY		5
+#define CRAT_SUBTYPE_MAX			6
+
+#define CRAT_SIBLINGMAP_SIZE	32
+
+/*
+ * ComputeUnit Affinity structure and definitions
+ */
+#define CRAT_CU_FLAGS_ENABLED		0x00000001
+#define CRAT_CU_FLAGS_HOT_PLUGGABLE	0x00000002
+#define CRAT_CU_FLAGS_CPU_PRESENT	0x00000004
+#define CRAT_CU_FLAGS_GPU_PRESENT	0x00000008
+#define CRAT_CU_FLAGS_IOMMU_PRESENT	0x00000010
+#define CRAT_CU_FLAGS_RESERVED		0xffffffe0
+
+#define CRAT_COMPUTEUNIT_RESERVED_LENGTH 4
+
+struct crat_subtype_computeunit {
+	uint8_t		type;
+	uint8_t		length;
+	uint16_t	reserved;
+	uint32_t	flags;
+	uint32_t	proximity_domain;
+	uint32_t	processor_id_low;
+	uint16_t	num_cpu_cores;
+	uint16_t	num_simd_cores;
+	uint16_t	max_waves_simd;
+	uint16_t	io_count;
+	uint16_t	hsa_capability;
+	uint16_t	lds_size_in_kb;
+	uint8_t		wave_front_size;
+	uint8_t		num_banks;
+	uint16_t	micro_engine_id;
+	uint8_t		num_arrays;
+	uint8_t		num_cu_per_array;
+	uint8_t		num_simd_per_cu;
+	uint8_t		max_slots_scatch_cu;
+	uint8_t		reserved2[CRAT_COMPUTEUNIT_RESERVED_LENGTH];
+};
+
+/*
+ * HSA Memory Affinity structure and definitions
+ */
+#define CRAT_MEM_FLAGS_ENABLED		0x00000001
+#define CRAT_MEM_FLAGS_HOT_PLUGGABLE	0x00000002
+#define CRAT_MEM_FLAGS_NON_VOLATILE	0x00000004
+#define CRAT_MEM_FLAGS_RESERVED		0xfffffff8
+
+#define CRAT_MEMORY_RESERVED_LENGTH 8
+
+struct crat_subtype_memory {
+	uint8_t		type;
+	uint8_t		length;
+	uint16_t	reserved;
+	uint32_t	flags;
+	uint32_t	promixity_domain;
+	uint32_t	base_addr_low;
+	uint32_t	base_addr_high;
+	uint32_t	length_low;
+	uint32_t	length_high;
+	uint32_t	width;
+	uint8_t		reserved2[CRAT_MEMORY_RESERVED_LENGTH];
+};
+
+/*
+ * HSA Cache Affinity structure and definitions
+ */
+#define CRAT_CACHE_FLAGS_ENABLED	0x00000001
+#define CRAT_CACHE_FLAGS_DATA_CACHE	0x00000002
+#define CRAT_CACHE_FLAGS_INST_CACHE	0x00000004
+#define CRAT_CACHE_FLAGS_CPU_CACHE	0x00000008
+#define CRAT_CACHE_FLAGS_SIMD_CACHE	0x00000010
+#define CRAT_CACHE_FLAGS_RESERVED	0xffffffe0
+
+#define CRAT_CACHE_RESERVED_LENGTH 8
+
+struct crat_subtype_cache {
+	uint8_t		type;
+	uint8_t		length;
+	uint16_t	reserved;
+	uint32_t	flags;
+	uint32_t	processor_id_low;
+	uint8_t		sibling_map[CRAT_SIBLINGMAP_SIZE];
+	uint32_t	cache_size;
+	uint8_t		cache_level;
+	uint8_t		lines_per_tag;
+	uint16_t	cache_line_size;
+	uint8_t		associativity;
+	uint8_t		cache_properties;
+	uint16_t	cache_latency;
+	uint8_t		reserved2[CRAT_CACHE_RESERVED_LENGTH];
+};
+
+/*
+ * HSA TLB Affinity structure and definitions
+ */
+#define CRAT_TLB_FLAGS_ENABLED	0x00000001
+#define CRAT_TLB_FLAGS_DATA_TLB	0x00000002
+#define CRAT_TLB_FLAGS_INST_TLB	0x00000004
+#define CRAT_TLB_FLAGS_CPU_TLB	0x00000008
+#define CRAT_TLB_FLAGS_SIMD_TLB	0x00000010
+#define CRAT_TLB_FLAGS_RESERVED	0xffffffe0
+
+#define CRAT_TLB_RESERVED_LENGTH 4
+
+struct crat_subtype_tlb {
+	uint8_t		type;
+	uint8_t		length;
+	uint16_t	reserved;
+	uint32_t	flags;
+	uint32_t	processor_id_low;
+	uint8_t		sibling_map[CRAT_SIBLINGMAP_SIZE];
+	uint32_t	tlb_level;
+	uint8_t		data_tlb_associativity_2mb;
+	uint8_t		data_tlb_size_2mb;
+	uint8_t		instruction_tlb_associativity_2mb;
+	uint8_t		instruction_tlb_size_2mb;
+	uint8_t		data_tlb_associativity_4k;
+	uint8_t		data_tlb_size_4k;
+	uint8_t		instruction_tlb_associativity_4k;
+	uint8_t		instruction_tlb_size_4k;
+	uint8_t		data_tlb_associativity_1gb;
+	uint8_t		data_tlb_size_1gb;
+	uint8_t		instruction_tlb_associativity_1gb;
+	uint8_t		instruction_tlb_size_1gb;
+	uint8_t		reserved2[CRAT_TLB_RESERVED_LENGTH];
+};
+
+/*
+ * HSA CCompute/APU Affinity structure and definitions
+ */
+#define CRAT_CCOMPUTE_FLAGS_ENABLED	0x00000001
+#define CRAT_CCOMPUTE_FLAGS_RESERVED	0xfffffffe
+
+#define CRAT_CCOMPUTE_RESERVED_LENGTH 16
+
+struct crat_subtype_ccompute {
+	uint8_t		type;
+	uint8_t		length;
+	uint16_t	reserved;
+	uint32_t	flags;
+	uint32_t	processor_id_low;
+	uint8_t		sibling_map[CRAT_SIBLINGMAP_SIZE];
+	uint32_t	apu_size;
+	uint8_t		reserved2[CRAT_CCOMPUTE_RESERVED_LENGTH];
+};
+
+/*
+ * HSA IO Link Affinity structure and definitions
+ */
+#define CRAT_IOLINK_FLAGS_ENABLED	0x00000001
+#define CRAT_IOLINK_FLAGS_COHERENCY	0x00000002
+#define CRAT_IOLINK_FLAGS_RESERVED	0xfffffffc
+
+/*
+ * IO interface types
+ */
+#define CRAT_IOLINK_TYPE_UNDEFINED	0
+#define CRAT_IOLINK_TYPE_HYPERTRANSPORT	1
+#define CRAT_IOLINK_TYPE_PCIEXPRESS	2
+#define CRAT_IOLINK_TYPE_OTHER		3
+#define CRAT_IOLINK_TYPE_MAX		255
+
+#define CRAT_IOLINK_RESERVED_LENGTH 24
+
+struct crat_subtype_iolink {
+	uint8_t		type;
+	uint8_t		length;
+	uint16_t	reserved;
+	uint32_t	flags;
+	uint32_t	proximity_domain_from;
+	uint32_t	proximity_domain_to;
+	uint8_t		io_interface_type;
+	uint8_t		version_major;
+	uint16_t	version_minor;
+	uint32_t	minimum_latency;
+	uint32_t	maximum_latency;
+	uint32_t	minimum_bandwidth_mbs;
+	uint32_t	maximum_bandwidth_mbs;
+	uint32_t	recommended_transfer_size;
+	uint8_t		reserved2[CRAT_IOLINK_RESERVED_LENGTH];
+};
+
+/*
+ * HSA generic sub-type header
+ */
+
+#define CRAT_SUBTYPE_FLAGS_ENABLED 0x00000001
+
+struct crat_subtype_generic {
+	uint8_t		type;
+	uint8_t		length;
+	uint16_t	reserved;
+	uint32_t	flags;
+};
+
+/*
+ * Component Locality Distance Information Table (CDIT)
+ */
+#define CDIT_OEMID_LENGTH	6
+#define CDIT_OEMTABLEID_LENGTH	8
+
+struct cdit_header {
+	uint32_t	signature;
+	uint32_t	length;
+	uint8_t		revision;
+	uint8_t		checksum;
+	uint8_t		oem_id[CDIT_OEMID_LENGTH];
+	uint8_t		oem_table_id[CDIT_OEMTABLEID_LENGTH];
+	uint32_t	oem_revision;
+	uint32_t	creator_id;
+	uint32_t	creator_revision;
+	uint32_t	total_entries;
+	uint16_t	num_domains;
+	uint8_t		entry[1];
+};
+
+#pragma pack()
+
+#endif /* KFD_CRAT_H_INCLUDED */
diff --git a/drivers/gpu/hsa/radeon/kfd_device.c b/drivers/gpu/hsa/radeon/kfd_device.c
new file mode 100644
index 0000000..d122920
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_device.c
@@ -0,0 +1,162 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/amd-iommu.h>
+#include <linux/bsearch.h>
+#include <linux/pci.h>
+#include <linux/slab.h>
+#include "kfd_priv.h"
+#include "kfd_scheduler.h"
+
+static const struct kfd_device_info bonaire_device_info = {
+	.max_pasid_bits = 16,
+};
+
+struct kfd_deviceid {
+	unsigned short did;
+	const struct kfd_device_info *device_info;
+};
+
+/* Please keep this sorted by increasing device id. */
+static const struct kfd_deviceid supported_devices[] = {
+	{ 0x1305, &bonaire_device_info },	/* Kaveri */
+	{ 0x1307, &bonaire_device_info },	/* Kaveri */
+	{ 0x130F, &bonaire_device_info },	/* Kaveri */
+	{ 0x665C, &bonaire_device_info },	/* Bonaire */
+};
+
+static const struct kfd_device_info *
+lookup_device_info(unsigned short did)
+{
+	size_t i;
+
+	for (i = 0; i < ARRAY_SIZE(supported_devices); i++) {
+		if (supported_devices[i].did == did) {
+			BUG_ON(supported_devices[i].device_info == NULL);
+			return supported_devices[i].device_info;
+		}
+	}
+
+	return NULL;
+}
+
+struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev)
+{
+	struct kfd_dev *kfd;
+
+	const struct kfd_device_info *device_info = lookup_device_info(pdev->device);
+
+	if (!device_info)
+		return NULL;
+
+	kfd = kzalloc(sizeof(*kfd), GFP_KERNEL);
+	kfd->kgd = kgd;
+	kfd->device_info = device_info;
+	kfd->pdev = pdev;
+
+	return kfd;
+}
+
+static bool
+device_iommu_pasid_init(struct kfd_dev *kfd)
+{
+	const u32 required_iommu_flags = AMD_IOMMU_DEVICE_FLAG_ATS_SUP | AMD_IOMMU_DEVICE_FLAG_PRI_SUP
+					| AMD_IOMMU_DEVICE_FLAG_PASID_SUP;
+
+	struct amd_iommu_device_info iommu_info;
+	pasid_t pasid_limit;
+	int err;
+
+	err = amd_iommu_device_info(kfd->pdev, &iommu_info);
+	if (err < 0)
+		return false;
+
+	if ((iommu_info.flags & required_iommu_flags) != required_iommu_flags)
+		return false;
+
+	pasid_limit = min_t(pasid_t, (pasid_t)1 << kfd->device_info->max_pasid_bits, iommu_info.max_pasids);
+	pasid_limit = min_t(pasid_t, pasid_limit, kfd->doorbell_process_limit);
+
+	err = amd_iommu_init_device(kfd->pdev, pasid_limit);
+	if (err < 0)
+		return false;
+
+	if (!radeon_kfd_set_pasid_limit(pasid_limit)) {
+		amd_iommu_free_device(kfd->pdev);
+		return false;
+	}
+
+	return true;
+}
+
+static void iommu_pasid_shutdown_callback(struct pci_dev *pdev, int pasid)
+{
+	struct kfd_dev *dev = radeon_kfd_device_by_pci_dev(pdev);
+
+	if (dev)
+		radeon_kfd_unbind_process_from_device(dev, pasid);
+}
+
+bool kgd2kfd_device_init(struct kfd_dev *kfd,
+			 const struct kgd2kfd_shared_resources *gpu_resources)
+{
+	kfd->shared_resources = *gpu_resources;
+
+	kfd->regs = gpu_resources->mmio_registers;
+
+	if (!device_iommu_pasid_init(kfd))
+		return false;
+
+	if (kfd_topology_add_device(kfd) != 0) {
+		amd_iommu_free_device(kfd->pdev);
+		return false;
+	}
+
+	amd_iommu_set_invalidate_ctx_cb(kfd->pdev, iommu_pasid_shutdown_callback);
+
+	if (kfd->device_info->scheduler_class->create(kfd, &kfd->scheduler)) {
+		amd_iommu_free_device(kfd->pdev);
+		return false;
+	}
+
+	kfd->device_info->scheduler_class->start(kfd->scheduler);
+
+	kfd->init_complete = true;
+
+	return true;
+}
+
+void kgd2kfd_device_exit(struct kfd_dev *kfd)
+{
+	int err = kfd_topology_remove_device(kfd);
+
+	BUG_ON(err != 0);
+
+	if (kfd->init_complete) {
+		kfd->device_info->scheduler_class->stop(kfd->scheduler);
+		kfd->device_info->scheduler_class->destroy(kfd->scheduler);
+
+		amd_iommu_free_device(kfd->pdev);
+	}
+
+	kfree(kfd);
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_module.c b/drivers/gpu/hsa/radeon/kfd_module.c
new file mode 100644
index 0000000..6978bc0
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_module.c
@@ -0,0 +1,117 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/module.h>
+#include <linux/sched.h>
+#include <linux/notifier.h>
+
+#include "kfd_priv.h"
+
+#define DRIVER_AUTHOR		"Andrew Lewycky, Oded Gabbay, Evgeny Pinchuk, others."
+
+#define DRIVER_NAME		"kfd"
+#define DRIVER_DESC		"AMD HSA Kernel Fusion Driver"
+#define DRIVER_DATE		"20140127"
+
+const struct kfd2kgd_calls *kfd2kgd;
+static const struct kgd2kfd_calls kgd2kfd = {
+	.exit		= kgd2kfd_exit,
+	.probe		= kgd2kfd_probe,
+	.device_init	= kgd2kfd_device_init,
+	.device_exit	= kgd2kfd_device_exit,
+};
+
+bool kgd2kfd_init(unsigned interface_version,
+		  const struct kfd2kgd_calls *f2g,
+		  const struct kgd2kfd_calls **g2f)
+{
+	/* Only one interface version is supported, no kfd/kgd version skew allowed. */
+	if (interface_version != KFD_INTERFACE_VERSION)
+		return false;
+
+	kfd2kgd = f2g;
+	*g2f = &kgd2kfd;
+
+	return true;
+}
+EXPORT_SYMBOL(kgd2kfd_init);
+
+void kgd2kfd_exit(void)
+{
+}
+
+extern int kfd_process_exit(struct notifier_block *nb,
+				unsigned long action, void *data);
+
+static struct notifier_block kfd_mmput_nb = {
+	.notifier_call		= kfd_process_exit,
+	.priority		= 3,
+};
+
+static int __init kfd_module_init(void)
+{
+	int err;
+
+	err = radeon_kfd_pasid_init();
+	if (err < 0)
+		goto err_pasid;
+
+	err = radeon_kfd_chardev_init();
+	if (err < 0)
+		goto err_ioctl;
+
+	err = mmput_register_notifier(&kfd_mmput_nb);
+	if (err)
+		goto err_mmu_notifier;
+
+	err = kfd_topology_init();
+	if (err < 0)
+		goto err_topology;
+
+	pr_info("[hsa] Initialized kfd module");
+
+	return 0;
+err_topology:
+	mmput_unregister_notifier(&kfd_mmput_nb);
+err_mmu_notifier:
+	radeon_kfd_chardev_exit();
+err_ioctl:
+	radeon_kfd_pasid_exit();
+err_pasid:
+	return err;
+}
+
+static void __exit kfd_module_exit(void)
+{
+	kfd_topology_shutdown();
+	mmput_unregister_notifier(&kfd_mmput_nb);
+	radeon_kfd_chardev_exit();
+	radeon_kfd_pasid_exit();
+	pr_info("[hsa] Removed kfd module");
+}
+
+module_init(kfd_module_init);
+module_exit(kfd_module_exit);
+
+MODULE_AUTHOR(DRIVER_AUTHOR);
+MODULE_DESCRIPTION(DRIVER_DESC);
+MODULE_LICENSE("GPL");
diff --git a/drivers/gpu/hsa/radeon/kfd_pasid.c b/drivers/gpu/hsa/radeon/kfd_pasid.c
new file mode 100644
index 0000000..d78bd00
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_pasid.c
@@ -0,0 +1,92 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/slab.h>
+#include <linux/types.h>
+#include "kfd_priv.h"
+
+#define INITIAL_PASID_LIMIT (1<<20)
+
+static unsigned long *pasid_bitmap;
+static pasid_t pasid_limit;
+static DEFINE_MUTEX(pasid_mutex);
+
+int radeon_kfd_pasid_init(void)
+{
+	pasid_limit = INITIAL_PASID_LIMIT;
+
+	pasid_bitmap = kzalloc(DIV_ROUND_UP(INITIAL_PASID_LIMIT, BITS_PER_BYTE), GFP_KERNEL);
+	if (!pasid_bitmap)
+		return -ENOMEM;
+
+	set_bit(0, pasid_bitmap); /* PASID 0 is reserved. */
+
+	return 0;
+}
+
+void radeon_kfd_pasid_exit(void)
+{
+	kfree(pasid_bitmap);
+}
+
+bool radeon_kfd_set_pasid_limit(pasid_t new_limit)
+{
+	if (new_limit < pasid_limit) {
+		bool ok;
+
+		mutex_lock(&pasid_mutex);
+
+		/* ensure that no pasids >= new_limit are in-use */
+		ok = (find_next_bit(pasid_bitmap, pasid_limit, new_limit) == pasid_limit);
+		if (ok)
+			pasid_limit = new_limit;
+
+		mutex_unlock(&pasid_mutex);
+
+		return ok;
+	}
+
+	return true;
+}
+
+pasid_t radeon_kfd_pasid_alloc(void)
+{
+	pasid_t found;
+
+	mutex_lock(&pasid_mutex);
+
+	found = find_first_zero_bit(pasid_bitmap, pasid_limit);
+	if (found == pasid_limit)
+		found = 0;
+	else
+		set_bit(found, pasid_bitmap);
+
+	mutex_unlock(&pasid_mutex);
+
+	return found;
+}
+
+void radeon_kfd_pasid_free(pasid_t pasid)
+{
+	BUG_ON(pasid == 0 || pasid >= pasid_limit);
+	clear_bit(pasid, pasid_bitmap);
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_priv.h b/drivers/gpu/hsa/radeon/kfd_priv.h
new file mode 100644
index 0000000..1d1dbcf
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_priv.h
@@ -0,0 +1,232 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef KFD_PRIV_H_INCLUDED
+#define KFD_PRIV_H_INCLUDED
+
+#include <linux/hashtable.h>
+#include <linux/mmu_notifier.h>
+#include <linux/mutex.h>
+#include <linux/radeon_kfd.h>
+#include <linux/types.h>
+
+struct kfd_scheduler_class;
+
+#define MAX_KFD_DEVICES 16	/* Global limit - only MAX_KFD_DEVICES will be supported by KFD. */
+
+/*
+ * Per-process limit. Each process can only
+ * create MAX_PROCESS_QUEUES across all devices
+ */
+#define MAX_PROCESS_QUEUES 1024
+
+#define MAX_DOORBELL_INDEX MAX_PROCESS_QUEUES
+#define KFD_SYSFS_FILE_MODE 0444
+
+/* We multiplex different sorts of mmap-able memory onto /dev/kfd.
+** We figure out what type of memory the caller wanted by comparing the mmap page offset to known ranges. */
+#define KFD_MMAP_DOORBELL_START	(((1ULL << 32)*1) >> PAGE_SHIFT)
+#define KFD_MMAP_DOORBELL_END	(((1ULL << 32)*2) >> PAGE_SHIFT)
+
+/* GPU ID hash width in bits */
+#define KFD_GPU_ID_HASH_WIDTH 16
+
+/* Macro for allocating structures */
+#define kfd_alloc_struct(ptr_to_struct)	((typeof(ptr_to_struct)) kzalloc(sizeof(*ptr_to_struct), GFP_KERNEL))
+
+/* Large enough to hold the maximum usable pasid + 1.
+** It must also be able to store the number of doorbells reported by a KFD device. */
+typedef unsigned int pasid_t;
+
+/* Type that represents a HW doorbell slot. */
+typedef u32 doorbell_t;
+
+struct kfd_device_info {
+	const struct kfd_scheduler_class *scheduler_class;
+	unsigned int max_pasid_bits;
+};
+
+struct kfd_dev {
+	struct kgd_dev *kgd;
+
+	const struct kfd_device_info *device_info;
+	struct pci_dev *pdev;
+
+	void __iomem *regs;
+
+	bool init_complete;
+
+	unsigned int id;		/* topology stub index */
+
+	phys_addr_t doorbell_base;	/* Start of actual doorbells used by
+					 * KFD. It is aligned for mapping
+					 * into user mode
+					 */
+	size_t doorbell_id_offset;	/* Doorbell offset (from KFD doorbell
+					 * to HW doorbell, GFX reserved some
+					 * at the start)
+					 */
+	size_t doorbell_process_limit;	/* Number of processes we have doorbell space for. */
+
+	struct kgd2kfd_shared_resources shared_resources;
+
+	struct kfd_scheduler *scheduler;
+};
+
+/* KGD2KFD callbacks */
+void kgd2kfd_exit(void);
+struct kfd_dev *kgd2kfd_probe(struct kgd_dev *kgd, struct pci_dev *pdev);
+bool kgd2kfd_device_init(struct kfd_dev *kfd,
+			 const struct kgd2kfd_shared_resources *gpu_resources);
+void kgd2kfd_device_exit(struct kfd_dev *kfd);
+
+extern const struct kfd2kgd_calls *kfd2kgd;
+
+
+/* KFD2KGD callback wrappers */
+void radeon_kfd_lock_srbm_index(struct kfd_dev *kfd);
+void radeon_kfd_unlock_srbm_index(struct kfd_dev *kfd);
+
+enum kfd_mempool {
+	KFD_MEMPOOL_SYSTEM_CACHEABLE = 1,
+	KFD_MEMPOOL_SYSTEM_WRITECOMBINE = 2,
+	KFD_MEMPOOL_FRAMEBUFFER = 3,
+};
+
+struct kfd_mem_obj_s; /* Dummy struct just to make kfd_mem_obj* a unique pointer type. */
+typedef struct kfd_mem_obj_s *kfd_mem_obj;
+
+int radeon_kfd_vidmem_alloc(struct kfd_dev *kfd, size_t size, size_t alignment,
+				enum kfd_mempool pool, kfd_mem_obj *mem_obj);
+void radeon_kfd_vidmem_free(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
+int radeon_kfd_vidmem_gpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, uint64_t *vmid0_address);
+void radeon_kfd_vidmem_ungpumap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
+int radeon_kfd_vidmem_kmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj, void **ptr);
+void radeon_kfd_vidmem_unkmap(struct kfd_dev *kfd, kfd_mem_obj mem_obj);
+
+/* Character device interface */
+int radeon_kfd_chardev_init(void);
+void radeon_kfd_chardev_exit(void);
+struct device *radeon_kfd_chardev(void);
+
+/* Scheduler */
+struct kfd_scheduler;
+struct kfd_scheduler_process;
+struct kfd_scheduler_queue {
+	uint64_t dummy;
+};
+
+struct kfd_queue {
+	struct kfd_dev *dev;
+
+	/* scheduler_queue must be last. It is variable sized (dev->device_info->scheduler_class->queue_size) */
+	struct kfd_scheduler_queue scheduler_queue;
+};
+
+/* Data that is per-process-per device. */
+struct kfd_process_device {
+	/* List of all per-device data for a process. Starts from kfd_process.per_device_data. */
+	struct list_head per_device_list;
+
+	/* The device that owns this data. */
+	struct kfd_dev *dev;
+
+	/* The user-mode address of the doorbell mapping for this device. */
+	doorbell_t __user *doorbell_mapping;
+
+	/* The number of queues created by this process for this device. */
+	uint32_t queue_count;
+
+	/* Scheduler process data for this device. */
+	struct kfd_scheduler_process *scheduler_process;
+
+	/* Is this process/pasid bound to this device? (amd_iommu_bind_pasid) */
+	bool bound;
+};
+
+/* Process data */
+struct kfd_process {
+	struct list_head processes_list;
+
+	struct mm_struct *mm;
+
+	struct mutex mutex;
+
+	/* In any process, the thread that started main() is the lead thread and outlives the rest.
+	 * It is here because amd_iommu_bind_pasid wants a task_struct. */
+	struct task_struct *lead_thread;
+
+	pasid_t pasid;
+
+	/* List of kfd_process_device structures, one for each device the process is using. */
+	struct list_head per_device_data;
+
+	/* The process's queues. */
+	size_t queue_array_size;
+	struct kfd_queue **queues;	/* Size is queue_array_size, up to MAX_PROCESS_QUEUES. */
+	unsigned long allocated_queue_bitmap[DIV_ROUND_UP(MAX_PROCESS_QUEUES, BITS_PER_LONG)];
+};
+
+struct kfd_process *radeon_kfd_create_process(const struct task_struct *);
+struct kfd_process *radeon_kfd_get_process(const struct task_struct *);
+
+struct kfd_process_device *radeon_kfd_bind_process_to_device(struct kfd_dev *dev, struct kfd_process *p);
+void radeon_kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid);
+struct kfd_process_device *radeon_kfd_get_process_device_data(struct kfd_dev *dev, struct kfd_process *p);
+
+bool radeon_kfd_allocate_queue_id(struct kfd_process *p, unsigned int *queue_id);
+void radeon_kfd_install_queue(struct kfd_process *p, unsigned int queue_id, struct kfd_queue *queue);
+void radeon_kfd_remove_queue(struct kfd_process *p, unsigned int queue_id);
+struct kfd_queue *radeon_kfd_get_queue(struct kfd_process *p, unsigned int queue_id);
+
+
+/* PASIDs */
+int radeon_kfd_pasid_init(void);
+void radeon_kfd_pasid_exit(void);
+bool radeon_kfd_set_pasid_limit(pasid_t new_limit);
+pasid_t radeon_kfd_pasid_alloc(void);
+void radeon_kfd_pasid_free(pasid_t pasid);
+
+/* Doorbells */
+void radeon_kfd_doorbell_init(struct kfd_dev *kfd);
+int radeon_kfd_doorbell_mmap(struct kfd_process *process, struct vm_area_struct *vma);
+doorbell_t __user *radeon_kfd_get_doorbell(struct file *devkfd, struct kfd_process *process, struct kfd_dev *dev,
+					   unsigned int doorbell_index);
+unsigned int radeon_kfd_queue_id_to_doorbell(struct kfd_dev *kfd, struct kfd_process *process, unsigned int queue_id);
+
+extern struct device *kfd_device;
+
+/* Topology */
+int kfd_topology_init(void);
+void kfd_topology_shutdown(void);
+int kfd_topology_add_device(struct kfd_dev *gpu);
+int kfd_topology_remove_device(struct kfd_dev *gpu);
+struct kfd_dev *radeon_kfd_device_by_id(uint32_t gpu_id);
+struct kfd_dev *radeon_kfd_device_by_pci_dev(const struct pci_dev *pdev);
+
+/* MMIO registers */
+#define WRITE_REG(dev, reg, value) radeon_kfd_write_reg((dev), (reg), (value))
+#define READ_REG(dev, reg) radeon_kfd_read_reg((dev), (reg))
+void radeon_kfd_write_reg(struct kfd_dev *dev, uint32_t reg, uint32_t value);
+uint32_t radeon_kfd_read_reg(struct kfd_dev *dev, uint32_t reg);
+
+#endif
diff --git a/drivers/gpu/hsa/radeon/kfd_process.c b/drivers/gpu/hsa/radeon/kfd_process.c
new file mode 100644
index 0000000..145ee38
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_process.c
@@ -0,0 +1,400 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/mutex.h>
+#include <linux/log2.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/amd-iommu.h>
+#include <linux/notifier.h>
+struct mm_struct;
+
+#include "kfd_priv.h"
+#include "kfd_scheduler.h"
+
+/* Initial size for the array of queues.
+ * The allocated size is doubled each time it is exceeded up to MAX_PROCESS_QUEUES. */
+#define INITIAL_QUEUE_ARRAY_SIZE 16
+
+/* List of struct kfd_process */
+static struct list_head kfd_processes_list = LIST_HEAD_INIT(kfd_processes_list);
+
+static DEFINE_MUTEX(kfd_processes_mutex);
+
+static struct kfd_process *create_process(const struct task_struct *thread);
+
+struct kfd_process*
+radeon_kfd_create_process(const struct task_struct *thread)
+{
+	struct kfd_process *process;
+
+	if (thread->mm == NULL)
+		return ERR_PTR(-EINVAL);
+
+	/* Only the pthreads threading model is supported. */
+	if (thread->group_leader->mm != thread->mm)
+		return ERR_PTR(-EINVAL);
+
+	/*
+	 * take kfd processes mutex before starting of process creation
+	 * so there won't be a case where two threads of the same process
+	 * create two kfd_process structures
+	 */
+	mutex_lock(&kfd_processes_mutex);
+
+	/* A prior open of /dev/kfd could have already created the process. */
+	process = thread->mm->kfd_process;
+	if (process)
+		pr_debug("kfd: process already found\n");
+
+	if (!process)
+		process = create_process(thread);
+
+	mutex_unlock(&kfd_processes_mutex);
+
+	return process;
+}
+
+struct kfd_process*
+radeon_kfd_get_process(const struct task_struct *thread)
+{
+	struct kfd_process *process;
+
+	if (thread->mm == NULL)
+		return ERR_PTR(-EINVAL);
+
+	/* Only the pthreads threading model is supported. */
+	if (thread->group_leader->mm != thread->mm)
+		return ERR_PTR(-EINVAL);
+
+	process = thread->mm->kfd_process;
+
+	return process;
+}
+
+/* Assumes that the kfd_process mutex is held.
+ * (Or that it doesn't need to be held because the process is exiting.)
+ *
+ * dev_filter can be set to only destroy queues for one device.
+ * Otherwise all queues for the process are destroyed.
+ */
+static void
+destroy_queues(struct kfd_process *p, struct kfd_dev *dev_filter)
+{
+	unsigned long queue_id;
+
+	for_each_set_bit(queue_id, p->allocated_queue_bitmap, MAX_PROCESS_QUEUES) {
+
+		struct kfd_queue *queue = radeon_kfd_get_queue(p, queue_id);
+		struct kfd_dev *dev;
+
+		BUG_ON(queue == NULL);
+
+		dev = queue->dev;
+
+		if (!dev_filter || dev == dev_filter) {
+			struct kfd_process_device *pdd = radeon_kfd_get_process_device_data(dev, p);
+
+			BUG_ON(pdd == NULL); /* A queue exists so pdd must. */
+
+			radeon_kfd_remove_queue(p, queue_id);
+			dev->device_info->scheduler_class->destroy_queue(dev->scheduler, &queue->scheduler_queue);
+
+			kfree(queue);
+
+			BUG_ON(pdd->queue_count == 0);
+			BUG_ON(pdd->scheduler_process == NULL);
+
+			if (--pdd->queue_count == 0) {
+				dev->device_info->scheduler_class->deregister_process(dev->scheduler,
+							pdd->scheduler_process);
+				pdd->scheduler_process = NULL;
+			}
+		}
+	}
+}
+
+static void free_process(struct kfd_process *p)
+{
+	struct kfd_process_device *pdd, *temp;
+
+	BUG_ON(p == NULL);
+
+	destroy_queues(p, NULL);
+
+	/* doorbell mappings: automatic */
+
+	list_for_each_entry_safe(pdd, temp, &p->per_device_data, per_device_list) {
+		amd_iommu_unbind_pasid(pdd->dev->pdev, p->pasid);
+		list_del(&pdd->per_device_list);
+		kfree(pdd);
+	}
+
+	radeon_kfd_pasid_free(p->pasid);
+
+	mutex_destroy(&p->mutex);
+
+	kfree(p->queues);
+
+	list_del(&p->processes_list);
+
+	kfree(p);
+}
+
+int kfd_process_exit(struct notifier_block *nb,
+			unsigned long action, void *data)
+{
+	struct mm_struct *mm = data;
+	struct kfd_process *p;
+
+	mutex_lock(&kfd_processes_mutex);
+
+	p = mm->kfd_process;
+	if (p) {
+		free_process(p);
+		mm->kfd_process = NULL;
+	}
+
+	mutex_unlock(&kfd_processes_mutex);
+
+	return 0;
+}
+
+static struct kfd_process *create_process(const struct task_struct *thread)
+{
+	struct kfd_process *process;
+	int err = -ENOMEM;
+
+	process = kzalloc(sizeof(*process), GFP_KERNEL);
+
+	if (!process)
+		goto err_alloc;
+
+	process->queues = kmalloc_array(INITIAL_QUEUE_ARRAY_SIZE, sizeof(process->queues[0]), GFP_KERNEL);
+	if (!process->queues)
+		goto err_alloc;
+
+	process->pasid = radeon_kfd_pasid_alloc();
+	if (process->pasid == 0)
+		goto err_alloc;
+
+	mutex_init(&process->mutex);
+
+	process->mm = thread->mm;
+	thread->mm->kfd_process = process;
+	list_add_tail(&process->processes_list, &kfd_processes_list);
+
+	process->lead_thread = thread->group_leader;
+
+	process->queue_array_size = INITIAL_QUEUE_ARRAY_SIZE;
+
+	INIT_LIST_HEAD(&process->per_device_data);
+
+	return process;
+
+err_alloc:
+	kfree(process->queues);
+	kfree(process);
+	return ERR_PTR(err);
+}
+
+struct kfd_process_device *
+radeon_kfd_get_process_device_data(struct kfd_dev *dev, struct kfd_process *p)
+{
+	struct kfd_process_device *pdd;
+
+	list_for_each_entry(pdd, &p->per_device_data, per_device_list)
+		if (pdd->dev == dev)
+			return pdd;
+
+	pdd = kzalloc(sizeof(*pdd), GFP_KERNEL);
+	if (pdd != NULL) {
+		pdd->dev = dev;
+		list_add(&pdd->per_device_list, &p->per_device_data);
+	}
+
+	return pdd;
+}
+
+/* Direct the IOMMU to bind the process (specifically the pasid->mm) to the device.
+ * Unbinding occurs when the process dies or the device is removed.
+ *
+ * Assumes that the process lock is held.
+ */
+struct kfd_process_device *radeon_kfd_bind_process_to_device(struct kfd_dev *dev, struct kfd_process *p)
+{
+	struct kfd_process_device *pdd = radeon_kfd_get_process_device_data(dev, p);
+	int err;
+
+	if (pdd == NULL)
+		return ERR_PTR(-ENOMEM);
+
+	if (pdd->bound)
+		return pdd;
+
+	err = amd_iommu_bind_pasid(dev->pdev, p->pasid, p->lead_thread);
+	if (err < 0)
+		return ERR_PTR(err);
+
+	pdd->bound = true;
+
+	return pdd;
+}
+
+void radeon_kfd_unbind_process_from_device(struct kfd_dev *dev, pasid_t pasid)
+{
+	struct kfd_process *p;
+	struct kfd_process_device *pdd;
+
+	BUG_ON(dev == NULL);
+
+	mutex_lock(&kfd_processes_mutex);
+
+	list_for_each_entry(p, &kfd_processes_list, processes_list)
+		if (p->pasid == pasid)
+			break;
+
+	mutex_unlock(&kfd_processes_mutex);
+
+	BUG_ON(p->pasid != pasid);
+
+	pdd = radeon_kfd_get_process_device_data(dev, p);
+
+	BUG_ON(pdd == NULL);
+
+	mutex_lock(&p->mutex);
+
+	destroy_queues(p, dev);
+
+	/* All queues just got destroyed so this should be gone. */
+	BUG_ON(pdd->scheduler_process != NULL);
+
+	/*
+	 * Just mark pdd as unbound, because we still need it to call
+	 * amd_iommu_unbind_pasid() in when the process exits.
+	 * We don't call amd_iommu_unbind_pasid() here
+	 * because the IOMMU called us.
+	 */
+	pdd->bound = false;
+
+	mutex_unlock(&p->mutex);
+}
+
+/* Ensure that the process's queue array is large enough to hold the queue at queue_id.
+ * Assumes that the process lock is held. */
+static bool ensure_queue_array_size(struct kfd_process *p, unsigned int queue_id)
+{
+	size_t desired_size;
+	struct kfd_queue **new_queues;
+
+	compiletime_assert(INITIAL_QUEUE_ARRAY_SIZE > 0, "INITIAL_QUEUE_ARRAY_SIZE must not be 0");
+	compiletime_assert(INITIAL_QUEUE_ARRAY_SIZE <= MAX_PROCESS_QUEUES,
+			   "INITIAL_QUEUE_ARRAY_SIZE must be less than MAX_PROCESS_QUEUES");
+	/* Ensure that doubling the current size won't ever overflow. */
+	compiletime_assert(MAX_PROCESS_QUEUES < SIZE_MAX / 2, "MAX_PROCESS_QUEUES must be less than SIZE_MAX/2");
+
+	/*
+	 * These & queue_id < MAX_PROCESS_QUEUES guarantee that
+	 * the desired_size calculation will end up <= MAX_PROCESS_QUEUES
+	 */
+	compiletime_assert(is_power_of_2(INITIAL_QUEUE_ARRAY_SIZE), "INITIAL_QUEUE_ARRAY_SIZE must be power of 2.");
+	compiletime_assert(MAX_PROCESS_QUEUES % INITIAL_QUEUE_ARRAY_SIZE == 0,
+			   "MAX_PROCESS_QUEUES must be multiple of INITIAL_QUEUE_ARRAY_SIZE.");
+	compiletime_assert(is_power_of_2(MAX_PROCESS_QUEUES / INITIAL_QUEUE_ARRAY_SIZE),
+			   "MAX_PROCESS_QUEUES must be a power-of-2 multiple of INITIAL_QUEUE_ARRAY_SIZE.");
+
+	if (queue_id < p->queue_array_size)
+		return true;
+
+	if (queue_id >= MAX_PROCESS_QUEUES)
+		return false;
+
+	desired_size = p->queue_array_size;
+	while (desired_size <= queue_id)
+		desired_size *= 2;
+
+	BUG_ON(desired_size < queue_id || desired_size > MAX_PROCESS_QUEUES);
+	BUG_ON(desired_size % INITIAL_QUEUE_ARRAY_SIZE != 0 || !is_power_of_2(desired_size / INITIAL_QUEUE_ARRAY_SIZE));
+
+	new_queues = kmalloc_array(desired_size, sizeof(p->queues[0]), GFP_KERNEL);
+	if (!new_queues)
+		return false;
+
+	memcpy(new_queues, p->queues, p->queue_array_size * sizeof(p->queues[0]));
+
+	kfree(p->queues);
+	p->queues = new_queues;
+	p->queue_array_size = desired_size;
+
+	return true;
+}
+
+/* Assumes that the process lock is held. */
+bool radeon_kfd_allocate_queue_id(struct kfd_process *p, unsigned int *queue_id)
+{
+	unsigned int qid = find_first_zero_bit(p->allocated_queue_bitmap, MAX_PROCESS_QUEUES);
+
+	if (qid >= MAX_PROCESS_QUEUES)
+		return false;
+
+	if (!ensure_queue_array_size(p, qid))
+		return false;
+
+	__set_bit(qid, p->allocated_queue_bitmap);
+
+	p->queues[qid] = NULL;
+	*queue_id = qid;
+
+	return true;
+}
+
+/* Install a queue into a previously-allocated queue id.
+ *  Assumes that the process lock is held. */
+void radeon_kfd_install_queue(struct kfd_process *p, unsigned int queue_id, struct kfd_queue *queue)
+{
+	BUG_ON(queue_id >= p->queue_array_size); /* Have to call allocate_queue_id before install_queue. */
+	BUG_ON(queue == NULL);
+
+	p->queues[queue_id] = queue;
+}
+
+/* Remove a queue from the open queue list and deallocate the queue id.
+ * This can be called whether or not a queue was installed.
+ * Assumes that the process lock is held. */
+void radeon_kfd_remove_queue(struct kfd_process *p, unsigned int queue_id)
+{
+	BUG_ON(!test_bit(queue_id, p->allocated_queue_bitmap));
+	BUG_ON(queue_id >= p->queue_array_size);
+
+	__clear_bit(queue_id, p->allocated_queue_bitmap);
+}
+
+/* Assumes that the process lock is held. */
+struct kfd_queue *radeon_kfd_get_queue(struct kfd_process *p, unsigned int queue_id)
+{
+	/* test_bit because the contents of unallocated queue slots are undefined.
+	 * Otherwise ensure_queue_array_size would have to clear new entries and
+	 * remove_queue would have to NULL removed queues. */
+	return (queue_id < p->queue_array_size &&
+		test_bit(queue_id, p->allocated_queue_bitmap)) ?
+			p->queues[queue_id] : NULL;
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_scheduler.h b/drivers/gpu/hsa/radeon/kfd_scheduler.h
new file mode 100644
index 0000000..48a032f
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_scheduler.h
@@ -0,0 +1,62 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef KFD_SCHEDULER_H_INCLUDED
+#define KFD_SCHEDULER_H_INCLUDED
+
+#include <linux/types.h>
+struct kfd_process;
+
+/* Opaque types for scheduler private data. */
+struct kfd_scheduler;
+struct kfd_scheduler_process;
+struct kfd_scheduler_queue;
+
+struct kfd_scheduler_class {
+	const char *name;
+
+	int (*create)(struct kfd_dev *, struct kfd_scheduler **);
+	void (*destroy)(struct kfd_scheduler *);
+
+	void (*start)(struct kfd_scheduler *);
+	void (*stop)(struct kfd_scheduler *);
+
+	int (*register_process)(struct kfd_scheduler *, struct kfd_process *, struct kfd_scheduler_process **);
+	void (*deregister_process)(struct kfd_scheduler *, struct kfd_scheduler_process *);
+
+	size_t queue_size;
+
+	int (*create_queue)(struct kfd_scheduler *scheduler,
+			    struct kfd_scheduler_process *process,
+			    struct kfd_scheduler_queue *queue,
+			    void __user *ring_address,
+			    uint64_t ring_size,
+			    void __user *rptr_address,
+			    void __user *wptr_address,
+			    unsigned int doorbell);
+
+	void (*destroy_queue)(struct kfd_scheduler *, struct kfd_scheduler_queue *);
+};
+
+extern const struct kfd_scheduler_class radeon_kfd_cik_static_scheduler_class;
+
+#endif
diff --git a/drivers/gpu/hsa/radeon/kfd_topology.c b/drivers/gpu/hsa/radeon/kfd_topology.c
new file mode 100644
index 0000000..6acac25
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_topology.c
@@ -0,0 +1,1201 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#include <linux/types.h>
+#include <linux/kernel.h>
+#include <linux/pci.h>
+#include <linux/errno.h>
+#include <linux/acpi.h>
+#include <linux/hash.h>
+
+#include "kfd_priv.h"
+#include "kfd_crat.h"
+#include "kfd_topology.h"
+
+static struct list_head topology_device_list;
+static int topology_crat_parsed;
+static struct kfd_system_properties sys_props;
+
+static DECLARE_RWSEM(topology_lock);
+
+
+static uint8_t checksum_image(const void *buf, size_t len)
+{
+	uint8_t *p = (uint8_t *)buf;
+	uint8_t sum = 0;
+
+	if (!buf)
+		return 0;
+
+	while (len-- > 0)
+		sum += *p++;
+
+	return sum;
+		}
+
+struct kfd_dev *radeon_kfd_device_by_id(uint32_t gpu_id)
+{
+	struct kfd_topology_device *top_dev;
+	struct kfd_dev *device = NULL;
+
+	down_read(&topology_lock);
+
+	list_for_each_entry(top_dev, &topology_device_list, list)
+		if (top_dev->gpu_id == gpu_id) {
+			device = top_dev->gpu;
+			break;
+		}
+
+	up_read(&topology_lock);
+
+	return device;
+}
+
+struct kfd_dev *radeon_kfd_device_by_pci_dev(const struct pci_dev *pdev)
+{
+	struct kfd_topology_device *top_dev;
+	struct kfd_dev *device = NULL;
+
+	down_read(&topology_lock);
+
+	list_for_each_entry(top_dev, &topology_device_list, list)
+		if (top_dev->gpu->pdev == pdev) {
+			device = top_dev->gpu;
+			break;
+		}
+
+	up_read(&topology_lock);
+
+	return device;
+}
+
+static int kfd_topology_get_crat_acpi(void *crat_image, size_t *size)
+{
+	struct acpi_table_header *crat_table;
+	acpi_status status;
+
+	if (!size)
+		return -EINVAL;
+
+/*
+	 * Fetch the CRAT table from ACPI
+ */
+	status = acpi_get_table(CRAT_SIGNATURE, 0, &crat_table);
+	if (status == AE_NOT_FOUND) {
+		pr_warn("CRAT table not found\n");
+		return -ENODATA;
+	} else if (ACPI_FAILURE(status)) {
+		const char *err = acpi_format_exception(status);
+
+		pr_err("CRAT table error: %s\n", err);
+		return -EINVAL;
+	}
+
+	/*
+	 * The checksum of the table should be verified
+	 */
+	if (checksum_image(crat_table, crat_table->length) ==
+		crat_table->checksum) {
+		pr_err("Bad checksum for the CRAT table\n");
+		return -EINVAL;
+}
+
+
+	if (*size >= crat_table->length && crat_image != 0)
+		memcpy(crat_image, crat_table, crat_table->length);
+
+	*size = crat_table->length;
+
+	return 0;
+}
+
+static void kfd_populated_cu_info_cpu(struct kfd_topology_device *dev,
+		struct crat_subtype_computeunit *cu)
+{
+	BUG_ON(!dev);
+	BUG_ON(!cu);
+
+	dev->node_props.cpu_cores_count = cu->num_cpu_cores;
+	dev->node_props.cpu_core_id_base = cu->processor_id_low;
+	if (cu->hsa_capability & CRAT_CU_FLAGS_IOMMU_PRESENT)
+		dev->node_props.capability |= HSA_CAP_ATS_PRESENT;
+
+	pr_info("CU CPU: cores=%d id_base=%d\n", cu->num_cpu_cores,
+			cu->processor_id_low);
+}
+
+static void kfd_populated_cu_info_gpu(struct kfd_topology_device *dev,
+		struct crat_subtype_computeunit *cu)
+{
+	BUG_ON(!dev);
+	BUG_ON(!cu);
+
+	dev->node_props.simd_id_base = cu->processor_id_low;
+	dev->node_props.simd_count = cu->num_simd_cores;
+	dev->node_props.lds_size_in_kb = cu->lds_size_in_kb;
+	dev->node_props.max_waves_per_simd = cu->max_waves_simd;
+	dev->node_props.wave_front_size = cu->wave_front_size;
+	dev->node_props.mem_banks_count = cu->num_banks;
+	dev->node_props.array_count = cu->num_arrays;
+	dev->node_props.cu_per_simd_array = cu->num_cu_per_array;
+	dev->node_props.simd_per_cu = cu->num_simd_per_cu;
+	dev->node_props.max_slots_scratch_cu = cu->max_slots_scatch_cu;
+	if (cu->hsa_capability & CRAT_CU_FLAGS_HOT_PLUGGABLE)
+		dev->node_props.capability |= HSA_CAP_HOT_PLUGGABLE;
+	pr_info("CU GPU: simds=%d id_base=%d\n", cu->num_simd_cores,
+				cu->processor_id_low);
+}
+
+/* kfd_parse_subtype_cu is called when the topology mutex is already acquired */
+static int kfd_parse_subtype_cu(struct crat_subtype_computeunit *cu)
+{
+	struct kfd_topology_device *dev;
+	int i = 0;
+
+	BUG_ON(!cu);
+
+	pr_info("Found CU entry in CRAT table with proximity_domain=%d caps=%x\n",
+			cu->proximity_domain, cu->hsa_capability);
+	list_for_each_entry(dev, &topology_device_list, list) {
+		if (cu->proximity_domain == i) {
+			if (cu->flags & CRAT_CU_FLAGS_CPU_PRESENT)
+				kfd_populated_cu_info_cpu(dev, cu);
+
+			if (cu->flags & CRAT_CU_FLAGS_GPU_PRESENT)
+				kfd_populated_cu_info_gpu(dev, cu);
+			break;
+		}
+		i++;
+	}
+
+	return 0;
+}
+
+/* kfd_parse_subtype_mem is called when the topology mutex is already acquired */
+static int kfd_parse_subtype_mem(struct crat_subtype_memory *mem)
+{
+	struct kfd_mem_properties *props;
+	struct kfd_topology_device *dev;
+	int i = 0;
+
+	BUG_ON(!mem);
+
+	pr_info("Found memory entry in CRAT table with proximity_domain=%d\n",
+			mem->promixity_domain);
+	list_for_each_entry(dev, &topology_device_list, list) {
+		if (mem->promixity_domain == i) {
+			props = kfd_alloc_struct(props);
+			if (props == 0)
+				return -ENOMEM;
+
+			if (dev->node_props.cpu_cores_count == 0)
+				props->heap_type = HSA_MEM_HEAP_TYPE_FB_PRIVATE;
+			else
+				props->heap_type = HSA_MEM_HEAP_TYPE_SYSTEM;
+
+			if (mem->flags & CRAT_MEM_FLAGS_HOT_PLUGGABLE)
+				props->flags |= HSA_MEM_FLAGS_HOT_PLUGGABLE;
+			if (mem->flags & CRAT_MEM_FLAGS_NON_VOLATILE)
+				props->flags |= HSA_MEM_FLAGS_NON_VOLATILE;
+
+			props->size_in_bytes = ((uint64_t)mem->length_high << 32) +
+						mem->length_low;
+			props->width = mem->width;
+
+			dev->mem_bank_count++;
+			list_add_tail(&props->list, &dev->mem_props);
+
+			break;
+		}
+		i++;
+	}
+
+	return 0;
+}
+
+/* kfd_parse_subtype_cache is called when the topology mutex is already acquired */
+static int kfd_parse_subtype_cache(struct crat_subtype_cache *cache)
+{
+	struct kfd_cache_properties *props;
+	struct kfd_topology_device *dev;
+	uint32_t id;
+
+	BUG_ON(!cache);
+
+	id = cache->processor_id_low;
+
+	pr_info("Found cache entry in CRAT table with processor_id=%d\n", id);
+	list_for_each_entry(dev, &topology_device_list, list)
+		if (id == dev->node_props.cpu_core_id_base ||
+		    id == dev->node_props.simd_id_base) {
+			props = kfd_alloc_struct(props);
+			if (props == 0)
+				return -ENOMEM;
+
+			props->processor_id_low = id;
+			props->cache_level = cache->cache_level;
+			props->cache_size = cache->cache_size;
+			props->cacheline_size = cache->cache_line_size;
+			props->cachelines_per_tag = cache->lines_per_tag;
+			props->cache_assoc = cache->associativity;
+			props->cache_latency = cache->cache_latency;
+
+			if (cache->flags & CRAT_CACHE_FLAGS_DATA_CACHE)
+				props->cache_type |= HSA_CACHE_TYPE_DATA;
+			if (cache->flags & CRAT_CACHE_FLAGS_INST_CACHE)
+				props->cache_type |= HSA_CACHE_TYPE_INSTRUCTION;
+			if (cache->flags & CRAT_CACHE_FLAGS_CPU_CACHE)
+				props->cache_type |= HSA_CACHE_TYPE_CPU;
+			if (cache->flags & CRAT_CACHE_FLAGS_SIMD_CACHE)
+				props->cache_type |= HSA_CACHE_TYPE_HSACU;
+
+			dev->cache_count++;
+			dev->node_props.caches_count++;
+			list_add_tail(&props->list, &dev->cache_props);
+
+			break;
+		}
+
+	return 0;
+}
+
+/* kfd_parse_subtype_iolink is called when the topology mutex is already acquired */
+static int kfd_parse_subtype_iolink(struct crat_subtype_iolink *iolink)
+{
+	struct kfd_iolink_properties *props;
+	struct kfd_topology_device *dev;
+	uint32_t i = 0;
+	uint32_t id_from;
+	uint32_t id_to;
+
+	BUG_ON(!iolink);
+
+	id_from = iolink->proximity_domain_from;
+	id_to = iolink->proximity_domain_to;
+
+	pr_info("Found IO link entry in CRAT table with id_from=%d\n", id_from);
+	list_for_each_entry(dev, &topology_device_list, list) {
+		if (id_from == i) {
+			props = kfd_alloc_struct(props);
+			if (props == 0)
+				return -ENOMEM;
+
+			props->node_from = id_from;
+			props->node_to = id_to;
+			props->ver_maj = iolink->version_major;
+			props->ver_min = iolink->version_minor;
+
+			/*
+			 * weight factor (derived from CDIR), currently always 1
+			 */
+			props->weight = 1;
+
+			props->min_latency = iolink->minimum_latency;
+			props->max_latency = iolink->maximum_latency;
+			props->min_bandwidth = iolink->minimum_bandwidth_mbs;
+			props->max_bandwidth = iolink->maximum_bandwidth_mbs;
+			props->rec_transfer_size =
+					iolink->recommended_transfer_size;
+
+			dev->io_link_count++;
+			dev->node_props.io_links_count++;
+			list_add_tail(&props->list, &dev->io_link_props);
+
+			break;
+		}
+		i++;
+	}
+
+	return 0;
+}
+
+static int kfd_parse_subtype(struct crat_subtype_generic *sub_type_hdr)
+{
+	struct crat_subtype_computeunit *cu;
+	struct crat_subtype_memory *mem;
+	struct crat_subtype_cache *cache;
+	struct crat_subtype_iolink *iolink;
+	int ret = 0;
+
+	BUG_ON(!sub_type_hdr);
+
+	switch (sub_type_hdr->type) {
+	case CRAT_SUBTYPE_COMPUTEUNIT_AFFINITY:
+		cu = (struct crat_subtype_computeunit *)sub_type_hdr;
+		ret = kfd_parse_subtype_cu(cu);
+		break;
+	case CRAT_SUBTYPE_MEMORY_AFFINITY:
+		mem = (struct crat_subtype_memory *)sub_type_hdr;
+		ret = kfd_parse_subtype_mem(mem);
+		break;
+	case CRAT_SUBTYPE_CACHE_AFFINITY:
+		cache = (struct crat_subtype_cache *)sub_type_hdr;
+		ret = kfd_parse_subtype_cache(cache);
+		break;
+	case CRAT_SUBTYPE_TLB_AFFINITY:
+		/*
+		 * For now, nothing to do here
+		 */
+		pr_info("Found TLB entry in CRAT table (not processing)\n");
+		break;
+	case CRAT_SUBTYPE_CCOMPUTE_AFFINITY:
+		/*
+		 * For now, nothing to do here
+		 */
+		pr_info("Found CCOMPUTE entry in CRAT table (not processing)\n");
+		break;
+	case CRAT_SUBTYPE_IOLINK_AFFINITY:
+		iolink = (struct crat_subtype_iolink *)sub_type_hdr;
+		ret = kfd_parse_subtype_iolink(iolink);
+		break;
+	default:
+		pr_warn("Unknown subtype (%d) in CRAT\n",
+				sub_type_hdr->type);
+	}
+
+	return ret;
+}
+
+static void kfd_release_topology_device(struct kfd_topology_device *dev)
+{
+	struct kfd_mem_properties *mem;
+	struct kfd_cache_properties *cache;
+	struct kfd_iolink_properties *iolink;
+
+	BUG_ON(!dev);
+
+	list_del(&dev->list);
+
+	while (dev->mem_props.next != &dev->mem_props) {
+		mem = container_of(dev->mem_props.next,
+				struct kfd_mem_properties, list);
+		list_del(&mem->list);
+		kfree(mem);
+	}
+
+	while (dev->cache_props.next != &dev->cache_props) {
+		cache = container_of(dev->cache_props.next,
+				struct kfd_cache_properties, list);
+		list_del(&cache->list);
+		kfree(cache);
+	}
+
+	while (dev->io_link_props.next != &dev->io_link_props) {
+		iolink = container_of(dev->io_link_props.next,
+				struct kfd_iolink_properties, list);
+		list_del(&iolink->list);
+		kfree(iolink);
+	}
+
+	kfree(dev);
+
+	sys_props.num_devices--;
+}
+
+static void kfd_release_live_view(void)
+{
+	struct kfd_topology_device *dev;
+
+	while (topology_device_list.next != &topology_device_list) {
+		dev = container_of(topology_device_list.next,
+				 struct kfd_topology_device, list);
+		kfd_release_topology_device(dev);
+}
+
+	memset(&sys_props, 0, sizeof(sys_props));
+}
+
+static struct kfd_topology_device *kfd_create_topology_device(void)
+{
+	struct kfd_topology_device *dev;
+
+	dev = kfd_alloc_struct(dev);
+	if (dev == 0) {
+		pr_err("No memory to allocate a topology device");
+		return 0;
+	}
+
+	INIT_LIST_HEAD(&dev->mem_props);
+	INIT_LIST_HEAD(&dev->cache_props);
+	INIT_LIST_HEAD(&dev->io_link_props);
+
+	list_add_tail(&dev->list, &topology_device_list);
+	sys_props.num_devices++;
+
+	return dev;
+	}
+
+static int kfd_parse_crat_table(void *crat_image)
+{
+	struct kfd_topology_device *top_dev;
+	struct crat_subtype_generic *sub_type_hdr;
+	uint16_t node_id;
+	int ret;
+	struct crat_header *crat_table = (struct crat_header *)crat_image;
+	uint16_t num_nodes;
+	uint32_t image_len;
+
+	if (!crat_image)
+		return -EINVAL;
+
+	num_nodes = crat_table->num_domains;
+	image_len = crat_table->length;
+
+	pr_info("Parsing CRAT table with %d nodes\n", num_nodes);
+
+	for (node_id = 0; node_id < num_nodes; node_id++) {
+		top_dev = kfd_create_topology_device();
+		if (!top_dev) {
+			kfd_release_live_view();
+			return -ENOMEM;
+	}
+}
+
+	sys_props.platform_id = *((uint64_t *)crat_table->oem_id);
+	sys_props.platform_oem = *((uint64_t *)crat_table->oem_table_id);
+	sys_props.platform_rev = crat_table->revision;
+
+	sub_type_hdr = (struct crat_subtype_generic *)(crat_table+1);
+	while ((char *)sub_type_hdr + sizeof(struct crat_subtype_generic) <
+			((char *)crat_image) + image_len) {
+		if (sub_type_hdr->flags & CRAT_SUBTYPE_FLAGS_ENABLED) {
+			ret = kfd_parse_subtype(sub_type_hdr);
+			if (ret != 0) {
+				kfd_release_live_view();
+				return ret;
+			}
+		}
+
+		sub_type_hdr = (typeof(sub_type_hdr))((char *)sub_type_hdr +
+				sub_type_hdr->length);
+	}
+
+	sys_props.generation_count++;
+	topology_crat_parsed = 1;
+
+	return 0;
+}
+
+
+#define sysfs_show_gen_prop(buffer, fmt, ...) \
+		snprintf(buffer, PAGE_SIZE, "%s"fmt, buffer, __VA_ARGS__)
+#define sysfs_show_32bit_prop(buffer, name, value) \
+		sysfs_show_gen_prop(buffer, "%s %u\n", name, value)
+#define sysfs_show_64bit_prop(buffer, name, value) \
+		sysfs_show_gen_prop(buffer, "%s %llu\n", name, value)
+#define sysfs_show_32bit_val(buffer, value) \
+		sysfs_show_gen_prop(buffer, "%u\n", value)
+#define sysfs_show_str_val(buffer, value) \
+		sysfs_show_gen_prop(buffer, "%s\n", value)
+
+static ssize_t sysprops_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	ssize_t ret;
+
+	/* Making sure that the buffer is an empty string */
+	buffer[0] = 0;
+
+	if (attr == &sys_props.attr_genid) {
+		ret = sysfs_show_32bit_val(buffer, sys_props.generation_count);
+	} else if (attr == &sys_props.attr_props) {
+		sysfs_show_64bit_prop(buffer, "platform_oem",
+				sys_props.platform_oem);
+		sysfs_show_64bit_prop(buffer, "platform_id",
+				sys_props.platform_id);
+		ret = sysfs_show_64bit_prop(buffer, "platform_rev",
+				sys_props.platform_rev);
+	} else {
+		ret = -EINVAL;
+	}
+
+	return ret;
+}
+
+static const struct sysfs_ops sysprops_ops = {
+	.show = sysprops_show,
+};
+
+static struct kobj_type sysprops_type = {
+	.sysfs_ops = &sysprops_ops,
+};
+
+static ssize_t iolink_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	ssize_t ret;
+	struct kfd_iolink_properties *iolink;
+
+	/* Making sure that the buffer is an empty string */
+	buffer[0] = 0;
+
+	iolink = container_of(attr, struct kfd_iolink_properties, attr);
+	sysfs_show_32bit_prop(buffer, "type", iolink->iolink_type);
+	sysfs_show_32bit_prop(buffer, "version_major", iolink->ver_maj);
+	sysfs_show_32bit_prop(buffer, "version_minor", iolink->ver_min);
+	sysfs_show_32bit_prop(buffer, "node_from", iolink->node_from);
+	sysfs_show_32bit_prop(buffer, "node_to", iolink->node_to);
+	sysfs_show_32bit_prop(buffer, "weight", iolink->weight);
+	sysfs_show_32bit_prop(buffer, "min_latency", iolink->min_latency);
+	sysfs_show_32bit_prop(buffer, "max_latency", iolink->max_latency);
+	sysfs_show_32bit_prop(buffer, "min_bandwidth", iolink->min_bandwidth);
+	sysfs_show_32bit_prop(buffer, "max_bandwidth", iolink->max_bandwidth);
+	sysfs_show_32bit_prop(buffer, "recommended_transfer_size",
+			iolink->rec_transfer_size);
+	ret = sysfs_show_32bit_prop(buffer, "flags", iolink->flags);
+
+	return ret;
+}
+
+static const struct sysfs_ops iolink_ops = {
+	.show = iolink_show,
+};
+
+static struct kobj_type iolink_type = {
+	.sysfs_ops = &iolink_ops,
+};
+
+static ssize_t mem_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	ssize_t ret;
+	struct kfd_mem_properties *mem;
+
+	/* Making sure that the buffer is an empty string */
+	buffer[0] = 0;
+
+	mem = container_of(attr, struct kfd_mem_properties, attr);
+	sysfs_show_32bit_prop(buffer, "heap_type", mem->heap_type);
+	sysfs_show_64bit_prop(buffer, "size_in_bytes", mem->size_in_bytes);
+	sysfs_show_32bit_prop(buffer, "flags", mem->flags);
+	sysfs_show_32bit_prop(buffer, "width", mem->width);
+	ret = sysfs_show_32bit_prop(buffer, "mem_clk_max", mem->mem_clk_max);
+
+	return ret;
+}
+
+static const struct sysfs_ops mem_ops = {
+	.show = mem_show,
+};
+
+static struct kobj_type mem_type = {
+	.sysfs_ops = &mem_ops,
+};
+
+static ssize_t kfd_cache_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	ssize_t ret;
+	uint32_t i;
+	struct kfd_cache_properties *cache;
+
+	/* Making sure that the buffer is an empty string */
+	buffer[0] = 0;
+
+	cache = container_of(attr, struct kfd_cache_properties, attr);
+	sysfs_show_32bit_prop(buffer, "processor_id_low",
+			cache->processor_id_low);
+	sysfs_show_32bit_prop(buffer, "level", cache->cache_level);
+	sysfs_show_32bit_prop(buffer, "size", cache->cache_size);
+	sysfs_show_32bit_prop(buffer, "cache_line_size", cache->cacheline_size);
+	sysfs_show_32bit_prop(buffer, "cache_lines_per_tag",
+			cache->cachelines_per_tag);
+	sysfs_show_32bit_prop(buffer, "association", cache->cache_assoc);
+	sysfs_show_32bit_prop(buffer, "latency", cache->cache_latency);
+	sysfs_show_32bit_prop(buffer, "type", cache->cache_type);
+	snprintf(buffer, PAGE_SIZE, "%ssibling_map ", buffer);
+	for (i = 0; i < KFD_TOPOLOGY_CPU_SIBLINGS; i++)
+		ret = snprintf(buffer, PAGE_SIZE, "%s%d%s",
+				buffer, cache->sibling_map[i],
+				(i == KFD_TOPOLOGY_CPU_SIBLINGS-1) ?
+						"\n" : ",");
+
+	return ret;
+}
+
+static const struct sysfs_ops cache_ops = {
+	.show = kfd_cache_show,
+};
+
+static struct kobj_type cache_type = {
+	.sysfs_ops = &cache_ops,
+};
+
+static ssize_t node_show(struct kobject *kobj, struct attribute *attr,
+		char *buffer)
+{
+	ssize_t ret;
+	struct kfd_topology_device *dev;
+	char public_name[KFD_TOPOLOGY_PUBLIC_NAME_SIZE];
+	uint32_t i;
+
+	/* Making sure that the buffer is an empty string */
+	buffer[0] = 0;
+
+	if (strcmp(attr->name, "gpu_id") == 0) {
+		dev = container_of(attr, struct kfd_topology_device,
+				attr_gpuid);
+		ret = sysfs_show_32bit_val(buffer, dev->gpu_id);
+	} else if (strcmp(attr->name, "name") == 0) {
+		dev = container_of(attr, struct kfd_topology_device,
+				attr_name);
+		for (i = 0; i < KFD_TOPOLOGY_PUBLIC_NAME_SIZE; i++) {
+			public_name[i] =
+					(char)dev->node_props.marketing_name[i];
+			if (dev->node_props.marketing_name[i] == 0)
+				break;
+		}
+		public_name[KFD_TOPOLOGY_PUBLIC_NAME_SIZE-1] = 0x0;
+		ret = sysfs_show_str_val(buffer, public_name);
+	} else {
+		dev = container_of(attr, struct kfd_topology_device,
+				attr_props);
+		sysfs_show_32bit_prop(buffer, "cpu_cores_count",
+				dev->node_props.cpu_cores_count);
+		sysfs_show_32bit_prop(buffer, "simd_count",
+				dev->node_props.simd_count);
+		sysfs_show_32bit_prop(buffer, "mem_banks_count",
+				dev->node_props.mem_banks_count);
+		sysfs_show_32bit_prop(buffer, "caches_count",
+				dev->node_props.caches_count);
+		sysfs_show_32bit_prop(buffer, "io_links_count",
+				dev->node_props.io_links_count);
+		sysfs_show_32bit_prop(buffer, "cpu_core_id_base",
+				dev->node_props.cpu_core_id_base);
+		sysfs_show_32bit_prop(buffer, "simd_id_base",
+				dev->node_props.simd_id_base);
+		sysfs_show_32bit_prop(buffer, "capability",
+				dev->node_props.capability);
+		sysfs_show_32bit_prop(buffer, "max_waves_per_simd",
+				dev->node_props.max_waves_per_simd);
+		sysfs_show_32bit_prop(buffer, "lds_size_in_kb",
+				dev->node_props.lds_size_in_kb);
+		sysfs_show_32bit_prop(buffer, "gds_size_in_kb",
+				dev->node_props.gds_size_in_kb);
+		sysfs_show_32bit_prop(buffer, "wave_front_size",
+				dev->node_props.wave_front_size);
+		sysfs_show_32bit_prop(buffer, "array_count",
+				dev->node_props.array_count);
+		sysfs_show_32bit_prop(buffer, "simd_arrays_per_engine",
+				dev->node_props.simd_arrays_per_engine);
+		sysfs_show_32bit_prop(buffer, "cu_per_simd_array",
+				dev->node_props.cu_per_simd_array);
+		sysfs_show_32bit_prop(buffer, "simd_per_cu",
+				dev->node_props.simd_per_cu);
+		sysfs_show_32bit_prop(buffer, "max_slots_scratch_cu",
+				dev->node_props.max_slots_scratch_cu);
+		sysfs_show_32bit_prop(buffer, "engine_id",
+				dev->node_props.engine_id);
+		sysfs_show_32bit_prop(buffer, "vendor_id",
+				dev->node_props.vendor_id);
+		sysfs_show_32bit_prop(buffer, "device_id",
+				dev->node_props.device_id);
+		sysfs_show_32bit_prop(buffer, "location_id",
+				dev->node_props.location_id);
+		sysfs_show_32bit_prop(buffer, "max_engine_clk_fcompute",
+				dev->node_props.max_engine_clk_fcompute);
+		ret = sysfs_show_32bit_prop(buffer, "max_engine_clk_ccompute",
+				dev->node_props.max_engine_clk_ccompute);
+	}
+
+	return ret;
+}
+
+static const struct sysfs_ops node_ops = {
+	.show = node_show,
+};
+
+static struct kobj_type node_type = {
+	.sysfs_ops = &node_ops,
+};
+
+static void kfd_remove_sysfs_file(struct kobject *kobj, struct attribute *attr)
+{
+	sysfs_remove_file(kobj, attr);
+	kobject_del(kobj);
+	kobject_put(kobj);
+}
+
+static void kfd_remove_sysfs_node_entry(struct kfd_topology_device *dev)
+{
+	struct kfd_iolink_properties *iolink;
+	struct kfd_cache_properties *cache;
+	struct kfd_mem_properties *mem;
+
+	BUG_ON(!dev);
+
+	if (dev->kobj_iolink) {
+		list_for_each_entry(iolink, &dev->io_link_props, list)
+			if (iolink->kobj) {
+				kfd_remove_sysfs_file(iolink->kobj, &iolink->attr);
+				iolink->kobj = 0;
+			}
+		kobject_del(dev->kobj_iolink);
+		kobject_put(dev->kobj_iolink);
+		dev->kobj_iolink = 0;
+	}
+
+	if (dev->kobj_cache) {
+		list_for_each_entry(cache, &dev->cache_props, list)
+			if (cache->kobj) {
+				kfd_remove_sysfs_file(cache->kobj, &cache->attr);
+				cache->kobj = 0;
+			}
+		kobject_del(dev->kobj_cache);
+		kobject_put(dev->kobj_cache);
+		dev->kobj_cache = 0;
+	}
+
+	if (dev->kobj_mem) {
+		list_for_each_entry(mem, &dev->mem_props, list)
+			if (mem->kobj) {
+				kfd_remove_sysfs_file(mem->kobj, &mem->attr);
+				mem->kobj = 0;
+			}
+		kobject_del(dev->kobj_mem);
+		kobject_put(dev->kobj_mem);
+		dev->kobj_mem = 0;
+	}
+
+	if (dev->kobj_node) {
+		sysfs_remove_file(dev->kobj_node, &dev->attr_gpuid);
+		sysfs_remove_file(dev->kobj_node, &dev->attr_name);
+		sysfs_remove_file(dev->kobj_node, &dev->attr_props);
+		kobject_del(dev->kobj_node);
+		kobject_put(dev->kobj_node);
+		dev->kobj_node = 0;
+	}
+}
+
+static int kfd_build_sysfs_node_entry(struct kfd_topology_device *dev,
+		uint32_t id)
+{
+	struct kfd_iolink_properties *iolink;
+	struct kfd_cache_properties *cache;
+	struct kfd_mem_properties *mem;
+	int ret;
+	uint32_t i;
+
+	BUG_ON(!dev);
+
+	/*
+	 * Creating the sysfs folders
+	 */
+	BUG_ON(dev->kobj_node);
+	dev->kobj_node = kfd_alloc_struct(dev->kobj_node);
+	if (!dev->kobj_node)
+		return -ENOMEM;
+
+	ret = kobject_init_and_add(dev->kobj_node, &node_type,
+			sys_props.kobj_nodes, "%d", id);
+	if (ret < 0)
+		return ret;
+
+	dev->kobj_mem = kobject_create_and_add("mem_banks", dev->kobj_node);
+	if (!dev->kobj_mem)
+		return -ENOMEM;
+
+	dev->kobj_cache = kobject_create_and_add("caches", dev->kobj_node);
+	if (!dev->kobj_cache)
+		return -ENOMEM;
+
+	dev->kobj_iolink = kobject_create_and_add("io_links", dev->kobj_node);
+	if (!dev->kobj_iolink)
+		return -ENOMEM;
+
+	/*
+	 * Creating sysfs files for node properties
+	 */
+	dev->attr_gpuid.name = "gpu_id";
+	dev->attr_gpuid.mode = KFD_SYSFS_FILE_MODE;
+	sysfs_attr_init(&dev->attr_gpuid);
+	dev->attr_name.name = "name";
+	dev->attr_name.mode = KFD_SYSFS_FILE_MODE;
+	sysfs_attr_init(&dev->attr_name);
+	dev->attr_props.name = "properties";
+	dev->attr_props.mode = KFD_SYSFS_FILE_MODE;
+	sysfs_attr_init(&dev->attr_props);
+	ret = sysfs_create_file(dev->kobj_node, &dev->attr_gpuid);
+	if (ret < 0)
+		return ret;
+	ret = sysfs_create_file(dev->kobj_node, &dev->attr_name);
+	if (ret < 0)
+		return ret;
+	ret = sysfs_create_file(dev->kobj_node, &dev->attr_props);
+	if (ret < 0)
+		return ret;
+
+	i = 0;
+	list_for_each_entry(mem, &dev->mem_props, list) {
+		mem->kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
+		if (!mem->kobj)
+			return -ENOMEM;
+		ret = kobject_init_and_add(mem->kobj, &mem_type,
+				dev->kobj_mem, "%d", i);
+		if (ret < 0)
+			return ret;
+
+		mem->attr.name = "properties";
+		mem->attr.mode = KFD_SYSFS_FILE_MODE;
+		sysfs_attr_init(&mem->attr);
+		ret = sysfs_create_file(mem->kobj, &mem->attr);
+		if (ret < 0)
+			return ret;
+		i++;
+	}
+
+	i = 0;
+	list_for_each_entry(cache, &dev->cache_props, list) {
+		cache->kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
+		if (!cache->kobj)
+			return -ENOMEM;
+		ret = kobject_init_and_add(cache->kobj, &cache_type,
+				dev->kobj_cache, "%d", i);
+		if (ret < 0)
+			return ret;
+
+		cache->attr.name = "properties";
+		cache->attr.mode = KFD_SYSFS_FILE_MODE;
+		sysfs_attr_init(&cache->attr);
+		ret = sysfs_create_file(cache->kobj, &cache->attr);
+		if (ret < 0)
+			return ret;
+		i++;
+	}
+
+	i = 0;
+	list_for_each_entry(iolink, &dev->io_link_props, list) {
+		iolink->kobj = kzalloc(sizeof(struct kobject), GFP_KERNEL);
+		if (!iolink->kobj)
+			return -ENOMEM;
+		ret = kobject_init_and_add(iolink->kobj, &iolink_type,
+				dev->kobj_iolink, "%d", i);
+		if (ret < 0)
+			return ret;
+
+		iolink->attr.name = "properties";
+		iolink->attr.mode = KFD_SYSFS_FILE_MODE;
+		sysfs_attr_init(&iolink->attr);
+		ret = sysfs_create_file(iolink->kobj, &iolink->attr);
+		if (ret < 0)
+			return ret;
+		i++;
+}
+
+	return 0;
+}
+
+static int kfd_build_sysfs_node_tree(void)
+{
+	struct kfd_topology_device *dev;
+	int ret;
+	uint32_t i = 0;
+
+	list_for_each_entry(dev, &topology_device_list, list) {
+		ret = kfd_build_sysfs_node_entry(dev, 0);
+		if (ret < 0)
+			return ret;
+		i++;
+	}
+
+	return 0;
+}
+
+static void kfd_remove_sysfs_node_tree(void)
+{
+	struct kfd_topology_device *dev;
+
+	list_for_each_entry(dev, &topology_device_list, list)
+		kfd_remove_sysfs_node_entry(dev);
+}
+
+static int kfd_topology_update_sysfs(void)
+{
+	int ret;
+
+	pr_info("Creating topology SYSFS entries\n");
+	if (sys_props.kobj_topology == 0) {
+		sys_props.kobj_topology = kfd_alloc_struct(sys_props.kobj_topology);
+		if (!sys_props.kobj_topology)
+			return -ENOMEM;
+
+		ret = kobject_init_and_add(sys_props.kobj_topology,
+				&sysprops_type,  &kfd_device->kobj,
+				"topology");
+		if (ret < 0)
+			return ret;
+
+		sys_props.kobj_nodes = kobject_create_and_add("nodes",
+				sys_props.kobj_topology);
+		if (!sys_props.kobj_nodes)
+			return -ENOMEM;
+
+		sys_props.attr_genid.name = "generation_id";
+		sys_props.attr_genid.mode = KFD_SYSFS_FILE_MODE;
+		sysfs_attr_init(&sys_props.attr_genid);
+		ret = sysfs_create_file(sys_props.kobj_topology,
+				&sys_props.attr_genid);
+		if (ret < 0)
+			return ret;
+
+		sys_props.attr_props.name = "system_properties";
+		sys_props.attr_props.mode = KFD_SYSFS_FILE_MODE;
+		sysfs_attr_init(&sys_props.attr_props);
+		ret = sysfs_create_file(sys_props.kobj_topology,
+				&sys_props.attr_props);
+		if (ret < 0)
+			return ret;
+	}
+
+	kfd_remove_sysfs_node_tree();
+
+	return kfd_build_sysfs_node_tree();
+}
+
+static void kfd_topology_release_sysfs(void)
+{
+	kfd_remove_sysfs_node_tree();
+	if (sys_props.kobj_topology) {
+		sysfs_remove_file(sys_props.kobj_topology,
+				&sys_props.attr_genid);
+		sysfs_remove_file(sys_props.kobj_topology,
+				&sys_props.attr_props);
+		if (sys_props.kobj_nodes) {
+			kobject_del(sys_props.kobj_nodes);
+			kobject_put(sys_props.kobj_nodes);
+			sys_props.kobj_nodes = 0;
+		}
+		kobject_del(sys_props.kobj_topology);
+		kobject_put(sys_props.kobj_topology);
+		sys_props.kobj_topology = 0;
+	}
+}
+
+int kfd_topology_init(void)
+{
+	void *crat_image = 0;
+	size_t image_size = 0;
+	int ret;
+
+	/*
+	 * Initialize the head for the topology device list
+	 */
+	INIT_LIST_HEAD(&topology_device_list);
+	init_rwsem(&topology_lock);
+	topology_crat_parsed = 0;
+
+	memset(&sys_props, 0, sizeof(sys_props));
+
+	/*
+	 * Get the CRAT image from the ACPI
+	 */
+	ret = kfd_topology_get_crat_acpi(crat_image, &image_size);
+	if (ret == 0 && image_size > 0) {
+		pr_info("Found CRAT image with size=%zd\n", image_size);
+		crat_image = kmalloc(image_size, GFP_KERNEL);
+		if (!crat_image) {
+			ret = -ENOMEM;
+			pr_err("No memory for allocating CRAT image\n");
+			goto err;
+		}
+		ret = kfd_topology_get_crat_acpi(crat_image, &image_size);
+
+		if (ret == 0) {
+			down_write(&topology_lock);
+			ret = kfd_parse_crat_table(crat_image);
+			if (ret == 0)
+				ret = kfd_topology_update_sysfs();
+			up_write(&topology_lock);
+		} else {
+			pr_err("Couldn't get CRAT table size from ACPI\n");
+		}
+		kfree(crat_image);
+	} else if (ret == -ENODATA) {
+		ret = 0;
+	} else {
+		pr_err("Couldn't get CRAT table size from ACPI\n");
+	}
+
+err:
+	pr_info("Finished initializing topology ret=%d\n", ret);
+	return ret;
+}
+
+void kfd_topology_shutdown(void)
+{
+	kfd_topology_release_sysfs();
+	kfd_release_live_view();
+}
+
+static void kfd_debug_print_topology(void)
+{
+	struct kfd_topology_device *dev;
+	uint32_t i = 0;
+
+	pr_info("DEBUG PRINT OF TOPOLOGY:");
+	list_for_each_entry(dev, &topology_device_list, list) {
+		pr_info("Node: %d\n", i);
+		pr_info("\tGPU assigned: %s\n", (dev->gpu ? "yes" : "no"));
+		pr_info("\tCPU count: %d\n", dev->node_props.cpu_cores_count);
+		pr_info("\tSIMD count: %d", dev->node_props.simd_count);
+		i++;
+	}
+}
+
+static uint32_t kfd_generate_gpu_id(struct kfd_dev *gpu)
+{
+	uint32_t hashout;
+	uint32_t buf[7];
+	int i;
+
+	if (!gpu)
+		return 0;
+
+	buf[0] = gpu->pdev->devfn;
+	buf[1] = gpu->pdev->subsystem_vendor;
+	buf[2] = gpu->pdev->subsystem_device;
+	buf[3] = gpu->pdev->device;
+	buf[4] = gpu->pdev->bus->number;
+	buf[5] = (uint32_t)(kfd2kgd->get_vmem_size(gpu->kgd) & 0xffffffff);
+	buf[6] = (uint32_t)(kfd2kgd->get_vmem_size(gpu->kgd) >> 32);
+
+	for (i = 0, hashout = 0; i < 7; i++)
+		hashout ^= hash_32(buf[i], KFD_GPU_ID_HASH_WIDTH);
+
+	return hashout;
+}
+
+static struct kfd_topology_device *kfd_assign_gpu(struct kfd_dev *gpu)
+{
+	struct kfd_topology_device *dev;
+	struct kfd_topology_device *out_dev = 0;
+
+	BUG_ON(!gpu);
+
+	list_for_each_entry(dev, &topology_device_list, list)
+		if (dev->gpu == 0 && dev->node_props.simd_count > 0) {
+			dev->gpu = gpu;
+			out_dev = dev;
+			break;
+		}
+
+	return out_dev;
+}
+
+static void kfd_notify_gpu_change(uint32_t gpu_id, int arrival)
+{
+	/*
+	 * TODO: Generate an event for thunk about the arrival/removal
+	 * of the GPU
+	 */
+}
+
+int kfd_topology_add_device(struct kfd_dev *gpu)
+{
+	uint32_t gpu_id;
+	struct kfd_topology_device *dev;
+	int res;
+
+	BUG_ON(!gpu);
+
+	gpu_id = kfd_generate_gpu_id(gpu);
+
+	pr_info("Adding new GPU (ID: 0x%x) to topology\n", gpu_id);
+
+	down_write(&topology_lock);
+	/*
+	 * Try to assign the GPU to existing topology device (generated from
+	 * CRAT table
+	 */
+	dev = kfd_assign_gpu(gpu);
+	if (!dev) {
+		pr_info("GPU was not found in the current topology. Extending.\n");
+		kfd_debug_print_topology();
+		dev = kfd_create_topology_device();
+		if (!dev) {
+			res = -ENOMEM;
+			goto err;
+		}
+		dev->gpu = gpu;
+
+		/*
+		 * TODO: Make a call to retrieve topology information from the
+		 * GPU vBIOS
+		 */
+
+		/*
+		 * Update the SYSFS tree, since we added another topology device
+		 */
+		if (kfd_topology_update_sysfs() < 0)
+			kfd_topology_release_sysfs();
+
+	}
+
+	dev->gpu_id = gpu_id;
+	gpu->id = gpu_id;
+	dev->node_props.vendor_id = gpu->pdev->vendor;
+	dev->node_props.device_id = gpu->pdev->device;
+	dev->node_props.location_id = (gpu->pdev->bus->number << 24) +
+			(gpu->pdev->devfn & 0xffffff);
+	/*
+	 * TODO: Retrieve max engine clock values from KGD
+	 */
+
+	res = 0;
+
+err:
+	up_write(&topology_lock);
+
+	if (res == 0)
+		kfd_notify_gpu_change(gpu_id, 1);
+
+	return res;
+}
+
+int kfd_topology_remove_device(struct kfd_dev *gpu)
+{
+	struct kfd_topology_device *dev;
+	uint32_t gpu_id;
+	int res = -ENODEV;
+
+	BUG_ON(!gpu);
+
+	down_write(&topology_lock);
+
+	list_for_each_entry(dev, &topology_device_list, list)
+		if (dev->gpu == gpu) {
+			gpu_id = dev->gpu_id;
+			kfd_remove_sysfs_node_entry(dev);
+			kfd_release_topology_device(dev);
+			res = 0;
+			if (kfd_topology_update_sysfs() < 0)
+				kfd_topology_release_sysfs();
+			break;
+		}
+
+	up_write(&topology_lock);
+
+	if (res == 0)
+		kfd_notify_gpu_change(gpu_id, 0);
+
+	return res;
+}
diff --git a/drivers/gpu/hsa/radeon/kfd_topology.h b/drivers/gpu/hsa/radeon/kfd_topology.h
new file mode 100644
index 0000000..989624b
--- /dev/null
+++ b/drivers/gpu/hsa/radeon/kfd_topology.h
@@ -0,0 +1,168 @@
+/*
+ * Copyright 2014 Advanced Micro Devices, Inc.
+ *
+ * Permission is hereby granted, free of charge, to any person obtaining a
+ * copy of this software and associated documentation files (the "Software"),
+ * to deal in the Software without restriction, including without limitation
+ * the rights to use, copy, modify, merge, publish, distribute, sublicense,
+ * and/or sell copies of the Software, and to permit persons to whom the
+ * Software is furnished to do so, subject to the following conditions:
+ *
+ * The above copyright notice and this permission notice shall be included in
+ * all copies or substantial portions of the Software.
+ *
+ * THE SOFTWARE IS PROVIDED "AS IS", WITHOUT WARRANTY OF ANY KIND, EXPRESS OR
+ * IMPLIED, INCLUDING BUT NOT LIMITED TO THE WARRANTIES OF MERCHANTABILITY,
+ * FITNESS FOR A PARTICULAR PURPOSE AND NONINFRINGEMENT.  IN NO EVENT SHALL
+ * THE COPYRIGHT HOLDER(S) OR AUTHOR(S) BE LIABLE FOR ANY CLAIM, DAMAGES OR
+ * OTHER LIABILITY, WHETHER IN AN ACTION OF CONTRACT, TORT OR OTHERWISE,
+ * ARISING FROM, OUT OF OR IN CONNECTION WITH THE SOFTWARE OR THE USE OR
+ * OTHER DEALINGS IN THE SOFTWARE.
+ */
+
+#ifndef __KFD_TOPOLOGY_H__
+#define __KFD_TOPOLOGY_H__
+
+#include <linux/types.h>
+#include <linux/list.h>
+#include "kfd_priv.h"
+
+#define KFD_TOPOLOGY_PUBLIC_NAME_SIZE 128
+
+#define HSA_CAP_HOT_PLUGGABLE			0x00000001
+#define HSA_CAP_ATS_PRESENT			0x00000002
+#define HSA_CAP_SHARED_WITH_GRAPHICS		0x00000004
+#define HSA_CAP_QUEUE_SIZE_POW2			0x00000008
+#define HSA_CAP_QUEUE_SIZE_32BIT		0x00000010
+#define HSA_CAP_QUEUE_IDLE_EVENT		0x00000020
+#define HSA_CAP_VA_LIMIT			0x00000040
+#define HSA_CAP_WATCH_POINTS_SUPPORTED		0x00000080
+#define HSA_CAP_WATCH_POINTS_TOTALBITS_MASK	0x00000f00
+#define HSA_CAP_WATCH_POINTS_TOTALBITS_SHIFT	8
+#define HSA_CAP_RESERVED			0xfffff000
+
+struct kfd_node_properties {
+	uint32_t cpu_cores_count;
+	uint32_t simd_count;
+	uint32_t mem_banks_count;
+	uint32_t caches_count;
+	uint32_t io_links_count;
+	uint32_t cpu_core_id_base;
+	uint32_t simd_id_base;
+	uint32_t capability;
+	uint32_t max_waves_per_simd;
+	uint32_t lds_size_in_kb;
+	uint32_t gds_size_in_kb;
+	uint32_t wave_front_size;
+	uint32_t array_count;
+	uint32_t simd_arrays_per_engine;
+	uint32_t cu_per_simd_array;
+	uint32_t simd_per_cu;
+	uint32_t max_slots_scratch_cu;
+	uint32_t engine_id;
+	uint32_t vendor_id;
+	uint32_t device_id;
+	uint32_t location_id;
+	uint32_t max_engine_clk_fcompute;
+	uint32_t max_engine_clk_ccompute;
+	uint16_t marketing_name[KFD_TOPOLOGY_PUBLIC_NAME_SIZE];
+};
+
+#define HSA_MEM_HEAP_TYPE_SYSTEM	0
+#define HSA_MEM_HEAP_TYPE_FB_PUBLIC	1
+#define HSA_MEM_HEAP_TYPE_FB_PRIVATE	2
+#define HSA_MEM_HEAP_TYPE_GPU_GDS	3
+#define HSA_MEM_HEAP_TYPE_GPU_LDS	4
+#define HSA_MEM_HEAP_TYPE_GPU_SCRATCH	5
+
+#define HSA_MEM_FLAGS_HOT_PLUGGABLE	0x00000001
+#define HSA_MEM_FLAGS_NON_VOLATILE	0x00000002
+#define HSA_MEM_FLAGS_RESERVED		0xfffffffc
+
+struct kfd_mem_properties {
+	struct list_head	list;
+	uint32_t		heap_type;
+	uint64_t		size_in_bytes;
+	uint32_t		flags;
+	uint32_t		width;
+	uint32_t		mem_clk_max;
+	struct kobject		*kobj;
+	struct attribute	attr;
+};
+
+#define KFD_TOPOLOGY_CPU_SIBLINGS 256
+
+#define HSA_CACHE_TYPE_DATA		0x00000001
+#define HSA_CACHE_TYPE_INSTRUCTION	0x00000002
+#define HSA_CACHE_TYPE_CPU		0x00000004
+#define HSA_CACHE_TYPE_HSACU		0x00000008
+#define HSA_CACHE_TYPE_RESERVED		0xfffffff0
+
+struct kfd_cache_properties {
+	struct list_head	list;
+	uint32_t		processor_id_low;
+	uint32_t		cache_level;
+	uint32_t		cache_size;
+	uint32_t		cacheline_size;
+	uint32_t		cachelines_per_tag;
+	uint32_t		cache_assoc;
+	uint32_t		cache_latency;
+	uint32_t		cache_type;
+	uint8_t			sibling_map[KFD_TOPOLOGY_CPU_SIBLINGS];
+	struct kobject		*kobj;
+	struct attribute	attr;
+};
+
+struct kfd_iolink_properties {
+	struct list_head	list;
+	uint32_t		iolink_type;
+	uint32_t		ver_maj;
+	uint32_t		ver_min;
+	uint32_t		node_from;
+	uint32_t		node_to;
+	uint32_t		weight;
+	uint32_t		min_latency;
+	uint32_t		max_latency;
+	uint32_t		min_bandwidth;
+	uint32_t		max_bandwidth;
+	uint32_t		rec_transfer_size;
+	uint32_t		flags;
+	struct kobject		*kobj;
+	struct attribute	attr;
+};
+
+struct kfd_topology_device {
+	struct list_head		list;
+	uint32_t			gpu_id;
+	struct kfd_node_properties	node_props;
+	uint32_t			mem_bank_count;
+	struct list_head		mem_props;
+	uint32_t			cache_count;
+	struct list_head		cache_props;
+	uint32_t			io_link_count;
+	struct list_head		io_link_props;
+	struct kfd_dev			*gpu;
+	struct kobject			*kobj_node;
+	struct kobject			*kobj_mem;
+	struct kobject			*kobj_cache;
+	struct kobject			*kobj_iolink;
+	struct attribute		attr_gpuid;
+	struct attribute		attr_name;
+	struct attribute		attr_props;
+};
+
+struct kfd_system_properties {
+	uint32_t		num_devices;     /* Number of H-NUMA nodes */
+	uint32_t		generation_count;
+	uint64_t		platform_oem;
+	uint64_t		platform_id;
+	uint64_t		platform_rev;
+	struct kobject		*kobj_topology;
+	struct kobject		*kobj_nodes;
+	struct attribute	attr_genid;
+	struct attribute	attr_props;
+};
+
+
+
+#endif /* __KFD_TOPOLOGY_H__ */
-- 
1.9.1

