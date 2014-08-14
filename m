Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754784AbaHNIqr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Aug 2014 04:46:47 -0400
Received: from terminus.zytor.com ([198.137.202.10]:36373 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752172AbaHNIqn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Aug 2014 04:46:43 -0400
Date: Thu, 14 Aug 2014 01:46:25 -0700
From: tip-bot for Namhyung Kim <tipbot@zytor.com>
Message-ID: <tip-e3ed75bb537a860a375ca1e09ad1b87c707f1636@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, jolsa@kernel.org,
        a.p.zijlstra@chello.nl, minchan@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, jolsa@kernel.org,
        minchan@kernel.org, a.p.zijlstra@chello.nl, namhyung.kim@lge.com,
        namhyung@kernel.org, jolsa@redhat.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1407825645-24586-5-git-send-email-namhyung@kernel.org>
References: <1407825645-24586-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-cache:
  Move session handling into cmd_buildid_cache()
Git-Commit-ID: e3ed75bb537a860a375ca1e09ad1b87c707f1636
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

Commit-ID:  e3ed75bb537a860a375ca1e09ad1b87c707f1636
Gitweb:     http://git.kernel.org/tip/e3ed75bb537a860a375ca1e09ad1b87c707f1636
Author:     Namhyung Kim <namhyung@kernel.org>
AuthorDate: Tue, 12 Aug 2014 15:40:36 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 13 Aug 2014 16:32:19 -0300

perf buildid-cache: Move session handling into cmd_buildid_cache()

This is a preparation of fixing dso__load_kernel_sym().  It needs a
session info before calling symbol__init().

Acked-by: Jiri Olsa <jolsa@kernel.org>
Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Minchan Kim <minchan@kernel.org>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1407825645-24586-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/builtin-buildid-cache.c | 35 +++++++++++++++++++++--------------
 1 file changed, 21 insertions(+), 14 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 2a2c78f..d91bfa6 100644
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
