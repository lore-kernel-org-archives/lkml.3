Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758177Ab3JNUJP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:09:15 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39326 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757234Ab3JNUHq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:07:46 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 155/161] perf tools: Add copyfile_mode()
Date: Mon, 14 Oct 2013 17:02:24 -0300
Message-Id: <1381780950-25642-156-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Add a function to copy a file specifying the permissions to use for the
created file.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381747424-3557-5-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/util.c | 18 +++++++++++++-----
 tools/perf/util/util.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index ab71d6216803..8dc8cf39f4ed 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -55,17 +55,20 @@ int mkdir_p(char *path, mode_t mode)
 	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
 }
 
-static int slow_copyfile(const char *from, const char *to)
+static int slow_copyfile(const char *from, const char *to, mode_t mode)
 {
-	int err = 0;
+	int err = -1;
 	char *line = NULL;
 	size_t n;
 	FILE *from_fp = fopen(from, "r"), *to_fp;
+	mode_t old_umask;
 
 	if (from_fp == NULL)
 		goto out;
 
+	old_umask = umask(mode ^ 0777);
 	to_fp = fopen(to, "w");
+	umask(old_umask);
 	if (to_fp == NULL)
 		goto out_fclose_from;
 
@@ -82,7 +85,7 @@ out:
 	return err;
 }
 
-int copyfile(const char *from, const char *to)
+int copyfile_mode(const char *from, const char *to, mode_t mode)
 {
 	int fromfd, tofd;
 	struct stat st;
@@ -93,13 +96,13 @@ int copyfile(const char *from, const char *to)
 		goto out;
 
 	if (st.st_size == 0) /* /proc? do it slowly... */
-		return slow_copyfile(from, to);
+		return slow_copyfile(from, to, mode);
 
 	fromfd = open(from, O_RDONLY);
 	if (fromfd < 0)
 		goto out;
 
-	tofd = creat(to, 0755);
+	tofd = creat(to, mode);
 	if (tofd < 0)
 		goto out_close_from;
 
@@ -121,6 +124,11 @@ out:
 	return err;
 }
 
+int copyfile(const char *from, const char *to)
+{
+	return copyfile_mode(from, to, 0755);
+}
+
 unsigned long convert_unit(unsigned long value, char *unit)
 {
 	*unit = ' ';
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 1f06ba44cd53..42dfba70fbfc 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -243,6 +243,7 @@ static inline int sane_case(int x, int high)
 
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
+int copyfile_mode(const char *from, const char *to, mode_t mode);
 
 s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
-- 
1.8.1.4

