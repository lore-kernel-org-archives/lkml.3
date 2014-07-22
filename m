Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752969AbaGVNUy (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:20:54 -0400
Received: from mga02.intel.com ([134.134.136.20]:45434 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755297AbaGVNUv (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:20:51 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576985908"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 28/52] perf script: Allow callchains if any event samples them
Date: Tue, 22 Jul 2014 16:17:37 +0300
Message-Id: <1406035081-14301-29-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

perf script was not displaying callchains if any selected
event did not have PERF_SAMPLE_CALLCHAIN.  Change this to
disable callchains only if all selected events do not have
PERF_SAMPLE_CALLCHAIN.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-script.c | 17 +++++++++++++----
 1 file changed, 13 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index 582da97..c1a56f2 100644
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
1.8.3.2

