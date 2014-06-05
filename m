Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752656AbaFEOjP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Jun 2014 10:39:15 -0400
Received: from terminus.zytor.com ([198.137.202.10]:48616 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752008AbaFEOjL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Jun 2014 10:39:11 -0400
Date: Thu, 5 Jun 2014 07:38:06 -0700
From: tip-bot for Peter Zijlstra <tipbot@zytor.com>
Message-ID: <tip-ebf905fc7a6e7c99c53b5afc888d8f950da90aff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, sasha.levin@oracle.com, hpa@zytor.com,
        mingo@kernel.org, torvalds@linux-foundation.org, peterz@infradead.org,
        acme@kernel.org, davej@redhat.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, sasha.levin@oracle.com,
        linux-kernel@vger.kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, davej@redhat.com, acme@kernel.org,
        tglx@linutronix.de
In-Reply-To: <20140529170024.GA2315@laptop.programming.kicks-ass.net>
References: <20140529170024.GA2315@laptop.programming.kicks-ass.net>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf:
  Fix use after free in perf_remove_from_context()
Git-Commit-ID: ebf905fc7a6e7c99c53b5afc888d8f950da90aff
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

Commit-ID:  ebf905fc7a6e7c99c53b5afc888d8f950da90aff
Gitweb:     http://git.kernel.org/tip/ebf905fc7a6e7c99c53b5afc888d8f950da90aff
Author:     Peter Zijlstra <peterz@infradead.org>
AuthorDate: Thu, 29 May 2014 19:00:24 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Thu, 5 Jun 2014 12:29:52 +0200

perf: Fix use after free in perf_remove_from_context()

While that mutex should guard the elements, it doesn't guard against the
use-after-free that's from list_for_each_entry_rcu().
__perf_event_exit_task() can actually free the event.

And because list addition/deletion is guarded by both ctx->mutex and
ctx->lock, holding ctx->mutex is sufficient for reading the list, so we
don't actually need the rcu list iteration.

Fixes: 3a497f48637e ("perf: Simplify perf_event_exit_task_context()")
Reported-by: Sasha Levin <sasha.levin@oracle.com>
Tested-by: Sasha Levin <sasha.levin@oracle.com>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: Dave Jones <davej@redhat.com>
Cc: acme@ghostprotocols.net
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/20140529170024.GA2315@laptop.programming.kicks-ass.net
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ed50b09..a62d142 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7431,7 +7431,7 @@ __perf_event_exit_task(struct perf_event *child_event,
 
 static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 {
-	struct perf_event *child_event;
+	struct perf_event *child_event, *next;
 	struct perf_event_context *child_ctx;
 	unsigned long flags;
 
@@ -7485,7 +7485,7 @@ static void perf_event_exit_task_context(struct task_struct *child, int ctxn)
 	 */
 	mutex_lock(&child_ctx->mutex);
 
-	list_for_each_entry_rcu(child_event, &child_ctx->event_list, event_entry)
+	list_for_each_entry_safe(child_event, next, &child_ctx->event_list, event_entry)
 		__perf_event_exit_task(child_event, child_ctx, child);
 
 	mutex_unlock(&child_ctx->mutex);
