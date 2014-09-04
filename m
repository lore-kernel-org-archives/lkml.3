Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932412AbaIDGMF (ORCPT <rfc822;w@1wt.eu>);
	Thu, 4 Sep 2014 02:12:05 -0400
Received: from bombadil.infradead.org ([198.137.202.9]:54715 "EHLO
	bombadil.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756142AbaIDGMD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 4 Sep 2014 02:12:03 -0400
Date: Thu, 4 Sep 2014 08:11:37 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Frederic Weisbecker <fweisbec@gmail.com>
Cc: LKML <linux-kernel@vger.kernel.org>,
        Catalin Iacob <iacobcatalin@gmail.com>, Dave Jones <davej@redhat.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>,
        Thomas Gleixner <tglx@linutronix.de>
Subject: Re: [RFC PATCH 3/9] irq_work: Force raised irq work to run on irq
 work interrupt
Message-ID: <20140904061137.GB3190@worktop.ger.corp.intel.com>
References: <1408632777-3348-1-git-send-email-fweisbec@gmail.com>
 <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1408632777-3348-4-git-send-email-fweisbec@gmail.com>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Thu, Aug 21, 2014 at 04:52:51PM +0200, Frederic Weisbecker wrote:
> diff --git a/kernel/irq_work.c b/kernel/irq_work.c
> index e6bcbe7..17bd203 100644
> --- a/kernel/irq_work.c
> +++ b/kernel/irq_work.c
> @@ -22,6 +22,7 @@
>  
>  static DEFINE_PER_CPU(struct llist_head, raised_list);
>  static DEFINE_PER_CPU(struct llist_head, lazy_list);
> +static bool has_own_interrupt;
>  
>  /*
>   * Claim the entry so that no one else will poke at it.

> +void irq_work_tick(void)
> +{
> +	if (!has_own_interrupt)
> +		irq_work_run_list(&__get_cpu_var(raised_list));
> +	irq_work_run_list(&__get_cpu_var(lazy_list));
> +}
> +
>  /*
>   * Synchronize against the irq_work @entry, ensures the entry is not
>   * currently in use.

Why not something like the below; then it becomes a compile time matter.

---
diff --git a/arch/alpha/include/asm/Kbuild b/arch/alpha/include/asm/Kbuild
index e858aa0..a52cbf1 100644
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
index e76fd79..b8fffc1 100644
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
diff --git a/arch/arm/include/asm/Kbuild b/arch/arm/include/asm/Kbuild
index 70cd84e..202905e 100644
--- a/arch/arm/include/asm/Kbuild
+++ b/arch/arm/include/asm/Kbuild
@@ -11,6 +11,7 @@ generic-y += hash.h
 generic-y += ioctl.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += local.h
 generic-y += local64.h
diff --git a/arch/arm64/include/asm/Kbuild b/arch/arm64/include/asm/Kbuild
index 0b3fcf8..d617789 100644
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
@@ -19,6 +19,7 @@ generic-y += ioctl.h
 generic-y += ioctls.h
 generic-y += ipcbuf.h
 generic-y += irq_regs.h
+generic-y += irq_work.h
 generic-y += kdebug.h
 generic-y += kmap_types.h
 generic-y += kvm_para.h
diff --git a/arch/avr32/include/asm/Kbuild b/arch/avr32/include/asm/Kbuild
index 00a0f3c..2a71b1c 100644
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
index 0d93b9a..46ed6bb 100644
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
index 8dbdce8..e77e0c1 100644
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
index 31742df..802b94c4 100644
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
index 5b73921..3caf05c 100644
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
index 0e69796..5f234a5 100644
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
index e8317d2..747320b 100644
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
index accc10a..e02448b 100644
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
index c67c94a..dbaf9f3 100644
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
index c29ead8..7b8111c 100644
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
index 27a3acd..448143b 100644
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
index 335e529..57012ef 100644
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
index ecbd667..77eb1a6 100644
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
index 480af0d..89b61d7 100644
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
index ecf25e6..ffb024b 100644
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
index 7f23f16..31e8f59 100644
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
index b3fea07..773f866 100644
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
index aad2091..1909d2a 100644
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
index c19e47d..5a6c9ac 100644
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
index cdd1b44..f5f94ce 100644
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
index 0aa5675..e6462b8 100644
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
index 7bd64aa..244b12c 100644
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
index 1e5fb87..5a2bb53 100644
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
diff --git a/arch/x86/include/asm/Kbuild b/arch/x86/include/asm/Kbuild
index 3bf000f..8fa909c 100644
--- a/arch/x86/include/asm/Kbuild
+++ b/arch/x86/include/asm/Kbuild
@@ -7,5 +7,6 @@ genhdr-y += unistd_x32.h
 generic-y += clkdev.h
 generic-y += cputime.h
 generic-y += early_ioremap.h
+generic-y += irq_work.h
 generic-y += mcs_spinlock.h
 generic-y += scatterlist.h
diff --git a/arch/xtensa/include/asm/Kbuild b/arch/xtensa/include/asm/Kbuild
index c3d20ba..105d389 100644
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
index e69de29..e962b41 100644
--- a/include/asm-generic/irq_work.h
+++ b/include/asm-generic/irq_work.h
@@ -0,0 +1,10 @@
+#ifndef __ASM_IRQ_WORK_H
+#define __ASM_IRQ_WORK_H
+
+static inline bool arch_irq_work_interrupt(void)
+{
+	return false;
+}
+
+#undef /* __ASM_IRQ_WORK_H */
+
