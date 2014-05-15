Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755505AbaEOR0a (ORCPT <rfc822;w@1wt.eu>);
	Thu, 15 May 2014 13:26:30 -0400
Received: from mx1.redhat.com ([209.132.183.28]:5828 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753105AbaEORYI (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 15 May 2014 13:24:08 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Jean Pihet <jean.pihet@linaro.org>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>
Subject: [PATCH 08/14] perf tools: Allow to close dso fd in case of open failure
Date: Thu, 15 May 2014 19:23:29 +0200
Message-Id: <1400174615-2121-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
References: <1400174615-2121-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding do_open function that tries to close opened
dso objects in case we fail to open the dso due to
to crossing the allowed RLIMIT_NOFILE limit.

Cc: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jean Pihet <jean.pihet@linaro.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/util/dso.c | 23 ++++++++++++++++++++++-
 1 file changed, 22 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index ad0e2da..7404f67 100644
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
-- 
1.8.3.1

