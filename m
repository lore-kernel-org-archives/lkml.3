Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934512Ab3GWW1I (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:27:08 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41479 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934426Ab3GWW1D (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 011/103] powerpc: Remove KVMTEST from RELON exception handlers
Date: Tue, 23 Jul 2013 15:25:22 -0700
Message-Id: <20130723220419.829164182@linuxfoundation.org>
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

commit c9f69518e5f08170bc857984a077f693d63171df upstream.

KVMTEST is a macro which checks whether we are taking an exception from
guest context, if so we branch out of line and eventually call into the
KVM code to handle the switch.

When running real guests on bare metal (HV KVM) the hardware ensures
that we never take a relocation on exception when transitioning from
guest to host. For PR KVM we disable relocation on exceptions ourself in
kvmppc_core_init_vm(), as of commit a413f47 "Disable relocation on
exceptions whenever PR KVM is active".

So convert all the RELON macros to use NOTEST, and drop the remaining
KVM_HANDLER() definitions we have for 0xe40 and 0xe80.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/include/asm/exception-64s.h |    8 ++++----
 arch/powerpc/kernel/exceptions-64s.S     |    2 --
 2 files changed, 4 insertions(+), 6 deletions(-)

--- a/arch/powerpc/include/asm/exception-64s.h
+++ b/arch/powerpc/include/asm/exception-64s.h
@@ -358,12 +358,12 @@ label##_relon_pSeries:					\
 	/* No guest interrupts come through here */	\
 	SET_SCRATCH0(r13);		/* save r13 */	\
 	EXCEPTION_RELON_PROLOG_PSERIES(PACA_EXGEN, label##_common, \
-				       EXC_STD, KVMTEST_PR, vec)
+				       EXC_STD, NOTEST, vec)
 
 #define STD_RELON_EXCEPTION_PSERIES_OOL(vec, label)		\
 	.globl label##_relon_pSeries;				\
 label##_relon_pSeries:						\
-	EXCEPTION_PROLOG_1(PACA_EXGEN, KVMTEST_PR, vec);	\
+	EXCEPTION_PROLOG_1(PACA_EXGEN, NOTEST, vec);		\
 	EXCEPTION_RELON_PROLOG_PSERIES_1(label##_common, EXC_STD)
 
 #define STD_RELON_EXCEPTION_HV(loc, vec, label)		\
@@ -374,12 +374,12 @@ label##_relon_hv:					\
 	/* No guest interrupts come through here */	\
 	SET_SCRATCH0(r13);	/* save r13 */		\
 	EXCEPTION_RELON_PROLOG_PSERIES(PACA_EXGEN, label##_common, \
-				       EXC_HV, KVMTEST, vec)
+				       EXC_HV, NOTEST, vec)
 
 #define STD_RELON_EXCEPTION_HV_OOL(vec, label)			\
 	.globl label##_relon_hv;				\
 label##_relon_hv:						\
-	EXCEPTION_PROLOG_1(PACA_EXGEN, KVMTEST, vec);		\
+	EXCEPTION_PROLOG_1(PACA_EXGEN, NOTEST, vec);		\
 	EXCEPTION_RELON_PROLOG_PSERIES_1(label##_common, EXC_HV)
 
 /* This associate vector numbers with bits in paca->irq_happened */
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1175,9 +1175,7 @@ __end_handlers:
 
 	/* Equivalents to the above handlers for relocation-on interrupt vectors */
 	STD_RELON_EXCEPTION_HV_OOL(0xe40, emulation_assist)
-	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe40)
 	MASKABLE_RELON_EXCEPTION_HV_OOL(0xe80, h_doorbell)
-	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe80)
 
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf00, performance_monitor)
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf20, altivec_unavailable)


