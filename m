Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754997AbaBDTNU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Feb 2014 14:13:20 -0500
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.225]:7326 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1754161AbaBDTNS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Feb 2014 14:13:18 -0500
Date: Tue, 4 Feb 2014 14:13:15 -0500
From: Steven Rostedt <rostedt@goodmis.org>
To: LKML <linux-kernel@vger.kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Thomas Gleixner <tglx@linutronix.de>, Ingo Molnar <mingo@kernel.org>,
        "H. Peter Anvin" <hpa@linux.intel.com>
Subject: [PATCH] x86: Use preempt_disable_notrace() in cycles_2_ns()
Message-ID: <20140204141315.2a968a72@gandalf.local.home>
X-Mailer: Claws Mail 3.9.3 (GTK+ 2.24.22; x86_64-pc-linux-gnu)
MIME-Version: 1.0
Content-Type: text/plain; charset=US-ASCII
Content-Transfer-Encoding: 7bit
X-RR-Connecting-IP: 107.14.168.118:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When debug preempt is enabled, preempt_disable() can be traced by
function and function graph tracing.

There's a place in the function graph tracer that calls trace_clock()
which eventually calls cycles_2_ns() outside of the recursion
protection. When cycles_2_ns() calls preempt_disable() it gets traced
and the graph tracer will go into a recursive loop causing a crash or
worse, a triple fault.

Simple fix is to use preempt_disable_notrace() in cycles_2_ns, which
makes sense because the preempt_disable() tracing may use that code
too, and it tracing it, even with recursion protection is rather
pointless.

Signed-off-by: Steven Rostedt <rostedt@goodmis.org>

diff --git a/arch/x86/kernel/tsc.c b/arch/x86/kernel/tsc.c
index 19e5adb..acb3b60 100644
--- a/arch/x86/kernel/tsc.c
+++ b/arch/x86/kernel/tsc.c
@@ -209,7 +209,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 	 * dance when its actually needed.
 	 */
 
-	preempt_disable();
+	preempt_disable_notrace();
 	data = this_cpu_read(cyc2ns.head);
 	tail = this_cpu_read(cyc2ns.tail);
 
@@ -229,7 +229,7 @@ static inline unsigned long long cycles_2_ns(unsigned long long cyc)
 		if (!--data->__count)
 			this_cpu_write(cyc2ns.tail, data);
 	}
-	preempt_enable();
+	preempt_enable_notrace();
 
 	return ns;
 }
