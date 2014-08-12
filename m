Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753889AbaHLGnn (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Aug 2014 02:43:43 -0400
Received: from lgeamrelo02.lge.com ([156.147.1.126]:41205 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753120AbaHLGku (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Aug 2014 02:40:50 -0400
X-Original-SENDERIP: 10.177.220.181
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        David Ahern <dsahern@gmail.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        Minchan Kim <minchan@kernel.org>
Subject: [PATCH 04/13] perf buildid-cache: Move session handling into cmd_buildid_cache()
Date: Tue, 12 Aug 2014 15:40:36 +0900
Message-Id: <1407825645-24586-5-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.0.0
In-Reply-To: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/builtin-buildid-cache.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 2a2c78f80876..d91bfa6632e8 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -246,20 +246,9 @@ static bool dso__missing_buildid_cache(struct dso *dso, int parm __maybe_unused)
 	return true;
 }
 
-static int build_id_cache__fprintf_missing(const char *filename, bool force, FILE *fp)
+static int build_id_cache__fprintf_missing(struct perf_session *session, FILE *fp)
 {
-	struct perf_data_file file = {
-		.path  = filename,
-		.mode  = PERF_DATA_MODE_READ,
-		.force = force,
-	};
-	struct perf_session *session = perf_session__new(&file, false, NULL);
-	if (session == NULL)
-		return -1;
-
 	perf_session__fprintf_dsos_buildid(session, fp, dso__missing_buildid_cache, 0);
-	perf_session__delete(session);
-
 	return 0;
 }
 
@@ -303,6 +292,11 @@ int cmd_buildid_cache(int argc, const char **argv,
 		   *update_name_list_str = NULL,
 		   *kcore_filename;
 
+	struct perf_data_file file = {
+		.mode  = PERF_DATA_MODE_READ,
+	};
+	struct perf_session *session = NULL;
+
 	const struct option buildid_cache_options[] = {
 	OPT_STRING('a', "add", &add_name_list_str,
 		   "file list", "file(s) to add"),
@@ -326,8 +320,17 @@ int cmd_buildid_cache(int argc, const char **argv,
 	argc = parse_options(argc, argv, buildid_cache_options,
 			     buildid_cache_usage, 0);
 
+	if (missing_filename) {
+		file.path = missing_filename;
+		file.force = force;
+
+		session = perf_session__new(&file, false, NULL);
+		if (session == NULL)
+			return -1;
+	}
+
 	if (symbol__init() < 0)
-		return -1;
+		goto out;
 
 	setup_pager();
 
@@ -370,7 +373,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 	}
 
 	if (missing_filename)
-		ret = build_id_cache__fprintf_missing(missing_filename, force, stdout);
+		ret = build_id_cache__fprintf_missing(session, stdout);
 
 	if (update_name_list_str) {
 		list = strlist__new(true, update_name_list_str);
@@ -394,5 +397,9 @@ int cmd_buildid_cache(int argc, const char **argv,
 	    build_id_cache__add_kcore(kcore_filename, debugdir, force))
 		pr_warning("Couldn't add %s\n", kcore_filename);
 
+out:
+	if (session)
+		perf_session__delete(session);
+
 	return ret;
 }
-- 
2.0.0

