Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758072Ab3K1KbG (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:31:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:65009 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757829Ab3K1Ka7 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:30:59 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 1/7] perf record: Unify data output code into perf_record__write function
Date: Thu, 28 Nov 2013 11:30:13 +0100
Message-Id: <1385634619-8129-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Unifying current 2 data output functions do_write_output
and write_output into single one perf_record__write.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 20 ++++++--------------
 1 file changed, 6 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 65615a8..d93e2ee 100644
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
1.8.3.1

