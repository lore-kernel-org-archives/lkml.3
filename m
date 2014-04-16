Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161291AbaDPNbJ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 09:31:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42043 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756225AbaDPNZP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 09:25:15 -0400
Date: Wed, 16 Apr 2014 06:24:32 -0700
From: tip-bot for Prarit Bhargava <tipbot@zytor.com>
Message-ID: <tip-fb24da805729ee4a83efa34015948f7d64da4b28@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        yoshihiro.yunomae.ez@hitachi.com, lv.zheng@intel.com,
        rui.y.wang@intel.com, seiji.aguchi@hds.com, yang.z.zhang@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, kernelfans@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, prarit@redhat.com,
        fei.li@intel.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        yoshihiro.yunomae.ez@hitachi.com, lv.zheng@intel.com,
        rui.y.wang@intel.com, seiji.aguchi@hds.com, yang.z.zhang@intel.com,
        bhelgaas@google.com, rostedt@goodmis.org, kernelfans@gmail.com,
        ak@linux.intel.com, tglx@linutronix.de, prarit@redhat.com,
        fei.li@intel.com
In-Reply-To: <1396440673-18286-1-git-send-email-prarit@redhat.com>
References: <1396440673-18286-1-git-send-email-prarit@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/irq] x86/irq: Fix fixup_irqs() error handling
Git-Commit-ID: fb24da805729ee4a83efa34015948f7d64da4b28
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

Commit-ID:  fb24da805729ee4a83efa34015948f7d64da4b28
Gitweb:     http://git.kernel.org/tip/fb24da805729ee4a83efa34015948f7d64da4b28
Author:     Prarit Bhargava <prarit@redhat.com>
AuthorDate: Wed, 2 Apr 2014 08:11:13 -0400
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Apr 2014 13:30:49 +0200

x86/irq: Fix fixup_irqs() error handling

Several patches to fix cpu hotplug and the down'd cpu's irq
relocations have been submitted in the past month or so.  The
patches should resolve the problems with cpu hotplug and irq
relocation, however, there is always a possibility that a bug
still exists.  The big problem with debugging these irq
reassignments is that the cpu down completes and then we get
random stack traces from drivers for which irqs have not been
properly assigned to a new cpu.  The stack traces are a mix of
storage, network, and other kernel subsystem (I once saw the
serial port stop working ...) warnings and failures.

The problem with these failures is that they are difficult to
diagnose. There is no warning in the cpu hotplug down path to
indicate that an IRQ has failed to be assigned to a new cpu, and
all we are left with is a stack trace from a driver, or a
non-functional device.  If we had some information on the
console debugging these situations would be much easier; after
all we can map an IRQ to a device by simply using lspci or
/proc/interrupts.

The current code, fixup_irqs(), which migrates IRQs from the
down'd cpu and is called close to the end of the cpu down path,
calls chip->set_irq_affinity which eventually calls
__assign_irq_vector(). Errors are not propogated back from this
function call and this results in silent irq relocation
failures.

This patch fixes this issue by returning the error codes up the
call stack and prints out a warning if there is a relocation
failure.

Signed-off-by: Prarit Bhargava <prarit@redhat.com>
Acked-by: Thomas Gleixner <tglx@linutronix.de>
Cc: Rui Wang <rui.y.wang@intel.com>
Cc: Liu Ping Fan <kernelfans@gmail.com>
Cc: Bjorn Helgaas <bhelgaas@google.com>
Cc: Yoshihiro YUNOMAE <yoshihiro.yunomae.ez@hitachi.com>
Cc: Lv Zheng <lv.zheng@intel.com>
Cc: Seiji Aguchi <seiji.aguchi@hds.com>
Cc: Yang Zhang <yang.z.zhang@intel.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Steven Rostedt (Red Hat) <rostedt@goodmis.org>
Cc: Li Fei <fei.li@intel.com>
Cc: gong.chen@linux.intel.com
Link: http://lkml.kernel.org/r/1396440673-18286-1-git-send-email-prarit@redhat.com
[ Made small cleanliness tweaks. ]
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/io_apic.c | 28 ++++++++++++++++++----------
 arch/x86/kernel/irq.c          | 13 +++++++++----
 2 files changed, 27 insertions(+), 14 deletions(-)

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
index 283a76a..49bbb57 100644
--- a/arch/x86/kernel/irq.c
+++ b/arch/x86/kernel/irq.c
@@ -357,6 +357,7 @@ void fixup_irqs(void)
 	struct irq_desc *desc;
 	struct irq_data *data;
 	struct irq_chip *chip;
+	int ret;
 
 	for_each_irq_desc(irq, desc) {
 		int break_affinity = 0;
@@ -395,10 +396,14 @@ void fixup_irqs(void)
 		if (!irqd_can_move_in_process_context(data) && chip->irq_mask)
 			chip->irq_mask(data);
 
-		if (chip->irq_set_affinity)
-			chip->irq_set_affinity(data, affinity, true);
-		else if (!(warned++))
-			set_affinity = 0;
+		if (chip->irq_set_affinity) {
+			ret = chip->irq_set_affinity(data, affinity, true);
+			if (ret == -ENOSPC)
+				pr_crit("IRQ %d set affinity failed because there are no available vectors.  The device assigned to this IRQ is unstable.\n", irq);
+		} else {
+			if (!(warned++))
+				set_affinity = 0;
+		}
 
 		/*
 		 * We unmask if the irq was not marked masked by the
