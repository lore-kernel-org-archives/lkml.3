Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756452AbaCEUEw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 5 Mar 2014 15:04:52 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61793 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751879AbaCEUEv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 5 Mar 2014 15:04:51 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Gleixner <tglx@linutronix.de>,
        Ingo Molnar <mingo@redhat.com>, "H. Peter Anvin" <hpa@zytor.com>,
        x86@kernel.org, Rui Wang <rui.y.wang@intel.com>,
        Liu Ping Fan <kernelfans@gmail.com>,
        Bjorn Helgaas <bhelgaas@google.com>,
        Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>,
        Lv Zheng <lv.zheng@intel.com>, Seiji Aguchi <seiji.aguchi@hds.com>,
        Yang Zhang <yang.z.zhang@intel.com>, Andi Kleen <ak@linux.intel.com>,
        "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>,
        Li Fei <fei.li@intel.com>, gong.chen@linux.intel.com
Subject: [PATCH] x86, fix x86 fixup_irqs() error handling
Date: Wed,  5 Mar 2014 15:04:14 -0500
Message-Id: <1394049854-28266-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fixup_irqs() calls chip->set_irq_affinity which eventually calls
__assign_irq_vector().  Errors are not propogated back from this function call
and this results in silent irq relocation failures.  This patch fixes this
issue and prints out a warning if there is a relocation failure.

Cc: Thomas Gleixner <tglx@linutronix.de>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: "H. Peter Anvin" <hpa@zytor.com>
Cc: x86@kernel.org
Cc: Rui Wang <rui.y.wang@intel.com>
Cc: Liu Ping Fan <kernelfans@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Lv Zheng <lv.zheng@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@Intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: "Steven Rostedt (Red Hat)" <rostedt@goodmis.org>
Cc: Li Fei <fei.li@intel.com>
Cc: gong.chen@linux.intel.com
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 arch/x86/kernel/apic/io_apic.c |   28 ++++++++++++++++++----------
 arch/x86/kernel/irq.c          |    9 +++++++--
 2 files changed, 25 insertions(+), 12 deletions(-)

diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 6ad4658..b4b21db 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -2312,7 +2312,7 @@ int __ioapic_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	int err;
 
 	if (!config_enabled(CONFIG_SMP))
-		return -1;
+		return -EPERM;
 
 	if (!cpumask_intersects(mask, cpu_online_mask))
 		return -EINVAL;
@@ -2343,7 +2343,7 @@ int native_ioapic_set_affinity(struct irq_data *data,
 	int ret;
 
 	if (!config_enabled(CONFIG_SMP))
-		return -1;
+		return -EPERM;
 
 	raw_spin_lock_irqsave(&ioapic_lock, flags);
 	ret = __ioapic_set_affinity(data, mask, &dest);
@@ -3075,9 +3075,11 @@ msi_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 	struct irq_cfg *cfg = data->chip_data;
 	struct msi_msg msg;
 	unsigned int dest;
+	int ret;
 
-	if (__ioapic_set_affinity(data, mask, &dest))
-		return -1;
+	ret = __ioapic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
 
 	__get_cached_msi_msg(data->msi_desc, &msg);
 
@@ -3177,9 +3179,11 @@ dmar_msi_set_affinity(struct irq_data *data, const struct cpumask *mask,
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int dest, irq = data->irq;
 	struct msi_msg msg;
+	int ret;
 
-	if (__ioapic_set_affinity(data, mask, &dest))
-		return -1;
+	ret = __ioapic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
 
 	dmar_msi_read(irq, &msg);
 
@@ -3226,9 +3230,11 @@ static int hpet_msi_set_affinity(struct irq_data *data,
 	struct irq_cfg *cfg = data->chip_data;
 	struct msi_msg msg;
 	unsigned int dest;
+	int ret;
 
-	if (__ioapic_set_affinity(data, mask, &dest))
-		return -1;
+	ret = __ioapic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
 
 	hpet_msi_read(data->handler_data, &msg);
 
@@ -3295,9 +3301,11 @@ ht_set_affinity(struct irq_data *data, const struct cpumask *mask, bool force)
 {
 	struct irq_cfg *cfg = data->chip_data;
 	unsigned int dest;
+	int ret;
 
-	if (__ioapic_set_affinity(data, mask, &dest))
-		return -1;
+	ret = __ioapic_set_affinity(data, mask, &dest);
+	if (ret)
+		return ret;
 
 	target_ht_irq(data->irq, dest, cfg->vector);
 	return IRQ_SET_MASK_OK_NOCOPY;
diff --git a/arch/x86/kernel/irq.c b/arch/x86/kernel/irq.c
index d99f31d..55fab61 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -351,6 +351,7 @@ void fixup_irqs(void)
 	struct irq_desc *desc;
 	struct irq_data *data;
 	struct irq_chip *chip;
+	int ret;
 
 	for_each_irq_desc(irq, desc) {
 		int break_affinity = 0;
@@ -389,8 +390,12 @@ void fixup_irqs(void)
 		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
 			chip->irq_mask(data);
 
-		if (chip->irq_set_affinity)
-			chip->irq_set_affinity(data, affinity, true);
+		if (chip->irq_set_affinity) {
+			ret = chip->irq_set_affinity(data, affinity, true);
+			WARN(ret == -ENOSPC,
+			     "IRQ %d set affinity failed with %d.  The device assigned to this IRQ is unstable.\n",
+			     irq, ret);
+		}
 		else if (!(warned++))
 			set_affinity = 0;
 
-- 
1.7.9.3

