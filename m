Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754983Ab3KYNJQ (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:09:16 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57301 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751693Ab3KYNJD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:09:03 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Peter Zijlstra <peterz@infradead.org>, Ingo Molnar <mingo@kernel.org>,
        Jiri Olsa <jolsa@redhat.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Steven Rostedt <rostedt@goodmis.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 60/78] perf/ftrace: Fix paranoid level for enabling function tracer
Date: Mon, 25 Nov 2013 13:06:47 +0000
Message-Id: <1385384825-21681-61-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 kernel/trace/trace_event_perf.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index fee3752..d01adb7 100644
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

