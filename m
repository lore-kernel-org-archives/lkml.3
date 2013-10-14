Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758239Ab3JNUL3 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 14 Oct 2013 16:11:29 -0400
Received: from merlin.infradead.org ([205.233.59.134]:39140 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757802Ab3JNUDL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 14 Oct 2013 16:03:11 -0400
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Adrian Hunter <adrian.hunter@intel.com>,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Stephane Eranian <eranian@google.com>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 128/161] perf symbols: Make a separate function to parse /proc/modules
Date: Mon, 14 Oct 2013 17:01:57 -0300
Message-Id: <1381780950-25642-129-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.4
In-Reply-To: <1381780950-25642-1-git-send-email-acme@infradead.org>
References: <1381780950-25642-1-git-send-email-acme@infradead.org>
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Adrian Hunter <adrian.hunter@intel.com>

Make a separate function to parse /proc/modules so that it can be
reused.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
Cc: David Ahern <dsahern@gmail.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Mike Galbraith <efault@gmx.de>
Cc: Namhyung Kim <namhyung@gmail.com>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Stephane Eranian <eranian@google.com>
Link: http://lkml.kernel.org/r/1381221956-16699-2-git-send-email-adrian.hunter@intel.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/machine.c | 67 +++++++++++++----------------------------------
 tools/perf/util/symbol.c  | 58 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h  |  3 +++
 3 files changed, 79 insertions(+), 49 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index 901397ae82be..6b861aefd99a 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -793,12 +793,22 @@ static int machine__set_modules_path(struct machine *machine)
 	return map_groups__set_modules_path_dir(&machine->kmaps, modules_path);
 }
 
-static int machine__create_modules(struct machine *machine)
+static int machine__create_module(void *arg, const char *name, u64 start)
 {
-	char *line = NULL;
-	size_t n;
-	FILE *file;
+	struct machine *machine = arg;
 	struct map *map;
+
+	map = machine__new_module(machine, start, name);
+	if (map == NULL)
+		return -1;
+
+	dso__kernel_module_get_build_id(map->dso, machine->root_dir);
+
+	return 0;
+}
+
+static int machine__create_modules(struct machine *machine)
+{
 	const char *modules;
 	char path[PATH_MAX];
 
@@ -812,56 +822,15 @@ static int machine__create_modules(struct machine *machine)
 	if (symbol__restricted_filename(modules, "/proc/modules"))
 		return -1;
 
-	file = fopen(modules, "r");
-	if (file == NULL)
+	if (modules__parse(modules, machine, machine__create_module))
 		return -1;
 
-	while (!feof(file)) {
-		char name[PATH_MAX];
-		u64 start;
-		char *sep;
-		int line_len;
-
-		line_len = getline(&line, &n, file);
-		if (line_len < 0)
-			break;
-
-		if (!line)
-			goto out_failure;
-
-		line[--line_len] = '\0'; /* \n */
-
-		sep = strrchr(line, 'x');
-		if (sep == NULL)
-			continue;
-
-		hex2u64(sep + 1, &start);
-
-		sep = strchr(line, ' ');
-		if (sep == NULL)
-			continue;
-
-		*sep = '\0';
-
-		snprintf(name, sizeof(name), "[%s]", line);
-		map = machine__new_module(machine, start, name);
-		if (map == NULL)
-			goto out_delete_line;
-		dso__kernel_module_get_build_id(map->dso, machine->root_dir);
-	}
+	if (!machine__set_modules_path(machine))
+		return 0;
 
-	free(line);
-	fclose(file);
+	pr_debug("Problems setting modules path maps, continuing anyway...\n");
 
-	if (machine__set_modules_path(machine) < 0) {
-		pr_debug("Problems setting modules path maps, continuing anyway...\n");
-	}
 	return 0;
-
-out_delete_line:
-	free(line);
-out_failure:
-	return -1;
 }
 
 int machine__create_kernel_maps(struct machine *machine)
diff --git a/tools/perf/util/symbol.c b/tools/perf/util/symbol.c
index 48c38791d61b..5fd95135e838 100644
--- a/tools/perf/util/symbol.c
+++ b/tools/perf/util/symbol.c
@@ -500,6 +500,64 @@ out_failure:
 	return -1;
 }
 
+int modules__parse(const char *filename, void *arg,
+		   int (*process_module)(void *arg, const char *name,
+					 u64 start))
+{
+	char *line = NULL;
+	size_t n;
+	FILE *file;
+	int err = 0;
+
+	file = fopen(filename, "r");
+	if (file == NULL)
+		return -1;
+
+	while (1) {
+		char name[PATH_MAX];
+		u64 start;
+		char *sep;
+		ssize_t line_len;
+
+		line_len = getline(&line, &n, file);
+		if (line_len < 0) {
+			if (feof(file))
+				break;
+			err = -1;
+			goto out;
+		}
+
+		if (!line) {
+			err = -1;
+			goto out;
+		}
+
+		line[--line_len] = '\0'; /* \n */
+
+		sep = strrchr(line, 'x');
+		if (sep == NULL)
+			continue;
+
+		hex2u64(sep + 1, &start);
+
+		sep = strchr(line, ' ');
+		if (sep == NULL)
+			continue;
+
+		*sep = '\0';
+
+		scnprintf(name, sizeof(name), "[%s]", line);
+
+		err = process_module(arg, name, start);
+		if (err)
+			break;
+	}
+out:
+	free(line);
+	fclose(file);
+	return err;
+}
+
 struct process_kallsyms_args {
 	struct map *map;
 	struct dso *dso;
diff --git a/tools/perf/util/symbol.h b/tools/perf/util/symbol.h
index 9b8b213a62c1..2d3eb43ab9f9 100644
--- a/tools/perf/util/symbol.h
+++ b/tools/perf/util/symbol.h
@@ -223,6 +223,9 @@ int sysfs__read_build_id(const char *filename, void *bf, size_t size);
 int kallsyms__parse(const char *filename, void *arg,
 		    int (*process_symbol)(void *arg, const char *name,
 					  char type, u64 start));
+int modules__parse(const char *filename, void *arg,
+		   int (*process_module)(void *arg, const char *name,
+					 u64 start));
 int filename__read_debuglink(const char *filename, char *debuglink,
 			     size_t size);
 
-- 
1.8.1.4

