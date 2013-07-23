Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935141Ab3GWW47 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:56:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41487 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934466Ab3GWW1E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:04 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 013/103] powerpc: Wire up the HV facility unavailable exception
Date: Tue, 23 Jul 2013 15:25:24 -0700
Message-Id: <20130723220420.076307910@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <20130723220418.532514378@linuxfoundation.org>
References: <20130723220418.532514378@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Ellerman <michael@ellerman.id.au>

commit b14b6260efeee6eb8942c6e6420e31281892acb6 upstream.

Similar to the facility unavailble exception, except the facilities are
controlled by HFSCR.

Adapt the facility_unavailable_exception() so it can be called for
either the regular or Hypervisor facility unavailable exceptions.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/exceptions-64s.S |   15 +++++++++++++++
 arch/powerpc/kernel/traps.c          |   16 ++++++++++++----
 2 files changed, 27 insertions(+), 4 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -347,6 +347,12 @@ facility_unavailable_trampoline:
 	EXCEPTION_PROLOG_0(PACA_EXGEN)
 	b	facility_unavailable_pSeries
 
+hv_facility_unavailable_trampoline:
+	. = 0xf80
+	SET_SCRATCH0(r13)
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b	facility_unavailable_hv
+
 #ifdef CONFIG_CBE_RAS
 	STD_EXCEPTION_HV(0x1200, 0x1202, cbe_system_error)
 	KVM_HANDLER_SKIP(PACA_EXGEN, EXC_HV, 0x1202)
@@ -525,6 +531,8 @@ denorm_done:
 	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0xf40)
 	STD_EXCEPTION_PSERIES_OOL(0xf60, facility_unavailable)
 	KVM_HANDLER_PR(PACA_EXGEN, EXC_STD, 0xf60)
+	STD_EXCEPTION_HV_OOL(0xf82, facility_unavailable)
+	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xf82)
 
 /*
  * An interrupt came in while soft-disabled. We set paca->irq_happened, then:
@@ -836,6 +844,12 @@ facility_unavailable_relon_trampoline:
 	EXCEPTION_PROLOG_0(PACA_EXGEN)
 	b	facility_unavailable_relon_pSeries
 
+hv_facility_unavailable_relon_trampoline:
+	. = 0x4f80
+	SET_SCRATCH0(r13)
+	EXCEPTION_PROLOG_0(PACA_EXGEN)
+	b	facility_unavailable_relon_hv
+
 	STD_RELON_EXCEPTION_PSERIES(0x5300, 0x1300, instruction_breakpoint)
 #ifdef CONFIG_PPC_DENORMALISATION
 	. = 0x5500
@@ -1174,6 +1188,7 @@ __end_handlers:
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf20, altivec_unavailable)
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf40, vsx_unavailable)
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf60, facility_unavailable)
+	STD_RELON_EXCEPTION_HV_OOL(0xf80, facility_unavailable)
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV)
 /*
--- a/arch/powerpc/kernel/traps.c
+++ b/arch/powerpc/kernel/traps.c
@@ -1295,10 +1295,18 @@ void facility_unavailable_exception(stru
 		"EBB",
 		"TAR",
 	};
-	char *facility;
+	char *facility, *prefix;
 	u64 value;
 
-	value = mfspr(SPRN_FSCR) >> 56;
+	if (regs->trap == 0xf60) {
+		value = mfspr(SPRN_FSCR);
+		prefix = "";
+	} else {
+		value = mfspr(SPRN_HFSCR);
+		prefix = "Hypervisor ";
+	}
+
+	value = value >> 56;
 
 	/* We restore the interrupt state now */
 	if (!arch_irq_disabled_regs(regs))
@@ -1309,8 +1317,8 @@ void facility_unavailable_exception(stru
 	else
 		facility = "unknown";
 
-	pr_err("Facility '%s' unavailable, exception at 0x%lx, MSR=%lx\n",
-		facility, regs->nip, regs->msr);
+	pr_err("%sFacility '%s' unavailable, exception at 0x%lx, MSR=%lx\n",
+		prefix, facility, regs->nip, regs->msr);
 
 	if (user_mode(regs)) {
 		_exception(SIGILL, regs, ILL_ILLOPC, regs->nip);


