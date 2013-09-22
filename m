Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753233Ab3IVKQR (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:16:17 -0400
Received: from mga01.intel.com ([192.55.52.88]:37121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3IVKQO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:16:14 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,956,1371106800"; 
   d="scan'208";a="405354138"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 08/10] perf tools: add copyfile_mode()
Date: Sun, 22 Sep 2013 13:22:16 +0300
Message-Id: <1379845338-29637-9-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
References: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Add a function to copy a file specifying the
permissions to use for the created file.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/util.c | 18 +++++++++++++-----
 tools/perf/util/util.h |  1 +
 2 files changed, 14 insertions(+), 5 deletions(-)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index 141317e..2d6c42c 100644
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
index 1f06ba4..42dfba7 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -243,6 +243,7 @@ static inline int sane_case(int x, int high)
 
 int mkdir_p(char *path, mode_t mode);
 int copyfile(const char *from, const char *to);
+int copyfile_mode(const char *from, const char *to, mode_t mode);
 
 s64 perf_atoll(const char *str);
 char **argv_split(const char *str, int *argcp);
-- 
1.7.11.7

