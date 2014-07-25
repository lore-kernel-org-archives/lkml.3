Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933154AbaGYPiZ (ORCPT <rfc822;w@1wt.eu>);
	Fri, 25 Jul 2014 11:38:25 -0400
Received: from mail.kernel.org ([198.145.19.201]:35107 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1761010AbaGYPiV (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 25 Jul 2014 11:38:21 -0400
From: Arnaldo Carvalho de Melo <acme@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 15/27] perf tools: Group VDSO global variables into a structure
Date: Fri, 25 Jul 2014 12:36:57 -0300
Message-Id: <1406302629-11790-16-git-send-email-acme@kernel.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1406302629-11790-1-git-send-email-acme@kernel.org>
References: <1406302629-11790-1-git-send-email-acme@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

This is preparation for removing the global variables used in vdso.c and
thereby fixing the lifetime of the VDSO temporary file.

Also allowance is made for the later addition of support for compat
VDSOs.

Reviewed-by: Jiri Olsa <jolsa@redhat.com>
Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1406035081-14301-46-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/vdso.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index da5ba4da2bd2..75245f081b60 100644
--- a/tools/perf/util/vdso.c
+++ b/tools/perf/util/vdso.c
@@ -15,8 +15,27 @@
 #include "linux/string.h"
 #include "debug.h"
 
-static bool vdso_found;
-static char vdso_file[] = "/tmp/perf-vdso.so-XXXXXX";
+#define VDSO__TEMP_FILE_NAME "/tmp/perf-vdso.so-XXXXXX"
+
+struct vdso_file {
+	bool found;
+	bool error;
+	char temp_file_name[sizeof(VDSO__TEMP_FILE_NAME)];
+	const char *dso_name;
+};
+
+struct vdso_info {
+	struct vdso_file vdso;
+};
+
+static struct vdso_info vdso_info_ = {
+	.vdso = {
+		.temp_file_name = VDSO__TEMP_FILE_NAME,
+		.dso_name = VDSO__MAP_NAME,
+	},
+};
+
+static struct vdso_info *vdso_info = &vdso_info_;
 
 static int find_vdso_map(void **start, void **end)
 {
@@ -49,7 +68,7 @@ static int find_vdso_map(void **start, void **end)
 	return !found;
 }
 
-static char *get_file(void)
+static char *get_file(struct vdso_file *vdso_file)
 {
 	char *vdso = NULL;
 	char *buf = NULL;
@@ -57,10 +76,10 @@ static char *get_file(void)
 	size_t size;
 	int fd;
 
-	if (vdso_found)
-		return vdso_file;
+	if (vdso_file->found)
+		return vdso_file->temp_file_name;
 
-	if (find_vdso_map(&start, &end))
+	if (vdso_file->error || find_vdso_map(&start, &end))
 		return NULL;
 
 	size = end - start;
@@ -69,26 +88,27 @@ static char *get_file(void)
 	if (!buf)
 		return NULL;
 
-	fd = mkstemp(vdso_file);
+	fd = mkstemp(vdso_file->temp_file_name);
 	if (fd < 0)
 		goto out;
 
 	if (size == (size_t) write(fd, buf, size))
-		vdso = vdso_file;
+		vdso = vdso_file->temp_file_name;
 
 	close(fd);
 
  out:
 	free(buf);
 
-	vdso_found = (vdso != NULL);
+	vdso_file->found = (vdso != NULL);
+	vdso_file->error = !vdso_file->found;
 	return vdso;
 }
 
 void vdso__exit(void)
 {
-	if (vdso_found)
-		unlink(vdso_file);
+	if (vdso_info->vdso.found)
+		unlink(vdso_info->vdso.temp_file_name);
 }
 
 struct dso *vdso__dso_findnew(struct machine *machine)
@@ -98,7 +118,7 @@ struct dso *vdso__dso_findnew(struct machine *machine)
 	if (!dso) {
 		char *file;
 
-		file = get_file();
+		file = get_file(&vdso_info->vdso);
 		if (!file)
 			return NULL;
 
-- 
1.9.3

