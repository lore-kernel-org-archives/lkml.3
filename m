Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754234AbaLATG4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:06:56 -0500
Received: from mx1.redhat.com ([209.132.183.28]:60616 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752854AbaLATGy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:06:54 -0500
From: Jiri Olsa <jolsa@kernel.org>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@kernel.org>, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>,
        Ingo Molnar <mingo@kernel.org>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Steven Rostedt <rostedt@goodmis.org>
Subject: [PATCH 2/8] perf tools: Remove extra debugdir variables
Date: Mon,  1 Dec 2014 20:06:23 +0100
Message-Id: <1417460789-13874-3-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There's no need to copy over the buildid_dir into separate
variable with no change.

This is leftover from commit:
  45de34bbe3e1 perf buildid: add perfconfig option to specify buildid cache dir

that added global buildid_dir variable that holds cache
directory, but did not cleanup the debugdir copies.

Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@kernel.org>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Cc: Steven Rostedt <rostedt@goodmis.org>
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/builtin-buildid-cache.c | 11 ++++-------
 tools/perf/util/build-id.c         |  9 +++------
 2 files changed, 7 insertions(+), 13 deletions(-)

diff --git a/tools/perf/builtin-buildid-cache.c b/tools/perf/builtin-buildid-cache.c
index 70385756da63..29f24c071bc6 100644
--- a/tools/perf/builtin-buildid-cache.c
+++ b/tools/perf/builtin-buildid-cache.c
@@ -285,7 +285,6 @@ int cmd_buildid_cache(int argc, const char **argv,
 	struct str_node *pos;
 	int ret = 0;
 	bool force = false;
-	char debugdir[PATH_MAX];
 	char const *add_name_list_str = NULL,
 		   *remove_name_list_str = NULL,
 		   *missing_filename = NULL,
@@ -335,13 +334,11 @@ int cmd_buildid_cache(int argc, const char **argv,
 
 	setup_pager();
 
-	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
-
 	if (add_name_list_str) {
 		list = strlist__new(true, add_name_list_str);
 		if (list) {
 			strlist__for_each(pos, list)
-				if (build_id_cache__add_file(pos->s, debugdir)) {
+				if (build_id_cache__add_file(pos->s, buildid_dir)) {
 					if (errno == EEXIST) {
 						pr_debug("%s already in the cache\n",
 							 pos->s);
@@ -359,7 +356,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 		list = strlist__new(true, remove_name_list_str);
 		if (list) {
 			strlist__for_each(pos, list)
-				if (build_id_cache__remove_file(pos->s, debugdir)) {
+				if (build_id_cache__remove_file(pos->s, buildid_dir)) {
 					if (errno == ENOENT) {
 						pr_debug("%s wasn't in the cache\n",
 							 pos->s);
@@ -380,7 +377,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 		list = strlist__new(true, update_name_list_str);
 		if (list) {
 			strlist__for_each(pos, list)
-				if (build_id_cache__update_file(pos->s, debugdir)) {
+				if (build_id_cache__update_file(pos->s, buildid_dir)) {
 					if (errno == ENOENT) {
 						pr_debug("%s wasn't in the cache\n",
 							 pos->s);
@@ -395,7 +392,7 @@ int cmd_buildid_cache(int argc, const char **argv,
 	}
 
 	if (kcore_filename &&
-	    build_id_cache__add_kcore(kcore_filename, debugdir, force))
+	    build_id_cache__add_kcore(kcore_filename, buildid_dir, force))
 		pr_warning("Couldn't add %s\n", kcore_filename);
 
 out:
diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index e8d79e5bfaf7..0c72680a977f 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -410,21 +410,18 @@ int perf_session__cache_build_ids(struct perf_session *session)
 {
 	struct rb_node *nd;
 	int ret;
-	char debugdir[PATH_MAX];
 
 	if (no_buildid_cache)
 		return 0;
 
-	snprintf(debugdir, sizeof(debugdir), "%s", buildid_dir);
-
-	if (mkdir(debugdir, 0755) != 0 && errno != EEXIST)
+	if (mkdir(buildid_dir, 0755) != 0 && errno != EEXIST)
 		return -1;
 
-	ret = machine__cache_build_ids(&session->machines.host, debugdir);
+	ret = machine__cache_build_ids(&session->machines.host, buildid_dir);
 
 	for (nd = rb_first(&session->machines.guests); nd; nd = rb_next(nd)) {
 		struct machine *pos = rb_entry(nd, struct machine, rb_node);
-		ret |= machine__cache_build_ids(pos, debugdir);
+		ret |= machine__cache_build_ids(pos, buildid_dir);
 	}
 	return ret ? -1 : 0;
 }
-- 
1.9.3

