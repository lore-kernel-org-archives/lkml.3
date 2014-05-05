Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752169AbaEETTw (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 15:19:52 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:59015 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752112AbaEETTt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 15:19:49 -0400
From: Andy Lutomirski <luto@amacapital.net>
To: "H. Peter Anvin" <hpa@zytor.com>, x86@kernel.org
Cc: Stefani Seibold <stefani@seibold.net>, linux-kernel@vger.kernel.org,
        Andy Lutomirski <luto@amacapital.net>
Subject: [PATCH v5 3/7] x86: Move syscall and sysenter setup into kernel/cpu/common.c
Date: Mon,  5 May 2014 12:19:33 -0700
Message-Id: <4e466987204e232d7b55a53ff6b9739f12237461.1399317206.git.luto@amacapital.net>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <cover.1399317206.git.luto@amacapital.net>
References: <cover.1399317206.git.luto@amacapital.net>
In-Reply-To: <cover.1399317206.git.luto@amacapital.net>
References: <cover.1399317206.git.luto@amacapital.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This code is used during CPU setup, and it isn't strictly speaking
related to the 32-bit vdso.  It's easier to understand how this
works when the code is closer to its callers.

This also lets syscall32_cpu_init be static, which might save some
trivial amount of kernel text.

Signed-off-by: Andy Lutomirski <luto@amacapital.net>
---
 arch/x86/include/asm/proto.h |  2 --
 arch/x86/kernel/cpu/common.c | 32 ++++++++++++++++++++++++++++++++
 arch/x86/vdso/vdso32-setup.c | 30 ------------------------------
 3 files changed, 32 insertions(+), 32 deletions(-)

diff --git a/arch/x86/include/asm/proto.h b/arch/x86/include/asm/proto.h
index 6fd3fd7..a90f897 100644
--- a/arch/x86/include/asm/proto.h
+++ b/arch/x86/include/asm/proto.h
@@ -12,8 +12,6 @@ void ia32_syscall(void);
 void ia32_cstar_target(void);
 void ia32_sysenter_target(void);
 
-void syscall32_cpu_init(void);
-
 void x86_configure_nx(void);
 void x86_report_nx(void);
 
diff --git a/arch/x86/kernel/cpu/common.c b/arch/x86/kernel/cpu/common.c
index a135239..7c65b46 100644
--- a/arch/x86/kernel/cpu/common.c
+++ b/arch/x86/kernel/cpu/common.c
@@ -953,6 +953,38 @@ static void vgetcpu_set_mode(void)
 	else
 		vgetcpu_mode = VGETCPU_LSL;
 }
+
+/* May not be __init: called during resume */
+static void syscall32_cpu_init(void)
+{
+	/* Load these always in case some future AMD CPU supports
+	   SYSENTER from compat mode too. */
+	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
+	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
+	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
+
+	wrmsrl(MSR_CSTAR, ia32_cstar_target);
+}
+#endif
+
+#ifdef CONFIG_X86_32
+void enable_sep_cpu(void)
+{
+	int cpu = get_cpu();
+	struct tss_struct *tss = &per_cpu(init_tss, cpu);
+
+	if (!boot_cpu_has(X86_FEATURE_SEP)) {
+		put_cpu();
+		return;
+	}
+
+	tss->x86_tss.ss1 = __KERNEL_CS;
+	tss->x86_tss.sp1 = sizeof(struct tss_struct) + (unsigned long) tss;
+	wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
+	wrmsr(MSR_IA32_SYSENTER_ESP, tss->x86_tss.sp1, 0);
+	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long) ia32_sysenter_target, 0);
+	put_cpu();
+}
 #endif
 
 void __init identify_boot_cpu(void)
diff --git a/arch/x86/vdso/vdso32-setup.c b/arch/x86/vdso/vdso32-setup.c
index 5a657d9..9c78d5b 100644
--- a/arch/x86/vdso/vdso32-setup.c
+++ b/arch/x86/vdso/vdso32-setup.c
@@ -75,41 +75,11 @@ static unsigned vdso32_size;
 #define	vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SYSENTER32))
 #define	vdso32_syscall()	(boot_cpu_has(X86_FEATURE_SYSCALL32))
 
-/* May not be __init: called during resume */
-void syscall32_cpu_init(void)
-{
-	/* Load these always in case some future AMD CPU supports
-	   SYSENTER from compat mode too. */
-	wrmsrl_safe(MSR_IA32_SYSENTER_CS, (u64)__KERNEL_CS);
-	wrmsrl_safe(MSR_IA32_SYSENTER_ESP, 0ULL);
-	wrmsrl_safe(MSR_IA32_SYSENTER_EIP, (u64)ia32_sysenter_target);
-
-	wrmsrl(MSR_CSTAR, ia32_cstar_target);
-}
-
 #else  /* CONFIG_X86_32 */
 
 #define vdso32_sysenter()	(boot_cpu_has(X86_FEATURE_SEP))
 #define vdso32_syscall()	(0)
 
-void enable_sep_cpu(void)
-{
-	int cpu = get_cpu();
-	struct tss_struct *tss = &per_cpu(init_tss, cpu);
-
-	if (!boot_cpu_has(X86_FEATURE_SEP)) {
-		put_cpu();
-		return;
-	}
-
-	tss->x86_tss.ss1 = __KERNEL_CS;
-	tss->x86_tss.sp1 = sizeof(struct tss_struct) + (unsigned long) tss;
-	wrmsr(MSR_IA32_SYSENTER_CS, __KERNEL_CS, 0);
-	wrmsr(MSR_IA32_SYSENTER_ESP, tss->x86_tss.sp1, 0);
-	wrmsr(MSR_IA32_SYSENTER_EIP, (unsigned long) ia32_sysenter_target, 0);
-	put_cpu();	
-}
-
 #endif	/* CONFIG_X86_64 */
 
 int __init sysenter_setup(void)
-- 
1.9.0

