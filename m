Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753502AbaEAGc6 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 1 May 2014 02:32:58 -0400
Received: from terminus.zytor.com ([198.137.202.10]:58231 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750741AbaEAGc4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 1 May 2014 02:32:56 -0400
Date: Wed, 30 Apr 2014 23:32:30 -0700
From: tip-bot for Richard Yao <tipbot@zytor.com>
Message-ID: <tip-61d4290cc1f10588147b76b385875f06827d47ff@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        jolsa@kernel.org, ryao@gentoo.org, tglx@linutronix.de,
        namhyung@kernel.org
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        jolsa@kernel.org, ryao@gentoo.org, tglx@linutronix.de,
        namhyung@kernel.org
In-Reply-To: <1398532675-13684-1-git-send-email-ryao@gentoo.org>
References: <1398532675-13684-1-git-send-email-ryao@gentoo.org>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf machine: Search for modules in %s/lib/
 modules/%s
Git-Commit-ID: 61d4290cc1f10588147b76b385875f06827d47ff
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

Commit-ID:  61d4290cc1f10588147b76b385875f06827d47ff
Gitweb:     http://git.kernel.org/tip/61d4290cc1f10588147b76b385875f06827d47ff
Author:     Richard Yao <ryao@gentoo.org>
AuthorDate: Sat, 26 Apr 2014 13:17:55 -0400
Committer:  Jiri Olsa <jolsa@kernel.org>
CommitDate: Wed, 30 Apr 2014 16:49:29 +0200

perf machine: Search for modules in %s/lib/modules/%s

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
