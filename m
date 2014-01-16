Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752135AbaAPECw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 23:02:52 -0500
Received: from e35.co.us.ibm.com ([32.97.110.153]:52887 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751480AbaAPECo (ORCPT
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
Subject: [PATCH tip/core/timers 5/5] timers: Make internal_add_timer() update ->next_timer if ->active_timers == 0
Date: Wed, 15 Jan 2014 20:02:34 -0800
Message-Id: <1389844954-5886-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1389844954-5886-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140116040203.GA5206@linux.vnet.ibm.com>
 <1389844954-5886-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14011604-6688-0000-0000-000005932784
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Oleg Nesterov <oleg@redhat.com>

The internal_add_timer() function updates base->next_timer only if
timer->expires < base->next_timer. This is correct, but it also makes
sense to do the same if we add the first non-deferrable timer.

Signed-off-by: Oleg Nesterov <oleg@redhat.com>
Reviewed-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/timer.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/timer.c b/kernel/timer.c
index b9cc28271646..e74685309b14 100644
--- a/kernel/timer.c
+++ b/kernel/timer.c
@@ -404,9 +404,9 @@ static void internal_add_timer(struct tvec_base *base, struct timer_list *timer)
 	 * Update base->active_timers and base->next_timer
 	 */
 	if (!tbase_get_deferrable(timer->base)) {
-		if (time_before(timer->expires, base->next_timer))
+		if (!base->active_timers++ ||
+		    time_before(timer->expires, base->next_timer))
 			base->next_timer = timer->expires;
-		base->active_timers++;
 	}
 	base->all_timers++;
 }
-- 
1.8.1.5

