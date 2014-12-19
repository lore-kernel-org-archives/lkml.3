Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753064AbaLSOIT (ORCPT <rfc822;w@1wt.eu>);
	Fri, 19 Dec 2014 09:08:19 -0500
Received: from terminus.zytor.com ([198.137.202.10]:46101 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753021AbaLSOIQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 19 Dec 2014 09:08:16 -0500
Date: Fri, 19 Dec 2014 06:07:19 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-b794ef26f1b08f712f970fe07290b96f9e070746@git.kernel.org>
Cc: tony.luck@intel.com, grant.likely@linaro.org, rdunlap@infradead.org,
        bp@alien8.de, konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        hpa@zytor.com, prarit@redhat.com, linux-kernel@vger.kernel.org,
        rjw@rjwysocki.net, tglx@linutronix.de, bhelgaas@google.com,
        yinghai@kernel.org, joro@8bytes.org, mingo@kernel.org,
        gregkh@linuxfoundation.org, benh@kernel.crashing.org
Reply-To: bp@alien8.de, konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        tony.luck@intel.com, grant.likely@linaro.org, rdunlap@infradead.org,
        bhelgaas@google.com, yinghai@kernel.org, joro@8bytes.org,
        gregkh@linuxfoundation.org, mingo@kernel.org, benh@kernel.crashing.org,
        hpa@zytor.com, prarit@redhat.com, rjw@rjwysocki.net,
        linux-kernel@vger.kernel.org, tglx@linutronix.de
In-Reply-To: <1414397531-28254-8-git-send-email-jiang.liu@linux.intel.com>
References: <1414397531-28254-8-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Protect __clear_irq_vector()
  with vector_lock
Git-Commit-ID: b794ef26f1b08f712f970fe07290b96f9e070746
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  b794ef26f1b08f712f970fe07290b96f9e070746
Gitweb:     http://git.kernel.org/tip/b794ef26f1b08f712f970fe07290b96f9e070746
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Mon, 27 Oct 2014 16:11:58 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Tue, 16 Dec 2014 14:08:16 +0100

x86, irq: Protect __clear_irq_vector() with vector_lock

Function __clear_irq_vector() accesses vector related data structure,
so protect it with vector_lock. Also rename it as clear_irq_vector().

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Grant Likely <grant.likely@linaro.org>
Cc: Prarit Bhargava <prarit@redhat.com>
Link: http://lkml.kernel.org/r/1414397531-28254-8-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>

---
 arch/x86/kernel/apic/io_apic.c | 19 +++++++++++--------
 1 file changed, 11 insertions(+), 8 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 4d87133..ab8ca9327 100644
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
@@ -3083,12 +3089,9 @@ int arch_setup_hwirq(unsigned int irq, int node)
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
 
