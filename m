Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754071AbaHMWuF (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 18:50:05 -0400
Received: from mail.kernel.org ([198.145.19.201]:55270 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751973AbaHMWuB (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 18:50:01 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung@kernel.org>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Minchan Kim <minchan@kernel.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 19/41] perf kmem: Move session handling out of __cmd_kmem()
Date: Wed, 13 Aug 2014 19:48:05 -0300
Message-Id: <1407970107-24540-20-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1407970107-24540-1-git-send-email-acme@kernel.org>
References: <1407970107-24540-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung@kernel.org>

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
index 84b82397a28e..349d9b46098e 100644
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
 
-- 
1.9.3

