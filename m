Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaDPKei (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Apr 2014 06:34:38 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51824 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755436AbaDPKdJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Apr 2014 06:33:09 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 43/46] sparc64: Make sure %pil interrupts are enabled during hypervisor yield.
Date: Wed, 16 Apr 2014 11:31:59 +0100
Message-Id: <1397644322-13905-44-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
References: <1397644322-13905-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

commit cb3042d609e30e6144024801c89be3925106752b upstream.

In arch_cpu_idle() we must enable %pil based interrupts before
potentially invoking the hypervisor cpu yield call.

As per the Hypervisor API documentation for cpu_yield:

	Interrupts which are blocked by some mechanism other that
	pstate.ie (for example %pil) are not guaranteed to cause
	a return from this service.

It seems that only first generation Niagara chips are hit by this
bug.  My best guess is that later chips implement this in hardware
and wake up anyways from %pil events, whereas in first generation
chips the yield is implemented completely in hypervisor code and
requires %pil to be enabled in order to wake properly from this
call.

Fixes: 87fa05aeb3a5 ("sparc: Use generic idle loop")
Reported-by: Fabio M. Di Nitto <fabbione@fabbione.net>
Reported-by: Jan Engelhardt <jengelh@inai.de>
Tested-by: Jan Engelhardt <jengelh@inai.de>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 arch/sparc/kernel/process_64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index baebab2..b9cc976 100644
--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -57,9 +57,12 @@ void arch_cpu_idle(void)
 {
 	if (tlb_type != hypervisor) {
 		touch_nmi_watchdog();
+		local_irq_enable();
 	} else {
 		unsigned long pstate;
 
+		local_irq_enable();
+
                 /* The sun4v sleeping code requires that we have PSTATE.IE cleared over
                  * the cpu sleep hypervisor call.
                  */
@@ -81,7 +84,6 @@ void arch_cpu_idle(void)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 	}
-	local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU
-- 
1.9.1

