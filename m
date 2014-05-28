Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754030AbaE1EoO (ORCPT <rfc822;w@1wt.eu>);
	Wed, 28 May 2014 00:44:14 -0400
Received: from e38.co.us.ibm.com ([32.97.110.159]:48873 "EHLO
	e38.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753521AbaE1EoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 28 May 2014 00:44:11 -0400
Subject: [PATCH 6/6] ppc,
 book3s: Go back to same idle state after handling machine check
 interrupt
To: benh@kernel.crashing.org, linux-kernel@vger.kernel.org,
        svaidyan@in.ibm.com, paulus@samba.org,
        srivatsa.bhat@linux.vnet.ibm.com, linuxppc-dev@lists.ozlabs.org
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Date: Wed, 28 May 2014 10:09:39 +0530
Message-ID: <20140528043939.15676.57491.stgit@preeti.in.ibm.com>
In-Reply-To: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
References: <20140528043703.15676.58580.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14052804-1344-0000-0000-000001D646D2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>

Now that the support for fast sleep is present, threads could have woken up
from fast sleep on getting a machine check interrupt. Hence add code to allow
threads to go back to the idle state they woke up from after handling the
interrupt. Today they go back to nap by default.

Signed-off-by: Srivatsa S. Bhat <srivatsa.bhat@linux.vnet.ibm.com>
[ Changelog added by <preeti@linux.vnet.ibm.com> ]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 arch/powerpc/kernel/exceptions-64s.S |   21 +++++++++++++++------
 arch/powerpc/kernel/idle_power7.S    |    2 +-
 2 files changed, 16 insertions(+), 7 deletions(-)

diff --git a/arch/powerpc/kernel/exceptions-64s.S b/arch/powerpc/kernel/exceptions-64s.S
index b4bf464..94cee3c 100644
--- a/arch/powerpc/kernel/exceptions-64s.S
+++ b/arch/powerpc/kernel/exceptions-64s.S
@@ -1396,15 +1396,16 @@ machine_check_handle_early:
 	 * of the following is true:
 	 * a. thread wasn't in power saving mode
 	 * b. thread was in power saving mode with no state loss or
-	 *    supervisor state loss
+	 *    supervisor state loss or hypervisor state loss (fastsleep)
 	 *
-	 * Go back to nap again if (b) is true.
+	 * Go back to nap or fastsleep again if (b) is true.
 	 */
 	rlwinm.	r11,r12,47-31,30,31	/* Was it in power saving mode? */
 	beq	4f			/* No, it wasn;t */
-	/* Thread was in power saving mode. Go back to nap again. */
-	cmpwi	r11,2
-	bne	3f
+	/* Thread was in power saving mode. Go back to the same state again. */
+	cmpwi	cr1,r11,2
+	blt	cr1,3f
+7:
 	/* Supervisor state loss */
 	li	r0,1
 	stb	r0,PACA_NAPSTATELOST(r13)
@@ -1412,7 +1413,15 @@ machine_check_handle_early:
 	MACHINE_CHECK_HANDLER_WINDUP
 	GET_PACA(r13)
 	ld	r1,PACAR1(r13)
-	b	.power7_enter_nap_mode
+	/* We need to pass the idle state in r3: 0 -> nap, 1 -> sleep */
+	bgt	cr1,8f
+	li	r3,0
+	b	.power7_enter_idle
+	/* No return */
+
+8:	li	r3,1 /* Pass 1 in r3 to request sleep in power7_enter_idle */
+	b	.power7_enter_idle
+	/* No return */
 4:
 #endif
 	/*
diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index c3ab869..e13e21b 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -95,7 +95,7 @@ _GLOBAL(power7_powersave_common)
 	std	r9,_MSR(r1)
 	std	r1,PACAR1(r13)
 
-_GLOBAL(power7_enter_nap_mode)
+_GLOBAL(power7_enter_idle)
 #ifdef CONFIG_KVM_BOOK3S_HV_POSSIBLE
 	/* Tell KVM we're napping */
 	li	r4,KVM_HWTHREAD_IN_NAP

