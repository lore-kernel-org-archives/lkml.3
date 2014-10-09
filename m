Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751459AbaJIGsY (ORCPT <rfc822;w@1wt.eu>);
	Thu, 9 Oct 2014 02:48:24 -0400
Received: from mail-wg0-f44.google.com ([74.125.82.44]:61834 "EHLO
	mail-wg0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750800AbaJIGsS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 9 Oct 2014 02:48:18 -0400
Date: Thu, 9 Oct 2014 08:48:13 +0200
From: Ingo Molnar <mingo@kernel.org>
To: Linus Torvalds <torvalds@linux-foundation.org>
Cc: linux-kernel@vger.kernel.org, Thomas Gleixner <tglx@linutronix.de>,
        =?iso-8859-1?Q?Fr=E9d=E9ric?= Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Andrew Morton <akpm@linux-foundation.org>
Subject: [GIT PULL] timers/nohz updates for v3.18
Message-ID: <20141009064813.GA20517@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Linus,

Please pull the latest timers-nohz-for-linus git tree from:

   git://git.kernel.org/pub/scm/linux/kernel/git/tip/tip.git timers-nohz-for-linus

   # HEAD: 9b01f5bf3999a3db5b1bbd9fdfd80d8d304e94ee nohz: nohz full depends on irq work self IPI support

Main changes:

 - Fix the deadlock reported by Dave Jones et al
 - Clean up and fix nohz_full interaction with arch abilities
 - nohz init code consolidation/cleanup

 Thanks,

	Ingo

------------------>
Frederic Weisbecker (7):
      nohz: Move nohz full init call to tick init
      irq_work: Force raised irq work to run on irq work interrupt
      x86: Tell irq work about self IPI support
      arm: Tell irq work about self IPI support
      arm64: Tell irq work about self IPI support
      nohz: Consolidate nohz full init code
      nohz: nohz full depends on irq work self IPI support

Peter Zijlstra (1):
      irq_work: Introduce arch_irq_work_has_interrupt()


 arch/alpha/include/asm/Kbuild      |  1 +
 arch/arc/include/asm/Kbuild        |  1 +
 arch/arm/include/asm/irq_work.h    | 11 ++++++++
 arch/arm/kernel/smp.c              |  2 +-
 arch/arm64/include/asm/Kbuild      |  2 +-
 arch/arm64/include/asm/irq_work.h  | 11 ++++++++
 arch/arm64/include/asm/smp.h       |  2 ++
 arch/arm64/kernel/smp.c            |  2 +-
 arch/avr32/include/asm/Kbuild      |  1 +
 arch/blackfin/include/asm/Kbuild   |  1 +
 arch/c6x/include/asm/Kbuild        |  1 +
 arch/cris/include/asm/Kbuild       |  1 +
 arch/frv/include/asm/Kbuild        |  1 +
 arch/hexagon/include/asm/Kbuild    |  1 +
 arch/ia64/include/asm/Kbuild       |  1 +
 arch/m32r/include/asm/Kbuild       |  1 +
 arch/m68k/include/asm/Kbuild       |  1 +
 arch/metag/include/asm/Kbuild      |  1 +
 arch/microblaze/include/asm/Kbuild |  1 +
 arch/mips/include/asm/Kbuild       |  1 +
 arch/mn10300/include/asm/Kbuild    |  1 +
 arch/openrisc/include/asm/Kbuild   |  1 +
 arch/parisc/include/asm/Kbuild     |  1 +
 arch/powerpc/include/asm/Kbuild    |  1 +
 arch/s390/include/asm/Kbuild       |  1 +
 arch/score/include/asm/Kbuild      |  1 +
 arch/sh/include/asm/Kbuild         |  1 +
 arch/sparc/include/asm/Kbuild      |  1 +
 arch/tile/include/asm/Kbuild       |  1 +
 arch/um/include/asm/Kbuild         |  1 +
 arch/unicore32/include/asm/Kbuild  |  1 +
 arch/x86/include/asm/irq_work.h    | 11 ++++++++
 arch/x86/kernel/irq_work.c         |  2 +-
 arch/xtensa/include/asm/Kbuild     |  1 +
 include/asm-generic/irq_work.h     | 10 ++++++++
 include/linux/irq_work.h           |  3 +++
 include/linux/tick.h               |  2 --
 init/main.c                        |  1 -
 kernel/irq_work.c                  | 15 +++++++++--
 kernel/time/tick-common.c          |  1 +
 kernel/time/tick-internal.h        |  7 +++++
 kernel/time/tick-sched.c           | 52 ++++++++++++++++++++++++--------------
 kernel/time/timer.c                |  2 +-
 43 files changed, 133 insertions(+), 29 deletions(-)
 create mode 100644 arch/arm/include/asm/irq_work.h
 create mode 100644 arch/arm64/include/asm/irq_work.h
 create mode 100644 arch/x86/include/asm/irq_work.h
 create mode 100644 include/asm-generic/irq_work.h

diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index e858aa0ad8af..a52cbf178c3a 100644
--- a/arch/alpha/include/asm/Kbuild
+++ b/arch/alpha/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
diff --git a/arch/arc/include/asm/Kbuild b/arch/arc/include/asm/Kbuild
index e76fd79f32b0..b8fffc1a2ac2 100644
--- a/arch/arc/include/asm/Kbuild
+++ b/arch/arc/include/asm/Kbuild
@@ -18,6 +18,7 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
 generic-y += local.h
diff --git a/arch/arm/include/asm/irq_work.h b/arch/arm/include/asm/irq_work.h
new file mode 100644
index 000000000000..712d03e5973a
--- /dev/null
+++ b/arch/arm/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_ARM_IRQ_WORK_H
+#define __ASM_ARM_IRQ_WORK_H
+
+#include <asm/smp_plat.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return is_smp();
+}
+
+#endif /* _ASM_ARM_IRQ_WORK_H */
diff --git a/arch/arm/kernel/smp.c b/arch/arm/kernel/smp.c
index 9388a3d479e1..bbe22fcb78f6 100644
--- a/arch/arm/kernel/smp.c
+++ b/arch/arm/kernel/smp.c
@@ -503,7 +503,7 @@ void arch_send_call_function_single_ipi(int cpu)
 #ifdef CONFIG_IRQ_WORK
 void arch_irq_work_raise(void)
 {
-	if (is_smp())
+	if (arch_irq_work_has_interrupt())
 		smp_cross_call(cpumask_of(smp_processor_id()), IPI_IRQ_WORK);
 }
 #endif
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 0b3fcf86e6ba..c1968475cc4e 100644
--- a/arch/arm64/include/asm/Kbuild
+++ b/arch/arm64/include/asm/Kbuild
@@ -9,8 +9,8 @@ generic-y += current.h
 generic-y += delay.h
 generic-y += div64.h
 generic-y += dma.h
-generic-y += emergency-restart.h
 generic-y += early_ioremap.h
+generic-y += emergency-restart.h
 generic-y += errno.h
 generic-y += ftrace.h
 generic-y += hash.h
diff --git a/arch/arm64/include/asm/irq_work.h b/arch/arm64/include/asm/irq_work.h
new file mode 100644
index 000000000000..8e24ef3f7c82
--- /dev/null
+++ b/arch/arm64/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef __ASM_IRQ_WORK_H
+#define __ASM_IRQ_WORK_H
+
+#include <asm/smp.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return !!__smp_cross_call;
+}
+
+#endif /* __ASM_IRQ_WORK_H */
diff --git a/arch/arm64/include/asm/smp.h b/arch/arm64/include/asm/smp.h
index a498f2cd2c2a..780f82c827b6 100644
--- a/arch/arm64/include/asm/smp.h
+++ b/arch/arm64/include/asm/smp.h
@@ -48,6 +48,8 @@ extern void smp_init_cpus(void);
  */
 extern void set_smp_cross_call(void (*)(const struct cpumask *, unsigned int));
 
+extern void (*__smp_cross_call)(const struct cpumask *, unsigned int);
+
 /*
  * Called from the secondary holding pen, this is the secondary CPU entry point.
  */
diff --git a/arch/arm64/kernel/smp.c b/arch/arm64/kernel/smp.c
index 474339718105..b06d1d90ee8c 100644
--- a/arch/arm64/kernel/smp.c
+++ b/arch/arm64/kernel/smp.c
@@ -470,7 +470,7 @@ void __init smp_prepare_cpus(unsigned int max_cpus)
 	}
 }
 
-static void (*__smp_cross_call)(const struct cpumask *, unsigned int);
+void (*__smp_cross_call)(const struct cpumask *, unsigned int);
 
 void __init set_smp_cross_call(void (*fn)(const struct cpumask *, unsigned int))
 {
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 00a0f3ccd6eb..2a71b1cb9848 100644
--- a/arch/avr32/include/asm/Kbuild
+++ b/arch/avr32/include/asm/Kbuild
@@ -9,6 +9,7 @@ generic-y += exec.h
 generic-y += futex.h
 generic-y += hash.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
diff --git a/arch/blackfin/include/asm/Kbuild b/arch/blackfin/include/asm/Kbuild
index 0d93b9a79ca9..46ed6bb9c679 100644
--- a/arch/blackfin/include/asm/Kbuild
+++ b/arch/blackfin/include/asm/Kbuild
@@ -15,6 +15,7 @@ generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
diff --git a/arch/c6x/include/asm/Kbuild b/arch/c6x/include/asm/Kbuild
index 8dbdce8421b0..e77e0c1dbe75 100644
--- a/arch/c6x/include/asm/Kbuild
+++ b/arch/c6x/include/asm/Kbuild
@@ -22,6 +22,7 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
diff --git a/arch/cris/include/asm/Kbuild b/arch/cris/include/asm/Kbuild
index 31742dfadff9..802b94c4ca86 100644
--- a/arch/cris/include/asm/Kbuild
+++ b/arch/cris/include/asm/Kbuild
@@ -8,6 +8,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += kvm_para.h
 generic-y += linkage.h
 generic-y += mcs_spinlock.h
diff --git a/arch/frv/include/asm/Kbuild b/arch/frv/include/asm/Kbuild
index 5b73921b6e9d..3caf05cabfc5 100644
--- a/arch/frv/include/asm/Kbuild
+++ b/arch/frv/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
diff --git a/arch/hexagon/include/asm/Kbuild b/arch/hexagon/include/asm/Kbuild
index 0e69796b58c7..5f234a5a2320 100644
--- a/arch/hexagon/include/asm/Kbuild
+++ b/arch/hexagon/include/asm/Kbuild
@@ -23,6 +23,7 @@ generic-y += ioctls.h
 generic-y += iomap.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
diff --git a/arch/ia64/include/asm/Kbuild b/arch/ia64/include/asm/Kbuild
index e8317d2d6c8d..747320be9d0e 100644
--- a/arch/ia64/include/asm/Kbuild
+++ b/arch/ia64/include/asm/Kbuild
@@ -2,6 +2,7 @@
 generic-y += clkdev.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += kvm_para.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
diff --git a/arch/m32r/include/asm/Kbuild b/arch/m32r/include/asm/Kbuild
index accc10a3dc78..e02448b0648b 100644
--- a/arch/m32r/include/asm/Kbuild
+++ b/arch/m32r/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += module.h
 generic-y += preempt.h
diff --git a/arch/m68k/include/asm/Kbuild b/arch/m68k/include/asm/Kbuild
index c67c94a2d672..dbaf9f3065e8 100644
--- a/arch/m68k/include/asm/Kbuild
+++ b/arch/m68k/include/asm/Kbuild
@@ -11,6 +11,7 @@ generic-y += hw_irq.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
diff --git a/arch/metag/include/asm/Kbuild b/arch/metag/include/asm/Kbuild
index c29ead89a317..7b8111c8f937 100644
--- a/arch/metag/include/asm/Kbuild
+++ b/arch/metag/include/asm/Kbuild
@@ -19,6 +19,7 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
diff --git a/arch/microblaze/include/asm/Kbuild b/arch/microblaze/include/asm/Kbuild
index 27a3acda6c19..448143b8cabd 100644
--- a/arch/microblaze/include/asm/Kbuild
+++ b/arch/microblaze/include/asm/Kbuild
@@ -5,6 +5,7 @@ generic-y += cputime.h
 generic-y += device.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
diff --git a/arch/mips/include/asm/Kbuild b/arch/mips/include/asm/Kbuild
index 335e5290ec75..57012ef1f51e 100644
--- a/arch/mips/include/asm/Kbuild
+++ b/arch/mips/include/asm/Kbuild
@@ -3,6 +3,7 @@ generic-y += cputime.h
 generic-y += current.h
 generic-y += emergency-restart.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
 generic-y += mutex.h
diff --git a/arch/mn10300/include/asm/Kbuild b/arch/mn10300/include/asm/Kbuild
index ecbd6676bd33..77eb1a68d13b 100644
--- a/arch/mn10300/include/asm/Kbuild
+++ b/arch/mn10300/include/asm/Kbuild
@@ -4,6 +4,7 @@ generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += exec.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
diff --git a/arch/openrisc/include/asm/Kbuild b/arch/openrisc/include/asm/Kbuild
index 480af0d9c2f5..89b61d7dc790 100644
--- a/arch/openrisc/include/asm/Kbuild
+++ b/arch/openrisc/include/asm/Kbuild
@@ -31,6 +31,7 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
diff --git a/arch/parisc/include/asm/Kbuild b/arch/parisc/include/asm/Kbuild
index ecf25e6678ad..ffb024b8423f 100644
--- a/arch/parisc/include/asm/Kbuild
+++ b/arch/parisc/include/asm/Kbuild
@@ -10,6 +10,7 @@ generic-y += exec.h
 generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kvm_para.h
 generic-y += local.h
diff --git a/arch/powerpc/include/asm/Kbuild b/arch/powerpc/include/asm/Kbuild
index 7f23f162ce9c..31e8f59aff38 100644
--- a/arch/powerpc/include/asm/Kbuild
+++ b/arch/powerpc/include/asm/Kbuild
@@ -1,6 +1,7 @@
 
 generic-y += clkdev.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += rwsem.h
diff --git a/arch/s390/include/asm/Kbuild b/arch/s390/include/asm/Kbuild
index b3fea0722ff1..773f86676588 100644
--- a/arch/s390/include/asm/Kbuild
+++ b/arch/s390/include/asm/Kbuild
@@ -2,6 +2,7 @@
 
 generic-y += clkdev.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
diff --git a/arch/score/include/asm/Kbuild b/arch/score/include/asm/Kbuild
index aad209199f7e..1909d2a5b82f 100644
--- a/arch/score/include/asm/Kbuild
+++ b/arch/score/include/asm/Kbuild
@@ -6,6 +6,7 @@ generic-y += barrier.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += hash.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += preempt.h
 generic-y += scatterlist.h
diff --git a/arch/sh/include/asm/Kbuild b/arch/sh/include/asm/Kbuild
index c19e47dacb31..5a6c9acff0d2 100644
--- a/arch/sh/include/asm/Kbuild
+++ b/arch/sh/include/asm/Kbuild
@@ -12,6 +12,7 @@ generic-y += hash.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kvm_para.h
 generic-y += local.h
 generic-y += local64.h
diff --git a/arch/sparc/include/asm/Kbuild b/arch/sparc/include/asm/Kbuild
index cdd1b447bb6c..f5f94ce1692c 100644
--- a/arch/sparc/include/asm/Kbuild
+++ b/arch/sparc/include/asm/Kbuild
@@ -8,6 +8,7 @@ generic-y += emergency-restart.h
 generic-y += exec.h
 generic-y += hash.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += linkage.h
 generic-y += local.h
 generic-y += local64.h
diff --git a/arch/tile/include/asm/Kbuild b/arch/tile/include/asm/Kbuild
index 0aa5675e7025..e6462b8a6284 100644
--- a/arch/tile/include/asm/Kbuild
+++ b/arch/tile/include/asm/Kbuild
@@ -17,6 +17,7 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += local.h
 generic-y += local64.h
 generic-y += mcs_spinlock.h
diff --git a/arch/um/include/asm/Kbuild b/arch/um/include/asm/Kbuild
index 7bd64aa2e94a..244b12c8cb39 100644
--- a/arch/um/include/asm/Kbuild
+++ b/arch/um/include/asm/Kbuild
@@ -14,6 +14,7 @@ generic-y += hash.h
 generic-y += hw_irq.h
 generic-y += io.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += mcs_spinlock.h
 generic-y += mutex.h
diff --git a/arch/unicore32/include/asm/Kbuild b/arch/unicore32/include/asm/Kbuild
index 1e5fb872a4aa..5a2bb53faa42 100644
--- a/arch/unicore32/include/asm/Kbuild
+++ b/arch/unicore32/include/asm/Kbuild
@@ -22,6 +22,7 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += local.h
diff --git a/arch/x86/include/asm/irq_work.h b/arch/x86/include/asm/irq_work.h
new file mode 100644
index 000000000000..78162f8e248b
--- /dev/null
+++ b/arch/x86/include/asm/irq_work.h
@@ -0,0 +1,11 @@
+#ifndef _ASM_IRQ_WORK_H
+#define _ASM_IRQ_WORK_H
+
+#include <asm/processor.h>
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return cpu_has_apic;
+}
+
+#endif /* _ASM_IRQ_WORK_H */
diff --git a/arch/x86/kernel/irq_work.c b/arch/x86/kernel/irq_work.c
index 1de84e3ab4e0..15d741ddfeeb 100644
--- a/arch/x86/kernel/irq_work.c
+++ b/arch/x86/kernel/irq_work.c
@@ -41,7 +41,7 @@ __visible void smp_trace_irq_work_interrupt(struct pt_regs *regs)
 void arch_irq_work_raise(void)
 {
 #ifdef CONFIG_X86_LOCAL_APIC
-	if (!cpu_has_apic)
+	if (!arch_irq_work_has_interrupt())
 		return;
 
 	apic->send_IPI_self(IRQ_WORK_VECTOR);
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index c3d20ba6eb86..105d38922c44 100644
--- a/arch/xtensa/include/asm/Kbuild
+++ b/arch/xtensa/include/asm/Kbuild
@@ -12,6 +12,7 @@ generic-y += hardirq.h
 generic-y += hash.h
 generic-y += ioctl.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
diff --git a/include/asm-generic/irq_work.h b/include/asm-generic/irq_work.h
new file mode 100644
index 000000000000..a44f452c6590
--- /dev/null
+++ b/include/asm-generic/irq_work.h
@@ -0,0 +1,10 @@
+#ifndef __ASM_IRQ_WORK_H
+#define __ASM_IRQ_WORK_H
+
+static inline bool arch_irq_work_has_interrupt(void)
+{
+	return false;
+}
+
+#endif /* __ASM_IRQ_WORK_H */
+
diff --git a/include/linux/irq_work.h b/include/linux/irq_work.h
index bf9422c3aefe..bf3fe719c7ce 100644
--- a/include/linux/irq_work.h
+++ b/include/linux/irq_work.h
@@ -39,9 +39,12 @@ bool irq_work_queue_on(struct irq_work *work, int cpu);
 #endif
 
 void irq_work_run(void);
+void irq_work_tick(void);
 void irq_work_sync(struct irq_work *work);
 
 #ifdef CONFIG_IRQ_WORK
+#include <asm/irq_work.h>
+
 bool irq_work_needs_cpu(void);
 #else
 static inline bool irq_work_needs_cpu(void) { return false; }
diff --git a/include/linux/tick.h b/include/linux/tick.h
index 9a82c7dc3fdd..595ee86f5e0d 100644
--- a/include/linux/tick.h
+++ b/include/linux/tick.h
@@ -181,14 +181,12 @@ static inline bool tick_nohz_full_cpu(int cpu)
 	return cpumask_test_cpu(cpu, tick_nohz_full_mask);
 }
 
-extern void tick_nohz_init(void);
 extern void __tick_nohz_full_check(void);
 extern void tick_nohz_full_kick(void);
 extern void tick_nohz_full_kick_cpu(int cpu);
 extern void tick_nohz_full_kick_all(void);
 extern void __tick_nohz_task_switch(struct task_struct *tsk);
 #else
-static inline void tick_nohz_init(void) { }
 static inline bool tick_nohz_full_enabled(void) { return false; }
 static inline bool tick_nohz_full_cpu(int cpu) { return false; }
 static inline void __tick_nohz_full_check(void) { }
diff --git a/init/main.c b/init/main.c
index bb1aed928f21..8af2f1abfe38 100644
--- a/init/main.c
+++ b/init/main.c
@@ -577,7 +577,6 @@ asmlinkage __visible void __init start_kernel(void)
 		local_irq_disable();
 	idr_init_cache();
 	rcu_init();
-	tick_nohz_init();
 	context_tracking_init();
 	radix_tree_init();
 	/* init some links before init_ISA_irqs() */
diff --git a/kernel/irq_work.c b/kernel/irq_work.c
index e6bcbe756663..385b85aded19 100644
--- a/kernel/irq_work.c
+++ b/kernel/irq_work.c
@@ -115,8 +115,10 @@ bool irq_work_needs_cpu(void)
 
 	raised = &__get_cpu_var(raised_list);
 	lazy = &__get_cpu_var(lazy_list);
-	if (llist_empty(raised) && llist_empty(lazy))
-		return false;
+
+	if (llist_empty(raised) || arch_irq_work_has_interrupt())
+		if (llist_empty(lazy))
+			return false;
 
 	/* All work should have been flushed before going offline */
 	WARN_ON_ONCE(cpu_is_offline(smp_processor_id()));
@@ -171,6 +173,15 @@ void irq_work_run(void)
 }
 EXPORT_SYMBOL_GPL(irq_work_run);
 
+void irq_work_tick(void)
+{
+	struct llist_head *raised = &__get_cpu_var(raised_list);
+
+	if (!llist_empty(raised) && !arch_irq_work_has_interrupt())
+		irq_work_run_list(raised);
+	irq_work_run_list(&__get_cpu_var(lazy_list));
+}
+
 /*
  * Synchronize against the irq_work @entry, ensures the entry is not
  * currently in use.
diff --git a/kernel/time/tick-common.c b/kernel/time/tick-common.c
index 0a0608edeb26..052b4b53c3d6 100644
--- a/kernel/time/tick-common.c
+++ b/kernel/time/tick-common.c
@@ -400,4 +400,5 @@ void tick_resume(void)
 void __init tick_init(void)
 {
 	tick_broadcast_init();
+	tick_nohz_init();
 }
diff --git a/kernel/time/tick-internal.h b/kernel/time/tick-internal.h
index c19c1d84b6f3..366aeb4f2c66 100644
--- a/kernel/time/tick-internal.h
+++ b/kernel/time/tick-internal.h
@@ -99,6 +99,13 @@ static inline int tick_broadcast_oneshot_active(void) { return 0; }
 static inline bool tick_broadcast_oneshot_available(void) { return false; }
 #endif /* !TICK_ONESHOT */
 
+/* NO_HZ_FULL internal */
+#ifdef CONFIG_NO_HZ_FULL
+extern void tick_nohz_init(void);
+# else
+static inline void tick_nohz_init(void) { }
+#endif
+
 /*
  * Broadcasting support
  */
diff --git a/kernel/time/tick-sched.c b/kernel/time/tick-sched.c
index f654a8a298fa..5a9ff243588c 100644
--- a/kernel/time/tick-sched.c
+++ b/kernel/time/tick-sched.c
@@ -295,22 +295,12 @@ void __tick_nohz_task_switch(struct task_struct *tsk)
 /* Parse the boot-time nohz CPU list from the kernel parameters. */
 static int __init tick_nohz_full_setup(char *str)
 {
-	int cpu;
-
 	alloc_bootmem_cpumask_var(&tick_nohz_full_mask);
-	alloc_bootmem_cpumask_var(&housekeeping_mask);
 	if (cpulist_parse(str, tick_nohz_full_mask) < 0) {
 		pr_warning("NOHZ: Incorrect nohz_full cpumask\n");
+		free_bootmem_cpumask_var(tick_nohz_full_mask);
 		return 1;
 	}
-
-	cpu = smp_processor_id();
-	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
-		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
-		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
-	}
-	cpumask_andnot(housekeeping_mask,
-		       cpu_possible_mask, tick_nohz_full_mask);
 	tick_nohz_full_running = true;
 
 	return 1;
@@ -349,18 +339,11 @@ static int tick_nohz_init_all(void)
 
 #ifdef CONFIG_NO_HZ_FULL_ALL
 	if (!alloc_cpumask_var(&tick_nohz_full_mask, GFP_KERNEL)) {
-		pr_err("NO_HZ: Can't allocate full dynticks cpumask\n");
-		return err;
-	}
-	if (!alloc_cpumask_var(&housekeeping_mask, GFP_KERNEL)) {
-		pr_err("NO_HZ: Can't allocate not-full dynticks cpumask\n");
+		WARN(1, "NO_HZ: Can't allocate full dynticks cpumask\n");
 		return err;
 	}
 	err = 0;
 	cpumask_setall(tick_nohz_full_mask);
-	cpumask_clear_cpu(smp_processor_id(), tick_nohz_full_mask);
-	cpumask_clear(housekeeping_mask);
-	cpumask_set_cpu(smp_processor_id(), housekeeping_mask);
 	tick_nohz_full_running = true;
 #endif
 	return err;
@@ -375,6 +358,37 @@ void __init tick_nohz_init(void)
 			return;
 	}
 
+	if (!alloc_cpumask_var(&housekeeping_mask, GFP_KERNEL)) {
+		WARN(1, "NO_HZ: Can't allocate not-full dynticks cpumask\n");
+		cpumask_clear(tick_nohz_full_mask);
+		tick_nohz_full_running = false;
+		return;
+	}
+
+	/*
+	 * Full dynticks uses irq work to drive the tick rescheduling on safe
+	 * locking contexts. But then we need irq work to raise its own
+	 * interrupts to avoid circular dependency on the tick
+	 */
+	if (!arch_irq_work_has_interrupt()) {
+		pr_warning("NO_HZ: Can't run full dynticks because arch doesn't "
+			   "support irq work self-IPIs\n");
+		cpumask_clear(tick_nohz_full_mask);
+		cpumask_copy(housekeeping_mask, cpu_possible_mask);
+		tick_nohz_full_running = false;
+		return;
+	}
+
+	cpu = smp_processor_id();
+
+	if (cpumask_test_cpu(cpu, tick_nohz_full_mask)) {
+		pr_warning("NO_HZ: Clearing %d from nohz_full range for timekeeping\n", cpu);
+		cpumask_clear_cpu(cpu, tick_nohz_full_mask);
+	}
+
+	cpumask_andnot(housekeeping_mask,
+		       cpu_possible_mask, tick_nohz_full_mask);
+
 	for_each_cpu(cpu, tick_nohz_full_mask)
 		context_tracking_cpu_set(cpu);
 
diff --git a/kernel/time/timer.c b/kernel/time/timer.c
index aca5dfe2fa3d..9bbb8344ed3b 100644
--- a/kernel/time/timer.c
+++ b/kernel/time/timer.c
@@ -1385,7 +1385,7 @@ void update_process_times(int user_tick)
 	rcu_check_callbacks(cpu, user_tick);
 #ifdef CONFIG_IRQ_WORK
 	if (in_irq())
-		irq_work_run();
+		irq_work_tick();
 #endif
 	scheduler_tick();
 	run_posix_cpu_timers(p);
