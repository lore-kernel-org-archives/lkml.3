Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756152Ab3GDK1f (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Jul 2013 06:27:35 -0400
Received: from mga02.intel.com ([134.134.136.20]:4990 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755186Ab3GDK1d (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Jul 2013 06:27:33 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,994,1363158000"; 
   d="scan'208";a="340407254"
From: Qiaowei Ren <qiaowei.ren@intel.com>
To: Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: linux-kernel@vger.kernel.org, Gang Wei <gang.wei@intel.com>,
        Qiaowei Ren <qiaowei.ren@intel.com>
Subject: [PATCH] x86, tboot: iomem fixes
Date: Thu,  4 Jul 2013 18:16:55 +0800
Message-Id: <1372933015-26584-1-git-send-email-qiaowei.ren@intel.com>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Fixes for iomem annotations in arch/x86/kernel/tboot.c

Signed-off-by: Qiaowei Ren <qiaowei.ren@intel.com>
---
 arch/x86/kernel/tboot.c |   43 +++++++++++--------------------------------
 1 file changed, 11 insertions(+), 32 deletions(-)

diff --git a/arch/x86/kernel/tboot.c b/arch/x86/kernel/tboot.c
index 3ff42d2..d06574c 100644
--- a/arch/x86/kernel/tboot.c
+++ b/arch/x86/kernel/tboot.c
@@ -442,33 +442,12 @@ late_initcall(tboot_late_init);
 #define TXTCR_HEAP_BASE             0x0300
 #define TXTCR_HEAP_SIZE             0x0308
 
-#define SHA1_SIZE      20
-
-struct sha1_hash {
-	u8 hash[SHA1_SIZE];
-};
-
-struct sinit_mle_data {
-	u32               version;             /* currently 6 */
-	struct sha1_hash  bios_acm_id;
-	u32               edx_senter_flags;
-	u64               mseg_valid;
-	struct sha1_hash  sinit_hash;
-	struct sha1_hash  mle_hash;
-	struct sha1_hash  stm_hash;
-	struct sha1_hash  lcp_policy_hash;
-	u32               lcp_policy_control;
-	u32               rlp_wakeup_addr;
-	u32               reserved;
-	u32               num_mdrs;
-	u32               mdrs_off;
-	u32               num_vtd_dmars;
-	u32               vtd_dmars_off;
-} __packed;
+#define SINIT_MLE_DATA_VTD_DMAR_OFF	140
 
 struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tbl)
 {
-	void *heap_base, *heap_ptr, *config;
+	void __iomem *heap_base, *heap_ptr, *config;
+	u32 dmar_tbl_off;
 
 	if (!tboot_enabled())
 		return dmar_tbl;
@@ -485,25 +464,25 @@ struct acpi_table_header *tboot_get_dmar_table(struct acpi_table_header *dmar_tb
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

