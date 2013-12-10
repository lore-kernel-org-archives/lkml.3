Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753619Ab3LJJTJ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 10 Dec 2013 04:19:09 -0500
Received: from terminus.zytor.com ([198.137.202.10]:44269 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753348Ab3LJJTB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 10 Dec 2013 04:19:01 -0500
Date: Tue, 10 Dec 2013 01:18:34 -0800
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-cef82c9f5a3deab94c1f1f02cfc25213844852ed@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        rostedt@goodmis.org, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com, mingo@elte.hu
In-Reply-To: <1386076182-14484-9-git-send-email-jolsa@redhat.com>
References: <1386076182-14484-9-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add filename__read_str util function
Git-Commit-ID: cef82c9f5a3deab94c1f1f02cfc25213844852ed
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Tue, 10 Dec 2013 01:18:40 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  cef82c9f5a3deab94c1f1f02cfc25213844852ed
Gitweb:     http://git.kernel.org/tip/cef82c9f5a3deab94c1f1f02cfc25213844852ed
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Tue, 3 Dec 2013 14:09:22 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 4 Dec 2013 15:20:12 -0300

perf tools: Add filename__read_str util function

Adding filename__read_str util function to read
text file and return it in the char array.

The interface is:
  int filename__read_str(const char *filename, char **buf, size_t *sizep)

  Returns 0/-1 if the read suceeded/fail respectively.

  buf  - place to store the data pointer
  size - place to store data size

v2 change:
  - better error handling suggested by Namhyung Kim.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Steven Rostedt <rostedt@goodmis.org>
Link: http://lkml.kernel.org/r/1386076182-14484-9-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 49 +++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h |  1 +
 2 files changed, 50 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index b1d5376..bae8756 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -6,6 +6,8 @@
 #endif
 #include <stdio.h>
 #include <stdlib.h>
+#include <string.h>
+#include <errno.h>
 #include <linux/kernel.h>
 
 /*
@@ -433,3 +435,50 @@ int filename__read_int(const char *filename, int *value)
 	close(fd);
 	return err;
 }
+
+int filename__read_str(const char *filename, char **buf, size_t *sizep)
+{
+	size_t size = 0, alloc_size = 0;
+	void *bf = NULL, *nbf;
+	int fd, n, err = 0;
+
+	fd = open(filename, O_RDONLY);
+	if (fd < 0)
+		return -errno;
+
+	do {
+		if (size == alloc_size) {
+			alloc_size += BUFSIZ;
+			nbf = realloc(bf, alloc_size);
+			if (!nbf) {
+				err = -ENOMEM;
+				break;
+			}
+
+			bf = nbf;
+		}
+
+		n = read(fd, bf + size, alloc_size - size);
+		if (n < 0) {
+			if (size) {
+				pr_warning("read failed %d: %s\n",
+					   errno, strerror(errno));
+				err = 0;
+			} else
+				err = -errno;
+
+			break;
+		}
+
+		size += n;
+	} while (n > 0);
+
+	if (!err) {
+		*sizep = size;
+		*buf   = bf;
+	} else
+		free(bf);
+
+	close(fd);
+	return err;
+}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index ce0f73d..adb39f2 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -308,4 +308,5 @@ char *get_srcline(struct dso *dso, unsigned long addr);
 void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
+int filename__read_str(const char *filename, char **buf, size_t *sizep);
 #endif /* GIT_COMPAT_UTIL_H */
