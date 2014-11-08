Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754004AbaKHSSx (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:18:53 -0500
Received: from mga11.intel.com ([192.55.52.93]:32426 "EHLO mga11.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932081AbaKHSSv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:18:51 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534453"
From: Jiang Liu <jiang.liu@linux.intel.com>
To: Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@redhat.com>,
        "H. Peter Anvin" <hpa@zytor.com>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Randy Dunlap <rdunlap@infradead.org>, Yinghai Lu <yinghai@kernel.org>,
        Borislav Petkov <bp@alien8.de>, x86@kernel.org,
        Jiang Liu <jiang.liu@linux.intel.com>
Cc: Konrad Rzeszutek Wilk <konrad.wilk@oracle.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        Tony Luck <tony.luck@intel.com>, Joerg Roedel <joro@8bytes.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-kernel@vger.kernel.org, linux-pci@vger.kernel.org,
        linux-acpi@vger.kernel.org, Daniel J Blueman <daniel@numascale.com>
Subject: [Patch Part3 v3 37/38] x86, irq: Introduce mechanism to support different vector allocation policies
Date: Sun,  9 Nov 2014 02:13:37 +0800
Message-Id: <1415470418-10874-38-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Introduce mechanism to support different vector allocation policies,
so platform or user may choose the best suitable CPU vector allocation
policy. Currently two policies are supported:
1) allocate CPU vector from cpumask_of_node(dev_to_node(dev))
2) allocate from apic->target_cpus(), this is the default policy

Platform driver may call set_vector_alloc_policy() to choose the
preferred policies.

This mechanism may be used to support NumaConnect systems to allocate
CPU vectors from device local node.

We may also enhance to support per-cpu vector allocation if it's needed.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
Cc: Daniel J Blueman <daniel@numascale.com>
---
 arch/x86/include/asm/hw_irq.h |   12 ++++++++
 arch/x86/kernel/apic/vector.c |   66 +++++++++++++++++++++++++++++++++++------
 2 files changed, 69 insertions(+), 9 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index 236aea888847..d37ad7b25063 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -168,6 +168,17 @@ struct irq_alloc_info {
 /* Request contigious CPU vectors */
 #define	X86_IRQ_ALLOC_CONTIGOUS_VECTORS	0x1
 
+enum {
+	/* Allocate vector from cpumask_of_node(dev_to_node(dev)) */
+	X86_VECTOR_POL_NODE = 0x1,
+	/* Allocate vector from apic->target_cpus() */
+	X86_VECTOR_POL_DEFAULT = 0x2,
+	/* Allocate vector from cpumask assigned by caller */
+	X86_VECTOR_POL_CALLER = 0x4,
+	X86_VECTOR_POL_MIN = X86_VECTOR_POL_NODE,
+	X86_VECTOR_POL_MAX = X86_VECTOR_POL_CALLER,
+};
+
 struct irq_cfg {
 	unsigned int		dest_apicid;
 	u8			vector;
@@ -183,6 +194,7 @@ extern struct irq_cfg *irq_cfg(unsigned int irq);
 extern struct irq_cfg *irqd_cfg(struct irq_data *irq_data);
 extern void lock_vector_lock(void);
 extern void unlock_vector_lock(void);
+extern void set_vector_alloc_policy(unsigned int policy);
 extern void setup_vector_irq(int cpu);
 #ifdef CONFIG_SMP
 extern void send_cleanup_vector(struct irq_cfg *);
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index c6c954bb2947..a3f640d34b1e 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -28,6 +28,8 @@ struct apic_chip_data {
 	u8			move_in_progress : 1;
 };
 
+static unsigned int x86_vector_alloc_policy = X86_VECTOR_POL_DEFAULT |
+					      X86_VECTOR_POL_CALLER;
 struct irq_domain *x86_vector_domain;
 static DEFINE_RAW_SPINLOCK(vector_lock);
 static struct irq_chip vector_chip;
@@ -71,6 +73,12 @@ struct irq_cfg *irq_cfg(unsigned int irq)
 	return irqd_cfg(irq_get_irq_data(irq));
 }
 
+void set_vector_alloc_policy(unsigned int policy)
+{
+	if (!WARN_ON((policy & (X86_VECTOR_POL_MAX - 1)) == 0))
+		x86_vector_alloc_policy = policy | X86_VECTOR_POL_CALLER;
+}
+
 static struct apic_chip_data *alloc_apic_chip_data(int node)
 {
 	struct apic_chip_data *data;
@@ -259,12 +267,6 @@ void copy_irq_alloc_info(struct irq_alloc_info *dst, struct irq_alloc_info *src)
 		memset(dst, 0, sizeof(*dst));
 }
 
-static inline const struct cpumask *
-irq_alloc_info_get_mask(struct irq_alloc_info *info)
-{
-	return (!info || !info->mask) ? apic->target_cpus() : info->mask;
-}
-
 static void x86_vector_free_irqs(struct irq_domain *domain,
 				 unsigned int virq, unsigned int nr_irqs)
 {
@@ -285,13 +287,59 @@ static void x86_vector_free_irqs(struct irq_domain *domain,
 	}
 }
 
+static int assign_irq_vector_policy(int irq, int node,
+				    struct apic_chip_data *data,
+				    struct irq_alloc_info *info)
+{
+	int err = -EBUSY;
+	unsigned int policy;
+	const struct cpumask *mask;
+
+	if (info && info->mask)
+		policy = X86_VECTOR_POL_CALLER;
+	else
+		policy = X86_VECTOR_POL_MIN;
+
+	for (; policy <= X86_VECTOR_POL_MAX; policy <<= 1) {
+		if (!(x86_vector_alloc_policy & policy))
+			continue;
+
+		switch (policy) {
+		case X86_VECTOR_POL_NODE:
+			if (node >= 0)
+				mask = cpumask_of_node(node);
+			else
+				mask = NULL;
+			break;
+		case X86_VECTOR_POL_DEFAULT:
+			mask = apic->target_cpus();
+			break;
+		case X86_VECTOR_POL_CALLER:
+			if (info && info->mask)
+				mask = info->mask;
+			else
+				mask = NULL;
+			break;
+		default:
+			mask = NULL;
+			break;
+		}
+		if (mask) {
+			err = assign_irq_vector(irq, data, mask);
+			if (!err)
+				return 0;
+		}
+	}
+
+	return err;
+}
+
 static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 				 unsigned int nr_irqs, void *arg)
 {
 	int i, err;
 	struct apic_chip_data *data;
 	struct irq_data *irq_data;
-	const struct cpumask *mask;
 	struct irq_alloc_info *info = arg;
 
 	if (disable_apic)
@@ -301,7 +349,6 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 	if ((info->flags & X86_IRQ_ALLOC_CONTIGOUS_VECTORS) && nr_irqs > 1)
 		return -ENOSYS;
 
-	mask = irq_alloc_info_get_mask(info);
 	for (i = 0; i < nr_irqs; i++) {
 		irq_data = irq_domain_get_irq_data(domain, virq + i);
 		BUG_ON(!irq_data);
@@ -319,7 +366,8 @@ static int x86_vector_alloc_irqs(struct irq_domain *domain, unsigned int virq,
 		irq_data->chip = &vector_chip;
 		irq_data->chip_data = data;
 		irq_data->hwirq = virq + i;
-		err = assign_irq_vector(virq, data, mask);
+		err = assign_irq_vector_policy(virq, irq_data->node, data,
+					       info);
 		if (err)
 			goto error;
 	}
-- 
1.7.10.4

