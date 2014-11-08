Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754498AbaKHSR4 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 8 Nov 2014 13:17:56 -0500
Received: from mga01.intel.com ([192.55.52.88]:12853 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753962AbaKHSRy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 8 Nov 2014 13:17:54 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.97,862,1389772800"; 
   d="scan'208";a="413534277"
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
        linux-acpi@vger.kernel.org
Subject: [Patch Part3 v3 32/38] x86, irq: Kill function apic_set_affinity()
Date: Sun,  9 Nov 2014 02:13:32 +0800
Message-Id: <1415470418-10874-33-git-send-email-jiang.liu@linux.intel.com>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
References: <1415470418-10874-1-git-send-email-jiang.liu@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Now there's no user of apic_set_affinity(), so kill it.
Also rename vector_set_affinity() to apic_set_affinity() for consistency.

Signed-off-by: Jiang Liu <jiang.liu@linux.intel.com>
---
 arch/x86/include/asm/hw_irq.h |    2 --
 arch/x86/kernel/apic/vector.c |   40 +++-------------------------------------
 2 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index dee2069d7c19..c7a616c8f9a1 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -196,8 +196,6 @@ static inline void irq_complete_move(struct irq_cfg *c) { }
 #endif
 
 extern void apic_ack_edge(struct irq_data *data);
-extern int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			     unsigned int *dest_id);
 #else	/*  CONFIG_X86_LOCAL_APIC */
 static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index 4fa940aa24c1..d56b4611c75a 100644
--- a/arch/x86/kernel/apic/vector.c
+++ b/arch/x86/kernel/apic/vector.c
@@ -463,42 +463,8 @@ void apic_ack_edge(struct irq_data *data)
 	ack_APIC_irq();
 }
 
-/*
- * Either sets data->affinity to a valid value, and returns
- * ->cpu_mask_to_apicid of that in dest_id, or returns -1 and
- * leaves data->affinity untouched.
- */
-int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-		      unsigned int *dest_id)
-{
-	struct irq_cfg *cfg = irqd_cfg(data);
-	unsigned int irq = data->irq;
-	int err;
-
-	if (!config_enabled(CONFIG_SMP))
-		return -EPERM;
-
-	if (!cpumask_intersects(mask, cpu_online_mask))
-		return -EINVAL;
-
-	err = assign_irq_vector(irq, cfg, mask);
-	if (err)
-		return err;
-
-	err = apic->cpu_mask_to_apicid_and(mask, cfg->domain, dest_id);
-	if (err) {
-		if (assign_irq_vector(irq, cfg, data->affinity))
-			pr_err("Failed to recover vector for irq %d\n", irq);
-		return err;
-	}
-
-	cpumask_copy(data->affinity, mask);
-
-	return 0;
-}
-
-static int vector_set_affinity(struct irq_data *irq_data,
-			       const struct cpumask *dest, bool force)
+static int apic_set_affinity(struct irq_data *irq_data,
+			     const struct cpumask *dest, bool force)
 {
 	int err;
 	int irq = irq_data->irq;
@@ -524,7 +490,7 @@ static int vector_set_affinity(struct irq_data *irq_data,
 
 static struct irq_chip vector_chip = {
 	.irq_ack = apic_ack_edge,
-	.irq_set_affinity = vector_set_affinity,
+	.irq_set_affinity = apic_set_affinity,
 	.irq_retrigger = apic_retrigger_irq,
 };
 
-- 
1.7.10.4

