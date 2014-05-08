Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754613AbaEHKqQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 8 May 2014 06:46:16 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33363 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753508AbaEHKqN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 8 May 2014 06:46:13 -0400
Date: Thu, 8 May 2014 03:45:33 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-tij931199thfkys8vbnokdpf@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, vincent.weaver@maine.edu,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        vincent.weaver@maine.edu, tglx@linutronix.de
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Simplify perf_event_exit_task_context()
Git-Commit-ID: 3a497f48637e2aac17eabb84a17f8ac5216028fc
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

Commit-ID:  3a497f48637e2aac17eabb84a17f8ac5216028fc
Gitweb:     http://git.kernel.org/tip/3a497f48637e2aac17eabb84a17f8ac5216028fc
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Mon, 5 May 2014 12:42:29 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 7 May 2014 13:44:19 +0200

perf: Simplify perf_event_exit_task_context()

Instead of jumping through hoops to make sure to find (and exit) each
event, do it the simple straight fwd way.

Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-tij931199thfkys8vbnokdpf@git.kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 17 +----------------
 1 file changed, 1 insertion(+), 16 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 83505a3..7ab734f 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7485,24 +7485,9 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 */
 	mutex_lock(&child_ctx->mutex);
 
-again:
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->pinned_groups,
-				 group_entry)
-		__perf_event_exit_task(child_event, child_ctx, child);
-
-	list_for_each_entry_safe(child_event, tmp, &child_ctx->flexible_groups,
-				 group_entry)
+	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
-	/*
-	 * If the last event was a group event, it will have appended all
-	 * its siblings to the list, but we obtained 'tmp' before that which
-	 * will still point to the list head terminating the iteration.
-	 */
-	if (!list_empty(&child_ctx->pinned_groups) ||
-	    !list_empty(&child_ctx->flexible_groups))
-		goto again;
-
 	mutex_unlock(&child_ctx->mutex);
 
 	put_ctx(child_ctx);
