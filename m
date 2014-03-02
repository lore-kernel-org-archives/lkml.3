Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753647AbaCBP5O (ORCPT <rfc822;w@1wt.eu>);
	Sun, 2 Mar 2014 10:57:14 -0500
Received: from mx1.redhat.com ([209.132.183.28]:5131 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753070AbaCBP5K (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 2 Mar 2014 10:57:10 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Paul Mackerras <paulus@samba.org>, Ingo Molnar <mingo@redhat.com>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        "H. Peter Anvin" <hpa@zytor.com>,
        Vince Weaver <vincent.weaver@maine.edu>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/3] perf: Disallow user space stack dump for function trace event
Date: Sun,  2 Mar 2014 16:56:39 +0100
Message-Id: <1393775800-13524-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
References: <1393775800-13524-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Disabling user space stack dump for function trace event.

Recent issues with user space callchains processing within
page fault handler tracing showed as Peter said 'there's
just too much fail surface'.

The user space stack dump is just another source of the this issue.

Related list discussions:
  http://marc.info/?t=139302086500001&r=1&w=2
  http://marc.info/?t=139301437300003&r=1&w=2

Suggested-by: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Ingo Molnar <mingo@redhat.com>
Cc: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: H. Peter Anvin <hpa@zytor.com>
Cc: Vince Weaver <vincent.weaver@maine.edu>
Cc: Steven Rostedt <rostedt@goodmis.org>
---
 kernel/trace/trace_event_perf.c | 7 +++++++
 1 file changed, 7 insertions(+)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index d5e01c3..c894614 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -42,6 +42,13 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 		 */
 		if (!p_event->attr.exclude_callchain_user)
 			return -EINVAL;
+
+		/*
+		 * Same reason to disable user stack dump as for user space
+		 * callchains above.
+		 */
+		if (p_event->attr.sample_type & PERF_SAMPLE_STACK_USER)
+			return -EINVAL;
 	}
 
 	/* No tracing, just counting, so no obvious leak */
-- 
1.8.3.1

