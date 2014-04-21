Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753335AbaDUEhn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 21 Apr 2014 00:37:43 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:58804 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752079AbaDUEfQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 21 Apr 2014 00:35:16 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "Fabio M. Di Nitto" <fabbione@fabbione.net>,
        Jan Engelhardt <jengelh@inai.de>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 30/32] sparc64: Make sure %pil interrupts are enabled during hypervisor yield.
Date: Sun, 20 Apr 2014 19:13:47 -0700
Message-Id: <20140421021137.958964731@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140421021133.865086647@linuxfoundation.org>
References: <20140421021133.865086647@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 arch/sparc/kernel/process_64.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

--- a/arch/sparc/kernel/process_64.c
+++ b/arch/sparc/kernel/process_64.c
@@ -58,9 +58,12 @@ void arch_cpu_idle(void)
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
@@ -82,7 +85,6 @@ void arch_cpu_idle(void)
 			: "=&r" (pstate)
 			: "i" (PSTATE_IE));
 	}
-	local_irq_enable();
 }
 
 #ifdef CONFIG_HOTPLUG_CPU


