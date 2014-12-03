Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752654AbaLCHx5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Dec 2014 02:53:57 -0500
Received: from mga11.intel.com ([192.55.52.93]:60624 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752288AbaLCHu0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Dec 2014 02:50:26 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,506,1413270000"; 
   d="scan'208";a="631852381"
From: Feng Wu <feng.wu@intel.com>
To: tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org,
        gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org,
        joro@8bytes.org, alex.williamson@redhat.com, jiang.liu@linux.intel.com
Cc: linux-kernel@vger.kernel.org, iommu@lists.linux-foundation.org,
        kvm@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [v2 15/25] KVM: Make struct kvm_irq_routing_table accessible
Date: Wed,  3 Dec 2014 15:39:44 +0800
Message-Id: <1417592394-24343-16-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
References: <1417592394-24343-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Move struct kvm_irq_routing_table from irqchip.c to kvm_host.h,
so we can use it outside of irqchip.c.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 include/linux/kvm_host.h |   19 +++++++++++++++++++
 virt/kvm/irqchip.c       |   11 -----------
 2 files changed, 19 insertions(+), 11 deletions(-)

diff --git a/include/linux/kvm_host.h b/include/linux/kvm_host.h
index 0b9659d..cfa85ac 100644
--- a/include/linux/kvm_host.h
+++ b/include/linux/kvm_host.h
@@ -335,6 +335,25 @@ struct kvm_kernel_irq_routing_entry {
 	struct hlist_node link;
 };
 
+#ifdef CONFIG_HAVE_KVM_IRQ_ROUTING
+
+struct kvm_irq_routing_table {
+	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
+	struct kvm_kernel_irq_routing_entry *rt_entries;
+	u32 nr_rt_entries;
+	/*
+	 * Array indexed by gsi. Each entry contains list of irq chips
+	 * the gsi is connected to.
+	 */
+	struct hlist_head map[0];
+};
+
+#else
+
+struct kvm_irq_routing_table {};
+
+#endif
+
 #ifndef KVM_PRIVATE_MEM_SLOTS
 #define KVM_PRIVATE_MEM_SLOTS 0
 #endif
diff --git a/virt/kvm/irqchip.c b/virt/kvm/irqchip.c
index 7f256f3..cdf29a6 100644
--- a/virt/kvm/irqchip.c
+++ b/virt/kvm/irqchip.c
@@ -31,17 +31,6 @@
 #include <trace/events/kvm.h>
 #include "irq.h"
 
-struct kvm_irq_routing_table {
-	int chip[KVM_NR_IRQCHIPS][KVM_IRQCHIP_NUM_PINS];
-	struct kvm_kernel_irq_routing_entry *rt_entries;
-	u32 nr_rt_entries;
-	/*
-	 * Array indexed by gsi. Each entry contains list of irq chips
-	 * the gsi is connected to.
-	 */
-	struct hlist_head map[0];
-};
-
 int kvm_irq_map_gsi(struct kvm *kvm,
 		    struct kvm_kernel_irq_routing_entry *entries, int gsi)
 {
-- 
1.7.1

