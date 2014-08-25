Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933146AbaHYOqa (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Aug 2014 10:46:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:6252 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933111AbaHYOq0 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Aug 2014 10:46:26 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>,
        "Jen-Cheng(Tommy) Huang" <tommy24@gatech.edu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 3/9] perf: Allow PERF_FORMAT_GROUP format on inherited events
Date: Mon, 25 Aug 2014 16:45:37 +0200
Message-Id: <1408977943-16594-4-git-send-email-jolsa@kernel.org>
In-Reply-To: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
References: <1408977943-16594-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

I assume the reason for this being disabled is the difficulty
to read child events once in perf overflow routine, thus the
perf_output_read_group function. The read syscall function
perf_event_read_group seems to handle this nicely.

My goal is to be able to read all events in group on leader
sample by using the PERF_SAMPLE_READ with PERF_FORMAT_GROUP
format. Once the monitored process forks, I need the child
processes/events do the same and store samples into parents
ring buffer.

So I need all events sample just to report their own value
(without child events being included). Thus switching the
perf_event_count call for simple read of event->count.

Reported-by: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jen-Cheng(Tommy) Huang <tommy24@gatech.edu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 kernel/events/core.c | 13 ++-----------
 1 file changed, 2 insertions(+), 11 deletions(-)

diff --git a/kernel/events/core.c b/kernel/events/core.c
index ff6a17607ddb..9d6b15c8f728 100644
--- a/kernel/events/core.c
+++ b/kernel/events/core.c
@@ -4608,9 +4608,6 @@ static void perf_output_read_one(struct perf_output_handle *handle,
 	__output_copy(handle, values, n * sizeof(u64));
 }
 
-/*
- * XXX PERF_FORMAT_GROUP vs inherited events seems difficult.
- */
 static void perf_output_read_group(struct perf_output_handle *handle,
 			    struct perf_event *event,
 			    u64 enabled, u64 running)
@@ -4631,7 +4628,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 	if (leader != event)
 		leader->pmu->read(leader);
 
-	values[n++] = perf_event_count(leader);
+	values[n++] = local64_read(&leader->count);
 	if (read_format & PERF_FORMAT_ID)
 		values[n++] = primary_event_id(leader);
 
@@ -4644,7 +4641,7 @@ static void perf_output_read_group(struct perf_output_handle *handle,
 		    (sub->state == PERF_EVENT_STATE_ACTIVE))
 			sub->pmu->read(sub);
 
-		values[n++] = perf_event_count(sub);
+		values[n++] = local64_read(&sub->count);
 		if (read_format & PERF_FORMAT_ID)
 			values[n++] = primary_event_id(sub);
 
@@ -6953,12 +6950,6 @@ perf_event_alloc(struct perf_event_attr *attr, int cpu,
 
 	local64_set(&hwc->period_left, hwc->sample_period);
 
-	/*
-	 * we currently do not support PERF_FORMAT_GROUP on inherited events
-	 */
-	if (attr->inherit && (attr->read_format & PERF_FORMAT_GROUP))
-		goto err_ns;
-
 	pmu = perf_init_event(event);
 	if (!pmu)
 		goto err_ns;
-- 
1.8.3.1

