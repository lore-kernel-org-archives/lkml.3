Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755536AbaJHW6F (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 18:58:05 -0400
Received: from mail.skyhub.de ([78.46.96.112]:41990 "EHLO mail.skyhub.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752229AbaJHW57 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 18:57:59 -0400
Date: Thu, 9 Oct 2014 00:57:50 +0200
From: Borislav Petkov <bp@alien8.de>
To: Aravind Gopalakrishnan <aravind.gopalakrishnan@amd.com>
Cc: slaoub@gmail.com, Tony Luck <tony.luck@intel.com>,
        "linux-edac@vger.kernel.org" <linux-edac@vger.kernel.org>,
        LKML <linux-kernel@vger.kernel.org>
Subject: Re: Fwd: [PATCH] x86, MCE, AMD: save IA32_MCi_STATUS before
 machine_check_poll() resets it
Message-ID: <20141008225750.GH16892@pd.tnic>
References: <1411460354.25617.3.camel@debian>
 <20140929120546.GB6495@pd.tnic>
 <1412037578.21488.11.camel@debian>
 <20140930072553.GA4639@pd.tnic>
 <1412070991.16556.12.camel@cyc>
 <20140930100940.GD4639@pd.tnic>
 <1412138102.21488.20.camel@debian>
 <20141002131206.GA16452@pd.tnic>
 <CAOjmkp9qQiTbqU3NUhUDAoQAa8wAPJnE_qXbDuBKrA3ee1_APQ@mail.gmail.com>
 <5435B206.60402@amd.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=utf-8
Content-Disposition: inline
In-Reply-To: <5435B206.60402@amd.com>
User-Agent: Mutt/1.5.23 (2014-03-12)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 04:52:06PM -0500, Aravind Gopalakrishnan wrote:
> I am not understanding why m.bank is assigned this value..

That's a very good question, see below for some history.

> 
> It only causes incorrect decoding-
> [  608.832916] DEBUG: raise_amd_threshold_event
> [  608.832926] [Hardware Error]: Corrected error, no action required.
> [  608.833143] [Hardware Error]: CPU:26 (15:2:0)
> MC165_STATUS[-|CE|MiscV|-|AddrV|-|-]: 0x8c00000000000000
> [  608.833551] [Hardware Error]: MC165_ADDR: 0x0000000000000000
> [  608.833777] [Hardware Error]: cache level: RESV, tx: INSN
> [  608.834034] amd_inject module loaded ...
> 
> 
> (Obviously, as in amd_decode_mce() we switch (m->bank) for decoding the
> status and there is no bank 165)
> 
> OTOH, if m.bank = bank;
> Then we get correct decoding info-

Yes, and I think we should do that only if we're using the *last* error
to report the overflow with: we're reporting a thresholding counter
overflow and the bank on which it was detected on should, of course, be
part of the report.

The "funny" bank is some sort of a software defined banks thing which
got added in 2005 (see the patch I dug out below) and it was supposed
to be used (I'm guessing here) for reporting thermal events using MCA
(dumb idea, if you ask me) so since thermal events don't really have
a bank, they decided to have some sort of a software-defined MCA bank
which doesn't correspond to any hardware bank.

Then Jacob decided to use it for some reason too:

95268664390b ("[PATCH] x86_64: mce_amd support for family 0x10 processors")

maybe because thresholding errors don't have a bank associated with them
but if I'm not missing anything, they do!

Oh oh, ok, it just dawned on me! I think I know what it *might* have
been: they wanted to report the overflowing with a special error
signature which uses a software-defined bank. Ok, that actually makes
sense: when you see an error for a sw-defined bank, you're reporting an
thresholding counter overflow.

Which means that we shouldn't be populating m.status either, i.e. what
we did earlier:

	rdmsrl(MSR_IA32_MCx_STATUS(bank), m.status);

because this is a special error type.

Hmm, it is too late here to think straight, more tomorrow. But Aravind,
that was a very good question, you actually made me dig into git history
:-)

Good night.


>From d2b6331397e634477b76f6fec119b7caf3ac564e Mon Sep 17 00:00:00 2001
From: Zwane Mwaikambo <zwane@linuxpower.ca>
Date: Mon, 3 Jan 2005 04:42:52 -0800
Subject: [PATCH] [PATCH] Intel thermal monitor for x86_64

Patch adds support for notification of overheating conditions on intel
x86_64 processors.  Tested on EM64T, test booted on AMD64.

Hardware courtesy of Intel Corporation

Signed-off-by: Zwane Mwaikambo <zwane@linuxpower.ca>
Signed-off-by: Andrew Morton <akpm@osdl.org>
Signed-off-by: Linus Torvalds <torvalds@osdl.org>
---
 arch/x86_64/Kconfig            |  7 +++
 arch/x86_64/kernel/Makefile    |  1 +
 arch/x86_64/kernel/entry.S     |  3 ++
 arch/x86_64/kernel/i8259.c     |  2 +
 arch/x86_64/kernel/mce.c       | 14 +++++-
 arch/x86_64/kernel/mce_intel.c | 99 ++++++++++++++++++++++++++++++++++++++++++
 arch/x86_64/kernel/traps.c     |  4 ++
 include/asm-x86_64/mce.h       | 13 ++++++
 8 files changed, 142 insertions(+), 1 deletion(-)
 create mode 100644 arch/x86_64/kernel/mce_intel.c

diff --git a/arch/x86_64/Kconfig b/arch/x86_64/Kconfig
index 4ffa04271050..bc317049ebed 100644
--- a/arch/x86_64/Kconfig
+++ b/arch/x86_64/Kconfig
@@ -338,6 +338,13 @@ config X86_MCE
 	   machine check error logs. See
 	   ftp://ftp.x86-64.org/pub/linux/tools/mcelog
 
+config X86_MCE_INTEL
+	bool "Intel MCE features"
+	depends on X86_MCE && X86_LOCAL_APIC
+	default y
+	help
+	   Additional support for intel specific MCE features such as
+	   the thermal monitor.
 endmenu
 
 #
diff --git a/arch/x86_64/kernel/Makefile b/arch/x86_64/kernel/Makefile
index 2c0f3af82e5e..96a5111e96c6 100644
--- a/arch/x86_64/kernel/Makefile
+++ b/arch/x86_64/kernel/Makefile
@@ -10,6 +10,7 @@ obj-y	:= process.o semaphore.o signal.o entry.o traps.o irq.o \
 		setup64.o bootflag.o e820.o reboot.o warmreboot.o quirks.o
 
 obj-$(CONFIG_X86_MCE)         += mce.o
+obj-$(CONFIG_X86_MCE_INTEL)	+= mce_intel.o
 obj-$(CONFIG_MTRR)		+= ../../i386/kernel/cpu/mtrr/
 obj-$(CONFIG_ACPI_BOOT)		+= acpi/
 obj-$(CONFIG_X86_MSR)		+= msr.o
diff --git a/arch/x86_64/kernel/entry.S b/arch/x86_64/kernel/entry.S
index d8d906a7d8e1..ca050e729a85 100644
--- a/arch/x86_64/kernel/entry.S
+++ b/arch/x86_64/kernel/entry.S
@@ -538,6 +538,9 @@ retint_kernel:
 	CFI_ENDPROC
 	.endm
 
+ENTRY(thermal_interrupt)
+	apicinterrupt THERMAL_APIC_VECTOR,smp_thermal_interrupt
+
 #ifdef CONFIG_SMP	
 ENTRY(reschedule_interrupt)
 	apicinterrupt RESCHEDULE_VECTOR,smp_reschedule_interrupt
diff --git a/arch/x86_64/kernel/i8259.c b/arch/x86_64/kernel/i8259.c
index 7929a2e534a6..04e6fdab46b6 100644
--- a/arch/x86_64/kernel/i8259.c
+++ b/arch/x86_64/kernel/i8259.c
@@ -476,6 +476,7 @@ void error_interrupt(void);
 void reschedule_interrupt(void);
 void call_function_interrupt(void);
 void invalidate_interrupt(void);
+void thermal_interrupt(void);
 
 static void setup_timer(void)
 {
@@ -550,6 +551,7 @@ void __init init_IRQ(void)
 	/* IPI for generic function call */
 	set_intr_gate(CALL_FUNCTION_VECTOR, call_function_interrupt);
 #endif	
+	set_intr_gate(THERMAL_APIC_VECTOR, thermal_interrupt);
 
 #ifdef CONFIG_X86_LOCAL_APIC
 	/* self generated IPI for local APIC timer */
diff --git a/arch/x86_64/kernel/mce.c b/arch/x86_64/kernel/mce.c
index 5da150baf25e..6e717e470460 100644
--- a/arch/x86_64/kernel/mce.c
+++ b/arch/x86_64/kernel/mce.c
@@ -43,7 +43,7 @@ struct mce_log mcelog = {
 	MCE_LOG_LEN,
 }; 
 
-static void mce_log(struct mce *mce)
+void mce_log(struct mce *mce)
 {
 	unsigned next, entry;
 	mce->finished = 0;
@@ -305,6 +305,17 @@ static void __init mce_cpu_quirks(struct cpuinfo_x86 *c)
 	}
 }			
 
+static void __init mce_cpu_features(struct cpuinfo_x86 *c)
+{
+	switch (c->x86_vendor) {
+	case X86_VENDOR_INTEL:
+		mce_intel_feature_init(c);
+		break;
+	default:
+		break;
+	}
+}
+
 /* 
  * Called for each booted CPU to set up machine checks.
  * Must be called with preempt off. 
@@ -321,6 +332,7 @@ void __init mcheck_init(struct cpuinfo_x86 *c)
 		return;
 
 	mce_init(NULL);
+	mce_cpu_features(c);
 }
 
 /*
diff --git a/arch/x86_64/kernel/mce_intel.c b/arch/x86_64/kernel/mce_intel.c
new file mode 100644
index 000000000000..4db9a640069f
--- /dev/null
+++ b/arch/x86_64/kernel/mce_intel.c
@@ -0,0 +1,99 @@
+/*
+ * Intel specific MCE features.
+ * Copyright 2004 Zwane Mwaikambo <zwane@linuxpower.ca>
+ */
+
+#include <linux/init.h>
+#include <linux/interrupt.h>
+#include <linux/percpu.h>
+#include <asm/processor.h>
+#include <asm/msr.h>
+#include <asm/mce.h>
+#include <asm/hw_irq.h>
+
+static DEFINE_PER_CPU(unsigned long, next_check);
+
+asmlinkage void smp_thermal_interrupt(void)
+{
+	struct mce m;
+
+	ack_APIC_irq();
+
+	irq_enter();
+	if (time_before(jiffies, __get_cpu_var(next_check)))
+		goto done;
+
+	__get_cpu_var(next_check) = jiffies + HZ*300;
+	memset(&m, 0, sizeof(m));
+	m.cpu = smp_processor_id();
+	m.bank = MCE_THERMAL_BANK;
+	rdtscll(m.tsc);
+	rdmsrl(MSR_IA32_THERM_STATUS, m.status);
+	if (m.status & 0x1) {
+		printk(KERN_EMERG
+			"CPU%d: Temperature above threshold, cpu clock throttled\n", m.cpu);
+		add_taint(TAINT_MACHINE_CHECK);
+	} else {
+		printk(KERN_EMERG "CPU%d: Temperature/speed normal\n", m.cpu);
+	}
+
+	mce_log(&m);
+done:
+	irq_exit();
+}
+
+static void __init intel_init_thermal(struct cpuinfo_x86 *c)
+{
+	u32 l, h;
+	int tm2 = 0;
+	unsigned int cpu = smp_processor_id();
+
+	if (!cpu_has(c, X86_FEATURE_ACPI))
+		return;
+
+	if (!cpu_has(c, X86_FEATURE_ACC))
+		return;
+
+	/* first check if TM1 is already enabled by the BIOS, in which
+	 * case there might be some SMM goo which handles it, so we can't even
+	 * put a handler since it might be delivered via SMI already.
+	 */
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
+	h = apic_read(APIC_LVTTHMR);
+	if ((l & (1 << 3)) && (h & APIC_DM_SMI)) {
+		printk(KERN_DEBUG
+		       "CPU%d: Thermal monitoring handled by SMI\n", cpu);
+		return;
+	}
+
+	if (cpu_has(c, X86_FEATURE_TM2) && (l & (1 << 13)))
+		tm2 = 1;
+
+	if (h & APIC_VECTOR_MASK) {
+		printk(KERN_DEBUG
+		       "CPU%d: Thermal LVT vector (%#x) already "
+		       "installed\n", cpu, (h & APIC_VECTOR_MASK));
+		return;
+	}
+
+	h = THERMAL_APIC_VECTOR;
+	h |= (APIC_DM_FIXED | APIC_LVT_MASKED);
+	apic_write_around(APIC_LVTTHMR, h);
+
+	rdmsr(MSR_IA32_THERM_INTERRUPT, l, h);
+	wrmsr(MSR_IA32_THERM_INTERRUPT, l | 0x03, h);
+
+	rdmsr(MSR_IA32_MISC_ENABLE, l, h);
+	wrmsr(MSR_IA32_MISC_ENABLE, l | (1 << 3), h);
+
+	l = apic_read(APIC_LVTTHMR);
+	apic_write_around(APIC_LVTTHMR, l & ~APIC_LVT_MASKED);
+	printk(KERN_INFO "CPU%d: Thermal monitoring enabled (%s)\n",
+		cpu, tm2 ? "TM2" : "TM1");
+	return;
+}
+
+void __init mce_intel_feature_init(struct cpuinfo_x86 *c)
+{
+	intel_init_thermal(c);
+}
diff --git a/arch/x86_64/kernel/traps.c b/arch/x86_64/kernel/traps.c
index 50e9621b0273..3ebfc9117d2a 100644
--- a/arch/x86_64/kernel/traps.c
+++ b/arch/x86_64/kernel/traps.c
@@ -882,6 +882,10 @@ asmlinkage void do_spurious_interrupt_bug(struct pt_regs * regs)
 {
 }
 
+asmlinkage void __attribute__((weak)) smp_thermal_interrupt(void)
+{
+}
+
 /*
  *  'math_state_restore()' saves the current math information in the
  * old math state array, and gets the new ones from the current task
diff --git a/include/asm-x86_64/mce.h b/include/asm-x86_64/mce.h
index 1c84fa8758c3..869249db6795 100644
--- a/include/asm-x86_64/mce.h
+++ b/include/asm-x86_64/mce.h
@@ -64,4 +64,17 @@ struct mce_log {
 #define MCE_GET_LOG_LEN      _IOR('M', 2, int)
 #define MCE_GETCLEAR_FLAGS   _IOR('M', 3, int)
 
+/* Software defined banks */
+#define MCE_EXTENDED_BANK	128
+#define MCE_THERMAL_BANK	MCE_EXTENDED_BANK + 0
+
+void mce_log(struct mce *m);
+#ifdef CONFIG_X86_MCE_INTEL
+void mce_intel_feature_init(struct cpuinfo_x86 *c);
+#else
+static inline void mce_intel_feature_init(struct cpuinfo_x86 *c)
+{
+}
+#endif
+
 #endif
-- 
2.0.0


-- 
Regards/Gruss,
    Boris.

Sent from a fat crate under my desk. Formatting is fine.
--
