Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932248Ab3LBUwX (ORCPT <rfc822;w@1wt.eu>);
	Mon, 2 Dec 2013 15:52:23 -0500
Received: from merlin.infradead.org ([205.233.59.134]:54072 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758548Ab3LBUtU (ORCPT
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
Subject: [PATCH 04/12] perf tools: Add writen function
Date: Mon,  2 Dec 2013 17:49:01 -0300
Message-Id: <1386017349-24486-5-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386017349-24486-1-git-send-email-acme@infradead.org>
References: <1386017349-24486-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Adding 'writen' function as a synchronous wrapper for write syscall with
following prototype:

  ssize_t writen(int fd, void *buf, size_t n)

Returns the number of bytes written on success or -1 in case of err.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Requested-by: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1385634619-8129-5-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 24 +++++++++++++++++++-----
 tools/perf/util/util.h |  1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 6ea0b4ae9569..b1d5376b9dd9 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -152,16 +152,14 @@ unsigned long convert_unit(unsigned long value, char *unit)
 	return value;
 }
 
-/*
- * Read exactly 'n' bytes or return an error.
- */
-ssize_t readn(int fd, void *buf, size_t n)
+static ssize_t ion(bool is_read, int fd, void *buf, size_t n)
 {
 	void *buf_start = buf;
 	size_t left = n;
 
 	while (left) {
-		ssize_t ret = read(fd, buf, left);
+		ssize_t ret = is_read ? read(fd, buf, left) :
+					write(fd, buf, left);
 
 		if (ret <= 0)
 			return ret;
@@ -174,6 +172,22 @@ ssize_t readn(int fd, void *buf, size_t n)
 	return n;
 }
 
+/*
+ * Read exactly 'n' bytes or return an error.
+ */
+ssize_t readn(int fd, void *buf, size_t n)
+{
+	return ion(true, fd, buf, n);
+}
+
+/*
+ * Write exactly 'n' bytes or return an error.
+ */
+ssize_t writen(int fd, void *buf, size_t n)
+{
+	return ion(false, fd, buf, n);
+}
+
 size_t hex_width(u64 v)
 {
 	size_t n = 1;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 9f6b928f6b2b..ce0f73d4d91f 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -254,6 +254,7 @@ int strtailcmp(const char *s1, const char *s2);
 char *strxfrchar(char *s, char from, char to);
 unsigned long convert_unit(unsigned long value, char *unit);
 ssize_t readn(int fd, void *buf, size_t n);
+ssize_t writen(int fd, void *buf, size_t n);
 
 struct perf_event_attr;
 
-- 
1.8.1.4

