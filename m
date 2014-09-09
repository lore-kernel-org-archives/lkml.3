Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932703AbaIIOzp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 9 Sep 2014 10:55:45 -0400
Received: from terminus.zytor.com ([198.137.202.10]:41136 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932668AbaIIOzb (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 9 Sep 2014 10:55:31 -0400
Date: Tue, 9 Sep 2014 07:53:54 -0700
From: tip-bot for Cong Wang <tipbot@zytor.com>
Message-ID: <tip-3577af70a2ce4853d58e57d832e687d739281479@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, acme@kernel.org, xiyou.wangcong@gmail.com,
        cwang@twopensource.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, stable@vger.kernel.org,
        xiyou.wangcong@gmail.com, cwang@twopensource.com, tglx@linutronix.de
In-Reply-To: <1409696840-843-1-git-send-email-xiyou.wangcong@gmail.com>
References: <1409696840-843-1-git-send-email-xiyou.wangcong@gmail.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Fix a race condition in perf_remove_from_context()
Git-Commit-ID: 3577af70a2ce4853d58e57d832e687d739281479
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  3577af70a2ce4853d58e57d832e687d739281479
Gitweb:     http://git.kernel.org/tip/3577af70a2ce4853d58e57d832e687d739281479
Author:     Cong Wang <cwang@twopensource.com>
AuthorDate: Tue, 2 Sep 2014 15:27:20 -0700
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Tue, 9 Sep 2014 06:53:42 +0200

perf: Fix a race condition in perf_remove_from_context()

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
Cc: <stable@vger.kernel.org>
Link: http://lkml.kernel.org/r/1409696840-843-1-git-send-email-xiyou.wangcong@gmail.com
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 10 ++++++++++
 1 file changed, 10 insertions(+)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index f9c1ed0..d640a8b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -1524,6 +1524,11 @@ retry:
 	 */
 	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task = ctx->task;
 		goto retry;
 	}
 
@@ -1967,6 +1972,11 @@ retry:
 	 */
 	if (ctx->is_active) {
 		raw_spin_unlock_irq(&ctx->lock);
+		/*
+		 * Reload the task pointer, it might have been changed by
+		 * a concurrent perf_event_context_sched_out().
+		 */
+		task = ctx->task;
 		goto retry;
 	}
 
