Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162473Ab3LFXVX (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 18:21:23 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:49090 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1423063Ab3LFXVI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 18:21:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 061/152] perf/ftrace: Fix paranoid level for enabling function tracer
Date: Fri,  6 Dec 2013 15:09:45 -0800
Message-Id: <1386371476-2477-62-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386371476-2477-1-git-send-email-kamal@canonical.com>
References: <1386371476-2477-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.14 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Steven Rostedt <rostedt@goodmis.org>

commit 12ae030d54ef250706da5642fc7697cc60ad0df7 upstream.

The current default perf paranoid level is "1" which has
"perf_paranoid_kernel()" return false, and giving any operations that
use it, access to normal users. Unfortunately, this includes function
tracing and normal users should not be allowed to enable function
tracing by default.

The proper level is defined at "-1" (full perf access), which
"perf_paranoid_tracepoint_raw()" will only give access to. Use that
check instead for enabling function tracing.

Reported-by: Dave Jones <davej@redhat.com>
Reported-by: Vince Weaver <vincent.weaver@maine.edu>
Tested-by: Vince Weaver <vincent.weaver@maine.edu>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
CVE: CVE-2013-2930
Fixes: ced39002f5ea ("ftrace, perf: Add support to use function tracepoint in perf")
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 kernel/trace/trace_event_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 84b1e04..8354dc8 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -26,7 +26,7 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 {
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event) &&
-	    perf_paranoid_kernel() && !capable(CAP_SYS_ADMIN))
+	    perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
 		return -EPERM;
 
 	/* No tracing, just counting, so no obvious leak */
-- 
1.8.3.2

