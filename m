Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754991Ab3ILQkP (ORCPT <rfc822;w@1wt.eu>);
	Thu, 12 Sep 2013 12:40:15 -0400
Received: from mx1.redhat.com ([209.132.183.28]:50967 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754957Ab3ILQkL (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 12 Sep 2013 12:40:11 -0400
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        David Ahern <dsahern@gmail.com>
Subject: [PATCH 3/4] perf tools: Unify page_size usage
Date: Thu, 12 Sep 2013 18:39:35 +0200
Message-Id: <1379003976-5839-4-git-send-email-jolsa@redhat.com>
In-Reply-To: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
References: <1379003976-5839-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Making page_size global from the util object.
Removing the not needed one.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: David Ahern <dsahern@gmail.com>
---
 tools/perf/builtin-record.c | 5 +----
 tools/perf/perf.c           | 1 +
 tools/perf/util/python.c    | 1 +
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index a41ac415..ceea545 100644
--- a/tools/perf/builtin-record.c
+++ b/tools/perf/builtin-record.c
@@ -70,7 +70,6 @@ struct perf_record {
 	struct perf_session	*session;
 	const char		*progname;
 	int			output;
-	unsigned int		page_size;
 	int			realtime_prio;
 	bool			no_buildid;
 	bool			no_buildid_cache;
@@ -119,7 +118,7 @@ static int perf_record__mmap_read(struct perf_record *rec,
 {
 	unsigned int head = perf_mmap__read_head(md);
 	unsigned int old = md->prev;
-	unsigned char *data = md->base + rec->page_size;
+	unsigned char *data = md->base + page_size;
 	unsigned long size;
 	void *buf;
 	int rc = 0;
@@ -360,8 +359,6 @@ static int __cmd_record(struct perf_record *rec, int argc, const char **argv)
 
 	rec->progname = argv[0];
 
-	rec->page_size = sysconf(_SC_PAGE_SIZE);
-
 	on_exit(perf_record__sig_exit, rec);
 	signal(SIGCHLD, sig_handler);
 	signal(SIGINT, sig_handler);
diff --git a/tools/perf/perf.c b/tools/perf/perf.c
index 85e1aed..6f0a209 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -456,6 +456,7 @@ int main(int argc, const char **argv)
 {
 	const char *cmd;
 
+	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 3eddf96..06efd02 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1029,6 +1029,7 @@ PyMODINIT_FUNC initperf(void)
 	    pyrf_cpu_map__setup_types() < 0)
 		return;
 
+	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	Py_INCREF(&pyrf_evlist__type);
-- 
1.7.11.7

