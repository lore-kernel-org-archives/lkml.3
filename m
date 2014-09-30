Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755239AbaI3AfJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Sep 2014 20:35:09 -0400
Received: from seldrel01.sonyericsson.com ([212.209.106.2]:10922 "EHLO
	seldrel01.sonyericsson.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755095AbaI3AfC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Sep 2014 20:35:02 -0400
From: Bjorn Andersson <bjorn.andersson@sonymobile.com>
To: Kumar Gala <galak@codeaurora.org>, Andy Gross <agross@codeaurora.org>,
        Arnd Bergmann <arnd@arndb.de>
CC: <devicetree@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-arm-msm@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Grant Likely <grant.likely@linaro.org>,
        Ian Campbell <ijc+devicetree@hellion.org.uk>,
        Lee Jones <lee.jones@linaro.org>, Liam Girdwood <lgirdwood@gmail.com>,
        Mark Brown <broonie@kernel.org>, Mark Rutland <mark.rutland@arm.com>,
        Pawel Moll <pawel.moll@arm.com>, Rob Herring <robh+dt@kernel.org>,
        Samuel Ortiz <sameo@linux.intel.com>, Suman Anna <s-anna@ti.com>
Subject: [RFC 4/7] soc: qcom: Add Shared Memory Manager driver
Date: Mon, 29 Sep 2014 17:34:48 -0700
Message-ID: <1412037291-16880-5-git-send-email-bjorn.andersson@sonymobile.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
References: <1412037291-16880-1-git-send-email-bjorn.andersson@sonymobile.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The Shared Memory Manager driver implements an interface for allocating
and accessing items in the memory area shared among all of the
processors in a Qualcomm platform.

Signed-off-by: Bjorn Andersson <bjorn.andersson@sonymobile.com>
---

In later platforms this is extended to support "secure smem", I do
unfortunately not have any devices that I could test this with so I have only
implemented the "insecure" version for now.

I was thinking about implementing an of_xlate as this would make sense for many
things. It is however not feasible for SMD, that would require us to list 257
items.

It would make sense to enhance this with a method of keeping track of currently
consumed items, both to take care of "mutual exclusion" between consumers as
well as knowing when it's safe to remove the device and/or unload the driver.

I did consider exposing the items as regmaps, but for many of the items the
regmap context is consuming far more space then the actual data. And we would
end up creating 3-400 regmap contexts in a normal system.


Also note that the hwspinlock framework does not yet support devicetree based
retrieval of spinlock handles, so that part needs to be changed.

 drivers/soc/qcom/Kconfig           |    8 +
 drivers/soc/qcom/Makefile          |    1 +
 drivers/soc/qcom/qcom_smem.c       |  328 ++++++++++++++++++++++++++++++++++++
 include/linux/soc/qcom/qcom_smem.h |   14 ++
 4 files changed, 351 insertions(+)
 create mode 100644 drivers/soc/qcom/qcom_smem.c
 create mode 100644 include/linux/soc/qcom/qcom_smem.h

diff --git a/drivers/soc/qcom/Kconfig b/drivers/soc/qcom/Kconfig
index 7bd2c94..9e6bc56 100644
--- a/drivers/soc/qcom/Kconfig
+++ b/drivers/soc/qcom/Kconfig
@@ -9,3 +9,11 @@ config QCOM_GSBI
           functions for connecting the underlying serial UART, SPI, and I2C
           devices to the output pins.
 
+config QCOM_SMEM
+	tristate "Qualcomm Shared Memory Interface"
+	depends on ARCH_QCOM
+	help
+	  Say y here to enable support for the Qualcomm Shared Memory Manager.
+	  The driver provides an interface to items in a heap shared among all
+	  processors in a Qualcomm platform and is used for exchanging
+	  information as well as a fifo based communication mechanism (SMD).
diff --git a/drivers/soc/qcom/Makefile b/drivers/soc/qcom/Makefile
index 4389012..b1f7b18 100644
--- a/drivers/soc/qcom/Makefile
+++ b/drivers/soc/qcom/Makefile
@@ -1 +1,2 @@
 obj-$(CONFIG_QCOM_GSBI)	+=	qcom_gsbi.o
+obj-$(CONFIG_QCOM_SMEM) +=	qcom_smem.o
diff --git a/drivers/soc/qcom/qcom_smem.c b/drivers/soc/qcom/qcom_smem.c
new file mode 100644
index 0000000..9766c86
--- /dev/null
+++ b/drivers/soc/qcom/qcom_smem.c
@@ -0,0 +1,328 @@
+/*
+ * Copyright (c) 2014, Sony Mobile Communications AB.
+ * Copyright (c) 2012-2013, The Linux Foundation. All rights reserved.
+ *
+ * This program is free software; you can redistribute it and/or modify
+ * it under the terms of the GNU General Public License version 2 and
+ * only version 2 as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope that it will be useful,
+ * but WITHOUT ANY WARRANTY; without even the implied warranty of
+ * MERCHANTABILITY or FITNESS FOR A PARTICULAR PURPOSE.  See the
+ * GNU General Public License for more details.
+ */
+
+#include <linux/module.h>
+#include <linux/platform_device.h>
+#include <linux/io.h>
+#include <linux/slab.h>
+#include <linux/of.h>
+#include <linux/hwspinlock.h>
+#include <linux/soc/qcom/qcom_smem.h>
+
+#define AUX_BASE_MASK		0xfffffffc
+#define HWSPINLOCK_TIMEOUT	1000
+#define SMEM_MAX_ITEMS		512
+
+/**
+  * struct smem_proc_comm - proc_comm communication struct (legacy)
+  * @command:	current command to be executed
+  * @status:	status of the currently requested command
+  * @params:	parameters to the command
+  */
+struct smem_proc_comm {
+	u32 command;
+	u32 status;
+	u32 params[2];
+};
+
+/**
+ * struct smem_entry - entry to reference smem items on the heap
+ * @allocated:	boolean to indicate if this entry is used
+ * @offset:	offset to the allocated space
+ * @size:	size of the allocated space, 8 byte aligned
+ * @aux_base:	base address for the memory region used by this unit, or 0 for
+ *		the default region. bits 0,1 are reserved
+ */
+struct smem_entry {
+	u32 allocated;
+	u32 offset;
+	u32 size;
+	u32 aux_base; /* bits 1:0 reserved */
+};
+
+/**
+ * struct smem_header - header found in beginning of primary smem region
+ * @proc_comm:		proc_comm communication interface (legacy)
+ * @version:		array of versions for the various subsystems
+ * @smem_initialized:	boolean to indicate that smem is initialized
+ * @free_offset:	index of the first unallocated byte in smem
+ * @available:		number of bytes available for allocation
+ * @unused:		reserved field
+ * toc:			array of references to smem entries
+ */
+struct smem_header {
+	struct smem_proc_comm proc_comm[4];
+	u32 version[32];
+	u32 smem_initialized;
+	u32 free_offset;
+	u32 available;
+	u32 unused;
+	struct smem_entry toc[SMEM_MAX_ITEMS];
+};
+
+/**
+  * struct smem_area - memory region used for smem heap
+  * @aux_base:	physical base address of the region, used for entry lookup
+  * @virt_base:	virtual address of the mapping
+  */
+struct smem_region {
+	u32 aux_base;
+	void __iomem *virt_base;
+};
+
+/**
+  * struct qcom_smem - control struct for the smem driver
+  * @dev:		device pointer
+  * @hwlock:		hwspinlock to be held during heap operations
+  * @num_regions:	number of entires in the regions array
+  * @regions:		array of memory regions, region 0 contains smem_header
+  */
+struct qcom_smem {
+	struct device *dev;
+
+	struct hwspinlock *hwlock;
+
+	unsigned num_regions;
+	struct smem_region regions[0];
+};
+
+/* Pointer to the one and only smem handle */
+static struct qcom_smem *smem_handle;
+
+/**
+ * of_get_qcom_smem - retrieve a smem handle from a phandle
+ * @client_node: of_node of the client
+ *
+ * Resolve the phandle in the property "qcom,smem" of @client_node and use this
+ * to retrieve an smem handle.
+ */
+struct qcom_smem *of_get_qcom_smem(struct device_node *client_node)
+{
+	struct device_node *node;
+
+	node = of_parse_phandle(client_node, "qcom,smem", 0);
+	if (!node)
+		return ERR_PTR(-EINVAL);
+
+	of_node_put(node);
+
+	if (!smem_handle)
+		return ERR_PTR(-EPROBE_DEFER);
+	else if (smem_handle->dev->of_node != node)
+		return ERR_PTR(-EINVAL);
+
+	return smem_handle;
+}
+EXPORT_SYMBOL(of_get_qcom_smem);
+
+/**
+ * qcom_smem_alloc - allocate space for a smem item
+ * @smem:	smem handle
+ * @smem_id:	item to be allocated
+ * @size:	number of bytes to be allocated
+ *
+ * Allocate space for a given smem item of size @size, given that the item is
+ * not yet allocated.
+ */
+int qcom_smem_alloc(struct qcom_smem *smem, unsigned smem_id, size_t size)
+{
+	struct smem_header *header = smem->regions[0].virt_base;
+	struct smem_entry *entry;
+	unsigned long flags;
+	int ret;
+
+	size = ALIGN(size, 8);
+
+	if (WARN_ON(smem_id >= SMEM_MAX_ITEMS))
+		return -EINVAL;
+
+	ret = hwspin_lock_timeout_irqsave(smem->hwlock,
+					  HWSPINLOCK_TIMEOUT,
+					  &flags);
+	if (ret)
+		return ret;
+
+	entry = &header->toc[smem_id];
+	if (entry->allocated) {
+		ret = -EEXIST;
+		goto out;
+	}
+
+	if (WARN_ON(size > header->available)) {
+		ret = -ENOMEM;
+		goto out;
+	}
+
+	entry->offset = header->free_offset;
+	entry->size = size;
+	entry->allocated = 1;
+
+	header->free_offset += size;
+	header->available -= size;
+
+	/* Commit the changes before we release the spin lock */
+	wmb();
+out:
+	hwspin_unlock_irqrestore(smem->hwlock, &flags);
+	return ret;
+}
+EXPORT_SYMBOL(qcom_smem_alloc);
+
+unsigned qcom_smem_get_free_space(struct qcom_smem *smem)
+{
+	struct smem_header *header = smem->regions[0].virt_base;
+
+	return header->available;
+}
+EXPORT_SYMBOL(qcom_smem_get_free_space);
+
+/**
+ * qcom_smem_get - resolve ptr of size of a smem item
+ * @smem:	smem handle
+ * @smem_id:	item id to be resolved
+ * @ptr:	pointer to be filled out with address of the item
+ * @size:	pointer to be filled out with size of the item
+ *
+ * Looks up pointer and size of a smem item.
+ */
+int qcom_smem_get(struct qcom_smem *smem,
+		  unsigned smem_id,
+		  void **ptr,
+		  size_t *size)
+{
+	struct smem_header *header = smem->regions[0].virt_base;
+	struct smem_region *area;
+	struct smem_entry *entry;
+	unsigned long flags;
+	u32 aux_base;
+	unsigned i;
+	int ret;
+
+	if (WARN_ON(smem_id >= SMEM_MAX_ITEMS))
+		return -EINVAL;
+
+	ret = hwspin_lock_timeout_irqsave(smem->hwlock,
+					  HWSPINLOCK_TIMEOUT,
+					  &flags);
+	if (ret)
+		return ret;
+
+	entry = &header->toc[smem_id];
+	if (!entry->allocated) {
+		ret = -ENXIO;
+		goto out;
+	}
+
+	if (ptr != NULL) {
+		aux_base = entry->aux_base & AUX_BASE_MASK;
+
+		for (i = 0; i < smem->num_regions; i++) {
+			area = &smem->regions[i];
+
+			if (area->aux_base == aux_base || !aux_base) {
+				*ptr = area->virt_base + entry->offset;
+				break;
+			}
+		}
+	}
+	if (size != NULL)
+		*size = entry->size;
+
+out:
+	hwspin_unlock_irqrestore(smem->hwlock, &flags);
+	return ret;
+}
+EXPORT_SYMBOL(qcom_smem_get);
+
+static int qcom_smem_probe(struct platform_device *pdev)
+{
+	struct qcom_smem *smem;
+	struct resource *res;
+	size_t array_size;
+	int num_regions = 0;
+	int i;
+
+	for (i = 0; i < pdev->num_resources; i++) {
+		res = &pdev->resource[i];
+
+		if (resource_type(res) == IORESOURCE_MEM)
+			num_regions++;
+	}
+
+	if (num_regions == 0) {
+		dev_err(&pdev->dev, "no smem regions specified\n");
+		return -EINVAL;
+	}
+
+	array_size = num_regions * sizeof(struct smem_region);
+	smem = devm_kzalloc(&pdev->dev, sizeof(*smem) + array_size, GFP_KERNEL);
+	if (!smem)
+		return -ENOMEM;
+
+	smem->dev = &pdev->dev;
+	smem->hwlock = of_hwspin_lock_request(pdev->dev.of_node, NULL);
+	if (IS_ERR(smem->hwlock))
+		return PTR_ERR(smem->hwlock);
+
+	smem->num_regions = num_regions;
+
+	for (i = 0; i < num_regions; i++) {
+		res = platform_get_resource(pdev, IORESOURCE_MEM, i);
+
+		smem->regions[i].aux_base = (u32)res->start;
+		smem->regions[i].virt_base = devm_ioremap(&pdev->dev,
+							  res->start,
+							  resource_size(res));
+		if (!smem->regions[i].virt_base)
+			return -ENOMEM;
+	}
+
+	dev_set_drvdata(&pdev->dev, smem);
+	smem_handle = smem;
+
+	dev_info(&pdev->dev, "Qualcomm Shared Memory Interface probed\n");
+
+	return 0;
+}
+
+static const struct of_device_id qcom_smem_of_match[] = {
+	{ .compatible = "qcom,smem" },
+	{}
+};
+MODULE_DEVICE_TABLE(of, qcom_smem_of_match);
+
+static struct platform_driver qcom_smem_driver = {
+	.probe          = qcom_smem_probe,
+	.driver  = {
+		.name  = "qcom_smem",
+		.owner = THIS_MODULE,
+		.of_match_table = qcom_smem_of_match,
+	},
+};
+
+static int __init qcom_smem_init(void)
+{
+	return platform_driver_register(&qcom_smem_driver);
+}
+arch_initcall(qcom_smem_init);
+
+static void __exit qcom_smem_exit(void)
+{
+	platform_driver_unregister(&qcom_smem_driver);
+}
+module_exit(qcom_smem_exit)
+
+MODULE_AUTHOR("Bjorn Andersson <bjorn.andersson@sonymobile.com>");
+MODULE_DESCRIPTION("Qualcomm Shared Memory Interface");
+MODULE_LICENSE("GPLv2");
diff --git a/include/linux/soc/qcom/qcom_smem.h b/include/linux/soc/qcom/qcom_smem.h
new file mode 100644
index 0000000..7c0d3fd
--- /dev/null
+++ b/include/linux/soc/qcom/qcom_smem.h
@@ -0,0 +1,14 @@
+#ifndef __QCOM_SMEM_H__
+#define __QCOM_SMEM_H__
+
+struct device_node;
+struct qcom_smem;
+
+struct qcom_smem *of_get_qcom_smem(struct device_node *node);
+
+int qcom_smem_alloc(struct qcom_smem *smem, unsigned smem_id, size_t size);
+int qcom_smem_get(struct qcom_smem *smem, unsigned item, void **ptr, size_t *size);
+
+unsigned qcom_smem_get_free_space(struct qcom_smem *smem);
+
+#endif
-- 
1.7.9.5

