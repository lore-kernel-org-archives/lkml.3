Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935049AbaGPTT4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 15:19:56 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44251 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934924AbaGPTTv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 15:19:51 -0400
Date: Wed, 16 Jul 2014 12:19:12 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-zedy3uktcp753q8fw8dagx7a@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf: Revert ("perf:
  Always destroy groups on exit")
Git-Commit-ID: 1903d50cba54261a6562a476c05085f3d7a54097
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

Commit-ID:  1903d50cba54261a6562a476c05085f3d7a54097
Gitweb:     http://git.kernel.org/tip/1903d50cba54261a6562a476c05085f3d7a54097
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Tue, 15 Jul 2014 17:27:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 16 Jul 2014 13:18:39 +0200

perf: Revert ("perf: Always destroy groups on exit")

Vince reported that commit 15a2d4de0eab5 ("perf: Always destroy groups
on exit") causes a regression with grouped events. In particular his
read_group_attached.c test fails.

  https://github.com/deater/perf_event_tests/blob/master/tests/bugs/read_group_attached.c

Because of the context switch optimization in
perf_event_context_sched_out() the 'original' event may end up in the
child process and when that exits the change in the patch in question
destroys the actual grouping.

Therefore revert that change and only destroy inherited groups.

Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/n/tip-zedy3uktcp753q8fw8dagx7a@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 14 +++++++++++++-
 1 file changed, 13 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index b0c95f0..c46b02b 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7458,7 +7458,19 @@ __perf_event_exit_task(struct perf_event *child_event,
 			 struct perf_event_context *child_ctx,
 			 struct task_struct *child)
 {
-	perf_remove_from_context(child_event, true);
+	/*
+	 * Do not destroy the 'original' grouping; because of the context
+	 * switch optimization the original events could've ended up in a
+	 * random child task.
+	 *
+	 * If we were to destroy the original group, all group related
+	 * operations would cease to function properly after this random
+	 * child dies.
+	 *
+	 * Do destroy all inherited groups, we don't care about those
+	 * and being thorough is better.
+	 */
+	perf_remove_from_context(child_event, !!child_event->parent);
 
 	/*
 	 * It can happen that the parent exits first, and has events
