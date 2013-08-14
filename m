Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760254Ab3HNSaB (ORCPT <rfc822;w@1wt.eu>);
	Wed, 14 Aug 2013 14:30:01 -0400
Received: from merlin.infradead.org ([205.233.59.134]:34323 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760187Ab3HNSZZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 14 Aug 2013 14:25:25 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 10/21] perf session: Change perf_session__has_traces to actually check for tracepoints
Date: Wed, 14 Aug 2013 15:25:04 -0300
Message-Id: <1376504715-28107-11-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1376504715-28107-1-git-send-email-acme@infradead.org>
References: <1376504715-28107-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Any event can have RAW data attribute set. The intent of the function is
to determine if the session has tracepoints, so check for the type of
each event explicitly.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1375930261-77273-17-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/session.c | 11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 5a89964..4d9028e 100644
--- a/tools/perf/util/session.c
+++ b/tools/perf/util/session.c
@@ -1401,12 +1401,15 @@ int perf_session__process_events(struct perf_session *self,
 
 bool perf_session__has_traces(struct perf_session *session, const char *msg)
 {
-	if (!(perf_evlist__sample_type(session->evlist) & PERF_SAMPLE_RAW)) {
-		pr_err("No trace sample to read. Did you call 'perf %s'?\n", msg);
-		return false;
+	struct perf_evsel *evsel;
+
+	list_for_each_entry(evsel, &session->evlist->entries, node) {
+		if (evsel->attr.type == PERF_TYPE_TRACEPOINT)
+			return true;
 	}
 
-	return true;
+	pr_err("No trace sample to read. Did you call 'perf %s'?\n", msg);
+	return false;
 }
 
 int maps__set_kallsyms_ref_reloc_sym(struct map **maps,
-- 
1.8.1.4

