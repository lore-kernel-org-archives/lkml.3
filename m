Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752651AbaFMG0m (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Jun 2014 02:26:42 -0400
Received: from terminus.zytor.com ([198.137.202.10]:44184 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751960AbaFMG0j (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Jun 2014 02:26:39 -0400
Date: Thu, 12 Jun 2014 23:26:22 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-a08cae03f430b971afa508a32662dc476d42d8cb@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, paulus@samba.org, hpa@zytor.com,
        mingo@kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, jolsa@kernel.org, a.p.zijlstra@chello.nl,
        jean.pihet@linaro.org, acme@kernel.org, namhyung@kernel.org,
        fweisbec@gmail.com, dsahern@gmail.com, tglx@linutronix.de,
        cjashfor@linux.vnet.ibm.com
In-Reply-To: <1401892622-30848-9-git-send-email-jolsa@kernel.org>
References: <1401892622-30848-9-git-send-email-jolsa@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow to close dso fd in case of open failure
Git-Commit-ID: a08cae03f430b971afa508a32662dc476d42d8cb
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  a08cae03f430b971afa508a32662dc476d42d8cb
Gitweb:     http://git.kernel.org/tip/a08cae03f430b971afa508a32662dc476d42d8cb
Author:     Jiri Olsa <jolsa@kernel.org>
AuthorDate: Wed, 7 May 2014 21:35:02 +0200
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Thu, 12 Jun 2014 16:53:21 +0200

perf tools: Allow to close dso fd in case of open failure

Adding do_open function that tries to close opened
dso objects in case we fail to open the dso due to
to crossing the allowed RLIMIT_NOFILE limit.

Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1401892622-30848-9-git-send-email-jolsa@kernel.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index db63438..c30752c 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -159,6 +159,27 @@ static void dso__list_del(struct dso *dso)
 	dso__data_open_cnt--;
 }
 
+static void close_first_dso(void);
+
+static int do_open(char *name)
+{
+	int fd;
+
+	do {
+		fd = open(name, O_RDONLY);
+		if (fd >= 0)
+			return fd;
+
+		pr_debug("dso open failed, mmap: %s\n", strerror(errno));
+		if (!dso__data_open_cnt || errno != EMFILE)
+			break;
+
+		close_first_dso();
+	} while (1);
+
+	return -1;
+}
+
 static int __open_dso(struct dso *dso, struct machine *machine)
 {
 	int fd;
@@ -177,7 +198,7 @@ static int __open_dso(struct dso *dso, struct machine *machine)
 		return -EINVAL;
 	}
 
-	fd = open(name, O_RDONLY);
+	fd = do_open(name);
 	free(name);
 	return fd;
 }
