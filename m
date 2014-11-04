Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753546AbaKDK4H (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Nov 2014 05:56:07 -0500
Received: from mx1.redhat.com ([209.132.183.28]:40716 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753269AbaKDK4D (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Nov 2014 05:56:03 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Steven Rostedt <rostedt@goodmis.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH] perf tools: Do not call pevent_free_format when deleting tracepoint
Date: Tue,  4 Nov 2014 11:55:38 +0100
Message-Id: <1415098538-1512-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The libtraceevent library's main handle 'struct pevent' holds
pointers of every event that was added to it via functions:
  pevent_parse_format
  pevent_parse_event

We can't release struct event_format (call pevent_free_format)
separately, because that breaks that pointers array mentioned
above and another add_event call could end up with segfault.

All added events are released within the handle cleanup
in pevent_free.

Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 2 --
 1 file changed, 2 deletions(-)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 2f9e68025ede..12b4396c7175 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -853,8 +853,6 @@ void perf_evsel__exit(struct perf_evsel *evsel)
 	perf_evsel__free_id(evsel);
 	close_cgroup(evsel->cgrp);
 	zfree(&evsel->group_name);
-	if (evsel->tp_format)
-		pevent_free_format(evsel->tp_format);
 	zfree(&evsel->name);
 	perf_evsel__object.fini(evsel);
 }
-- 
1.9.3

