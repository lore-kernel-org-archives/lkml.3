Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752670AbaKAWl0 (ORCPT <rfc822;w@1wt.eu>);
	Sat, 1 Nov 2014 18:41:26 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60316 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751781AbaKAWjd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 1 Nov 2014 18:39:33 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Peter Zijlstra" <peterz@infradead.org>,
        "Ingo Molnar" <mingo@kernel.org>,
        "Arnaldo Carvalho de Melo" <acme@kernel.org>,
        "Cong Wang" <xiyou.wangcong@gmail.com>,
        "Paul Mackerras" <paulus@samba.org>,
        "Linus Torvalds" <torvalds@linux-foundation.org>,
        "Cong Wang" <cwang@twopensource.com>
Date: Sat, 01 Nov 2014 22:28:03 +0000
Message-ID: <lsq.1414880883.2222066@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 033/102] perf: Fix a race condition in perf_remove_from_context()
In-Reply-To: <lsq.1414880882.522510247@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.64-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Cong Wang <cwang@twopensource.com>

commit 3577af70a2ce4853d58e57d832e687d739281479 upstream.

We saw a kernel soft lockup in perf_remove_from_context(),
it looks like the `perf` process, when exiting, could not go
out of the retry loop. Meanwhile, the target process was forking
a child. So either the target process should execute the smp
function call to deactive the event (if it was running) or it should
do a context switch which deactives the event.

It seems we optimize out a context switch in perf_event_context_sched_out(),
and what's more important, we still test an obsolete task pointer when
retrying, so no one actually would deactive that event in this situation.
Fix it directly by reloading the task pointer in perf_remove_from_context().

This should cure the above soft lockup.

Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1409696840-843-1-git-send-email-xiyou.wangcong@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 kernel/events/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1683,6 +1683,16 @@ retry:
 	 */
 	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task = ctx->task;
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task = ctx->task;
 		goto retry;
 	}
 

