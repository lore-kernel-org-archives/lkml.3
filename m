Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751906Ab3HTCmY (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 Aug 2013 22:42:24 -0400
Received: from e33.co.us.ibm.com ([32.97.110.151]:39614 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751810Ab3HTCmX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 Aug 2013 22:42:23 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@elte.hu, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@polymtl.ca,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        sbw@mit.edu, Borislav Petkov <bp@alien8.de>,
        Borislav Petkov <bp@suse.de>,
        =?UTF-8?q?Bj=C3=B8rn=20Mork?= <bjorn@mork.no>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 1/9] rcu: Expedite grace periods during suspend/resume
Date: Mon, 19 Aug 2013 19:42:06 -0700
Message-Id: <1376966534-30775-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20130820024148.GA30283@linux.vnet.ibm.com>
References: <20130820024148.GA30283@linux.vnet.ibm.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13082002-2398-0000-0000-000001A46F16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Borislav Petkov <bp@alien8.de>

CONFIG_RCU_FAST_NO_HZ can increase grace-period durations by up to
a factor of four, which can result in long suspend and resume times.
Thus, this commit temporarily switches to expedited grace periods when
suspending the box and return to normal settings when resuming.  Similar
logic is applied to hibernation.

Because expedited grace periods are of dubious benefit on very large
systems, so this commit restricts their automated use during suspend
and resume to systems of 256 or fewer CPUs.  (Some day a number of
Linux-kernel facilities, including RCU's expedited grace periods,
will be more scalable, but I need to see bug reports first.)

[ paulmck: This also papers over an audio/irq bug, but hopefully that will
  be fixed soon. ]

Signed-off-by: Borislav Petkov <bp@suse.de>
Signed-off-by: Bjørn Mork <bjorn@mork.no>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcutree.c | 21 +++++++++++++++++++++
 1 file changed, 21 insertions(+)

diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 338f1d1..a7bf517 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -54,6 +54,7 @@
 #include <linux/stop_machine.h>
 #include <linux/random.h>
 #include <linux/ftrace_event.h>
+#include <linux/suspend.h>
 
 #include "rcutree.h"
 #include <trace/events/rcu.h>
@@ -3032,6 +3033,25 @@ static int rcu_cpu_notify(struct notifier_block *self,
 	return NOTIFY_OK;
 }
 
+static int rcu_pm_notify(struct notifier_block *self,
+			 unsigned long action, void *hcpu)
+{
+	switch (action) {
+	case PM_HIBERNATION_PREPARE:
+	case PM_SUSPEND_PREPARE:
+		if (nr_cpu_ids <= 256) /* Expediting bad for large systems. */
+			rcu_expedited = 1;
+		break;
+	case PM_POST_HIBERNATION:
+	case PM_POST_SUSPEND:
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
@@ -3273,6 +3293,7 @@ void __init rcu_init(void)
 	 * or the scheduler are operational.
 	 */
 	cpu_notifier(rcu_cpu_notify, 0);
+	pm_notifier(rcu_pm_notify, 0);
 	for_each_online_cpu(cpu)
 		rcu_cpu_notify(NULL, CPU_UP_PREPARE, (void *)(long)cpu);
 }
-- 
1.8.1.5

