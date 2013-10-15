Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932911Ab3JOFYk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:24:40 -0400
Received: from terminus.zytor.com ([198.137.202.10]:32973 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932792Ab3JOFYU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:24:20 -0400
Date: Mon, 14 Oct 2013 22:23:53 -0700
From: tip-bot for Jiri Olsa <tipbot@zytor.com>
Message-ID: <tip-918512b435e15fefe609d236e0ecd62cb8f389c9@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, a.p.zijlstra@chello.nl,
        namhyung@kernel.org, jolsa@redhat.com, fweisbec@gmail.com,
        dsahern@gmail.com, tglx@linutronix.de, cjashfor@linux.vnet.ibm.com,
        mingo@elte.hu
In-Reply-To: <1379003976-5839-4-git-send-email-jolsa@redhat.com>
References: <1379003976-5839-4-git-send-email-jolsa@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools: Unify page_size usage
Git-Commit-ID: 918512b435e15fefe609d236e0ecd62cb8f389c9
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:23:59 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  918512b435e15fefe609d236e0ecd62cb8f389c9
Gitweb:     http://git.kernel.org/tip/918512b435e15fefe609d236e0ecd62cb8f389c9
Author:     Jiri Olsa <jolsa@redhat.com>
AuthorDate: Thu, 12 Sep 2013 18:39:35 +0200
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 9 Oct 2013 11:22:55 -0300

perf tools: Unify page_size usage

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
index cf36ba2..0aacd62 100644
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
index 245020c..6265778 100644
--- a/tools/perf/perf.c
+++ b/tools/perf/perf.c
@@ -456,6 +456,7 @@ int main(int argc, const char **argv)
 {
 	const char *cmd;
 
+	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	cmd = perf_extract_argv0_path(argv[0]);
diff --git a/tools/perf/util/python.c b/tools/perf/util/python.c
index 71b5412..a24ce0a 100644
--- a/tools/perf/util/python.c
+++ b/tools/perf/util/python.c
@@ -1036,6 +1036,7 @@ PyMODINIT_FUNC initperf(void)
 	    pyrf_cpu_map__setup_types() < 0)
 		return;
 
+	/* The page_size is placed in util object. */
 	page_size = sysconf(_SC_PAGE_SIZE);
 
 	Py_INCREF(&pyrf_evlist__type);
