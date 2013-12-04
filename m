Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932845Ab3LDPlQ (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 10:41:16 -0500
Received: from terminus.zytor.com ([198.137.202.10]:58271 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932404Ab3LDPlJ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 10:41:09 -0500
Date: Wed, 4 Dec 2013 07:40:32 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-bc3a502bc2bc78d03526d6abcc5697aab18d5ae9@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, acme@redhat.com, hpa@zytor.com,
        mingo@kernel.org, peterz@infradead.org, efault@gmx.de,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        adrian.hunter@intel.com, dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, acme@redhat.com,
        linux-kernel@vger.kernel.org, efault@gmx.de, peterz@infradead.org,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1385634619-8129-5-git-send-email-jolsa@redhat.com>
References: <1385634619-8129-5-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add writen function
Git-Commit-ID: bc3a502bc2bc78d03526d6abcc5697aab18d5ae9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Wed, 04 Dec 2013 07:40:38 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  bc3a502bc2bc78d03526d6abcc5697aab18d5ae9
Gitweb:     http://git.kernel.org/tip/bc3a502bc2bc78d03526d6abcc5697aab18d5ae9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 28 Nov 2013 11:30:16 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 2 Dec 2013 09:22:46 -0300

perf tools: Add writen function

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
 
