Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754758Ab3LQUxt (ORCPT <rfc822;w@1wt.eu>);
	Tue, 17 Dec 2013 15:53:49 -0500
Received: from merlin.infradead.org ([205.233.59.134]:56171 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754546Ab3LQUw0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 17 Dec 2013 15:52:26 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@redhat.com>,
        Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@kernel.org>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <peterz@infradead.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH 07/10] perf symbols: Clarify method to get DSO binary_type filename
Date: Tue, 17 Dec 2013 17:52:08 -0300
Message-Id: <1387313531-14629-8-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1387313531-14629-1-git-send-email-acme@infradead.org>
References: <1387313531-14629-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Arnaldo Carvalho de Melo <acme@redhat.com>

Using dso__binary_type_file() make it look like this function will
return a file, not just its filename, so rename it to:

	dso__read_binary_type_filename()

to make its purpose clear, just like we have:

	dso__read_running_kernel_build_id()

Cc: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <peterz@infradead.org>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/n/tip-vkf3upzrfrxtr01wueej4xw4@git.kernel.org
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/dso.c    | 14 +++++++-------
 tools/perf/util/dso.h    |  4 ++--
 tools/perf/util/symbol.c |  4 ++--
 3 files changed, 11 insertions(+), 11 deletions(-)

diff --git a/tools/perf/util/dso.c b/tools/perf/util/dso.c
index e7f4449088e4..eef166212324 100644
--- a/tools/perf/util/dso.c
+++ b/tools/perf/util/dso.c
@@ -28,8 +28,9 @@ char dso__symtab_origin(const struct dso *dso)
 	return origin[dso->symtab_type];
 }
 
-int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *filename, size_t size)
+int dso__read_binary_type_filename(const struct dso *dso,
+				   enum dso_binary_type type,
+				   char *root_dir, char *filename, size_t size)
 {
 	char build_id_hex[BUILD_ID_SIZE * 2 + 1];
 	int ret = 0;
@@ -137,19 +138,18 @@ int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
 
 static int open_dso(struct dso *dso, struct machine *machine)
 {
-	char *root_dir = (char *) "";
-	char *name;
 	int fd;
+	char *root_dir = (char *)"";
+	char *name = malloc(PATH_MAX);
 
-	name = malloc(PATH_MAX);
 	if (!name)
 		return -ENOMEM;
 
 	if (machine)
 		root_dir = machine->root_dir;
 
-	if (dso__binary_type_file(dso, dso->data_type,
-				  root_dir, name, PATH_MAX)) {
+	if (dso__read_binary_type_filename(dso, dso->data_type,
+					    root_dir, name, PATH_MAX)) {
 		free(name);
 		return -EINVAL;
 	}
diff --git a/tools/perf/util/dso.h b/tools/perf/util/dso.h
index e1cc50698137..aa3384745d75 100644
--- a/tools/perf/util/dso.h
+++ b/tools/perf/util/dso.h
@@ -128,8 +128,8 @@ void dso__read_running_kernel_build_id(struct dso *dso,
 int dso__kernel_module_get_build_id(struct dso *dso, const char *root_dir);
 
 char dso__symtab_origin(const struct dso *dso);
-int dso__binary_type_file(const struct dso *dso, enum dso_binary_type type,
-			  char *root_dir, char *filename, size_t size);
+int dso__read_binary_type_filename(const struct dso *dso, enum dso_binary_type type,
+				   char *root_dir, char *filename, size_t size);
 
 int dso__data_fd(struct dso *dso, struct machine *machine);
 ssize_t dso__data_read_offset(struct dso *dso, struct machine *machine,
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 61eb1cddf01a..9ee4b80dac57 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -1258,8 +1258,8 @@ int dso__load(struct dso *dso, struct map *map, symbol_filter_t filter)
 
 		enum dso_binary_type symtab_type = binary_type_symtab[i];
 
-		if (dso__binary_type_file(dso, symtab_type,
-					  root_dir, name, PATH_MAX))
+		if (dso__read_binary_type_filename(dso, symtab_type,
+						   root_dir, name, PATH_MAX))
 			continue;
 
 		/* Name is now the name of the next image to try */
-- 
1.8.1.4

