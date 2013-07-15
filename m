Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752498Ab3GORPH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Jul 2013 13:15:07 -0400
Received: from moutng.kundenserver.de ([212.227.126.187]:52939 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751958Ab3GORPE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Jul 2013 13:15:04 -0400
Message-ID: <51E42E11.1010903@dawncrow.de>
Date: Mon, 15 Jul 2013 19:14:57 +0200
From: =?ISO-8859-1?Q?Andr=E9_Hentschel?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130623 Thunderbird/17.0.7
MIME-Version: 1.0
To: "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
CC: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <will.deacon@arm.com>,
        Jonathan Austin <jonathan.austin@arm.com>
Subject: arm: Only load TLS values when needed
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:GQloeYutGTjxLAPN8WrDjKtLuI98j8EbR/yS8domUlH
 4vhtD1d+n+3EJ9IPU8e5nLjRdUpLA78ThzD4Q5PTj3pE28RkFM
 pbn868Q1EVGItoqaO3qU17kvsehjm2RjVJQ0vuGoVh3JykxwTe
 yt7lXXb+uM/ZsNRl1ToC5uzX2Q9kRKPNjs7B/MJU8pnHdRlH0I
 fYOvOIJeiuwM6ELsz/f7ksRPi5pf6GWGHP361xkLirC17EI+Yv
 1U4DVQHY1R6VfDX/sSDbblgggeVbBzI7h/HP+0N5Rsirh40Idb
 Cndvj3NwY3d3i5am07K8SDGwP9HCHt0hzV71V6uUnycSPy8Ir5
 dPhiryKASBNy1ltqVjTA=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: André Hentschel <nerv@dawncrow.de>

This patch intents to reduce loading instructions when the resulting value is not used.
It's a follow up on a4780adeefd042482f624f5e0d577bf9cdcbb760

Signed-off-by: André Hentschel <nerv@dawncrow.de>

---
This patch is against Linux 3.11-rc1 (ad81f0545ef01ea651886dddac4bef6cec930092)

Thanks to everyone who helped me with a4780adeefd042482f624f5e0d577bf9cdcbb760

diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 83259b8..3742722 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -3,29 +3,32 @@
 
 #ifdef __ASSEMBLY__
 #include <asm/asm-offsets.h>
-	.macro switch_tls_none, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_none, prev, next, tp, tpuser, tmp1, tmp2
 	.endm
 
-	.macro switch_tls_v6k, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_v6k, prev, next, tp, tpuser, tmp1, tmp2
+	ldrd	\tp, \tpuser, [\next, #TI_TP_VALUE]	@ get the next TLS and user r/w register
 	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
 	mcr	p15, 0, \tpuser, c13, c0, 2	@ and the user r/w register
-	str	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
+	str	\tmp2, [\prev, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro switch_tls_v6, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_v6, prev, next, tp, tpuser, tmp1, tmp2
 	ldr	\tmp1, =elf_hwcap
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
+	ldr	\tp, [\next, #TI_TP_VALUE]	@ get the next TLS register
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
 	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
-	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
+	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the previous user r/w register
+	ldrne	\tpuser, [\next, #TI_TP_VALUE + 4]	@ get the next user r/w register
 	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
 	mcrne	p15, 0, \tpuser, c13, c0, 2	@ set user r/w register
-	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
+	strne	\tmp2, [\prev, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro switch_tls_software, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_software, prev, next, tp, tpuser, tmp1, tmp2
 	mov	\tmp1, #0xffff0fff
 	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index a39cfc2a1..1484b59 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -689,12 +689,10 @@ ENTRY(__switch_to)
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
  THUMB(	str	lr, [ip], #4		   )
-	ldr	r4, [r2, #TI_TP_VALUE]
-	ldr	r5, [r2, #TI_TP_VALUE + 4]
 #ifdef CONFIG_CPU_USE_DOMAINS
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
-	switch_tls r1, r4, r5, r3, r7
+	switch_tls r1, r2, r4, r5, r3, r7
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard
