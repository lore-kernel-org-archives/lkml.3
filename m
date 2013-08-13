Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757095Ab3HMGdn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 13 Aug 2013 02:33:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60614 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756514Ab3HMGdi (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 13 Aug 2013 02:33:38 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Neuling <mikey@neuling.org>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 05/60] powerpc: Fix hypervisor facility unavaliable vector number
Date: Mon, 12 Aug 2013 23:33:32 -0700
Message-Id: <20130813063332.498809812@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.3.825.g36032ce.dirty
In-Reply-To: <20130813063331.950321483@linuxfoundation.org>
References: <20130813063331.950321483@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Michael Neuling <mikey@neuling.org>

commit 88f094120bd2f012ff494ae50a8d4e0d8af8f69e upstream.

Currently if we take hypervisor facility unavaliable (from 0xf80/0x4f80) we
mark it as an OS facility unavaliable (0xf60) as the two share the same code
path.

The becomes a problem in facility_unavailable_exception() as we aren't able to
see the hypervisor facility unavailable exceptions.

Below fixes this by duplication the required macros.

Signed-off-by: Michael Neuling <mikey@neuling.org>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/exceptions-64s.S |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -848,7 +848,7 @@ hv_facility_unavailable_relon_trampoline
 	. = 0x4f80
 	SET_SCRATCH0(r13)
 	EXCEPTION_PROLOG_0(PACA_EXGEN)
-	b	facility_unavailable_relon_hv
+	b	hv_facility_unavailable_relon_hv
 
 	STD_RELON_EXCEPTION_PSERIES(0x5300, 0x1300, instruction_breakpoint)
 #ifdef CONFIG_PPC_DENORMALISATION
@@ -1175,6 +1175,7 @@ END_FTR_SECTION_IFSET(CPU_FTR_VSX)
 	b	.ret_from_except
 
 	STD_EXCEPTION_COMMON(0xf60, facility_unavailable, .facility_unavailable_exception)
+	STD_EXCEPTION_COMMON(0xf80, hv_facility_unavailable, .facility_unavailable_exception)
 
 	.align	7
 	.globl	__end_handlers
@@ -1188,7 +1189,7 @@ __end_handlers:
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf20, altivec_unavailable)
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf40, vsx_unavailable)
 	STD_RELON_EXCEPTION_PSERIES_OOL(0xf60, facility_unavailable)
-	STD_RELON_EXCEPTION_HV_OOL(0xf80, facility_unavailable)
+	STD_RELON_EXCEPTION_HV_OOL(0xf80, hv_facility_unavailable)
 
 #if defined(CONFIG_PPC_PSERIES) || defined(CONFIG_PPC_POWERNV)
 /*


