Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751780AbaAOFV3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 00:21:29 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:48241 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751579AbaAOFU5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 00:20:57 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, niv@us.ibm.com, tglx@linutronix.de,
        peterz@infradead.org, rostedt@goodmis.org, dhowells@redhat.com,
        edumazet@google.com, darren@dvhart.com, fweisbec@gmail.com,
        oleg@redhat.com, sbw@mit.edu,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/timers 1/4] timers: Track total number of timers in list
Date: Tue, 14 Jan 2014 21:20:45 -0800
Message-Id: <1389763248-31297-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <20140115051939.GA31164@linux.vnet.ibm.com>
References: <20140115051939.GA31164@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011505-1542-0000-0000-0000053E6071
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

Currently, the tvec_base structure's ->active_timers field tracks only
the non-deferrable timers, which means that even if ->active_timers is
zero, there might well be non-deferrable timers in the list.  This commit
therefore adds an ->all_timers field to track all the timers, whether
deferrable or not.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/timer.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/kernel/timer.c b/kernel/timer.c
index 6582b82fa966..2245b7374c3d 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -81,6 +81,7 @@ struct tvec_base {
 	unsigned long timer_jiffies;
 	unsigned long next_timer;
 	unsigned long active_timers;
+	unsigned long all_timers;
 	struct tvec_root tv1;
 	struct tvec tv2;
 	struct tvec tv3;
@@ -392,6 +393,7 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 			base->next_timer = timer->expires;
 		base->active_timers++;
 	}
+	base->all_timers++;
 }
 
 #ifdef CONFIG_TIMER_STATS
@@ -671,6 +673,7 @@ detach_expired_timer(struct timer_list *timer, struct tvec_base *base)
 	detach_timer(timer, true);
 	if (!tbase_get_deferrable(timer->base))
 		base->active_timers--;
+	base->all_timers--;
 }
 
 static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
@@ -685,6 +688,7 @@ static int detach_if_pending(struct timer_list *timer, struct tvec_base *base,
 		if (timer->expires == base->next_timer)
 			base->next_timer = base->timer_jiffies;
 	}
+	base->all_timers--;
 	return 1;
 }
 
@@ -1560,6 +1564,7 @@ static int init_timers_cpu(int cpu)
 	base->timer_jiffies = jiffies;
 	base->next_timer = base->timer_jiffies;
 	base->active_timers = 0;
+	base->all_timers = 0;
 	return 0;
 }
 
-- 
1.8.1.5

