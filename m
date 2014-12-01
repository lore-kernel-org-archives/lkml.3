Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753124AbaLAKcG (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 05:32:06 -0500
Received: from lvps176-28-13-145.dedicated.hosteurope.de ([176.28.13.145]:40588
	"EHLO lvps176-28-13-145.dedicated.hosteurope.de" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752767AbaLAKcE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 05:32:04 -0500
From: Tim Sander <tim@krieglstein.org>
To: Russell King - ARM Linux <linux@arm.linux.org.uk>
Cc: Daniel Thompson <daniel.thompson@linaro.org>,
        Thomas Gleixner <tglx@linutronix.de>,
        Jason Cooper <jason@lakedaemon.net>, linux-kernel@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, patches@linaro.org,
        linaro-kernel@lists.linaro.org, John Stultz <john.stultz@linaro.org>,
        Sumit Semwal <sumit.semwal@linaro.org>,
        Dirk Behme <dirk.behme@de.bosch.com>,
        Daniel Drake <drake@endlessm.com>,
        Dmitry Pervushin <dpervushin@gmail.com>
Subject: Re: [PATCH 3.18-rc3 v9 5/5] arm: smp: Handle ipi_cpu_backtrace() using FIQ (if available)
Date: Mon, 01 Dec 2014 11:32 +0100
Message-ID: <1633306.naE1qIcAOt@dabox>
Organization: Sander and Lightning
User-Agent: KMail/4.14.2 (Linux/3.16.3; KDE/4.14.2; x86_64; ; )
In-Reply-To: <20141128100828.GQ3836@n2100.arm.linux.org.uk>
References: <1415968543-29469-1-git-send-email-daniel.thompson@linaro.org> <13373554.4deCsZOMXS@dabox> <20141128100828.GQ3836@n2100.arm.linux.org.uk>
MIME-Version: 1.0
Content-Transfer-Encoding: 7Bit
Content-Type: text/plain; charset="us-ascii"
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Hi Russel, Daniel

Am Freitag, 28. November 2014, 10:08:28 schrieb Russell King - ARM Linux:
> On Fri, Nov 28, 2014 at 10:10:04AM +0100, Tim Sander wrote:
> > Hi Daniel, Russell
> > 
> > Am Mittwoch, 26. November 2014, 16:17:06 schrieb Daniel Thompson:
> > > On 26/11/14 13:12, Russell King - ARM Linux wrote:
> > > > On Wed, Nov 26, 2014 at 01:46:52PM +0100, Tim Sander wrote:
> > > >> Hi Daniel
> > > >> 
> > > >> Am Dienstag, 25. November 2014, 17:26:41 schrieb Daniel Thompson:
> > > >>> Previous changes have introduced both a replacement default FIQ
> > > >>> handler
> > > >>> and an implementation of arch_trigger_all_cpu_backtrace for ARM but
> > > >>> these are currently independent of each other.
> > > >>> 
> > > >>> This patch plumbs together these features making it possible, on
> > > >>> platforms
> > > >>> that support it, to trigger backtrace using FIQ.
> > > >> 
> > > >> Does this ipi handler interfere in any way with set_fiq_handler?
> > > >> 
> > > >> As far as i know there is only one FIQ handler vector so i guess
> > > >> there is
> > > >> a
> > > >> potential conflict. But i have not worked with IPI's so i might be
> > > >> completley wrong.
> > > > 
> > > > First, the code in arch/arm/kernel/fiq.c should work with this new FIQ
> > > > code in that the new FIQ code is used as the "default" handler (as
> > > > opposed to the original handler which was a total no-op.)
> > > > 
> > > > Secondly, use of arch/arm/kernel/fiq.c in a SMP system is really not a
> > > > good idea: the FIQ registers are private to each CPU in the system,
> > > > and
> > > > there is no infrastructure to allow fiq.c to ensure that it loads the
> > > > right CPU with the register information for the provided handler.
> > 
> > Well given the races in the GIC v1. i have seen in the chips on my desk
> > initializing with for_each_possible_cpu(cpu) work_on_cpu(cpu,..) is rather
> > easy.
> > 
> > > > So, use of arch/arm/kernel/fiq.c and the IPI's use of FIQ /should/ be
> > > > mutually exclusive.
> > 
> > Yes but i digress on the assessment that this a decision between SMP and
> > non- SMP usage or the availbility of the GIC.
> 
> The two things are mutually exclusive.  You can either have FIQ being used
> for debug purposes, where we decode the FIQ reason and call some function
> (which means that we will only service one FIQ at a time) or you can use
> it in exclusive mode (provided by fiq.c) where your handler has sole usage
> of the vector, and benefits from fast and immediate servicing of the event.
As far as i am aware, die CONFIG_FIQ symbol is not pulled by all ARM 
platforms. Since there are ARM platforms which don't use this symbol but the 
hardware is fully capable of handling FIQ requests i would expect, that adding
CONFIG_FIQ to a plattform, that this platform honors the set_fiq_handler 
functionality. 
> You can't have fast and immediate servicing of the event _and_ debug usage
> at the same time.
> 
> > Well i am not against these features as they assumably improve the
> > backtrace, but it would be nice to have a config option which switches
> > between set_fiq_handler usage and the other conflicting usages of the
> > fiq.
> You have a config option already.  CONFIG_FIQ.
Yes, but if the FIQ handler is also used for IPI, set_fiq_handler gets IPI 
interrupts (with the patch starting this thread)? So i think that the patch 
needs to look like:
--- a/arch/arm/kernel/traps.c
+++ b/arch/arm/kernel/traps.c
@@ -483,6 +483,9 @@ asmlinkage void __exception_irq_entry 
handle_fiq_as_nmi(struct pt_regs *regs)
+#ifndef CONFIG_FIQ
 #ifdef CONFIG_ARM_GIC
        gic_handle_fiq_ipi();
 #endif
+#endif

As otherwise if the platform has CONFIG_SMP and CONFIG_FIQ and CONFIG_ARM_GIC 
the GIC will get reprogrammed to deliver FIQ's to the handler set by 
set_fiq_handler ?

Best regards
Tim



