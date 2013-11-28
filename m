Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758141Ab3K1KbJ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Nov 2013 05:31:09 -0500
Received: from mx1.redhat.com ([209.132.183.28]:28312 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1757724Ab3K1KbG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Nov 2013 05:31:06 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Ingo Molnar <mingo@kernel.org>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Namhyung Kim <namhyung@kernel.org>, Mike Galbraith <efault@gmx.de>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 4/7] perf tools: Add writen function
Date: Thu, 28 Nov 2013 11:30:16 +0100
Message-Id: <1385634619-8129-5-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding 'writen' function as a synchronous wrapper
for write syscall with following prototype:

  ssize_t writen(int fd, void *buf, size_t n)

Returns the number of bytes written on success
or -1 in case of err.

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
 tools/perf/util/util.c | 24 +++++++++++++++++++-----
 tools/perf/util/util.h |  1 +
 2 files changed, 20 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 6ea0b4a..b1d5376 100644
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
index 9f6b928..ce0f73d 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -254,6 +254,7 @@ int strtailcmp(const char *s1, const char *s2);
 char *strxfrchar(char *s, char from, char to);
 unsigned long convert_unit(unsigned long value, char *unit);
 ssize_t readn(int fd, void *buf, size_t n);
+ssize_t writen(int fd, void *buf, size_t n);
 
 struct perf_event_attr;
 
-- 
1.8.3.1

