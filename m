Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752675Ab3JRIjM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 18 Oct 2013 04:39:12 -0400
Received: from mga09.intel.com ([134.134.136.24]:9454 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752512Ab3JRIjH (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 18 Oct 2013 04:39:07 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,520,1378882800"; 
   d="scan'208";a="421045760"
From: "Chen, Gong" <gong.chen@linux.intel.com>
To: tony.luck@intel.com, bp@alien8.de, joe@perches.com,
        naveen.n.rao@linux.vnet.ibm.com, m.chehab@samsung.com
Cc: arozansk@redhat.com, linux-acpi@vger.kernel.org,
        linux-kernel@vger.kernel.org, "Chen, Gong" <gong.chen@linux.intel.com>
Subject: [PATCH v3 7/9] ACPI, APEI, CPER: Enhance memory reporting capability
Date: Fri, 18 Oct 2013 04:23:42 -0400
Message-Id: <1382084624-10857-8-git-send-email-gong.chen@linux.intel.com>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
References: <1382084624-10857-1-git-send-email-gong.chen@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After H/W error happens under FFM enabled mode, lots of information
are shown but some important parts like DIMM location missed. This
patch is used to show these extra fileds.

Original-author: Tony Luck <tony.luck@intel.com>
Signed-off-by: Chen, Gong <gong.chen@linux.intel.com>
Acked-by: Naveen N. Rao <naveen.n.rao@linux.vnet.ibm.com>
Acked-by: Borislav Petkov <bp@suse.de>
Reviewed-by: Mauro Carvalho Chehab <m.chehab@samsung.com>
---
 drivers/acpi/apei/cper.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/drivers/acpi/apei/cper.c b/drivers/acpi/apei/cper.c
index 946ef52..b1a8a55 100644
--- a/drivers/acpi/apei/cper.c
+++ b/drivers/acpi/apei/cper.c
@@ -28,6 +28,7 @@
 #include <linux/module.h>
 #include <linux/time.h>
 #include <linux/cper.h>
+#include <linux/dmi.h>
 #include <linux/acpi.h>
 #include <linux/pci.h>
 #include <linux/aer.h>
@@ -210,6 +211,8 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 		printk("%s""card: %d\n", pfx, mem->card);
 	if (mem->validation_bits & CPER_MEM_VALID_MODULE)
 		printk("%s""module: %d\n", pfx, mem->module);
+	if (mem->validation_bits & CPER_MEM_VALID_RANK_NUMBER)
+		printk("%s""rank: %d\n", pfx, mem->rank);
 	if (mem->validation_bits & CPER_MEM_VALID_BANK)
 		printk("%s""bank: %d\n", pfx, mem->bank);
 	if (mem->validation_bits & CPER_MEM_VALID_DEVICE)
@@ -232,6 +235,15 @@ static void cper_print_mem(const char *pfx, const struct cper_sec_mem_err *mem)
 		       etype < ARRAY_SIZE(cper_mem_err_type_strs) ?
 		       cper_mem_err_type_strs[etype] : "unknown");
 	}
+	if (mem->validation_bits & CPER_MEM_VALID_MODULE_HANDLE) {
+		const char *bank = NULL, *device = NULL;
+		dmi_memdev_name(mem->mem_dev_handle, &bank, &device);
+		if (bank != NULL && device != NULL)
+			printk("%s""DIMM location: %s %s", pfx, bank, device);
+		else
+			printk("%s""DIMM DMI handle: 0x%.4x",
+			       pfx, mem->mem_dev_handle);
+	}
 }
 
 static const char *cper_pcie_port_type_strs[] = {
-- 
1.8.4.rc3

