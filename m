Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751213AbaGAEOE (ORCPT <rfc822;w@1wt.eu>);
	Tue, 1 Jul 2014 00:14:04 -0400
Received: from e32.co.us.ibm.com ([32.97.110.150]:42773 "EHLO
	e32.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750788AbaGAEOC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 1 Jul 2014 00:14:02 -0400
Subject: [PATCH V2] powerpc/powernv: Check for IRQHAPPENED before sleeping
To: benh@kernel.crashing.org, mikey@neuling.org, mpe@ellerman.id.au
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Cc: shreyas@linux.vnet.ibm.com, svaidy@linux.vnet.ibm.com,
        linuxppc-dev@lists.ozlabs.org, linux-kernel@vger.kernel.org
Date: Tue, 01 Jul 2014 09:39:14 +0530
Message-ID: <20140701040808.6486.59805.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.16-38-g167d
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14070104-0928-0000-0000-00000316BC5B
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit 8d6f7c5a: "powerpc/powernv: Make it possible to skip the IRQHAPPENED
check in power7_nap()" added code that prevents cpus from checking for pending
interrupts just before entering sleep state, which is wrong. A cpu cannot enter
any idle state with pending interrupts.

Possible consequences of a cpu entering an idle state without checking for pending
interrupts could be a device timeout or a more serious consequence in case of
Power8 would be if doorbell IPIs are delivered when cpus have interrupts soft
disabled. Precisely the state that the cpus are in just before entering an
idle state on PowerPC.

Interrupts delivered during soft disabled state are replayed when the interrupts
are enabled again. Hence since a cpu goes to sleep with interrupts enabled
again, it will receive any pending interrupts. However doorbell IPIs are not
replayed even when the interrupts are re-enabled since they are edge triggered.Hence
not checking for pending interrupts just before going to sleep state would mean
that we will never take the doorbell IPI if it was delivered during the soft
disabled state, unless some other interrupt wakes us up.This could result in the
cpu that sent the doorbell IPI complaining that the sleeping cpu is stuck.

This patch fixes these issues by ensuring that cpus check for pending interrupts
just before entering any idle state as long as they are not in the path of split
core operations.

Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
Acked-by: Michael Neuling <mikey@neuling.org>
---
Changes from V1: Modified the changelog to add the details of the problem
that this patch fixes.

 arch/powerpc/kernel/idle_power7.S |    2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/arch/powerpc/kernel/idle_power7.S b/arch/powerpc/kernel/idle_power7.S
index 2480256..5cf3d36 100644
--- a/arch/powerpc/kernel/idle_power7.S
+++ b/arch/powerpc/kernel/idle_power7.S
@@ -131,7 +131,7 @@ _GLOBAL(power7_nap)
 
 _GLOBAL(power7_sleep)
 	li	r3,1
-	li	r4,0
+	li	r4,1
 	b	power7_powersave_common
 	/* No return */
 

