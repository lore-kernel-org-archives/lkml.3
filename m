Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753553Ab3KGPEy (ORCPT <rfc822;w@1wt.eu>);
	Thu, 7 Nov 2013 10:04:54 -0500
Received: from merlin.infradead.org ([205.233.59.134]:55636 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753088Ab3KGPEs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 7 Nov 2013 10:04:48 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/7] perf record: Refactor feature handling into a separate function
Date: Thu,  7 Nov 2013 12:04:15 -0300
Message-Id: <1383836658-10518-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1383836658-10518-1-git-send-email-acme@infradead.org>
References: <1383836658-10518-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Ahern <dsahern@gmail.com>

Code move only. No logic changes.

Signed-off-by: David Ahern <dsahern@gmail.com>
Acked-by: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1383763297-27066-2-git-send-email-dsahern@gmail.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 33 +++++++++++++++++++++------------
 1 file changed, 21 insertions(+), 12 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ea4c04f7437e..2932069ad7a8 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -342,9 +342,28 @@ out:
 	return rc;
 }
 
+static void perf_record__init_features(struct perf_record *rec)
+{
+	struct perf_evlist *evsel_list = rec->evlist;
+	struct perf_session *session = rec->session;
+	int feat;
+
+	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
+		perf_header__set_feat(&session->header, feat);
+
+	if (rec->no_buildid)
+		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
+
+	if (!have_tracepoints(&evsel_list->entries))
+		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
+
+	if (!rec->opts.branch_stack)
+		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+}
+
 static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 {
-	int err, feat;
+	int err;
 	unsigned long waking = 0;
 	const bool forks = argc > 0;
 	struct machine *machine;
@@ -371,17 +390,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	rec->session = session;
 
-	for (feat = HEADER_FIRST_FEATURE; feat < HEADER_LAST_FEATURE; feat++)
-		perf_header__set_feat(&session->header, feat);
-
-	if (rec->no_buildid)
-		perf_header__clear_feat(&session->header, HEADER_BUILD_ID);
-
-	if (!have_tracepoints(&evsel_list->entries))
-		perf_header__clear_feat(&session->header, HEADER_TRACING_DATA);
-
-	if (!rec->opts.branch_stack)
-		perf_header__clear_feat(&session->header, HEADER_BRANCH_STACK);
+	perf_record__init_features(rec);
 
 	if (forks) {
 		err = perf_evlist__prepare_workload(evsel_list, &opts->target,
-- 
1.8.1.4

