Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932529Ab3KFOxB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Nov 2013 09:53:01 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.226]:34091 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932493Ab3KFOw7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Nov 2013 09:52:59 -0500
Message-Id: <20131106145257.422854511@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 06 Nov 2013 09:50:44 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Frederic Weisbecker <fweisbec@gmail.com>,
        Andrew Morton <akpm@linux-foundation.org>,
        "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Subject: [for-next][PATCH 3/8] rcu: Do not trace rcu_is_watching() functions
References: <20131106145041.904349372@goodmis.org>
Content-Disposition: inline; filename=0009-rcu-Do-not-trace-rcu_is_watching-functions.patch
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Steven Rostedt <rostedt@goodmis.org>

As perf uses the rcu_read_lock() primitives for recording into its
ring buffer, perf tracing can not be called when RCU in inactive.
With the perf function tracing, there are functions that can be
traced when RCU is not active, and perf must not have its function
callback called when this is the case.

Luckily, Paul McKenney has created a way to detect when RCU is
active or not with the rcu_is_watching() function. Unfortunately,
this function can also be traced, and if that happens it can cause
a bit of overhead for the perf function calls that do the check.
Recursion protection prevents anything bad from happening, but
there is a bit of added overhead for every function being traced that
must detect that the rcu_is_watching() is also being traced.

As rcu_is_watching() is a helper routine and not part of the
critical logic in RCU, it does not need to be traced in order to
debug RCU itself. Add the "notrace" annotation to all the rcu_is_watching()
calls such that we never trace it.

Link: http://lkml.kernel.org/r/20131104202736.72dd8e45@gandalf.local.home

Acked-by: Paul E. McKenney <paulmck@linux.vnet.ibm.com>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/rcutiny.c | 2 +-
 kernel/rcutree.c | 4 ++--
 2 files changed, 3 insertions(+), 3 deletions(-)

diff --git a/kernel/rcutiny.c b/kernel/rcutiny.c
index 0fa061d..590c8a8 100644
--- a/kernel/rcutiny.c
+++ b/kernel/rcutiny.c
@@ -179,7 +179,7 @@ EXPORT_SYMBOL_GPL(rcu_irq_enter);
 /*
  * Test whether RCU thinks that the current CPU is idle.
  */
-bool __rcu_is_watching(void)
+bool notrace __rcu_is_watching(void)
 {
 	return rcu_dynticks_nesting;
 }
diff --git a/kernel/rcutree.c b/kernel/rcutree.c
index 981d0c1..499bb2b 100644
--- a/kernel/rcutree.c
+++ b/kernel/rcutree.c
@@ -662,7 +662,7 @@ void rcu_nmi_exit(void)
  * rcu_is_watching(), the caller of __rcu_is_watching() must have at
  * least disabled preemption.
  */
-bool __rcu_is_watching(void)
+bool notrace __rcu_is_watching(void)
 {
 	return atomic_read(this_cpu_ptr(&rcu_dynticks.dynticks)) & 0x1;
 }
@@ -673,7 +673,7 @@ bool __rcu_is_watching(void)
  * If the current CPU is in its idle loop and is neither in an interrupt
  * or NMI handler, return true.
  */
-bool rcu_is_watching(void)
+bool notrace rcu_is_watching(void)
 {
 	int ret;
 
-- 
1.8.4.rc3


