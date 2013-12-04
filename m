Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933403Ab3LDUHf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 4 Dec 2013 15:07:35 -0500
Received: from merlin.infradead.org ([205.233.59.134]:59407 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab3LDUHW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 4 Dec 2013 15:07:22 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Steven Rostedt <rostedt@goodmis.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/38] perf tools: Add filename__read_str util function
Date: Wed,  4 Dec 2013 17:06:43 -0300
Message-Id: <1386187622-2928-20-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1386187622-2928-1-git-send-email-acme@infradead.org>
References: <1386187622-2928-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

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
index b1d5376b9dd9..bae8756a4eb1 100644
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
index ce0f73d4d91f..adb39f251f90 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -308,4 +308,5 @@ char *get_srcline(struct dso *dso, unsigned long addr);
 void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
+int filename__read_str(const char *filename, char **buf, size_t *sizep);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.1.4

