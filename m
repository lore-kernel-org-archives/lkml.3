Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752627AbaH1S14 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 14:27:56 -0400
Received: from e34.co.us.ibm.com ([32.97.110.152]:50698 "EHLO
	e34.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752056AbaH1S0p (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 14:26:45 -0400
From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
To: linux-kernel@vger.kernel.org
Cc: mingo@kernel.org, laijs@cn.fujitsu.com, dipankar@in.ibm.com,
        akpm@linux-foundation.org, mathieu.desnoyers@efficios.com,
        josh@joshtriplett.org, tglx@linutronix.de, peterz@infradead.org,
        rostedt@goodmis.org, dhowells@redhat.com, edumazet@google.com,
        dvhart@linux.intel.com, fweisbec@gmail.com, oleg@redhat.com,
        bobby.prani@gmail.com, "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [PATCH tip/core/rcu 12/15] rcu: Make TINY_RCU tinier by putting error checks under #ifdef
Date: Thu, 28 Aug 2014 11:26:31 -0700
Message-Id: <1409250394-25159-12-git-send-email-paulmck@linux.vnet.ibm.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
References: <20140828182614.GA23877@linux.vnet.ibm.com>
 <1409250394-25159-1-git-send-email-paulmck@linux.vnet.ibm.com>
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14082818-1542-0000-0000-0000045F4E07
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>

The rcu_idle_enter_common() and rcu_idle_exit_common() functions contain
error checks that have to the best of my knowledge have never triggered
over the past several years.  These are nevertheless valuable when
creating new architectures or doing other low-level changes, so the
checks should not be deleted.  This commit instead places these checks
under #ifdef CONFIG_RCU_TRACE so that they are executed only when
specifically requested.

The savings are significant:

	Before:

	   text    data     bss     dec     hex filename
	   1749      39       0    1788     6fc /tmp/b/kernel/rcu/tiny.o
	    632     152       0     784     310 /tmp/b/kernel/rcu/update.o
				   ----
				   2572

	After:

	   text    data     bss     dec     hex filename
	   1281      37       0    1318     526 /tmp/b/kernel/rcu/tiny.o
	    632     152       0     784     310 /tmp/b/kernel/rcu/update.o
				   ----
				   2102

This amounts to 470 bytes, or 18% of the original.

Switched from #ifdef to IS_ENABLED() on Josh Triplett's advice.

Signed-off-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Reviewed-by: Josh Triplett <josh@joshtriplett.org>
---
 kernel/rcu/tiny.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/rcu/tiny.c b/kernel/rcu/tiny.c
index 6bd785c34add..4a55a2416e3c 100644
--- a/kernel/rcu/tiny.c
+++ b/kernel/rcu/tiny.c
@@ -62,7 +62,7 @@ static void rcu_idle_enter_common(long long newval)
 	}
 	RCU_TRACE(trace_rcu_dyntick(TPS("Start"),
 				    rcu_dynticks_nesting, newval));
-	if (!is_idle_task(current)) {
+	if (IS_ENABLED(CONFIG_RCU_TRACE) && !is_idle_task(current)) {
 		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick(TPS("Entry error: not idle task"),
@@ -123,7 +123,7 @@ static void rcu_idle_exit_common(long long oldval)
 		return;
 	}
 	RCU_TRACE(trace_rcu_dyntick(TPS("End"), oldval, rcu_dynticks_nesting));
-	if (!is_idle_task(current)) {
+	if (IS_ENABLED(CONFIG_RCU_TRACE) && !is_idle_task(current)) {
 		struct task_struct *idle __maybe_unused = idle_task(smp_processor_id());
 
 		RCU_TRACE(trace_rcu_dyntick(TPS("Exit error: not idle task"),
-- 
1.8.1.5

