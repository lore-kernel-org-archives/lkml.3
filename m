Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753768AbaIXO7Z (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Sep 2014 10:59:25 -0400
Received: from terminus.zytor.com ([198.137.202.10]:59768 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751937AbaIXO7W (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Sep 2014 10:59:22 -0400
Date: Wed, 24 Sep 2014 07:58:29 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-1929def9e609d1a8cdb1626d85eda3da66921a7d@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, eranian@google.com, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, torvalds@linux-foundation.org,
        peterz@infradead.org, acme@kernel.org, jolsa@redhat.com,
        fweisbec@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, jolsa@kernel.org,
        torvalds@linux-foundation.org, peterz@infradead.org, acme@kernel.org,
        jolsa@redhat.com, fweisbec@gmail.com, tglx@linutronix.de
In-Reply-To: <1410520708-19275-2-git-send-email-jolsa@kernel.org>
References: <1410520708-19275-2-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf: Fix child event initial state setup
Git-Commit-ID: 1929def9e609d1a8cdb1626d85eda3da66921a7d
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

Commit-ID:  1929def9e609d1a8cdb1626d85eda3da66921a7d
Gitweb:     http://git.kernel.org/tip/1929def9e609d1a8cdb1626d85eda3da66921a7d
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Fri, 12 Sep 2014 13:18:27 +0200
Committer:  Ingo Molnar <mingo@kernel.org>
CommitDate: Wed, 24 Sep 2014 14:48:12 +0200

perf: Fix child event initial state setup

Currently we initialize the child event based on the original
parent state. This is wrong, because the original parent event
(and its state) is not related to current fork and also could
be already gone.

We need to initialize the child state based on the immediate
parent event state.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Peter Zijlstra (Intel) <peterz@infradead.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Stephane Eranian <eranian@google.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Linus Torvalds <torvalds@linux-foundation.org>
Link: http://lkml.kernel.org/r/1410520708-19275-2-git-send-email-jolsa@kernel.org
Signed-off-by: Ingo Molnar <mingo@kernel.org>
---
 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index 15e58d4..132524c 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7818,6 +7818,7 @@ inherit_event(struct perf_event *parent_event,
 	      struct perf_event *group_leader,
 	      struct perf_event_context *child_ctx)
 {
+	enum perf_event_active_state parent_state = parent_event->state;
 	struct perf_event *child_event;
 	unsigned long flags;
 
@@ -7851,7 +7852,7 @@ inherit_event(struct perf_event *parent_event,
 	 * not its attr.disabled bit.  We hold the parent's mutex,
 	 * so we won't race with perf_event_{en, dis}able_family.
 	 */
-	if (parent_event->state >= PERF_EVENT_STATE_INACTIVE)
+	if (parent_state >= PERF_EVENT_STATE_INACTIVE)
 		child_event->state = PERF_EVENT_STATE_INACTIVE;
 	else
 		child_event->state = PERF_EVENT_STATE_OFF;
