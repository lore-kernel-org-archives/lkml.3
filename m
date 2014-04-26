Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752294AbaDZRSQ (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Apr 2014 13:18:16 -0400
Received: from smtp.gentoo.org ([140.211.166.183]:48748 "EHLO smtp.gentoo.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751582AbaDZRSO (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Apr 2014 13:18:14 -0400
From: Richard Yao <ryao@gentoo.org>
To: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Paul Mackerras <paulus@samba.org>,
        Arnaldo Carvalho de Melo <acme@ghostprotocols.net>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>, jiri Olsa <jolsa@redhat.com>,
        Stephane Eranian <eranian@google.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, linux-kernel@vger.kernel.org,
        Richard Yao <ryao@gentoo.org>
Subject: [PATCH] perf machine: Search for modules in %s/lib/modules/%s
Date: Sat, 26 Apr 2014 13:17:55 -0400
Message-Id: <1398532675-13684-1-git-send-email-ryao@gentoo.org>
X-Mailer: git-send-email 1.8.3.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Modules installed outside of the kernel's build system should go into
"%s/lib/modules/%s/extra", but at present, perf will only look at them
when they are in "%s/lib/modules/%s/kernel". Lets encourage good
citizenship by relaxing this requirement to "%s/lib/modules/%s". This
way open source modules that are out-of-tree have no incentive to start
populating a directory reserved for in-kernel modules and I can stop
hex-editing my system's perf binary when profiling OSS out-of-tree
modules.

Feedback from Namhyung Kim correctly revealed that the hex-edits that I
had been doing meant that perf was also traversing the build and source
symlinks in %s/lib/modules/%s. That is undesireable, so we explicitly
exclude them from traversal with a minor tweak to the traversal routine.

Signed-off-by: Richard Yao <ryao@gentoo.org>
---
 tools/perf/util/machine.c | 16 ++++++++++++----
 1 file changed, 12 insertions(+), 4 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index a53cd0b..27c2a5e 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -717,7 +717,7 @@ static char *get_kernel_version(const char *root_dir)
 }
 
 static int map_groups__set_modules_path_dir(struct map_groups *mg,
-				const char *dir_name)
+				const char *dir_name, int depth)
 {
 	struct dirent *dent;
 	DIR *dir = opendir(dir_name);
@@ -742,7 +742,15 @@ static int map_groups__set_modules_path_dir(struct map_groups *mg,
 			    !strcmp(dent->d_name, ".."))
 				continue;
 
-			ret = map_groups__set_modules_path_dir(mg, path);
+			/* Do not follow top-level source and build symlinks */
+			if (depth == 0) {
+				if (!strcmp(dent->d_name, "source") ||
+				    !strcmp(dent->d_name, "build"))
+					continue;
+			}
+
+			ret = map_groups__set_modules_path_dir(mg, path,
+							       depth + 1);
 			if (ret < 0)
 				goto out;
 		} else {
@@ -786,11 +794,11 @@ static int machine__set_modules_path(struct machine *machine)
 	if (!version)
 		return -1;
 
-	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s/kernel",
+	snprintf(modules_path, sizeof(modules_path), "%s/lib/modules/%s",
 		 machine->root_dir, version);
 	free(version);
 
-	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
+	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path, 0);
 }
 
 static int machine__create_module(void *arg, const char *name, u64 start)
-- 
1.8.3.2

