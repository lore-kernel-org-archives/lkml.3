Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752179AbaAPECz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:02:55 -0500
Received: from e31.co.us.ibm.com ([32.97.110.149]:39110 "EHLO
	e31.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751511AbaAPECo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 23:02:44 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/timers 2/5] timers: Reduce __run_timers() latency for empty list
Date: Wed, 15 Jan 2014 20:02:31 -0800
Message-Id: <1389844954-5886-2-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1389844954-5886-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140116040203.GA5206@linux.vnet.ibm.com>
 <1389844954-5886-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011604-8236-0000-0000-0000061FC355
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
 kernel/timer.c | 18 ++++++++++++++++++
 1 file changed, 18 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 2245b7374c3d..eff9052001e1 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -338,6 +338,20 @@ void set_timer_slack(struct timer_list *timer, int slack_hz)
 }
 EXPORT_SYMBOL_GPL(set_timer_slack);
 
+/*
+ * If the list is empty, catch up ->timer_jiffies to the current time.
+ * The caller must hold the tvec_base lock.  Returns true if the list
+ * was empty and therefore ->timer_jiffies was updated.
+ */
+static bool catchup_timer_jiffies(struct tvec_base *base)
+{
+	if (!base->all_timers) {
+		base->timer_jiffies = jiffies;
+		return true;
+	}
+	return false;
+}
+
 static void
 __internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 {
@@ -1150,6 +1164,10 @@ static inline void __run_timers(struct tvec_base *base)
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

