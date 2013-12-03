Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754884Ab3LCTnw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Dec 2013 14:43:52 -0500
Received: from g1t0027.austin.hp.com ([15.216.28.34]:37928 "EHLO
	g1t0027.austin.hp.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754105Ab3LCTmq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Dec 2013 14:42:46 -0500
From: Bill Sumner <bill.sumner@hp.com>
To: dwmw2@infradead.org, indou.takao@jp.fujitsu.com, bhe@redhat.com
Cc: iommu@lists.linux-foundation.org, kexec@lists.infradead.org,
        alex.williamson@redhat.com, linux-pci@vger.kernel.org,
        linux-kernel@vger.kernel.org, ddutile@redhat.com,
        ishii.hironobu@jp.fujitsu.com, bhelgaas@google.com, bill.sumner@hp.com,
        doug.hatch@hp.com
Subject: [PATCH 5/6] Crashdump-Accepting-Active-IOMMU-Debug-Print-IOMMU
Date: Tue,  3 Dec 2013 12:41:33 -0700
Message-Id: <1386099694-4190-6-git-send-email-bill.sumner@hp.com>
X-Mailer: git-send-email 1.7.11.3
In-Reply-To: <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
References: <Crashdump-Accepting-Active-IOMMU>
 <1386099694-4190-1-git-send-email-bill.sumner@hp.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Signed-off-by: Bill Sumner <bill.sumner@hp.com>
---
 drivers/iommu/intel-iommu.c | 76 +++++++++++++++++++++++++++++++++++++++++++++
 1 file changed, 76 insertions(+)

diff --git a/drivers/iommu/intel-iommu.c b/drivers/iommu/intel-iommu.c
index d9a49ad..19c1370 100644
--- a/drivers/iommu/intel-iommu.c
+++ b/drivers/iommu/intel-iommu.c
@@ -5322,3 +5322,79 @@ static int copy_intel_iommu_translation_tables(struct dmar_drhd_unit *drhd,
 	return 0;
 }
 #endif /* CONFIG_CRASH_DUMP */
+#ifdef CONFIG_CRASH_DUMP
+
+
+/* =========================================================================
+ * Diagnostic print
+ * ------------------------------------------------------------------------
+ */
+
+static struct intel_iommu_register_print {
+	int	len;		/* Length of register */
+	int	idx;		/* Index to read register */
+	char	reg[20];	/* Linux name of register */
+	char	txt[40];	/* Description */
+} intel_iommu_register_print_v[] = {
+	{1, DMAR_VER_REG,	"DMAR_VER_REG",		"Arch version supported by this IOMMU"},
+	{2, DMAR_CAP_REG,	"DMAR_CAP_REG",		"Hardware supported capabilities"},
+	{2, DMAR_ECAP_REG,	"DMAR_ECAP_REG",	"Extended capabilities supported"},
+	{1, DMAR_GCMD_REG,	"DMAR_GCMD_REG",	"Global command register"},
+	{1, DMAR_GSTS_REG,	"DMAR_GSTS_REG",	"Global status register "},
+	{2, DMAR_RTADDR_REG,	"DMAR_RTADDR_REG",	"Root entry table"},
+	{2, DMAR_CCMD_REG,	"DMAR_CCMD_REG",	"Context command reg"},
+	{1, DMAR_FSTS_REG,	"DMAR_FSTS_REG",	"Fault Status register"},
+	{1, DMAR_FECTL_REG,	"DMAR_FECTL_REG",	"Fault control register"},
+	{1, DMAR_FEDATA_REG,	"DMAR_FEDATA_REG",	"Fault event interrupt data register"},
+	{1, DMAR_FEADDR_REG,	"DMAR_FEADDR_REG",	"Fault event interrupt addr register"},
+	{1, DMAR_FEUADDR_REG,	"DMAR_FEUADDR_REG",	"Upper address register"},
+	{2, DMAR_AFLOG_REG,	"DMAR_AFLOG_REG",	"Advanced Fault control"},
+	{1, DMAR_PMEN_REG,	"DMAR_PMEN_REG",	"Enable Protected Memory Region"},
+	{1, DMAR_PLMBASE_REG,	"DMAR_PLMBASE_REG",	"PMRR Low addr"},
+	{1, DMAR_PLMLIMIT_REG,	"DMAR_PLMLIMIT_REG",	"PMRR low limit"},
+	{2, DMAR_PHMBASE_REG,	"DMAR_PHMBASE_REG",	"pmrr high base addr"},
+	{2, DMAR_PHMLIMIT_REG,	"DMAR_PHMLIMIT_REG",	"pmrr high limit"},
+	{2, DMAR_IQH_REG,	"DMAR_IQH_REG",		"Invalidation queue head register"},
+	{2, DMAR_IQT_REG,	"DMAR_IQT_REG",		"Invalidation queue tail register"},
+	{2, DMAR_IQA_REG,	"DMAR_IQA_REG",		"Invalidation queue addr register"},
+	{1, DMAR_ICS_REG,	"DMAR_ICS_REG",		"Invalidation complete status register"},
+	{2, DMAR_IRTA_REG,	"DMAR_IRTA_REG",	"Interrupt remapping table addr register"},
+};
+
+static void print_intel_iommu_registers(struct dmar_drhd_unit *drhd)
+{
+	struct intel_iommu *iommu;	/* Virt adr(iommu hardware registers) */
+	unsigned long long q;		/* quadword scratch */
+	u32 ver;			/* DMAR_VER_REG */
+
+	int m = sizeof(intel_iommu_register_print_v) /
+		sizeof(intel_iommu_register_print_v[0]);
+	struct intel_iommu_register_print *p = &intel_iommu_register_print_v[0];
+
+	iommu = drhd->iommu;
+
+	pr_debug("ENTER %s\n", __func__);
+	ver = readl(iommu->reg + DMAR_VER_REG);
+	pr_debug("IOMMU %d: reg_base_addr %llx ver %d:%d cap %llx ecap %llx\n",
+		iommu->seq_id,
+		(unsigned long long)drhd->reg_base_addr,
+		DMAR_VER_MAJOR(ver), DMAR_VER_MINOR(ver),
+		(unsigned long long)iommu->cap,
+		(unsigned long long)iommu->ecap);
+
+	q = readq(iommu->reg + DMAR_RTADDR_REG);
+	pr_debug("IOMMU %d: DMAR_RTADDR_REG:0x%16.16llx\n", iommu->seq_id, q);
+
+	for (; p < &intel_iommu_register_print_v[m]; p++)
+		if (p->len == 2)
+			pr_debug("0x%16.16llx %-20s %-40s\n",
+				(u64)readq(iommu->reg + p->idx), p->reg,
+						p->txt);
+		else
+			pr_debug("        0x%8.8x %-20s %-40s\n",
+				(u32)readl(iommu->reg + p->idx), p->reg,
+						p->txt);
+
+	pr_debug("LEAVE %s\n", __func__);
+}
+#endif /* CONFIG_CRASH_DUMP */
-- 
Bill Sumner <bill.sumner@hp.com>

