Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751533AbaDAMa0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 08:30:26 -0400
Received: from eddie.linux-mips.org ([78.24.191.182]:52627 "EHLO
	cvs.linux-mips.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751153AbaDAMaW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 08:30:22 -0400
Date: Tue, 1 Apr 2014 13:30:21 +0100 (BST)
From: "Maciej W. Rozycki" <macro@linux-mips.org>
To: Ingo Molnar <mingo@kernel.org>
cc: Richard Weinberger <richard@nod.at>, linux-kernel@vger.kernel.org
Subject: [PATCH] x86/apic: Reinstate error IRQ Pentium erratum 3AP
 workaround
Message-ID: <alpine.LFD.2.11.1404011300010.27402@eddie.linux-mips.org>
User-Agent: Alpine 2.11 (LFD 23 2013-08-11)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

A change introduced with commit 60283df7ac26a4fe2d56631ca2946e04725e7eaf 
[x86/apic: Read Error Status Register correctly] removed a read from the 
APIC ESR register made before writing to same required to retrieve the
correct error status on Pentium systems affected by the 3AP erratum[1]:

"3AP. Writes to Error Register Clears Register

PROBLEM: The APIC Error register is intended to only be read.  If there is
a write to this register the data in the APIC Error register will be
cleared and lost.

IMPLICATION: There is a possibility of clearing the Error register status
since the write to the register is not specifically blocked.

WORKAROUND: Writes should not occur to the Pentium processor APIC Error
register.

STATUS: For the steppings affected see the Summary Table of Changes at the
beginning of this section."

The steppings affected are actually: B1, B3 and B5.

To avoid this information loss this change avoids the write to ESR on all 
Pentium systems where it is actually never needed; in Pentium processor 
documentation ESR was noted read-only and the write only required for 
future architectural compatibility[2].  The approach taken in the same as 
in lapic_setup_esr.

References:

[1] "Pentium Processor Family Developer's Manual", Intel Corporation, 
    1997, order number 241428-005, Appendix A "Errata and S-Specs for the 
    Pentium Processor Family", p. A-92,

[2] "Pentium Processor Family Developer's Manual, Volume 3: Architecture 
    and Programming Manual", Intel Corporation, 1995, order number 
    241430-004, Section 19.3.3. "Error Handling In APIC", p. 19-33.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
---
linux-apic-esr-irq-3ap.patch
Index: linux-20140329-tp/arch/x86/kernel/apic/apic.c
===================================================================
--- linux-20140329-tp.orig/arch/x86/kernel/apic/apic.c
+++ linux-20140329-tp/arch/x86/kernel/apic/apic.c
@@ -1989,7 +1989,8 @@ static inline void __smp_error_interrupt
 	};
 
 	/* First tickle the hardware, only then report what went on. -- REW */
-	apic_write(APIC_ESR, 0);
+	if (lapic_get_maxlvt() > 3)	/* Due to the Pentium erratum 3AP. */
+		apic_write(APIC_ESR, 0);
 	v = apic_read(APIC_ESR);
 	ack_APIC_irq();
 	atomic_inc(&irq_err_count);
