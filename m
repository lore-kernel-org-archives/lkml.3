Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753344AbaGKL5N (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Jul 2014 07:57:13 -0400
Received: from mx1.redhat.com ([209.132.183.28]:37575 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752991AbaGKL4y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Jul 2014 07:56:54 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 5/5] perf: Check event's owner permission in tracepoint init callback
Date: Fri, 11 Jul 2014 13:56:22 +0200
Message-Id: <1405079782-8139-6-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
References: <1405079782-8139-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Checking event's owner task permissions instead of 'current'
process' ones. This way we get proper check when this is
called from fork callback, where 'current' process does not
represent the owner.

Checking parent event owner task in case of child event.

Reported-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c            |  4 ++++
 kernel/trace/trace_event_perf.c | 19 +++++++++++++++++--
 2 files changed, 21 insertions(+), 2 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index faba9e0..c478828 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -3315,6 +3315,10 @@ struct task_struct *perf_event_get_owner(struct perf_event *event)
 {
 	struct task_struct *owner;
 
+	/* Only the parent holds owner task. */
+	if (event->parent)
+		event = event->parent;
+
 	rcu_read_lock();
 	owner = ACCESS_ONCE(event->owner);
 	/*
diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 5d12bb4..35b76ec 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -21,9 +21,24 @@ typedef typeof(unsigned long [PERF_MAX_TRACE_SIZE / sizeof(unsigned long)])
 /* Count the events in use (per event id, not per instance) */
 static int	total_ref_count;
 
+static bool is_owner_admin(struct perf_event *event)
+{
+	struct task_struct *owner = perf_event_get_owner(event);
+	bool admin = false;
+
+	if (owner) {
+		admin = has_capability(owner, CAP_SYS_ADMIN);
+		put_task_struct(owner);
+	}
+
+	return admin;
+}
+
 static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 				 struct perf_event *p_event)
 {
+	bool admin = is_owner_admin(p_event);
+
 	if (tp_event->perf_perm) {
 		int ret = tp_event->perf_perm(tp_event, p_event);
 		if (ret)
@@ -32,7 +47,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
-		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+		if (perf_paranoid_tracepoint_raw() && !admin)
 			return -EPERM;
 
 		/*
@@ -65,7 +80,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 	 * ...otherwise raw tracepoint data can be a severe data leak,
 	 * only allow root to have these.
 	 */
-	if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
+	if (perf_paranoid_tracepoint_raw() && !admin)
 		return -EPERM;
 
 	return 0;
-- 
1.8.3.1

