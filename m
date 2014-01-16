Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752070AbaAPECr (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:02:47 -0500
Received: from e33.co.us.ibm.com ([32.97.110.151]:57769 "EHLO
	e33.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751473AbaAPECo (ORCPT
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
Subject: [PATCH tip/core/timers 3/5] timers: Reduce future __run_timers() latency for newly emptied list
Date: Wed, 15 Jan 2014 20:02:32 -0800
Message-Id: <1389844954-5886-3-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1389844954-5886-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140116040203.GA5206@linux.vnet.ibm.com>
 <1389844954-5886-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011604-0928-0000-0000-00000574DE6D
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The __run_timers() function currently steps through the list one jiffy at
a time in order to update the timer wheel.  However, if the timer wheel
is empty, no adjustment is needed other than updating ->timer_jiffies.
Therefore, if we just emptied the timer wheel, for example, by deleting
the last timer, we should mark the timer wheel as being up to date.
This marking will reduce (and perhaps eliminate) the jiffy-stepping that
a future __run_timers() call will need to do in response to some future
timer posting or migration.  This commit therefore catches ->timer_jiffies
for this case.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/timer.c | 2 ++
 1 file changed, 2 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index eff9052001e1..1e53acb33361 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -688,6 +688,7 @@ detach_expired_timer(struct timer_list *timer, struct tvec_base *base)
 	if (!tbase_get_deferrable(timer->base))
 		base->active_timers--;
 	base->all_timers--;
+	(void)catchup_timer_jiffies(base);
 }
 
 static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
@@ -703,6 +704,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
 			base->next_timer = base->timer_jiffies;
 	}
 	base->all_timers--;
+	(void)catchup_timer_jiffies(base);
 	return 1;
 }
 
-- 
1.8.1.5

