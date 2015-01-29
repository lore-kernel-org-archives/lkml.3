Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752983AbbA2IKI (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 Jan 2015 03:10:08 -0500
Received: from LGEMRELSE6Q.lge.com ([156.147.1.121]:51025 "EHLO
	lgemrelse6q.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752599AbbA2IKB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 Jan 2015 03:10:01 -0500
X-Original-SENDERIP: 10.177.220.203
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Ingo Molnar <mingo@kernel.org>, Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Jiri Olsa <jolsa@redhat.com>, LKML <linux-kernel@vger.kernel.org>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Andi Kleen <andi@firstfloor.org>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>
Subject: [PATCH 08/42] perf tools: Add rm_rf() utility function
Date: Thu, 29 Jan 2015 17:06:49 +0900
Message-Id: <1422518843-25818-9-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.2.2
In-Reply-To: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
References: <1422518843-25818-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The rm_rf() function does same as the shell command 'rm -rf' which
removes all directory entries recursively.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/util.c | 43 +++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/util.h |  1 +
 2 files changed, 44 insertions(+)

diff --git a/tools/perf/util/util.c b/tools/perf/util/util.c
index b86744f29eef..de1307a6ff4b 100644
--- a/tools/perf/util/util.c
+++ b/tools/perf/util/util.c
@@ -72,6 +72,49 @@ int mkdir_p(char *path, mode_t mode)
 	return (stat(path, &st) && mkdir(path, mode)) ? -1 : 0;
 }
 
+int rm_rf(char *path)
+{
+	DIR *dir;
+	int ret = 0;
+	struct dirent *d;
+	char namebuf[PATH_MAX];
+
+	dir = opendir(path);
+	if (dir == NULL)
+		return 0;
+
+	while ((d = readdir(dir)) != NULL && !ret) {
+		struct stat statbuf;
+
+		if (!strcmp(d->d_name, ".") || !strcmp(d->d_name, ".."))
+			continue;
+
+		scnprintf(namebuf, sizeof(namebuf), "%s/%s",
+			  path, d->d_name);
+
+		ret = stat(namebuf, &statbuf);
+		if (ret < 0) {
+			pr_debug("stat failed: %s\n", namebuf);
+			break;
+		}
+
+		if (S_ISREG(statbuf.st_mode))
+			ret = unlink(namebuf);
+		else if (S_ISDIR(statbuf.st_mode))
+			ret = rm_rf(namebuf);
+		else {
+			pr_debug("unknown file: %s\n", namebuf);
+			ret = -1;
+		}
+	}
+	closedir(dir);
+
+	if (ret < 0)
+		return ret;
+
+	return rmdir(path);
+}
+
 static int slow_copyfile(const char *from, const char *to, mode_t mode)
 {
 	int err = -1;
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 027a5153495c..7b71ad87cdc3 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -248,6 +248,7 @@ static inline int sane_case(int x, int high)
 }
 
 int mkdir_p(char *path, mode_t mode);
+int rm_rf(char *path);
 int copyfile(const char *from, const char *to);
 int copyfile_mode(const char *from, const char *to, mode_t mode);
 
-- 
2.2.2

