Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935025Ab3BNVqb (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Feb 2013 16:46:31 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57493 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935000Ab3BNVor (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Feb 2013 16:44:47 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Namhyung Kim <namhyung.kim@lge.com>,
        Namhyung Kim <namhyung@kernel.org>, Andi Kleen <andi@firstfloor.org>,
        Borislav Petkov <bp@alien8.de>, Jiri Olsa <jolsa@redhat.com>,
        Paul Mackerras <paulus@samba.org>, Pekka Enberg <penberg@kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 01/10] perf buildid-cache: Add --update option
Date: Thu, 14 Feb 2013 18:44:14 -0300
Message-Id: <1360878263-12694-2-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360878263-12694-1-git-send-email-acme@infradead.org>
References: <1360878263-12694-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Namhyung Kim <namhyung.kim@lge.com>

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
-- 
1.8.1.1.361.gec3ae6e

