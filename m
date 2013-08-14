Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933287Ab3HNVVo (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 17:21:44 -0400
Received: from moutng.kundenserver.de ([212.227.126.171]:52051 "EHLO
	moutng.kundenserver.de" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933191Ab3HNVVm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 17:21:42 -0400
Message-ID: <520BF4E1.8040708@dawncrow.de>
Date: Wed, 14 Aug 2013 23:21:37 +0200
From: =?UTF-8?B?QW5kcsOpIEhlbnRzY2hlbA==?= <nerv@dawncrow.de>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:17.0) Gecko/20130803 Thunderbird/17.0.8
MIME-Version: 1.0
To: Jonathan Austin <jonathan.austin@arm.com>
CC: "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>
Subject: Re: arm: Only load TLS values when needed
References: <51E42E11.1010903@dawncrow.de> <51E5836B.1010904@arm.com> <51E59E8F.1060501@dawncrow.de> <51E67B98.9040101@arm.com> <51E6F532.1030004@dawncrow.de> <520B8F37.4040609@dawncrow.de> <520BAE58.3060600@arm.com>
In-Reply-To: <520BAE58.3060600@arm.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-Provags-ID: V02:K0:gfhO6dFU3sgO1iWBdNhZiDV8Hu0dWK7torqp6i8td7R
 WbFKuvHJGT4vYLaU0EbJdY2bdGIfq9+mvYdYLfUAMWzTb1GAsc
 WL6HUE3kjnAQwzDS96kLTk8dYhYjMiLPDIj+tFbF7eiY86ECJs
 XCJZGkSgVlYruUMERZJecGlR8ApFCv7WhOig1ONvS+YFLBVN9d
 4kFz6EkYdJn/VivoPdQQaUGBWPErlNiiHJbBgaJRySIMq4QdfE
 U4emXSX1QK9ipwXOg/3415XLUmpiC+qQM/ocJPL3aq7ITLTAew
 6bUos5kLxTZ5Hf0AMLhCcIPw9hkFb4q6CG4bttgbwXvAGMkBNe
 lyeUpfcsbEKTMatzZrn8=
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Am 14.08.2013 18:20, schrieb Jonathan Austin:
> Hi André,
> 
> On 14/08/13 15:07, André Hentschel wrote:
>> Hi Jonathan,
>> Any updates on this?
>>
> 
> I was holding out to see the version with ldrd at the top, as discussed below - I never saw a version with that change? I'd meant to ping you to see if that was coming, sorry.
> 
> 
> [...]
>>>> [...]
>>>>>> Now we've only got one instruction between the store and the load
>>>>>> and risk stalling the pipeline...
>>>>>>
>>>>>> Dave M cautiously says "The ancient advice was that one instruction
>>>>>> was enough" but this is very core dependent... I wonder if anyone
>>>>>> has a good idea about whether this is an issue here...?
>>>>>
>>>>> We could use a ldrd at the top, that'd be nearly what we have right
>>>>> now, don't we?
>>>>
>>>> Yea, that'd be good - as far as I can see from an 1136 TRM, the ldrd *may* be two cycles (depending on alignment of the words) but the ldr and ldrne will always be two cycles. Ahhh, the joys of modifying the fast path ;)
> 
> Was expecting to see something that reflected this discussion,

Ah ok, i misunderstood that, sry.
Something like that?

From: André Hentschel <nerv@dawncrow.de>

This patch intents to reduce loading instructions when the resulting value is not used.
It's a follow up on a4780adeefd042482f624f5e0d577bf9cdcbb760

Signed-off-by: André Hentschel <nerv@dawncrow.de>

---
This patch is against 28fbc8b6a29c849a3f03a6b05010d4b584055665

diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 83259b8..31743f7 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -3,29 +3,31 @@
 
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
+	ldrd	\tp, \tpuser, [\next, #TI_TP_VALUE]
 	ldr	\tmp1, =elf_hwcap
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
 	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
-	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
+	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the previous user r/w register
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
index d40d0ef..11112de 100644
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


