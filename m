Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758193Ab3BFWnZ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:43:25 -0500
Received: from moutng.kundenserver.de ([212.227.126.187]:56383 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756968Ab3BFWnW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:43:22 -0500
Message-ID: <5112DC7E.4020108@dawncrow.de>
Date: Wed, 06 Feb 2013 23:43:10 +0100
From: =?ISO-8859-15?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:16.0) Gecko/20121011 Thunderbird/16.0.1
MIME-Version: 1.0
To: linux-arch@vger.kernel.org, will.deacon@arm.com, linux@arm.linux.org.uk,
        linux-arm-kernel@lists.infradead.org
CC: linux-kernel@vger.kernel.org, Greg KH <gregkh@linuxfoundation.org>
Subject: [PATCH] arm: Preserve TPIDRURW on context switch
Content-Type: text/plain; charset=ISO-8859-15
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:vr3nRphOD1eJJjDkGbseUstybllQfcBtjEtrRsTS26i
 5ZcCNRHsf8e2loE77sPc/ZIb71h4Hmpu6Mw3J1+1lfXFNDXjmn
 bxhLqQpPPd0LsP5hXj4pLEHjdISluKMYbMxHoDeWoLiw26q9l5
 20M7MNTAl+RbYpvqDdkIGEHEvhlQN8X5tDQ4+52j0r2+4nWVxf
 Ty8W0Qt88HApsvHlVsKi9DseG3G55EdBMRMPEiQMRloSfQ0iWU
 EL0OE+dZlcbL5WK1a2G103gzB+CoVjkX+kqU0gDmV3TROkRpeY
 4/TObUTq5dc0gVCMv5eKuNFNIrLi1QowMPvLe/A4tHWmUF5u83
 QUsWzPXgClipnpyLXNeM=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are more and more applications coming to WinRT, Wine could support them,
but mostly they expect to have the thread environment block (TEB) in TPIDRURW.
This register must be preserved per thread instead of being cleared.

This patch is against 0944c0a03465718909ba8e800a5230528aeabafb

I could only test it with kernel 3.4.6

Signed-off-by: André Hentschel <nerv@dawncrow.de>
From: =?UTF-8?q?Andr=C3=A9=20Hentschel?= <nerv@dawncrow.de>
Date: Wed, 6 Feb 2013 23:24:54 +0100
Subject: [PATCH] arm: Preserve TPIDRURW on context switch

---
 arch/arm/include/asm/thread_info.h |  1 +
 arch/arm/include/asm/tls.h         | 43 ++++++++++++++++++++++++++++++++++----
 arch/arm/kernel/asm-offsets.c      |  1 +
 arch/arm/kernel/entry-armv.S       |  7 +++++++
 4 files changed, 48 insertions(+), 4 deletions(-)

diff --git a/arch/arm/include/asm/thread_info.h b/arch/arm/include/asm/thread_info.h
index cddda1f..948525c 100644
--- a/arch/arm/include/asm/thread_info.h
+++ b/arch/arm/include/asm/thread_info.h
@@ -59,6 +59,7 @@ struct thread_info {
 	__u32			syscall;	/* syscall number */
 	__u8			used_cp[16];	/* thread used copro */
 	unsigned long		tp_value;
+	unsigned long		tp2_value;	/* userspace read/write thread id register (2) */
 #ifdef CONFIG_CRUNCH
 	struct crunch_state	crunchstate;
 #endif
diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 73409e6..3230cf2 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -7,8 +7,6 @@
 
 	.macro set_tls_v6k, tp, tmp1, tmp2
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	.endm
 
 	.macro set_tls_v6, tp, tmp1, tmp2
@@ -17,8 +15,6 @@
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
 	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
 
@@ -26,24 +22,63 @@
 	mov	\tmp1, #0xffff0fff
 	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
+
+	.macro set_tls2_none, tp2, tmp1, tmp2
+	.endm
+
+	.macro set_tls2_v6k, tp2, tmp1, tmp2
+	mcr	p15, 0, \tp2, c13, c0, 2		@ set TPIDRURW register
+	.endm
+
+	.macro set_tls2_v6, tp2, tmp1, tmp2
+	ldr	\tmp1, =elf_hwcap
+	ldr	\tmp1, [\tmp1, #0]
+	mov	\tmp2, #0xffff0fff
+	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
+	mcrne	p15, 0, \tp2, c13, c0, 2		@ yes, set TPIDRURW register
+	.endm
+
+	.macro get_tls2_none, tp2, tmp1, tmp2
+	.endm
+
+	.macro get_tls2_v6k, tp2, tmp1, tmp2
+	mrc	p15, 0, \tp2, c13, c0, 2		@ get TPIDRURW register
+	.endm
+
+	.macro get_tls2_v6, tp2, tmp1, tmp2
+	ldr	\tmp1, =elf_hwcap
+	ldr	\tmp1, [\tmp1, #0]
+	mov	\tmp2, #0xffff0fff
+	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
+	mrcne	p15, 0, \tp2, c13, c0, 2		@ yes, get TPIDRURW register
+	.endm
+
 #endif
 
 #ifdef CONFIG_TLS_REG_EMUL
 #define tls_emu		1
 #define has_tls_reg		1
 #define set_tls		set_tls_none
+#define set_tls2	set_tls2_none
+#define get_tls2	get_tls2_none
 #elif defined(CONFIG_CPU_V6)
 #define tls_emu		0
 #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
 #define set_tls		set_tls_v6
+#define set_tls2	set_tls2_v6
+#define get_tls2	get_tls2_v6
 #elif defined(CONFIG_CPU_32v6K)
 #define tls_emu		0
 #define has_tls_reg		1
 #define set_tls		set_tls_v6k
+#define set_tls2	set_tls2_v6k
+#define get_tls2	get_tls2_v6k
 #else
 #define tls_emu		0
 #define has_tls_reg		0
 #define set_tls		set_tls_software
+#define set_tls2	set_tls2_none
+#define get_tls2	get_tls2_none
 #endif
 
 #endif	/* __ASMARM_TLS_H */
diff --git a/arch/arm/kernel/asm-offsets.c b/arch/arm/kernel/asm-offsets.c
index c985b48..2563f29 100644
--- a/arch/arm/kernel/asm-offsets.c
+++ b/arch/arm/kernel/asm-offsets.c
@@ -58,6 +58,7 @@ int main(void)
   DEFINE(TI_CPU_SAVE,		offsetof(struct thread_info, cpu_context));
   DEFINE(TI_USED_CP,		offsetof(struct thread_info, used_cp));
   DEFINE(TI_TP_VALUE,		offsetof(struct thread_info, tp_value));
+  DEFINE(TI_TP2_VALUE,		offsetof(struct thread_info, tp2_value));
   DEFINE(TI_FPSTATE,		offsetof(struct thread_info, fpstate));
 #ifdef CONFIG_VFP
   DEFINE(TI_VFPSTATE,		offsetof(struct thread_info, vfpstate));
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..39de843 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -737,6 +737,13 @@ ENTRY(__switch_to)
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
 	set_tls	r3, r4, r5
+
+	@ preserve TPIDRURW register state
+	get_tls2	r3, r4, r5
+	str	r3, [r1, #TI_TP2_VALUE]
+	ldr	r3, [r2, #TI_TP2_VALUE]
+	set_tls2	r3, r4, r5
+
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
-- 
1.8.0

Best Regards, André Hentschel
