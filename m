Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933276AbaFLOBN (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Jun 2014 10:01:13 -0400
Received: from mail-we0-f174.google.com ([74.125.82.174]:39830 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755884AbaFLOBM (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Jun 2014 10:01:12 -0400
Date: Thu, 12 Jun 2014 16:01:05 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/irq changes for v3.16
Message-ID: <20140612140105.GA9060@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-irq-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-irq-for-linus

   # HEAD: fb24da805729ee4a83efa34015948f7d64da4b28 x86/irq: Fix fixup_irqs() error handling

Two changes: a cpu-hotplug/irq race fix, plus a HyperV related fix.

 Thanks,

	Ingo

------------------>
K. Y. Srinivasan (1):
      x86, irq, pic: Probe for legacy PIC and set legacy_pic appropriately

Prarit Bhargava (1):
      x86/irq: Fix fixup_irqs() error handling


 arch/x86/kernel/apic/io_apic.c | 28 ++++++++++++++++++----------
 arch/x86/kernel/cpu/mshyperv.c |  9 ---------
 arch/x86/kernel/i8259.c        | 20 +++++++++++++++++++-
 arch/x86/kernel/irq.c          | 13 +++++++++----
 4 files changed, 46 insertions(+), 24 deletions(-)

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
diff --git a/arch/x86/kernel/cpu/mshyperv.c b/arch/x86/kernel/cpu/mshyperv.c
index 76f98fe..a450373 100644
--- a/arch/x86/kernel/cpu/mshyperv.c
+++ b/arch/x86/kernel/cpu/mshyperv.c
@@ -132,15 +132,6 @@ static void __init ms_hyperv_init_platform(void)
 		lapic_timer_frequency = hv_lapic_frequency;
 		printk(KERN_INFO "HyperV: LAPIC Timer Frequency: %#x\n",
 				lapic_timer_frequency);
-
-		/*
-		 * On Hyper-V, when we are booting off an EFI firmware stack,
-		 * we do not have many legacy devices including PIC, PIT etc.
-		 */
-		if (efi_enabled(EFI_BOOT)) {
-			printk(KERN_INFO "HyperV: Using null_legacy_pic\n");
-			legacy_pic = &null_legacy_pic;
-		}
 	}
 #endif
 
diff --git a/arch/x86/kernel/i8259.c b/arch/x86/kernel/i8259.c
index 2e977b5..8af8171 100644
--- a/arch/x86/kernel/i8259.c
+++ b/arch/x86/kernel/i8259.c
@@ -299,13 +299,31 @@ static void unmask_8259A(void)
 static void init_8259A(int auto_eoi)
 {
 	unsigned long flags;
+	unsigned char probe_val = ~(1 << PIC_CASCADE_IR);
+	unsigned char new_val;
 
 	i8259A_auto_eoi = auto_eoi;
 
 	raw_spin_lock_irqsave(&i8259A_lock, flags);
 
-	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
+	/*
+	 * Check to see if we have a PIC.
+	 * Mask all except the cascade and read
+	 * back the value we just wrote. If we don't
+	 * have a PIC, we will read 0xff as opposed to the
+	 * value we wrote.
+	 */
 	outb(0xff, PIC_SLAVE_IMR);	/* mask all of 8259A-2 */
+	outb(probe_val, PIC_MASTER_IMR);
+	new_val = inb(PIC_MASTER_IMR);
+	if (new_val != probe_val) {
+		printk(KERN_INFO "Using NULL legacy PIC\n");
+		legacy_pic = &null_legacy_pic;
+		raw_spin_unlock_irqrestore(&i8259A_lock, flags);
+		return;
+	}
+
+	outb(0xff, PIC_MASTER_IMR);	/* mask all of 8259A-1 */
 
 	/*
 	 * outb_pic - this has to work on a wide range of PC hardware.
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
