Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754472Ab3AZUGW (ORCPT <rfc822;w@1wt.eu>);
	Sat, 26 Jan 2013 15:06:22 -0500
Received: from mx1.redhat.com ([209.132.183.28]:34471 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754292Ab3AZUGS (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sat, 26 Jan 2013 15:06:18 -0500
From: Jiri Olsa <jolsa@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Jiri Olsa <jolsa@redhat.com>, Corey Ashford <cjashfor@linux.vnet.ibm.com>,
        Frederic Weisbecker <fweisbec@gmail.com>, Ingo Molnar <mingo@elte.hu>,
        Namhyung Kim <namhyung@kernel.org>, Paul Mackerras <paulus@samba.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Arnaldo Carvalho de Melo <acme@redhat.com>,
        Andi Kleen <ak@linux.intel.com>, Stephane Eranian <eranian@google.com>
Subject: [PATCH 5/8] perf tools: Add support to include non architectural event aliases
Date: Sat, 26 Jan 2013 21:04:07 +0100
Message-Id: <1359230650-10415-6-git-send-email-jolsa@redhat.com>
In-Reply-To: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
References: <1359230650-10415-1-git-send-email-jolsa@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Adding support to parse non architectural event aliases
for given cpu. These aliases will be provided as single
files parsed by pmu_aliases_parse_multi function.

Signed-off-by: Jiri Olsa <jolsa@redhat.com>
Cc: Corey Ashford <cjashfor@linux.vnet.ibm.com>
Cc: Frederic Weisbecker <fweisbec@gmail.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Namhyung Kim <namhyung@kernel.org>
Cc: Paul Mackerras <paulus@samba.org>
Cc: Peter Zijlstra <a.p.zijlstra@chello.nl>
Cc: Arnaldo Carvalho de Melo <acme@redhat.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Stephane Eranian <eranian@google.com>
---
 tools/perf/arch/x86/Makefile   |   7 +++
 tools/perf/arch/x86/util/pmu.c | 121 +++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/pmu.c          |  16 ++++--
 tools/perf/util/pmu.h          |   2 +
 4 files changed, 141 insertions(+), 5 deletions(-)
 create mode 100644 tools/perf/arch/x86/util/pmu.c

diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 815841c..c175f65 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -6,3 +6,10 @@ ifndef NO_LIBUNWIND
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/pmu.o
+
+$(OUTPUT)$(OUTPUT)arch/$(ARCH)/util/pmu.o: $(OUTPUT)arch/$(ARCH)/util/pmu.c $(OUTPUT)PERF-CFLAGS
+	$(QUIET_CC)$(CC) -o $@ -c $(ALL_CFLAGS) \
+	 '-DPERF_EXEC_PATH="$(perfexecdir_SQ)"' \
+	 '-DPREFIX="$(prefix_SQ)"' \
+	 $<
diff --git a/tools/perf/arch/x86/util/pmu.c b/tools/perf/arch/x86/util/pmu.c
new file mode 100644
index 0000000..a37da52
--- /dev/null
+++ b/tools/perf/arch/x86/util/pmu.c
@@ -0,0 +1,121 @@
+
+#include <linux/compiler.h>
+#include <linux/kernel.h>
+#include <stdio.h>
+#include <sys/types.h>
+#include <sys/stat.h>
+#include <unistd.h>
+#include "pmu.h"
+#include "util.h"
+#include "sysfs.h"
+
+static int add_aliases(struct list_head *head, char *path, const char **files)
+{
+	char file[PATH_MAX];
+	int ret = 0;
+
+	while (!ret && *files) {
+		scnprintf(file, PATH_MAX, "%s/%s", path, *files);
+		ret = pmu_aliases_parse_multi(file, head);
+		files++;
+	}
+
+	return ret;
+}
+
+#define ADD_ALIASES(...)				\
+do {							\
+	const char *__files[] = { __VA_ARGS__ , NULL };	\
+	return add_aliases(head, path, __files);	\
+} while (0)
+
+static int get_path(const char *vendor, char *path, int size)
+{
+	struct stat st;
+
+	/* try local one first */
+	scnprintf(path, size, "./arch/x86/events/%s/", vendor);
+
+	if (stat(path, &st) < 0) {
+		/* and installed later */
+		scnprintf(path, size, "%s/%s/events/x86/%s/",
+			  PREFIX, PERF_EXEC_PATH, vendor);
+
+		if (stat(path, &st) < 0)
+			return -1;
+	}
+
+	return 0;
+}
+
+static int intel_aliases(struct list_head *head, unsigned model)
+{
+	char path[PATH_MAX];
+
+	if (get_path("intel", path, PATH_MAX))
+		return -1;
+
+	switch (model) {
+	default:
+		ADD_ALIASES("");
+		break;
+	}
+
+	return 0;
+}
+
+static int cpu_specs(unsigned *vendor, unsigned *model)
+{
+	FILE *file;
+	struct stat st;
+	char path[PATH_MAX];
+	int ret = 0;
+
+	scnprintf(path, PATH_MAX, "%s/devices/system/cpu/modalias",
+		  sysfs_find_mountpoint());
+
+	if (stat(path, &st) < 0)
+		return -ENOENT;
+
+	file = fopen(path, "r");
+	if (!file)
+		return -errno;
+
+	if (2 != fscanf(file, "x86cpu:vendor:%X:family:%*X:model:%X:",
+			vendor, model))
+		ret = -1;
+
+	fclose(file);
+	return ret;
+}
+
+static int cpu_aliases(struct list_head *head)
+{
+	unsigned vendol, model;
+	int ret;
+
+	ret = cpu_specs(&vendol, &model);
+	if (ret) {
+		pr_info("failed to get cpu aliases");
+		return 0;
+	}
+
+	switch (vendol) {
+	/* Intel */
+	case 0:
+		return intel_aliases(head, model);
+	default:
+		/* unknown vendor.. plenty to cover ;-) */
+		return 0;
+	}
+
+	return 0;
+}
+
+int arch_pmu_aliases(char *name, struct list_head *head)
+{
+	if (!strcmp(name, "cpu"))
+		return cpu_aliases(head);
+
+	return 0;
+}
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 68d6c86..7c2908b 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -219,6 +219,13 @@ static int pmu_aliases_parse(char *dir, struct list_head *head)
 	return ret;
 }
 
+__attribute__((weak))
+int arch_pmu_aliases(char *name __maybe_unused,
+		     struct list_head *head __maybe_unused)
+{
+	return 0;
+}
+
 /*
  * Reading the pmu event aliases definition, which should be located at:
  * /sys/bus/event_source/devices/<dev>/events as sysfs group attributes.
@@ -236,13 +243,12 @@ static int pmu_aliases(char *name, struct list_head *head)
 	snprintf(path, PATH_MAX,
 		 "%s/bus/event_source/devices/%s/events", sysfs, name);
 
-	if (stat(path, &st) < 0)
-		return 0;	 /* no error if 'events' does not exist */
-
-	if (pmu_aliases_parse(path, head))
+	/* no error if 'events' does not exist */
+	if (!stat(path, &st) &&
+	    pmu_aliases_parse(path, head))
 		return -1;
 
-	return 0;
+	return arch_pmu_aliases(name, head);
 }
 
 static int pmu_alias_terms(struct perf_pmu_alias *alias,
diff --git a/tools/perf/util/pmu.h b/tools/perf/util/pmu.h
index add249b..aa049ea 100644
--- a/tools/perf/util/pmu.h
+++ b/tools/perf/util/pmu.h
@@ -45,5 +45,7 @@ char *perf_pmu__event_name(struct list_head *head_terms, bool remove);
 
 int pmu_aliases_parse_multi(char *path, struct list_head *head);
 
+int arch_pmu_aliases(char *name, struct list_head *head);
+
 int perf_pmu__test(void);
 #endif /* __PMU_H */
-- 
1.7.11.7

