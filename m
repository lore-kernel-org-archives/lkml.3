Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754493AbaHMWvS (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:51:18 -0400
Received: from mail.kernel.org ([198.145.19.201]:55702 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753082AbaHMWvO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:51:14 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 36/41] perf script: Allow callchains if any event samples them
Date: Wed, 13 Aug 2014 19:48:22 -0300
Message-Id: <1407970107-24540-37-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

perf script was not displaying callchains if any selected event did not
have PERF_SAMPLE_CALLCHAIN.

Change this to disable callchains only if all selected events do not
have PERF_SAMPLE_CALLCHAIN.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406786474-9306-17-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-script.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 37d2b608d388..c1b7029884b1 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -184,10 +184,6 @@ static int perf_evsel__check_attr(struct perf_evsel *evsel,
 		if (perf_evsel__check_stype(evsel, PERF_SAMPLE_IP, "IP",
 					    PERF_OUTPUT_IP))
 			return -EINVAL;
-
-		if (!no_callchain &&
-		    !(attr->sample_type & PERF_SAMPLE_CALLCHAIN))
-			symbol_conf.use_callchain = false;
 	}
 
 	if (PRINT_FIELD(ADDR) &&
@@ -290,6 +286,19 @@ static int perf_session__check_output_opt(struct perf_session *session)
 		set_print_ip_opts(&evsel->attr);
 	}
 
+	if (!no_callchain) {
+		bool use_callchain = false;
+
+		evlist__for_each(session->evlist, evsel) {
+			if (evsel->attr.sample_type & PERF_SAMPLE_CALLCHAIN) {
+				use_callchain = true;
+				break;
+			}
+		}
+		if (!use_callchain)
+			symbol_conf.use_callchain = false;
+	}
+
 	/*
 	 * set default for tracepoints to print symbols only
 	 * if callchains are present
-- 
1.9.3

