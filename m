Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752228Ab3KTEHp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 23:07:45 -0500
Received: from mail-pa0-f44.google.com ([209.85.220.44]:54792 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751510Ab3KTEHn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 23:07:43 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH] perf script: Print callchains and symbols if they exist - v2
Date: Tue, 19 Nov 2013 21:07:37 -0700
Message-Id: <1384920457-5986-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The intent of perf-script is to dump the events and information
in the file. H/W, S/W and raw events all dump callchains if they
are present; might as well make that the default for tracepoints
too.

v2: Only add options for sym, dso and ip if callchains are present

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
---
 tools/perf/builtin-script.c | 24 ++++++++++++++++++++++++
 1 file changed, 24 insertions(+)

diff --git a/tools/perf/builtin-script.c b/tools/perf/builtin-script.c
index b392770766dd..9f3ba4404a14 100644
--- a/tools/perf/builtin-script.c
+++ b/tools/perf/builtin-script.c
@@ -280,6 +280,30 @@ static int perf_session__check_output_opt(struct perf_session *session)
 		set_print_ip_opts(&evsel->attr);
 	}
 
+	/*
+	 * set default for tracepoints to print symbols only
+	 * if callchains are present
+	 */
+	if (symbol_conf.use_callchain &&
+	    !output[PERF_TYPE_TRACEPOINT].user_set) {
+		struct perf_event_attr *attr;
+
+		j = PERF_TYPE_TRACEPOINT;
+		evsel = perf_session__find_first_evtype(session, j);
+		if (evsel == NULL)
+			goto out;
+
+		attr = &evsel->attr;
+
+		if (attr->sample_type & PERF_SAMPLE_CALLCHAIN) {
+			output[j].fields |= PERF_OUTPUT_IP;
+			output[j].fields |= PERF_OUTPUT_SYM;
+			output[j].fields |= PERF_OUTPUT_DSO;
+			set_print_ip_opts(attr);
+		}
+	}
+
+out:
 	return 0;
 }
 
-- 
1.8.3.4 (Apple Git-47)

