Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756710AbaKSQEy (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 11:04:54 -0500
Received: from mail.kernel.org ([198.145.19.201]:51615 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754986AbaKSQEw (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 11:04:52 -0500
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 13/16] perf evsel: Fix ftrace:function event recording
Date: Wed, 19 Nov 2014 13:03:33 -0300
Message-Id: <1416413016-19110-14-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1416413016-19110-1-git-send-email-acme@kernel.org>
References: <1416413016-19110-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@kernel.org>

Following patch fails (-EINVAL) ftrace:function with enabled user
space callchains:
  cfa77bc4af2c perf: Disallow user-space callchains for function trace events

We need to follow in perf tool itself and explicitly set the
perf_event_attr::exclude_callchain_user flag for ftrace:function
event.

Reported-by: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1415899263-24820-1-git-send-email-jolsa@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/evsel.c | 8 ++++++++
 1 file changed, 8 insertions(+)

diff --git a/tools/perf/util/evsel.c b/tools/perf/util/evsel.c
index 34344ffa79ca..f2dc91fb87fa 100644
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

