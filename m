Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752193AbaLCHuG (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:50:06 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752161AbaLCHuC (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:02 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852275"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 08/25] iommu, x86: Add intel_irq_remapping_capability() for Intel
Date: Wed,  3 Dec 2014 15:39:37 +0800
Message-Id: <1417592394-24343-9-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add the Intel side implementation for capability in
struct irq_remap_ops.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   27 +++++++++++++++++++++++++++
 drivers/iommu/irq_remapping.c       |    2 ++
 drivers/iommu/irq_remapping.h       |    4 ++++
 3 files changed, 33 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 01786a8..827aeff 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -651,6 +651,32 @@ error:
 	return -1;
 }
 
+static bool intel_irq_remapping_capability(enum irq_remap_cap cap)
+{
+	struct dmar_drhd_unit *drhd;
+	struct intel_iommu *iommu;
+
+	switch (cap) {
+	case IRQ_POSTING_CAP:
+		/*
+		 * If 1) posted-interrupts is disabled by user
+		 * or 2) irq remapping is disabled, posted-interrupts
+		 * is not supported.
+		 */
+		if (disable_irq_post || !irq_remapping_enabled)
+			return 0;
+
+		for_each_iommu(iommu, drhd)
+			if (!cap_pi_support(iommu->cap))
+				return 0;
+
+		return 1;
+	default:
+		pr_warn("Unknown irq remapping capability.\n");
+		return 0;
+	}
+}
+
 static int ir_parse_one_hpet_scope(struct acpi_dmar_device_scope *scope,
 				   struct intel_iommu *iommu,
 				   struct acpi_dmar_hardware_unit *drhd)
@@ -947,6 +973,7 @@ static struct irq_domain *intel_get_irq_domain(struct irq_alloc_info *info)
 
 struct irq_remap_ops intel_irq_remap_ops = {
 	.supported		= intel_irq_remapping_supported,
+	.capability		= intel_irq_remapping_capability,
 	.prepare		= dmar_table_init,
 	.enable			= intel_enable_irq_remapping,
 	.disable		= disable_irq_remapping,
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index 3c3da04..e63e969 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -24,6 +24,8 @@ int irq_remap_broken;
 int disable_sourceid_checking;
 int no_x2apic_optout;
 
+int disable_irq_post = 1;
+
 static struct irq_remap_ops *remap_ops;
 
 static void irq_remapping_disable_io_apic(void)
diff --git a/drivers/iommu/irq_remapping.h b/drivers/iommu/irq_remapping.h
index 2d991b2..cb1f46d 100644
--- a/drivers/iommu/irq_remapping.h
+++ b/drivers/iommu/irq_remapping.h
@@ -36,6 +36,8 @@ extern int disable_sourceid_checking;
 extern int no_x2apic_optout;
 extern int irq_remapping_enabled;
 
+extern int disable_irq_post;
+
 struct irq_remap_ops {
 	/* Check whether Interrupt Remapping is supported */
 	int (*supported)(void);
@@ -76,6 +78,8 @@ extern void ir_ack_apic_edge(struct irq_data *data);
 #define disable_irq_remap     1
 #define irq_remap_broken      0
 
+#define disable_irq_post      1
+
 #endif /* CONFIG_IRQ_REMAP */
 
 #endif /* __IRQ_REMAPPING_H */
-- 
1.7.1

