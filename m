Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753632Ab3GTMZH (ORCPT <rfc822;w@1wt.eu>);
	Sat, 20 Jul 2013 08:25:07 -0400
Received: from science.horizon.com ([71.41.210.146]:10979 "HELO
	science.horizon.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with SMTP id S1752746Ab3GTMZG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 20 Jul 2013 08:25:06 -0400
Date: 20 Jul 2013 08:25:04 -0400
Message-ID: <20130720122504.25856.qmail@science.horizon.com>
From: "George Spelvin" <linux@horizon.com>
To: hpa@linux.intel.com
Subject: Re: [GIT PULL] x86 fixes for 3.11-rc2
Cc: linux@horizon.com, linux-kernel@vger.kernel.org
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

It's marginal with only two call sites, but would it be worth factoring
out the write-back function?  Something like this (untested) patch.
It definitely makes the generated assembly cleaner.

(Signed-off-by: George Spelvin <linux@horizon.com> if you want it.)

diff --git a/arch/x86/include/asm/msr.h b/arch/x86/include/asm/msr.h
index cb75028..8802d97 100644
--- a/arch/x86/include/asm/msr.h
+++ b/arch/x86/include/asm/msr.h
@@ -171,6 +171,30 @@ static inline int wrmsr_safe(unsigned msr, unsigned low, unsigned high)
 	__err;							\
 })
 
+/*
+ * We have to check that we can write back the value, and not just
+ * read it.  At least on 90 nm Pentium M (Family 6, Model 13), reading
+ * an invalid MSR is not guaranteed to trap, see Erratum X4 in "Intel
+ * Pentium M Processor on 90 nm Process with 2-MB L2 Cache and Intel®
+ * Processor A100 and A110 on 90 nm process with 512-KB L2 Cache
+ * Specification Update".
+ */
+#define rdmsr_verysafe(msr, low, high)				\
+({								\
+	int __err;						\
+	asm volatile("2: rdmsr\n"				\
+		     "3: wrmsr ; xor %[err],%[err]\n"		\
+		     "1:\n\t"					\
+		     ".section .fixup,\"ax\"\n\t"		\
+		     "4:  mov %[fault],%[err] ; jmp 1b\n\t"	\
+		     ".previous\n\t"				\
+		     _ASM_EXTABLE(2b, 4b)			\
+		     _ASM_EXTABLE(3b, 4b)			\
+		     : [err] "=r" (__err), "=a" (*low), "=d" (*high) \
+		     : "c" (msr), [fault] "i" (-EIO));		\
+	__err;							\
+})
+
 static inline int rdmsrl_safe(unsigned msr, unsigned long long *p)
 {
 	int err;
diff --git a/arch/x86/kernel/acpi/sleep.c b/arch/x86/kernel/acpi/sleep.c
index b44577b..7c3f40c 100644
--- a/arch/x86/kernel/acpi/sleep.c
+++ b/arch/x86/kernel/acpi/sleep.c
@@ -48,9 +48,9 @@ int acpi_suspend_lowlevel(void)
 #ifndef CONFIG_64BIT
 	native_store_gdt((struct desc_ptr *)&header->pmode_gdt);
 
-	if (!rdmsr_safe(MSR_EFER,
-			&header->pmode_efer_low,
-			&header->pmode_efer_high))
+	if (!rdmsr_verysafe(MSR_EFER,
+			    &header->pmode_efer_low,
+			    &header->pmode_efer_high))
 		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_EFER);
 #endif /* !CONFIG_64BIT */
 
@@ -59,9 +59,9 @@ int acpi_suspend_lowlevel(void)
 		header->pmode_cr4 = read_cr4();
 		header->pmode_behavior |= (1 << WAKEUP_BEHAVIOR_RESTORE_CR4);
 	}
-	if (!rdmsr_safe(MSR_IA32_MISC_ENABLE,
-			&header->pmode_misc_en_low,
-			&header->pmode_misc_en_high))
+	if (!rdmsr_verysafe(MSR_IA32_MISC_ENABLE,
+			    &header->pmode_misc_en_low,
+			    &header->pmode_misc_en_high))
 		header->pmode_behavior |=
 			(1 << WAKEUP_BEHAVIOR_RESTORE_MISC_ENABLE);
 	header->realmode_flags = acpi_realmode_flags;
