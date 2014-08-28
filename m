Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752410AbaH1X1u (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Aug 2014 19:27:50 -0400
Received: from mail-pa0-f46.google.com ([209.85.220.46]:40000 "EHLO
	mail-pa0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751559AbaH1X1t (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Aug 2014 19:27:49 -0400
From: Cong Wang <xiyou.wangcong@gmail.com>
To: linux-kernel@vger.kernel.org
Cc: stable@vger.kernel.org, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Cong Wang <cwang@twopensource.com>,
        Cong Wang <xiyou.wangcong@gmail.com>
Subject: [Patch] perf_event: fix a race condition in perf_remove_from_context()
Date: Thu, 28 Aug 2014 16:27:35 -0700
Message-Id: <1409268455-11807-1-git-send-email-xiyou.wangcong@gmail.com>
X-Mailer: git-send-email 1.8.3.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Cong Wang <cwang@twopensource.com>

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
This should fix the above soft lockup.

Cc: stable@vger.kernel.org
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Signed-off-by: Cong Wang <cwang@twopensource.com>
Signed-off-by: Cong Wang <xiyou.wangcong@gmail.com>

---
diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9c1ed0..c4141a0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1524,6 +1524,11 @@ retry:
 	 */
 	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out() without switching
+		 */
+		task = ctx->task;
 		goto retry;
 	}
 
