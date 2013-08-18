Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753391Ab3HRBiI (ORCPT <rfc822;w@1wt.eu>);
	Sat, 17 Aug 2013 21:38:08 -0400
Received: from e31.co.us.ibm.com ([32.97.110.149]:37703 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752489Ab3HRBiF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 17 Aug 2013 21:38:05 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 01/11] rcu: Expedite grace periods during suspend/resume
Date: Sat, 17 Aug 2013 18:37:46 -0700
Message-Id: <1376789876-27594-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130818013735.GA27234@linux.vnet.ibm.com>
References: <20130818013735.GA27234@linux.vnet.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13081801-7282-0000-0000-00001A8C3A6E
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
a factor of four, which can result in long suspend and resume times.
Thus, this commit temporarily switches to expedited grace periods when
suspending the box and return to normal settings when resuming.

[ paulmck: This also papers over an audio/irq bug, but hopefully that will
  be fixed soon. ]

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcutree.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 338f1d1..69e4792 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -54,6 +54,7 @@
 #include <linux/stop_machine.h>
 #include <linux/random.h>
 #include <linux/ftrace_event.h>
+#include <linux/suspend.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -3032,6 +3033,22 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+static int rcu_pm_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+		rcu_expedited = 1;
+		break;
+	case PM_POST_RESTORE:
+		rcu_expedited = 0;
+		break;
+	default:
+		break;
+	}
+	return NOTIFY_OK;
+}
+
 /*
  * Spawn the kthread that handles this RCU flavor's grace periods.
  */
@@ -3273,6 +3290,7 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
+	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
-- 
1.8.1.5

