Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755865Ab3KVOZV (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Nov 2013 09:25:21 -0500
Received: from mx1.redhat.com ([209.132.183.28]:15809 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755777Ab3KVOZO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Nov 2013 09:25:14 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        Stephane Eranian <eranian@google.com>, David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>
Subject: [PATCH 1/3] perf tools: Add perf_data_file__write interface
Date: Fri, 22 Nov 2013 15:24:26 +0100
Message-Id: <1385130268-10664-2-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
References: <1385130268-10664-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding perf_data_file__write interface to centralize
output to files. The function prototype is:

  ssize_t perf_data_file__write(struct perf_data_file *file,
                                void *buf, size_t size);

Returns number of bytes written or -1 in case of error.

NOTE Indenting 'struct perf_data_file' members,
     no functional change done.

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
 tools/perf/util/data.c | 20 ++++++++++++++++++++
 tools/perf/util/data.h | 15 ++++++++-------
 2 files changed, 28 insertions(+), 7 deletions(-)

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
1.8.3.1

