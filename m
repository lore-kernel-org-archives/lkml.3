Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753639AbbATF4u (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Jan 2015 00:56:50 -0500
Received: from mga02.intel.com ([134.134.136.20]:37470 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752344AbbATFzN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Jan 2015 00:55:13 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.09,432,1418112000"; 
   d="scan'208";a="664448249"
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
Subject: [Patch Part2 v4 26/33] x86/irq: Move private data in struct irq_cfg into dedicated data structure
Date: Tue, 20 Jan 2015 13:51:46 +0800
Message-Id: <1421733113-15704-27-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
References: <1421733113-15704-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several fields in struct irq_cfg are private to vector.c, so move it
into dedicated data structure. This helps to hide implementation
details.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>
Cc: Tony Luck <tony.luck@intel.com>
Cc: Joerg Roedel <joro@8bytes.org>
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Cc: Rafael J. Wysocki <rjw@rjwysocki.net>
Cc: Randy Dunlap <rdunlap@infradead.org>
Cc: Yinghai Lu <yinghai@kernel.org>
Cc: Borislav Petkov <bp@alien8.de>
Link: http://lkml.kernel.org/r/1416901802-24211-35-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hw_irq.h |    3 -
 arch/x86/kernel/apic/vector.c |  221 ++++++++++++++++++++++-------------------
 2 files changed, 119 insertions(+), 105 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 330445236484..e7ae6eb84934 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -171,11 +171,8 @@ enum {
 };
 
 struct irq_cfg {
-	cpumask_var_t		domain;
-	cpumask_var_t		old_domain;
 	unsigned int		dest_apicid;
 	u8			vector;
-	u8			move_in_progress : 1;
 };
 
 extern struct irq_domain *x86_vector_domain;
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index a5ce2eef0528..0e7c39beefed 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -21,11 +21,18 @@
 #include <asm/desc.h>
 #include <asm/irq_remapping.h>
 
+struct apic_chip_data {
+	struct irq_cfg		cfg;
+	cpumask_var_t		domain;
+	cpumask_var_t		old_domain;
+	u8			move_in_progress : 1;
+};
+
 struct irq_domain *x86_vector_domain;
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static struct irq_chip lapic_controller;
 #ifdef	CONFIG_X86_IO_APIC
-static struct irq_cfg *legacy_irq_cfgs[NR_IRQS_LEGACY];
+static struct apic_chip_data *legacy_irq_data[NR_IRQS_LEGACY];
 #endif
 
 void lock_vector_lock(void)
@@ -41,12 +48,7 @@ void unlock_vector_lock(void)
 	raw_spin_unlock(&vector_lock);
 }
 
-struct irq_cfg *irq_cfg(unsigned int irq)
-{
-	return irqd_cfg(irq_get_irq_data(irq));
-}
-
-struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
+static struct apic_chip_data *apic_chip_data(struct irq_data *irq_data)
 {
 	if (!irq_data)
 		return NULL;
@@ -57,36 +59,48 @@ struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
 	return irq_data->chip_data;
 }
 
-static struct irq_cfg *alloc_irq_cfg(int node)
+struct irq_cfg *irqd_cfg(struct irq_data *irq_data)
+{
+	struct apic_chip_data *data = apic_chip_data(irq_data);
+
+	return data ? &data->cfg : NULL;
+}
+
+struct irq_cfg *irq_cfg(unsigned int irq)
 {
-	struct irq_cfg *cfg;
+	return irqd_cfg(irq_get_irq_data(irq));
+}
 
-	cfg = kzalloc_node(sizeof(*cfg), GFP_KERNEL, node);
-	if (!cfg)
+static struct apic_chip_data *alloc_apic_chip_data(int node)
+{
+	struct apic_chip_data *data;
+
+	data = kzalloc_node(sizeof(*data), GFP_KERNEL, node);
+	if (!data)
 		return NULL;
-	if (!zalloc_cpumask_var_node(&cfg->domain, GFP_KERNEL, node))
-		goto out_cfg;
-	if (!zalloc_cpumask_var_node(&cfg->old_domain, GFP_KERNEL, node))
+	if (!zalloc_cpumask_var_node(&data->domain, GFP_KERNEL, node))
+		goto out_data;
+	if (!zalloc_cpumask_var_node(&data->old_domain, GFP_KERNEL, node))
 		goto out_domain;
-	return cfg;
+	return data;
 out_domain:
-	free_cpumask_var(cfg->domain);
-out_cfg:
-	kfree(cfg);
+	free_cpumask_var(data->domain);
+out_data:
+	kfree(data);
 	return NULL;
 }
 
-static void free_irq_cfg(struct irq_cfg *cfg)
+static void free_apic_chip_data(struct apic_chip_data *data)
 {
-	if (cfg) {
-		free_cpumask_var(cfg->domain);
-		free_cpumask_var(cfg->old_domain);
-		kfree(cfg);
+	if (data) {
+		free_cpumask_var(data->domain);
+		free_cpumask_var(data->old_domain);
+		kfree(data);
 	}
 }
 
-static int
-__assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
+static int __assign_irq_vector(int irq, struct apic_chip_data *d,
+			       const struct cpumask *mask)
 {
 	/*
 	 * NOTE! The local APIC isn't very good at handling
@@ -104,7 +118,7 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 	int cpu, err;
 	cpumask_var_t tmp_mask;
 
-	if (cfg->move_in_progress)
+	if (d->move_in_progress)
 		return -EBUSY;
 
 	if (!alloc_cpumask_var(&tmp_mask, GFP_ATOMIC))
@@ -112,26 +126,26 @@ __assign_irq_vector(int irq, struct irq_cfg *cfg, const struct cpumask *mask)
 
 	/* Only try and allocate irqs on cpus that are present */
 	err = -ENOSPC;
-	cpumask_clear(cfg->old_domain);
+	cpumask_clear(d->old_domain);
 	cpu = cpumask_first_and(mask, cpu_online_mask);
 	while (cpu < nr_cpu_ids) {
 		int new_cpu, vector, offset;
 
 		apic->vector_allocation_domain(cpu, tmp_mask, mask);
 
-		if (cpumask_subset(tmp_mask, cfg->domain)) {
+		if (cpumask_subset(tmp_mask, d->domain)) {
 			err = 0;
-			if (cpumask_equal(tmp_mask, cfg->domain))
+			if (cpumask_equal(tmp_mask, d->domain))
 				break;
 			/*
 			 * New cpumask using the vector is a proper subset of
 			 * the current in use mask. So cleanup the vector
 			 * allocation for the members that are not used anymore.
 			 */
-			cpumask_andnot(cfg->old_domain, cfg->domain, tmp_mask);
-			cfg->move_in_progress =
-			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
-			cpumask_and(cfg->domain, cfg->domain, tmp_mask);
+			cpumask_andnot(d->old_domain, d->domain, tmp_mask);
+			d->move_in_progress =
+			   cpumask_intersects(d->old_domain, cpu_online_mask);
+			cpumask_and(d->domain, d->domain, tmp_mask);
 			break;
 		}
 
@@ -145,8 +159,8 @@ next:
 		}
 
 		if (unlikely(current_vector == vector)) {
-			cpumask_or(cfg->old_domain, cfg->old_domain, tmp_mask);
-			cpumask_andnot(tmp_mask, mask, cfg->old_domain);
+			cpumask_or(d->old_domain, d->old_domain, tmp_mask);
+			cpumask_andnot(tmp_mask, mask, d->old_domain);
 			cpu = cpumask_first_and(tmp_mask, cpu_online_mask);
 			continue;
 		}
@@ -162,15 +176,15 @@ next:
 		/* Found one! */
 		current_vector = vector;
 		current_offset = offset;
-		if (cfg->vector) {
-			cpumask_copy(cfg->old_domain, cfg->domain);
-			cfg->move_in_progress =
-			   cpumask_intersects(cfg->old_domain, cpu_online_mask);
+		if (d->cfg.vector) {
+			cpumask_copy(d->old_domain, d->domain);
+			d->move_in_progress =
+			   cpumask_intersects(d->old_domain, cpu_online_mask);
 		}
 		for_each_cpu_and(new_cpu, tmp_mask, cpu_online_mask)
 			per_cpu(vector_irq, new_cpu)[vector] = irq;
-		cfg->vector = vector;
-		cpumask_copy(cfg->domain, tmp_mask);
+		d->cfg.vector = vector;
+		cpumask_copy(d->domain, tmp_mask);
 		err = 0;
 		break;
 	}
@@ -178,46 +192,46 @@ next:
 
 	if (!err) {
 		/* cache destination APIC IDs into cfg->dest_apicid */
-		err = apic->cpu_mask_to_apicid_and(mask, cfg->domain,
-						   &cfg->dest_apicid);
+		err = apic->cpu_mask_to_apicid_and(mask, d->domain,
+						   &d->cfg.dest_apicid);
 	}
 
 	return err;
 }
 
-static int assign_irq_vector(int irq, struct irq_cfg *cfg,
+static int assign_irq_vector(int irq, struct apic_chip_data *data,
 			     const struct cpumask *mask)
 {
 	int err;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	err = __assign_irq_vector(irq, cfg, mask);
+	err = __assign_irq_vector(irq, data, mask);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 	return err;
 }
 
-static void clear_irq_vector(int irq, struct irq_cfg *cfg)
+static void clear_irq_vector(int irq, struct apic_chip_data *data)
 {
 	int cpu, vector;
 	unsigned long flags;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	BUG_ON(!cfg->vector);
+	BUG_ON(!data->cfg.vector);
 
-	vector = cfg->vector;
-	for_each_cpu_and(cpu, cfg->domain, cpu_online_mask)
+	vector = data->cfg.vector;
+	for_each_cpu_and(cpu, data->domain, cpu_online_mask)
 		per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
 
-	cfg->vector = 0;
-	cpumask_clear(cfg->domain);
+	data->cfg.vector = 0;
+	cpumask_clear(data->domain);
 
-	if (likely(!cfg->move_in_progress)) {
+	if (likely(!data->move_in_progress)) {
 		raw_spin_unlock_irqrestore(&vector_lock, flags);
 		return;
 	}
 
-	for_each_cpu_and(cpu, cfg->old_domain, cpu_online_mask) {
+	for_each_cpu_and(cpu, data->old_domain, cpu_online_mask) {
 		for (vector = FIRST_EXTERNAL_VECTOR; vector < NR_VECTORS;
 		     vector++) {
 			if (per_cpu(vector_irq, cpu)[vector] != irq)
@@ -226,7 +240,7 @@ static void clear_irq_vector(int irq, struct irq_cfg *cfg)
 			break;
 		}
 	}
-	cfg->move_in_progress = 0;
+	data->move_in_progress = 0;
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 }
 
@@ -261,10 +275,10 @@ static void x86_vector_free_irqs(struct irq_domain *domain,
 		irq_data = irq_domain_get_irq_data(x86_vector_domain, virq + i);
 		if (irq_data && irq_data->chip_data) {
 			clear_irq_vector(virq + i, irq_data->chip_data);
-			free_irq_cfg(irq_data->chip_data);
+			free_apic_chip_data(irq_data->chip_data);
 #ifdef	CONFIG_X86_IO_APIC
 			if (virq + i < nr_legacy_irqs())
-				legacy_irq_cfgs[virq + i] = NULL;
+				legacy_irq_data[virq + i] = NULL;
 #endif
 			irq_domain_reset_irq_data(irq_data);
 		}
@@ -275,7 +289,7 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 				 unsigned int nr_irqs, void *arg)
 {
 	int i, err;
-	struct irq_cfg *cfg;
+	struct apic_chip_data *data;
 	struct irq_data *irq_data;
 	const struct cpumask *mask;
 	struct irq_alloc_info *info = arg;
@@ -292,20 +306,20 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		BUG_ON(!irq_data);
 #ifdef	CONFIG_X86_IO_APIC
-		if (virq + i < nr_legacy_irqs() && legacy_irq_cfgs[virq + i])
-			cfg = legacy_irq_cfgs[virq + i];
+		if (virq + i < nr_legacy_irqs() && legacy_irq_data[virq + i])
+			data = legacy_irq_data[virq + i];
 		else
 #endif
-			cfg = alloc_irq_cfg(irq_data->node);
-		if (!cfg) {
+			data = alloc_apic_chip_data(irq_data->node);
+		if (!data) {
 			err = -ENOMEM;
 			goto error;
 		}
 
 		irq_data->chip = &lapic_controller;
-		irq_data->chip_data = cfg;
+		irq_data->chip_data = data;
 		irq_data->hwirq = virq + i;
-		err = assign_irq_vector(virq, cfg, mask);
+		err = assign_irq_vector(virq, data, mask);
 		if (err)
 			goto error;
 	}
@@ -349,22 +363,22 @@ int __init arch_probe_nr_irqs(void)
 static void init_legacy_irqs(void)
 {
 	int i, node = cpu_to_node(0);
-	struct irq_cfg *cfg;
+	struct apic_chip_data *data;
 
 	/*
 	 * For legacy IRQ's, start with assigning irq0 to irq15 to
 	 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
 	 */
 	for (i = 0; i < nr_legacy_irqs(); i++) {
-		cfg = legacy_irq_cfgs[i] = alloc_irq_cfg(node);
-		BUG_ON(!cfg);
+		data = legacy_irq_data[i] = alloc_apic_chip_data(node);
+		BUG_ON(!data);
 		/*
 		 * For legacy IRQ's, start with assigning irq0 to irq15 to
 		 * IRQ0_VECTOR to IRQ15_VECTOR for all cpu's.
 		 */
-		cfg->vector = IRQ0_VECTOR + i;
-		cpumask_setall(cfg->domain);
-		irq_set_chip_data(i, cfg);
+		data->cfg.vector = IRQ0_VECTOR + i;
+		cpumask_setall(data->domain);
+		irq_set_chip_data(i, data);
 	}
 }
 #else
@@ -390,7 +404,7 @@ static void __setup_vector_irq(int cpu)
 {
 	/* Initialize vector_irq on a new cpu */
 	int irq, vector;
-	struct irq_cfg *cfg;
+	struct apic_chip_data *data;
 
 	/*
 	 * vector_lock will make sure that we don't run into irq vector
@@ -400,13 +414,13 @@ static void __setup_vector_irq(int cpu)
 	raw_spin_lock(&vector_lock);
 	/* Mark the inuse vectors */
 	for_each_active_irq(irq) {
-		cfg = irq_cfg(irq);
-		if (!cfg)
+		data = apic_chip_data(irq_get_irq_data(irq));
+		if (!data)
 			continue;
 
-		if (!cpumask_test_cpu(cpu, cfg->domain))
+		if (!cpumask_test_cpu(cpu, data->domain))
 			continue;
-		vector = cfg->vector;
+		vector = data->cfg.vector;
 		per_cpu(vector_irq, cpu)[vector] = irq;
 	}
 	/* Mark the free vectors */
@@ -415,8 +429,8 @@ static void __setup_vector_irq(int cpu)
 		if (irq <= VECTOR_UNDEFINED)
 			continue;
 
-		cfg = irq_cfg(irq);
-		if (!cpumask_test_cpu(cpu, cfg->domain))
+		data = apic_chip_data(irq_get_irq_data(irq));
+		if (!cpumask_test_cpu(cpu, data->domain))
 			per_cpu(vector_irq, cpu)[vector] = VECTOR_UNDEFINED;
 	}
 	raw_spin_unlock(&vector_lock);
@@ -442,15 +456,15 @@ void setup_vector_irq(int cpu)
 	__setup_vector_irq(cpu);
 }
 
-static int apic_retrigger_irq(struct irq_data *data)
+static int apic_retrigger_irq(struct irq_data *irq_data)
 {
-	struct irq_cfg *cfg = irqd_cfg(data);
+	struct apic_chip_data *data = apic_chip_data(irq_data);
 	unsigned long flags;
 	int cpu;
 
 	raw_spin_lock_irqsave(&vector_lock, flags);
-	cpu = cpumask_first_and(cfg->domain, cpu_online_mask);
-	apic->send_IPI_mask(cpumask_of(cpu), cfg->vector);
+	cpu = cpumask_first_and(data->domain, cpu_online_mask);
+	apic->send_IPI_mask(cpumask_of(cpu), data->cfg.vector);
 	raw_spin_unlock_irqrestore(&vector_lock, flags);
 
 	return 1;
@@ -468,7 +482,7 @@ static int apic_set_affinity(struct irq_data *irq_data,
 {
 	int err;
 	int irq = irq_data->irq;
-	struct irq_cfg *cfg = irq_data->chip_data;
+	struct apic_chip_data *data = irq_data->chip_data;
 
 	if (!config_enabled(CONFIG_SMP))
 		return -EPERM;
@@ -476,11 +490,11 @@ static int apic_set_affinity(struct irq_data *irq_data,
 	if (!cpumask_intersects(dest, cpu_online_mask))
 		return -EINVAL;
 
-	err = assign_irq_vector(irq, cfg, dest);
+	err = assign_irq_vector(irq, data, dest);
 	if (err) {
 		struct irq_data *top = irq_get_irq_data(irq);
 
-		if (assign_irq_vector(irq, cfg, top->affinity))
+		if (assign_irq_vector(irq, data, top->affinity))
 			pr_err("Failed to recover vector for irq %d\n", irq);
 		return err;
 	}
@@ -495,28 +509,31 @@ static struct irq_chip lapic_controller = {
 };
 
 #ifdef CONFIG_SMP
-static void __send_cleanup_vector(struct irq_cfg *cfg)
+static void __send_cleanup_vector(struct apic_chip_data *data)
 {
 	cpumask_var_t cleanup_mask;
 
 	if (unlikely(!alloc_cpumask_var(&cleanup_mask, GFP_ATOMIC))) {
 		unsigned int i;
 
-		for_each_cpu_and(i, cfg->old_domain, cpu_online_mask)
+		for_each_cpu_and(i, data->old_domain, cpu_online_mask)
 			apic->send_IPI_mask(cpumask_of(i),
 					    IRQ_MOVE_CLEANUP_VECTOR);
 	} else {
-		cpumask_and(cleanup_mask, cfg->old_domain, cpu_online_mask);
+		cpumask_and(cleanup_mask, data->old_domain, cpu_online_mask);
 		apic->send_IPI_mask(cleanup_mask, IRQ_MOVE_CLEANUP_VECTOR);
 		free_cpumask_var(cleanup_mask);
 	}
-	cfg->move_in_progress = 0;
+	data->move_in_progress = 0;
 }
 
 void send_cleanup_vector(struct irq_cfg *cfg)
 {
-	if (cfg->move_in_progress)
-		__send_cleanup_vector(cfg);
+	struct apic_chip_data *data;
+
+	data = container_of(cfg, struct apic_chip_data, cfg);
+	if (data->move_in_progress)
+		__send_cleanup_vector(data);
 }
 
 asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
@@ -532,7 +549,7 @@ asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
 		int irq;
 		unsigned int irr;
 		struct irq_desc *desc;
-		struct irq_cfg *cfg;
+		struct apic_chip_data *data;
 
 		irq = __this_cpu_read(vector_irq[vector]);
 
@@ -543,8 +560,8 @@ asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
 		if (!desc)
 			continue;
 
-		cfg = irq_cfg(irq);
-		if (!cfg)
+		data = apic_chip_data(&desc->irq_data);
+		if (!data)
 			continue;
 
 		raw_spin_lock(&desc->lock);
@@ -553,10 +570,11 @@ asmlinkage __visible void smp_irq_move_cleanup_interrupt(void)
 		 * Check if the irq migration is in progress. If so, we
 		 * haven't received the cleanup request yet for this irq.
 		 */
-		if (cfg->move_in_progress)
+		if (data->move_in_progress)
 			goto unlock;
 
-		if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
+		if (vector == data->cfg.vector &&
+		    cpumask_test_cpu(me, data->domain))
 			goto unlock;
 
 		irr = apic_read(APIC_IRR + (vector / 32 * 0x10));
@@ -582,14 +600,15 @@ unlock:
 static void __irq_complete_move(struct irq_cfg *cfg, unsigned vector)
 {
 	unsigned me;
+	struct apic_chip_data *data;
 
-	if (likely(!cfg->move_in_progress))
+	data = container_of(cfg, struct apic_chip_data, cfg);
+	if (likely(!data->move_in_progress))
 		return;
 
 	me = smp_processor_id();
-
-	if (vector == cfg->vector && cpumask_test_cpu(me, cfg->domain))
-		__send_cleanup_vector(cfg);
+	if (vector == data->cfg.vector && cpumask_test_cpu(me, data->domain))
+		__send_cleanup_vector(data);
 }
 
 void irq_complete_move(struct irq_cfg *cfg)
@@ -601,10 +620,8 @@ void irq_force_complete_move(int irq)
 {
 	struct irq_cfg *cfg = irq_cfg(irq);
 
-	if (!cfg)
-		return;
-
-	__irq_complete_move(cfg, cfg->vector);
+	if (cfg)
+		__irq_complete_move(cfg, cfg->vector);
 }
 #endif
 
-- 
1.7.10.4

