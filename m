Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935133Ab3GWWyf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 23 Jul 2013 18:54:35 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41505 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934506Ab3GWW1I (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 23 Jul 2013 18:27:08 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Michael Ellerman <michael@ellerman.id.au>,
        Benjamin Herrenschmidt <benh@kernel.crashing.org>
Subject: [ 010/103] powerpc: Remove unreachable relocation on exception handlers
Date: Tue, 23 Jul 2013 15:25:21 -0700
Message-Id: <20130723220419.707419827@linuxfoundation.org>
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

commit 1d567cb4bd42d560a7621cac6f6aebe87343689e upstream.

We have relocation on exception handlers defined for h_data_storage and
h_instr_storage. However we will never take relocation on exceptions for
these because they can only come from a guest, and we never take
relocation on exceptions when we transition from guest to host.

We also have a handler for hmi_exception (Hypervisor Maintenance) which
is defined in the architecture to never be delivered with relocation on,
see see v2.07 Book III-S section 6.5.

So remove the handlers, leaving a branch to self just to be double extra
paranoid.

Signed-off-by: Michael Ellerman <michael@ellerman.id.au>
Signed-off-by: Benjamin Herrenschmidt <benh@kernel.crashing.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 arch/powerpc/kernel/exceptions-64s.S |   18 +++---------------
 1 file changed, 3 insertions(+), 15 deletions(-)

--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -793,14 +793,10 @@ system_call_relon_pSeries:
 	STD_RELON_EXCEPTION_PSERIES(0x4d00, 0xd00, single_step)
 
 	. = 0x4e00
-	SET_SCRATCH0(r13)
-	EXCEPTION_PROLOG_0(PACA_EXGEN)
-	b	h_data_storage_relon_hv
+	b	.	/* Can't happen, see v2.07 Book III-S section 6.5 */
 
 	. = 0x4e20
-	SET_SCRATCH0(r13)
-	EXCEPTION_PROLOG_0(PACA_EXGEN)
-	b	h_instr_storage_relon_hv
+	b	.	/* Can't happen, see v2.07 Book III-S section 6.5 */
 
 	. = 0x4e40
 	SET_SCRATCH0(r13)
@@ -808,9 +804,7 @@ system_call_relon_pSeries:
 	b	emulation_assist_relon_hv
 
 	. = 0x4e60
-	SET_SCRATCH0(r13)
-	EXCEPTION_PROLOG_0(PACA_EXGEN)
-	b	hmi_exception_relon_hv
+	b	.	/* Can't happen, see v2.07 Book III-S section 6.5 */
 
 	. = 0x4e80
 	SET_SCRATCH0(r13)
@@ -1180,14 +1174,8 @@ tm_unavailable_common:
 __end_handlers:
 
 	/* Equivalents to the above handlers for relocation-on interrupt vectors */
-	STD_RELON_EXCEPTION_HV_OOL(0xe00, h_data_storage)
-	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe00)
-	STD_RELON_EXCEPTION_HV_OOL(0xe20, h_instr_storage)
-	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe20)
 	STD_RELON_EXCEPTION_HV_OOL(0xe40, emulation_assist)
 	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe40)
-	STD_RELON_EXCEPTION_HV_OOL(0xe60, hmi_exception)
-	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe60)
 	MASKABLE_RELON_EXCEPTION_HV_OOL(0xe80, h_doorbell)
 	KVM_HANDLER(PACA_EXGEN, EXC_HV, 0xe80)
 


