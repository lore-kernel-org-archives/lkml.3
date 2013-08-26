Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028Ab3HZTUA (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Aug 2013 15:20:00 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:59045 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751669Ab3HZTT6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Aug 2013 15:19:58 -0400
Message-ID: <521BAA3F.4050703@dawncrow.de>
Date: Mon, 26 Aug 2013 21:19:27 +0200
From: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jonathan Austin <jonathan.austin@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>,
        Russell King <linux@arm.linux.org.uk>
Subject: Re: arm: Only load TLS values when needed
References: <51E42E11.1010903@dawncrow.de> <51E5836B.1010904@arm.com> <51E59E8F.1060501@dawncrow.de> <51E67B98.9040101@arm.com> <51E6F532.1030004@dawncrow.de> <520B8F37.4040609@dawncrow.de> <520BAE58.3060600@arm.com> <520BF4E1.8040708@dawncrow.de> <520D0FFA.1060508@arm.com> <520D1D9D.2040706@dawncrow.de>
In-Reply-To: <520D1D9D.2040706@dawncrow.de>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:iFUu3MAwf0iTSdowKUM3h01IuJhu8wutdIUouVvy8sA
 SwYn1QD4pfhOVFvG+xIo0+j6hhYbAM9az89WMuz5lVhI2eNxlZ
 6z4D33NclVhyoY8r9jVftTywDObkVVmn20MLOL2A8Uj8Ce9tFt
 dKNPBxueRG8N9L16XfZXHbqL/QIKYxFLxST/MmgE1xG3oC9NKJ
 uxh0zlNPCrdaWwm6CS9hhMHwC3mULf4CvsE7VYZ4Xq7jF6U6YI
 RcTYnHn0EPEvbngF0reYPxYVVbHM9YYXBJwnvAwaZnzkQyi8dC
 c8KlZZ44ApuI8Y7KFDEqGtkD5XKaYLrxPaQQ1KtrcvD/IKZV55
 dYDgN6JcoHRcBDtYRmHQ=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 15.08.2013 20:27, schrieb André Hentschel:
> Hi Jonathan,
> 
> Am 15.08.2013 19:29, schrieb Jonathan Austin:
>> Hi André
>> What I've *not* tested:
>> * As this CPU does not have the tls register, I haven't run any tests that try to read/write it, but we wouldn't expect that to work, right?
>> * Haven't tried a V7 platform, as I understand you've already done that.
>> * Haven't verified it still builds for v4 (which was the problem for ldrd in the past and now we've put it back, so that's important)
> 
> It shouldn't matter as v4 would not use the v6 codepath, would it?
> 
>> * Performance impact
> 
> I only could test it on v7, would be interesting to see some v6, v5, ... "benchmarks", though.
> 

I did some "benchmarks" on my pandaboard(armv7) and it turns out that ldrd is slightly slower than two ldr.
So with this in mind the best thing is most likely the easiest one, so what about this untested patch below?
(It intends to improve the situation for tls_none and tls_software)

diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 83259b8..1dd50f8 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -3,17 +3,21 @@
 
 #ifdef __ASSEMBLY__
 #include <asm/asm-offsets.h>
-	.macro switch_tls_none, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_none, prev, next, tp, tpuser, tmp1, tmp2
 	.endm
 
-	.macro switch_tls_v6k, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_v6k, prev, next, tp, tpuser, tmp1, tmp2
+	ldr	\tp, [\next, #TI_TP_VALUE]
+	ldr	\tpuser, [\next, #TI_TP_VALUE + 4]
 	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
 	mcr	p15, 0, \tpuser, c13, c0, 2	@ and the user r/w register
-	str	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
+	str	\tmp2, [\prev, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro switch_tls_v6, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_v6, prev, next, tp, tpuser, tmp1, tmp2
+	ldr	\tp, [\next, #TI_TP_VALUE]
+	ldr	\tpuser, [\next, #TI_TP_VALUE + 4]
 	ldr	\tmp1, =elf_hwcap
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
@@ -22,10 +26,11 @@
 	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
 	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
 	mcrne	p15, 0, \tpuser, c13, c0, 2	@ set user r/w register
-	strne	\tmp2, [\base, #TI_TP_VALUE + 4] @ save it
+	strne	\tmp2, [\prev, #TI_TP_VALUE + 4] @ save it
 	.endm
 
-	.macro switch_tls_software, base, tp, tpuser, tmp1, tmp2
+	.macro switch_tls_software, prev, next, tp, tpuser, tmp1, tmp2
+	ldr	\tp, [\next, #TI_TP_VALUE]
 	mov	\tmp1, #0xffff0fff
 	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 9cbe70c..4df8976 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -690,12 +690,10 @@ ENTRY(__switch_to)
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

