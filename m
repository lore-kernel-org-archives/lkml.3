Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754821AbaHNIrS (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:47:18 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36410 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751861AbaHNIrP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:47:15 -0400
Date: Thu, 14 Aug 2014 01:46:55 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-2b2b2c68c64fb9db392940b42355944064f2a4ca@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, a.p.zijlstra@chello.nl,
        minchan@kernel.org, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, minchan@kernel.org,
        a.p.zijlstra@chello.nl, namhyung.kim@lge.com, namhyung@kernel.org,
        jolsa@redhat.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1407825645-24586-7-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-7-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf kmem:
  Move session handling out of __cmd_kmem()
Git-Commit-ID: 2b2b2c68c64fb9db392940b42355944064f2a4ca
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

Commit-ID:  2b2b2c68c64fb9db392940b42355944064f2a4ca
Gitweb:     http://git.kernel.org/tip/2b2b2c68c64fb9db392940b42355944064f2a4ca
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:38 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:33:07 -0300

perf kmem: Move session handling out of __cmd_kmem()

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-7-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-kmem.c | 49 +++++++++++++++++++++++++++--------------------
 1 file changed, 28 insertions(+), 21 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 84b8239..349d9b4 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -405,10 +405,9 @@ static void sort_result(void)
 	__sort_result(&root_caller_stat, &root_caller_sorted, &caller_sort);
 }
 
-static int __cmd_kmem(void)
+static int __cmd_kmem(struct perf_session *session)
 {
 	int err = -EINVAL;
-	struct perf_session *session;
 	const struct perf_evsel_str_handler kmem_tracepoints[] = {
 		{ "kmem:kmalloc",		perf_evsel__process_alloc_event, },
     		{ "kmem:kmem_cache_alloc",	perf_evsel__process_alloc_event, },
@@ -417,31 +416,22 @@ static int __cmd_kmem(void)
 		{ "kmem:kfree",			perf_evsel__process_free_event, },
     		{ "kmem:kmem_cache_free",	perf_evsel__process_free_event, },
 	};
-	struct perf_data_file file = {
-		.path = input_name,
-		.mode = PERF_DATA_MODE_READ,
-	};
-
-	session = perf_session__new(&file, false, &perf_kmem);
-	if (session == NULL)
-		return -ENOMEM;
 
 	if (!perf_session__has_traces(session, "kmem record"))
-		goto out_delete;
+		goto out;
 
 	if (perf_session__set_tracepoints_handlers(session, kmem_tracepoints)) {
 		pr_err("Initializing perf session tracepoint handlers failed\n");
-		return -1;
+		goto out;
 	}
 
 	setup_pager();
 	err = perf_session__process_events(session, &perf_kmem);
 	if (err != 0)
-		goto out_delete;
+		goto out;
 	sort_result();
 	print_result(session);
-out_delete:
-	perf_session__delete(session);
+out:
 	return err;
 }
 
@@ -688,29 +678,46 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 		NULL,
 		NULL
 	};
+	struct perf_session *session;
+	struct perf_data_file file = {
+		.path = input_name,
+		.mode = PERF_DATA_MODE_READ,
+	};
+	int ret = -1;
+
 	argc = parse_options_subcommand(argc, argv, kmem_options,
 					kmem_subcommands, kmem_usage, 0);
 
 	if (!argc)
 		usage_with_options(kmem_usage, kmem_options);
 
-	symbol__init();
-
 	if (!strncmp(argv[0], "rec", 3)) {
+		symbol__init();
 		return __cmd_record(argc, argv);
-	} else if (!strcmp(argv[0], "stat")) {
+	}
+
+	session = perf_session__new(&file, false, &perf_kmem);
+	if (session == NULL)
+		return -ENOMEM;
+
+	symbol__init();
+
+	if (!strcmp(argv[0], "stat")) {
 		if (cpu__setup_cpunode_map())
-			return -1;
+			goto out_delete;
 
 		if (list_empty(&caller_sort))
 			setup_sorting(&caller_sort, default_sort_order);
 		if (list_empty(&alloc_sort))
 			setup_sorting(&alloc_sort, default_sort_order);
 
-		return __cmd_kmem();
+		ret = __cmd_kmem(session);
 	} else
 		usage_with_options(kmem_usage, kmem_options);
 
-	return 0;
+out_delete:
+	perf_session__delete(session);
+
+	return ret;
 }
 
