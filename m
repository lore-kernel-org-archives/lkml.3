Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757667Ab3KHQlw (ORCPT <rfc822;w@1wt.eu>);
	Fri, 8 Nov 2013 11:41:52 -0500
Received: from mail-pa0-f52.google.com ([209.85.220.52]:42588 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757335Ab3KHQlv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 8 Nov 2013 11:41:51 -0500
From: David Ahern <dsahern@gmail.com>
To: acme@ghostprotocols.net, linux-kernel@vger.kernel.org
Cc: David Ahern <dsahern@gmail.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH] perf record: Delete file if a failure occurs writing the perf data file
Date: Fri,  8 Nov 2013 09:41:46 -0700
Message-Id: <1383928906-31470-1-git-send-email-dsahern@gmail.com>
X-Mailer: git-send-email 1.8.3.4 (Apple Git-47)
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If perf fails to write data to the data file (e.g., ENOSPC error) it fails
with the message:
  failed to write perf data, error: No space left on device

and stops — killing the workload too. The file is an unknown state. Trying
to read it (e.g., perf report) fails with a SIGBUS error.

Fix by deleting the file on a failure.

Signed-off-by: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/builtin-record.c | 1 +
 tools/perf/util/data.c      | 5 +++++
 tools/perf/util/data.h      | 1 +
 3 files changed, 7 insertions(+)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index 15280b5e5574..8b8944d8ffea 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -562,6 +562,7 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 out_delete_session:
 	perf_session__delete(session);
+	perf_data_file__unlink(session->file);
 	return err;
 }
 
diff --git a/tools/perf/util/data.c b/tools/perf/util/data.c
index 7d09faf85cf1..a0315a694fa2 100644
--- a/tools/perf/util/data.c
+++ b/tools/perf/util/data.c
@@ -118,3 +118,8 @@ void perf_data_file__close(struct perf_data_file *file)
 {
 	close(file->fd);
 }
+
+void perf_data_file__unlink(struct perf_data_file *file)
+{
+	unlink(file->path);
+}
diff --git a/tools/perf/util/data.h b/tools/perf/util/data.h
index 8c2df80152a5..f55a04295ab6 100644
--- a/tools/perf/util/data.h
+++ b/tools/perf/util/data.h
@@ -44,5 +44,6 @@ static inline unsigned long perf_data_file__size(struct perf_data_file *file)
 
 int perf_data_file__open(struct perf_data_file *file);
 void perf_data_file__close(struct perf_data_file *file);
+void perf_data_file__unlink(struct perf_data_file *file);
 
 #endif /* __PERF_DATA_H */
-- 
1.8.3.4 (Apple Git-47)

