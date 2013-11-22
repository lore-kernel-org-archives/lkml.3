Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755772Ab3KVOZM (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:25:12 -0500
Received: from mx1.redhat.com ([209.132.183.28]:10453 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755339Ab3KVOZL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:25:11 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 2/3] perf record: Use perf_data_file__write for output file
Date: Fri, 22 Nov 2013 15:24:27 +0100
Message-Id: <1385130268-10664-3-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Changing the file output code to use the newly
added perf_data_file__write interface.

No functional change intended.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/builtin-record.c | 42 +++++++++++++-----------------------------
 1 file changed, 13 insertions(+), 29 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 65615a8..bc3c7be 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,42 +76,27 @@ struct perf_record {
 	long			samples;
 };
 
-static int do_write_output(struct perf_record *rec, void *buf, size_t size)
+static ssize_t perf_record__write(struct perf_record *rec,
+				  void *buf, size_t size)
 {
-	struct perf_data_file *file = &rec->file;
-
-	while (size) {
-		ssize_t ret = write(file->fd, buf, size);
-
-		if (ret < 0) {
-			pr_err("failed to write perf data, error: %m\n");
-			return -1;
-		}
-
-		size -= ret;
-		buf += ret;
+	struct perf_session *session = rec->session;
+	ssize_t ret;
 
-		rec->bytes_written += ret;
-	}
+	ret = perf_data_file__write(session->file, buf, size);
+	if (ret < 0)
+		return -1;
 
+	rec->bytes_written += ret;
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
@@ -136,7 +121,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		if (write_output(rec, buf, size) < 0) {
+		if (perf_record__write(rec, buf, size) < 0) {
 			rc = -1;
 			goto out;
 		}
@@ -146,7 +131,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 	size = head - old;
 	old += size;
 
-	if (write_output(rec, buf, size) < 0) {
+	if (perf_record__write(rec, buf, size) < 0) {
 		rc = -1;
 		goto out;
 	}
@@ -322,8 +307,7 @@ static struct perf_event_header finished_round_event = {
 
 static int perf_record__mmap_read_all(struct perf_record *rec)
 {
-	int i;
-	int rc = 0;
+	int i, rc = 0;
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
 		if (rec->evlist->mmap[i].base) {
@@ -335,7 +319,7 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 	}
 
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
-		rc = write_output(rec, &finished_round_event,
+		rc = perf_record__write(rec, &finished_round_event,
 				  sizeof(finished_round_event));
 
 out:
-- 
1.8.3.1

