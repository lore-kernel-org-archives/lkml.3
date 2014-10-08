Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752943AbaJHQvP (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Oct 2014 12:51:15 -0400
Received: from casper.infradead.org ([85.118.1.10]:34383 "EHLO
	casper.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751029AbaJHQvO (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Oct 2014 12:51:14 -0400
Date: Wed, 8 Oct 2014 18:51:10 +0200
From: Peter Zijlstra <peterz@infradead.org>
To: Steven Rostedt <rostedt@goodmis.org>
Cc: Fengguang Wu <fengguang.wu@intel.com>, Jet Chen <jet.chen@intel.com>,
        Su Tao <tao.su@intel.com>, Yuanhan Liu <yuanhan.liu@intel.com>,
        LKP <lkp@01.org>, linux-kernel@vger.kernel.org
Subject: [PATCH] trace: Robustify wait loop
Message-ID: <20141008165110.GA14547@worktop.programming.kicks-ass.net>
References: <20141008100613.GA17869@wfg-t540p.sh.intel.com>
 <20141008104120.GH10832@worktop.programming.kicks-ass.net>
 <20141008110825.58bdb51d@gandalf.local.home>
 <20141008154838.GM10832@worktop.programming.kicks-ass.net>
 <20141008121718.0210c24e@gandalf.local.home>
 <20141008163657.GN10832@worktop.programming.kicks-ass.net>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <20141008163657.GN10832@worktop.programming.kicks-ass.net>
User-Agent: Mutt/1.5.22.1 (2013-10-16)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

On Wed, Oct 08, 2014 at 06:36:57PM +0200, Peter Zijlstra wrote:
> 
> Right, I'll send the patch. 


---
Subject: trace: Robustify wait loop
From: Peter Zijlstra (Intel) <peterz@infradead.org>
Date: Wed Oct  8 18:44:26 CEST 2014

The pending nested sleep debugging triggered on the potential stale
TASK_INTERRUPTIBLE in this code.

While there, fix the loop such that we won't revert to a while(1)
yield() 'spin' loop if we ever get a spurious wakeup.

And fix the actual issue by properly terminating the 'wait' loop by
setting TASK_RUNNING.

Reported-by: Fengguang Wu <fengguang.wu@intel.com>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
---
 kernel/trace/trace_events.c |    5 ++++-
 1 file changed, 4 insertions(+), 1 deletion(-)

--- a/kernel/trace/trace_events.c
+++ b/kernel/trace/trace_events.c
@@ -2513,8 +2513,11 @@ static __init int event_test_thread(void
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
