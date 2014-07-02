Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758822AbaGBGlu (ORCPT <rfc822;w@1wt.eu>);
	Wed, 2 Jul 2014 02:41:50 -0400
Received: from terminus.zytor.com ([198.137.202.10]:45262 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757904AbaGBGlg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 2 Jul 2014 02:41:36 -0400
Date: Tue, 1 Jul 2014 23:39:42 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1f9a7268c67f0290837aada443d28fd953ddca90@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, stable@vger.kernel.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org,
        stable@vger.kernel.org, acme@kernel.org, namhyung@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        tglx@linutronix.de, cjashfor@linux.vnet.ibm.com
In-Reply-To: <1403598026-2310-2-git-send-email-jolsa@kernel.org>
References: <1403598026-2310-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/urgent] perf:
  Do not allow optimized switch for non-cloned events
Git-Commit-ID: 1f9a7268c67f0290837aada443d28fd953ddca90
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

Commit-ID:  1f9a7268c67f0290837aada443d28fd953ddca90
Gitweb:     http://git.kernel.org/tip/1f9a7268c67f0290837aada443d28fd953ddca90
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 24 Jun 2014 10:20:25 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 2 Jul 2014 08:35:56 +0200

perf: Do not allow optimized switch for non-cloned events

The context check in perf_event_context_sched_out allows
non-cloned context to be part of the optimized schedule
out switch.

This could move non-cloned context into another workload
child. Once this child exits, the context is closed and
leaves all original (parent) events in closed state.

Any other new cloned event will have closed state and not
measure anything. And probably causing other odd bugs.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra <peterz@infradead.org>
Cc: <stable@vger.kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1403598026-2310-2-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index a33d9a2b..b0c95f0 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -2320,7 +2320,7 @@ static void perf_event_context_sched_out(struct task_struct *task, int ctxn,
 	next_parent = rcu_dereference(next_ctx->parent_ctx);
 
 	/* If neither context have a parent context; they cannot be clones. */
-	if (!parent && !next_parent)
+	if (!parent || !next_parent)
 		goto unlock;
 
 	if (next_parent == ctx || next_ctx == parent || next_parent == parent) {
