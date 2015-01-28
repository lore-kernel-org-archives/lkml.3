Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbbA1UVt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:21:49 -0500
Received: from mga14.intel.com ([192.55.52.115]:59771 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754863AbbA1UVp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:21:45 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677269206"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>, Dan Williams <dan.j.williams@intel.com>,
        Vinod Koul <vinod.koul@intel.com>,
        Jiang Liu <jiang.liu@linux.intel.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Vivek Goyal <vgoyal@redhat.com>, Thierry Reding <treding@nvidia.com>,
        Mike Travis <travis@sgi.com>
Cc: Tony Luck <tony.luck@intel.com>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, dmaengine@vger.kernel.org
Subject: [Patch v2 17/22] resources: Move struct resource_list_entry from ACPI into resource core
Date: Wed, 28 Jan 2015 18:57:35 +0800
Message-Id: <1422442660-455-18-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Currently ACPI, PCI and pnp all implement the same resource list
management with different data structure. We need to transfer from
one data structure into another when passing resources from one
subsystem into another subsystem. Sp move struct resource_list_entry
from ACPI into resource core, so it could be reused by different
subystems and avoid the data structure conversion.

Introduce dedicated header file resource_ext.h instead of embedding
it into ioport.h to avoid header file inclusion order issues.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/acpi_lpss.c     |    6 ++--
 drivers/acpi/acpi_platform.c |    2 +-
 drivers/acpi/resource.c      |   13 +++----
 drivers/dma/acpi-dma.c       |    8 ++---
 include/linux/acpi.h         |   12 +------
 include/linux/resource_ext.h |   77 ++++++++++++++++++++++++++++++++++++++++++
 kernel/resource.c            |   25 ++++++++++++++
 7 files changed, 115 insertions(+), 28 deletions(-)
 create mode 100644 include/linux/resource_ext.h

diff --git a/drivers/acpi/acpi_lpss.c b/drivers/acpi/acpi_lpss.c
index 4f3febf8a589..39b548dba70b 100644
--- a/drivers/acpi/acpi_lpss.c
+++ b/drivers/acpi/acpi_lpss.c
@@ -333,12 +333,12 @@ static int acpi_lpss_create_device(struct acpi_device *adev,
 		goto err_out;
 
 	list_for_each_entry(rentry, &resource_list, node)
-		if (resource_type(&rentry->res) == IORESOURCE_MEM) {
+		if (resource_type(rentry->res) == IORESOURCE_MEM) {
 			if (dev_desc->prv_size_override)
 				pdata->mmio_size = dev_desc->prv_size_override;
 			else
-				pdata->mmio_size = resource_size(&rentry->res);
-			pdata->mmio_base = ioremap(rentry->res.start,
+				pdata->mmio_size = resource_size(rentry->res);
+			pdata->mmio_base = ioremap(rentry->res->start,
 						   pdata->mmio_size);
 			break;
 		}
diff --git a/drivers/acpi/acpi_platform.c b/drivers/acpi/acpi_platform.c
index 6ba8beb6b9d2..238e32b9cbb0 100644
--- a/drivers/acpi/acpi_platform.c
+++ b/drivers/acpi/acpi_platform.c
@@ -71,7 +71,7 @@ struct platform_device *acpi_create_platform_device(struct acpi_device *adev)
 		}
 		count = 0;
 		list_for_each_entry(rentry, &resource_list, node)
-			resources[count++] = rentry->res;
+			resources[count++] = *rentry->res;
 
 		acpi_dev_free_resource_list(&resource_list);
 	}
diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 3ea0d17eb951..f7648205416e 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -444,12 +444,7 @@ EXPORT_SYMBOL_GPL(acpi_dev_resource_interrupt);
  */
 void acpi_dev_free_resource_list(struct list_head *list)
 {
-	struct resource_list_entry *rentry, *re;
-
-	list_for_each_entry_safe(rentry, re, list, node) {
-		list_del(&rentry->node);
-		kfree(rentry);
-	}
+	resource_list_free(list);
 }
 EXPORT_SYMBOL_GPL(acpi_dev_free_resource_list);
 
@@ -466,14 +461,14 @@ static acpi_status acpi_dev_new_resource_entry(struct resource_win *win,
 {
 	struct resource_list_entry *rentry;
 
-	rentry = kmalloc(sizeof(*rentry), GFP_KERNEL);
+	rentry = resource_list_create_entry(NULL, 0);
 	if (!rentry) {
 		c->error = -ENOMEM;
 		return AE_NO_MEMORY;
 	}
-	rentry->res = win->res;
+	*rentry->res = win->res;
 	rentry->offset = win->offset;
-	list_add_tail(&rentry->node, c->list);
+	resource_list_add_tail(rentry, c->list);
 	c->count++;
 	return AE_OK;
 }
diff --git a/drivers/dma/acpi-dma.c b/drivers/dma/acpi-dma.c
index de361a156b34..1ce84abe0924 100644
--- a/drivers/dma/acpi-dma.c
+++ b/drivers/dma/acpi-dma.c
@@ -56,10 +56,10 @@ static int acpi_dma_parse_resource_group(const struct acpi_csrt_group *grp,
 		return 0;
 
 	list_for_each_entry(rentry, &resource_list, node) {
-		if (resource_type(&rentry->res) == IORESOURCE_MEM)
-			mem = rentry->res.start;
-		else if (resource_type(&rentry->res) == IORESOURCE_IRQ)
-			irq = rentry->res.start;
+		if (resource_type(rentry->res) == IORESOURCE_MEM)
+			mem = rentry->res->start;
+		else if (resource_type(rentry->res) == IORESOURCE_IRQ)
+			irq = rentry->res->start;
 	}
 
 	acpi_dev_free_resource_list(&resource_list);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index e818decb631f..e53822148b6a 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -27,6 +27,7 @@
 
 #include <linux/errno.h>
 #include <linux/ioport.h>	/* for struct resource */
+#include <linux/resource_ext.h>
 #include <linux/device.h>
 #include <linux/property.h>
 
@@ -285,11 +286,6 @@ extern int pnpacpi_disabled;
 
 #define PXM_INVAL	(-1)
 
-struct resource_win {
-	struct resource res;
-	resource_size_t offset;
-};
-
 bool acpi_dev_resource_memory(struct acpi_resource *ares, struct resource *res);
 bool acpi_dev_resource_io(struct acpi_resource *ares, struct resource *res);
 bool acpi_dev_resource_address_space(struct acpi_resource *ares,
@@ -300,12 +296,6 @@ unsigned long acpi_dev_irq_flags(u8 triggering, u8 polarity, u8 shareable);
 bool acpi_dev_resource_interrupt(struct acpi_resource *ares, int index,
 				 struct resource *res);
 
-struct resource_list_entry {
-	struct list_head node;
-	struct resource res;
-	resource_size_t offset;
-};
-
 void acpi_dev_free_resource_list(struct list_head *list);
 int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
 			   int (*preproc)(struct acpi_resource *, void *),
diff --git a/include/linux/resource_ext.h b/include/linux/resource_ext.h
new file mode 100644
index 000000000000..ea385e513ab1
--- /dev/null
+++ b/include/linux/resource_ext.h
@@ -0,0 +1,77 @@
+/*
+ * Copyright (C) 2015, Intel Corporation
+ * Author: Jiang Liu <jiang.liu@linux.intel.com>
+ *
+ * This program is free software; you can redistribute it and/or modify it
+ * under the terms and conditions of the GNU General Public License,
+ * version 2, as published by the Free Software Foundation.
+ *
+ * This program is distributed in the hope it will be useful, but WITHOUT
+ * ANY WARRANTY; without even the implied warranty of MERCHANTABILITY or
+ * FITNESS FOR A PARTICULAR PURPOSE.  See the GNU General Public License for
+ * more details.
+ */
+#ifndef _LINUX_RESOURCE_EXT_H
+#define _LINUX_RESOURCE_EXT_H
+#include <linux/types.h>
+#include <linux/list.h>
+#include <linux/ioport.h>
+#include <linux/slab.h>
+
+/* Represent resource window for bridge devices */
+struct resource_win {
+	struct resource res;		/* In master (CPU) address space */
+	resource_size_t offset;		/* Translation offset for bridge */
+};
+
+/*
+ * Common resource list management data structure and interfaces to support
+ * ACPI, PNP and PCI host bridge etc.
+ */
+struct resource_list_entry {
+	struct list_head	node;
+	struct resource		*res;	/* In master (CPU) address space */
+	resource_size_t		offset;	/* Translation offset for bridge */
+	struct resource		__res;	/* Default storage for res */
+};
+
+extern struct resource_list_entry *
+resource_list_create_entry(struct resource *res, size_t extra_size);
+extern void resource_list_free(struct list_head *head);
+
+static inline void resource_list_add(struct resource_list_entry *entry,
+				     struct list_head *head)
+{
+	list_add(&entry->node, head);
+}
+
+static inline void resource_list_add_tail(struct resource_list_entry *entry,
+					  struct list_head *head)
+{
+	list_add_tail(&entry->node, head);
+}
+
+static inline void resource_list_del(struct resource_list_entry *entry)
+{
+	list_del(&entry->node);
+}
+
+static inline void resource_list_free_entry(struct resource_list_entry *entry)
+{
+	kfree(entry);
+}
+
+static inline void
+resource_list_destroy_entry(struct resource_list_entry *entry)
+{
+	resource_list_del(entry);
+	resource_list_free_entry(entry);
+}
+
+#define resource_list_for_each_entry(entry, list)	\
+	list_for_each_entry((entry), (list), node)
+
+#define resource_list_for_each_entry_safe(entry, tmp, list)	\
+	list_for_each_entry_safe((entry), (tmp), (list), node)
+
+#endif /* _LINUX_RESOURCE_EXT_H */
diff --git a/kernel/resource.c b/kernel/resource.c
index 0bcebffc4e77..d8b3b0e9658a 100644
--- a/kernel/resource.c
+++ b/kernel/resource.c
@@ -22,6 +22,7 @@
 #include <linux/device.h>
 #include <linux/pfn.h>
 #include <linux/mm.h>
+#include <linux/resource_ext.h>
 #include <asm/io.h>
 
 
@@ -1529,6 +1530,30 @@ int iomem_is_exclusive(u64 addr)
 	return err;
 }
 
+struct resource_list_entry *resource_list_create_entry(struct resource *res,
+						       size_t extra_size)
+{
+	struct resource_list_entry *entry;
+
+	entry = kzalloc(sizeof(*entry) + extra_size, GFP_KERNEL);
+	if (entry) {
+		INIT_LIST_HEAD(&entry->node);
+		entry->res = res ? res : &entry->__res;
+	}
+
+	return entry;
+}
+EXPORT_SYMBOL(resource_list_create_entry);
+
+void resource_list_free(struct list_head *head)
+{
+	struct resource_list_entry *entry, *tmp;
+
+	list_for_each_entry_safe(entry, tmp, head, node)
+		resource_list_destroy_entry(entry);
+}
+EXPORT_SYMBOL(resource_list_free);
+
 static int __init strict_iomem(char *str)
 {
 	if (strstr(str, "relaxed"))
-- 
1.7.10.4

