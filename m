Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752881AbaANEPp (ORCPT <rfc822;w@1wt.eu>);
	Mon, 13 Jan 2014 23:15:45 -0500
Received: from e36.co.us.ibm.com ([32.97.110.154]:48643 "EHLO
	e36.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752676AbaANEP3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 13 Jan 2014 23:15:29 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/timers 3/3] timers: Reduce future __run_timers() latency for first add to empty list
Date: Mon, 13 Jan 2014 20:15:19 -0800
Message-Id: <1389672919-14621-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1389672919-14621-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140114041449.GA13934@linux.vnet.ibm.com>
 <1389672919-14621-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011404-3532-0000-0000-000004B7A825
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __run_timers() function currently steps through the list one jiffy at
a time in order to update the timer wheel.  However, if the timer wheel
is empty, no adjustment is needed other than updating ->timer_jiffies.
Therefore, just before we add a timer to an empty timer wheel, we should
mark the timer wheel as being up to date.  This marking will reduce (and
perhaps eliminate) the jiffy-stepping that a future __run_timers() call
will need to do in response to some future timer posting or migration.
This commit therefore updates ->timer_jiffies for this case.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/timer.c | 1 +
 1 file changed, 1 insertion(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 2b2e235ea7f1..e539dbf5b9c5 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -745,6 +745,7 @@ __mod_timer(struct timer_list *timer, unsigned long expires,
 
 	base = lock_timer_base(timer, &flags);
 
+	(void)catchup_timer_jiffies(base);
 	ret = detach_if_pending(timer, base, false);
 	if (!ret && pending_only)
 		goto out_unlock;
-- 
1.8.1.5

