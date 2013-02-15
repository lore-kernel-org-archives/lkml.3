Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761657Ab3BOQbB (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 11:31:01 -0500
Received: from terminus.zytor.com ([198.137.202.10]:35785 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932973Ab3BOQa6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 11:30:58 -0500
Date: Fri, 15 Feb 2013 08:29:08 -0800
From: tip-bot for Namhyung Kim <namhyung.kim@lge.com>
Message-ID: <tip-eeb49845425375481f14c0e5721f88242642e88e@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, paulus@samba.org,
        hpa@zytor.com, mingo@kernel.org, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        bp@alien8.de, namhyung@kernel.org, jolsa@redhat.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        linux-kernel@vger.kernel.org, acme@redhat.com, andi@firstfloor.org,
        a.p.zijlstra@chello.nl, penberg@kernel.org, namhyung.kim@lge.com,
        namhyung@kernel.org, bp@alien8.de, jolsa@redhat.com,
        tglx@linutronix.de
In-Reply-To: <1360227734-375-5-git-send-email-namhyung@kernel.org>
References: <1360227734-375-5-git-send-email-namhyung@kernel.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf buildid-cache: Add --update option
Git-Commit-ID: eeb49845425375481f14c0e5721f88242642e88e
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Fri, 15 Feb 2013 08:29:15 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  eeb49845425375481f14c0e5721f88242642e88e
Gitweb:     http://git.kernel.org/tip/eeb49845425375481f14c0e5721f88242642e88e
Author:     Namhyung Kim <namhyung.kim@lge.com>
AuthorDate: Thu, 7 Feb 2013 18:02:11 +0900
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Thu, 14 Feb 2013 14:59:27 -0300

perf buildid-cache: Add --update option

When adding vmlinux file to build-id cache, it'd be fail since kallsyms
dso with a same build-id was already added by perf record.

So one needs to remove the kallsyms first to add vmlinux into the cache.
Add --update option for doing it at once.

Signed-off-by: Namhyung Kim <namhyung@kernel.org>
Cc: Andi Kleen <andi@firstfloor.org>
Cc: Borislav Petkov <bp@alien8.de>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Pekka Enberg <penberg@kernel.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Link: http://lkml.kernel.org/r/1360227734-375-5-git-send-email-namhyung@kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/Documentation/perf-buildid-cache.txt |  4 ++
 tools/perf/builtin-buildid-cache.c              | 50 ++++++++++++++++++++++++-
 2 files changed, 53 insertions(+), 1 deletion(-)

diff --git a/tools/perf/Documentation/perf-buildid-cache.txt b/tools/perf/Documentation/perf-buildid-cache.txt
index 8e798ba..e9a8349 100644
--- a/tools/perf/Documentation/perf-buildid-cache.txt
+++ b/tools/perf/Documentation/perf-buildid-cache.txt
@@ -27,6 +27,10 @@ OPTIONS
 -M::
 --missing=:: 
 	List missing build ids in the cache for the specified file.
+-u::
+--update::
+	Update specified file of the cache. It can be used to update kallsyms
+	kernel dso to vmlinux in order to support annotation.
 -v::
 --verbose::
 	Be more verbose.
diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index a336014..c96c8fa 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -93,6 +93,32 @@ static int build_id_cache__fprintf_missing(const char *filename, bool force, FIL
 	return 0;
 }
 
+static int build_id_cache__update_file(const char *filename,
+				       const char *debugdir)
+{
+	u8 build_id[BUILD_ID_SIZE];
+	char sbuild_id[BUILD_ID_SIZE * 2 + 1];
+
+	int err;
+
+	if (filename__read_build_id(filename, &build_id, sizeof(build_id)) < 0) {
+		pr_debug("Couldn't read a build-id in %s\n", filename);
+		return -1;
+	}
+
+	build_id__sprintf(build_id, sizeof(build_id), sbuild_id);
+	err = build_id_cache__remove_s(sbuild_id, debugdir);
+	if (!err) {
+		err = build_id_cache__add_s(sbuild_id, debugdir, filename,
+					    false, false);
+	}
+	if (verbose)
+		pr_info("Updating %s %s: %s\n", sbuild_id, filename,
+			err ? "FAIL" : "Ok");
+
+	return err;
+}
+
 int cmd_buildid_cache(int argc, const char **argv,
 		      const char *prefix __maybe_unused)
 {
@@ -103,7 +129,9 @@ int cmd_buildid_cache(int argc, const char **argv,
 	char debugdir[PATH_MAX];
 	char const *add_name_list_str = NULL,
 		   *remove_name_list_str = NULL,
-		   *missing_filename = NULL;
+		   *missing_filename = NULL,
+		   *update_name_list_str = NULL;
+
 	const struct option buildid_cache_options[] = {
 	OPT_STRING('a', "add", &add_name_list_str,
 		   "file list", "file(s) to add"),
@@ -112,6 +140,8 @@ int cmd_buildid_cache(int argc, const char **argv,
 	OPT_STRING('M', "missing", &missing_filename, "file",
 		   "to find missing build ids in the cache"),
 	OPT_BOOLEAN('f', "force", &force, "don't complain, do it"),
+	OPT_STRING('u', "update", &update_name_list_str, "file list",
+		    "file(s) to update"),
 	OPT_INCR('v', "verbose", &verbose, "be more verbose"),
 	OPT_END()
 	};
@@ -169,5 +199,23 @@ int cmd_buildid_cache(int argc, const char **argv,
 	if (missing_filename)
 		ret = build_id_cache__fprintf_missing(missing_filename, force, stdout);
 
+	if (update_name_list_str) {
+		list = strlist__new(true, update_name_list_str);
+		if (list) {
+			strlist__for_each(pos, list)
+				if (build_id_cache__update_file(pos->s, debugdir)) {
+					if (errno == ENOENT) {
+						pr_debug("%s wasn't in the cache\n",
+							 pos->s);
+						continue;
+					}
+					pr_warning("Couldn't update %s: %s\n",
+						   pos->s, strerror(errno));
+				}
+
+			strlist__delete(list);
+		}
+	}
+
 	return ret;
 }
