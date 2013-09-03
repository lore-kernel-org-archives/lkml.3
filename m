Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760182Ab3ICOWX (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 10:22:23 -0400
Received: from mail-ea0-f176.google.com ([209.85.215.176]:48410 "EHLO
	mail-ea0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753503Ab3ICOWV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 10:22:21 -0400
Date: Tue, 3 Sep 2013 16:22:17 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, "H. Peter Anvin" <hpa@zytor.com>,
        Thomas Gleixner <tglx@linutronix.de>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] x86/apic changes for v3.12
Message-ID: <20130903142217.GA27791@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest x86-apic-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git x86-apic-for-linus

   HEAD: 25aa2957973d361081ac6c8b6e5a0d9d7a83fef6 x86/ioapic: Check attr against the previous setting when programmed more than once

Smaller fixes.

 Thanks,

	Ingo

------------------>
Liu Ping Fan (1):
      x86/ioapic: Check attr against the previous setting when programmed more than once

Tang Chen (1):
      x86/acpi: Fix incorrect sanity check in acpi_register_lapic()

Yoshihiro YUNOMAE (1):
      x86/ioapic/kcrash: Prevent crash_kexec() from deadlocking on ioapic_lock


 arch/x86/include/asm/apic.h    |  2 ++
 arch/x86/kernel/acpi/boot.c    |  7 +++++--
 arch/x86/kernel/apic/io_apic.c | 14 +++++++++++---
 arch/x86/kernel/crash.c        |  4 +++-
 4 files changed, 21 insertions(+), 6 deletions(-)

diff --git a/arch/x86/include/asm/apic.h b/arch/x86/include/asm/apic.h
index f8119b5..1d2091a 100644
--- a/arch/x86/include/asm/apic.h
+++ b/arch/x86/include/asm/apic.h
@@ -715,4 +715,6 @@ static inline void exiting_ack_irq(void)
 	ack_APIC_irq();
 }
 
+extern void ioapic_zap_locks(void);
+
 #endif /* _ASM_X86_APIC_H */
diff --git a/arch/x86/kernel/acpi/boot.c b/arch/x86/kernel/acpi/boot.c
index 2627a81..81aa73b 100644
--- a/arch/x86/kernel/acpi/boot.c
+++ b/arch/x86/kernel/acpi/boot.c
@@ -199,7 +199,7 @@ static void acpi_register_lapic(int id, u8 enabled)
 {
 	unsigned int ver = 0;
 
-	if (id >= (MAX_LOCAL_APIC-1)) {
+	if (id >= MAX_LOCAL_APIC) {
 		printk(KERN_INFO PREFIX "skipped apicid that is too big\n");
 		return;
 	}
@@ -1120,6 +1120,7 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	int ioapic;
 	int ioapic_pin;
 	struct io_apic_irq_attr irq_attr;
+	int ret;
 
 	if (acpi_irq_model != ACPI_IRQ_MODEL_IOAPIC)
 		return gsi;
@@ -1149,7 +1150,9 @@ int mp_register_gsi(struct device *dev, u32 gsi, int trigger, int polarity)
 	set_io_apic_irq_attr(&irq_attr, ioapic, ioapic_pin,
 			     trigger == ACPI_EDGE_SENSITIVE ? 0 : 1,
 			     polarity == ACPI_ACTIVE_HIGH ? 0 : 1);
-	io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	ret = io_apic_set_pci_routing(dev, gsi_to_irq(gsi), &irq_attr);
+	if (ret < 0)
+		gsi = INT_MIN;
 
 	return gsi;
 }
diff --git a/arch/x86/kernel/apic/io_apic.c b/arch/x86/kernel/apic/io_apic.c
index 9ed796c..e63a5bd 100644
--- a/arch/x86/kernel/apic/io_apic.c
+++ b/arch/x86/kernel/apic/io_apic.c
@@ -1534,6 +1534,11 @@ void intel_ir_io_apic_print_entries(unsigned int apic,
 	}
 }
 
+void ioapic_zap_locks(void)
+{
+	raw_spin_lock_init(&ioapic_lock);
+}
+
 __apicdebuginit(void) print_IO_APIC(int ioapic_idx)
 {
 	union IO_APIC_reg_00 reg_00;
@@ -3375,12 +3380,15 @@ int io_apic_setup_irq_pin_once(unsigned int irq, int node,
 {
 	unsigned int ioapic_idx = attr->ioapic, pin = attr->ioapic_pin;
 	int ret;
+	struct IO_APIC_route_entry orig_entry;
 
 	/* Avoid redundant programming */
 	if (test_bit(pin, ioapics[ioapic_idx].pin_programmed)) {
-		pr_debug("Pin %d-%d already programmed\n",
-			 mpc_ioapic_id(ioapic_idx), pin);
-		return 0;
+		pr_debug("Pin %d-%d already programmed\n", mpc_ioapic_id(ioapic_idx), pin);
+		orig_entry = ioapic_read_entry(attr->ioapic, pin);
+		if (attr->trigger == orig_entry.trigger && attr->polarity == orig_entry.polarity)
+			return 0;
+		return -EBUSY;
 	}
 	ret = io_apic_setup_irq_pin(irq, node, attr);
 	if (!ret)
diff --git a/arch/x86/kernel/crash.c b/arch/x86/kernel/crash.c
index 74467fe..e0e0841 100644
--- a/arch/x86/kernel/crash.c
+++ b/arch/x86/kernel/crash.c
@@ -128,7 +128,9 @@ void native_machine_crash_shutdown(struct pt_regs *regs)
 	cpu_emergency_svm_disable();
 
 	lapic_shutdown();
-#if defined(CONFIG_X86_IO_APIC)
+#ifdef CONFIG_X86_IO_APIC
+	/* Prevent crash_kexec() from deadlocking on ioapic_lock. */
+	ioapic_zap_locks();
 	disable_IO_APIC();
 #endif
 #ifdef CONFIG_HPET_TIMER
