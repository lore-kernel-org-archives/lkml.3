Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753174AbaIKIW7 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 04:22:59 -0400
Received: from mga09.intel.com ([134.134.136.24]:19391 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753056AbaIKIWz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 04:22:55 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.04,504,1406617200"; 
   d="scan'208";a="571629031"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Grant Likely <grant.likely@linaro.org>
Cc: Jiang Liu <jiang.liu@linux.intel.com>,
        Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>, x86@kernel.org,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [RFC Part1 v1 06/18] x86, irq: Protect __clear_irq_vector() with vector_lock
Date: Thu, 11 Sep 2014 16:24:53 +0800
Message-Id: <1410423905-26239-7-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
References: <1410423905-26239-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function __clear_irq_vector() accesses vector related data structure,
so protect it with vector_lock. Also rename it as clear_irq_vector().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/io_apic.c |   19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 814527753563..ee3d3ff521a3 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1349,10 +1349,12 @@ int assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	return err;
 }
 
-static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
+static void clear_irq_vector(int irq, struct irq_cfg *cfg)
 {
 	int cpu, vector;
+	unsigned long flags;
 
+	raw_spin_lock_irqsave(&vector_lock, flags);
 	BUG_ON(!cfg->vector);
 
 	vector = cfg->vector;
@@ -1362,8 +1364,11 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 	cfg->vector = 0;
 	cpumask_clear(cfg->domain);
 
-	if (likely(!cfg->move_in_progress))
+	if (likely(!cfg->move_in_progress)) {
+		raw_spin_unlock_irqrestore(&vector_lock, flags);
 		return;
+	}
+
 	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS; vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
@@ -1373,6 +1378,7 @@ static void __clear_irq_vector(int irq, struct irq_cfg *cfg)
 		}
 	}
 	cfg->move_in_progress = 0;
+	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
 void __setup_vector_irq(int cpu)
@@ -1499,7 +1505,7 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 					 &dest)) {
 		pr_warn("Failed to obtain apicid for ioapic %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		__clear_irq_vector(irq, cfg);
+		clear_irq_vector(irq, cfg);
 
 		return;
 	}
@@ -1513,7 +1519,7 @@ static void setup_ioapic_irq(unsigned int irq, struct irq_cfg *cfg,
 	if (x86_io_apic_ops.setup_entry(irq, &entry, dest, cfg->vector, attr)) {
 		pr_warn("Failed to setup ioapic entry for ioapic  %d, pin %d\n",
 			mpc_ioapic_id(attr->ioapic), attr->ioapic_pin);
-		__clear_irq_vector(irq, cfg);
+		clear_irq_vector(irq, cfg);
 
 		return;
 	}
@@ -3082,12 +3088,9 @@ int arch_setup_hwirq(unsigned int irq, int node)
 void arch_teardown_hwirq(unsigned int irq)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
-	unsigned long flags;
 
 	free_remapped_irq(irq);
-	raw_spin_lock_irqsave(&vector_lock, flags);
-	__clear_irq_vector(irq, cfg);
-	raw_spin_unlock_irqrestore(&vector_lock, flags);
+	clear_irq_vector(irq, cfg);
 	free_irq_cfg(irq, cfg);
 }
 
-- 
1.7.10.4

