Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752839AbbAUKKC (ORCPT <rfc822;w@1wt.eu>);
	Wed, 21 Jan 2015 05:10:02 -0500
Received: from e34.co.us.ibm.com ([32.97.110.152]:38706 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752940AbbAUKIb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 21 Jan 2015 05:08:31 -0500
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH RFC tip/core/rcu 5/7] rcu: Avoid clobbering early boot callbacks
Date: Wed, 21 Jan 2015 02:08:18 -0800
Message-Id: <1421834900-23987-5-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20150121100750.GA22883@linux.vnet.ibm.com>
 <1421834900-23987-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 15012110-0017-0000-0000-0000081BA328
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

When a CPU comes online, it initializes its callback list.  This
is a bad thing if this is the first time that the CPU has come
online and if that CPU has early boot callbacks.  This commit therefore
avoid initializing the callback list if there are callbacks present,
in which case the initial call_rcu() did the initialization for us.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
---
 kernel/rcu/tree.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/rcu/tree.c b/kernel/rcu/tree.c
index ff2e42ebb64b..02fa29a4d104 100644
--- a/kernel/rcu/tree.c
+++ b/kernel/rcu/tree.c
@@ -3584,7 +3584,8 @@ rcu_init_percpu_data(int cpu, struct rcu_state *rsp)
 	rdp->qlen_last_fqs_check = 0;
 	rdp->n_force_qs_snap = rsp->n_force_qs;
 	rdp->blimit = blimit;
-	init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
+	if (!rdp->nxtlist)
+		init_callback_list(rdp);  /* Re-enable callbacks on this CPU. */
 	rdp->dynticks->dynticks_nesting = DYNTICK_TASK_EXIT_IDLE;
 	rcu_sysidle_init_percpu_data(rdp->dynticks);
 	atomic_set(&rdp->dynticks->dynticks,
-- 
1.8.1.5

