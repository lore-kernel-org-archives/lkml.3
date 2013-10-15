Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933590Ab3JOFfa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:35:30 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932603Ab3JOFfY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:35:24 -0400
Date: Mon, 14 Oct 2013 22:35:05 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-9a17d7268d71674f0bbff6821f7d8e6dc0ece19a@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381747424-3557-5-git-send-email-adrian.hunter@intel.com>
References: <1381747424-3557-5-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Add copyfile_mode()
Git-Commit-ID: 9a17d7268d71674f0bbff6821f7d8e6dc0ece19a
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:35:11 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  9a17d7268d71674f0bbff6821f7d8e6dc0ece19a
Gitweb:     http://git.kernel.org/tip/9a17d7268d71674f0bbff6821f7d8e6dc0ece19a
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Mon, 14 Oct 2013 13:43:41 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Mon, 14 Oct 2013 10:29:23 -0300

perf tools: Add copyfile_mode()

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
index ab71d62..8dc8cf3 100644
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
