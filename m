Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752383AbaKJGlJ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 10 Nov 2014 01:41:09 -0500
Received: from mga11.intel.com ([192.55.52.93]:54485 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751325AbaKJGgb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 10 Nov 2014 01:36:31 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.07,351,1413270000"; 
   d="scan'208";a="629364122"
From: Feng Wu <feng.wu@intel.com>
To: gleb@kernel.org, pbonzini@redhat.com, dwmw2@infradead.org, joro@8bytes.org,
        tglx@linutronix.de, mingo@redhat.com, hpa@zytor.com, x86@kernel.org
Cc: kvm@vger.kernel.org, iommu@lists.linux-foundation.org,
        linux-kernel@vger.kernel.org, Feng Wu <feng.wu@intel.com>
Subject: [PATCH 04/13] iommu/vt-d: Adjust 'struct irte' to better suit for VT-d Posted-Interrupts
Date: Mon, 10 Nov 2014 14:26:43 +0800
Message-Id: <1415600812-27773-5-git-send-email-feng.wu@intel.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
References: <1415600812-27773-1-git-send-email-feng.wu@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adjusts the definition of 'struct irte', so that we can
add the VT-d Posted-Interrtups format in this structure later.

Signed-off-by: Feng Wu <feng.wu@intel.com>
---
 drivers/iommu/intel_irq_remapping.c |   35 +++++++++++++++++++----------------
 include/linux/dmar.h                |    4 ++--
 2 files changed, 21 insertions(+), 18 deletions(-)

diff --git a/drivers/iommu/intel_irq_remapping.c b/drivers/iommu/intel_irq_remapping.c
index f99f0f1..776da10 100644
--- a/drivers/iommu/intel_irq_remapping.c
+++ b/drivers/iommu/intel_irq_remapping.c
@@ -310,9 +310,9 @@ static void set_irte_sid(struct irte *irte, unsigned int svt,
 {
 	if (disable_sourceid_checking)
 		svt = SVT_NO_VERIFY;
-	irte->svt = svt;
-	irte->sq = sq;
-	irte->sid = sid;
+	irte->irq_remap_high.svt = svt;
+	irte->irq_remap_high.sq = sq;
+	irte->irq_remap_high.sid = sid;
 }
 
 static int set_ioapic_sid(struct irte *irte, int apic)
@@ -917,8 +917,8 @@ static void prepare_irte(struct irte *irte, int vector,
 {
 	memset(irte, 0, sizeof(*irte));
 
-	irte->present = 1;
-	irte->dst_mode = apic->irq_dest_mode;
+	irte->irq_remap_low.present = 1;
+	irte->irq_remap_low.dst_mode = apic->irq_dest_mode;
 	/*
 	 * Trigger mode in the IRTE will always be edge, and for IO-APIC, the
 	 * actual level or edge trigger will be setup in the IO-APIC
@@ -926,11 +926,11 @@ static void prepare_irte(struct irte *irte, int vector,
 	 * For more details, see the comments (in io_apic.c) explainig IO-APIC
 	 * irq migration in the presence of interrupt-remapping.
 	*/
-	irte->trigger_mode = 0;
-	irte->dlvry_mode = apic->irq_delivery_mode;
-	irte->vector = vector;
-	irte->dest_id = IRTE_DEST(dest);
-	irte->redir_hint = 1;
+	irte->irq_remap_low.trigger_mode = 0;
+	irte->irq_remap_low.dlvry_mode = apic->irq_delivery_mode;
+	irte->irq_remap_low.vector = vector;
+	irte->irq_remap_low.dest_id = IRTE_DEST(dest);
+	irte->irq_remap_low.redir_hint = 1;
 }
 
 static int intel_setup_ioapic_entry(int irq,
@@ -973,10 +973,13 @@ static int intel_setup_ioapic_entry(int irq,
 		"Redir_hint:%d Trig_Mode:%d Dlvry_Mode:%X "
 		"Avail:%X Vector:%02X Dest:%08X "
 		"SID:%04X SQ:%X SVT:%X)\n",
-		attr->ioapic, irte.present, irte.fpd, irte.dst_mode,
-		irte.redir_hint, irte.trigger_mode, irte.dlvry_mode,
-		irte.avail, irte.vector, irte.dest_id,
-		irte.sid, irte.sq, irte.svt);
+		attr->ioapic, irte.irq_remap_low.present,
+		irte.irq_remap_low.fpd, irte.irq_remap_low.dst_mode,
+		irte.irq_remap_low.redir_hint, irte.irq_remap_low.trigger_mode,
+		irte.irq_remap_low.dlvry_mode, irte.irq_remap_low.avail,
+		irte.irq_remap_low.vector, irte.irq_remap_low.dest_id,
+		irte.irq_remap_high.sid, irte.irq_remap_high.sq,
+		irte.irq_remap_high.svt);
 
 	entry = (struct IR_IO_APIC_route_entry *)route_entry;
 	memset(entry, 0, sizeof(*entry));
@@ -1046,8 +1049,8 @@ intel_ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 		return err;
 	}
 
-	irte.vector = cfg->vector;
-	irte.dest_id = IRTE_DEST(dest);
+	irte.irq_remap_low.vector = cfg->vector;
+	irte.irq_remap_low.dest_id = IRTE_DEST(dest);
 
 	/*
 	 * Atomically updates the IRTE with the new destination, vector
diff --git a/include/linux/dmar.h b/include/linux/dmar.h
index 593fff9..8be5d42 100644
--- a/include/linux/dmar.h
+++ b/include/linux/dmar.h
@@ -159,7 +159,7 @@ struct irte {
 				vector		: 8,
 				__reserved_2	: 8,
 				dest_id		: 32;
-		};
+		} irq_remap_low;
 		__u64 low;
 	};
 
@@ -169,7 +169,7 @@ struct irte {
 				sq		: 2,
 				svt		: 2,
 				__reserved_3	: 44;
-		};
+		} irq_remap_high;
 		__u64 high;
 	};
 };
-- 
1.7.1

