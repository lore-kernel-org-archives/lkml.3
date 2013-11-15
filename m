Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752377Ab3KORba (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Nov 2013 12:31:30 -0500
Received: from mail-qc0-f176.google.com ([209.85.216.176]:46562 "EHLO
	mail-qc0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751253Ab3KORbW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Nov 2013 12:31:22 -0500
Date: Fri, 15 Nov 2013 12:39:45 -0500 (EST)
From: Vince Weaver <vincent.weaver@maine.edu>
To: LKML <linux-kernel@vger.kernel.org>
cc: Steven Rostedt <rostedt@goodmis.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>
Subject: [patch] perf/trace properly use u64 to hold event_id
Message-ID: <alpine.DEB.2.10.1311151236100.11932@vincent-weaver-1.um.maine.edu>
User-Agent: Alpine 2.10 (DEB 1266 2009-07-14)
MIME-Version: 1.0
Content-Type: TEXT/PLAIN; charset=US-ASCII
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org


The 64-bit attr.config value for perf trace events was being copied into
an "int" before doing a comparison, meaning the top 32 bits were
being truncated.

As far as I can tell this didn't cause any errors, but it did mean
it was possible to create valid aliases for all the tracepoint ids
which I don't think was intended.  (For example, 0xffffffff00000018
and 0x18 both enable the same tracepoint).

Signed-off-by: Vince Weaver <vincent.weaver@maine.edu>

diff --git a/kernel/trace/trace_event_perf.c b/kernel/trace/trace_event_perf.c
index 78e27e3..280c3db0 100644
--- a/kernel/trace/trace_event_perf.c
+++ b/kernel/trace/trace_event_perf.c
@@ -173,7 +173,7 @@ static int perf_trace_event_init(struct ftrace_event_call *tp_event,
 int perf_trace_init(struct perf_event *p_event)
 {
 	struct ftrace_event_call *tp_event;
-	int event_id = p_event->attr.config;
+	u64 event_id = p_event->attr.config;
 	int ret = -EINVAL;
 
 	mutex_lock(&event_mutex);
