Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932859Ab3JNU0t (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:26:49 -0400
Received: from merlin.infradead.org ([205.233.59.134]:38923 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757666Ab3JNUDE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:04 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Jiri Olsa <jolsa@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 078/161] perf tools: Unify page_size usage
Date: Mon, 14 Oct 2013 17:01:07 -0300
Message-Id: <1381780950-25642-79-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jiri Olsa <jolsa@redhat.com>

Making page_size global from the util object.

Removing the not needed one.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1379003976-5839-4-git-send-email-jolsa@redhat.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-record.c | 5 +----
 tools/perf/perf.c           | 1 +
 tools/perf/util/python.c    | 1 +
 3 files changed, 3 insertions(+), 4 deletions(-)

diff --git a/tools/perf/builtin-record.c b/tools/perf/builtin-record.c
index cf36ba2a1591..0aacd6295fe6 100644
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
index 245020cc6180..626577830264 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -456,6 +456,7 @@ int main(int argc, const char **argv)
 {
 	const char *cmd;
 
+	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 71b5412bbbb9..a24ce0a6a941 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1036,6 +1036,7 @@ PyMODINIT_FUNC initperf(void)
 	    pyrf_cpu_map__setup_types() < 0)
 		return;
 
+	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	Py_INCREF(&pyrf_evlist__type);
-- 
1.8.1.4

