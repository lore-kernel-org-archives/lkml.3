Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755018Ab3LTTJt (ORCPT <rfc822;w@1wt.eu>);
	Fri, 20 Dec 2013 14:09:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:38461 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751201Ab3LTTJ2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 20 Dec 2013 14:09:28 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 14/35] perf record: Use perf_data_file__write for output file
Date: Fri, 20 Dec 2013 16:08:49 -0300
Message-Id: <1387566550-3524-15-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387566550-3524-1-git-send-email-acme@infradead.org>
References: <1387566550-3524-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Changing the file output code to use the newly
added perf_data_file__write interface.

No functional change intended.

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
 tools/perf/builtin-record.c | 23 +++++++++--------------
 1 file changed, 9 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index c1c1200d2f0a..8eed3d752c80 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,24 +76,19 @@ struct perf_record {
 	long			samples;
 };
 
-static int perf_record__write(struct perf_record *rec, void *buf, size_t size)
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
+	ret = perf_data_file__write(session->file, buf, size);
+	if (ret < 0) {
+		pr_err("failed to write perf data, error: %m\n");
+		return -1;
 	}
 
+	rec->bytes_written += ret;
 	return 0;
 }
 
-- 
1.8.1.4

