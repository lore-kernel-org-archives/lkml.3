Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753101Ab3IVKP7 (ORCPT <rfc822;w@1wt.eu>);
	Sun, 22 Sep 2013 06:15:59 -0400
Received: from mga01.intel.com ([192.55.52.88]:37121 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753052Ab3IVKP4 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 22 Sep 2013 06:15:56 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.90,956,1371106800"; 
   d="scan'208";a="405354055"
From: Adrian Hunter <adrian.hunter@intel.com>
To: Arnaldo Carvalho de Melo <acme@ghostprotocols.net>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>, linux-kernel@vger.kernel.org,
        David Ahern <dsahern@gmail.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Jiri Olsa <jolsa@redhat.com>,
        Mike Galbraith <efault@gmx.de>, Namhyung Kim <namhyung@gmail.com>,
        Paul Mackerras <paulus@samba.org>,
        Stephane Eranian <eranian@google.com>
Subject: [PATCH V2 02/10] perf tools: make a separate function to parse /proc/modules
Date: Sun, 22 Sep 2013 13:22:10 +0300
Message-Id: <1379845338-29637-3-git-send-email-adrian.hunter@intel.com>
X-Mailer: git-send-email 1.7.11.7
In-Reply-To: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
References: <1379845338-29637-1-git-send-email-adrian.hunter@intel.com>
Organization: Intel Finland Oy, Registered Address: PL 281, 00181 Helsinki, Business Identity Code: 0357606 - 4, Domiciled in Helsinki
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Make a separate function to parse /proc/modules
so that it can be reused.

Signed-off-by: Adrian Hunter <adrian.hunter@intel.com>
---
 tools/perf/util/machine.c | 67 +++++++++++++----------------------------------
 tools/perf/util/symbol.c  | 58 ++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/symbol.h  |  3 +++
 3 files changed, 79 insertions(+), 49 deletions(-)

diff --git a/tools/perf/util/machine.c b/tools/perf/util/machine.c
index ddf917b..83b615bc 100644
--- a/tools/perf/util/machine.c
+++ b/tools/perf/util/machine.c
@@ -776,12 +776,22 @@ static int machine__set_modules_path(struct machine *machine)
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
 
@@ -795,56 +805,15 @@ static int machine__create_modules(struct machine *machine)
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
index 48c3879..ffdf2e7 100644
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
+		snprintf(name, sizeof(name), "[%s]", line);
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
index 2d4ee9a..a2543f0 100644
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
1.7.11.7

