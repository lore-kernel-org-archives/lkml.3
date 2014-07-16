Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933406AbaGPMdt (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 08:33:49 -0400
Received: from mx1.redhat.com ([209.132.183.28]:9217 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932978AbaGPMdp (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 08:33:45 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>,
        Alexander Yarygin <yarygin@linux.vnet.ibm.com>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH] perf: Check permission only for parent tracepoint event
Date: Wed, 16 Jul 2014 14:33:29 +0200
Message-Id: <1405514009-15875-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to check cloned event's permission once the
parent was already checked.

Also the code is checking 'current' process permissions, which
is not owner process for cloned events, thus could end up with
wrong permission check result.

Reported-by: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Alexander Yarygin <yarygin@linux.vnet.ibm.com>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1405079782-8139-1-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/trace/trace_event_perf.c | 12 ++++++++++++
 1 file changed, 12 insertions(+)

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 5d12bb407b44..4b9c114ee9de 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -30,6 +30,18 @@ static int perf_trace_event_perm(struct ftrace_event_call *tp_event,
 			return ret;
 	}
 
+	/*
+	 * We checked and allowed to create parent,
+	 * allow children without checking.
+	 */
+	if (p_event->parent)
+		return 0;
+
+	/*
+	 * It's ok to check current process (owner) permissions in here,
+	 * because code below is called only via perf_event_open syscall.
+	 */
+
 	/* The ftrace function trace is allowed only for root. */
 	if (ftrace_event_is_function(tp_event)) {
 		if (perf_paranoid_tracepoint_raw() && !capable(CAP_SYS_ADMIN))
-- 
1.8.3.1

