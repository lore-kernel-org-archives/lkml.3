Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755872AbaGVNYK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 09:24:10 -0400
Received: from mga02.intel.com ([134.134.136.20]:45622 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755491AbaGVNVa (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 09:21:30 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,710,1400050800"; 
   d="scan'208";a="576986290"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@kernel.org>
Cc: Peter Zijlstra <peterz@infradead.org>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Namhyung Kim <namhyung@gmail.com>, Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 45/52] perf tools: Group VDSO global variables into a structure
Date: Tue, 22 Jul 2014 16:17:54 +0300
Message-Id: <1406035081-14301-46-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This is preparation for removing the global variables
used in vdso.c and thereby fixing the lifetime of the
VDSO temporary file.

Also allowance is made for the later addition of
support for compat VDSOs.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/vdso.c | 44 ++++++++++++++++++++++++++++++++------------
 1 file changed, 32 insertions(+), 12 deletions(-)

diff --git a/tools/perf/util/vdso.c b/tools/perf/util/vdso.c
index da5ba4d..75245f0 100644
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
1.8.3.2

