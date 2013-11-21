Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754491Ab3KULCp (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Nov 2013 06:02:45 -0500
Received: from mx1.redhat.com ([209.132.183.28]:12805 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754462Ab3KULCm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Nov 2013 06:02:42 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Steven Rostedt <rostedt@goodmis.org>, David Ahern <dsahern@gmail.com>
Subject: [PATCH 19/22] perf tools: Add filename__read_str util function
Date: Thu, 21 Nov 2013 12:01:17 +0100
Message-Id: <1385031680-9014-20-git-send-email-jolsa@redhat.com>
In-Reply-To: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
References: <1385031680-9014-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding filename__read_str util function to read
text file and return it in the char array.

The interface is:
  int filename__read_str(const char *filename, char **buf, size_t *sizep)

  Returns 0/-1 if the read suceeded/fail respectively.

  buf  - place to store the data pointer
  size - place to store data size

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/util/util.c | 41 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h |  1 +
 2 files changed, 42 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 28a0a89..e96cc90 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -413,3 +413,44 @@ int filename__read_int(const char *filename, int *value)
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
+		n = read(fd, bf + size, BUFSIZ);
+		if (n < 0) {
+			err = 0;
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
index c8f362d..e54bb10 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -307,4 +307,5 @@ char *get_srcline(struct dso *dso, unsigned long addr);
 void free_srcline(char *srcline);
 
 int filename__read_int(const char *filename, int *value);
+int filename__read_str(const char *filename, char **buf, size_t *sizep);
 #endif /* GIT_COMPAT_UTIL_H */
-- 
1.8.3.1

