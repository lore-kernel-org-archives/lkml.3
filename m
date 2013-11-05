Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753812Ab3KEB1l (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 20:27:41 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:44433 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1750798Ab3KEB1k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 20:27:40 -0500
Date: Mon, 4 Nov 2013 20:27:36 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: "Paul E. McKenney" <paulmck@linux.vnet.ibm.com>
Cc: LKML <linux-kernel@vger.kernel.org>
Subject: [PATCH] rcu: Do not trace rcu_is_watching() functions
Message-ID: <20131104202736.72dd8e45@gandalf.local.home>
X-Mailer: Claws Mail 3.9.2 (GTK+ 2.24.20; x86_64-pc-linux-gnu)
Mime-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


Paul,

As I added the rcu_is_watching() to the ftrace code to prevent perf
from tracing functions where RCU is not watching, I noticed that the
rcu_is_watching() functions can themselves be traced. I would say this
is a helper function and not something that we need to trace, as it can
cause a slowdown in function tracing (any recursion is detected, so it
only affects performance).

I marked the functions with notrace. You can take this patch and push
it for 3.13 or I can take it if you give me an "Acked-by". As it only
affects performance and does not crash the code it's not a must have in
my tree.

If you take it, I can write up a better change log too.

-- Steve

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

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
 
