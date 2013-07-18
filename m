Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757045Ab3GRISy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Jul 2013 04:18:54 -0400
Received: from mga09.intel.com ([134.134.136.24]:43652 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751972Ab3GRISv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Jul 2013 04:18:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,691,1367996400"; 
   d="scan'208";a="347647378"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH v3] x86, tboot: iomem fixes
Date: Thu, 18 Jul 2013 16:07:54 +0800
Message-Id: <1374134874-8161-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Current code doesn't use specific interface to access I/O space.
So some potential bugs can be caused. We can fix this by using
specific API.

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/kernel/tboot.c |   21 ++++++++++++---------
 1 file changed, 12 insertions(+), 9 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 3ff42d2..afe8cf8 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -466,9 +466,12 @@ struct sinit_mle_data {
 	u32               vtd_dmars_off;
 } __packed;
 
+#define SINIT_MLE_DATA_VTD_DMAR_OFF	140
+
 struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tbl)
 {
-	void *heap_base, *heap_ptr, *config;
+	void __iomem *heap_base, *heap_ptr, *config;
+	u32 dmar_tbl_off;
 
 	if (!tboot_enabled())
 		return dmar_tbl;
@@ -485,25 +488,25 @@ struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tb
 		return NULL;
 
 	/* now map TXT heap */
-	heap_base = ioremap(*(u64 *)(config + TXTCR_HEAP_BASE),
-			    *(u64 *)(config + TXTCR_HEAP_SIZE));
+	heap_base = ioremap(readl(config + TXTCR_HEAP_BASE),
+			    readl(config + TXTCR_HEAP_SIZE));
 	iounmap(config);
 	if (!heap_base)
 		return NULL;
 
 	/* walk heap to SinitMleData */
 	/* skip BiosData */
-	heap_ptr = heap_base + *(u64 *)heap_base;
+	heap_ptr = heap_base + readq(heap_base);
 	/* skip OsMleData */
-	heap_ptr += *(u64 *)heap_ptr;
+	heap_ptr += readq(heap_ptr);
 	/* skip OsSinitData */
-	heap_ptr += *(u64 *)heap_ptr;
+	heap_ptr += readq(heap_ptr);
 	/* now points to SinitMleDataSize; set to SinitMleData */
 	heap_ptr += sizeof(u64);
 	/* get addr of DMAR table */
-	dmar_tbl = (struct acpi_table_header *)(heap_ptr +
-		   ((struct sinit_mle_data *)heap_ptr)->vtd_dmars_off -
-		   sizeof(u64));
+	dmar_tbl_off = readl(heap_ptr + SINIT_MLE_DATA_VTD_DMAR_OFF);
+	memcpy_fromio(dmar_tbl, heap_ptr + dmar_tbl_off - sizeof(u64),
+			sizeof(struct acpi_table_header));
 
 	/* don't unmap heap because dmar.c needs access to this */
 
-- 
1.7.9.5

