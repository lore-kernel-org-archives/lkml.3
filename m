Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752708AbaLCHzZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:55:25 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752180AbaLCHuF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:05 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852295"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 09/25] iommu, x86: define irq_remapping_cap()
Date: Wed,  3 Dec 2014 15:39:38 +0800
Message-Id: <1417592394-24343-10-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a new interface irq_remapping_cap() to detect
whether irq remapping supports new features, such as VT-d
Posted-Interrupts. We export this function out, so that KVM
code can check this and use this mechanism properly.

Signed-off-by: Feng Wu <feng.wu@intel.com>
Reviewed-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/irq_remapping.h |    2 ++
 drivers/iommu/irq_remapping.c        |   12 ++++++++++++
 2 files changed, 14 insertions(+), 0 deletions(-)

diff --git a/arch/x86/include/asm/irq_remapping.h b/arch/x86/include/asm/irq_remapping.h
index f87ac70..b3ad067 100644
--- a/arch/x86/include/asm/irq_remapping.h
+++ b/arch/x86/include/asm/irq_remapping.h
@@ -37,6 +37,7 @@ enum irq_remap_cap {
 
 extern void setup_irq_remapping_ops(void);
 extern int irq_remapping_supported(void);
+extern bool irq_remapping_cap(enum irq_remap_cap cap);
 extern void set_irq_remapping_broken(void);
 extern int irq_remapping_prepare(void);
 extern int irq_remapping_enable(void);
@@ -69,6 +70,7 @@ struct vcpu_data {
 
 static inline void setup_irq_remapping_ops(void) { }
 static inline int irq_remapping_supported(void) { return 0; }
+static bool irq_remapping_cap(enum irq_remap_cap cap) { return 0; }
 static inline void set_irq_remapping_broken(void) { }
 static inline int irq_remapping_prepare(void) { return -ENODEV; }
 static inline int irq_remapping_enable(void) { return -ENODEV; }
diff --git a/drivers/iommu/irq_remapping.c b/drivers/iommu/irq_remapping.c
index e63e969..b008663 100644
--- a/drivers/iommu/irq_remapping.c
+++ b/drivers/iommu/irq_remapping.c
@@ -103,6 +103,18 @@ int irq_remapping_supported(void)
 	return remap_ops->supported();
 }
 
+bool irq_remapping_cap(enum irq_remap_cap cap)
+{
+	if (disable_irq_post)
+		return 0;
+
+	if (!remap_ops || !remap_ops->capability)
+		return 0;
+
+	return remap_ops->capability(cap);
+}
+EXPORT_SYMBOL_GPL(irq_remapping_cap);
+
 int __init irq_remapping_prepare(void)
 {
 	if (!remap_ops || !remap_ops->prepare)
-- 
1.7.1

