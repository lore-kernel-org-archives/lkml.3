Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754124AbaKMRVk (ORCPT <rfc822;w@1wt.eu>);
	Thu, 13 Nov 2014 12:21:40 -0500
Received: from mx1.redhat.com ([209.132.183.28]:57588 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753973AbaKMRVi (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 13 Nov 2014 12:21:38 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH] perf tools: Fix ftrace:function event recording
Date: Thu, 13 Nov 2014 18:21:03 +0100
Message-Id: <1415899263-24820-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Following patch fails (-EINVAL) ftrace:function with enabled user
space callchains:
  cfa77bc4af2c perf: Disallow user-space callchains for function trace events

We need to follow in perf tool itself and explicitly set the
perf_event_attr::exclude_callchain_user flag for ftrace:function
event.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/evsel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index ec5eb8033296..a3baaa31231e 100644
--- a/tools/perf/util/evsel.c
+++ b/tools/perf/util/evsel.c
@@ -658,6 +658,14 @@ void perf_evsel__config(struct perf_evsel *evsel, struct record_opts *opts)
 		attr->mmap_data = track;
 	}
 
+	/*
+	 * We don't allow user space callchains for  function trace
+	 * event, due to issues with page faults while tracing page
+	 * fault handler and its overall trickiness nature.
+	 */
+	if (perf_evsel__is_function_event(evsel))
+		evsel->attr.exclude_callchain_user = 1;
+
 	if (callchain_param.enabled && !evsel->no_aux_samples)
 		perf_evsel__config_callgraph(evsel);
 
-- 
1.9.3

