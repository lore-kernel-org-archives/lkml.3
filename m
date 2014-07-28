Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752171AbaG1I0J (ORCPT <rfc822;w@1wt.eu>);
	Mon, 28 Jul 2014 04:26:09 -0400
Received: from terminus.zytor.com ([198.137.202.10]:42578 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751383AbaG1I0E (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 28 Jul 2014 04:26:04 -0400
Date: Mon, 28 Jul 2014 01:25:07 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-30f4f815a45d0b148d17afb0d5a5575ae2ba4309@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, adrian.hunter@intel.com, dsahern@gmail.com,
        tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        peterz@infradead.org, namhyung@gmail.com, jolsa@redhat.com,
        fweisbec@gmail.com, dsahern@gmail.com, adrian.hunter@intel.com,
        tglx@linutronix.de
In-Reply-To: <1406035081-14301-46-git-send-email-adrian.hunter@intel.com>
References: <1406035081-14301-46-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Group VDSO global variables into a structure
Git-Commit-ID: 30f4f815a45d0b148d17afb0d5a5575ae2ba4309
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

Commit-ID:  30f4f815a45d0b148d17afb0d5a5575ae2ba4309
Gitweb:     http://git.kernel.org/tip/30f4f815a45d0b148d17afb0d5a5575ae2ba4309
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 22 Jul 2014 16:17:54 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 23 Jul 2014 17:11:26 -0300

perf tools: Group VDSO global variables into a structure

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
 
