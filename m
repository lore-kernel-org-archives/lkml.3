Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754950AbaK0IsE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 27 Nov 2014 03:48:04 -0500
Received: from mail.kernel.org ([198.145.19.201]:41856 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754924AbaK0Ir7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 27 Nov 2014 03:47:59 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Linus Torvalds <torvalds@linux-foundation.org>,
        Ingo Molnar <mingo@kernel.org>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 43/91] perf: Fix a race condition in perf_remove_from_context()
Date: Thu, 27 Nov 2014 16:42:26 +0800
Message-Id: <1417077794-9299-43-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1417077368-9217-1-git-send-email-lizf@kernel.org>
References: <1417077368-9217-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <cwang@twopensource.com>

3.4.105-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 kernel/events/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 685ce46..c958be1 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1702,6 +1702,16 @@ retry:
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
 
-- 
1.9.1

