Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754282AbaILLSu (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Sep 2014 07:18:50 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5858 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754165AbaILLSq (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Sep 2014 07:18:46 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 2/3] perf: Fix child event initial state setup
Date: Fri, 12 Sep 2014 13:18:27 +0200
Message-Id: <1410520708-19275-2-git-send-email-jolsa@kernel.org>
In-Reply-To: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
References: <1410520708-19275-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Currently we initialize the child event based on the original
parent state. This is wrong, because the original parent event
(and its state) is not related to current fork and also could
be already gone.

We need to initialize the child state based on the immediate
parent event state.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index cf779eaaf624..5a09a09b2983 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -7798,6 +7798,7 @@ inherit_event(struct perf_event *parent_event,
 	      struct perf_event *group_leader,
 	      struct perf_event_context *child_ctx)
 {
+	enum perf_event_active_state parent_state = parent_event->state;
 	struct perf_event *child_event;
 	unsigned long flags;
 
@@ -7831,7 +7832,7 @@ inherit_event(struct perf_event *parent_event,
 	 * not its attr.disabled bit.  We hold the parent's mutex,
 	 * so we won't race with perf_event_{en, dis}able_family.
 	 */
-	if (parent_event->state >= PERF_EVENT_STATE_INACTIVE)
+	if (parent_state >= PERF_EVENT_STATE_INACTIVE)
 		child_event->state = PERF_EVENT_STATE_INACTIVE;
 	else
 		child_event->state = PERF_EVENT_STATE_OFF;
-- 
1.8.3.1

