Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752020AbaKDBSH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Nov 2014 20:18:07 -0500
Received: from lgeamrelo02.lge.com ([156.147.1.126]:33027 "EHLO
	lgeamrelo02.lge.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751744AbaKDBRC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Nov 2014 20:17:02 -0500
X-Original-SENDERIP: 10.177.222.235
X-Original-MAILFROM: namhyung@kernel.org
From: Namhyung Kim <namhyung@kernel.org>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, Ingo Molnar <mingo@kernel.org>,
        Paul Mackerras <paulus@samba.org>, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>,
        LKML <linux-kernel@vger.kernel.org>, Jiri Olsa <jolsa@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf tools: Move disable_buildid_cache() to util/build-id.c
Date: Tue,  4 Nov 2014 10:14:31 +0900
Message-Id: <1415063674-17206-6-git-send-email-namhyung@kernel.org>
X-Mailer: git-send-email 2.1.2
In-Reply-To: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
References: <1415063674-17206-1-git-send-email-namhyung@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also move static variable no_buildid_cache and check it in the
perf_session_cache_build_ids().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
---
 tools/perf/util/build-id.c | 11 +++++++++++
 tools/perf/util/build-id.h |  1 +
 tools/perf/util/header.c   | 10 +---------
 tools/perf/util/util.h     |  1 -
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index dd2a3e52ada1..e8d79e5bfaf7 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -18,6 +18,9 @@
 #include "header.h"
 #include "vdso.h"
 
+
+static bool no_buildid_cache;
+
 int build_id__mark_dso_hit(struct perf_tool *tool __maybe_unused,
 			   union perf_event *event,
 			   struct perf_sample *sample,
@@ -251,6 +254,11 @@ int dsos__hit_all(struct perf_session *session)
 	return 0;
 }
 
+void disable_buildid_cache(void)
+{
+	no_buildid_cache = true;
+}
+
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms, bool is_vdso)
 {
@@ -404,6 +412,9 @@ int perf_session__cache_build_ids(struct perf_session *session)
 	int ret;
 	char debugdir[PATH_MAX];
 
+	if (no_buildid_cache)
+		return 0;
+
 	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
 
 	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
diff --git a/tools/perf/util/build-id.h b/tools/perf/util/build-id.h
index 666a3bd4f64e..8236319514d5 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -25,5 +25,6 @@ int perf_session__cache_build_ids(struct perf_session *session);
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms, bool is_vdso);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
+void disable_buildid_cache(void);
 
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 3e2c156d9c64..3081f030aef0 100644
--- a/tools/perf/util/header.c
+++ b/tools/perf/util/header.c
@@ -24,8 +24,6 @@
 #include "build-id.h"
 #include "data.h"
 
-static bool no_buildid_cache = false;
-
 static u32 header_argc;
 static const char **header_argv;
 
@@ -191,8 +189,7 @@ static int write_build_id(int fd, struct perf_header *h,
 		pr_debug("failed to write buildid table\n");
 		return err;
 	}
-	if (!no_buildid_cache)
-		perf_session__cache_build_ids(session);
+	perf_session__cache_build_ids(session);
 
 	return 0;
 }
@@ -2790,8 +2787,3 @@ int perf_event__process_build_id(struct perf_tool *tool __maybe_unused,
 				 session);
 	return 0;
 }
-
-void disable_buildid_cache(void)
-{
-	no_buildid_cache = true;
-}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7dc44cfe25b3..76d23d83eae5 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -154,7 +154,6 @@ extern void set_die_routine(void (*routine)(const char *err, va_list params) NOR
 
 extern int prefixcmp(const char *str, const char *prefix);
 extern void set_buildid_dir(void);
-extern void disable_buildid_cache(void);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
-- 
2.1.2

