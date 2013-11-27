Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932331Ab3K0UWk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Nov 2013 15:22:40 -0500
Received: from merlin.infradead.org ([205.233.59.134]:32803 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757891Ab3K0URC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Nov 2013 15:17:02 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 25/34] perf script: Print callchains and symbols if they exist
Date: Wed, 27 Nov 2013 17:16:25 -0300
Message-Id: <1385583394-3703-26-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1385583394-3703-1-git-send-email-acme@infradead.org>
References: <1385583394-3703-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

The intent of perf-script is to dump the events and information in the
file. H/W, S/W and raw events all dump callchains if they are present;
might as well make that the default for tracepoints too.

v2: Only add options for sym, dso and ip if callchains are present

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Link: http://lkml.kernel.org/r/1384920457-5986-1-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
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
1.8.1.4

