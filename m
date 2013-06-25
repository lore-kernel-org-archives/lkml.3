Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171Ab3FYSdl (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Jun 2013 14:33:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:40872 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752122Ab3FYSdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Jun 2013 14:33:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Helge Deller <deller@gmx.de>
Subject: [ 11/95] parisc: add kernel stack overflow check
Date: Tue, 25 Jun 2013 11:31:58 -0700
Message-Id: <20130625182154.923668141@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130625182153.605455184@linuxfoundation.org>
References: <20130625182153.605455184@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.9-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Helge Deller <deller@gmx.de>

commit 9372450cc22d185f708e5cc3557cf991be4b7dc5 upstream.

Add the CONFIG_DEBUG_STACKOVERFLOW config option to enable checks to
detect kernel stack overflows.

Stack overflows can not be detected reliable since we do not want to
introduce too much overhead.

Instead, during irq processing in do_cpu_irq_mask() we check kernel
stack usage of the interrupted kernel process. Kernel threads can be
easily detected by checking the value of space register 7 (sr7) which
is zero when running inside the kernel.

Since THREAD_SIZE is 16k and PAGE_SIZE is 4k, reduce the alignment of
the init thread to the lower value (PAGE_SIZE) in the kernel
vmlinux.ld.S linker script.

Signed-off-by: Helge Deller <deller@gmx.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/parisc/Kconfig.debug             |   11 +++++++++++
 arch/parisc/include/asm/thread_info.h |    2 +-
 arch/parisc/kernel/irq.c              |   31 +++++++++++++++++++++++++++++--
 arch/parisc/kernel/vmlinux.lds.S      |    2 +-
 4 files changed, 42 insertions(+), 4 deletions(-)

--- a/arch/parisc/Kconfig.debug
+++ b/arch/parisc/Kconfig.debug
@@ -27,3 +27,14 @@ config DEBUG_STRICT_USER_COPY_CHECKS
 	  If unsure, or if you run an older (pre 4.4) gcc, say N.
 
 endmenu
+
+config DEBUG_STACKOVERFLOW
+	bool "Check for stack overflows"
+	default y
+	depends on DEBUG_KERNEL
+	---help---
+	  Say Y here if you want to check the overflows of kernel, IRQ
+	  and exception stacks. This option will cause messages of the
+	  stacks in detail when free stack space drops below a certain
+	  limit.
+	  If in doubt, say "N".
--- a/arch/parisc/include/asm/thread_info.h
+++ b/arch/parisc/include/asm/thread_info.h
@@ -40,7 +40,7 @@ struct thread_info {
 
 /* thread information allocation */
 
-#define THREAD_SIZE_ORDER            2
+#define THREAD_SIZE_ORDER	2 /* PA-RISC requires at least 16k stack */
 /* Be sure to hunt all references to this down when you change the size of
  * the kernel stack */
 #define THREAD_SIZE             (PAGE_SIZE << THREAD_SIZE_ORDER)
--- a/arch/parisc/kernel/irq.c
+++ b/arch/parisc/kernel/irq.c
@@ -330,6 +330,34 @@ static inline int eirr_to_irq(unsigned l
 	return (BITS_PER_LONG - bit) + TIMER_IRQ;
 }
 
+int sysctl_panic_on_stackoverflow = 1;
+
+static inline void stack_overflow_check(struct pt_regs *regs)
+{
+#ifdef CONFIG_DEBUG_STACKOVERFLOW
+	#define STACK_MARGIN	(256*6)
+
+	/* Our stack starts directly behind the thread_info struct. */
+	unsigned long stack_start = (unsigned long) current_thread_info();
+	unsigned long sp = regs->gr[30];
+
+	/* if sr7 != 0, we interrupted a userspace process which we do not want
+	 * to check for stack overflow. We will only check the kernel stack. */
+	if (regs->sr[7])
+		return;
+
+	if (likely((sp - stack_start) < (THREAD_SIZE - STACK_MARGIN)))
+		return;
+
+	pr_emerg("stackcheck: %s will most likely overflow kernel stack "
+		 "(sp:%lx, stk bottom-top:%lx-%lx)\n",
+		current->comm, sp, stack_start, stack_start + THREAD_SIZE);
+
+	if (sysctl_panic_on_stackoverflow)
+		panic("low stack detected by irq handler - check messages\n");
+#endif
+}
+
 /* ONLY called from entry.S:intr_extint() */
 void do_cpu_irq_mask(struct pt_regs *regs)
 {
@@ -364,6 +392,7 @@ void do_cpu_irq_mask(struct pt_regs *reg
 		goto set_out;
 	}
 #endif
+	stack_overflow_check(regs);
 	generic_handle_irq(irq);
 
  out:
@@ -420,6 +449,4 @@ void __init init_IRQ(void)
 	cpu_eiem = EIEM_MASK(TIMER_IRQ);
 #endif
         set_eiem(cpu_eiem);	/* EIEM : enable all external intr */
-
 }
-
--- a/arch/parisc/kernel/vmlinux.lds.S
+++ b/arch/parisc/kernel/vmlinux.lds.S
@@ -95,7 +95,7 @@ SECTIONS
 	NOTES
 
 	/* Data */
-	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, THREAD_SIZE)
+	RW_DATA_SECTION(L1_CACHE_BYTES, PAGE_SIZE, PAGE_SIZE)
 
 	/* PA-RISC locks requires 16-byte alignment */
 	. = ALIGN(16);


