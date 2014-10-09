Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754956AbaJIBLY (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 21:11:24 -0400
Received: from cdptpa-outbound-snat.email.rr.com ([107.14.166.227]:27083 "EHLO
	cdptpa-oedge-vip.email.rr.com" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1752989AbaJIBLF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 21:11:05 -0400
Message-Id: <20141009011057.177972498@goodmis.org>
User-Agent: quilt/0.61-1
Date: Wed, 08 Oct 2014 21:10:11 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org
Cc: Ingo Molnar <mingo@kernel.org>, Andrew Morton <akpm@linux-foundation.org>,
        Fengguang Wu <fengguang.wu@intel.com>,
        "Peter Zijlstra (Intel)" <peterz@infradead.org>
Subject: [for-next][PATCH 1/2] tracing: Robustify wait loop
References: <20141009011010.446507073@goodmis.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Content-Disposition: inline; filename=0001-tracing-Robustify-wait-loop.patch
X-RR-Connecting-IP: 107.14.168.142:25
X-Cloudmark-Score: 0
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Peter Zijlstra <peterz@infradead.org>

The pending nested sleep debugging triggered on the potential stale
TASK_INTERRUPTIBLE in this code.

While there, fix the loop such that we won't revert to a while(1)
yield() 'spin' loop if we ever get a spurious wakeup.

And fix the actual issue by properly terminating the 'wait' loop by
setting TASK_RUNNING.

Link: http://lkml.kernel.org/p/20141008165110.GA14547@worktop.programming.kicks-ass.net

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_events.c | 5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

diff --git a/kernel/trace/trace_events.c b/kernel/trace/trace_events.c
index ef06ce7e9cf8..0cc51edde3a8 100644
--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2513,8 +2513,11 @@ static __init int event_test_thread(void *unused)
 	kfree(test_malloc);
 
 	set_current_state(TASK_INTERRUPTIBLE);
-	while (!kthread_should_stop())
+	while (!kthread_should_stop()) {
 		schedule();
+		set_current_state(TASK_INTERRUPTIBLE);
+	}
+	__set_current_state(TASK_RUNNING);
 
 	return 0;
 }
-- 
2.0.1


