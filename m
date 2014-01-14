Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752823AbaANEP3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:15:29 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:50522 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752608AbaANEP1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:15:27 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/timers 1/3] timers: Reduce __run_timers() latency for empty list
Date: Mon, 13 Jan 2014 20:15:17 -0800
Message-Id: <1389672919-14621-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140114041449.GA13934@linux.vnet.ibm.com>
References: <20140114041449.GA13934@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011404-8236-0000-0000-00000604DD28
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __run_timers() function currently steps through the list one jiffy at
a time in order to update the timer wheel.  However, if the timer wheel
is empty, no adjustment is needed other than updating ->timer_jiffies.
In this case, which is likely to be common for NO_HZ_FULL kernels, the
kernel currently incurs a large latency for no good reason.  This commit
therefore short-circuits this case.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/timer.c | 15 +++++++++++++++
 1 file changed, 15 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6582b82fa966..21849275828f 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -337,6 +337,17 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
 }
 EXPORT_SYMBOL_GPL(set_timer_slack);
 
+static bool catchup_timer_jiffies(struct tvec_base *base)
+{
+#ifdef CONFIG_NO_HZ_FULL
+	if (!base->active_timers) {
+		base->timer_jiffies = jiffies;
+		return 1;
+	}
+#endif /* #ifdef CONFIG_NO_HZ_FULL */
+	return 0;
+}
+
 static void
 __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
@@ -1146,6 +1157,10 @@ static inline void __run_timers(struct tvec_base *base)
 	struct timer_list *timer;
 
 	spin_lock_irq(&base->lock);
+	if (catchup_timer_jiffies(base)) {
+		spin_unlock_irq(&base->lock);
+		return;
+	}
 	while (time_after_eq(jiffies, base->timer_jiffies)) {
 		struct list_head work_list;
 		struct list_head *head = &work_list;
-- 
1.8.1.5

