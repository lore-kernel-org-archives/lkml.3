Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759108AbaD3PdM (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Apr 2014 11:33:12 -0400
Received: from mx1.redhat.com ([209.132.183.28]:31296 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752084AbaD3PdK (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Apr 2014 11:33:10 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Richard Yao <ryao@gentoo.org>,
        Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 4/7] perf machine: Search for modules in %s/lib/modules/%s
Date: Wed, 30 Apr 2014 17:32:48 +0200
Message-Id: <1398871971-381-5-git-send-email-jolsa@kernel.org>
In-Reply-To: <1398871971-381-1-git-send-email-jolsa@kernel.org>
References: <1398871971-381-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Richard Yao <ryao@gentoo.org>

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
Acked-by: Namhyung kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1398532675-13684-1-git-send-email-ryao@gentoo.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
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
1.8.3.1

