Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758290Ab3K1KcE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:32:04 -0500
Received: from mx1.redhat.com ([209.132.183.28]:61339 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757807Ab3K1KbF (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:31:05 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 6/7] perf record: Use perf_data_file__write for output file
Date: Thu, 28 Nov 2013 11:30:18 +0100
Message-Id: <1385634619-8129-7-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
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
Cc: David Ahern <dsahern@gmail.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index d93e2ee..1be39e2 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -76,24 +76,17 @@ struct perf_record {
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
-	}
+	ret = perf_data_file__write(session->file, buf, size);
+	if (ret < 0)
+		return -1;
 
+	rec->bytes_written += ret;
 	return 0;
 }
 
-- 
1.8.3.1

