Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1750947Ab3BPFOz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 16 Feb 2013 00:14:55 -0500
Received: from mail-vc0-f181.google.com ([209.85.220.181]:51025 "EHLO
	mail-vc0-f181.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741Ab3BPFOx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 16 Feb 2013 00:14:53 -0500
Date: Sat, 16 Feb 2013 00:14:49 -0500 (EST)
From: Nicolas Pitre <nicolas.pitre@linaro.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
cc: Arnd Bergmann <arnd@arndb.de>, linux-arm-kernel@lists.infradead.org,
        Stephen Warren <swarren@nvidia.com>, Pavel Machek <pavel@denx.de>,
        Sascha Hauer <s.hauer@pengutronix.de>, linux-kernel@vger.kernel.org,
        arm@kernel.org, Simon Horman <horms+renesas@verge.net.au>,
        Shawn Guo <shawn.guo@linaro.org>, Dinh Nguyen <dinguyen@altera.com>
Subject: Re: [PATCH 8/9] [HACK] ARM: imx: work around v7_cpu_resume link
 error
In-Reply-To: <20130215110720.GL17833@n2100.arm.linux.org.uk>
Message-ID: <alpine.LFD.2.03.1302152336520.6419@syhkavp.arg>
References: <1360882071-4072668-1-git-send-email-arnd@arndb.de> <1360882071-4072668-9-git-send-email-arnd@arndb.de> <20130215110720.GL17833@n2100.arm.linux.org.uk>
User-Agent: Alpine 2.03 (LFD 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Fri, 15 Feb 2013, Russell King - ARM Linux wrote:

> On Thu, Feb 14, 2013 at 11:47:50PM +0100, Arnd Bergmann wrote:
> > Patch c08e20d24 "arm: Add v7_invalidate_l1 to cache-v7.S"
> > moves the v7_invalidate_l1 symbol out of imx/headsmp.S,
> > which seems to cause a link error because it is now
> > too far away from v7_cpu_resume when building an
> > allyesconfig kernel.
> > 
> > If we move the v7_cpu_resume function from the .data
> > section to .text, that creates another link error
> > for the reference to phys_l2x0_saved_regs, but we
> > can move all of the above to .text.
> > 
> > I believe that this is not a correct bug fix but just
> > a bad workaround, so I'm open to ideas from people
> > who understand the bigger picture.
> 
> Unfortunately, this ends up with writable data in the .text section, which
> is supposed to be read-only.  We should try to preserve that status, even
> though we don't enforce it.
> 
> I guess the problem is that we end up with the .data segment soo far away
> from the .text segment that these branches no longer work (and remember
> that this code executes with the MMU off.)
> 
> The only solution I can think is that we need to do quite a bit of magic
> here to jump to an absolute address, but taking account of the V:P offset.
> That's not going to be particularly nice, and it's going to then also have
> to jump back the other way - to the cpu_resume code which is also in the
> .data section.

Something like this should work:

diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
index 7e49deb128..9de26f3edb 100644
--- a/arch/arm/mach-imx/headsmp.S
+++ b/arch/arm/mach-imx/headsmp.S
@@ -99,8 +99,11 @@ phys_l2x0_saved_regs:
 #endif
 
 ENTRY(v7_cpu_resume)
-	bl	v7_invalidate_l1
+	ldr	ip, 2f
+	mov	lr, pc
+1:	add	pc, pc, ip
 	pl310_resume
 	b	cpu_resume
+2:	.word v7_invalidate_l1 - 1b - 8
 ENDPROC(v7_cpu_resume)
 #endif


However it is probably best to move all the code to the .text section 
where it belongs and fixup the data access instead.  I must plead guilty 
for introducing this idea of putting code in the .data section with the 
SA1100resume code over 10 years ago that everyone copied since.

So here's how I think it should look instead, and how I should have done 
the SA1100 code back then:

diff --git a/arch/arm/mach-imx/headsmp.S b/arch/arm/mach-imx/headsmp.S
index 7e49deb128..38a544a037 100644
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
+	adr	r0, phys_l2x0_saved_ptr_offset
+	ldr	r2, [r0]
+	add	r2, r2, r0
 	ldr	r0, [r2, #L2X0_R_PHY_BASE]	@ get physical base of l2x0
 	ldr	r1, [r2, #L2X0_R_AUX_CTRL]	@ get aux_ctrl value
 	str	r1, [r0, #L2X0_AUX_CTRL]	@ restore aux_ctrl
@@ -90,9 +90,13 @@ ENDPROC(v7_secondary_startup)
 	str	r1, [r0, #L2X0_CTRL]		@ re-enable L2
 	.endm
 
+	.bss
 	.globl	phys_l2x0_saved_regs
 phys_l2x0_saved_regs:
-        .long   0
+        .space   4
+	.previous
+phys_l2x0_saved_ptr_offset:
+	.word	phys_l2x0_saved_regs - .
 #else
 	.macro	pl310_resume
 	.endm

And yet we could dispense with phys_l2x0_saved_regs 
altogether and use l2x0_saved_regs directly here instead.

That doesn't solve the issue of the kernel becoming too large for branch 
displacement fixup though.


Nicolas
