Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753800Ab3KDSc0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Nov 2013 13:32:26 -0500
Received: from mx1.redhat.com ([209.132.183.28]:33691 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752187Ab3KDScX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Nov 2013 13:32:23 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/2] perf tools: Add perf_data__write implementation into perf_data_file object
Date: Mon,  4 Nov 2013 19:31:44 +0100
Message-Id: <1383589905-10208-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
References: <1383589905-10208-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_data__write implementation into perf_data_file
object. This interface is now used within record command
to store data.

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
 tools/perf/builtin-record.c | 38 ++++++++++++++------------------------
 tools/perf/util/data.c      | 20 ++++++++++++++++++++
 tools/perf/util/data.h      | 15 ++++++++-------
 3 files changed, 42 insertions(+), 31 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index ab8d15e..5201677 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -82,24 +82,17 @@ static void advance_output(struct perf_record *rec, size_t size)
 	rec->bytes_written += size;
 }
 
-static int write_output(struct perf_record *rec, void *buf, size_t size)
+static ssize_t perf_record__write(struct perf_record *rec,
+				  void *buf, size_t size)
 {
-	struct perf_data_file *file = &rec->file;
-
-	while (size) {
-		int ret = write(file->fd, buf, size);
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
 
@@ -109,10 +102,7 @@ static int process_synthesized_event(struct perf_tool *tool,
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
@@ -137,7 +127,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 		size = md->mask + 1 - (old & md->mask);
 		old += size;
 
-		if (write_output(rec, buf, size) < 0) {
+		if (perf_record__write(rec, buf, size) < 0) {
 			rc = -1;
 			goto out;
 		}
@@ -147,7 +137,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 	size = head - old;
 	old += size;
 
-	if (write_output(rec, buf, size) < 0) {
+	if (perf_record__write(rec, buf, size) < 0) {
 		rc = -1;
 		goto out;
 	}
@@ -322,8 +312,8 @@ static struct perf_event_header finished_round_event = {
 
 static int perf_record__mmap_read_all(struct perf_record *rec)
 {
-	int i;
-	int rc = 0;
+	struct perf_session *session = rec->session;
+	int i, rc = 0;
 
 	for (i = 0; i < rec->evlist->nr_mmaps; i++) {
 		if (rec->evlist->mmap[i].base) {
@@ -335,7 +325,7 @@ static int perf_record__mmap_read_all(struct perf_record *rec)
 	}
 
 	if (perf_header__has_feat(&rec->session->header, HEADER_TRACING_DATA))
-		rc = write_output(rec, &finished_round_event,
+		rc = perf_data_file__write(session->file, &finished_round_event,
 				  sizeof(finished_round_event));
 
 out:
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 7d09faf..cce1256 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -118,3 +118,23 @@ void perf_data_file__close(struct perf_data_file *file)
 {
 	close(file->fd);
 }
+
+ssize_t perf_data_file__write(struct perf_data_file *file,
+			      void *buf, size_t size)
+{
+	ssize_t total = size;
+
+	while (size) {
+		ssize_t ret = write(file->fd, buf, size);
+
+		if (ret < 0) {
+			pr_err("failed to write perf data, error: %m\n");
+			return -1;
+		}
+
+		size -= ret;
+		buf  += ret;
+	}
+
+	return total;
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 8c2df80..02c53dc 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -9,12 +9,12 @@ enum perf_data_mode {
 };
 
 struct perf_data_file {
-	const char *path;
-	int fd;
-	bool is_pipe;
-	bool force;
-	unsigned long size;
-	enum perf_data_mode mode;
+	const char		*path;
+	int			 fd;
+	bool			 is_pipe;
+	bool			 force;
+	unsigned long		 size;
+	enum perf_data_mode	 mode;
 };
 
 static inline bool perf_data_file__is_read(struct perf_data_file *file)
@@ -44,5 +44,6 @@ static inline unsigned long perf_data_file__size(struct perf_data_file *file)
 
 int perf_data_file__open(struct perf_data_file *file);
 void perf_data_file__close(struct perf_data_file *file);
-
+ssize_t perf_data_file__write(struct perf_data_file *file,
+			      void *buf, size_t size);
 #endif /* __PERF_DATA_H */
-- 
1.7.11.7

