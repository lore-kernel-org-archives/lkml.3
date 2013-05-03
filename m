Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1763002Ab3ECJ4E (ORCPT <rfc822;w@1wt.eu>);
	Fri, 3 May 2013 05:56:04 -0400
Received: from caramon.arm.linux.org.uk ([78.32.30.218]:43463 "EHLO
	caramon.arm.linux.org.uk" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1762976Ab3ECJ4C (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 3 May 2013 05:56:02 -0400
Date: Fri, 3 May 2013 10:55:47 +0100
From: Russell King - ARM Linux <linux@arm.linux.org.uk>
To: Jonathan Austin <jonathan.austin@arm.com>
Cc: =?iso-8859-1?Q?Andr=E9?= Hentschel <nerv@dawncrow.de>,
        Will Deacon <Will.Deacon@arm.com>,
        "linux-arch@vger.kernel.org" <linux-arch@vger.kernel.org>,
        "linux-kernel@vger.kernel.org" <linux-kernel@vger.kernel.org>,
        "linux-arm-kernel@lists.infradead.org" 
	<linux-arm-kernel@lists.infradead.org>
Subject: Re: [PATCHv2] arm: Preserve TPIDRURW on context switch
Message-ID: <20130503095547.GD18614@n2100.arm.linux.org.uk>
References: <517168BB.3070903@dawncrow.de> <20130422143616.GP14496@n2100.arm.linux.org.uk> <20130422151836.GA15665@mudshark.cambridge.arm.com> <5175A697.3080308@dawncrow.de> <20130423091536.GB17593@mudshark.cambridge.arm.com> <51770E4E.2040003@dawncrow.de> <20130424094251.GA21850@mudshark.cambridge.arm.com> <5182C480.3080001@dawncrow.de> <5183819E.50308@arm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <5183819E.50308@arm.com>
User-Agent: Mutt/1.5.19 (2009-01-05)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, May 03, 2013 at 10:21:34AM +0100, Jonathan Austin wrote:
>  	.macro set_tls_v6k, tp, tmp1, tmp2
> -	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
> -	mov	\tmp1, #0
> -	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> +	ldrd	\tmp1, \tmp2, [\tp]
> +	mcr	p15, 0, \tmp1, c13, c0, 3	@ set user r/o TLS register
> +	mcr	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register

So we're still back at stalling the pipeline with result delays on older
CPUs?

> +	.endm
> +
> +	.macro save_tlsuser_v6k, tp, tmp1, tmp2
> +	@ TPIDRURW can be updated from userspace, so we have to re-read it
> +	mrc	p15, 0, \tmp2, c13, c0, 2	@ load user r/w TLS register
> +	str	\tmp2, [\tp, #4]
>  	.endm
>  
>  	.macro set_tls_v6, tp, tmp1, tmp2
> @@ -16,15 +25,26 @@
>  	ldr	\tmp1, [\tmp1, #0]
>  	mov	\tmp2, #0xffff0fff
>  	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
> -	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
> -	movne	\tmp1, #0
> -	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
> -	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
> +	ldrned	\tmp1, \tmp2, [\tp]
> +	ldreq	\tmp1, [\tp]
> +	mcrne	p15, 0, \tmp1, c13, c0, 3	@ yes, set user r/o TLS register
> +	mcrne	p15, 0, \tmp2, c13, c0, 2	@ set user r/w TLS register
> +	streq	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0

This at least is better.

> +	.endm
> +
> +	.macro save_tlsuser_v6, tp, tmp1, tmp2
> +	@ TPIDRURW can be updated from userspace, so we have to re-read it
> +	ldr	\tmp1, =elf_hwcap
> +	ldr	\tmp1, [\tmp1, #0]
> +	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?

But this isn't - this involves two delays.

> +	mrcne	p15, 0, \tmp2, c13, c0, 2	@ read user r/w TLS register
> +	strne	\tmp2, [\tp, #4]		@ save in to thread_info
>  	.endm
>  
>  	.macro set_tls_software, tp, tmp1, tmp2
> -	mov	\tmp1, #0xffff0fff
> -	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
> +	ldr	\tmp1, [\tp]
> +	mov	\tmp2, #0xffff0fff
> +	str	\tmp1, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
>  	.endm
>  #endif
>  
> @@ -32,18 +52,31 @@
>  #define tls_emu		1
>  #define has_tls_reg		1
>  #define set_tls		set_tls_none
> +#define save_tlsuser	save_tlsuser_none
> +#define get_tlsuser	get_tlsuser_none
>  #elif defined(CONFIG_CPU_V6)
>  #define tls_emu		0
>  #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
>  #define set_tls		set_tls_v6
> +#define save_tlsuser	save_tlsuser_v6
> +#define get_tlsuser	get_tlsuser_v6
>  #elif defined(CONFIG_CPU_32v6K)
>  #define tls_emu		0
>  #define has_tls_reg		1
>  #define set_tls		set_tls_v6k
> +#define save_tlsuser	save_tlsuser_v6k
> +#define get_tlsuser	get_tlsuser_v6k
>  #else
>  #define tls_emu		0
>  #define has_tls_reg		0
>  #define set_tls		set_tls_software
> +#define save_tlsuser	save_tlsuser_none
> +#define get_tlsuser	get_tlsuser_none
>  #endif

This separation of setting and saving the TLS value is actually quite
silly.  They're called from the same place, so lets just call it
"switch_tls" instead.

Here's just the assembly bits doing that - this is totally untested
of course:

 arch/arm/include/asm/tls.h   |   28 +++++++++++++++-------------
 arch/arm/kernel/entry-armv.S |    4 ++--
 2 files changed, 17 insertions(+), 15 deletions(-)

diff --git a/arch/arm/include/asm/tls.h b/arch/arm/include/asm/tls.h
index 73409e6..9c377f1 100644
--- a/arch/arm/include/asm/tls.h
+++ b/arch/arm/include/asm/tls.h
@@ -2,27 +2,29 @@
 #define __ASMARM_TLS_H
 
 #ifdef __ASSEMBLY__
-	.macro set_tls_none, tp, tmp1, tmp2
+	.macro switch_tls_none, base, tp, trw, tmp1, tmp2
 	.endm
 
-	.macro set_tls_v6k, tp, tmp1, tmp2
+	.macro switch_tls_v6k, base, tp, trw, tmp1, tmp2
+	mrc	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
 	mcr	p15, 0, \tp, c13, c0, 3		@ set TLS register
-	mov	\tmp1, #0
-	mcr	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
+	mcr	p15, 0, \trw, c13, c0, 2	@ and the user r/w register
+	str	\tmp2, [\base, #TI_TP_VALUE + 4]@ save it
 	.endm
 
-	.macro set_tls_v6, tp, tmp1, tmp2
+	.macro switch_tls_v6, base, tp, trw, tmp1, tmp2
 	ldr	\tmp1, =elf_hwcap
 	ldr	\tmp1, [\tmp1, #0]
 	mov	\tmp2, #0xffff0fff
 	tst	\tmp1, #HWCAP_TLS		@ hardware TLS available?
-	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
-	movne	\tmp1, #0
-	mcrne	p15, 0, \tmp1, c13, c0, 2	@ clear user r/w TLS register
 	streq	\tp, [\tmp2, #-15]		@ set TLS value at 0xffff0ff0
+	mrcne	p15, 0, \tmp2, c13, c0, 2	@ get the user r/w register
+	mcrne	p15, 0, \tp, c13, c0, 3		@ yes, set TLS register
+	mcrne	p15, 0, \trw, c13, c0, 2	@ set user r/w register
+	strne	\tmp2, [\base, #TI_TP_VALUE + 4]@ save it
 	.endm
 
-	.macro set_tls_software, tp, tmp1, tmp2
+	.macro switch_tls_software, base, tp, trw, tmp1, tmp2
 	mov	\tmp1, #0xffff0fff
 	str	\tp, [\tmp1, #-15]		@ set TLS value at 0xffff0ff0
 	.endm
@@ -31,19 +33,19 @@
 #ifdef CONFIG_TLS_REG_EMUL
 #define tls_emu		1
 #define has_tls_reg		1
-#define set_tls		set_tls_none
+#define switch_tls	switch_tls_none
 #elif defined(CONFIG_CPU_V6)
 #define tls_emu		0
 #define has_tls_reg		(elf_hwcap & HWCAP_TLS)
-#define set_tls		set_tls_v6
+#define switch_tls	switch_tls_v6
 #elif defined(CONFIG_CPU_32v6K)
 #define tls_emu		0
 #define has_tls_reg		1
-#define set_tls		set_tls_v6k
+#define switch_tls	switch_tls_v6k
 #else
 #define tls_emu		0
 #define has_tls_reg		0
-#define set_tls		set_tls_software
+#define switch_tls	switch_tls_software
 #endif
 
 #endif	/* __ASMARM_TLS_H */
diff --git a/arch/arm/kernel/entry-armv.S b/arch/arm/kernel/entry-armv.S
index 0f82098..81a08b1 100644
--- a/arch/arm/kernel/entry-armv.S
+++ b/arch/arm/kernel/entry-armv.S
@@ -728,15 +728,15 @@ ENTRY(__switch_to)
  UNWIND(.fnstart	)
  UNWIND(.cantunwind	)
 	add	ip, r1, #TI_CPU_SAVE
-	ldr	r3, [r2, #TI_TP_VALUE]
  ARM(	stmia	ip!, {r4 - sl, fp, sp, lr} )	@ Store most regs on stack
  THUMB(	stmia	ip!, {r4 - sl, fp}	   )	@ Store most regs on stack
  THUMB(	str	sp, [ip], #4		   )
  THUMB(	str	lr, [ip], #4		   )
+	ldrd	r4, r5, [r2, #TI_TP_VALUE]
 #ifdef CONFIG_CPU_USE_DOMAINS
 	ldr	r6, [r2, #TI_CPU_DOMAIN]
 #endif
-	set_tls	r3, r4, r5
+	switch_tls r2, r4, r5, r3, r7
 #if defined(CONFIG_CC_STACKPROTECTOR) && !defined(CONFIG_SMP)
 	ldr	r7, [r2, #TI_TASK]
 	ldr	r8, =__stack_chk_guard

