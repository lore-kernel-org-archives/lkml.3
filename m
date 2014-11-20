Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756313AbaKTHhg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 20 Nov 2014 02:37:36 -0500
Received: from terminus.zytor.com ([198.137.202.10]:43792 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756076AbaKTHhd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 20 Nov 2014 02:37:33 -0500
Date: Wed, 19 Nov 2014 23:36:41 -0800
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-73c5d224b4514575abe0dd89b43adbde937429c3@git.kernel.org>
Cc: srikar@linux.vnet.ibm.com, aravinda@linux.vnet.ibm.com,
        masami.hiramatsu.pt@hitachi.com, peterz@infradead.org, hpa@zytor.com,
        mingo@kernel.org, linux-kernel@vger.kernel.org,
        hemant@linux.vnet.ibm.com, hegdevasant@linux.vnet.ibm.com,
        oleg@redhat.com, brendan.d.gregg@gmail.com, tglx@linutronix.de,
        acme@redhat.com, penberg@iki.fi, namhyung@kernel.org
Reply-To: srikar@linux.vnet.ibm.com, aravinda@linux.vnet.ibm.com,
        masami.hiramatsu.pt@hitachi.com, peterz@infradead.org,
        hegdevasant@linux.vnet.ibm.com, linux-kernel@vger.kernel.org,
        hemant@linux.vnet.ibm.com, mingo@kernel.org, hpa@zytor.com,
        oleg@redhat.com, penberg@iki.fi, namhyung@kernel.org, acme@redhat.com,
        tglx@linutronix.de, brendan.d.gregg@gmail.com
In-Reply-To: <1415368677-3794-1-git-send-email-namhyung@kernel.org>
References: <1415368677-3794-1-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf build-id: Move disable_buildid_cache()
  to util/build-id.c
Git-Commit-ID: 73c5d224b4514575abe0dd89b43adbde937429c3
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

Commit-ID:  73c5d224b4514575abe0dd89b43adbde937429c3
Gitweb:     http://git.kernel.org/tip/73c5d224b4514575abe0dd89b43adbde937429c3
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Fri, 7 Nov 2014 22:57:56 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 19 Nov 2014 12:33:46 -0300

perf build-id: Move disable_buildid_cache() to util/build-id.c

Also move static variable no_buildid_cache and check it in the
perf_session_cache_build_ids().

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Aravinda Prasad <aravinda@linux.vnet.ibm.com>
Cc: Brendan Gregg <brendan.d.gregg@gmail.com>
Cc: Hemant Kumar <hemant@linux.vnet.ibm.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Masami Hiramatsu <masami.hiramatsu.pt@hitachi.com>
Cc: Oleg Nesterov <oleg@redhat.com>
Cc: Pekka Enberg <penberg@iki.fi>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Srikar Dronamraju <srikar@linux.vnet.ibm.com>
Cc: Vasant Hegde <hegdevasant@linux.vnet.ibm.com>
Cc: systemtap@sourceware.org
Link: http://lkml.kernel.org/r/1415368677-3794-1-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/build-id.c | 11 +++++++++++
 tools/perf/util/build-id.h |  1 +
 tools/perf/util/header.c   | 10 +---------
 tools/perf/util/util.h     |  1 -
 4 files changed, 13 insertions(+), 10 deletions(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index dd2a3e5..e8d79e5 100644
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
index 666a3bd..8236319 100644
--- a/tools/perf/util/build-id.h
+++ b/tools/perf/util/build-id.h
@@ -25,5 +25,6 @@ int perf_session__cache_build_ids(struct perf_session *session);
 int build_id_cache__add_s(const char *sbuild_id, const char *debugdir,
 			  const char *name, bool is_kallsyms, bool is_vdso);
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir);
+void disable_buildid_cache(void);
 
 #endif
diff --git a/tools/perf/util/header.c b/tools/perf/util/header.c
index 05fab7a..b20e40c 100644
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
@@ -2791,8 +2788,3 @@ int perf_event__process_build_id(struct perf_tool *tool __maybe_unused,
 				 session);
 	return 0;
 }
-
-void disable_buildid_cache(void)
-{
-	no_buildid_cache = true;
-}
diff --git a/tools/perf/util/util.h b/tools/perf/util/util.h
index 7dc44cf..76d23d8 100644
--- a/tools/perf/util/util.h
+++ b/tools/perf/util/util.h
@@ -154,7 +154,6 @@ extern void set_die_routine(void (*routine)(const char *err, va_list params) NOR
 
 extern int prefixcmp(const char *str, const char *prefix);
 extern void set_buildid_dir(void);
-extern void disable_buildid_cache(void);
 
 static inline const char *skip_prefix(const char *str, const char *prefix)
 {
