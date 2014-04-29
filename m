Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756755AbaD2JSN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Apr 2014 05:18:13 -0400
Received: from fw-tnat.cambridge.arm.com ([217.140.96.21]:51262 "EHLO
	cam-smtp0.cambridge.arm.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1751668AbaD2JSK (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Apr 2014 05:18:10 -0400
Date: Tue, 29 Apr 2014 10:17:50 +0100
From: Dave Martin <Dave.Martin@arm.com>
To: Joel Fernandes <joelf@ti.com>
Cc: Linux OMAP List <linux-omap@vger.kernel.org>,
        Linux ARM Kernel List <linux-arm-kernel@lists.infradead.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>,
        Russell King <linux@arm.linux.org.uk>, Nishanth Menon <nm@ti.com>,
        Santosh Shilimkar <santosh.shilimkar@ti.com>,
        Tony Lindgren <tony@atomide.com>
Subject: Re: [PATCH] ARM: OMAP5: Switch to THUMB mode if needed on secondary
 CPU
Message-ID: <20140429091725.GA3582@e103592.cambridge.arm.com>
References: <1398191506-3741-1-git-send-email-joelf@ti.com>
 <20140428164348.GA14354@e103592.cambridge.arm.com>
 <535E8DC2.4010504@ti.com>
 <535E8E2D.1020708@ti.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <535E8E2D.1020708@ti.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Mon, Apr 28, 2014 at 06:21:49PM +0100, Joel Fernandes wrote:
> On 04/28/2014 12:20 PM, Joel Fernandes wrote:
> > On 04/28/2014 11:43 AM, Dave Martin wrote:
> >> On Tue, Apr 22, 2014 at 01:31:46PM -0500, Joel Fernandes wrote:
> >>> On my DRA7 system, when the kernel is built in THUMB mode, the secondary CPU
> >>> (Cortex A15) fails to come up causing SMP boot on second CPU to timeout. This
> >>> seems to be because the CPU is in ARM mode once the ROM hands over control to
> >>> the kernel.  Switch to THUMB mode if required once the kernel is control of
> >>> secondary CPU. On OMAP4 on the other hand, it appears to be in THUMB mode on
> >>> entry so this is not required and SMP boot works as is.
> >>>
> >>> Cc: Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>> Cc: Russell King <linux@arm.linux.org.uk>
> >>> Cc: Nishanth Menon <nm@ti.com>
> >>> Cc: Tony Lindgren <tony@atomide.com>
> >>> Signed-off-by: Joel Fernandes <joelf@ti.com>
> >>> ---
> >>>  arch/arm/mach-omap2/omap-headsmp.S |    8 ++++++--
> >>>  1 file changed, 6 insertions(+), 2 deletions(-)
> >>>
> >>> diff --git a/arch/arm/mach-omap2/omap-headsmp.S b/arch/arm/mach-omap2/omap-headsmp.S
> >>> index 75e9295..1809dce 100644
> >>> --- a/arch/arm/mach-omap2/omap-headsmp.S
> >>> +++ b/arch/arm/mach-omap2/omap-headsmp.S
> >>> @@ -1,7 +1,7 @@
> >>>  /*
> >>>   * Secondary CPU startup routine source file.
> >>>   *
> >>> - * Copyright (C) 2009 Texas Instruments, Inc.
> >>> + * Copyright (C) 2014 Texas Instruments, Inc.
> >>>   *
> >>>   * Author:
> >>>   *      Santosh Shilimkar <santosh.shilimkar@ti.com>
> >>> @@ -28,9 +28,13 @@
> >>>   * code.  This routine also provides a holding flag into which
> >>>   * secondary core is held until we're ready for it to initialise.
> >>>   * The primary core will update this flag using a hardware
> >>> -+ * register AuxCoreBoot0.
> >>> + * register AuxCoreBoot0.
> >>>   */
> >>>  ENTRY(omap5_secondary_startup)
> >>
> >> Are you sure this problem is not caused by the missing ENDPROC() for
> >> omap5_secondary_startup?
> >>
> >> You have END() instead (which may have been accidental).
> >>
> >> Without ENDPROC(), the symbol is not marked as a function and so
> >> the Thumb bit won't be set when taking a pointer -- so the kernel
> >> is actually telling the firmware to enter in ARM state.
> >>
> >>
> >> Try changing END() to ENDPROC() without this patch, and see if it
> >> makes a difference.
> >>
> >> If it still doesn't work, then the firmware either doesn't support
> >> entering in ARM, or is buggy.
> > 
> > Thanks for the suggestion. I'm guessing what you mean is with ENDPROC,
> > interworking code uses bx instead of bl to set thumb mode.
> > 
> > But ROM/firmware doesn't have access to symbol table, how would it know
> > the type of the symbol to be ARM or THUMB before it branches?
> > 
> Sorry what I meant is, say its of Type function. What tells the firmware
> to switch to THUMB?
> 
> What's typically done is a boot address register is written by the
> kernel, and the firmware jumps to it after WFE.

Using ENTRY(x) ... ENDPROC(x) causes the symbol seen by the linker
for x to have the Thumb bit set if the code is Thumb.

This means that any reference the linker fixes up for that symbol
will have the Thumb bit set appropriately.  This applies to any kind
of reference, so code in another file that takes the address of the
symbol and then passes that address to the firmware should result in the
firmware getting an address with the Thumb bit.

>From the firmware's point of view it just gets a raw address, but
the Thumb bit will now be set.  The firmware still needs to handle
this correctly when jumping, but from the look of the code this may
already work on omap3/4.  It would be interesting to know whether it
works on omap5.

Cheers
---Dave
