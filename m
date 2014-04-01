Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751559AbaDANEA (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Apr 2014 09:04:00 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58381 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750786AbaDAND6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Apr 2014 09:03:58 -0400
Date: Tue, 1 Apr 2014 06:03:30 -0700
From: "tip-bot for Maciej W. Rozycki" <tipbot@zytor.com>
Message-ID: <tip-023de4a09f571fad0af9691e4e437e14b68f05fb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        richard@nod.at, macro@linux-mips.org, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        macro@linux-mips.org, richard@nod.at, tglx@linutronix.de
In-Reply-To: <alpine.LFD.2.11.1404011300010.27402@eddie.linux-mips.org>
References: <alpine.LFD.2.11.1404011300010.27402@eddie.linux-mips.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:x86/urgent] x86/apic:
  Reinstate error IRQ Pentium erratum 3AP workaround
Git-Commit-ID: 023de4a09f571fad0af9691e4e437e14b68f05fb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  023de4a09f571fad0af9691e4e437e14b68f05fb
Gitweb:     http://git.kernel.org/tip/023de4a09f571fad0af9691e4e437e14b68f05fb
Author:     Maciej W. Rozycki <macro@linux-mips.org>
AuthorDate: Tue, 1 Apr 2014 13:30:21 +0100
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 1 Apr 2014 14:59:43 +0200

x86/apic: Reinstate error IRQ Pentium erratum 3AP workaround

A change introduced with commit 60283df7ac26a4fe2d56631ca2946e04725e7eaf
("x86/apic: Read Error Status Register correctly") removed a read from the
APIC ESR register made before writing to same required to retrieve the
correct error status on Pentium systems affected by the 3AP erratum[1]:

	"3AP. Writes to Error Register Clears Register

	PROBLEM: The APIC Error register is intended to only be read.
	If there is a write to this register the data in the APIC Error
	register will be cleared and lost.

	IMPLICATION: There is a possibility of clearing the Error
	register status since the write to the register is not
	specifically blocked.

	WORKAROUND: Writes should not occur to the Pentium processor
	APIC Error register.

	STATUS: For the steppings affected see the Summary Table of
	Changes at the beginning of this section."

The steppings affected are actually: B1, B3 and B5.

To avoid this information loss this change avoids the write to
ESR on all Pentium systems where it is actually never needed;
in Pentium processor documentation ESR was noted read-only and
the write only required for future architectural
compatibility[2].

The approach taken is the same as in lapic_setup_esr().

References:

	[1] "Pentium Processor Family Developer's Manual", Intel Corporation,
	    1997, order number 241428-005, Appendix A "Errata and S-Specs for the
	    Pentium Processor Family", p. A-92,

	[2] "Pentium Processor Family Developer's Manual, Volume 3: Architecture
	    and Programming Manual", Intel Corporation, 1995, order number
	    241430-004, Section 19.3.3. "Error Handling In APIC", p. 19-33.

Signed-off-by: Maciej W. Rozycki <macro@linux-mips.org>
Cc: Richard Weinberger <richard@nod.at>
Link: http://lkml.kernel.org/r/alpine.LFD.2.11.1404011300010.27402@eddie.linux-mips.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 arch/x86/kernel/apic/apic.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/arch/x86/kernel/apic/apic.c b/arch/x86/kernel/apic/apic.c
index 53e2053..005ed3f 100644
--- a/arch/x86/kernel/apic/apic.c
+++ b/arch/x86/kernel/apic/apic.c
@@ -1996,7 +1996,8 @@ static inline void __smp_error_interrupt(struct pt_regs *regs)
 	};
 
 	/* First tickle the hardware, only then report what went on. -- REW */
-	apic_write(APIC_ESR, 0);
+	if (lapic_get_maxlvt() > 3)	/* Due to the Pentium erratum 3AP. */
+		apic_write(APIC_ESR, 0);
 	v = apic_read(APIC_ESR);
 	ack_APIC_irq();
 	atomic_inc(&irq_err_count);
