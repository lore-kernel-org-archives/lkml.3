Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752153AbaKJGi3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:38:29 -0500
Received: from mga11.intel.com ([192.55.52.93]:54509 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751918AbaKJGgj (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:39 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364157"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 12/13] iommu/vt-d: No need to migrating irq for VT-d Posted-Interrtups
Date: Mon, 10 Nov 2014 14:26:51 +0800
Message-Id: <1415600812-27773-13-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We don't need to migrate the irqs for VT-d Posted-Interrtups here.
When 'pst' is set in IRTE, the associated irq will be posted to
guests instead of interrupt remapping. The destination of the
interrupt is set in Posted-Interrupts Descriptor, and the migration
happens during VCPU scheduling.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 drivers/iommu/intel_irq_remapping.c |    7 +++++++
 1 files changed, 7 insertions(+), 0 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index 87c02fe..249e2b1 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -1038,6 +1038,13 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	if (get_irte(irq, &irte))
 		return -EBUSY;
 
+	/*
+	 * If the interrupt is for posting, it is used by guests,
+	 * we cannot change IRTE here.
+	 */
+	if (irte.irq_post_low.pst == 1)
+		return 0;
+
 	err = assign_irq_vector(irq, cfg, mask);
 	if (err)
 		return err;
-- 
1.7.1

