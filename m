Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752418AbaI3Kg3 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 06:36:29 -0400
Received: from ozlabs.org ([103.22.144.67]:48128 "EHLO ozlabs.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752089AbaI3Kfx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 06:35:53 -0400
From: Michael Neuling <mikey@neuling.org>
To: greg@kroah.com, arnd@arndb.de, mpe@ellerman.id.au,
        benh@kernel.crashing.org
Cc: mikey@neuling.org, anton@samba.org, linux-kernel@vger.kernel.org,
        linuxppc-dev@ozlabs.org, jk@ozlabs.org, imunsie@au.ibm.com,
        cbe-oss-dev@lists.ozlabs.org,
        "Aneesh Kumar K.V" <aneesh.kumar@linux.vnet.ibm.com>
Subject: [PATCH v2 14/17] cxl: Driver code for powernv PCIe based cards for userspace access
Date: Tue, 30 Sep 2014 20:35:03 +1000
Message-Id: <1412073306-13812-15-git-send-email-mikey@neuling.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412073306-13812-1-git-send-email-mikey@neuling.org>
References: <1412073306-13812-1-git-send-email-mikey@neuling.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Ian Munsie <imunsie@au1.ibm.com>

This is the core of the cxl driver.

It adds support for using cxl cards in the powernv environment only (no guest
support).  It allows access to cxl accelerators by userspace using
/dev/cxl/afu0.0 char device.

The kernel driver has no knowledge of the acceleration function.  It only
provides services to userspace via the /dev/cxl/afu0.0 device.

This will compile to two modules.  cxl.ko provides the core cxl functionality
and userspace API.  cxl-pci.ko provides the PCI driver driver functionality the
powernv environment.

Documentation of the cxl hardware architecture and userspace API is provided in
subsequent patches.

Signed-off-by: Ian Munsie <imunsie@au1.ibm.com>
Signed-off-by: Michael Neuling <mikey@neuling.org>
---
 drivers/misc/cxl/context.c | 171 ++++++++
 drivers/misc/cxl/cxl-pci.c | 964 +++++++++++++++++++++++++++++++++++++++++++++
 drivers/misc/cxl/cxl.h     | 605 ++++++++++++++++++++++++++++
 drivers/misc/cxl/debugfs.c | 116 ++++++
 drivers/misc/cxl/fault.c   | 298 ++++++++++++++
 drivers/misc/cxl/file.c    | 503 +++++++++++++++++++++++
 drivers/misc/cxl/irq.c     | 405 +++++++++++++++++++
 drivers/misc/cxl/main.c    | 238 +++++++++++
 drivers/misc/cxl/native.c  | 649 ++++++++++++++++++++++++++++++
 drivers/misc/cxl/sysfs.c   | 348 ++++++++++++++++
 10 files changed, 4297 insertions(+)
 create mode 100644 drivers/misc/cxl/context.c
 create mode 100644 drivers/misc/cxl/cxl-pci.c
 create mode 100644 drivers/misc/cxl/cxl.h
 create mode 100644 drivers/misc/cxl/debugfs.c
 create mode 100644 drivers/misc/cxl/fault.c
 create mode 100644 drivers/misc/cxl/file.c
 create mode 100644 drivers/misc/cxl/irq.c
 create mode 100644 drivers/misc/cxl/main.c
 create mode 100644 drivers/misc/cxl/native.c
 create mode 100644 drivers/misc/cxl/sysfs.c

diff --git a/drivers/misc/cxl/context.c b/drivers/misc/cxl/context.c
new file mode 100644
index 0000000..9206ca4
--- /dev/null
+++ b/drivers/misc/cxl/context.c
@@ -0,0 +1,171 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/bitmap.h>
+#include <linux/sched.h>
+#include <linux/pid.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/debugfs.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <asm/cputable.h>
+#include <asm/current.h>
+#include <asm/copro.h>
+
+#include "cxl.h"
+
+/*
+ * Allocates space for a CXL context.
+ */
+struct cxl_context_t *cxl_context_alloc(void)
+{
+	return kzalloc(sizeof(struct cxl_context_t), GFP_KERNEL);
+}
+
+/*
+ * Initialises a CXL context.
+ */
+int cxl_context_init(struct cxl_context_t *ctx, struct cxl_afu_t *afu, bool master)
+{
+	int i;
+
+	spin_lock_init(&ctx->sst_lock);
+	ctx->sstp = NULL;
+	ctx->afu = afu;
+	ctx->master = master;
+	ctx->pid = get_pid(get_task_pid(current, PIDTYPE_PID));
+
+	INIT_WORK(&ctx->fault_work, cxl_handle_fault);
+
+	init_waitqueue_head(&ctx->wq);
+	spin_lock_init(&ctx->lock);
+
+	ctx->irq_bitmap = NULL;
+	ctx->pending_irq = false;
+	ctx->pending_fault = false;
+	ctx->pending_afu_err = false;
+
+	ctx->status = OPENED;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&afu->contexts_lock);
+	i = idr_alloc(&ctx->afu->contexts_idr, ctx, 0,
+		      ctx->afu->num_procs, GFP_NOWAIT);
+	spin_unlock(&afu->contexts_lock);
+	idr_preload_end();
+	if (i < 0)
+		return i;
+
+	ctx->ph = i;
+	ctx->elem = &ctx->afu->spa[i];
+	ctx->pe_inserted = false;
+	return 0;
+}
+
+/*
+ * Map a per-context mmio space into the given vma.
+ */
+int cxl_context_iomap(struct cxl_context_t *ctx, struct vm_area_struct *vma)
+{
+	u64 len = vma->vm_end - vma->vm_start;
+	len = min(len, ctx->psn_size);
+
+	if (ctx->afu->current_model == CXL_MODEL_DEDICATED) {
+		vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+		return vm_iomap_memory(vma, ctx->afu->psn_phys, ctx->afu->adapter->ps_size);
+	}
+
+	/* make sure there is a valid per process space for this AFU */
+	if ((ctx->master && !ctx->afu->psa) || (!ctx->afu->pp_psa)) {
+		pr_devel("AFU doesn't support mmio space\n");
+		return -EINVAL;
+	}
+
+	/* Can't mmap until the AFU is enabled */
+	if (!ctx->afu->enabled)
+		return -EBUSY;
+
+	pr_devel("%s: mmio physical: %llx pe: %i master:%i\n", __func__,
+		 ctx->psn_phys, ctx->ph , ctx->master);
+
+	vma->vm_page_prot = pgprot_noncached(vma->vm_page_prot);
+	return vm_iomap_memory(vma, ctx->psn_phys, len);
+}
+
+/*
+ * Detach a context from the hardware. This disables interrupts and doesn't
+ * return until all outstanding interrupts for this context have completed. The
+ * hardware should no longer access *ctx after this has returned.
+ */
+static void __detach_context(struct cxl_context_t *ctx)
+{
+	unsigned long flags;
+	enum cxl_context_status status;
+
+	spin_lock_irqsave(&ctx->sst_lock, flags);
+	status = ctx->status;
+	ctx->status = CLOSED;
+	spin_unlock_irqrestore(&ctx->sst_lock, flags);
+	if (status != STARTED)
+		return;
+
+	WARN_ON(cxl_ops->detach_process(ctx));
+	afu_release_irqs(ctx);
+	flush_work(&ctx->fault_work); /* Only needed for dedicated process */
+	wake_up_all(&ctx->wq);
+}
+
+/*
+ * Detach the given context from the AFU. This doesn't actually
+ * free the context but it should stop the context running in hardware
+ * (ie. prevent this context from generating any further interrupts
+ * so that it can be freed).
+ */
+void cxl_context_detach(struct cxl_context_t *ctx)
+{
+	__detach_context(ctx);
+}
+
+/*
+ * Detach all contexts on the given AFU.
+ */
+void cxl_context_detach_all(struct cxl_afu_t *afu)
+{
+	struct cxl_context_t *ctx;
+	int tmp;
+
+	rcu_read_lock();
+	idr_for_each_entry(&afu->contexts_idr, ctx, tmp)
+		__detach_context(ctx);
+	rcu_read_unlock();
+}
+EXPORT_SYMBOL(cxl_context_detach_all);
+
+void cxl_context_free(struct cxl_context_t *ctx)
+{
+	unsigned long flags;
+
+	spin_lock(&ctx->afu->contexts_lock);
+	idr_remove(&ctx->afu->contexts_idr, ctx->ph);
+	spin_unlock(&ctx->afu->contexts_lock);
+	synchronize_rcu();
+
+	spin_lock_irqsave(&ctx->sst_lock, flags);
+	free_page((u64)ctx->sstp);
+	ctx->sstp = NULL;
+	spin_unlock_irqrestore(&ctx->sst_lock, flags);
+
+	put_pid(ctx->pid);
+	kfree(ctx);
+}
diff --git a/drivers/misc/cxl/cxl-pci.c b/drivers/misc/cxl/cxl-pci.c
new file mode 100644
index 0000000..402ab00
--- /dev/null
+++ b/drivers/misc/cxl/cxl-pci.c
@@ -0,0 +1,964 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+
+#include <linux/pci_regs.h>
+#include <linux/pci_ids.h>
+#include <linux/device.h>
+#include <linux/module.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+#include <linux/sort.h>
+#include <linux/pci.h>
+#include <linux/of.h>
+#include <linux/delay.h>
+#include <asm/opal.h>
+#include <asm/msi_bitmap.h>
+#include <asm/pci-bridge.h> /* for struct pci_controller */
+#include <asm/pnv-pci.h>
+
+#include "cxl.h"
+
+
+#define CXL_PCI_VSEC_ID	0x1280
+#define CXL_VSEC_MIN_SIZE 0x80
+
+#define CXL_READ_VSEC_LENGTH(dev, vsec, dest)			\
+	{							\
+		pci_read_config_word(dev, vsec + 0x6, dest);	\
+		*dest >>= 4;					\
+	}
+#define CXL_READ_VSEC_NAFUS(dev, vsec, dest) \
+	pci_read_config_byte(dev, vsec + 0x8, dest)
+
+#define CXL_READ_VSEC_STATUS(dev, vsec, dest) \
+	pci_read_config_byte(dev, vsec + 0x9, dest)
+#define CXL_STATUS_SECOND_PORT  0x80
+#define CXL_STATUS_MSI_X_FULL   0x40
+#define CXL_STATUS_MSI_X_SINGLE 0x20
+#define CXL_STATUS_FLASH_RW     0x08
+#define CXL_STATUS_FLASH_RO     0x04
+#define CXL_STATUS_LOADABLE_AFU 0x02
+#define CXL_STATUS_LOADABLE_PSL 0x01
+/* If we see these features we won't try to use the card */
+#define CXL_UNSUPPORTED_FEATURES \
+	(CXL_STATUS_MSI_X_FULL | CXL_STATUS_MSI_X_SINGLE)
+
+#define CXL_READ_VSEC_MODE_CONTROL(dev, vsec, dest) \
+	pci_read_config_byte(dev, vsec + 0xa, dest)
+#define CXL_WRITE_VSEC_MODE_CONTROL(dev, vsec, val) \
+	pci_write_config_byte(dev, vsec + 0xa, val)
+#define CXL_VSEC_PROTOCOL_MASK   0xe0
+#define CXL_VSEC_PROTOCOL_256TB  0x80 /* Power 8 uses this */
+#define CXL_VSEC_PROTOCOL_512TB  0x40
+#define CXL_VSEC_PROTOCOL_1024TB 0x20
+#define CXL_VSEC_PROTOCOL_ENABLE 0x01
+
+#define CXL_READ_VSEC_PSL_REVISION(dev, vsec, dest) \
+	pci_read_config_word(dev, vsec + 0xc, dest)
+#define CXL_READ_VSEC_CAIA_MINOR(dev, vsec, dest) \
+	pci_read_config_byte(dev, vsec + 0xe, dest)
+#define CXL_READ_VSEC_CAIA_MAJOR(dev, vsec, dest) \
+	pci_read_config_byte(dev, vsec + 0xf, dest)
+#define CXL_READ_VSEC_BASE_IMAGE(dev, vsec, dest) \
+	pci_read_config_word(dev, vsec + 0x10, dest)
+
+#define CXL_READ_VSEC_IMAGE_STATE(dev, vsec, dest) \
+	pci_read_config_byte(dev, vsec + 0x13, dest)
+#define CXL_WRITE_VSEC_IMAGE_STATE(dev, vsec, val) \
+	pci_write_config_byte(dev, vsec + 0x13, val)
+#define CXL_VSEC_USER_IMAGE_LOADED 0x80 /* RO */
+#define CXL_VSEC_PERST_LOADS_IMAGE 0x20 /* RW */
+#define CXL_VSEC_PERST_SELECT_USER 0x10 /* RW */
+
+#define CXL_READ_VSEC_AFU_DESC_OFF(dev, vsec, dest) \
+	pci_read_config_dword(dev, vsec + 0x20, dest)
+#define CXL_READ_VSEC_AFU_DESC_SIZE(dev, vsec, dest) \
+	pci_read_config_dword(dev, vsec + 0x24, dest)
+#define CXL_READ_VSEC_PS_OFF(dev, vsec, dest) \
+	pci_read_config_dword(dev, vsec + 0x28, dest)
+#define CXL_READ_VSEC_PS_SIZE(dev, vsec, dest) \
+	pci_read_config_dword(dev, vsec + 0x2c, dest)
+
+
+/* This works a little different than the p1/p2 register accesses to make it
+ * easier to pull out individual fields */
+#define AFUD_READ(afu, off)		_cxl_reg_read(afu->afu_desc_mmio + off)
+#define EXTRACT_PPC_BIT(val, bit)	(!!(val & PPC_BIT(bit)))
+#define EXTRACT_PPC_BITS(val, bs, be)	((val & PPC_BITMASK(bs, be)) >> PPC_BITLSHIFT(be))
+
+#define AFUD_READ_INFO(afu)		AFUD_READ(afu, 0x0)
+#define   AFUD_NUM_INTS_PER_PROC(val)	EXTRACT_PPC_BITS(val,  0, 15)
+#define   AFUD_NUM_PROCS(val)		EXTRACT_PPC_BITS(val, 16, 31)
+#define   AFUD_NUM_CRS(val)		EXTRACT_PPC_BITS(val, 32, 47)
+#define   AFUD_MULTIMODEL(val)		EXTRACT_PPC_BIT(val, 48)
+#define   AFUD_PUSH_BLOCK_TRANSFER(val)	EXTRACT_PPC_BIT(val, 55)
+#define   AFUD_DEDICATED_PROCESS(val)	EXTRACT_PPC_BIT(val, 59)
+#define   AFUD_AFU_DIRECTED(val)	EXTRACT_PPC_BIT(val, 61)
+#define   AFUD_TIME_SLICED(val)		EXTRACT_PPC_BIT(val, 63)
+#define AFUD_READ_CR(afu)		AFUD_READ(afu, 0x20)
+#define   AFUD_CR_LEN(val)		EXTRACT_PPC_BITS(val, 8, 63)
+#define AFUD_READ_CR_OFF(afu)		AFUD_READ(afu, 0x28)
+#define AFUD_READ_PPPSA(afu)		AFUD_READ(afu, 0x30)
+#define   AFUD_PPPSA_PP(val)		EXTRACT_PPC_BIT(val, 6)
+#define   AFUD_PPPSA_PSA(val)		EXTRACT_PPC_BIT(val, 7)
+#define   AFUD_PPPSA_LEN(val)		EXTRACT_PPC_BITS(val, 8, 63)
+#define AFUD_READ_PPPSA_OFF(afu)	AFUD_READ(afu, 0x38)
+#define AFUD_READ_EB(afu)		AFUD_READ(afu, 0x40)
+#define   AFUD_EB_LEN(val)		EXTRACT_PPC_BITS(val, 8, 63)
+#define AFUD_READ_EB_OFF(afu)		AFUD_READ(afu, 0x48)
+
+static DEFINE_PCI_DEVICE_TABLE(cxl_pci_tbl) = {
+	{ PCI_DEVICE(PCI_VENDOR_ID_IBM, 0x0477), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_IBM, 0x044b), },
+	{ PCI_DEVICE(PCI_VENDOR_ID_IBM, 0x04cf), },
+	{ PCI_DEVICE_CLASS(0x120000, ~0), },
+
+	{ }
+};
+MODULE_DEVICE_TABLE(pci, cxl_pci_tbl);
+
+
+/* Mostly using these wrappers to avoid confusion:
+ * priv 1 is BAR2, while priv 2 is BAR0 */
+static inline resource_size_t p1_base(struct pci_dev *dev)
+{
+	return pci_resource_start(dev, 2);
+}
+
+static inline resource_size_t p1_size(struct pci_dev *dev)
+{
+	return pci_resource_len(dev, 2);
+}
+
+static inline resource_size_t p2_base(struct pci_dev *dev)
+{
+	return pci_resource_start(dev, 0);
+}
+
+static inline resource_size_t p2_size(struct pci_dev *dev)
+{
+	return pci_resource_len(dev, 0);
+}
+
+static int find_cxl_vsec(struct pci_dev *dev)
+{
+	int vsec = 0;
+	u16 val;
+
+	while ((vsec = pci_find_next_ext_capability(dev, vsec, PCI_EXT_CAP_ID_VNDR))) {
+		pci_read_config_word(dev, vsec + 0x4, &val);
+		if (val == CXL_PCI_VSEC_ID)
+			return vsec;
+	}
+	return 0;
+
+}
+
+static void dump_cxl_config_space(struct pci_dev *dev)
+{
+	int vsec;
+	u32 val;
+
+	dev_info(&dev->dev, "dump_cxl_config_space\n");
+
+	pci_read_config_dword(dev, PCI_BASE_ADDRESS_0, &val);
+	dev_info(&dev->dev, "BAR0: %#.8x\n", val);
+	pci_read_config_dword(dev, PCI_BASE_ADDRESS_1, &val);
+	dev_info(&dev->dev, "BAR1: %#.8x\n", val);
+	pci_read_config_dword(dev, PCI_BASE_ADDRESS_2, &val);
+	dev_info(&dev->dev, "BAR2: %#.8x\n", val);
+	pci_read_config_dword(dev, PCI_BASE_ADDRESS_3, &val);
+	dev_info(&dev->dev, "BAR3: %#.8x\n", val);
+	pci_read_config_dword(dev, PCI_BASE_ADDRESS_4, &val);
+	dev_info(&dev->dev, "BAR4: %#.8x\n", val);
+	pci_read_config_dword(dev, PCI_BASE_ADDRESS_5, &val);
+	dev_info(&dev->dev, "BAR5: %#.8x\n", val);
+
+	dev_info(&dev->dev, "p1 regs: %#llx, len: %#llx\n",
+		p1_base(dev), p1_size(dev));
+	dev_info(&dev->dev, "p2 regs: %#llx, len: %#llx\n",
+		p1_base(dev), p2_size(dev));
+	dev_info(&dev->dev, "BAR 4/5: %#llx, len: %#llx\n",
+		pci_resource_start(dev, 4), pci_resource_len(dev, 4));
+
+	if (!(vsec = find_cxl_vsec(dev)))
+		return;
+
+#define show_reg(name, what) \
+	dev_info(&dev->dev, "cxl vsec: %30s: %#x\n", name, what)
+
+	pci_read_config_dword(dev, vsec + 0x0, &val);
+	show_reg("Cap ID", (val >> 0) & 0xffff);
+	show_reg("Cap Ver", (val >> 16) & 0xf);
+	show_reg("Next Cap Ptr", (val >> 20) & 0xfff);
+	pci_read_config_dword(dev, vsec + 0x4, &val);
+	show_reg("VSEC ID", (val >> 0) & 0xffff);
+	show_reg("VSEC Rev", (val >> 16) & 0xf);
+	show_reg("VSEC Length",	(val >> 20) & 0xfff);
+	pci_read_config_dword(dev, vsec + 0x8, &val);
+	show_reg("Num AFUs", (val >> 0) & 0xff);
+	show_reg("Status", (val >> 8) & 0xff);
+	show_reg("Mode Control", (val >> 16) & 0xff);
+	show_reg("Reserved", (val >> 24) & 0xff);
+	pci_read_config_dword(dev, vsec + 0xc, &val);
+	show_reg("PSL Rev", (val >> 0) & 0xffff);
+	show_reg("CAIA Ver", (val >> 16) & 0xffff);
+	pci_read_config_dword(dev, vsec + 0x10, &val);
+	show_reg("Base Image Rev", (val >> 0) & 0xffff);
+	show_reg("Reserved", (val >> 16) & 0x0fff);
+	show_reg("Image Control", (val >> 28) & 0x3);
+	show_reg("Reserved", (val >> 30) & 0x1);
+	show_reg("Image Loaded", (val >> 31) & 0x1);
+
+	pci_read_config_dword(dev, vsec + 0x14, &val);
+	show_reg("Reserved", val);
+	pci_read_config_dword(dev, vsec + 0x18, &val);
+	show_reg("Reserved", val);
+	pci_read_config_dword(dev, vsec + 0x1c, &val);
+	show_reg("Reserved", val);
+
+	pci_read_config_dword(dev, vsec + 0x20, &val);
+	show_reg("AFU Descriptor Offset", val);
+	pci_read_config_dword(dev, vsec + 0x24, &val);
+	show_reg("AFU Descriptor Size", val);
+	pci_read_config_dword(dev, vsec + 0x28, &val);
+	show_reg("Problem State Offset", val);
+	pci_read_config_dword(dev, vsec + 0x2c, &val);
+	show_reg("Problem State Size", val);
+
+	pci_read_config_dword(dev, vsec + 0x30, &val);
+	show_reg("Reserved", val);
+	pci_read_config_dword(dev, vsec + 0x34, &val);
+	show_reg("Reserved", val);
+	pci_read_config_dword(dev, vsec + 0x38, &val);
+	show_reg("Reserved", val);
+	pci_read_config_dword(dev, vsec + 0x3c, &val);
+	show_reg("Reserved", val);
+
+	pci_read_config_dword(dev, vsec + 0x40, &val);
+	show_reg("PSL Programming Port", val);
+	pci_read_config_dword(dev, vsec + 0x44, &val);
+	show_reg("PSL Programming Control", val);
+
+	pci_read_config_dword(dev, vsec + 0x48, &val);
+	show_reg("Reserved", val);
+	pci_read_config_dword(dev, vsec + 0x4c, &val);
+	show_reg("Reserved", val);
+
+	pci_read_config_dword(dev, vsec + 0x50, &val);
+	show_reg("Flash Address Register", val);
+	pci_read_config_dword(dev, vsec + 0x54, &val);
+	show_reg("Flash Size Register", val);
+	pci_read_config_dword(dev, vsec + 0x58, &val);
+	show_reg("Flash Status/Control Register", val);
+	pci_read_config_dword(dev, vsec + 0x58, &val);
+	show_reg("Flash Data Port", val);
+
+#undef show_reg
+}
+
+static void dump_afu_descriptor(struct cxl_afu_t *afu)
+{
+	u64 val;
+
+#define show_reg(name, what) \
+	dev_info(&afu->dev, "afu desc: %30s: %#llx\n", name, what)
+
+	val = AFUD_READ_INFO(afu);
+	show_reg("num_ints_per_process", AFUD_NUM_INTS_PER_PROC(val));
+	show_reg("num_of_processes", AFUD_NUM_PROCS(val));
+	show_reg("num_of_afu_CRs", AFUD_NUM_CRS(val));
+	show_reg("req_prog_model", val & 0xffffULL);
+
+	val = AFUD_READ(afu, 0x8);
+	show_reg("Reserved", val);
+	val = AFUD_READ(afu, 0x10);
+	show_reg("Reserved", val);
+	val = AFUD_READ(afu, 0x18);
+	show_reg("Reserved", val);
+
+	val = AFUD_READ_CR(afu);
+	show_reg("Reserved", (val >> (63-7)) & 0xff);
+	show_reg("AFU_CR_len", AFUD_CR_LEN(val));
+
+	val = AFUD_READ_CR_OFF(afu);
+	show_reg("AFU_CR_offset", val);
+
+	val = AFUD_READ_PPPSA(afu);
+	show_reg("PerProcessPSA_control", (val >> (63-7)) & 0xff);
+	show_reg("PerProcessPSA Length", AFUD_PPPSA_LEN(val));
+
+	val = AFUD_READ_PPPSA_OFF(afu);
+	show_reg("PerProcessPSA_offset", val);
+
+	val = AFUD_READ_EB(afu);
+	show_reg("Reserved", (val >> (63-7)) & 0xff);
+	show_reg("AFU_EB_len", AFUD_EB_LEN(val));
+
+	val = AFUD_READ_EB_OFF(afu);
+	show_reg("AFU_EB_offset", val);
+
+#undef show_reg
+}
+
+extern struct device_node *pnv_pci_to_phb_node(struct pci_dev *dev);
+
+static int init_implementation_adapter_regs(struct cxl_t *adapter, struct pci_dev *dev)
+{
+	struct device_node *np;
+	const __be32 *prop;
+	u64 psl_dsnctl;
+	u64 chipid;
+
+	if (!(np = pnv_pci_to_phb_node(dev)))
+		return -ENODEV;
+
+	while (np && !(prop = of_get_property(np, "ibm,chip-id", NULL)))
+		np = of_get_next_parent(np);
+	if (!np)
+		return -ENODEV;
+	chipid = be32_to_cpup(prop);
+	of_node_put(np);
+
+	/* Tell PSL where to route data to */
+	psl_dsnctl = 0x02E8900002000000ULL | (chipid << (63-5));
+	cxl_p1_write(adapter, CXL_PSL_DSNDCTL, psl_dsnctl);
+	cxl_p1_write(adapter, CXL_PSL_RESLCKTO, 0x20000000200ULL);
+	/* snoop write mask */
+	cxl_p1_write(adapter, CXL_PSL_SNWRALLOC, 0x00000000FFFFFFFFULL);
+	/* set fir_accum */
+	cxl_p1_write(adapter, CXL_PSL_FIR_CNTL, 0x0800000000000000ULL);
+	/* for debugging with trace arrays */
+	cxl_p1_write(adapter, CXL_PSL_TRACE, 0x0000FF7C00000000ULL);
+
+	return 0;
+}
+
+static int init_implementation_afu_regs(struct cxl_afu_t *afu)
+{
+	/* read/write masks for this slice */
+	cxl_p1n_write(afu, CXL_PSL_APCALLOC_A, 0xFFFFFFFEFEFEFEFEULL);
+	/* APC read/write masks for this slice */
+	cxl_p1n_write(afu, CXL_PSL_COALLOC_A, 0xFF000000FEFEFEFEULL);
+	/* for debugging with trace arrays */
+	cxl_p1n_write(afu, CXL_PSL_SLICE_TRACE, 0x0000FFFF00000000ULL);
+	cxl_p1n_write(afu, CXL_PSL_RXCTL_A, 0xF000000000000000ULL);
+
+	return 0;
+}
+
+static int setup_cxl_msi(struct cxl_t *adapter, unsigned int hwirq,
+			 unsigned int virq)
+{
+	struct pci_dev *dev = to_pci_dev(adapter->dev.parent);
+
+	return pnv_cxl_ioda_msi_setup(dev, hwirq, virq);
+}
+
+static int alloc_one_hwirq(struct cxl_t *adapter)
+{
+	struct pci_dev *dev = to_pci_dev(adapter->dev.parent);
+
+	return pnv_cxl_alloc_hwirqs(dev, 1);
+}
+
+static void release_one_hwirq(struct cxl_t *adapter, int hwirq)
+{
+	struct pci_dev *dev = to_pci_dev(adapter->dev.parent);
+
+	return pnv_cxl_release_hwirqs(dev, hwirq, 1);
+}
+
+static int alloc_hwirq_ranges(struct cxl_irq_ranges *irqs, struct cxl_t *adapter, unsigned int num)
+{
+	struct pci_dev *dev = to_pci_dev(adapter->dev.parent);
+
+	return pnv_cxl_alloc_hwirq_ranges(irqs, dev, num);
+}
+
+static void release_hwirq_ranges(struct cxl_irq_ranges *irqs, struct cxl_t *adapter)
+{
+	struct pci_dev *dev = to_pci_dev(adapter->dev.parent);
+
+	pnv_cxl_release_hwirq_ranges(irqs, dev);
+
+}
+
+
+static struct cxl_driver_ops cxl_pci_driver_ops = {
+	.module = THIS_MODULE,
+	.alloc_one_irq = alloc_one_hwirq,
+	.release_one_irq = release_one_hwirq,
+	.alloc_irq_ranges = alloc_hwirq_ranges,
+	.release_irq_ranges = release_hwirq_ranges,
+	.setup_irq = setup_cxl_msi,
+};
+
+static int setup_cxl_bars(struct pci_dev *dev)
+{
+	/* Safety check in case we get backported to < 3.17 without M64 */
+	if ((p1_base(dev) < 0x100000000ULL) ||
+	    (p2_base(dev) < 0x100000000ULL)) {
+		dev_err(&dev->dev, "ABORTING: M32 BAR assignment incompatible with CXL\n");
+		return -ENODEV;
+	}
+
+	/* BAR 4/5 has a special meaning for CXL and must be programmed with a
+	 * special value corresponding to the CXL protocol address range.
+	 * For POWER 8 that means bits 48:49 must be set to 10 */
+	pci_write_config_dword(dev, PCI_BASE_ADDRESS_4, 0x00000000);
+	pci_write_config_dword(dev, PCI_BASE_ADDRESS_5, 0x00020000);
+
+	return 0;
+}
+
+/*
+ *  pciex node: ibm,opal-m64-window = <0x3d058 0x0 0x3d058 0x0 0x8 0x0>;
+ */
+
+static int switch_card_to_cxl(struct pci_dev *dev)
+{
+	int vsec;
+	u8 val;
+	int rc;
+
+	dev_info(&dev->dev, "switch card to CXL\n");
+
+	if (!(vsec = find_cxl_vsec(dev))) {
+		dev_err(&dev->dev, "ABORTING: CXL VSEC not found!\n");
+		return -ENODEV;
+	}
+
+	if ((rc = CXL_READ_VSEC_MODE_CONTROL(dev, vsec, &val))) {
+		dev_err(&dev->dev, "failed to read current mode control: %i", rc);
+		return rc;
+	}
+	val &= ~CXL_VSEC_PROTOCOL_MASK;
+	val |= CXL_VSEC_PROTOCOL_256TB | CXL_VSEC_PROTOCOL_ENABLE;
+	if ((rc = CXL_WRITE_VSEC_MODE_CONTROL(dev, vsec, val))) {
+		dev_err(&dev->dev, "failed to enable CXL protocol: %i", rc);
+		return rc;
+	}
+	/* The CAIA spec (v0.12 11.6 Bi-modal Device Support) states
+	 * we must wait 100ms after this mode switch before touching
+	 * PCIe config space.
+	 */
+	msleep(100);
+
+	return 0;
+}
+
+static int cxl_map_slice_regs(struct cxl_afu_t *afu, struct cxl_t *adapter, struct pci_dev *dev)
+{
+	u64 p1n_base, p2n_base, afu_desc;
+	const u64 p1n_size = 0x100;
+	const u64 p2n_size = 0x1000;
+
+	p1n_base = p1_base(dev) + 0x10000 + (afu->slice * p1n_size);
+	p2n_base = p2_base(dev) + (afu->slice * p2n_size);
+	afu->psn_phys = p2_base(dev) + (adapter->ps_off + (afu->slice * adapter->ps_size));
+	afu_desc = p2_base(dev) + adapter->afu_desc_off + (afu->slice * adapter->afu_desc_size);
+
+	if (!(afu->p1n_mmio = ioremap(p1n_base, p1n_size)))
+		goto err;
+	if (!(afu->p2n_mmio = ioremap(p2n_base, p2n_size)))
+		goto err1;
+	if (afu_desc) {
+		if (!(afu->afu_desc_mmio = ioremap(afu_desc, adapter->afu_desc_size)))
+			goto err2;
+	}
+
+	return 0;
+err2:
+	iounmap(afu->p2n_mmio);
+err1:
+	iounmap(afu->p1n_mmio);
+err:
+	dev_err(&afu->dev, "Error mapping AFU MMIO regions\n");
+	return -ENOMEM;
+}
+
+static void cxl_unmap_slice_regs(struct cxl_afu_t *afu)
+{
+	if (afu->p1n_mmio)
+		iounmap(afu->p2n_mmio);
+	if (afu->p1n_mmio)
+		iounmap(afu->p1n_mmio);
+}
+
+static void cxl_release_afu(struct device *dev)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(dev);
+
+	pr_devel("cxl_release_afu\n");
+
+	kfree(afu);
+}
+
+static struct cxl_afu_t *cxl_alloc_afu(struct cxl_t *adapter, int slice)
+{
+	struct cxl_afu_t *afu;
+
+	if (!(afu = kzalloc(sizeof(struct cxl_afu_t), GFP_KERNEL)))
+		return NULL;
+
+	afu->adapter = adapter;
+	afu->dev.parent = &adapter->dev;
+	afu->dev.release = cxl_release_afu;
+	afu->slice = slice;
+	idr_init(&afu->contexts_idr);
+	spin_lock_init(&afu->contexts_lock);
+	spin_lock_init(&afu->afu_cntl_lock);
+	mutex_init(&afu->spa_mutex);
+
+	afu->prefault_mode = CXL_PREFAULT_NONE;
+	afu->irqs_max = afu->adapter->user_irqs;
+
+	return afu;
+}
+
+/* Expects AFU struct to have recently been zeroed out */
+static int cxl_read_afu_descriptor(struct cxl_afu_t *afu)
+{
+	u64 val;
+
+	val = AFUD_READ_INFO(afu);
+	afu->pp_irqs = AFUD_NUM_INTS_PER_PROC(val);
+	afu->max_procs_virtualised = AFUD_NUM_PROCS(val);
+
+	if (AFUD_AFU_DIRECTED(val))
+		afu->models_supported |= CXL_MODEL_DIRECTED;
+	if (AFUD_DEDICATED_PROCESS(val))
+		afu->models_supported |= CXL_MODEL_DEDICATED;
+	if (AFUD_TIME_SLICED(val))
+		afu->models_supported |= CXL_MODEL_TIME_SLICED;
+
+	val = AFUD_READ_PPPSA(afu);
+	afu->pp_size = AFUD_PPPSA_LEN(val) * 4096;
+	afu->psa = AFUD_PPPSA_PSA(val);
+	if ((afu->pp_psa = AFUD_PPPSA_PP(val)))
+		afu->pp_offset = AFUD_READ_PPPSA_OFF(afu);
+
+	return 0;
+}
+
+static int cxl_afu_descriptor_looks_ok(struct cxl_afu_t *afu)
+{
+	if (afu->psa && afu->adapter->ps_size <
+			(afu->pp_offset + afu->pp_size*afu->max_procs_virtualised)) {
+		dev_err(&afu->dev, "per-process PSA can't fit inside the PSA!\n");
+		return -ENODEV;
+	}
+
+	if (afu->pp_psa && (afu->pp_size < PAGE_SIZE))
+		dev_warn(&afu->dev, "AFU uses < PAGE_SIZE per-process PSA!");
+
+	return 0;
+}
+
+static int sanitise_afu_regs(struct cxl_afu_t *afu)
+{
+	cxl_p1_write(afu->adapter, CXL_PSL_ErrIVTE, 0x0000000000000000);
+	cxl_p1n_write(afu, CXL_PSL_SERR_An, 0x0000000000000000);
+	cxl_p1n_write(afu, CXL_PSL_IVTE_Offset_An, 0x0000000000000000);
+	cxl_ops->slbia(afu);
+
+	return 0;
+}
+
+static int cxl_init_afu(struct cxl_t *adapter, int slice, struct pci_dev *dev)
+{
+	struct cxl_afu_t *afu;
+	bool free = true;
+	int rc;
+
+	if (!(afu = cxl_alloc_afu(adapter, slice)))
+		return -ENOMEM;
+
+	if ((rc = dev_set_name(&afu->dev, "afu%i.%i", adapter->adapter_num, slice)))
+		goto err1;
+
+	if ((rc = cxl_map_slice_regs(afu, adapter, dev)))
+		goto err1;
+
+	if ((rc = sanitise_afu_regs(afu)))
+		goto err2;
+
+	/* We need to reset the AFU before we can read the AFU descriptor */
+	if ((rc = cxl_ops->afu_reset(afu)))
+		goto err2;
+
+	if (cxl_verbose)
+		dump_afu_descriptor(afu);
+
+	if ((rc = cxl_read_afu_descriptor(afu)))
+		goto err2;
+
+	if ((rc = cxl_afu_descriptor_looks_ok(afu)))
+		goto err2;
+
+	if ((rc = init_implementation_afu_regs(afu)))
+		goto err2;
+
+	if ((rc = cxl_register_serr_irq(afu)))
+		goto err2;
+
+	if ((rc = cxl_register_psl_irq(afu)))
+		goto err3;
+
+	/* Don't care if this fails */
+	cxl_debugfs_afu_add(afu);
+
+	/* After we call this function we must not free the afu directly, even
+	 * if it returns an error! */
+	if ((rc = cxl_register_afu(afu)))
+		goto err_put1;
+
+	if ((rc = cxl_sysfs_afu_add(afu)))
+		goto err_put1;
+
+
+	if ((rc = cxl_afu_select_best_model(afu)))
+		goto err_put2;
+
+	adapter->afu[afu->slice] = afu;
+
+	return 0;
+
+err_put2:
+	cxl_sysfs_afu_remove(afu);
+err_put1:
+	device_unregister(&afu->dev);
+	free = false;
+	cxl_debugfs_afu_remove(afu);
+	cxl_release_psl_irq(afu);
+err3:
+	cxl_release_serr_irq(afu);
+err2:
+	cxl_unmap_slice_regs(afu);
+err1:
+	if (free)
+		kfree(afu);
+	return rc;
+}
+
+static void cxl_remove_afu(struct cxl_afu_t *afu)
+{
+	pr_devel("cxl_remove_afu\n");
+
+	if (!afu)
+		return;
+
+	cxl_sysfs_afu_remove(afu);
+	cxl_debugfs_afu_remove(afu);
+
+	spin_lock(&afu->adapter->afu_list_lock);
+	afu->adapter->afu[afu->slice] = NULL;
+	spin_unlock(&afu->adapter->afu_list_lock);
+
+	cxl_context_detach_all(afu);
+	cxl_afu_deactivate_model(afu);
+
+	cxl_release_psl_irq(afu);
+	cxl_release_serr_irq(afu);
+	cxl_unmap_slice_regs(afu);
+
+	device_unregister(&afu->dev);
+}
+
+
+static int cxl_map_adapter_regs(struct cxl_t *adapter, struct pci_dev *dev)
+{
+	if (pci_request_region(dev, 2, "priv 2 regs"))
+		goto err1;
+	if (pci_request_region(dev, 0, "priv 1 regs"))
+		goto err2;
+
+	pr_devel("cxl_map_adapter_regs: p1: %#.16llx %#llx, p2: %#.16llx %#llx",
+			p1_base(dev), p1_size(dev), p2_base(dev), p2_size(dev));
+
+	if (!(adapter->p1_mmio = ioremap(p1_base(dev), p1_size(dev))))
+		goto err3;
+
+	if (!(adapter->p2_mmio = ioremap(p2_base(dev), p2_size(dev))))
+		goto err4;
+
+	return 0;
+
+err4:
+	iounmap(adapter->p1_mmio);
+	adapter->p1_mmio = NULL;
+err3:
+	pci_release_region(dev, 0);
+err2:
+	pci_release_region(dev, 2);
+err1:
+	return -ENOMEM;
+}
+
+static void cxl_unmap_adapter_regs(struct cxl_t *adapter)
+{
+	if (adapter->p1_mmio)
+		iounmap(adapter->p1_mmio);
+	if (adapter->p2_mmio)
+		iounmap(adapter->p2_mmio);
+}
+
+static int cxl_read_vsec(struct cxl_t *adapter, struct pci_dev *dev)
+{
+	int vsec;
+	u32 afu_desc_off, afu_desc_size;
+	u32 ps_off, ps_size;
+	u16 vseclen;
+	u8 image_state;
+
+	if (!(vsec = find_cxl_vsec(dev))) {
+		dev_err(&adapter->dev, "ABORTING: CXL VSEC not found!\n");
+		return -ENODEV;
+	}
+
+	CXL_READ_VSEC_LENGTH(dev, vsec, &vseclen);
+	if (vseclen < CXL_VSEC_MIN_SIZE) {
+		pr_err("ABORTING: CXL VSEC too short\n");
+		return -EINVAL;
+	}
+
+	CXL_READ_VSEC_STATUS(dev, vsec, &adapter->vsec_status);
+	CXL_READ_VSEC_PSL_REVISION(dev, vsec, &adapter->psl_rev);
+	CXL_READ_VSEC_CAIA_MAJOR(dev, vsec, &adapter->caia_major);
+	CXL_READ_VSEC_CAIA_MINOR(dev, vsec, &adapter->caia_minor);
+	CXL_READ_VSEC_BASE_IMAGE(dev, vsec, &adapter->base_image);
+	CXL_READ_VSEC_IMAGE_STATE(dev, vsec, &image_state);
+	adapter->user_image_loaded = !!(image_state & CXL_VSEC_USER_IMAGE_LOADED);
+	adapter->perst_loads_image = !!(image_state & CXL_VSEC_PERST_LOADS_IMAGE);
+	adapter->perst_select_user = !!(image_state & CXL_VSEC_PERST_SELECT_USER);
+
+	CXL_READ_VSEC_NAFUS(dev, vsec, &adapter->slices);
+	CXL_READ_VSEC_AFU_DESC_OFF(dev, vsec, &afu_desc_off);
+	CXL_READ_VSEC_AFU_DESC_SIZE(dev, vsec, &afu_desc_size);
+	CXL_READ_VSEC_PS_OFF(dev, vsec, &ps_off);
+	CXL_READ_VSEC_PS_SIZE(dev, vsec, &ps_size);
+
+	/* Convert everything to bytes, because there is NO WAY I'd look at the
+	 * code a month later and forget what units these are in ;-) */
+	adapter->ps_off = ps_off * 64 * 1024;
+	adapter->ps_size = ps_size * 64 * 1024;
+	adapter->afu_desc_off = afu_desc_off * 64 * 1024;
+	adapter->afu_desc_size = afu_desc_size *64 * 1024;
+
+	/* Total IRQs - 1 PSL ERROR - #AFU*(1 slice error + 1 DSI) */
+	adapter->user_irqs = pnv_cxl_get_irq_count(dev) - 1 - 2*adapter->slices;
+
+	return 0;
+}
+
+static int cxl_vsec_looks_ok(struct cxl_t *adapter, struct pci_dev *dev)
+{
+	if (adapter->vsec_status & CXL_STATUS_SECOND_PORT)
+		return -EBUSY;
+
+	if (adapter->vsec_status & CXL_UNSUPPORTED_FEATURES) {
+		dev_err(&adapter->dev, "ABORTING: CXL requires unsupported features\n");
+		return -EINVAL;
+	}
+
+	if (!adapter->slices) {
+		/* Once we support dynamic reprogramming we can use the card if
+		 * it supports loadable AFUs */
+		dev_err(&adapter->dev, "ABORTING: Device has no AFUs\n");
+		return -EINVAL;
+	}
+
+	if (!adapter->afu_desc_off || !adapter->afu_desc_size) {
+		dev_err(&adapter->dev, "ABORTING: VSEC shows no AFU descriptors\n");
+		return -EINVAL;
+	}
+
+	if (adapter->ps_size > p2_size(dev) - adapter->ps_off) {
+		dev_err(&adapter->dev, "ABORTING: Problem state size larger than "
+				   "available in BAR2: 0x%llx > 0x%llx\n",
+			 adapter->ps_size, p2_size(dev) - adapter->ps_off);
+		return -EINVAL;
+	}
+
+	return 0;
+}
+
+static void cxl_release_adapter(struct device *dev)
+{
+	struct cxl_t *adapter = to_cxl_adapter(dev);
+
+	pr_devel("cxl_release_adapter\n");
+
+	kfree(adapter);
+}
+
+static struct cxl_t *cxl_alloc_adapter(struct pci_dev *dev)
+{
+	struct cxl_t *adapter;
+
+	if (!(adapter = kzalloc(sizeof(struct cxl_t), GFP_KERNEL)))
+		return NULL;
+
+	adapter->dev.parent = &dev->dev;
+	adapter->dev.release = cxl_release_adapter;
+	adapter->driver = &cxl_pci_driver_ops;
+	pci_set_drvdata(dev, adapter);
+	spin_lock_init(&adapter->afu_list_lock);
+
+	return adapter;
+}
+
+static struct cxl_t *cxl_init_adapter(struct pci_dev *dev)
+{
+	struct cxl_t *adapter;
+	bool free = true;
+	int rc;
+
+
+	if (!(adapter = cxl_alloc_adapter(dev)))
+		return ERR_PTR(-ENOMEM);
+
+	if ((rc = switch_card_to_cxl(dev)))
+		goto err1;
+
+	if ((rc = cxl_alloc_adapter_nr(adapter)))
+		goto err1;
+
+	if ((rc = dev_set_name(&adapter->dev, "card%i", adapter->adapter_num)))
+		goto err2;
+
+	if ((rc = cxl_read_vsec(adapter, dev)))
+		goto err2;
+
+	if ((rc = cxl_vsec_looks_ok(adapter, dev)))
+		goto err2;
+
+	if ((rc = cxl_map_adapter_regs(adapter, dev)))
+		goto err2;
+
+	/* TODO: cxl_ops->sanitise_adapter_regs(adapter); */
+
+	if ((rc = init_implementation_adapter_regs(adapter, dev)))
+		goto err3;
+
+	if ((rc = pnv_phb_to_cxl(dev)))
+		goto err3;
+
+	if ((rc = cxl_register_psl_err_irq(adapter)))
+		goto err3;
+
+	/* Don't care if this one fails: */
+	cxl_debugfs_adapter_add(adapter);
+
+	/* After we call this function we must not free the adapter directly,
+	 * even if it returns an error! */
+	if ((rc = cxl_register_adapter(adapter)))
+		goto err_put1;
+
+	if ((rc = cxl_sysfs_adapter_add(adapter)))
+		goto err_put1;
+
+	return adapter;
+
+err_put1:
+	device_unregister(&adapter->dev);
+	free = false;
+	cxl_debugfs_adapter_remove(adapter);
+	cxl_release_psl_err_irq(adapter);
+err3:
+	cxl_unmap_adapter_regs(adapter);
+err2:
+	cxl_remove_adapter_nr(adapter);
+err1:
+	if (free)
+		kfree(adapter);
+	return ERR_PTR(rc);
+}
+
+static void cxl_remove_adapter(struct cxl_t *adapter)
+{
+	struct pci_dev *pdev = to_pci_dev(adapter->dev.parent);
+
+	pr_devel("cxl_release_adapter\n");
+
+	cxl_sysfs_adapter_remove(adapter);
+	cxl_debugfs_adapter_remove(adapter);
+	cxl_release_psl_err_irq(adapter);
+	cxl_unmap_adapter_regs(adapter);
+	cxl_remove_adapter_nr(adapter);
+
+	device_unregister(&adapter->dev);
+
+	pci_release_region(pdev, 0);
+	pci_release_region(pdev, 2);
+	pci_disable_device(pdev);
+}
+
+static int cxl_probe(struct pci_dev *dev, const struct pci_device_id *id)
+{
+	struct cxl_t *adapter;
+	int slice;
+	int rc;
+
+	pci_dev_get(dev);
+
+	if (cxl_verbose)
+		dump_cxl_config_space(dev);
+
+	if ((rc = setup_cxl_bars(dev)))
+		return rc;
+
+	if ((rc = pci_enable_device(dev))) {
+		dev_err(&dev->dev, "pci_enable_device failed: %i\n", rc);
+		return rc;
+	}
+
+	adapter = cxl_init_adapter(dev);
+	if (IS_ERR(adapter)) {
+		dev_err(&dev->dev, "cxl_init_adapter failed: %li\n", PTR_ERR(adapter));
+		return PTR_ERR(adapter);
+	}
+
+	for (slice = 0; slice < adapter->slices; slice++) {
+		if ((rc = cxl_init_afu(adapter, slice, dev)))
+			dev_err(&dev->dev, "AFU %i failed to initialise: %i\n", slice, rc);
+	}
+
+	return 0;
+}
+
+static void cxl_remove(struct pci_dev *dev)
+{
+	struct cxl_t *adapter = pci_get_drvdata(dev);
+	int afu;
+
+	dev_warn(&dev->dev, "pci remove\n");
+
+	/* Lock to prevent someone grabbing a ref through the adapter list as
+	 * we are removing it */
+	for (afu = 0; afu < adapter->slices; afu++)
+		cxl_remove_afu(adapter->afu[afu]);
+	cxl_remove_adapter(adapter);
+}
+
+static struct pci_driver cxl_pci_driver = {
+	.name = "cxl-pci",
+	.id_table = cxl_pci_tbl,
+	.probe = cxl_probe,
+	.remove = cxl_remove,
+};
+
+module_driver(cxl_pci_driver, pci_register_driver, pci_unregister_driver);
+
+MODULE_DESCRIPTION("IBM Coherent Accelerator");
+MODULE_AUTHOR("Ian Munsie <imunsie@au1.ibm.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/cxl/cxl.h b/drivers/misc/cxl/cxl.h
new file mode 100644
index 0000000..87984cb
--- /dev/null
+++ b/drivers/misc/cxl/cxl.h
@@ -0,0 +1,605 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#ifndef _CXL_H_
+#define _CXL_H_
+
+#include <linux/interrupt.h>
+#include <linux/semaphore.h>
+#include <linux/device.h>
+#include <linux/types.h>
+#include <linux/cdev.h>
+#include <linux/pid.h>
+#include <linux/io.h>
+#include <asm/cputable.h>
+#include <asm/mmu.h>
+#include <asm/reg.h>
+#include <misc/cxl.h>
+
+#include <uapi/misc/cxl.h>
+
+extern uint cxl_verbose;
+
+#define CXL_TIMEOUT 5
+
+/* Opaque types to avoid accidentally passing registers for the wrong MMIO
+ *
+ * At the end of the day, I'm not married to using typedef here, but it might
+ * (and has!) help avoid bugs like mixing up CXL_PSL_CtxTime and
+ * CXL_PSL_CtxTime_An, or calling cxl_p1n_write instead of cxl_p1_write.
+ *
+ * I'm quite happy if these are changed back to #defines before upstreaming, it
+ * should be little more than a regexp search+replace operation in this file.
+ */
+typedef struct {
+	const int x;
+} cxl_p1_reg_t;
+typedef struct {
+	const int x;
+} cxl_p1n_reg_t;
+typedef struct {
+	const int x;
+} cxl_p2n_reg_t;
+#define cxl_reg_off(reg) \
+	(reg.x)
+
+/* Memory maps. Ref CXL Appendix A */
+
+/* PSL Privilege 1 Memory Map */
+/* Configuration and Control area */
+static const cxl_p1_reg_t CXL_PSL_CtxTime = {0x0000};
+static const cxl_p1_reg_t CXL_PSL_ErrIVTE = {0x0008};
+static const cxl_p1_reg_t CXL_PSL_KEY1    = {0x0010};
+static const cxl_p1_reg_t CXL_PSL_KEY2    = {0x0018};
+static const cxl_p1_reg_t CXL_PSL_Control = {0x0020};
+/* Downloading */
+static const cxl_p1_reg_t CXL_PSL_DLCNTL  = {0x0060};
+static const cxl_p1_reg_t CXL_PSL_DLADDR  = {0x0068};
+
+/* PSL Lookaside Buffer Management Area */
+static const cxl_p1_reg_t CXL_PSL_LBISEL  = {0x0080};
+static const cxl_p1_reg_t CXL_PSL_SLBIE   = {0x0088};
+static const cxl_p1_reg_t CXL_PSL_SLBIA   = {0x0090};
+static const cxl_p1_reg_t CXL_PSL_TLBIE   = {0x00A0};
+static const cxl_p1_reg_t CXL_PSL_TLBIA   = {0x00A8};
+static const cxl_p1_reg_t CXL_PSL_AFUSEL  = {0x00B0};
+
+/* 0x00C0:7EFF Implementation dependent area */
+static const cxl_p1_reg_t CXL_PSL_FIR1      = {0x0100};
+static const cxl_p1_reg_t CXL_PSL_FIR2      = {0x0108};
+static const cxl_p1_reg_t CXL_PSL_VERSION   = {0x0118};
+static const cxl_p1_reg_t CXL_PSL_RESLCKTO  = {0x0128};
+static const cxl_p1_reg_t CXL_PSL_FIR_CNTL  = {0x0148};
+static const cxl_p1_reg_t CXL_PSL_DSNDCTL   = {0x0150};
+static const cxl_p1_reg_t CXL_PSL_SNWRALLOC = {0x0158};
+static const cxl_p1_reg_t CXL_PSL_TRACE     = {0x0170};
+/* 0x7F00:7FFF Reserved PCIe MSI-X Pending Bit Array area */
+/* 0x8000:FFFF Reserved PCIe MSI-X Table Area */
+
+/* PSL Slice Privilege 1 Memory Map */
+/* Configuration Area */
+static const cxl_p1n_reg_t CXL_PSL_SR_An          = {0x00};
+static const cxl_p1n_reg_t CXL_PSL_LPID_An        = {0x08};
+static const cxl_p1n_reg_t CXL_PSL_AMBAR_An       = {0x10};
+static const cxl_p1n_reg_t CXL_PSL_SPOffset_An    = {0x18};
+static const cxl_p1n_reg_t CXL_PSL_ID_An          = {0x20};
+static const cxl_p1n_reg_t CXL_PSL_SERR_An        = {0x28};
+/* Memory Management and Lookaside Buffer Management */
+static const cxl_p1n_reg_t CXL_PSL_SDR_An         = {0x30};
+static const cxl_p1n_reg_t CXL_PSL_AMOR_An        = {0x38};
+/* Pointer Area */
+static const cxl_p1n_reg_t CXL_HAURP_An           = {0x80};
+static const cxl_p1n_reg_t CXL_PSL_SPAP_An        = {0x88};
+static const cxl_p1n_reg_t CXL_PSL_LLCMD_An       = {0x90};
+/* Control Area */
+static const cxl_p1n_reg_t CXL_PSL_SCNTL_An       = {0xA0};
+static const cxl_p1n_reg_t CXL_PSL_CtxTime_An     = {0xA8};
+static const cxl_p1n_reg_t CXL_PSL_IVTE_Offset_An = {0xB0};
+static const cxl_p1n_reg_t CXL_PSL_IVTE_Limit_An  = {0xB8};
+/* 0xC0:FF Implementation Dependent Area */
+static const cxl_p1n_reg_t CXL_PSL_FIR_SLICE_An   = {0xC0};
+static const cxl_p1n_reg_t CXL_AFU_DEBUG_An       = {0xC8};
+static const cxl_p1n_reg_t CXL_PSL_APCALLOC_A     = {0xD0};
+static const cxl_p1n_reg_t CXL_PSL_COALLOC_A      = {0xD8};
+static const cxl_p1n_reg_t CXL_PSL_RXCTL_A        = {0xE0};
+static const cxl_p1n_reg_t CXL_PSL_SLICE_TRACE    = {0xE8};
+
+/* PSL Slice Privilege 2 Memory Map */
+/* Configuration and Control Area */
+static const cxl_p2n_reg_t CXL_PSL_PID_TID_An = {0x000};
+static const cxl_p2n_reg_t CXL_CSRP_An        = {0x008};
+static const cxl_p2n_reg_t CXL_AURP0_An       = {0x010};
+static const cxl_p2n_reg_t CXL_AURP1_An       = {0x018};
+static const cxl_p2n_reg_t CXL_SSTP0_An       = {0x020};
+static const cxl_p2n_reg_t CXL_SSTP1_An       = {0x028};
+static const cxl_p2n_reg_t CXL_PSL_AMR_An     = {0x030};
+/* Segment Lookaside Buffer Management */
+static const cxl_p2n_reg_t CXL_SLBIE_An       = {0x040};
+static const cxl_p2n_reg_t CXL_SLBIA_An       = {0x048};
+static const cxl_p2n_reg_t CXL_SLBI_Select_An = {0x050};
+/* Interrupt Registers */
+static const cxl_p2n_reg_t CXL_PSL_DSISR_An   = {0x060};
+static const cxl_p2n_reg_t CXL_PSL_DAR_An     = {0x068};
+static const cxl_p2n_reg_t CXL_PSL_DSR_An     = {0x070};
+static const cxl_p2n_reg_t CXL_PSL_TFC_An     = {0x078};
+static const cxl_p2n_reg_t CXL_PSL_PEHandle_An = {0x080};
+static const cxl_p2n_reg_t CXL_PSL_ErrStat_An = {0x088};
+/* AFU Registers */
+static const cxl_p2n_reg_t CXL_AFU_Cntl_An    = {0x090};
+static const cxl_p2n_reg_t CXL_AFU_ERR_An     = {0x098};
+/* Work Element Descriptor */
+static const cxl_p2n_reg_t CXL_PSL_WED_An     = {0x0A0};
+/* 0x0C0:FFF Implementation Dependent Area */
+
+#define CXL_PSL_SPAP_Addr 0x0ffffffffffff000ULL
+#define CXL_PSL_SPAP_Size 0x0000000000000ff0ULL
+#define CXL_PSL_SPAP_Size_Shift 4
+#define CXL_PSL_SPAP_V    0x0000000000000001ULL
+
+/****** CXL_PSL_DLCNTL *****************************************************/
+#define CXL_PSL_DLCNTL_D (0x1ull << (63-28))
+#define CXL_PSL_DLCNTL_C (0x1ull << (63-29))
+#define CXL_PSL_DLCNTL_E (0x1ull << (63-30))
+#define CXL_PSL_DLCNTL_S (0x1ull << (63-31))
+#define CXL_PSL_DLCNTL_CE (CXL_PSL_DLCNTL_C | CXL_PSL_DLCNTL_E)
+#define CXL_PSL_DLCNTL_DCES (CXL_PSL_DLCNTL_D | CXL_PSL_DLCNTL_CE | CXL_PSL_DLCNTL_S)
+
+/****** CXL_PSL_SR_An ******************************************************/
+#define CXL_PSL_SR_An_SF  MSR_SF            /* 64bit */
+#define CXL_PSL_SR_An_TA  (1ull << (63-1))  /* Tags active,   GA1: 0 */
+#define CXL_PSL_SR_An_HV  MSR_HV            /* Hypervisor,    GA1: 0 */
+#define CXL_PSL_SR_An_PR  MSR_PR            /* Problem state, GA1: 1 */
+#define CXL_PSL_SR_An_ISL (1ull << (63-53)) /* Ignore Segment Large Page */
+#define CXL_PSL_SR_An_TC  (1ull << (63-54)) /* Page Table secondary hash */
+#define CXL_PSL_SR_An_US  (1ull << (63-56)) /* User state,    GA1: X */
+#define CXL_PSL_SR_An_SC  (1ull << (63-58)) /* Segment Table secondary hash */
+#define CXL_PSL_SR_An_R   MSR_DR            /* Relocate,      GA1: 1 */
+#define CXL_PSL_SR_An_MP  (1ull << (63-62)) /* Master Process */
+#define CXL_PSL_SR_An_LE  (1ull << (63-63)) /* Little Endian */
+
+/****** CXL_PSL_LLCMD_An ****************************************************/
+#define CXL_LLCMD_TERMINATE   0x0001000000000000ULL
+#define CXL_LLCMD_REMOVE      0x0002000000000000ULL
+#define CXL_LLCMD_SUSPEND     0x0003000000000000ULL
+#define CXL_LLCMD_RESUME      0x0004000000000000ULL
+#define CXL_LLCMD_ADD         0x0005000000000000ULL
+#define CXL_LLCMD_UPDATE      0x0006000000000000ULL
+#define CXL_LLCMD_HANDLE_MASK 0x000000000000ffffULL
+
+/****** CXL_PSL_ID_An ****************************************************/
+#define CXL_PSL_ID_An_F	(1ull << (63-31))
+#define CXL_PSL_ID_An_L	(1ull << (63-30))
+
+/****** CXL_PSL_SCNTL_An ****************************************************/
+#define CXL_PSL_SCNTL_An_CR          (0x1ull << (63-15))
+/* Programming Models: */
+#define CXL_PSL_SCNTL_An_PM_MASK     (0xffffull << (63-31))
+#define CXL_PSL_SCNTL_An_PM_Shared   (0x0000ull << (63-31))
+#define CXL_PSL_SCNTL_An_PM_OS       (0x0001ull << (63-31))
+#define CXL_PSL_SCNTL_An_PM_Process  (0x0002ull << (63-31))
+#define CXL_PSL_SCNTL_An_PM_AFU      (0x0004ull << (63-31))
+#define CXL_PSL_SCNTL_An_PM_AFU_PBT  (0x0104ull << (63-31))
+/* Purge Status (ro) */
+#define CXL_PSL_SCNTL_An_Ps_MASK     (0x3ull << (63-39))
+#define CXL_PSL_SCNTL_An_Ps_Pending  (0x1ull << (63-39))
+#define CXL_PSL_SCNTL_An_Ps_Complete (0x3ull << (63-39))
+/* Purge */
+#define CXL_PSL_SCNTL_An_Pc          (0x1ull << (63-48))
+/* Suspend Status (ro) */
+#define CXL_PSL_SCNTL_An_Ss_MASK     (0x3ull << (63-55))
+#define CXL_PSL_SCNTL_An_Ss_Pending  (0x1ull << (63-55))
+#define CXL_PSL_SCNTL_An_Ss_Complete (0x3ull << (63-55))
+/* Suspend Control */
+#define CXL_PSL_SCNTL_An_Sc          (0x1ull << (63-63))
+
+/* AFU Slice Enable Status (ro) */
+#define CXL_AFU_Cntl_An_ES_MASK     (0x7ull << (63-2))
+#define CXL_AFU_Cntl_An_ES_Disabled (0x0ull << (63-2))
+#define CXL_AFU_Cntl_An_ES_Enabled  (0x4ull << (63-2))
+/* AFU Slice Enable */
+#define CXL_AFU_Cntl_An_E           (0x1ull << (63-3))
+/* AFU Slice Reset status (ro) */
+#define CXL_AFU_Cntl_An_RS_MASK     (0x3ull << (63-5))
+#define CXL_AFU_Cntl_An_RS_Pending  (0x1ull << (63-5))
+#define CXL_AFU_Cntl_An_RS_Complete (0x2ull << (63-5))
+/* AFU Slice Reset */
+#define CXL_AFU_Cntl_An_RA          (0x1ull << (63-7))
+
+/****** CXL_SSTP0/1_An ******************************************************/
+/* These top bits are for the segment that CONTAINS the segment table */
+#define CXL_SSTP0_An_B_SHIFT    SLB_VSID_SSIZE_SHIFT
+#define CXL_SSTP0_An_KS             (1ull << (63-2))
+#define CXL_SSTP0_An_KP             (1ull << (63-3))
+#define CXL_SSTP0_An_N              (1ull << (63-4))
+#define CXL_SSTP0_An_L              (1ull << (63-5))
+#define CXL_SSTP0_An_C              (1ull << (63-6))
+#define CXL_SSTP0_An_TA             (1ull << (63-7))
+#define CXL_SSTP0_An_LP_SHIFT                (63-9)  /* 2 Bits */
+/* And finally, the virtual address & size of the segment table: */
+#define CXL_SSTP0_An_SegTableSize_SHIFT      (63-31) /* 12 Bits */
+#define CXL_SSTP0_An_SegTableSize_MASK \
+	(((1ull << 12) - 1) << CXL_SSTP0_An_SegTableSize_SHIFT)
+#define CXL_SSTP0_An_STVA_U_MASK   ((1ull << (63-49))-1)
+#define CXL_SSTP1_An_STVA_L_MASK (~((1ull << (63-55))-1))
+#define CXL_SSTP1_An_V              (1ull << (63-63))
+
+/****** CXL_PSL_SLBIE_[An] **************************************************/
+/* write: */
+#define CXL_SLBIE_C        PPC_BIT(36)         /* Class */
+#define CXL_SLBIE_SS       PPC_BITMASK(37, 38) /* Segment Size */
+#define CXL_SLBIE_SS_SHIFT PPC_BITLSHIFT(38)
+#define CXL_SLBIE_TA       PPC_BIT(38)         /* Tags Active */
+/* read: */
+#define CXL_SLBIE_MAX      PPC_BITMASK(24, 31)
+#define CXL_SLBIE_PENDING  PPC_BITMASK(56, 63)
+
+/****** CXL_SLBIA_[An] ******************************************************/
+#define CXL_SLBIA_P         (1ull) /* Pending (read) */
+
+/****** Common to all PSL_SLBIE/A_[An] registers *****************************/
+#define CXL_SLBI_IQ_ALL     (0ull)              /* Inv qualifier */
+#define CXL_SLBI_IQ_LPID    (1ull)              /* Inv qualifier */
+#define CXL_SLBI_IQ_LPIDPID (3ull)              /* Inv qualifier */
+
+/****** CXL_PSL_DSISR_An ****************************************************/
+#define CXL_PSL_DSISR_An_DS (1ull << (63-0))  /* Segment not found */
+#define CXL_PSL_DSISR_An_DM (1ull << (63-1))  /* PTE not found (See also: M) or protection fault */
+#define CXL_PSL_DSISR_An_ST (1ull << (63-2))  /* Segment Table PTE not found */
+#define CXL_PSL_DSISR_An_UR (1ull << (63-3))  /* AURP PTE not found */
+#define CXL_PSL_DSISR_TRANS (CXL_PSL_DSISR_An_DS | CXL_PSL_DSISR_An_DM | CXL_PSL_DSISR_An_ST | CXL_PSL_DSISR_An_UR)
+#define CXL_PSL_DSISR_An_PE (1ull << (63-4))  /* PSL Error (implementation specific) */
+#define CXL_PSL_DSISR_An_AE (1ull << (63-5))  /* AFU Error */
+#define CXL_PSL_DSISR_An_OC (1ull << (63-6))  /* OS Context Warning */
+/* NOTE: Bits 32:63 are undefined if DSISR[DS] = 1 */
+#define CXL_PSL_DSISR_An_M  DSISR_NOHPTE      /* PTE not found */
+#define CXL_PSL_DSISR_An_P  DSISR_PROTFAULT   /* Storage protection violation */
+#define CXL_PSL_DSISR_An_A  (1ull << (63-37)) /* AFU lock access to write through or cache inhibited storage */
+#define CXL_PSL_DSISR_An_S  DSISR_ISSTORE     /* Access was afu_wr or afu_zero */
+#define CXL_PSL_DSISR_An_K  DSISR_KEYFAULT    /* Access not permitted by virtual page class key protection */
+
+/****** CXL_PSL_TFC_An ******************************************************/
+#define CXL_PSL_TFC_An_A  (1ull << (63-28)) /* Acknowledge non-translation fault */
+#define CXL_PSL_TFC_An_C  (1ull << (63-29)) /* Continue (abort transaction) */
+#define CXL_PSL_TFC_An_AE (1ull << (63-30)) /* Restart PSL with address error */
+#define CXL_PSL_TFC_An_R  (1ull << (63-31)) /* Restart PSL transaction */
+
+/* cxl_process_element->software_status */
+#define CXL_PE_SOFTWARE_STATE_V (1ul << (31 -  0)) /* Valid */
+#define CXL_PE_SOFTWARE_STATE_C (1ul << (31 - 29)) /* Complete */
+#define CXL_PE_SOFTWARE_STATE_S (1ul << (31 - 30)) /* Suspend */
+#define CXL_PE_SOFTWARE_STATE_T (1ul << (31 - 31)) /* Terminate */
+
+/* SPA->sw_command_status */
+#define CXL_SPA_SW_CMD_MASK         0xffff000000000000ULL
+#define CXL_SPA_SW_CMD_TERMINATE    0x0001000000000000ULL
+#define CXL_SPA_SW_CMD_REMOVE       0x0002000000000000ULL
+#define CXL_SPA_SW_CMD_SUSPEND      0x0003000000000000ULL
+#define CXL_SPA_SW_CMD_RESUME       0x0004000000000000ULL
+#define CXL_SPA_SW_CMD_ADD          0x0005000000000000ULL
+#define CXL_SPA_SW_CMD_UPDATE       0x0006000000000000ULL
+#define CXL_SPA_SW_STATE_MASK       0x0000ffff00000000ULL
+#define CXL_SPA_SW_STATE_TERMINATED 0x0000000100000000ULL
+#define CXL_SPA_SW_STATE_REMOVED    0x0000000200000000ULL
+#define CXL_SPA_SW_STATE_SUSPENDED  0x0000000300000000ULL
+#define CXL_SPA_SW_STATE_RESUMED    0x0000000400000000ULL
+#define CXL_SPA_SW_STATE_ADDED      0x0000000500000000ULL
+#define CXL_SPA_SW_STATE_UPDATED    0x0000000600000000ULL
+#define CXL_SPA_SW_PSL_ID_MASK      0x00000000ffff0000ULL
+#define CXL_SPA_SW_LINK_MASK        0x000000000000ffffULL
+
+#define CXL_MAX_SLICES 4
+#define MAX_AFU_MMIO_REGS 3
+
+#define CXL_MODEL_DEDICATED   0x1
+#define CXL_MODEL_DIRECTED    0x2
+#define CXL_MODEL_TIME_SLICED 0x4
+#define CXL_SUPPORTED_MODELS (CXL_MODEL_DEDICATED | CXL_MODEL_DIRECTED)
+
+enum cxl_context_status {
+	CLOSED,
+	OPENED,
+	STARTED
+};
+
+enum prefault_modes {
+	CXL_PREFAULT_NONE,
+	CXL_PREFAULT_WED,
+	CXL_PREFAULT_ALL,
+};
+
+struct cxl_sste {
+	__be64 esid_data;
+	__be64 vsid_data;
+};
+
+#define to_cxl_adapter(d) container_of(d, struct cxl_t, dev)
+#define to_cxl_afu(d) container_of(d, struct cxl_afu_t, dev)
+
+struct cxl_afu_t {
+	irq_hw_number_t psl_hwirq;
+	irq_hw_number_t serr_hwirq;
+	unsigned int serr_virq;
+	void __iomem *p1n_mmio;
+	void __iomem *p2n_mmio;
+	phys_addr_t psn_phys;
+	u64 pp_offset;
+	u64 pp_size;
+	void __iomem *afu_desc_mmio;
+	struct cxl_t *adapter;
+	struct device dev;
+	struct cdev afu_cdev_s, afu_cdev_m;
+	struct device *chardev_s, *chardev_m;
+	struct idr contexts_idr;
+	struct dentry *debugfs;
+	spinlock_t contexts_lock;
+	struct mutex spa_mutex;
+	spinlock_t afu_cntl_lock;
+
+	/* Only the first part of the SPA is used for the process element
+	 * linked list. The only other part that software needs to worry about
+	 * is sw_command_status, which we store a separate pointer to.
+	 * Everything else in the SPA is only used by hardware */
+	struct cxl_process_element *spa;
+	__be64 *sw_command_status;
+	unsigned int spa_size;
+	int spa_order;
+	int spa_max_procs;
+	unsigned int psl_virq;
+
+	int pp_irqs;
+	int irqs_max;
+	int num_procs;
+	int max_procs_virtualised;
+	int slice;
+	int models_supported;
+	int current_model;
+	enum prefault_modes prefault_mode;
+	bool psa;
+	bool pp_psa;
+	bool enabled;
+};
+
+/* This is a cxl context.  If the PSL is in dedicated model, there will be one
+ * of these per AFU.  If in AFU directed there can be lots of these. */
+struct cxl_context_t {
+	struct cxl_afu_t *afu;
+
+	/* Problem state MMIO */
+	phys_addr_t psn_phys;
+	u64 psn_size;
+
+	spinlock_t sst_lock; /* Protects segment table */
+	struct cxl_sste *sstp;
+	unsigned int sst_size, sst_lru;
+
+	wait_queue_head_t wq;
+	struct pid *pid;
+	spinlock_t lock; /* Protects pending_irq_mask, pending_fault and fault_addr */
+	/* Only used in PR mode */
+	u64 process_token;
+
+	unsigned long *irq_bitmap; /* Accessed from IRQ context */
+	struct cxl_irq_ranges irqs;
+	u64 fault_addr;
+	u64 afu_err;
+	enum cxl_context_status status;
+
+
+	/* XXX: Is it possible to need multiple work items at once? */
+	struct work_struct fault_work;
+	u64 dsisr;
+	u64 dar;
+
+	struct cxl_process_element *elem;
+
+	int ph; /* process handle/process element index */
+	u32 irq_count;
+	bool pe_inserted;
+	bool master;
+	bool kernel;
+	bool pending_irq;
+	bool pending_fault;
+	bool pending_afu_err;
+};
+
+struct cxl_t {
+	void __iomem *p1_mmio;
+	void __iomem *p2_mmio;
+	irq_hw_number_t err_hwirq;
+	unsigned int err_virq;
+	struct cxl_driver_ops *driver;
+	spinlock_t afu_list_lock;
+	struct cxl_afu_t *afu[CXL_MAX_SLICES];
+	struct device dev;
+	struct dentry *trace;
+	struct dentry *psl_err_chk;
+	struct dentry *debugfs;
+	struct bin_attribute cxl_attr;
+	int adapter_num;
+	int user_irqs;
+	u64 afu_desc_off;
+	u64 afu_desc_size;
+	u64 ps_off;
+	u64 ps_size;
+	u16 psl_rev;
+	u16 base_image;
+	u8 vsec_status;
+	u8 caia_major;
+	u8 caia_minor;
+	u8 slices;
+	bool user_image_loaded;
+	bool perst_loads_image;
+	bool perst_select_user;
+};
+
+struct cxl_driver_ops {
+	struct module *module;
+	int (*alloc_one_irq)(struct cxl_t *adapter);
+	void (*release_one_irq)(struct cxl_t *adapter, int hwirq);
+	int (*alloc_irq_ranges)(struct cxl_irq_ranges *irqs, struct cxl_t *adapter, unsigned int num);
+	void (*release_irq_ranges)(struct cxl_irq_ranges *irqs, struct cxl_t *adapter);
+	int (*setup_irq)(struct cxl_t *adapter, unsigned int hwirq, unsigned int virq);
+};
+
+/* common == phyp + powernv */
+struct cxl_process_element_common {
+	__be32 tid;
+	__be32 pid;
+	__be64 csrp;
+	__be64 aurp0;
+	__be64 aurp1;
+	__be64 sstp0;
+	__be64 sstp1;
+	__be64 amr;
+	u8     reserved3[4];
+	__be64 wed;
+} __packed;
+
+/* just powernv */
+struct cxl_process_element {
+	__be64 sr;
+	__be64 SPOffset;
+	__be64 sdr;
+	__be64 haurp;
+	__be32 ctxtime;
+	__be16 ivte_offsets[4];
+	__be16 ivte_ranges[4];
+	__be32 lpid;
+	struct cxl_process_element_common common;
+	__be32 software_state;
+} __packed;
+
+#define _cxl_reg_write(addr, val) \
+	out_be64((u64 __iomem *)(addr), val)
+#define _cxl_reg_read(addr) \
+	in_be64((u64 __iomem *)(addr))
+
+static inline void __iomem *_cxl_p1_addr(struct cxl_t *cxl, cxl_p1_reg_t reg)
+{
+	WARN_ON(!cpu_has_feature(CPU_FTR_HVMODE));
+	return cxl->p1_mmio + cxl_reg_off(reg);
+}
+#define cxl_p1_write(cxl, reg, val) \
+	_cxl_reg_write(_cxl_p1_addr(cxl, reg), val)
+#define cxl_p1_read(cxl, reg) \
+	_cxl_reg_read(_cxl_p1_addr(cxl, reg))
+
+static inline void __iomem *_cxl_p1n_addr(struct cxl_afu_t *afu, cxl_p1n_reg_t reg)
+{
+	WARN_ON(!cpu_has_feature(CPU_FTR_HVMODE));
+	return afu->p1n_mmio + cxl_reg_off(reg);
+}
+#define cxl_p1n_write(afu, reg, val) \
+	_cxl_reg_write(_cxl_p1n_addr(afu, reg), val)
+#define cxl_p1n_read(afu, reg) \
+	_cxl_reg_read(_cxl_p1n_addr(afu, reg))
+
+static inline void __iomem *_cxl_p2n_addr(struct cxl_afu_t *afu, cxl_p2n_reg_t reg)
+{
+	return afu->p2n_mmio + cxl_reg_off(reg);
+}
+#define cxl_p2n_write(afu, reg, val) \
+	_cxl_reg_write(_cxl_p2n_addr(afu, reg), val)
+#define cxl_p2n_read(afu, reg) \
+	_cxl_reg_read(_cxl_p2n_addr(afu, reg))
+
+struct cxl_calls {
+	void (*cxl_slbia)(struct mm_struct *mm);
+	struct module *owner;
+};
+int register_cxl_calls(struct cxl_calls *calls);
+void unregister_cxl_calls(struct cxl_calls *calls);
+
+int cxl_alloc_adapter_nr(struct cxl_t *adapter);
+void cxl_remove_adapter_nr(struct cxl_t *adapter);
+
+int cxl_file_init(void);
+void cxl_file_exit(void);
+int cxl_register_adapter(struct cxl_t *adapter);
+int cxl_register_afu(struct cxl_afu_t *afu);
+int cxl_chardev_m_afu_add(struct cxl_afu_t *afu);
+int cxl_chardev_s_afu_add(struct cxl_afu_t *afu);
+void cxl_chardev_afu_remove(struct cxl_afu_t *afu);
+
+void cxl_context_detach_all(struct cxl_afu_t *afu);
+void cxl_context_free(struct cxl_context_t *ctx);
+void cxl_context_detach(struct cxl_context_t *ctx);
+
+int cxl_sysfs_adapter_add(struct cxl_t *adapter);
+void cxl_sysfs_adapter_remove(struct cxl_t *adapter);
+int cxl_sysfs_afu_add(struct cxl_afu_t *afu);
+void cxl_sysfs_afu_remove(struct cxl_afu_t *afu);
+
+int cxl_afu_activate_model(struct cxl_afu_t *afu, int model);
+int _cxl_afu_deactivate_model(struct cxl_afu_t *afu, int model);
+int cxl_afu_deactivate_model(struct cxl_afu_t *afu);
+int cxl_afu_select_best_model(struct cxl_afu_t *afu);
+
+unsigned int cxl_map_irq(struct cxl_t *adapter, irq_hw_number_t hwirq,
+		         irq_handler_t handler, void *cookie);
+void cxl_unmap_irq(unsigned int virq, void *cookie);
+int cxl_register_psl_irq(struct cxl_afu_t *afu);
+void cxl_release_psl_irq(struct cxl_afu_t *afu);
+int cxl_register_psl_err_irq(struct cxl_t *adapter);
+void cxl_release_psl_err_irq(struct cxl_t *adapter);
+int cxl_register_serr_irq(struct cxl_afu_t *afu);
+void cxl_release_serr_irq(struct cxl_afu_t *afu);
+int afu_register_irqs(struct cxl_context_t *ctx, u32 count);
+void afu_release_irqs(struct cxl_context_t *ctx);
+irqreturn_t cxl_slice_irq_err(int irq, void *data);
+
+int cxl_debugfs_init(void);
+void cxl_debugfs_exit(void);
+int cxl_debugfs_adapter_add(struct cxl_t *adapter);
+void cxl_debugfs_adapter_remove(struct cxl_t *adapter);
+int cxl_debugfs_afu_add(struct cxl_afu_t *afu);
+void cxl_debugfs_afu_remove(struct cxl_afu_t *afu);
+
+void cxl_handle_fault(struct work_struct *work);
+void cxl_prefault(struct cxl_context_t *ctx, u64 wed);
+
+struct cxl_t *get_cxl_adapter(int num);
+int cxl_alloc_sst(struct cxl_context_t *ctx, u64 *sstp0, u64 *sstp1);
+
+void init_cxl_native(void);
+
+struct cxl_context_t *cxl_context_alloc(void);
+int cxl_context_init(struct cxl_context_t *ctx, struct cxl_afu_t *afu, bool master);
+void cxl_context_free(struct cxl_context_t *ctx);
+int cxl_context_iomap(struct cxl_context_t *ctx, struct vm_area_struct *vma);
+
+/* This matches the layout of the H_COLLECT_CA_INT_INFO retbuf */
+struct cxl_irq_info {
+	u64 dsisr;
+	u64 dar;
+	u64 dsr;
+	u32 pid;
+	u32 tid;
+	u64 afu_err;
+	u64 errstat;
+	u64 padding[3]; /* to match the expected retbuf size for plpar_hcall9 */
+};
+
+struct cxl_backend_ops {
+	int (*attach_process)(struct cxl_context_t *ctx, bool kernel, u64 wed,
+			    u64 amr);
+	int (*detach_process)(struct cxl_context_t *ctx);
+
+	int (*get_irq)(struct cxl_context_t *ctx, struct cxl_irq_info *info);
+	int (*ack_irq)(struct cxl_context_t *ctx, u64 tfc, u64 psl_reset_mask);
+
+	int (*check_error)(struct cxl_afu_t *afu);
+	void (*slbia)(struct cxl_afu_t *afu);
+	int (*afu_reset)(struct cxl_afu_t *afu);
+};
+extern const struct cxl_backend_ops *cxl_ops;
+
+void cxl_stop_trace(struct cxl_t *cxl);
+
+#endif
diff --git a/drivers/misc/cxl/debugfs.c b/drivers/misc/cxl/debugfs.c
new file mode 100644
index 0000000..f4d148c
--- /dev/null
+++ b/drivers/misc/cxl/debugfs.c
@@ -0,0 +1,116 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/debugfs.h>
+#include <linux/kernel.h>
+#include <linux/slab.h>
+
+#include "cxl.h"
+
+struct dentry *cxl_debugfs;
+
+void cxl_stop_trace(struct cxl_t *adapter)
+{
+	int slice;
+
+	/* Stop the trace */
+	cxl_p1_write(adapter, CXL_PSL_TRACE, 0x8000000000000017LL);
+
+	/* Stop the slice traces */
+	spin_lock(&adapter->afu_list_lock);
+	for (slice = 0; slice < adapter->slices; slice++) {
+		if (adapter->afu[slice])
+			cxl_p1n_write(adapter->afu[slice], CXL_PSL_SLICE_TRACE, 0x8000000000000000LL);
+	}
+	spin_unlock(&adapter->afu_list_lock);
+}
+
+int cxl_debugfs_adapter_add(struct cxl_t *adapter)
+{
+	struct dentry *dir;
+	char buf[32];
+
+	if (!cxl_debugfs)
+		return -ENODEV;
+
+	snprintf(buf, 32, "card%i", adapter->adapter_num);
+	dir = debugfs_create_dir(buf, cxl_debugfs);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+	adapter->debugfs = dir;
+
+	debugfs_create_x64("fir1",     S_IRUSR, dir, _cxl_p1_addr(adapter, CXL_PSL_FIR1));
+	debugfs_create_x64("fir2",     S_IRUSR, dir, _cxl_p1_addr(adapter, CXL_PSL_FIR2));
+	debugfs_create_x64("fir_cntl", S_IRUSR, dir, _cxl_p1_addr(adapter, CXL_PSL_FIR_CNTL));
+	debugfs_create_x64("err_ivte", S_IRUSR, dir, _cxl_p1_addr(adapter, CXL_PSL_ErrIVTE));
+
+	debugfs_create_x64("trace", S_IRUSR | S_IWUSR, dir, _cxl_p1_addr(adapter, CXL_PSL_TRACE));
+
+	return 0;
+}
+EXPORT_SYMBOL(cxl_debugfs_adapter_add);
+
+void cxl_debugfs_adapter_remove(struct cxl_t *adapter)
+{
+	debugfs_remove_recursive(adapter->debugfs);
+}
+EXPORT_SYMBOL(cxl_debugfs_adapter_remove);
+
+int cxl_debugfs_afu_add(struct cxl_afu_t *afu)
+{
+	struct dentry *dir;
+	char buf[32];
+
+	if (!afu->adapter->debugfs)
+		return -ENODEV;
+
+	snprintf(buf, 32, "psl%i.%i", afu->adapter->adapter_num, afu->slice);
+	dir = debugfs_create_dir(buf, afu->adapter->debugfs);
+	if (IS_ERR(dir))
+		return PTR_ERR(dir);
+	afu->debugfs = dir;
+
+	debugfs_create_x64("fir",        S_IRUSR, dir, _cxl_p1n_addr(afu, CXL_PSL_FIR_SLICE_An));
+	debugfs_create_x64("serr",       S_IRUSR, dir, _cxl_p1n_addr(afu, CXL_PSL_SERR_An));
+	debugfs_create_x64("afu_debug",  S_IRUSR, dir, _cxl_p1n_addr(afu, CXL_AFU_DEBUG_An));
+	debugfs_create_x64("sr",         S_IRUSR, dir, _cxl_p1n_addr(afu, CXL_PSL_SR_An));
+
+	debugfs_create_x64("dsisr",      S_IRUSR, dir, _cxl_p2n_addr(afu, CXL_PSL_DSISR_An));
+	debugfs_create_x64("dar",        S_IRUSR, dir, _cxl_p2n_addr(afu, CXL_PSL_DAR_An));
+	debugfs_create_x64("sstp0",      S_IRUSR, dir, _cxl_p2n_addr(afu, CXL_SSTP0_An));
+	debugfs_create_x64("sstp1",      S_IRUSR, dir, _cxl_p2n_addr(afu, CXL_SSTP1_An));
+	debugfs_create_x64("err_status", S_IRUSR, dir, _cxl_p2n_addr(afu, CXL_PSL_ErrStat_An));
+
+	debugfs_create_x64("trace", S_IRUSR | S_IWUSR, dir, _cxl_p1n_addr(afu, CXL_PSL_SLICE_TRACE));
+
+	return 0;
+}
+EXPORT_SYMBOL(cxl_debugfs_afu_add);
+
+void cxl_debugfs_afu_remove(struct cxl_afu_t *afu)
+{
+	debugfs_remove_recursive(afu->debugfs);
+}
+EXPORT_SYMBOL(cxl_debugfs_afu_remove);
+
+int __init cxl_debugfs_init(void)
+{
+	struct dentry *ent;
+	ent = debugfs_create_dir("cxl", NULL);
+	if (IS_ERR(ent))
+		return PTR_ERR(ent);
+	cxl_debugfs = ent;
+
+	return 0;
+}
+
+void cxl_debugfs_exit(void)
+{
+	debugfs_remove_recursive(cxl_debugfs);
+}
diff --git a/drivers/misc/cxl/fault.c b/drivers/misc/cxl/fault.c
new file mode 100644
index 0000000..f729c4a
--- /dev/null
+++ b/drivers/misc/cxl/fault.c
@@ -0,0 +1,298 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/pid.h>
+#include <linux/mm.h>
+#include <linux/moduleparam.h>
+
+#undef MODULE_PARAM_PREFIX
+#define MODULE_PARAM_PREFIX "cxl" "."
+#include <asm/current.h>
+#include <asm/copro.h>
+#include <asm/mmu.h>
+
+#include "cxl.h"
+
+bool cxl_fault_debug = false;
+
+static struct cxl_sste* find_free_sste(struct cxl_sste *primary_group,
+				       bool sec_hash,
+				       struct cxl_sste *secondary_group,
+				       unsigned int *lru)
+{
+	unsigned int i, entry;
+	struct cxl_sste *sste, *group = primary_group;
+
+	for (i = 0; i < 2; i++) {
+		for (entry = 0; entry < 8; entry++) {
+			sste = group + entry;
+			if (!(sste->esid_data & SLB_ESID_V))
+				return sste;
+		}
+		if (!sec_hash)
+			break;
+		group = secondary_group;
+	}
+	/* Nothing free, select an entry to cast out */
+	if (sec_hash && (*lru & 0x8))
+		sste = secondary_group + (*lru & 0x7);
+	else
+		sste = primary_group + (*lru & 0x7);
+	*lru = (*lru + 1) & 0xf;
+
+	return sste;
+}
+
+static void cxl_load_segment(struct cxl_context_t *ctx, u64 esid_data,
+			     u64 vsid_data)
+{
+	/* mask is the group index, we search primary and secondary here. */
+	unsigned int mask = (ctx->sst_size >> 7)-1; /* SSTP0[SegTableSize] */
+	bool sec_hash = 1;
+	struct cxl_sste *sste;
+	unsigned int hash;
+
+	WARN_ON_SMP(!spin_is_locked(&ctx->sst_lock));
+
+	sec_hash = !!(cxl_p1n_read(ctx->afu, CXL_PSL_SR_An) & CXL_PSL_SR_An_SC);
+
+	if (vsid_data & SLB_VSID_B_1T)
+		hash = (esid_data >> SID_SHIFT_1T) & mask;
+	else /* 256M */
+		hash = (esid_data >> SID_SHIFT) & mask;
+
+	sste = find_free_sste(ctx->sstp + (hash << 3), sec_hash,
+			      ctx->sstp + ((~hash & mask) << 3), &ctx->sst_lru);
+
+	pr_devel("CXL Populating SST[%li]: %#llx %#llx\n",
+			sste - ctx->sstp, vsid_data, esid_data);
+
+	sste->vsid_data = cpu_to_be64(vsid_data);
+	sste->esid_data = cpu_to_be64(esid_data);
+}
+
+static int cxl_fault_segment(struct cxl_context_t *ctx, struct mm_struct *mm,
+			     u64 ea)
+{
+	u64 vsid_data = 0, esid_data = 0;
+	unsigned long flags;
+	int rc;
+
+	spin_lock_irqsave(&ctx->sst_lock, flags);
+	if (!(rc = copro_data_segment(mm, ea, &esid_data, &vsid_data))) {
+		cxl_load_segment(ctx, esid_data, vsid_data);
+	}
+	spin_unlock_irqrestore(&ctx->sst_lock, flags);
+
+	return rc;
+}
+
+static void cxl_ack_ae(struct cxl_context_t *ctx)
+{
+	unsigned long flags;
+
+	cxl_ops->ack_irq(ctx, CXL_PSL_TFC_An_AE, 0);
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	ctx->pending_fault = true;
+	ctx->fault_addr = ctx->dar;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	wake_up_all(&ctx->wq);
+}
+
+static int cxl_handle_segment_miss(struct cxl_context_t *ctx,
+				   struct mm_struct *mm, u64 ea)
+{
+	int rc;
+
+	pr_devel("CXL interrupt: Segment fault pe: %i ea: %#llx\n", ctx->ph, ea);
+
+	if ((rc = cxl_fault_segment(ctx, mm, ea)))
+		cxl_ack_ae(ctx);
+	else {
+
+		mb(); /* Order seg table write to TFC MMIO write */
+		cxl_ops->ack_irq(ctx, CXL_PSL_TFC_An_R, 0);
+	}
+
+	return IRQ_HANDLED;
+}
+
+static void cxl_handle_page_fault(struct cxl_context_t *ctx,
+				  struct mm_struct *mm, u64 dsisr, u64 dar)
+{
+	unsigned flt = 0;
+	int result;
+	unsigned long access, flags;
+
+	if ((result = copro_handle_mm_fault(mm, dar, dsisr, &flt))) {
+		pr_devel("copro_handle_mm_fault failed: %#x\n", result);
+		return cxl_ack_ae(ctx);
+	}
+
+	/*
+	 * update_mmu_cache() will not have loaded the hash since current->trap
+	 * is not a 0x400 or 0x300, so just call hash_page_mm() here.
+	 */
+	access = _PAGE_PRESENT;
+	if (dsisr & CXL_PSL_DSISR_An_S)
+		access |= _PAGE_RW;
+	if ((!ctx->kernel) || ~(dar & (1ULL << 63)))
+		access |= _PAGE_USER;
+	local_irq_save(flags);
+	hash_page_mm(mm, dar, access, 0x300);
+	local_irq_restore(flags);
+
+	pr_devel("Page fault successfully handled for pe: %i!\n", ctx->ph);
+	cxl_ops->ack_irq(ctx, CXL_PSL_TFC_An_R, 0);
+}
+
+void cxl_handle_fault(struct work_struct *fault_work)
+{
+	struct cxl_context_t *ctx =
+		container_of(fault_work, struct cxl_context_t, fault_work);
+	u64 dsisr = ctx->dsisr;
+	u64 dar = ctx->dar;
+	struct task_struct *task;
+	struct mm_struct *mm;
+
+	if (cxl_p2n_read(ctx->afu, CXL_PSL_DSISR_An) != dsisr ||
+	    cxl_p2n_read(ctx->afu, CXL_PSL_DAR_An) != dar ||
+	    cxl_p2n_read(ctx->afu, CXL_PSL_PEHandle_An) != ctx->ph) {
+		/* Most likely explanation is harmless - a dedicated process
+		 * has detached and these were cleared by the PSL purge, but
+		 * warn about it just in case */
+		dev_notice(&ctx->afu->dev, "cxl_handle_fault: Translation fault regs changed\n");
+		return;
+	}
+
+	pr_devel("CXL BOTTOM HALF handling fault for afu pe: %i. "
+		"DSISR: %#llx DAR: %#llx\n", ctx->ph, dsisr, dar);
+
+	if (!(task = get_pid_task(ctx->pid, PIDTYPE_PID))) {
+		pr_devel("cxl_handle_fault unable to get task %i\n",
+			 pid_nr(ctx->pid));
+		cxl_ack_ae(ctx);
+		return;
+	}
+	if (!(mm = get_task_mm(task))) {
+		pr_devel("cxl_handle_fault unable to get mm %i\n",
+			 pid_nr(ctx->pid));
+		cxl_ack_ae(ctx);
+		goto out;
+	}
+
+	if (dsisr & CXL_PSL_DSISR_An_DS)
+		cxl_handle_segment_miss(ctx, mm, dar);
+	else if (dsisr & CXL_PSL_DSISR_An_DM)
+		cxl_handle_page_fault(ctx, mm, dsisr, dar);
+	else
+		WARN(1, "cxl_handle_fault has nothing to handle\n");
+
+	mmput(mm);
+out:
+	put_task_struct(task);
+}
+
+static void cxl_prefault_one(struct cxl_context_t *ctx, u64 ea)
+{
+	int rc;
+	struct task_struct *task;
+	struct mm_struct *mm;
+
+	if (!(task = get_pid_task(ctx->pid, PIDTYPE_PID))) {
+		pr_devel("cxl_prefault_one unable to get task %i\n",
+			 pid_nr(ctx->pid));
+		return;
+	}
+	if (!(mm = get_task_mm(task))) {
+		pr_devel("cxl_prefault_one unable to get mm %i\n",
+			 pid_nr(ctx->pid));
+		put_task_struct(task);
+		return;
+	}
+
+	rc = cxl_fault_segment(ctx, mm, ea);
+
+	mmput(mm);
+	put_task_struct(task);
+}
+
+static u64 next_segment(u64 ea, u64 vsid_data)
+{
+	if (vsid_data & SLB_VSID_B_1T)
+		ea |= (1ULL << 40) - 1;
+	else
+		ea |= (1ULL << 28) - 1;
+
+	return ea + 1;
+}
+
+static void cxl_prefault_vma(struct cxl_context_t *ctx)
+{
+	u64 ea, vsid_data, esid_data, last_esid_data = 0;
+	struct vm_area_struct *vma;
+	int rc;
+	struct task_struct *task;
+	struct mm_struct *mm;
+	unsigned long flags;
+
+	if (!(task = get_pid_task(ctx->pid, PIDTYPE_PID))) {
+		pr_devel("cxl_prefault_vma unable to get task %i\n",
+			 pid_nr(ctx->pid));
+		return;
+	}
+	if (!(mm = get_task_mm(task))) {
+		pr_devel("cxl_prefault_vm unable to get mm %i\n",
+			 pid_nr(ctx->pid));
+		goto out1;
+	}
+
+	spin_lock_irqsave(&ctx->sst_lock, flags);
+	down_read(&mm->mmap_sem);
+	for (vma = mm->mmap; vma; vma = vma->vm_next) {
+		for (ea = vma->vm_start; ea < vma->vm_end;
+				ea = next_segment(ea, vsid_data)) {
+			rc = copro_data_segment(mm, ea, &esid_data, &vsid_data);
+			if (rc)
+				continue;
+
+			if (last_esid_data == esid_data)
+				continue;
+
+			cxl_load_segment(ctx, esid_data, vsid_data);
+			last_esid_data = esid_data;
+		}
+	}
+	up_read(&mm->mmap_sem);
+	spin_unlock_irqrestore(&ctx->sst_lock, flags);
+
+	mmput(mm);
+out1:
+	put_task_struct(task);
+}
+
+void cxl_prefault(struct cxl_context_t *ctx, u64 wed)
+{
+	switch (ctx->afu->prefault_mode) {
+	case CXL_PREFAULT_WED:
+		cxl_prefault_one(ctx, wed);
+		break;
+	case CXL_PREFAULT_ALL:
+		cxl_prefault_vma(ctx);
+		break;
+	default:
+		break;
+	}
+}
diff --git a/drivers/misc/cxl/file.c b/drivers/misc/cxl/file.c
new file mode 100644
index 0000000..fb87ce3
--- /dev/null
+++ b/drivers/misc/cxl/file.c
@@ -0,0 +1,503 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+
+#include <linux/spinlock.h>
+#include <linux/module.h>
+#include <linux/export.h>
+#include <linux/kernel.h>
+#include <linux/bitmap.h>
+#include <linux/sched.h>
+#include <linux/poll.h>
+#include <linux/pid.h>
+#include <linux/fs.h>
+#include <linux/mm.h>
+#include <linux/slab.h>
+#include <asm/cputable.h>
+#include <asm/current.h>
+#include <asm/copro.h>
+
+#include "cxl.h"
+
+#define CXL_NUM_MINORS 256 /* Total to reserve */
+#define CXL_DEV_MINORS 9   /* 1 control + 4 AFUs * 2 (master/shared) */
+
+#define CXL_CARD_MINOR(adapter) (adapter->adapter_num * CXL_DEV_MINORS)
+#define CXL_AFU_MINOR(afu) (CXL_CARD_MINOR(afu->adapter) + 1 + (2 * afu->slice))
+#define CXL_AFU_MINOR_M(afu) (CXL_AFU_MINOR(afu) + 1)
+#define CXL_AFU_MKDEV(afu) MKDEV(MAJOR(cxl_dev), CXL_AFU_MINOR(afu))
+#define CXL_AFU_MKDEV_M(afu) MKDEV(MAJOR(cxl_dev), CXL_AFU_MINOR_M(afu))
+
+#define CXL_DEVT_ADAPTER(dev) (MINOR(dev) / CXL_DEV_MINORS)
+#define CXL_DEVT_AFU(dev) ((MINOR(dev) % CXL_DEV_MINORS - 1) / 2)
+
+#define CXL_DEVT_IS_CARD(dev) (MINOR(dev) % CXL_DEV_MINORS == 0)
+#define CXL_DEVT_IS_AFU(dev) (!CXL_DEVT_IS_CARD(dev))
+#define _CXL_DEVT_IS_AFU_S(dev) (((MINOR(dev) % CXL_DEV_MINORS) % 2) == 1)
+#define CXL_DEVT_IS_AFU_S(dev) (!CXL_DEVT_IS_CARD(dev) && _CXL_DEVT_IS_AFU_S(dev))
+#define CXL_DEVT_IS_AFU_M(dev) (!CXL_DEVT_IS_CARD(dev) && !_CXL_DEVT_IS_AFU_S(dev))
+
+dev_t cxl_dev;
+
+struct class *cxl_class;
+EXPORT_SYMBOL(cxl_class);
+
+static int __afu_open(struct inode *inode, struct file *file, bool master)
+{
+	struct cxl_t *adapter;
+	struct cxl_afu_t *afu;
+	struct cxl_context_t *ctx;
+	int adapter_num = CXL_DEVT_ADAPTER(inode->i_rdev);
+	int slice = CXL_DEVT_AFU(inode->i_rdev);
+	int rc = -ENODEV;
+
+	pr_devel("afu_open afu%i.%i\n", slice, adapter_num);
+
+	if (!(adapter = get_cxl_adapter(adapter_num)))
+		return -ENODEV;
+
+	if (!try_module_get(adapter->driver->module))
+		goto err_put_adapter;
+
+	if (slice > adapter->slices)
+		goto err_put_module;
+
+	spin_lock(&adapter->afu_list_lock);
+	if (!(afu = adapter->afu[slice])) {
+		spin_unlock(&adapter->afu_list_lock);
+		goto err_put_module;
+	}
+	get_device(&afu->dev);
+	spin_unlock(&adapter->afu_list_lock);
+
+	if (!afu->current_model)
+		goto err_put_afu;
+
+	if (!(ctx = cxl_context_alloc())) {
+		rc = -ENOMEM;
+		goto err_put_afu;
+	}
+
+	if ((rc = cxl_context_init(ctx, afu, master)))
+		goto err_put_afu;
+
+	pr_devel("afu_open pe: %i\n", ctx->ph);
+	file->private_data = ctx;
+	cxl_ctx_get();
+
+	/* Our ref on the AFU will now hold the adapter */
+	put_device(&adapter->dev);
+
+	return 0;
+
+err_put_afu:
+	put_device(&afu->dev);
+err_put_module:
+	module_put(adapter->driver->module);
+err_put_adapter:
+	put_device(&adapter->dev);
+	return rc;
+}
+static int afu_open(struct inode *inode, struct file *file)
+{
+	return __afu_open(inode, file, false);
+}
+
+static int afu_master_open(struct inode *inode, struct file *file)
+{
+	return __afu_open(inode, file, true);
+}
+
+static int afu_release(struct inode *inode, struct file *file)
+{
+	struct cxl_context_t *ctx = file->private_data;
+
+	pr_devel("%s: closing cxl file descriptor. pe: %i\n",
+		 __func__, ctx->ph);
+	cxl_context_detach(ctx);
+
+	module_put(ctx->afu->adapter->driver->module);
+
+	put_device(&ctx->afu->dev);
+
+	/* It should be safe to remove the context now */
+	cxl_context_free(ctx);
+
+	cxl_ctx_put();
+	return 0;
+}
+
+static long afu_ioctl_start_work(struct cxl_context_t *ctx,
+		     struct cxl_ioctl_start_work __user *uwork)
+{
+	struct cxl_ioctl_start_work work;
+	u64 amr;
+	int rc;
+
+	pr_devel("afu_ioctl: pe: %i CXL_START_WORK\n", ctx->ph);
+
+	if (ctx->status != OPENED)
+		return -EIO;
+
+	if (copy_from_user(&work, uwork,
+			   sizeof(struct cxl_ioctl_start_work)))
+		return -EFAULT;
+
+	if (work.reserved1 || work.reserved2 || work.reserved3 ||
+	    work.reserved4 || work.reserved5 || work.reserved6)
+		return -EINVAL;
+
+	if (work.num_interrupts == -1)
+		work.num_interrupts = ctx->afu->pp_irqs;
+	else if ((work.num_interrupts < ctx->afu->pp_irqs) ||
+		 (work.num_interrupts > ctx->afu->irqs_max))
+		return -EINVAL;
+	if ((rc = afu_register_irqs(ctx, work.num_interrupts)))
+		return rc;
+
+	amr = work.amr & mfspr(SPRN_UAMOR);
+
+	work.process_element = ctx->ph;
+
+	/* Returns PE and number of interrupts */
+	if (copy_to_user(uwork, &work,
+			 sizeof(struct cxl_ioctl_start_work)))
+		return -EFAULT;
+
+	if ((rc = cxl_ops->attach_process(ctx, false, work.wed, amr)))
+		return rc;
+
+	ctx->status = STARTED;
+
+	return 0;
+}
+
+static long afu_ioctl_check_error(struct cxl_context_t *ctx)
+{
+	if (ctx->status != STARTED)
+		return -EIO;
+
+	if (cxl_ops->check_error && cxl_ops->check_error(ctx->afu)) {
+		/* This may not be enough for some errors.  May need to PERST
+		 * the card in some cases if it's very broken.
+		 */
+		return cxl_ops->afu_reset(ctx->afu);
+	}
+	return -EPERM;
+}
+
+static long afu_ioctl(struct file *file, unsigned int cmd, unsigned long arg)
+{
+	struct cxl_context_t *ctx = file->private_data;
+
+	if (ctx->status == CLOSED)
+		return -EIO;
+
+	pr_devel("afu_ioctl\n");
+	switch (cmd) {
+	case CXL_IOCTL_START_WORK:
+		return afu_ioctl_start_work(ctx,
+			(struct cxl_ioctl_start_work __user *)arg);
+	case CXL_IOCTL_CHECK_ERROR:
+		return afu_ioctl_check_error(ctx);
+	}
+	return -EINVAL;
+}
+
+static long afu_compat_ioctl(struct file *file, unsigned int cmd,
+			     unsigned long arg)
+{
+	return afu_ioctl(file, cmd, arg);
+}
+
+static int afu_mmap(struct file *file, struct vm_area_struct *vm)
+{
+	struct cxl_context_t *ctx = file->private_data;
+
+	/* AFU must be started before we can MMIO */
+	if (ctx->status != STARTED)
+		return -EIO;
+
+	return cxl_context_iomap(ctx, vm);
+}
+
+static unsigned int afu_poll(struct file *file, struct poll_table_struct *poll)
+{
+	struct cxl_context_t *ctx = file->private_data;
+	int mask = 0;
+	unsigned long flags;
+
+
+	poll_wait(file, &ctx->wq, poll);
+
+	pr_devel("afu_poll wait done pe: %i\n", ctx->ph);
+
+	spin_lock_irqsave(&ctx->lock, flags);
+	if (ctx->pending_irq || ctx->pending_fault ||
+	    ctx->pending_afu_err)
+		mask |= POLLIN | POLLRDNORM;
+	else if (ctx->status == CLOSED)
+		/* Only error on closed when there are no futher events pending
+		 */
+		mask |= POLLERR;
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	pr_devel("afu_poll pe: %i returning %#x\n", ctx->ph, mask);
+
+	return mask;
+}
+
+static ssize_t afu_read(struct file *file, char __user *buf, size_t count,
+			loff_t *off)
+{
+	struct cxl_context_t *ctx = file->private_data;
+	struct cxl_event event;
+	unsigned long flags;
+	ssize_t size;
+	DEFINE_WAIT(wait);
+
+	if (count < sizeof(struct cxl_event_header))
+		return -EINVAL;
+
+	while (1) {
+		spin_lock_irqsave(&ctx->lock, flags);
+		if (ctx->pending_irq || ctx->pending_fault ||
+		    ctx->pending_afu_err || (ctx->status == CLOSED))
+			break;
+		spin_unlock_irqrestore(&ctx->lock, flags);
+
+		if (file->f_flags & O_NONBLOCK)
+			return -EAGAIN;
+
+		prepare_to_wait(&ctx->wq, &wait, TASK_INTERRUPTIBLE);
+		if (!(ctx->pending_irq || ctx->pending_fault ||
+		      ctx->pending_afu_err || (ctx->status == CLOSED))) {
+			pr_devel("afu_read going to sleep...\n");
+			schedule();
+			pr_devel("afu_read woken up\n");
+		}
+		finish_wait(&ctx->wq, &wait);
+
+		if (signal_pending(current))
+			return -ERESTARTSYS;
+	}
+
+	memset(&event, 0, sizeof(event));
+	event.header.process_element = ctx->ph;
+	if (ctx->pending_irq) {
+		pr_devel("afu_read delivering AFU interrupt\n");
+		event.header.size = sizeof(struct cxl_event_afu_interrupt);
+		event.header.type = CXL_EVENT_AFU_INTERRUPT;
+		event.irq.irq = find_first_bit(ctx->irq_bitmap, ctx->irq_count) + 1;
+
+		/* Only clear the IRQ if we can send the whole event: */
+		if (count >= event.header.size) {
+			clear_bit(event.irq.irq - 1, ctx->irq_bitmap);
+			if (bitmap_empty(ctx->irq_bitmap, ctx->irq_count))
+				ctx->pending_irq = false;
+		}
+	} else if (ctx->pending_fault) {
+		pr_devel("afu_read delivering data storage fault\n");
+		event.header.size = sizeof(struct cxl_event_data_storage);
+		event.header.type = CXL_EVENT_DATA_STORAGE;
+		event.fault.addr = ctx->fault_addr;
+
+		/* Only clear the fault if we can send the whole event: */
+		if (count >= event.header.size)
+			ctx->pending_fault = false;
+	} else if (ctx->pending_afu_err) {
+		pr_devel("afu_read delivering afu error\n");
+		event.header.size = sizeof(struct cxl_event_afu_error);
+		event.header.type = CXL_EVENT_AFU_ERROR;
+		event.afu_err.err = ctx->afu_err;
+
+		/* Only clear the fault if we can send the whole event: */
+		if (count >= event.header.size)
+			ctx->pending_afu_err = false;
+	} else if (ctx->status == CLOSED) {
+		pr_devel("afu_read fatal error\n");
+		spin_unlock_irqrestore(&ctx->lock, flags);
+		return -EIO;
+	} else
+		WARN(1, "afu_read must be buggy\n");
+
+	spin_unlock_irqrestore(&ctx->lock, flags);
+
+	size = min_t(size_t, count, event.header.size);
+	copy_to_user(buf, &event, size);
+
+	return size;
+}
+
+static const struct file_operations afu_fops = {
+	.owner		= THIS_MODULE,
+	.open           = afu_open,
+	.poll		= afu_poll,
+	.read		= afu_read,
+	.release        = afu_release,
+	.unlocked_ioctl = afu_ioctl,
+	.compat_ioctl   = afu_compat_ioctl,
+	.mmap           = afu_mmap,
+};
+
+static const struct file_operations afu_master_fops = {
+	.owner		= THIS_MODULE,
+	.open           = afu_master_open,
+	.poll		= afu_poll,
+	.read		= afu_read,
+	.release        = afu_release,
+	.unlocked_ioctl = afu_ioctl,
+	.compat_ioctl   = afu_compat_ioctl,
+	.mmap           = afu_mmap,
+};
+
+
+static char *cxl_devnode(struct device *dev, umode_t *mode)
+{
+	struct cxl_afu_t *afu;
+
+	if (CXL_DEVT_IS_CARD(dev->devt)) {
+		/* These minor numbers will eventually be used to program the
+		 * PSL and AFUs once we have dynamic reprogramming support */
+		return NULL;
+	} else { /* CXL_DEVT_IS_AFU */
+		/* Default character devices in each programming model just get
+		 * named /dev/cxl/afuX.Y */
+		afu = dev_get_drvdata(dev);
+		if ((afu->current_model == CXL_MODEL_DEDICATED) &&
+				CXL_DEVT_IS_AFU_M(dev->devt))
+			return kasprintf(GFP_KERNEL, "cxl/%s", dev_name(&afu->dev));
+		if ((afu->current_model == CXL_MODEL_DIRECTED) &&
+				CXL_DEVT_IS_AFU_S(dev->devt))
+			return kasprintf(GFP_KERNEL, "cxl/%s", dev_name(&afu->dev));
+	}
+	return kasprintf(GFP_KERNEL, "cxl/%s", dev_name(dev));
+}
+
+extern struct class *cxl_class;
+
+int cxl_chardev_m_afu_add(struct cxl_afu_t *afu)
+{
+	struct device *dev;
+	int rc;
+
+	cdev_init(&afu->afu_cdev_m, &afu_master_fops);
+	if ((rc = cdev_add(&afu->afu_cdev_m, CXL_AFU_MKDEV_M(afu), 1))) {
+		dev_err(&afu->dev, "Unable to add master chardev: %i\n", rc);
+		return rc;
+	}
+
+	dev = device_create(cxl_class, &afu->dev, CXL_AFU_MKDEV_M(afu), afu,
+			"afu%i.%im", afu->adapter->adapter_num, afu->slice);
+	if (IS_ERR(dev)) {
+		dev_err(&afu->dev, "Unable to create master chardev in sysfs: %i\n", rc);
+		rc = PTR_ERR(dev);
+		goto err;
+	}
+
+	afu->chardev_m = dev;
+
+	return 0;
+err:
+	cdev_del(&afu->afu_cdev_m);
+	return rc;
+}
+
+int cxl_chardev_s_afu_add(struct cxl_afu_t *afu)
+{
+	struct device *dev;
+	int rc;
+
+	cdev_init(&afu->afu_cdev_s, &afu_fops);
+	if ((rc = cdev_add(&afu->afu_cdev_s, CXL_AFU_MKDEV(afu), 1))) {
+		dev_err(&afu->dev, "Unable to add shared chardev: %i\n", rc);
+		return rc;
+	}
+
+	dev = device_create(cxl_class, &afu->dev, CXL_AFU_MKDEV(afu), afu,
+			"afu%i.%is", afu->adapter->adapter_num, afu->slice);
+	if (IS_ERR(dev)) {
+		dev_err(&afu->dev, "Unable to create shared chardev in sysfs: %i\n", rc);
+		rc = PTR_ERR(dev);
+		goto err;
+	}
+
+	afu->chardev_s = dev;
+
+	return 0;
+err:
+	cdev_del(&afu->afu_cdev_s);
+	return rc;
+}
+
+void cxl_chardev_afu_remove(struct cxl_afu_t *afu)
+{
+	if (afu->chardev_m) {
+		cdev_del(&afu->afu_cdev_m);
+		device_unregister(afu->chardev_m);
+	}
+	if (afu->chardev_s) {
+		cdev_del(&afu->afu_cdev_s);
+		device_unregister(afu->chardev_s);
+	}
+}
+
+int cxl_register_afu(struct cxl_afu_t *afu)
+{
+	afu->dev.class = cxl_class;
+
+	return device_register(&afu->dev);
+}
+EXPORT_SYMBOL(cxl_register_afu);
+
+int cxl_register_adapter(struct cxl_t *adapter)
+{
+	adapter->dev.class = cxl_class;
+
+	/* Future: When we support dynamically reprogramming the PSL & AFU we
+	 * will expose the interface to do that via a chardev:
+	 * adapter->dev.devt = CXL_CARD_MKDEV(adapter);
+	 */
+
+	return device_register(&adapter->dev);
+}
+EXPORT_SYMBOL(cxl_register_adapter);
+
+int __init cxl_file_init(void)
+{
+	int rc;
+
+	if ((rc = alloc_chrdev_region(&cxl_dev, 0, CXL_NUM_MINORS, "cxl"))) {
+		pr_err("Unable to allocate CXL major number: %i\n", rc);
+		return rc;
+	}
+
+	pr_devel("CXL device allocated, MAJOR %i\n", MAJOR(cxl_dev));
+
+	cxl_class = class_create(THIS_MODULE, "cxl");
+	if (IS_ERR(cxl_class)) {
+		pr_err("Unable to create CXL class\n");
+		rc = PTR_ERR(cxl_class);
+		goto err;
+	}
+	cxl_class->devnode = cxl_devnode;
+
+	return 0;
+
+err:
+	unregister_chrdev_region(cxl_dev, CXL_NUM_MINORS);
+	return rc;
+}
+
+void cxl_file_exit(void)
+{
+	unregister_chrdev_region(cxl_dev, CXL_NUM_MINORS);
+	class_destroy(cxl_class);
+}
diff --git a/drivers/misc/cxl/irq.c b/drivers/misc/cxl/irq.c
new file mode 100644
index 0000000..3e01e1d
--- /dev/null
+++ b/drivers/misc/cxl/irq.c
@@ -0,0 +1,405 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+
+#include <linux/interrupt.h>
+#include <linux/workqueue.h>
+#include <linux/sched.h>
+#include <linux/wait.h>
+#include <linux/slab.h>
+#include <linux/pid.h>
+#include <asm/cputable.h>
+#include <misc/cxl.h>
+
+#include "cxl.h"
+
+/* XXX: This is implementation specific */
+static irqreturn_t handle_psl_slice_error(struct cxl_context_t *ctx, u64 dsisr, u64 errstat)
+{
+	u64 fir1, fir2, fir_slice, serr, afu_debug;
+
+	fir1 = cxl_p1_read(ctx->afu->adapter, CXL_PSL_FIR1);
+	fir2 = cxl_p1_read(ctx->afu->adapter, CXL_PSL_FIR2);
+	fir_slice = cxl_p1n_read(ctx->afu, CXL_PSL_FIR_SLICE_An);
+	serr = cxl_p1n_read(ctx->afu, CXL_PSL_SERR_An);
+	afu_debug = cxl_p1n_read(ctx->afu, CXL_AFU_DEBUG_An);
+
+	dev_crit(&ctx->afu->dev, "PSL ERROR STATUS: 0x%.16llx\n", errstat);
+	dev_crit(&ctx->afu->dev, "PSL_FIR1: 0x%.16llx\n", fir1);
+	dev_crit(&ctx->afu->dev, "PSL_FIR2: 0x%.16llx\n", fir2);
+	dev_crit(&ctx->afu->dev, "PSL_SERR_An: 0x%.16llx\n", serr);
+	dev_crit(&ctx->afu->dev, "PSL_FIR_SLICE_An: 0x%.16llx\n", fir_slice);
+	dev_crit(&ctx->afu->dev, "CXL_PSL_AFU_DEBUG_An: 0x%.16llx\n", afu_debug);
+
+	dev_crit(&ctx->afu->dev, "STOPPING CXL TRACE\n");
+	cxl_stop_trace(ctx->afu->adapter);
+
+	return cxl_ops->ack_irq(ctx, 0, errstat);
+}
+
+irqreturn_t cxl_slice_irq_err(int irq, void *data)
+{
+	struct cxl_afu_t *afu = data;
+	u64 fir_slice, errstat, serr, afu_debug;
+
+	WARN(irq, "CXL SLICE ERROR interrupt %i\n", irq);
+
+	serr = cxl_p1n_read(afu, CXL_PSL_SERR_An);
+	fir_slice = cxl_p1n_read(afu, CXL_PSL_FIR_SLICE_An);
+	errstat = cxl_p2n_read(afu, CXL_PSL_ErrStat_An);
+	afu_debug = cxl_p1n_read(afu, CXL_AFU_DEBUG_An);
+	dev_crit(&afu->dev, "PSL_SERR_An: 0x%.16llx\n", serr);
+	dev_crit(&afu->dev, "PSL_FIR_SLICE_An: 0x%.16llx\n", fir_slice);
+	dev_crit(&afu->dev, "CXL_PSL_ErrStat_An: 0x%.16llx\n", errstat);
+	dev_crit(&afu->dev, "CXL_PSL_AFU_DEBUG_An: 0x%.16llx\n", afu_debug);
+
+	cxl_p1n_write(afu, CXL_PSL_SERR_An, serr);
+
+	return IRQ_HANDLED;
+}
+
+irqreturn_t cxl_irq_err(int irq, void *data)
+{
+	struct cxl_t *adapter = data;
+	u64 fir1, fir2, err_ivte;
+
+	WARN(1, "CXL ERROR interrupt %i\n", irq);
+
+	err_ivte = cxl_p1_read(adapter, CXL_PSL_ErrIVTE);
+	dev_crit(&adapter->dev, "PSL_ErrIVTE: 0x%.16llx\n", err_ivte);
+
+	dev_crit(&adapter->dev, "STOPPING CXL TRACE\n");
+	cxl_stop_trace(adapter);
+
+	fir1 = cxl_p1_read(adapter, CXL_PSL_FIR1);
+	fir2 = cxl_p1_read(adapter, CXL_PSL_FIR2);
+
+	dev_crit(&adapter->dev, "PSL_FIR1: 0x%.16llx\nPSL_FIR2: 0x%.16llx\n", fir1, fir2);
+
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t schedule_cxl_fault(struct cxl_context_t *ctx, u64 dsisr, u64 dar)
+{
+	ctx->dsisr = dsisr;
+	ctx->dar = dar;
+	schedule_work(&ctx->fault_work);
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cxl_irq(int irq, void *data)
+{
+	struct cxl_context_t *ctx = data;
+	struct cxl_irq_info irq_info;
+	u64 dsisr, dar;
+	int result;
+
+	if ((result = cxl_ops->get_irq(ctx, &irq_info))) {
+		WARN(1, "Unable to get CXL IRQ Info: %i\n", result);
+		return IRQ_HANDLED;
+	}
+
+	dsisr = irq_info.dsisr;
+	dar = irq_info.dar;
+
+	pr_devel("CXL interrupt %i for afu pe: %i DSISR: %#llx DAR: %#llx\n", irq, ctx->ph, dsisr, dar);
+
+	if (dsisr & CXL_PSL_DSISR_An_DS) {
+		/* We don't inherently need to sleep to handle this, but we do
+		 * need to get a ref to the task's mm, which we can't do from
+		 * irq context without the potential for a deadlock since it
+		 * takes the task_lock. An alternate option would be to keep a
+		 * reference to the task's mm the entire time it has cxl open,
+		 * but to do that we need to solve the issue where we hold a
+		 * ref to the mm, but the mm can hold a ref to the fd after an
+		 * mmap preventing anything from being cleaned up. */
+		pr_devel("Scheduling segment miss handling for later pe: %i\n", ctx->ph);
+		return schedule_cxl_fault(ctx, dsisr, dar);
+	}
+
+	if (dsisr & CXL_PSL_DSISR_An_M)
+		pr_devel("CXL interrupt: PTE not found\n");
+	if (dsisr & CXL_PSL_DSISR_An_P)
+		pr_devel("CXL interrupt: Storage protection violation\n");
+	if (dsisr & CXL_PSL_DSISR_An_A)
+		pr_devel("CXL interrupt: AFU lock access to write through or cache inhibited storage\n");
+	if (dsisr & CXL_PSL_DSISR_An_S)
+		pr_devel("CXL interrupt: Access was afu_wr or afu_zero\n");
+	if (dsisr & CXL_PSL_DSISR_An_K)
+		pr_devel("CXL interrupt: Access not permitted by virtual page class key protection\n");
+
+	if (dsisr & CXL_PSL_DSISR_An_DM) {
+		/* In some cases we might be able to handle the fault
+		 * immediately if hash_page would succeed, but we still need
+		 * the task's mm, which as above we can't get without a lock */
+		pr_devel("Scheduling page fault handling for later pe: %i\n", ctx->ph);
+		return schedule_cxl_fault(ctx, dsisr, dar);
+	}
+	if (dsisr & CXL_PSL_DSISR_An_ST)
+		WARN(1, "CXL interrupt: Segment Table PTE not found\n");
+	if (dsisr & CXL_PSL_DSISR_An_UR)
+		pr_devel("CXL interrupt: AURP PTE not found\n");
+	if (dsisr & CXL_PSL_DSISR_An_PE)
+		return handle_psl_slice_error(ctx, dsisr, irq_info.errstat);
+	if (dsisr & CXL_PSL_DSISR_An_AE) {
+		pr_devel("CXL interrupt: AFU Error %.llx\n", irq_info.afu_err);
+
+		if (ctx->pending_afu_err) {
+			/* This shouldn't happen - the PSL treats these errors
+			 * as fatal and will have reset the AFU, so there's not
+			 * much point buffering multiple AFU errors.
+			 * OTOH if we DO ever see a storm of these come in it's
+			 * probably best that we log them somewhere: */
+			dev_err_ratelimited(&ctx->afu->dev, "CXL AFU Error "
+					    "undelivered to pe %i: %.llx\n",
+					    ctx->ph, irq_info.afu_err);
+		} else {
+			spin_lock(&ctx->lock);
+			ctx->afu_err = irq_info.afu_err;
+			ctx->pending_afu_err = 1;
+			spin_unlock(&ctx->lock);
+
+			wake_up_all(&ctx->wq);
+		}
+
+		cxl_ops->ack_irq(ctx, CXL_PSL_TFC_An_A, 0);
+	}
+	if (dsisr & CXL_PSL_DSISR_An_OC)
+		pr_devel("CXL interrupt: OS Context Warning\n");
+
+	WARN(1, "Unhandled CXL PSL IRQ\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cxl_irq_multiplexed(int irq, void *data)
+{
+	struct cxl_afu_t *afu = data;
+	struct cxl_context_t *ctx;
+	int ph = cxl_p2n_read(afu, CXL_PSL_PEHandle_An) & 0xffff;
+	int ret;
+
+	rcu_read_lock();
+	ctx = idr_find(&afu->contexts_idr, ph);
+	if (ctx) {
+		ret = cxl_irq(irq, ctx);
+		rcu_read_unlock();
+		return ret;
+	}
+	rcu_read_unlock();
+
+	WARN(1, "Unable to demultiplex CXL PSL IRQ\n");
+	return IRQ_HANDLED;
+}
+
+static irqreturn_t cxl_irq_afu(int irq, void *data)
+{
+	struct cxl_context_t *ctx = data;
+	irq_hw_number_t hwirq = irqd_to_hwirq(irq_get_irq_data(irq));
+	int irq_off, afu_irq = 1;
+	__u16 range;
+	int r;
+
+	for (r = 1; r < CXL_IRQ_RANGES; r++) {
+		irq_off = hwirq - ctx->irqs.offset[r];
+		range = ctx->irqs.range[r];
+		if (irq_off >= 0 && irq_off < range) {
+			afu_irq += irq_off;
+			break;
+		}
+		afu_irq += range;
+	}
+	if (unlikely(r >= CXL_IRQ_RANGES)) {
+		WARN(1, "Recieved AFU IRQ out of range for pe %i (virq %i hwirq %lx)\n",
+		     ctx->ph, irq, hwirq);
+		return IRQ_HANDLED;
+	}
+
+	pr_devel("Received AFU interrupt %i for pe: %i (virq %i hwirq %lx)\n",
+	       afu_irq, ctx->ph, irq, hwirq);
+
+	if (unlikely(!ctx->irq_bitmap)) {
+		WARN(1, "Recieved AFU IRQ for context with no IRQ bitmap\n");
+		return IRQ_HANDLED;
+	}
+	spin_lock(&ctx->lock);
+	set_bit(afu_irq - 1, ctx->irq_bitmap);
+	ctx->pending_irq = true;
+	spin_unlock(&ctx->lock);
+
+	wake_up_all(&ctx->wq);
+
+	return IRQ_HANDLED;
+}
+
+unsigned int cxl_map_irq(struct cxl_t *adapter, irq_hw_number_t hwirq,
+			 irq_handler_t handler, void *cookie)
+{
+	unsigned int virq;
+	int result;
+
+	/* IRQ Domain? */
+	virq = irq_create_mapping(NULL, hwirq);
+	if (!virq) {
+		dev_warn(&adapter->dev, "cxl_map_irq: irq_create_mapping failed\n");
+		return 0;
+	}
+
+	if (adapter->driver->setup_irq)
+		adapter->driver->setup_irq(adapter, hwirq, virq);
+
+	pr_devel("hwirq %#lx mapped to virq %u\n", hwirq, virq);
+
+	result = request_irq(virq, handler, 0, "cxl", cookie);
+	if (result) {
+		dev_warn(&adapter->dev, "cxl_map_irq: request_irq failed: %i\n", result);
+		return 0;
+	}
+
+	return virq;
+}
+
+void cxl_unmap_irq(unsigned int virq, void *cookie)
+{
+	free_irq(virq, cookie);
+	irq_dispose_mapping(virq);
+}
+
+static int cxl_register_one_irq(struct cxl_t *adapter,
+				irq_handler_t handler,
+				void *cookie,
+				irq_hw_number_t *dest_hwirq,
+				unsigned int *dest_virq)
+{
+	int hwirq, virq;
+
+	if ((hwirq = adapter->driver->alloc_one_irq(adapter)) < 0)
+		return hwirq;
+
+	if (!(virq = cxl_map_irq(adapter, hwirq, handler, cookie)))
+		goto err;
+
+	*dest_hwirq = hwirq;
+	*dest_virq = virq;
+
+	return 0;
+
+err:
+	adapter->driver->release_one_irq(adapter, hwirq);
+	return -ENOMEM;
+}
+
+int cxl_register_psl_err_irq(struct cxl_t *adapter)
+{
+	int rc;
+
+	if ((rc = cxl_register_one_irq(adapter, cxl_irq_err, adapter,
+				       &adapter->err_hwirq,
+				       &adapter->err_virq)))
+		return rc;
+
+	cxl_p1_write(adapter, CXL_PSL_ErrIVTE, adapter->err_hwirq & 0xffff);
+
+	return 0;
+}
+EXPORT_SYMBOL(cxl_register_psl_err_irq);
+
+void cxl_release_psl_err_irq(struct cxl_t *adapter)
+{
+	cxl_p1_write(adapter, CXL_PSL_ErrIVTE, 0x0000000000000000);
+	cxl_unmap_irq(adapter->err_virq, adapter);
+	adapter->driver->release_one_irq(adapter, adapter->err_hwirq);
+}
+EXPORT_SYMBOL(cxl_release_psl_err_irq);
+
+int cxl_register_serr_irq(struct cxl_afu_t *afu)
+{
+	u64 serr;
+	int rc;
+
+	if ((rc = cxl_register_one_irq(afu->adapter, cxl_slice_irq_err, afu,
+				       &afu->serr_hwirq,
+				       &afu->serr_virq)))
+		return rc;
+
+	serr = cxl_p1n_read(afu, CXL_PSL_SERR_An);
+	serr = (serr & 0x00ffffffffff0000ULL) | (afu->serr_hwirq & 0xffff);
+	cxl_p1n_write(afu, CXL_PSL_SERR_An, serr);
+
+	return 0;
+}
+EXPORT_SYMBOL(cxl_register_serr_irq);
+
+void cxl_release_serr_irq(struct cxl_afu_t *afu)
+{
+	cxl_p1n_write(afu, CXL_PSL_SERR_An, 0x0000000000000000);
+	cxl_unmap_irq(afu->serr_virq, afu);
+	afu->adapter->driver->release_one_irq(afu->adapter, afu->serr_hwirq);
+}
+EXPORT_SYMBOL(cxl_release_serr_irq);
+
+int cxl_register_psl_irq(struct cxl_afu_t *afu)
+{
+	return cxl_register_one_irq(afu->adapter, cxl_irq_multiplexed, afu,
+			&afu->psl_hwirq, &afu->psl_virq);
+}
+EXPORT_SYMBOL(cxl_register_psl_irq);
+
+void cxl_release_psl_irq(struct cxl_afu_t *afu)
+{
+	cxl_unmap_irq(afu->psl_virq, afu);
+	afu->adapter->driver->release_one_irq(afu->adapter, afu->psl_hwirq);
+}
+EXPORT_SYMBOL(cxl_release_psl_irq);
+
+int afu_register_irqs(struct cxl_context_t *ctx, u32 count)
+{
+	irq_hw_number_t hwirq;
+	int rc, r, i;
+
+	if ((rc = ctx->afu->adapter->driver->alloc_irq_ranges(&ctx->irqs, ctx->afu->adapter, count)))
+		return rc;
+
+	/* Multiplexed PSL Interrupt */
+	ctx->irqs.offset[0] = ctx->afu->psl_hwirq;
+	ctx->irqs.range[0] = 1;
+
+	ctx->irq_count = count;
+	ctx->irq_bitmap = kcalloc(BITS_TO_LONGS(count),
+				  sizeof(*ctx->irq_bitmap), GFP_KERNEL);
+	if (!ctx->irq_bitmap)
+		return -ENOMEM;
+	for (r = 1; r < CXL_IRQ_RANGES; r++) {
+		hwirq = ctx->irqs.offset[r];
+		for (i = 0; i < ctx->irqs.range[r]; hwirq++, i++) {
+			cxl_map_irq(ctx->afu->adapter, hwirq,
+				     cxl_irq_afu, ctx);
+		}
+	}
+
+	return 0;
+}
+
+void afu_release_irqs(struct cxl_context_t *ctx)
+{
+	irq_hw_number_t hwirq;
+	unsigned int virq;
+	int r, i;
+
+	for (r = 1; r < CXL_IRQ_RANGES; r++) {
+		hwirq = ctx->irqs.offset[r];
+		for (i = 0; i < ctx->irqs.range[r]; hwirq++, i++) {
+			virq = irq_find_mapping(NULL, hwirq);
+			if (virq)
+				cxl_unmap_irq(virq, ctx);
+		}
+	}
+
+	ctx->afu->adapter->driver->release_irq_ranges(&ctx->irqs, ctx->afu->adapter);
+}
diff --git a/drivers/misc/cxl/main.c b/drivers/misc/cxl/main.c
new file mode 100644
index 0000000..fb0e0fc
--- /dev/null
+++ b/drivers/misc/cxl/main.c
@@ -0,0 +1,238 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+
+#include <linux/spinlock.h>
+#include <linux/kernel.h>
+#include <linux/module.h>
+#include <linux/device.h>
+#include <linux/mutex.h>
+#include <linux/init.h>
+#include <linux/list.h>
+#include <linux/mm.h>
+#include <linux/of.h>
+#include <linux/slab.h>
+#include <linux/idr.h>
+#include <asm/cputable.h>
+#include <misc/cxl.h>
+
+#include "cxl.h"
+
+static DEFINE_SPINLOCK(adapter_idr_lock);
+static DEFINE_IDR(cxl_adapter_idr);
+
+const struct cxl_backend_ops *cxl_ops;
+EXPORT_SYMBOL(cxl_ops);
+
+uint cxl_verbose;
+EXPORT_SYMBOL(cxl_verbose);
+module_param_named(verbose, cxl_verbose, uint, 0600);
+MODULE_PARM_DESC(verbose, "Enable verbose dmesg output");
+
+static inline void cxl_slbia_core(struct mm_struct *mm)
+{
+	struct cxl_t *adapter;
+	struct cxl_afu_t *afu;
+	struct cxl_context_t *ctx;
+	struct task_struct *task;
+	unsigned long flags;
+	int card, slice, id;
+
+	pr_devel("%s called\n", __func__);
+
+	spin_lock(&adapter_idr_lock);
+	idr_for_each_entry(&cxl_adapter_idr, adapter, card) {
+		/* XXX: Make this lookup faster with link from mm to ctx */
+		spin_lock(&adapter->afu_list_lock);
+		for (slice = 0; slice < adapter->slices; slice++) {
+			afu = adapter->afu[slice];
+			if (!afu->enabled)
+				continue;
+			rcu_read_lock();
+			idr_for_each_entry(&afu->contexts_idr, ctx, id) {
+				if (!(task = get_pid_task(ctx->pid, PIDTYPE_PID))) {
+					pr_devel("%s unable to get task %i\n",
+						 __func__, pid_nr(ctx->pid));
+					continue;
+				}
+
+				if (task->mm != mm)
+					goto next;
+
+				pr_devel("%s matched mm - card: %i afu: %i pe: %i\n",
+					 __func__, adapter->adapter_num, slice, ctx->ph);
+
+				spin_lock_irqsave(&ctx->sst_lock, flags);
+				if (!ctx->sstp)
+					goto next_unlock;
+				memset(ctx->sstp, 0, ctx->sst_size);
+				mb();
+				cxl_ops->slbia(afu);
+
+next_unlock:
+				spin_unlock_irqrestore(&ctx->sst_lock, flags);
+next:
+				put_task_struct(task);
+			}
+			rcu_read_unlock();
+		}
+		spin_unlock(&adapter->afu_list_lock);
+	}
+	spin_unlock(&adapter_idr_lock);
+}
+
+struct cxl_calls cxl_calls = {
+	.cxl_slbia = cxl_slbia_core,
+	.owner = THIS_MODULE,
+};
+
+int cxl_alloc_sst(struct cxl_context_t *ctx, u64 *sstp0, u64 *sstp1)
+{
+	unsigned long vsid, flags;
+	u64 ea_mask;
+	u64 size;
+
+	*sstp0 = 0;
+	*sstp1 = 0;
+
+	ctx->sst_size = PAGE_SIZE;
+	ctx->sst_lru = 0;
+	if (!ctx->sstp) {
+		ctx->sstp = (struct cxl_sste *)get_zeroed_page(GFP_KERNEL);
+		pr_devel("SSTP allocated at 0x%p\n", ctx->sstp);
+	} else {
+		pr_devel("Zeroing and reusing SSTP already allocated at 0x%p\n", ctx->sstp);
+		spin_lock_irqsave(&ctx->sst_lock, flags);
+		memset(ctx->sstp, 0, PAGE_SIZE);
+		cxl_ops->slbia(ctx->afu);
+		spin_unlock_irqrestore(&ctx->sst_lock, flags);
+	}
+	if (!ctx->sstp) {
+		pr_err("cxl_alloc_sst: Unable to allocate segment table\n");
+		return -ENOMEM;
+	}
+
+	vsid  = get_kernel_vsid((u64)ctx->sstp, mmu_kernel_ssize) << 12;
+
+	*sstp0 |= (u64)mmu_kernel_ssize << CXL_SSTP0_An_B_SHIFT;
+	*sstp0 |= (SLB_VSID_KERNEL | mmu_psize_defs[mmu_linear_psize].sllp) << 50;
+
+	size = (((u64)ctx->sst_size >> 8) - 1) << CXL_SSTP0_An_SegTableSize_SHIFT;
+	if (unlikely(size & ~CXL_SSTP0_An_SegTableSize_MASK)) {
+		WARN(1, "Impossible segment table size\n");
+		return -EINVAL;
+	}
+	*sstp0 |= size;
+
+	if (mmu_kernel_ssize == MMU_SEGSIZE_256M)
+		ea_mask = 0xfffff00ULL;
+	else
+		ea_mask = 0xffffffff00ULL;
+
+	*sstp0 |=  vsid >>     (50-14);  /*   Top 14 bits of VSID */
+	*sstp1 |= (vsid << (64-(50-14))) & ~ea_mask;
+	*sstp1 |= (u64)ctx->sstp & ea_mask;
+	*sstp1 |= CXL_SSTP1_An_V;
+
+	pr_devel("Looked up %#llx: slbfee. %#llx (ssize: %x, vsid: %#lx), copied to SSTP0: %#llx, SSTP1: %#llx\n",
+			(u64)ctx->sstp, (u64)ctx->sstp & ESID_MASK, mmu_kernel_ssize, vsid, *sstp0, *sstp1);
+
+	return 0;
+}
+
+/* Find a CXL adapter by it's number and increase it's refcount */
+struct cxl_t *get_cxl_adapter(int num)
+{
+	struct cxl_t *adapter;
+
+	spin_lock(&adapter_idr_lock);
+	if ((adapter = idr_find(&cxl_adapter_idr, num)))
+		get_device(&adapter->dev);
+	spin_unlock(&adapter_idr_lock);
+
+	return adapter;
+}
+
+int cxl_alloc_adapter_nr(struct cxl_t *adapter)
+{
+	int i;
+
+	idr_preload(GFP_KERNEL);
+	spin_lock(&adapter_idr_lock);
+	i = idr_alloc(&cxl_adapter_idr, adapter, 0, 0, GFP_NOWAIT);
+	spin_unlock(&adapter_idr_lock);
+	idr_preload_end();
+	if (i < 0)
+		return i;
+
+	adapter->adapter_num = i;
+
+	return 0;
+}
+EXPORT_SYMBOL(cxl_alloc_adapter_nr);
+
+void cxl_remove_adapter_nr(struct cxl_t *adapter)
+{
+	idr_remove(&cxl_adapter_idr, adapter->adapter_num);
+}
+EXPORT_SYMBOL(cxl_remove_adapter_nr);
+
+int cxl_afu_select_best_model(struct cxl_afu_t *afu)
+{
+	if (afu->models_supported & CXL_MODEL_DIRECTED)
+		return cxl_afu_activate_model(afu, CXL_MODEL_DIRECTED);
+
+	if (afu->models_supported & CXL_MODEL_DEDICATED)
+		return cxl_afu_activate_model(afu, CXL_MODEL_DEDICATED);
+
+	dev_warn(&afu->dev, "No supported programing models available\n");
+	/* We don't fail this so the user can inspect sysfs */
+	return 0;
+}
+EXPORT_SYMBOL(cxl_afu_select_best_model);
+
+static int __init init_cxl(void)
+{
+	int rc = 0;
+
+	if (!cpu_has_feature(CPU_FTR_HVMODE))
+		return -EPERM;
+
+	if ((rc = cxl_file_init()))
+		return rc;
+
+	cxl_debugfs_init();
+	init_cxl_native();
+
+	if ((rc = register_cxl_calls(&cxl_calls)))
+		goto err;
+
+	return 0;
+
+err:
+	cxl_debugfs_exit();
+	cxl_file_exit();
+
+	return rc;
+}
+
+static void exit_cxl(void)
+{
+	cxl_debugfs_exit();
+	cxl_file_exit();
+	unregister_cxl_calls(&cxl_calls);
+}
+
+module_init(init_cxl);
+module_exit(exit_cxl);
+
+MODULE_DESCRIPTION("IBM Coherent Accelerator");
+MODULE_AUTHOR("Ian Munsie <imunsie@au1.ibm.com>");
+MODULE_LICENSE("GPL");
diff --git a/drivers/misc/cxl/native.c b/drivers/misc/cxl/native.c
new file mode 100644
index 0000000..3c5c6a8
--- /dev/null
+++ b/drivers/misc/cxl/native.c
@@ -0,0 +1,649 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#undef DEBUG
+
+#include <linux/spinlock.h>
+#include <linux/sched.h>
+#include <linux/slab.h>
+#include <linux/sched.h>
+#include <linux/mutex.h>
+#include <linux/mm.h>
+#include <linux/uaccess.h>
+#include <asm/synch.h>
+#include <misc/cxl.h>
+
+#include "cxl.h"
+
+static int afu_control(struct cxl_afu_t *afu, u64 command,
+		       u64 result, u64 mask, bool enabled)
+{
+	u64 AFU_Cntl = cxl_p2n_read(afu, CXL_AFU_Cntl_An);
+	unsigned long timeout = jiffies + (HZ * CXL_TIMEOUT);
+
+	spin_lock(&afu->afu_cntl_lock);
+	pr_devel("AFU command starting: %llx\n", command);
+
+	cxl_p2n_write(afu, CXL_AFU_Cntl_An, AFU_Cntl | command);
+
+	AFU_Cntl = cxl_p2n_read(afu, CXL_AFU_Cntl_An);
+	while ((AFU_Cntl & mask) != result) {
+		if (time_after_eq(jiffies, timeout)) {
+			dev_warn(&afu->dev, "WARNING: AFU control timed out!\n");
+			spin_unlock(&afu->afu_cntl_lock);
+			return -EBUSY;
+		}
+		pr_devel_ratelimited("AFU control... (0x%.16llx)\n",
+				     AFU_Cntl | command);
+		cpu_relax();
+		AFU_Cntl = cxl_p2n_read(afu, CXL_AFU_Cntl_An);
+	};
+	pr_devel("AFU command complete: %llx\n", command);
+	afu->enabled = enabled;
+	spin_unlock(&afu->afu_cntl_lock);
+
+	return 0;
+}
+
+static int afu_enable(struct cxl_afu_t *afu)
+{
+	pr_devel("AFU enable request\n");
+
+	return afu_control(afu, CXL_AFU_Cntl_An_E,
+			   CXL_AFU_Cntl_An_ES_Enabled,
+			   CXL_AFU_Cntl_An_ES_MASK, true);
+}
+
+static int afu_disable(struct cxl_afu_t *afu)
+{
+	pr_devel("AFU disable request\n");
+
+	return afu_control(afu, 0, CXL_AFU_Cntl_An_ES_Disabled,
+			   CXL_AFU_Cntl_An_ES_MASK, false);
+}
+
+/* We have to disable when we reset */
+static int afu_reset_and_disable(struct cxl_afu_t *afu)
+{
+	pr_devel("AFU reset request\n");
+
+	return afu_control(afu, CXL_AFU_Cntl_An_RA,
+			   CXL_AFU_Cntl_An_RS_Complete | CXL_AFU_Cntl_An_ES_Disabled,
+			   CXL_AFU_Cntl_An_RS_MASK | CXL_AFU_Cntl_An_ES_MASK,
+			   false);
+}
+
+static int afu_check_and_enable(struct cxl_afu_t *afu)
+{
+	if (afu->enabled)
+		return 0;
+	return afu_enable(afu);
+}
+
+static int psl_purge(struct cxl_afu_t *afu)
+{
+	u64 PSL_CNTL = cxl_p1n_read(afu, CXL_PSL_SCNTL_An);
+	u64 AFU_Cntl = cxl_p2n_read(afu, CXL_AFU_Cntl_An);
+	u64 dsisr, dar;
+	u64 start, end;
+	unsigned long timeout = jiffies + (HZ * CXL_TIMEOUT);
+
+	pr_devel("PSL purge request\n");
+
+	if ((AFU_Cntl & CXL_AFU_Cntl_An_ES_MASK) != CXL_AFU_Cntl_An_ES_Disabled) {
+		WARN(1, "psl_purge request while AFU not disabled!\n");
+		afu_disable(afu);
+	}
+
+	cxl_p1n_write(afu, CXL_PSL_SCNTL_An,
+		       PSL_CNTL | CXL_PSL_SCNTL_An_Pc);
+	start = local_clock();
+	PSL_CNTL = cxl_p1n_read(afu, CXL_PSL_SCNTL_An);
+	while ((PSL_CNTL &  CXL_PSL_SCNTL_An_Ps_MASK)
+			== CXL_PSL_SCNTL_An_Ps_Pending) {
+		if (time_after_eq(jiffies, timeout)) {
+			dev_warn(&afu->dev, "WARNING: PSL Purge timed out!\n");
+			return -EBUSY;
+		}
+		dsisr = cxl_p2n_read(afu, CXL_PSL_DSISR_An);
+		pr_devel_ratelimited("PSL purging... PSL_CNTL: 0x%.16llx  PSL_DSISR: 0x%.16llx\n", PSL_CNTL, dsisr);
+		if (dsisr & CXL_PSL_DSISR_TRANS) {
+			dar = cxl_p2n_read(afu, CXL_PSL_DAR_An);
+			dev_notice(&afu->dev, "PSL purge terminating pending translation, DSISR: 0x%.16llx, DAR: 0x%.16llx\n", dsisr, dar);
+			cxl_p2n_write(afu, CXL_PSL_TFC_An, CXL_PSL_TFC_An_AE);
+		} else if (dsisr) {
+			dev_notice(&afu->dev, "PSL purge acknowledging pending non-translation fault, DSISR: 0x%.16llx\n", dsisr);
+			cxl_p2n_write(afu, CXL_PSL_TFC_An, CXL_PSL_TFC_An_A);
+		} else {
+			cpu_relax();
+		}
+		PSL_CNTL = cxl_p1n_read(afu, CXL_PSL_SCNTL_An);
+	};
+	end = local_clock();
+	pr_devel("PSL purged in %lld ns\n", end - start);
+
+	cxl_p1n_write(afu, CXL_PSL_SCNTL_An,
+		       PSL_CNTL & ~CXL_PSL_SCNTL_An_Pc);
+	return 0;
+}
+
+static int spa_max_procs(int spa_size)
+{
+	/* From the CAIA:
+	 *    end_of_SPA_area = SPA_Base + ((n+4) * 128) + (( ((n*8) + 127) >> 7) * 128) + 255
+	 * Most of that junk is really just an overly-complicated way of saying
+	 * the last 256 bytes are __aligned(128), so it's really:
+	 *    end_of_SPA_area = end_of_PSL_queue_area + __aligned(128) 255
+	 * and
+	 *    end_of_PSL_queue_area = SPA_Base + ((n+4) * 128) + (n*8) - 1
+	 * so
+	 *    sizeof(SPA) = ((n+4) * 128) + (n*8) + __aligned(128) 256
+	 * Ignore the alignment (which is safe in this case as long as we are
+	 * careful with our rounding) and solve for n:
+	 */
+	return ((spa_size / 8) - 96) / 17;
+}
+
+static int alloc_spa(struct cxl_afu_t *afu)
+{
+	u64 spap;
+
+	/* Work out how many pages to allocate */
+	afu->spa_order = 0;
+	do {
+		afu->spa_order++;
+		afu->spa_size = (1 << afu->spa_order) * PAGE_SIZE;
+		afu->spa_max_procs = spa_max_procs(afu->spa_size);
+	} while (afu->spa_max_procs < afu->num_procs);
+
+	WARN_ON(afu->spa_size > 0x100000); /* Max size supported by the hardware */
+
+	if (!(afu->spa = (struct cxl_process_element *)
+	      __get_free_pages(GFP_KERNEL | __GFP_ZERO, afu->spa_order))) {
+		pr_err("cxl_alloc_spa: Unable to allocate scheduled process area\n");
+		return -ENOMEM;
+	}
+	pr_devel("spa pages: %i afu->spa_max_procs: %i   afu->num_procs: %i\n",
+		 1<<afu->spa_order, afu->spa_max_procs, afu->num_procs);
+
+	afu->sw_command_status = (__be64 *)((char *)afu->spa +
+					    ((afu->spa_max_procs + 3) * 128));
+
+	spap = virt_to_phys(afu->spa) & CXL_PSL_SPAP_Addr;
+	spap |= ((afu->spa_size >> (12 - CXL_PSL_SPAP_Size_Shift)) - 1) & CXL_PSL_SPAP_Size;
+	spap |= CXL_PSL_SPAP_V;
+	pr_devel("cxl: SPA allocated at 0x%p. Max processes: %i, sw_command_status: 0x%p CXL_PSL_SPAP_An=0x%016llx\n", afu->spa, afu->spa_max_procs, afu->sw_command_status, spap);
+	cxl_p1n_write(afu, CXL_PSL_SPAP_An, spap);
+
+	return 0;
+}
+
+static void release_spa(struct cxl_afu_t *afu)
+{
+	free_pages((unsigned long) afu->spa, afu->spa_order);
+}
+
+static void afu_slbia_native(struct cxl_afu_t *afu)
+{
+	pr_devel("cxl_afu_slbia issuing SLBIA command\n");
+	cxl_p2n_write(afu, CXL_SLBIA_An, CXL_SLBI_IQ_ALL);
+	while (cxl_p2n_read(afu, CXL_SLBIA_An) & CXL_SLBIA_P)
+		cpu_relax();
+}
+
+static void cxl_write_sstp(struct cxl_afu_t *afu, u64 sstp0, u64 sstp1)
+{
+	/* 1. Disable SSTP by writing 0 to SSTP1[V] */
+	cxl_p2n_write(afu, CXL_SSTP1_An, 0);
+
+	/* 2. Invalidate all SLB entries */
+	afu_slbia_native(afu);
+
+	/* 3. Set SSTP0_An */
+	cxl_p2n_write(afu, CXL_SSTP0_An, sstp0);
+
+	/* 4. Set SSTP1_An */
+	cxl_p2n_write(afu, CXL_SSTP1_An, sstp1);
+}
+
+/* Using per slice version may improve performance here. (ie. SLBIA_An) */
+static void slb_invalid(struct cxl_context_t *ctx)
+{
+	struct cxl_t *adapter = ctx->afu->adapter;
+	u64 slbia;
+
+	WARN_ON(!mutex_is_locked(&ctx->afu->spa_mutex));
+
+	cxl_p1_write(adapter, CXL_PSL_LBISEL,
+			((u64)be32_to_cpu(ctx->elem->common.pid) << 32) |
+			be32_to_cpu(ctx->elem->lpid));
+	cxl_p1_write(adapter, CXL_PSL_SLBIA, CXL_SLBI_IQ_LPIDPID);
+
+	while (1) {
+		slbia = cxl_p1_read(adapter, CXL_PSL_SLBIA);
+		if (!(slbia & CXL_SLBIA_P))
+			break;
+		cpu_relax();
+	}
+}
+
+static int do_process_element_cmd(struct cxl_context_t *ctx,
+				  u64 cmd, u64 pe_state)
+{
+	u64 state;
+
+	WARN_ON(!ctx->afu->enabled);
+
+	ctx->elem->software_state = cpu_to_be32(pe_state);
+	smp_wmb();
+	*(ctx->afu->sw_command_status) = cpu_to_be64(cmd | 0 | ctx->ph);
+	smp_mb();
+	cxl_p1n_write(ctx->afu, CXL_PSL_LLCMD_An, cmd | ctx->ph);
+	while (1) {
+		state = be64_to_cpup(ctx->afu->sw_command_status);
+		if (state == ~0ULL) {
+			pr_err("cxl: Error adding process element to AFU\n");
+			return -1;
+		}
+		if ((state & (CXL_SPA_SW_CMD_MASK | CXL_SPA_SW_STATE_MASK  | CXL_SPA_SW_LINK_MASK)) ==
+		    (cmd | (cmd >> 16) | ctx->ph))
+			break;
+		/* The command won't finish in the PSL if there are
+		 * outstanding DSIs.  Hence we need to yield here in
+		 * case there are outstanding DSIs that we need to
+		 * service.  Tuning possiblity: we could wait for a
+		 * while before sched
+		 */
+		schedule();
+
+	}
+	return 0;
+}
+
+static int add_process_element(struct cxl_context_t *ctx)
+{
+	int rc = 0;
+
+	mutex_lock(&ctx->afu->spa_mutex);
+	pr_devel("%s Adding pe: %i started\n", __func__, ctx->ph);
+	if (!(rc = do_process_element_cmd(ctx, CXL_SPA_SW_CMD_ADD, CXL_PE_SOFTWARE_STATE_V)))
+		ctx->pe_inserted = true;
+	pr_devel("%s Adding pe: %i finished\n", __func__, ctx->ph);
+	mutex_unlock(&ctx->afu->spa_mutex);
+	return rc;
+}
+
+static int terminate_process_element(struct cxl_context_t *ctx)
+{
+	int rc = 0;
+
+	/* fast path terminate if it's already invalid */
+	if (!(ctx->elem->software_state & cpu_to_be32(CXL_PE_SOFTWARE_STATE_V)))
+		return rc;
+
+	mutex_lock(&ctx->afu->spa_mutex);
+	pr_devel("%s Terminate pe: %i started\n", __func__, ctx->ph);
+	rc = do_process_element_cmd(ctx, CXL_SPA_SW_CMD_TERMINATE,
+				    CXL_PE_SOFTWARE_STATE_V | CXL_PE_SOFTWARE_STATE_T);
+	ctx->elem->software_state = 0;	/* Remove Valid bit */
+	pr_devel("%s Terminate pe: %i finished\n", __func__, ctx->ph);
+	mutex_unlock(&ctx->afu->spa_mutex);
+	return rc;
+}
+
+static int remove_process_element(struct cxl_context_t *ctx)
+{
+	int rc = 0;
+
+	mutex_lock(&ctx->afu->spa_mutex);
+	pr_devel("%s Remove pe: %i started\n", __func__, ctx->ph);
+	if (!(rc = do_process_element_cmd(ctx, CXL_SPA_SW_CMD_REMOVE, 0)))
+		ctx->pe_inserted = false;
+	slb_invalid(ctx);
+	pr_devel("%s Remove pe: %i finished\n", __func__, ctx->ph);
+	mutex_unlock(&ctx->afu->spa_mutex);
+
+	return rc;
+}
+
+
+static void assign_psn_space(struct cxl_context_t *ctx)
+{
+	if (!ctx->afu->pp_size || ctx->master) {
+		ctx->psn_phys = ctx->afu->psn_phys;
+		ctx->psn_size = ctx->afu->adapter->ps_size;
+	} else {
+		ctx->psn_phys = ctx->afu->psn_phys +
+			(ctx->afu->pp_offset + ctx->afu->pp_size * ctx->ph);
+		ctx->psn_size = ctx->afu->pp_size;
+	}
+}
+
+static int activate_afu_directed(struct cxl_afu_t *afu)
+{
+	int rc;
+
+	dev_info(&afu->dev, "Activating AFU directed model\n");
+
+	if (alloc_spa(afu))
+		return -ENOMEM;
+
+	cxl_p1n_write(afu, CXL_PSL_SCNTL_An, CXL_PSL_SCNTL_An_PM_AFU);
+	cxl_p1n_write(afu, CXL_PSL_AMOR_An, 0xFFFFFFFFFFFFFFFFULL);
+	cxl_p1n_write(afu, CXL_PSL_ID_An, CXL_PSL_ID_An_F | CXL_PSL_ID_An_L);
+
+	afu->current_model = CXL_MODEL_DIRECTED;
+	afu->num_procs = afu->max_procs_virtualised;
+
+	if ((rc = cxl_chardev_m_afu_add(afu)))
+		return rc;
+
+	if ((rc = cxl_chardev_s_afu_add(afu)))
+		goto err;
+
+	return 0;
+err:
+	cxl_chardev_afu_remove(afu);
+	return rc;
+}
+
+#ifdef CONFIG_CPU_LITTLE_ENDIAN
+#define set_endian(sr) ((sr) |= CXL_PSL_SR_An_LE)
+#else
+#define set_endian(sr) ((sr) &= ~(CXL_PSL_SR_An_LE))
+#endif
+
+static int attach_afu_directed(struct cxl_context_t *ctx, u64 wed, u64 amr)
+{
+
+	u64 sr, sstp0, sstp1;
+	int r, result;
+
+	assign_psn_space(ctx);
+
+	ctx->elem->ctxtime = 0; /* disable */
+	ctx->elem->lpid = cpu_to_be32(mfspr(SPRN_LPID));
+	ctx->elem->haurp = 0; /* disable */
+	ctx->elem->sdr = cpu_to_be64(mfspr(SPRN_SDR1));
+
+	sr = CXL_PSL_SR_An_SC;
+	if (ctx->master)
+		sr |= CXL_PSL_SR_An_MP;
+	if (mfspr(SPRN_LPCR) & LPCR_TC)
+		sr |= CXL_PSL_SR_An_TC;
+	/* HV=0, PR=1, R=1 for userspace
+	 * For kernel contexts: this would need to change
+	 */
+	sr |= CXL_PSL_SR_An_PR | CXL_PSL_SR_An_R;
+	set_endian(sr);
+	sr &= ~(CXL_PSL_SR_An_HV);
+	if (!test_tsk_thread_flag(current, TIF_32BIT))
+		sr |= CXL_PSL_SR_An_SF;
+	ctx->elem->common.pid = cpu_to_be32(current->pid);
+	ctx->elem->common.tid = 0;
+	ctx->elem->sr = cpu_to_be64(sr);
+
+	ctx->elem->common.csrp = 0; /* disable */
+	ctx->elem->common.aurp0 = 0; /* disable */
+	ctx->elem->common.aurp1 = 0; /* disable */
+
+	if ((result = cxl_alloc_sst(ctx, &sstp0, &sstp1)))
+		return result;
+
+	cxl_prefault(ctx, wed);
+
+	ctx->elem->common.sstp0 = cpu_to_be64(sstp0);
+	ctx->elem->common.sstp1 = cpu_to_be64(sstp1);
+
+	for (r = 0; r < CXL_IRQ_RANGES; r++) {
+		ctx->elem->ivte_offsets[r] = cpu_to_be16(ctx->irqs.offset[r]);
+		ctx->elem->ivte_ranges[r] = cpu_to_be16(ctx->irqs.range[r]);
+	}
+
+	ctx->elem->common.amr = cpu_to_be64(amr);
+	ctx->elem->common.wed = cpu_to_be64(wed);
+
+	/* first guy needs to enable */
+	if ((result = afu_check_and_enable(ctx->afu)))
+		return result;
+
+	add_process_element(ctx);
+
+	return 0;
+}
+
+static int deactivate_afu_directed(struct cxl_afu_t *afu)
+{
+	dev_info(&afu->dev, "Deactivating AFU directed model\n");
+
+	afu->current_model = 0;
+	afu->num_procs = 0;
+
+	cxl_chardev_afu_remove(afu);
+
+	afu_reset_and_disable(afu);
+	afu_disable(afu);
+	psl_purge(afu);
+
+	release_spa(afu);
+
+	return 0;
+}
+
+static int activate_dedicated_process(struct cxl_afu_t *afu)
+{
+	dev_info(&afu->dev, "Activating dedicated process model\n");
+
+	cxl_p1n_write(afu, CXL_PSL_SCNTL_An, CXL_PSL_SCNTL_An_PM_Process);
+
+	cxl_p1n_write(afu, CXL_PSL_CtxTime_An, 0); /* disable */
+	cxl_p1n_write(afu, CXL_PSL_SPAP_An, 0);    /* disable */
+	cxl_p1n_write(afu, CXL_PSL_AMOR_An, 0xFFFFFFFFFFFFFFFFULL);
+	cxl_p1n_write(afu, CXL_PSL_LPID_An, mfspr(SPRN_LPID));
+	cxl_p1n_write(afu, CXL_HAURP_An, 0);       /* disable */
+	cxl_p1n_write(afu, CXL_PSL_SDR_An, mfspr(SPRN_SDR1));
+
+	cxl_p2n_write(afu, CXL_CSRP_An, 0);        /* disable */
+	cxl_p2n_write(afu, CXL_AURP0_An, 0);       /* disable */
+	cxl_p2n_write(afu, CXL_AURP1_An, 0);       /* disable */
+
+	afu->current_model = CXL_MODEL_DEDICATED;
+	afu->num_procs = 1;
+
+	return cxl_chardev_m_afu_add(afu);
+}
+
+static int attach_dedicated(struct cxl_context_t *ctx, u64 wed, u64 amr)
+{
+	struct cxl_afu_t *afu = ctx->afu;
+	u64 sr, sstp0, sstp1;
+	int result;
+
+	sr = CXL_PSL_SR_An_SC;
+	set_endian(sr);
+	if (ctx->master)
+		sr |= CXL_PSL_SR_An_MP;
+	if (mfspr(SPRN_LPCR) & LPCR_TC)
+		sr |= CXL_PSL_SR_An_TC;
+	sr |= CXL_PSL_SR_An_PR | CXL_PSL_SR_An_R;
+	if (!test_tsk_thread_flag(current, TIF_32BIT))
+		sr |= CXL_PSL_SR_An_SF;
+	cxl_p2n_write(afu, CXL_PSL_PID_TID_An, (u64)current->pid << 32);
+	cxl_p1n_write(afu, CXL_PSL_SR_An, sr);
+
+	if ((result = cxl_alloc_sst(ctx, &sstp0, &sstp1)))
+		return result;
+
+	cxl_prefault(ctx, wed);
+
+	cxl_write_sstp(afu, sstp0, sstp1);
+	cxl_p1n_write(afu, CXL_PSL_IVTE_Offset_An,
+		       (((u64)ctx->irqs.offset[0] & 0xffff) << 48) |
+		       (((u64)ctx->irqs.offset[1] & 0xffff) << 32) |
+		       (((u64)ctx->irqs.offset[2] & 0xffff) << 16) |
+			((u64)ctx->irqs.offset[3] & 0xffff));
+	cxl_p1n_write(afu, CXL_PSL_IVTE_Limit_An, (u64)
+		       (((u64)ctx->irqs.range[0] & 0xffff) << 48) |
+		       (((u64)ctx->irqs.range[1] & 0xffff) << 32) |
+		       (((u64)ctx->irqs.range[2] & 0xffff) << 16) |
+			((u64)ctx->irqs.range[3] & 0xffff));
+
+	cxl_p2n_write(afu, CXL_PSL_AMR_An, amr);
+
+	/* master only context for dedicated */
+	assign_psn_space(ctx);
+
+	if ((result = afu_reset_and_disable(afu)))
+		return result;
+
+	cxl_p2n_write(afu, CXL_PSL_WED_An, wed);
+
+	return afu_enable(afu);
+}
+
+static int deactivate_dedicated_process(struct cxl_afu_t *afu)
+{
+	dev_info(&afu->dev, "Deactivating dedicated process model\n");
+
+	afu->current_model = 0;
+	afu->num_procs = 0;
+
+	cxl_chardev_afu_remove(afu);
+
+	return 0;
+}
+
+int _cxl_afu_deactivate_model(struct cxl_afu_t *afu, int model)
+{
+	if (model == CXL_MODEL_DIRECTED)
+		return deactivate_afu_directed(afu);
+	if (model == CXL_MODEL_DEDICATED)
+		return deactivate_dedicated_process(afu);
+	return 0;
+}
+
+int cxl_afu_deactivate_model(struct cxl_afu_t *afu)
+{
+	return _cxl_afu_deactivate_model(afu, afu->current_model);
+}
+EXPORT_SYMBOL(cxl_afu_deactivate_model);
+
+int cxl_afu_activate_model(struct cxl_afu_t *afu, int model)
+{
+	if (!model)
+		return 0;
+	if (!(model & afu->models_supported))
+		return -EINVAL;
+
+	if (model == CXL_MODEL_DIRECTED)
+		return activate_afu_directed(afu);
+	if (model == CXL_MODEL_DEDICATED)
+		return activate_dedicated_process(afu);
+
+	return -EINVAL;
+}
+EXPORT_SYMBOL(cxl_afu_activate_model);
+
+static int attach_process_native(struct cxl_context_t *ctx, bool kernel,
+			       u64 wed, u64 amr)
+{
+	ctx->kernel = kernel;
+	if (ctx->afu->current_model == CXL_MODEL_DIRECTED)
+		return attach_afu_directed(ctx, wed, amr);
+
+	if (ctx->afu->current_model == CXL_MODEL_DEDICATED)
+		return attach_dedicated(ctx, wed, amr);
+
+	return -EINVAL;
+}
+
+/* TODO: handle case when this is called with IRQs off which may
+ * happen when we unbind the driver.  Terminate & remove use a mutex
+ * lock and schedule which will not good with lock held.  May need to
+ * write do_process_element_cmd() that handles outstanding page
+ * faults. */
+static int detach_process_native(struct cxl_context_t *ctx)
+{
+	if (ctx->afu->current_model == CXL_MODEL_DEDICATED) {
+		afu_reset_and_disable(ctx->afu);
+		afu_disable(ctx->afu);
+		psl_purge(ctx->afu);
+		return 0;
+	}
+
+	if (!ctx->pe_inserted)
+		return 0;
+	if (terminate_process_element(ctx))
+		return -1;
+	if (remove_process_element(ctx))
+		return -1;
+
+	return 0;
+}
+
+static int get_irq_native(struct cxl_context_t *ctx, struct cxl_irq_info *info)
+{
+	u64 pidtid;
+
+	info->dsisr = cxl_p2n_read(ctx->afu, CXL_PSL_DSISR_An);
+	info->dar = cxl_p2n_read(ctx->afu, CXL_PSL_DAR_An);
+	info->dsr = cxl_p2n_read(ctx->afu, CXL_PSL_DSR_An);
+	pidtid = cxl_p2n_read(ctx->afu, CXL_PSL_PID_TID_An);
+	info->pid = pidtid >> 32;
+	info->tid = pidtid & 0xffffffff;
+	info->afu_err = cxl_p2n_read(ctx->afu, CXL_AFU_ERR_An);
+	info->errstat = cxl_p2n_read(ctx->afu, CXL_PSL_ErrStat_An);
+
+	return 0;
+}
+
+static void recover_psl_err(struct cxl_afu_t *afu, u64 errstat)
+{
+	u64 dsisr;
+
+	pr_devel("RECOVERING FROM PSL ERROR... (0x%.16llx)\n", errstat);
+
+	/* Clear PSL_DSISR[PE] */
+	dsisr = cxl_p2n_read(afu, CXL_PSL_DSISR_An);
+	cxl_p2n_write(afu, CXL_PSL_DSISR_An, dsisr & ~CXL_PSL_DSISR_An_PE);
+
+	/* Write 1s to clear error status bits */
+	cxl_p2n_write(afu, CXL_PSL_ErrStat_An, errstat);
+}
+
+static int ack_irq_native(struct cxl_context_t *ctx, u64 tfc,
+			  u64 psl_reset_mask)
+{
+	if (tfc)
+		cxl_p2n_write(ctx->afu, CXL_PSL_TFC_An, tfc);
+	if (psl_reset_mask)
+		recover_psl_err(ctx->afu, psl_reset_mask);
+
+	return 0;
+}
+
+static int check_error(struct cxl_afu_t *afu)
+{
+	return (cxl_p1n_read(afu, CXL_PSL_SCNTL_An) == ~0ULL);
+}
+
+static const struct cxl_backend_ops cxl_native_ops = {
+	.attach_process = attach_process_native,
+	.detach_process = detach_process_native,
+	.get_irq = get_irq_native,
+	.ack_irq = ack_irq_native,
+	.check_error = check_error,
+	.slbia = afu_slbia_native,
+	.afu_reset = afu_reset_and_disable,
+};
+
+void init_cxl_native(void)
+{
+	cxl_ops = &cxl_native_ops;
+}
diff --git a/drivers/misc/cxl/sysfs.c b/drivers/misc/cxl/sysfs.c
new file mode 100644
index 0000000..67489e8
--- /dev/null
+++ b/drivers/misc/cxl/sysfs.c
@@ -0,0 +1,348 @@
+/*
+ * Copyright 2014 IBM Corp.
+ *
+ * This program is free software; you can redistribute it and/or
+ * modify it under the terms of the GNU General Public License
+ * as published by the Free Software Foundation; either version
+ * 2 of the License, or (at your option) any later version.
+ */
+
+#include <linux/kernel.h>
+#include <linux/device.h>
+#include <linux/sysfs.h>
+
+#include "cxl.h"
+
+#define to_afu_chardev_m(d) dev_get_drvdata(d)
+
+/*********  Adapter attributes  **********************************************/
+
+static ssize_t caia_version_show(struct device *device,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct cxl_t *adapter = to_cxl_adapter(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%i.%i\n", adapter->caia_major,
+			 adapter->caia_minor);
+}
+
+static ssize_t psl_revision_show(struct device *device,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct cxl_t *adapter = to_cxl_adapter(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%i\n", adapter->psl_rev);
+}
+
+static ssize_t base_image_show(struct device *device,
+			       struct device_attribute *attr,
+			       char *buf)
+{
+	struct cxl_t *adapter = to_cxl_adapter(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%i\n", adapter->base_image);
+}
+
+static ssize_t image_loaded_show(struct device *device,
+				 struct device_attribute *attr,
+				 char *buf)
+{
+	struct cxl_t *adapter = to_cxl_adapter(device);
+
+	if (adapter->user_image_loaded)
+		return scnprintf(buf, PAGE_SIZE, "user\n");
+	return scnprintf(buf, PAGE_SIZE, "factory\n");
+}
+
+static struct device_attribute adapter_attrs[] = {
+	__ATTR_RO(caia_version),
+	__ATTR_RO(psl_revision),
+	__ATTR_RO(base_image),
+	__ATTR_RO(image_loaded),
+	/* __ATTR_RW(reset_loads_image); */
+	/* __ATTR_RW(reset_image_select); */
+};
+
+
+/*********  AFU master specific attributes  **********************************/
+
+static ssize_t mmio_size_show_master(struct device *device,
+				     struct device_attribute *attr,
+				     char *buf)
+{
+	struct cxl_afu_t *afu = to_afu_chardev_m(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->adapter->ps_size);
+}
+
+static ssize_t pp_mmio_off_show(struct device *device,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct cxl_afu_t *afu = to_afu_chardev_m(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->pp_offset);
+}
+
+static ssize_t pp_mmio_len_show(struct device *device,
+				struct device_attribute *attr,
+				char *buf)
+{
+	struct cxl_afu_t *afu = to_afu_chardev_m(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->pp_size);
+}
+
+static struct device_attribute afu_master_attrs[] = {
+	__ATTR(mmio_size, S_IRUGO, mmio_size_show_master, NULL),
+	__ATTR_RO(pp_mmio_off),
+	__ATTR_RO(pp_mmio_len),
+};
+
+
+/*********  AFU attributes  **************************************************/
+
+static ssize_t mmio_size_show(struct device *device,
+			      struct device_attribute *attr,
+			      char *buf)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+
+	if (afu->pp_size)
+		return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->pp_size);
+	return scnprintf(buf, PAGE_SIZE, "%llu\n", afu->adapter->ps_size);
+}
+
+static ssize_t reset_store_afu(struct device *device,
+			       struct device_attribute *attr,
+			       const char *buf, size_t count)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+	int rc;
+
+	if ((rc = cxl_ops->afu_reset(afu)))
+		return rc;
+	return count;
+}
+
+static ssize_t irqs_min_show(struct device *device,
+			     struct device_attribute *attr,
+			     char *buf)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%i\n", afu->pp_irqs);
+}
+
+static ssize_t irqs_max_show(struct device *device,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+
+	return scnprintf(buf, PAGE_SIZE, "%i\n", afu->irqs_max);
+}
+
+static ssize_t irqs_max_store(struct device *device,
+				  struct device_attribute *attr,
+				  const char *buf, size_t count)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+	ssize_t ret;
+	int irqs_max;
+
+	ret = sscanf(buf, "%i", &irqs_max);
+	if (ret != 1)
+		return -EINVAL;
+
+	if (irqs_max < afu->pp_irqs)
+		return -EINVAL;
+
+	if (irqs_max > afu->adapter->user_irqs)
+		return -EINVAL;
+
+	afu->irqs_max = irqs_max;
+	return count;
+}
+
+static ssize_t models_supported_show(struct device *device,
+				    struct device_attribute *attr,
+				    char *buf)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+	char *p = buf, *end = buf + PAGE_SIZE;
+
+	if (afu->models_supported & CXL_MODEL_DEDICATED)
+		p += scnprintf(p, end - p, "dedicated_process\n");
+	if (afu->models_supported & CXL_MODEL_DIRECTED)
+		p += scnprintf(p, end - p, "afu_directed\n");
+	return (p - buf);
+}
+
+static ssize_t prefault_mode_show(struct device *device,
+				  struct device_attribute *attr,
+				  char *buf)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+
+	switch (afu->prefault_mode) {
+	case CXL_PREFAULT_WED:
+		return scnprintf(buf, PAGE_SIZE, "wed\n");
+	case CXL_PREFAULT_ALL:
+		return scnprintf(buf, PAGE_SIZE, "all\n");
+	default:
+		return scnprintf(buf, PAGE_SIZE, "none\n");
+	}
+}
+
+static ssize_t prefault_mode_store(struct device *device,
+			  struct device_attribute *attr,
+			  const char *buf, size_t count)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+	enum prefault_modes mode = -1;
+
+	if (!strncmp(buf, "wed", 3))
+		mode = CXL_PREFAULT_WED;
+	if (!strncmp(buf, "all", 3))
+		mode = CXL_PREFAULT_ALL;
+	if (!strncmp(buf, "none", 4))
+		mode = CXL_PREFAULT_NONE;
+
+	if (mode == -1)
+		return -EINVAL;
+
+	afu->prefault_mode = mode;
+	return count;
+}
+
+static ssize_t model_show(struct device *device,
+			 struct device_attribute *attr,
+			 char *buf)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+
+	if (afu->current_model == CXL_MODEL_DEDICATED)
+		return scnprintf(buf, PAGE_SIZE, "dedicated_process\n");
+	if (afu->current_model == CXL_MODEL_DIRECTED)
+		return scnprintf(buf, PAGE_SIZE, "afu_directed\n");
+	return scnprintf(buf, PAGE_SIZE, "none\n");
+}
+
+static ssize_t model_store(struct device *device,
+			   struct device_attribute *attr,
+			   const char *buf, size_t count)
+{
+	struct cxl_afu_t *afu = to_cxl_afu(device);
+	int old_model, model = -1;
+	int rc = -EBUSY;
+
+	/* can't change this if we have a user */
+	spin_lock(&afu->contexts_lock);
+	if (!idr_is_empty(&afu->contexts_idr))
+		goto err;
+
+	if (!strncmp(buf, "dedicated_process", 17))
+		model = CXL_MODEL_DEDICATED;
+	if (!strncmp(buf, "afu_directed", 12))
+		model = CXL_MODEL_DIRECTED;
+	if (!strncmp(buf, "none", 4))
+		model = 0;
+
+	if (model == -1) {
+		rc = -EINVAL;
+		goto err;
+	}
+
+	/* cxl_afu_deactivate_model needs to be done outside the lock, prevent
+	 * other contexts coming in before we are ready: */
+	old_model = afu->current_model;
+	afu->current_model = 0;
+	afu->num_procs = 0;
+
+	spin_unlock(&afu->contexts_lock);
+
+	if ((rc = _cxl_afu_deactivate_model(afu, old_model)))
+		return rc;
+	if ((rc = cxl_afu_activate_model(afu, model)))
+		return rc;
+
+	return count;
+err:
+	spin_unlock(&afu->contexts_lock);
+	return rc;
+}
+
+static struct device_attribute afu_attrs[] = {
+	__ATTR_RO(mmio_size),
+	__ATTR_RO(irqs_min),
+	__ATTR_RW(irqs_max),
+	__ATTR_RO(models_supported),
+	__ATTR_RW(model),
+	__ATTR_RW(prefault_mode),
+	__ATTR(reset, S_IWUSR, NULL, reset_store_afu),
+};
+
+
+
+int cxl_sysfs_adapter_add(struct cxl_t *adapter)
+{
+	int i, rc;
+
+	for (i = 0; i < ARRAY_SIZE(adapter_attrs); i++) {
+		if ((rc = device_create_file(&adapter->dev, &adapter_attrs[i])))
+			goto err;
+	}
+	return 0;
+err:
+	for (i--; i >= 0; i--)
+		device_remove_file(&adapter->dev, &adapter_attrs[i]);
+	return rc;
+}
+EXPORT_SYMBOL(cxl_sysfs_adapter_add);
+void cxl_sysfs_adapter_remove(struct cxl_t *adapter)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(adapter_attrs); i++)
+		device_remove_file(&adapter->dev, &adapter_attrs[i]);
+}
+EXPORT_SYMBOL(cxl_sysfs_adapter_remove);
+
+int cxl_sysfs_afu_add(struct cxl_afu_t *afu)
+{
+	int afu_attr, mstr_attr, rc = 0;
+
+	for (afu_attr = 0; afu_attr < ARRAY_SIZE(afu_attrs); afu_attr++) {
+		if ((rc = device_create_file(&afu->dev, &afu_attrs[afu_attr])))
+			goto err;
+	}
+	for (mstr_attr = 0; mstr_attr < ARRAY_SIZE(afu_master_attrs); mstr_attr++) {
+		if ((rc = device_create_file(afu->chardev_m, &afu_master_attrs[mstr_attr])))
+			goto err1;
+	}
+
+	return 0;
+
+err1:
+	for (mstr_attr--; mstr_attr >= 0; mstr_attr--)
+		device_remove_file(afu->chardev_m, &afu_master_attrs[mstr_attr]);
+err:
+	for (afu_attr--; afu_attr >= 0; afu_attr--)
+		device_remove_file(&afu->dev, &afu_attrs[afu_attr]);
+	return rc;
+}
+EXPORT_SYMBOL(cxl_sysfs_afu_add);
+
+void cxl_sysfs_afu_remove(struct cxl_afu_t *afu)
+{
+	int i;
+
+	for (i = 0; i < ARRAY_SIZE(afu_master_attrs); i++)
+		device_remove_file(afu->chardev_m, &afu_master_attrs[i]);
+	for (i = 0; i < ARRAY_SIZE(afu_attrs); i++)
+		device_remove_file(&afu->dev, &afu_attrs[i]);
+}
+EXPORT_SYMBOL(cxl_sysfs_afu_remove);
-- 
1.9.1

