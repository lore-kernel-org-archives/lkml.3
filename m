Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932190Ab3LSQOB (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 11:14:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:33279 "EHLO mail.zytor.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932170Ab3LSQN6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 11:13:58 -0500
Message-ID: <52B31B21.6010901@zytor.com>
Date: Thu, 19 Dec 2013 08:13:21 -0800
From: "H. Peter Anvin" <hpa@zytor.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.2.0
MIME-Version: 1.0
To: Ingo Molnar <mingo@kernel.org>
CC: Len Brown <lenb@kernel.org>, x86@kernel.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, Len Brown <len.brown@intel.com>,
        stable@vger.kernel.org, Linus Torvalds <torvalds@linux-foundation.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Mike Galbraith <efault@gmx.de>, Borislav Petkov <bp@alien8.de>
Subject: Re: [PATCH] x86 idle: repair large-server 50-watt idle-power regression
References: <baff264285f6e585df757d58b17788feabc68918.1387403066.git.len.brown@intel.com> <20131219122257.GC11279@gmail.com> <52B316FF.50906@zytor.com> <20131219160210.GA28426@gmail.com>
In-Reply-To: <20131219160210.GA28426@gmail.com>
X-Enigmail-Version: 1.6
Content-Type: multipart/mixed;
 boundary="------------000906000501000406070602"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a multi-part message in MIME format.
--------------000906000501000406070602
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit

How does this look?  Completely untested, of course.

I do wonder if we need more memory barriers, though.

An alternative would be to move everything into mwait_idle_with_hints().

	-hpa


--------------000906000501000406070602
Content-Type: text/plain; charset=UTF-8;
 name="diff"
Content-Transfer-Encoding: 7bit
Content-Disposition: attachment;
 filename="diff"

diff --git a/arch/x86/include/asm/processor.h b/arch/x86/include/asm/processor.h
index 7b034a4057f9..6dce588f94b4 100644
--- a/arch/x86/include/asm/processor.h
+++ b/arch/x86/include/asm/processor.h
@@ -723,6 +723,23 @@ static inline void __sti_mwait(unsigned long eax, unsigned long ecx)
 		     :: "a" (eax), "c" (ecx));
 }
 
+/*
+ * Issue a clflush in preparation for a monitor instruction if the CPU
+ * needs it.  We force the address into the ax register to get a fixed
+ * length for the instruction, however, this is what the monitor instruction
+ * is going to need anyway, so it shouldn't add any additional code.
+ */
+static inline void clflush_monitor(const void *addr, unsigned long ecx,
+				   unsigned long edx)
+{
+	alternative_input(ASM_NOP3,
+			  "clflush (%0)",
+			  X86_FEATURE_CLFLUSH_MONITOR,
+			  "a" (addr));
+	__monitor(addr, eax, edx);
+	smp_mb();
+}
+
 extern void select_idle_routine(const struct cpuinfo_x86 *c);
 extern void init_amd_e400_c1e_mask(void);
 
diff --git a/arch/x86/kernel/acpi/cstate.c b/arch/x86/kernel/acpi/cstate.c
index d2b7f27781bc..b14d02354134 100644
--- a/arch/x86/kernel/acpi/cstate.c
+++ b/arch/x86/kernel/acpi/cstate.c
@@ -163,11 +163,7 @@ EXPORT_SYMBOL_GPL(acpi_processor_ffh_cstate_probe);
 void mwait_idle_with_hints(unsigned long ax, unsigned long cx)
 {
 	if (!need_resched()) {
-		if (this_cpu_has(X86_FEATURE_CLFLUSH_MONITOR))
-			clflush((void *)&current_thread_info()->flags);
-
-		__monitor((void *)&current_thread_info()->flags, 0, 0);
-		smp_mb();
+		clflush_monitor(&current_thread_info()->flags, 0, 0);
 		if (!need_resched())
 			__mwait(ax, cx);
 	}

--------------000906000501000406070602--
