Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933347Ab3JOFbe (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Oct 2013 01:31:34 -0400
Received: from terminus.zytor.com ([198.137.202.10]:33585 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932673Ab3JOFb2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Oct 2013 01:31:28 -0400
Date: Mon, 14 Oct 2013 22:31:09 -0700
From: tip-bot for Adrian Hunter <tipbot@zytor.com>
Message-ID: <tip-316d70d6dbde540b275289563cbddd9f0c903fc6@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        paulus@samba.org, hpa@zytor.com, mingo@kernel.org,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, adrian.hunter@intel.com,
        dsahern@gmail.com, tglx@linutronix.de
Reply-To: mingo@kernel.org, hpa@zytor.com, paulus@samba.org,
        eranian@google.com, linux-kernel@vger.kernel.org, acme@redhat.com,
        a.p.zijlstra@chello.nl, efault@gmx.de, namhyung@gmail.com,
        jolsa@redhat.com, fweisbec@gmail.com, dsahern@gmail.com,
        adrian.hunter@intel.com, tglx@linutronix.de
In-Reply-To: <1381221956-16699-2-git-send-email-adrian.hunter@intel.com>
References: <1381221956-16699-2-git-send-email-adrian.hunter@intel.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf symbols: Make a separate function to parse /
 proc/modules
Git-Commit-ID: 316d70d6dbde540b275289563cbddd9f0c903fc6
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.5.1 (terminus.zytor.com [127.0.0.1]); Mon, 14 Oct 2013 22:31:15 -0700 (PDT)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  316d70d6dbde540b275289563cbddd9f0c903fc6
Gitweb:     http://git.kernel.org/tip/316d70d6dbde540b275289563cbddd9f0c903fc6
Author:     Adrian Hunter <adrian.hunter@intel.com>
AuthorDate: Tue, 8 Oct 2013 11:45:48 +0300
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Fri, 11 Oct 2013 12:17:57 -0300

perf symbols: Make a separate function to parse /proc/modules

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
index 901397a..6b861ae 100644
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
index 48c3879..5fd9513 100644
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
index 9b8b213..2d3eb43 100644
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
 
