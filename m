Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752981AbaKFWst (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:48:49 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59130 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753291AbaKFWoS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:44:18 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "David S. Miller" <davem@davemloft.net>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 028/162] sparc64: Do not disable interrupts in nmi_cpu_busy()
Date: Thu,  6 Nov 2014 14:34:52 -0800
Message-Id: <1415313426-9622-29-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "David S. Miller" <davem@davemloft.net>

[ Upstream commit 58556104e9cd0107a7a8d2692cf04ef31669f6e4 ]

nmi_cpu_busy() is a SMP function call that just makes sure that all of the
cpus are spinning using cpu cycles while the NMI test runs.

It does not need to disable IRQs because we just care about NMIs executing
which will even with 'normal' IRQs disabled.

It is not legal to enable hard IRQs in a SMP cross call, in fact this bug
triggers the BUG check in irq_work_run_list():

	BUG_ON(!irqs_disabled());

Because now irq_work_run() is invoked from the tail of
generic_smp_call_function_single_interrupt().

Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 arch/sparc/kernel/nmi.c | 1 -
 1 file changed, 1 deletion(-)

diff --git a/arch/sparc/kernel/nmi.c b/arch/sparc/kernel/nmi.c
index 6479256..fce8ab1 100644
--- a/arch/sparc/kernel/nmi.c
+++ b/arch/sparc/kernel/nmi.c
@@ -141,7 +141,6 @@ static inline unsigned int get_nmi_count(int cpu)
 
 static __init void nmi_cpu_busy(void *data)
 {
-	local_irq_enable_in_hardirq();
 	while (endflag == 0)
 		mb();
 }
-- 
1.9.1

