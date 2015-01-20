Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753684AbbATF5S (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:57:18 -0500
Received: from mga11.intel.com ([192.55.52.93]:23692 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753665AbbATF5N (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:57:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664448758"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Bjorn Helgaas <bhelgaas@google.com>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, Dimitri Sivanich <sivanich@sgi.com>,
        x86@kernel.org, Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        David Cohen <david.a.cohen@linux.intel.com>,
        Sander Eikelenboom <linux@eikelenboom.it>,
        David Vrabel <david.vrabel@citrix.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org
Subject: [Patch Part2 v4 33/33] x86/irq: Avoid memory allocation in __assign_irq_vector()
Date: Tue, 20 Jan 2015 13:51:53 +0800
Message-Id: <1421733113-15704-34-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Function __assign_irq_vector() is protected by vector_lock, so use
a global temporary cpu_mask to avoid allocating/freeing cpu_mask.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/kernel/apic/vector.c |   33 +++++++++++++++++----------------
 1 file changed, 17 insertions(+), 16 deletions(-)

diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index f5eb3999383f..4a04b25cdcdf 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -30,6 +30,7 @@ struct apic_chip_data {
 
 struct irq_domain *x86_vector_domain;
 static DEFINE_RAW_SPINLOCK(vector_lock);
+static cpumask_var_t vector_cpumask;
 static struct irq_chip lapic_controller;
 #ifdef	CONFIG_X86_IO_APIC
 static struct apic_chip_data *legacy_irq_data[NR_IRQS_LEGACY];
@@ -116,14 +117,10 @@ static int __assign_irq_vector(int irq, struct apic_chip_data *d,
 	static int current_vector = FIRST_EXTERNAL_VECTOR + VECTOR_OFFSET_START;
 	static int current_offset = VECTOR_OFFSET_START % 16;
 	int cpu, err;
-	cpumask_var_t tmp_mask;
 
 	if (d->move_in_progress)
 		return -EBUSY;
 
-	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
-		return -ENOMEM;
-
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
 	cpumask_clear(d->old_domain);
@@ -131,21 +128,22 @@ static int __assign_irq_vector(int irq, struct apic_chip_data *d,
 	while (cpu < nr_cpu_ids) {
 		int new_cpu, vector, offset;
 
-		apic->vector_allocation_domain(cpu, tmp_mask, mask);
+		apic->vector_allocation_domain(cpu, vector_cpumask, mask);
 
-		if (cpumask_subset(tmp_mask, d->domain)) {
+		if (cpumask_subset(vector_cpumask, d->domain)) {
 			err = 0;
-			if (cpumask_equal(tmp_mask, d->domain))
+			if (cpumask_equal(vector_cpumask, d->domain))
 				break;
 			/*
 			 * New cpumask using the vector is a proper subset of
 			 * the current in use mask. So cleanup the vector
 			 * allocation for the members that are not used anymore.
 			 */
-			cpumask_andnot(d->old_domain, d->domain, tmp_mask);
+			cpumask_andnot(d->old_domain, d->domain,
+				       vector_cpumask);
 			d->move_in_progress =
 			   cpumask_intersects(d->old_domain, cpu_online_mask);
-			cpumask_and(d->domain, d->domain, tmp_mask);
+			cpumask_and(d->domain, d->domain, vector_cpumask);
 			break;
 		}
 
@@ -159,16 +157,18 @@ next:
 		}
 
 		if (unlikely(current_vector == vector)) {
-			cpumask_or(d->old_domain, d->old_domain, tmp_mask);
-			cpumask_andnot(tmp_mask, mask, d->old_domain);
-			cpu = cpumask_first_and(tmp_mask, cpu_online_mask);
+			cpumask_or(d->old_domain, d->old_domain,
+				   vector_cpumask);
+			cpumask_andnot(vector_cpumask, mask, d->old_domain);
+			cpu = cpumask_first_and(vector_cpumask,
+						cpu_online_mask);
 			continue;
 		}
 
 		if (test_bit(vector, used_vectors))
 			goto next;
 
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask) {
+		for_each_cpu_and(new_cpu, vector_cpumask, cpu_online_mask) {
 			if (per_cpu(vector_irq, new_cpu)[vector] >
 			    VECTOR_UNDEFINED)
 				goto next;
@@ -181,14 +181,13 @@ next:
 			d->move_in_progress =
 			   cpumask_intersects(d->old_domain, cpu_online_mask);
 		}
-		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
+		for_each_cpu_and(new_cpu, vector_cpumask, cpu_online_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
 		d->cfg.vector = vector;
-		cpumask_copy(d->domain, tmp_mask);
+		cpumask_copy(d->domain, vector_cpumask);
 		err = 0;
 		break;
 	}
-	free_cpumask_var(tmp_mask);
 
 	if (!err) {
 		/* cache destination APIC IDs into cfg->dest_apicid */
@@ -397,6 +396,8 @@ int __init arch_early_irq_init(void)
 	arch_init_msi_domain(x86_vector_domain);
 	arch_init_htirq_domain(x86_vector_domain);
 
+	BUG_ON(!alloc_cpumask_var(&vector_cpumask, GFP_KERNEL));
+
 	return arch_early_ioapic_init();
 }
 
-- 
1.7.10.4

