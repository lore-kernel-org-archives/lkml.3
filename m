Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758569Ab3LBUt1 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:49:27 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54068 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757308Ab3LBUtU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 2 Dec 2013 15:49:20 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/12] perf record: Unify data output code into perf_record__write function
Date: Mon,  2 Dec 2013 17:48:58 -0300
Message-Id: <1386017349-24486-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Unifying current 2 data output functions do_write_output and
write_output into single one perf_record__write.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1385634619-8129-2-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 65615a8bc25e..d93e2eef0979 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,7 +76,7 @@ struct perf_record {
 	long			samples;
 };
 
-static int do_write_output(struct perf_record *rec, void *buf, size_t size)
+static int perf_record__write(struct perf_record *rec, void *buf, size_t size)
 {
 	struct perf_data_file *file = &rec->file;
 
@@ -97,21 +97,13 @@ static int do_write_output(struct perf_record *rec, void *buf, size_t size)
 	return 0;
 }
 
-static int write_output(struct perf_record *rec, void *buf, size_t size)
-{
-	return do_write_output(rec, buf, size);
-}
-
 static int process_synthesized_event(struct perf_tool *tool,
 				     union perf_event *event,
 				     struct perf_sample *sample __maybe_unused,
 				     struct machine *machine __maybe_unused)
 {
 	struct perf_record *rec = container_of(tool, struct perf_record, tool);
-	if (write_output(rec, event, event->header.size) < 0)
-		return -1;
-
-	return 0;
+	return perf_record__write(rec, event, event->header.size);
 }
 
 static int perf_record__mmap_read(struct perf_record *rec,
@@ -136,7 +128,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		if (write_output(rec, buf, size) < 0) {
+		if (perf_record__write(rec, buf, size) < 0) {
 			rc = -1;
 			goto out;
 		}
@@ -146,7 +138,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 	size = head - old;
 	old += size;
 
-	if (write_output(rec, buf, size) < 0) {
+	if (perf_record__write(rec, buf, size) < 0) {
 		rc = -1;
 		goto out;
 	}
@@ -335,8 +327,8 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 	}
 
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
-		rc = write_output(rec, &finished_round_event,
-				  sizeof(finished_round_event));
+		rc = perf_record__write(rec, &finished_round_event,
+					sizeof(finished_round_event));
 
 out:
 	return rc;
-- 
1.8.1.4

