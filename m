Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757654Ab3CUI0n (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Mar 2013 04:26:43 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:61313 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754226Ab3CUI0k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Mar 2013 04:26:40 -0400
Message-ID: <514AC418.1070806@gmail.com>
Date: Thu, 21 Mar 2013 16:26:00 +0800
From: Chen Gang F T <chen.gang.flying.transformer@gmail.com>
User-Agent: Mozilla/5.0 (X11; Linux x86_64; rv:17.0) Gecko/20130110 Thunderbird/17.0.2
MIME-Version: 1.0
To: Chen Gang <gang.chen@asianux.com>
CC: Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>,
        sfr@canb.auug.org.au, "paulus@samba.org" <paulus@samba.org>,
        matt@ozlabs.org, imunsie@au1.ibm.com, linuxppc-dev@lists.ozlabs.org,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>
Subject: Re: [Suggestion] PowerPC: kernel: cross compiling issue with allmodconfig
References: <51428C81.6000204@asianux.com> <25841.1363323174@ale.ozlabs.ibm.com> <5142AE27.7060003@asianux.com> <514AA0D9.1090509@asianux.com>
In-Reply-To: <514AA0D9.1090509@asianux.com>
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


  it seems:
    only move slb_miss_realmode to the end, can fix this issue without negative effect.



diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index 200afa5..56bd923 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1066,78 +1066,6 @@ unrecov_user_slb:
 #endif /* __DISABLED__ */
 
 
-/*
- * r13 points to the PACA, r9 contains the saved CR,
- * r12 contain the saved SRR1, SRR0 is still ready for return
- * r3 has the faulting address
- * r9 - r13 are saved in paca->exslb.
- * r3 is saved in paca->slb_r3
- * We assume we aren't going to take any exceptions during this procedure.
- */
-_GLOBAL(slb_miss_realmode)
-	mflr	r10
-#ifdef CONFIG_RELOCATABLE
-	mtctr	r11
-#endif
-
-	stw	r9,PACA_EXSLB+EX_CCR(r13)	/* save CR in exc. frame */
-	std	r10,PACA_EXSLB+EX_LR(r13)	/* save LR */
-
-	bl	.slb_allocate_realmode
-
-	/* All done -- return from exception. */
-
-	ld	r10,PACA_EXSLB+EX_LR(r13)
-	ld	r3,PACA_EXSLB+EX_R3(r13)
-	lwz	r9,PACA_EXSLB+EX_CCR(r13)	/* get saved CR */
-
-	mtlr	r10
-
-	andi.	r10,r12,MSR_RI	/* check for unrecoverable exception */
-	beq-	2f
-
-.machine	push
-.machine	"power4"
-	mtcrf	0x80,r9
-	mtcrf	0x01,r9		/* slb_allocate uses cr0 and cr7 */
-.machine	pop
-
-	RESTORE_PPR_PACA(PACA_EXSLB, r9)
-	ld	r9,PACA_EXSLB+EX_R9(r13)
-	ld	r10,PACA_EXSLB+EX_R10(r13)
-	ld	r11,PACA_EXSLB+EX_R11(r13)
-	ld	r12,PACA_EXSLB+EX_R12(r13)
-	ld	r13,PACA_EXSLB+EX_R13(r13)
-	rfid
-	b	.	/* prevent speculative execution */
-
-2:	mfspr	r11,SPRN_SRR0
-	ld	r10,PACAKBASE(r13)
-	LOAD_HANDLER(r10,unrecov_slb)
-	mtspr	SPRN_SRR0,r10
-	ld	r10,PACAKMSR(r13)
-	mtspr	SPRN_SRR1,r10
-	rfid
-	b	.
-
-unrecov_slb:
-	EXCEPTION_PROLOG_COMMON(0x4100, PACA_EXSLB)
-	DISABLE_INTS
-	bl	.save_nvgprs
-1:	addi	r3,r1,STACK_FRAME_OVERHEAD
-	bl	.unrecoverable_exception
-	b	1b
-
-
-#ifdef CONFIG_PPC_970_NAP
-power4_fixup_nap:
-	andc	r9,r9,r10
-	std	r9,TI_LOCAL_FLAGS(r11)
-	ld	r10,_LINK(r1)		/* make idle task do the */
-	std	r10,_NIP(r1)		/* equivalent of a blr */
-	blr
-#endif
-
 	.align	7
 	.globl alignment_common
 alignment_common:
@@ -1336,6 +1264,78 @@ _GLOBAL(opal_mc_secondary_handler)
 
 
 /*
+ * r13 points to the PACA, r9 contains the saved CR,
+ * r12 contain the saved SRR1, SRR0 is still ready for return
+ * r3 has the faulting address
+ * r9 - r13 are saved in paca->exslb.
+ * r3 is saved in paca->slb_r3
+ * We assume we aren't going to take any exceptions during this procedure.
+ */
+_GLOBAL(slb_miss_realmode)
+	mflr	r10
+#ifdef CONFIG_RELOCATABLE
+	mtctr	r11
+#endif
+
+	stw	r9,PACA_EXSLB+EX_CCR(r13)	/* save CR in exc. frame */
+	std	r10,PACA_EXSLB+EX_LR(r13)	/* save LR */
+
+	bl	.slb_allocate_realmode
+
+	/* All done -- return from exception. */
+
+	ld	r10,PACA_EXSLB+EX_LR(r13)
+	ld	r3,PACA_EXSLB+EX_R3(r13)
+	lwz	r9,PACA_EXSLB+EX_CCR(r13)	/* get saved CR */
+
+	mtlr	r10
+
+	andi.	r10,r12,MSR_RI	/* check for unrecoverable exception */
+	beq-	2f
+
+.machine	push
+.machine	"power4"
+	mtcrf	0x80,r9
+	mtcrf	0x01,r9		/* slb_allocate uses cr0 and cr7 */
+.machine	pop
+
+	RESTORE_PPR_PACA(PACA_EXSLB, r9)
+	ld	r9,PACA_EXSLB+EX_R9(r13)
+	ld	r10,PACA_EXSLB+EX_R10(r13)
+	ld	r11,PACA_EXSLB+EX_R11(r13)
+	ld	r12,PACA_EXSLB+EX_R12(r13)
+	ld	r13,PACA_EXSLB+EX_R13(r13)
+	rfid
+	b	.	/* prevent speculative execution */
+
+2:	mfspr	r11,SPRN_SRR0
+	ld	r10,PACAKBASE(r13)
+	LOAD_HANDLER(r10,unrecov_slb)
+	mtspr	SPRN_SRR0,r10
+	ld	r10,PACAKMSR(r13)
+	mtspr	SPRN_SRR1,r10
+	rfid
+	b	.
+
+unrecov_slb:
+	EXCEPTION_PROLOG_COMMON(0x4100, PACA_EXSLB)
+	DISABLE_INTS
+	bl	.save_nvgprs
+1:	addi	r3,r1,STACK_FRAME_OVERHEAD
+	bl	.unrecoverable_exception
+	b	1b
+
+
+#ifdef CONFIG_PPC_970_NAP
+power4_fixup_nap:
+	andc	r9,r9,r10
+	std	r9,TI_LOCAL_FLAGS(r11)
+	ld	r10,_LINK(r1)		/* make idle task do the */
+	std	r10,_NIP(r1)		/* equivalent of a blr */
+	blr
+#endif
+
+/*
  * Hash table stuff
  */
 	.align	7


On 2013年03月21日 13:55, Chen Gang wrote:
> Hello All:
> 
> summary:
>   the root cause is no enough room in exception area (0x5500 -- 0x7000).
> 
>   it is caused by the patches "for saving/restre PPR":
>     they consumed much space of this area (0x5500 -- 0x7000).
>     for pseries_defconfig and ppc64_defconfig, it is still ok.
>     but for allmodconfig and "some additional config", it will cause issue.
> 
>   the solving patch "Make room in exception vector area" can make room larger.
>     it can let "some additional config" ok.
>     but for allmodconfig, it is still not enough.
> 
> 
> details
>   reason:
>     it is caused by:
>        commit number: 13e7a8e846c2ea38a552b986ea49332f965bbb7a
>        commit number: 44e9309f1f357794b7ae93d5f3e3e6f11d2b8a7f
>     they are "for saving/restore PPR"
>     by Haren Myneni <haren@linux.vnet.ibm.com> Thu, 6 Dec 2012
>     compiling result:
>       pseries_defconfig: pass   (cpu for POWER7)
>       ppc64_defconfig:   pass   (cpu for POWER7)
>       allmodconfig:      failed (cpu for POWER7)
> 
>   analysing:
>     solving patch:
>       ------------------------------------------------------------------
>       commit number: 61383407677aef05928541a00678591abea2d84c
>       Author: Benjamin Herrenschmidt <benh@kernel.crashing.org>
>       Date:   Thu Jan 10 17:44:19 2013 +1100
> 
>         powerpc: Make room in exception vector area
>     
>         The FWNMI region is fixed at 0x7000 and the vector are now
>         overflowing that with some configurations. Fix that by moving
>         some hash management code out of that region as it doesn't need
>         to be that close to the call sites (isn't accessed using
>         conditional branches).
>       ------------------------------------------------------------------
> 
>       but for allmodconfig (not only for "some configurations"):
>         it really can reduce much overflow bytes,
>           (maybe from hundreds bytes to dozens bytes)
>         but still not enough (still content overflow bytes)
> 
>     additional trying:
> 	after del CONFIG_VSX and CONFIG_PPC_970_NAP in allmodconfig,
>           (will reduce dozens bytes in the region .0x5500 -- .0x7000)
>         it can pass compiling (not overflow).
> 
> 
> next:
>   I am sorry:
>       I am not quite familiar with the detail features of powerpc.
>       it seems I am not the suitable member to continue trying.
> 
>   I prefer Benjamin to continue trying (just like what he has done).
> 
>   if Benjamin will not do it (e.g. maybe no time to do)
>     I should continue: "make additional room in exception vector area".
>       (if get no reply within a week: before 2013-03-28, I should continue)
> 
> 
> 
>   welcome any members' (especially Benjamin) suggestions or completions.
> 
>   thanks.
> 
>   :-)
> 
> 
> On 2013年03月15日 13:14, Chen Gang wrote:
>> 于 2013年03月15日 12:52, Michael Neuling 写道:
>>> Yep it's a known problem but no one has bothered to fix it since it
>>> doesn't happen in a config that anyone cares about like
>>> pseries_defconfig and ppc64_defconfig.  We've been moving code around in
>>> this area a lot recently hence the breakage.
>>>
>>> It should be fixed though.  Patches welcome. :-)
>>
>>   thanks, and I should try, and very glad to try.
>>
>>   :-)  :-)
>>
>>   excuse me, I try to provide related patch within this month (2013-03-31), is it ok ?
>>   the reason is:
>>     I am not familiar with ppc assembly code, neither ppc kernel,
>>     so need additional time resource.
>>       (originally, I worked for x86(_64) core dump analysing for kernel and user programs)
>>
>>   thanks.
>>
> 
> 


-- 
Chen Gang

Flying Transformer
