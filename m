Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754699AbaKZXWJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 26 Nov 2014 18:22:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:59192 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753283AbaKZXWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 26 Nov 2014 18:22:05 -0500
Date: Wed, 26 Nov 2014 15:21:11 -0800
From: tip-bot for Jiang Liu <tipbot@zytor.com>
Message-ID: <tip-194200be668427182d3364a758ef7372c50e0b69@git.kernel.org>
Cc: yinghai@kernel.org, rjw@rjwysocki.net, gregkh@linuxfoundation.org,
        konrad.wilk@oracle.com, jiang.liu@linux.intel.com,
        linux-kernel@vger.kernel.org, bp@alien8.de, hpa@zytor.com,
        tglx@linutronix.de, jroedel@suse.de, joro@8bytes.org,
        benh@kernel.crashing.org, mingo@kernel.org, rdunlap@infradead.org,
        bhelgaas@google.com, tony.luck@intel.com
Reply-To: benh@kernel.crashing.org, rdunlap@infradead.org, mingo@kernel.org,
        tony.luck@intel.com, bhelgaas@google.com, yinghai@kernel.org,
        gregkh@linuxfoundation.org, rjw@rjwysocki.net,
        jiang.liu@linux.intel.com, linux-kernel@vger.kernel.org,
        konrad.wilk@oracle.com, tglx@linutronix.de, hpa@zytor.com,
        bp@alien8.de, joro@8bytes.org, jroedel@suse.de
In-Reply-To: <1416901802-24211-33-git-send-email-jiang.liu@linux.intel.com>
References: <1416901802-24211-33-git-send-email-jiang.liu@linux.intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/apic] x86, irq: Kill function apic_set_affinity()
Git-Commit-ID: 194200be668427182d3364a758ef7372c50e0b69
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

Commit-ID:  194200be668427182d3364a758ef7372c50e0b69
Gitweb:     http://git.kernel.org/tip/194200be668427182d3364a758ef7372c50e0b69
Author:     Jiang Liu <jiang.liu@linux.intel.com>
AuthorDate: Tue, 25 Nov 2014 15:49:56 +0800
Committer:  Thomas Gleixner <tglx@linutronix.de>
CommitDate: Wed, 26 Nov 2014 23:52:49 +0100

x86, irq: Kill function apic_set_affinity()

Now there's no user of apic_set_affinity(), so kill it.
Also rename vector_set_affinity() to apic_set_affinity() for consistency.

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
Link: http://lkml.kernel.org/r/1416901802-24211-33-git-send-email-jiang.liu@linux.intel.com
Signed-off-by: Thomas Gleixner <tglx@linutronix.de>
Tested-by: Joerg Roedel <jroedel@suse.de>
---
 arch/x86/include/asm/hw_irq.h |  2 --
 arch/x86/kernel/apic/vector.c | 40 +++-------------------------------------
 2 files changed, 3 insertions(+), 39 deletions(-)

diff --git a/arch/x86/include/asm/hw_irq.h b/arch/x86/include/asm/hw_irq.h
index ea9aebc..3304452 100644
--- a/arch/x86/include/asm/hw_irq.h
+++ b/arch/x86/include/asm/hw_irq.h
@@ -198,8 +198,6 @@ static inline void irq_complete_move(struct irq_cfg *c) { }
 #endif
 
 extern void apic_ack_edge(struct irq_data *data);
-extern int apic_set_affinity(struct irq_data *data, const struct cpumask *mask,
-			     unsigned int *dest_id);
 #else	/*  CONFIG_X86_LOCAL_APIC */
 static inline void lock_vector_lock(void) {}
 static inline void unlock_vector_lock(void) {}
diff --git a/arch/x86/kernel/apic/vector.c b/arch/x86/kernel/apic/vector.c
index fba4958..436a340 100644
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
 
 static struct irq_chip lapic_controller = {
 	.irq_ack		= apic_ack_edge,
-	.irq_set_affinity	= vector_set_affinity,
+	.irq_set_affinity	= apic_set_affinity,
 	.irq_retrigger		= apic_retrigger_irq,
 };
 
