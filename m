Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S934076Ab3HHCw5 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 Aug 2013 22:52:57 -0400
Received: from mail-pb0-f45.google.com ([209.85.160.45]:55007 "EHLO
	mail-pb0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934001Ab3HHCvv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 Aug 2013 22:51:51 -0400
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org, mingo@kernel.org
Cc: David Ahern <dsahern@gmail.com>, Frederic Weisbecker <fweisbec@gmail.com>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 16/19] perf tool: Change perf_session__has_traces to actually check for tracepoints
Date: Wed,  7 Aug 2013 22:50:58 -0400
Message-Id: <1375930261-77273-17-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.7.10.1
In-Reply-To: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
References: <1375930261-77273-1-git-send-email-dsahern@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Any event can have RAW data attribute set. The intent of the function is
to determine if the session has tracepoints, so check for the type of each
event explicitly.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/session.c |   11 +++++++----
 1 file changed, 7 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/session.c b/tools/perf/util/session.c
index 0eada12..83bdcfa 100644
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
1.7.10.1

