Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755913Ab3BRRGp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 12:06:45 -0500
Received: from mail-ve0-f178.google.com ([209.85.128.178]:49451 "EHLO
	mail-ve0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754987Ab3BRRGo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 12:06:44 -0500
Date: Mon, 18 Feb 2013 12:06:32 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Shawn Guo <shawn.guo@linaro.org>
cc: Russell King - ARM Linux <linux@arm.linux.org.uk>,
        Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Pavel Machek <pavel@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Simon Horman <horms+renesas@verge.net.au>,
        Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link
 error
In-Reply-To: <20130218055541.GK6782@S2101-09.ap.freescale.net>
Message-ID: <alpine.LFD.2.03.1302181204050.6419@syhkavp.arg>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-9-git-send-email-arnd@arndb.de> <20130215110720.GL17833@n2100.arm.linux.org.uk> <alpine.LFD.2.03.1302152336520.6419@syhkavp.arg>
 <20130218055541.GK6782@S2101-09.ap.freescale.net>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, 18 Feb 2013, Shawn Guo wrote:

> On Sat, Feb 16, 2013 at 12:14:49AM -0500, Nicolas Pitre wrote:
> > Something like this should work:
> > 
> > diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
> > index 7e49deb128..9de26f3edb 100644
> > --- a/arch/arm/mach-imx/headsmp.S
> > +++ b/arch/arm/mach-imx/headsmp.S
> > @@ -99,8 +99,11 @@ phys_l2x0_saved_regs:
> >  #endif
> >  
> >  ENTRY(v7_cpu_resume)
> > -	bl	v7_invalidate_l1
> > +	ldr	ip, 2f
> > +	mov	lr, pc
> > +1:	add	pc, pc, ip
> >  	pl310_resume
> >  	b	cpu_resume
> > +2:	.word v7_invalidate_l1 - 1b - 8
> >  ENDPROC(v7_cpu_resume)
> >  #endif
> > 
> Yes, it works.
> 
> > 
> > However it is probably best to move all the code to the .text section 
> > where it belongs and fixup the data access instead.  I must plead guilty 
> > for introducing this idea of putting code in the .data section with the 
> > SA1100resume code over 10 years ago that everyone copied since.
> > 
> > So here's how I think it should look instead, and how I should have done 
> > the SA1100 code back then:
> > 
> > diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
> > index 7e49deb128..38a544a037 100644
> > --- a/arch/arm/mach-imx/headsmp.S
> > +++ b/arch/arm/mach-imx/headsmp.S
> > @@ -73,16 +73,16 @@ ENDPROC(v7_secondary_startup)
> >  
> >  #ifdef CONFIG_PM
> >  /*
> > - * The following code is located into the .data section.  This is to
> > - * allow phys_l2x0_saved_regs to be accessed with a relative load
> > - * as we are running on physical address here.
> > + * The following code must assume it is running from physical address
> > + * where absolute virtual addresses to the data section have to be
> > + * turned into relative ones.
> >   */
> > -	.data
> > -	.align
> >  
> >  #ifdef CONFIG_CACHE_L2X0
> >  	.macro	pl310_resume
> > -	ldr	r2, phys_l2x0_saved_regs
> > +	adr	r0, phys_l2x0_saved_ptr_offset
> > +	ldr	r2, [r0]
> > +	add	r2, r2, r0
> >  	ldr	r0, [r2, #L2X0_R_PHY_BASE]	@ get physical base of l2x0
> >  	ldr	r1, [r2, #L2X0_R_AUX_CTRL]	@ get aux_ctrl value
> >  	str	r1, [r0, #L2X0_AUX_CTRL]	@ restore aux_ctrl
> > @@ -90,9 +90,13 @@ ENDPROC(v7_secondary_startup)
> >  	str	r1, [r0, #L2X0_CTRL]		@ re-enable L2
> >  	.endm
> >  
> > +	.bss
> >  	.globl	phys_l2x0_saved_regs
> >  phys_l2x0_saved_regs:
> > -        .long   0
> > +        .space   4
> > +	.previous
> > +phys_l2x0_saved_ptr_offset:
> > +	.word	phys_l2x0_saved_regs - .
> >  #else
> >  	.macro	pl310_resume
> >  	.endm
> > 
> But this does not work.  It seems the execution jumps to the start of
> kernel on system resuming.

Try the following instead.  It makes the code simpler and easier to 
debug.

diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
index 7e49deb128..27bc06e910 100644
--- a/arch/arm/mach-imx/headsmp.S
+++ b/arch/arm/mach-imx/headsmp.S
@@ -73,16 +73,16 @@ ENDPROC(v7_secondary_startup)
 
 #ifdef CONFIG_PM
 /*
- * The following code is located into the .data section.  This is to
- * allow phys_l2x0_saved_regs to be accessed with a relative load
- * as we are running on physical address here.
+ * The following code must assume it is running from physical address
+ * where absolute virtual addresses to the data section have to be
+ * turned into relative ones.
  */
-	.data
-	.align
 
 #ifdef CONFIG_CACHE_L2X0
 	.macro	pl310_resume
-	ldr	r2, phys_l2x0_saved_regs
+	adr	r0, l2x0_saved_regs_offset
+	ldr	r2, [r0]
+	add	r2, r2, r0
 	ldr	r0, [r2, #L2X0_R_PHY_BASE]	@ get physical base of l2x0
 	ldr	r1, [r2, #L2X0_R_AUX_CTRL]	@ get aux_ctrl value
 	str	r1, [r0, #L2X0_AUX_CTRL]	@ restore aux_ctrl
@@ -90,9 +90,9 @@ ENDPROC(v7_secondary_startup)
 	str	r1, [r0, #L2X0_CTRL]		@ re-enable L2
 	.endm
 
-	.globl	phys_l2x0_saved_regs
-phys_l2x0_saved_regs:
-        .long   0
+l2x0_saved_regs_offset:
+	.word	l2x0_saved_regs - .
+
 #else
 	.macro	pl310_resume
 	.endm
diff --git a/arch/arm/mach-imx/pm-imx6q.c b/arch/arm/mach-imx/pm-imx6q.c
index f7b0c2b1b9..f3791f980d 100644
--- a/arch/arm/mach-imx/pm-imx6q.c
+++ b/arch/arm/mach-imx/pm-imx6q.c
@@ -21,8 +21,6 @@
 #include <mach/common.h>
 #include <mach/hardware.h>
 
-extern unsigned long phys_l2x0_saved_regs;
-
 static int imx6q_suspend_finish(unsigned long val)
 {
 	cpu_do_idle();
@@ -55,18 +53,5 @@ static const struct platform_suspend_ops imx6q_pm_ops = {
 
 void __init imx6q_pm_init(void)
 {
-	/*
-	 * The l2x0 core code provides an infrastucture to save and restore
-	 * l2x0 registers across suspend/resume cycle.  But because imx6q
-	 * retains L2 content during suspend and needs to resume L2 before
-	 * MMU is enabled, it can only utilize register saving support and
-	 * have to take care of restoring on its own.  So we save physical
-	 * address of the data structure used by l2x0 core to save registers,
-	 * and later restore the necessary ones in imx6q resume entry.
-	 */
-#ifdef CONFIG_CACHE_L2X0
-	phys_l2x0_saved_regs = __pa(&l2x0_saved_regs);
-#endif
-
 	suspend_set_ops(&imx6q_pm_ops);
 }

Nicolas
