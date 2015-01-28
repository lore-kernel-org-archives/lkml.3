Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757246AbbA1UYi (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 Jan 2015 15:24:38 -0500
Received: from mga01.intel.com ([192.55.52.88]:20300 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757169AbbA1UY1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 Jan 2015 15:24:27 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,480,1418112000"; 
   d="scan'208";a="677269091"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Thomas Gleixner <tglx@linutronix.de>,
        Bjorn Helgaas <bhelgaas@google.com>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Lv Zheng <lv.zheng@intel.com>,
        Len Brown <lenb@kernel.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>, Tony Luck <tony.luck@intel.com>,
        x86@kernel.org, linux-kernel@vger.kernel.org,
        linux-pci@vger.kernel.org, linux-acpi@vger.kernel.org
Subject: [Patch v2 16/22] ACPI: Introduce helper function acpi_dev_filter_resource_type()
Date: Wed, 28 Jan 2015 18:57:34 +0800
Message-Id: <1422442660-455-17-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
References: <1422442660-455-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce helper function acpi_dev_filter_resource_type(), which may
be used by acpi_dev_get_resources() to filer out resource based on
resource type.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/acpi/resource.c |   55 +++++++++++++++++++++++++++++++++++++++++++++++
 include/linux/acpi.h    |    8 +++++++
 2 files changed, 63 insertions(+)

diff --git a/drivers/acpi/resource.c b/drivers/acpi/resource.c
index 1c3abae6f2fa..3ea0d17eb951 100644
--- a/drivers/acpi/resource.c
+++ b/drivers/acpi/resource.c
@@ -569,3 +569,58 @@ int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
 	return c.count;
 }
 EXPORT_SYMBOL_GPL(acpi_dev_get_resources);
+
+/**
+ * acpi_dev_filter_resource_type - Filter ACPI resource according to resource
+ *				   types
+ * @ares: Input ACPI resource object.
+ * @types: Valid resource types of IORESOURCE_XXX
+ *
+ * This is a hepler function to support acpi_dev_get_resources(), which filters
+ * ACPI resource objects according to resource types.
+ */
+int acpi_dev_filter_resource_type(struct acpi_resource *ares,
+				  unsigned long types)
+{
+	unsigned long type = 0;
+
+	switch (ares->type) {
+	case ACPI_RESOURCE_TYPE_MEMORY24:
+	case ACPI_RESOURCE_TYPE_MEMORY32:
+	case ACPI_RESOURCE_TYPE_FIXED_MEMORY32:
+		type = IORESOURCE_MEM;
+		break;
+	case ACPI_RESOURCE_TYPE_IO:
+	case ACPI_RESOURCE_TYPE_FIXED_IO:
+		type = IORESOURCE_IO;
+		break;
+	case ACPI_RESOURCE_TYPE_IRQ:
+	case ACPI_RESOURCE_TYPE_EXTENDED_IRQ:
+		type = IORESOURCE_IRQ;
+		break;
+	case ACPI_RESOURCE_TYPE_DMA:
+	case ACPI_RESOURCE_TYPE_FIXED_DMA:
+		type = IORESOURCE_DMA;
+		break;
+	case ACPI_RESOURCE_TYPE_GENERIC_REGISTER:
+		type = IORESOURCE_REG;
+		break;
+	case ACPI_RESOURCE_TYPE_ADDRESS16:
+	case ACPI_RESOURCE_TYPE_ADDRESS32:
+	case ACPI_RESOURCE_TYPE_ADDRESS64:
+	case ACPI_RESOURCE_TYPE_EXTENDED_ADDRESS64:
+		if (ares->data.address.resource_type == ACPI_MEMORY_RANGE)
+			type = IORESOURCE_MEM;
+		else if (ares->data.address.resource_type == ACPI_IO_RANGE)
+			type = IORESOURCE_IO;
+		else if (ares->data.address.resource_type ==
+			 ACPI_BUS_NUMBER_RANGE)
+			type = IORESOURCE_BUS;
+		break;
+	default:
+		break;
+	}
+
+	return (type & types) ? 0 : 1;
+}
+EXPORT_SYMBOL_GPL(acpi_dev_filter_resource_type);
diff --git a/include/linux/acpi.h b/include/linux/acpi.h
index 21dac3cb62d2..e818decb631f 100644
--- a/include/linux/acpi.h
+++ b/include/linux/acpi.h
@@ -310,6 +310,14 @@ void acpi_dev_free_resource_list(struct list_head *list);
 int acpi_dev_get_resources(struct acpi_device *adev, struct list_head *list,
 			   int (*preproc)(struct acpi_resource *, void *),
 			   void *preproc_data);
+int acpi_dev_filter_resource_type(struct acpi_resource *ares,
+				  unsigned long types);
+
+static inline int acpi_dev_filter_resource_type_cb(struct acpi_resource *ares,
+						   void *arg)
+{
+	return acpi_dev_filter_resource_type(ares, (unsigned long)arg);
+}
 
 int acpi_check_resource_conflict(const struct resource *res);
 
-- 
1.7.10.4

