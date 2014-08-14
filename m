Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755203AbaHNIvx (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:51:53 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36681 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754409AbaHNIvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:51:51 -0400
Date: Thu, 14 Aug 2014 01:51:02 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-98526ee7229be8537373aebe037b74cac112d84b@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406786474-9306-17-git-send-email-adrian.hunter@intel.com>
References: <1406786474-9306-17-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf script:
  Allow callchains if any event samples them
Git-Commit-ID: 98526ee7229be8537373aebe037b74cac112d84b
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  98526ee7229be8537373aebe037b74cac112d84b
Gitweb:     http://git.kernel.org/tip/98526ee7229be8537373aebe037b74cac112d84b
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Thu, 31 Jul 2014 09:00:59 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 19:21:53 -0300

perf script: Allow callchains if any event samples them

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
index 37d2b60..c1b7029 100644
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
