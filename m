Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754372AbaLATHn (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 14:07:43 -0500
Received: from mx1.redhat.com ([209.132.183.28]:35704 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754352AbaLATHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 14:07:41 -0500
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
Subject: [PATCH 8/8] perf buildid-cache: Try to remove empty directories
Date: Mon,  1 Dec 2014 20:06:29 +0100
Message-Id: <1417460789-13874-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
References: <1417460789-13874-1-git-send-email-jolsa@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The cache removal routine only removes files leaving
directories untouched. Adding code that tries to
remove directories up to the 'buildid_dir' level.

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
 tools/perf/util/build-id.c | 44 +++++++++++++++++++++++++++++++++++++++++++-
 1 file changed, 43 insertions(+), 1 deletion(-)

diff --git a/tools/perf/util/build-id.c b/tools/perf/util/build-id.c
index 0c72680a977f..c5dc066db6e9 100644
--- a/tools/perf/util/build-id.c
+++ b/tools/perf/util/build-id.c
@@ -329,11 +329,41 @@ static int build_id_cache__add_b(const u8 *build_id, size_t build_id_size,
 				     is_kallsyms, is_vdso);
 }
 
+/*
+ * Tries to remove directory of the file given in
+ * the @file parameter. It might change the string
+ * pointed to by the @file pointer.
+ */
+static void try_remove_dir(char *file, const char *debugdir)
+{
+	char *dir = dirname(file);
+
+	while (dir) {
+		char *slash;
+
+		if (!strcmp(dir, debugdir))
+			return;
+
+		pr_debug("try_remove_dir %s\n", dir);
+
+		/* We dont care if it failes, we tried.. */
+		if (rmdir(dir))
+			return;
+
+		slash = strrchr(dir, '/');
+		if (!slash)
+			return;
+
+		*slash = 0;
+	}
+}
+
 int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 {
 	const size_t size = PATH_MAX;
 	char *filename = zalloc(size),
-	     *linkname = zalloc(size);
+	     *linkname = zalloc(size),
+	     *build_id_link = NULL;
 	int err = -1;
 
 	if (filename == NULL || linkname == NULL)
@@ -351,6 +381,10 @@ int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 	if (unlink(linkname))
 		goto out_free;
 
+	build_id_link = strdup(linkname);
+	if (!build_id_link)
+		goto out_free;
+
 	/*
 	 * Since the link is relative, we must make it absolute:
 	 */
@@ -360,10 +394,18 @@ int build_id_cache__remove_s(const char *sbuild_id, const char *debugdir)
 	if (unlink(linkname))
 		goto out_free;
 
+	/*
+	 * The order matters here, because linkname path
+	 * is based on build_id_link path.
+	 */
+	try_remove_dir(linkname, debugdir);
+	try_remove_dir(build_id_link, debugdir);
+
 	err = 0;
 out_free:
 	free(filename);
 	free(linkname);
+	free(build_id_link);
 	return err;
 }
 
-- 
1.9.3

