Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932830AbaEEMuu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 5 May 2014 08:50:50 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:41018 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S932303AbaEEMne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 5 May 2014 08:43:34 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "David S. Miller" <davem@davemloft.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 48/50] sparc64: Make sure %pil interrupts are enabled during hypervisor yield.
Date: Mon,  5 May 2014 14:43:30 +0200
Message-Id: <3f5bb90c762520fee214e7852897198e89b29630.1399292849.git.jslaby@suse.cz>
X-Mailer: git-send-email 1.9.2
In-Reply-To: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
References: <7d4f4737432af6216e86975e587331b9d8b08063.1399292849.git.jslaby@suse.cz>
In-Reply-To: <cover.1399292849.git.jslaby@suse.cz>
References: <cover.1399292849.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "David S. Miller" <davem@davemloft.net>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

[ Upstream commit cb3042d609e30e6144024801c89be3925106752b ]

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 arch/sparc/kernel/process_64.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/arch/sparc/kernel/process_64.c b/arch/sparc/kernel/process_64.c
index baebab215492..b9cc9763faf4 100644
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
1.9.2

