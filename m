Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758648Ab3FMOrr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Jun 2013 10:47:47 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:59584 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758030Ab3FMOrl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Jun 2013 10:47:41 -0400
Date: Thu, 13 Jun 2013 16:47:30 +0200
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>,
        Heiko Carstens <heiko.carstens@de.ibm.com>
Subject: [GIT PULL] s390 patches for the 3.10-rc6
Message-ID: <20130613164730.65273fbd@mschwide>
Organization: IBM Corporation
X-Mailer: Claws Mail 3.8.0 (GTK+ 2.24.10; i686-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13061314-5024-0000-0000-000006519A79
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Linus,

please pull from the 'for-linus' branch of

	git://git.kernel.org/pub/scm/linux/kernel/git/s390/linux.git for-linus

to receive the following updates:

Three kvm related memory management fixes, a fix for show_trace,
a fix for early console output and a patch from Ben to help prevent
compile errors in regard to irq functions (or our lack thereof).

Ben Hutchings (1):
      s390/pci: Implement IRQ functions if !PCI

Christian Borntraeger (3):
      s390/pgtable: Fix guest overindication for change bit
      s390/pgtable: Save pgste during modify_prot_start/commit
      s390/pgtable: make pgste lock an explicit barrier

Martin Schwidefsky (1):
      s390/dumpstack: fix address ranges for asynchronous and panic stack

Peter Oberparleiter (1):
      s390/sclp: fix new line detection

 arch/s390/include/asm/pgtable.h |   32 ++++++++++++++------
 arch/s390/kernel/dumpstack.c    |   12 +++++---
 arch/s390/kernel/irq.c          |   64 +++++++++++++++++++++++++++++++++++++++
 arch/s390/kernel/sclp.S         |    2 +-
 arch/s390/pci/pci.c             |   33 --------------------
 5 files changed, 95 insertions(+), 48 deletions(-)

diff --git a/arch/s390/include/asm/pgtable.h b/arch/s390/include/asm/pgtable.h
index ac01463..e8b6e5b 100644
--- a/arch/s390/include/asm/pgtable.h
+++ b/arch/s390/include/asm/pgtable.h
@@ -623,7 +623,7 @@ static inline pgste_t pgste_get_lock(pte_t *ptep)
 		"	csg	%0,%1,%2\n"
 		"	jl	0b\n"
 		: "=&d" (old), "=&d" (new), "=Q" (ptep[PTRS_PER_PTE])
-		: "Q" (ptep[PTRS_PER_PTE]) : "cc");
+		: "Q" (ptep[PTRS_PER_PTE]) : "cc", "memory");
 #endif
 	return __pgste(new);
 }
@@ -635,11 +635,19 @@ static inline void pgste_set_unlock(pte_t *ptep, pgste_t pgste)
 		"	nihh	%1,0xff7f\n"	/* clear RCP_PCL_BIT */
 		"	stg	%1,%0\n"
 		: "=Q" (ptep[PTRS_PER_PTE])
-		: "d" (pgste_val(pgste)), "Q" (ptep[PTRS_PER_PTE]) : "cc");
+		: "d" (pgste_val(pgste)), "Q" (ptep[PTRS_PER_PTE])
+		: "cc", "memory");
 	preempt_enable();
 #endif
 }
 
+static inline void pgste_set(pte_t *ptep, pgste_t pgste)
+{
+#ifdef CONFIG_PGSTE
+	*(pgste_t *)(ptep + PTRS_PER_PTE) = pgste;
+#endif
+}
+
 static inline pgste_t pgste_update_all(pte_t *ptep, pgste_t pgste)
 {
 #ifdef CONFIG_PGSTE
@@ -704,17 +712,19 @@ static inline void pgste_set_key(pte_t *ptep, pgste_t pgste, pte_t entry)
 {
 #ifdef CONFIG_PGSTE
 	unsigned long address;
-	unsigned long okey, nkey;
+	unsigned long nkey;
 
 	if (pte_val(entry) & _PAGE_INVALID)
 		return;
+	VM_BUG_ON(!(pte_val(*ptep) & _PAGE_INVALID));
 	address = pte_val(entry) & PAGE_MASK;
-	okey = nkey = page_get_storage_key(address);
-	nkey &= ~(_PAGE_ACC_BITS | _PAGE_FP_BIT);
-	/* Set page access key and fetch protection bit from pgste */
-	nkey |= (pgste_val(pgste) & (RCP_ACC_BITS | RCP_FP_BIT)) >> 56;
-	if (okey != nkey)
-		page_set_storage_key(address, nkey, 0);
+	/*
+	 * Set page access key and fetch protection bit from pgste.
+	 * The guest C/R information is still in the PGSTE, set real
+	 * key C/R to 0.
+	 */
+	nkey = (pgste_val(pgste) & (RCP_ACC_BITS | RCP_FP_BIT)) >> 56;
+	page_set_storage_key(address, nkey, 0);
 #endif
 }
 
@@ -1099,8 +1109,10 @@ static inline pte_t ptep_modify_prot_start(struct mm_struct *mm,
 	if (!mm_exclusive(mm))
 		__ptep_ipte(address, ptep);
 
-	if (mm_has_pgste(mm))
+	if (mm_has_pgste(mm)) {
 		pgste = pgste_update_all(&pte, pgste);
+		pgste_set(ptep, pgste);
+	}
 	return pte;
 }
 
diff --git a/arch/s390/kernel/dumpstack.c b/arch/s390/kernel/dumpstack.c
index 2982974..87acc38 100644
--- a/arch/s390/kernel/dumpstack.c
+++ b/arch/s390/kernel/dumpstack.c
@@ -74,6 +74,8 @@ __show_trace(unsigned long sp, unsigned long low, unsigned long high)
 
 static void show_trace(struct task_struct *task, unsigned long *stack)
 {
+	const unsigned long frame_size =
+		STACK_FRAME_OVERHEAD + sizeof(struct pt_regs);
 	register unsigned long __r15 asm ("15");
 	unsigned long sp;
 
@@ -82,11 +84,13 @@ static void show_trace(struct task_struct *task, unsigned long *stack)
 		sp = task ? task->thread.ksp : __r15;
 	printk("Call Trace:\n");
 #ifdef CONFIG_CHECK_STACK
-	sp = __show_trace(sp, S390_lowcore.panic_stack - 4096,
-			  S390_lowcore.panic_stack);
+	sp = __show_trace(sp,
+			  S390_lowcore.panic_stack + frame_size - 4096,
+			  S390_lowcore.panic_stack + frame_size);
 #endif
-	sp = __show_trace(sp, S390_lowcore.async_stack - ASYNC_SIZE,
-			  S390_lowcore.async_stack);
+	sp = __show_trace(sp,
+			  S390_lowcore.async_stack + frame_size - ASYNC_SIZE,
+			  S390_lowcore.async_stack + frame_size);
 	if (task)
 		__show_trace(sp, (unsigned long) task_stack_page(task),
 			     (unsigned long) task_stack_page(task) + THREAD_SIZE);
diff --git a/arch/s390/kernel/irq.c b/arch/s390/kernel/irq.c
index f7fb589..408e866 100644
--- a/arch/s390/kernel/irq.c
+++ b/arch/s390/kernel/irq.c
@@ -311,3 +311,67 @@ void measurement_alert_subclass_unregister(void)
 	spin_unlock(&ma_subclass_lock);
 }
 EXPORT_SYMBOL(measurement_alert_subclass_unregister);
+
+void synchronize_irq(unsigned int irq)
+{
+	/*
+	 * Not needed, the handler is protected by a lock and IRQs that occur
+	 * after the handler is deleted are just NOPs.
+	 */
+}
+EXPORT_SYMBOL_GPL(synchronize_irq);
+
+#ifndef CONFIG_PCI
+
+/* Only PCI devices have dynamically-defined IRQ handlers */
+
+int request_irq(unsigned int irq, irq_handler_t handler,
+		unsigned long irqflags, const char *devname, void *dev_id)
+{
+	return -EINVAL;
+}
+EXPORT_SYMBOL_GPL(request_irq);
+
+void free_irq(unsigned int irq, void *dev_id)
+{
+	WARN_ON(1);
+}
+EXPORT_SYMBOL_GPL(free_irq);
+
+void enable_irq(unsigned int irq)
+{
+	WARN_ON(1);
+}
+EXPORT_SYMBOL_GPL(enable_irq);
+
+void disable_irq(unsigned int irq)
+{
+	WARN_ON(1);
+}
+EXPORT_SYMBOL_GPL(disable_irq);
+
+#endif /* !CONFIG_PCI */
+
+void disable_irq_nosync(unsigned int irq)
+{
+	disable_irq(irq);
+}
+EXPORT_SYMBOL_GPL(disable_irq_nosync);
+
+unsigned long probe_irq_on(void)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(probe_irq_on);
+
+int probe_irq_off(unsigned long val)
+{
+	return 0;
+}
+EXPORT_SYMBOL_GPL(probe_irq_off);
+
+unsigned int probe_irq_mask(unsigned long val)
+{
+	return val;
+}
+EXPORT_SYMBOL_GPL(probe_irq_mask);
diff --git a/arch/s390/kernel/sclp.S b/arch/s390/kernel/sclp.S
index b6506ee..29bd7be 100644
--- a/arch/s390/kernel/sclp.S
+++ b/arch/s390/kernel/sclp.S
@@ -225,7 +225,7 @@ _sclp_print:
 	ahi	%r2,1
 	ltr	%r0,%r0				# end of string?
 	jz	.LfinalizemtoS4
-	chi	%r0,0x15			# end of line (NL)?
+	chi	%r0,0x0a			# end of line (NL)?
 	jz	.LfinalizemtoS4
 	stc	%r0,0(%r6,%r7)			# copy to mto
 	la	%r11,0(%r6,%r7)
diff --git a/arch/s390/pci/pci.c b/arch/s390/pci/pci.c
index e6f15b5..f1e5be8 100644
--- a/arch/s390/pci/pci.c
+++ b/arch/s390/pci/pci.c
@@ -302,15 +302,6 @@ static int zpci_cfg_store(struct zpci_dev *zdev, int offset, u32 val, u8 len)
 	return rc;
 }
 
-void synchronize_irq(unsigned int irq)
-{
-	/*
-	 * Not needed, the handler is protected by a lock and IRQs that occur
-	 * after the handler is deleted are just NOPs.
-	 */
-}
-EXPORT_SYMBOL_GPL(synchronize_irq);
-
 void enable_irq(unsigned int irq)
 {
 	struct msi_desc *msi = irq_get_msi_desc(irq);
@@ -327,30 +318,6 @@ void disable_irq(unsigned int irq)
 }
 EXPORT_SYMBOL_GPL(disable_irq);
 
-void disable_irq_nosync(unsigned int irq)
-{
-	disable_irq(irq);
-}
-EXPORT_SYMBOL_GPL(disable_irq_nosync);
-
-unsigned long probe_irq_on(void)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(probe_irq_on);
-
-int probe_irq_off(unsigned long val)
-{
-	return 0;
-}
-EXPORT_SYMBOL_GPL(probe_irq_off);
-
-unsigned int probe_irq_mask(unsigned long val)
-{
-	return val;
-}
-EXPORT_SYMBOL_GPL(probe_irq_mask);
-
 void pcibios_fixup_bus(struct pci_bus *bus)
 {
 }

