Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754665Ab3GAQE6 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Jul 2013 12:04:58 -0400
Received: from multi.imgtec.com ([194.200.65.239]:10434 "EHLO multi.imgtec.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754505Ab3GAQE4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Jul 2013 12:04:56 -0400
From: James Hogan <james.hogan@imgtec.com>
To: <linux-kernel@vger.kernel.org>
CC: Thomas Gleixner <tglx@linutronix.de>, James Hogan <james.hogan@imgtec.com>,
        "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Subject: [PATCH 3/5] metag: smp: don't spin waiting for CPU to start
Date: Mon, 1 Jul 2013 17:04:17 +0100
Message-ID: <1372694659-30176-4-git-send-email-james.hogan@imgtec.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
References: <1372694659-30176-1-git-send-email-james.hogan@imgtec.com>
MIME-Version: 1.0
Content-Type: text/plain
X-SEF-Processed: 7_3_0_01192__2013_07_01_17_04_54
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use a completion to block until a secondary CPU has started up, like ARM
do, instead of a loop of udelays.

On Meta, SMP is really SMT, with each "CPU" being a different hardware
thread on the same Meta processor core, so as well as being more
efficient and latency friendly, using a completion prevents the bogomips
of the secondary CPU from being drastically skewed every time by the
execution of the tight in-cache udelay loop on the other CPU.

Signed-off-by: James Hogan <james.hogan@imgtec.com>
Cc: "Srivatsa S. Bhat" <srivatsa.bhat@linux.vnet.ibm.com>
Cc: Thomas Gleixner <tglx@linutronix.de>
---
 arch/metag/kernel/smp.c | 16 ++++++----------
 1 file changed, 6 insertions(+), 10 deletions(-)

diff --git a/arch/metag/kernel/smp.c b/arch/metag/kernel/smp.c
index 09979f2..e413875 100644
--- a/arch/metag/kernel/smp.c
+++ b/arch/metag/kernel/smp.c
@@ -8,6 +8,7 @@
  * published by the Free Software Foundation.
  */
 #include <linux/atomic.h>
+#include <linux/completion.h>
 #include <linux/delay.h>
 #include <linux/init.h>
 #include <linux/spinlock.h>
@@ -62,6 +63,8 @@ static DEFINE_PER_CPU(struct ipi_data, ipi_data) = {
 
 static DEFINE_SPINLOCK(boot_lock);
 
+static DECLARE_COMPLETION(cpu_running);
+
 /*
  * "thread" is assumed to be a valid Meta hardware thread ID.
  */
@@ -235,20 +238,12 @@ int __cpuinit __cpu_up(unsigned int cpu, struct task_struct *idle)
 	 */
 	ret = boot_secondary(thread, idle);
 	if (ret == 0) {
-		unsigned long timeout;
-
 		/*
 		 * CPU was successfully started, wait for it
 		 * to come online or time out.
 		 */
-		timeout = jiffies + HZ;
-		while (time_before(jiffies, timeout)) {
-			if (cpu_online(cpu))
-				break;
-
-			udelay(10);
-			barrier();
-		}
+		wait_for_completion_timeout(&cpu_running,
+					    msecs_to_jiffies(1000));
 
 		if (!cpu_online(cpu))
 			ret = -EIO;
@@ -391,6 +386,7 @@ asmlinkage void secondary_start_kernel(void)
 	 * OK, now it's safe to let the boot CPU continue
 	 */
 	set_cpu_online(cpu, true);
+	complete(&cpu_running);
 
 	/*
 	 * Enable local interrupts.
-- 
1.8.1.2


