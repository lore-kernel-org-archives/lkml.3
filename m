Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754222AbaF0XQd (ORCPT <rfc822;w@1wt.eu>);
	Fri, 27 Jun 2014 19:16:33 -0400
Received: from mga09.intel.com ([134.134.136.24]:50741 "EHLO mga09.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754426AbaF0XQb (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 27 Jun 2014 19:16:31 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="5.01,564,1400050800"; 
   d="scan'208";a="564749653"
From: Andi Kleen <andi@firstfloor.org>
To: jolsa@redhat.com
Cc: linux-kernel@vger.kernel.org, namhyung@kernel.org, acme@infradead.org,
        Andi Kleen <ak@linux.intel.com>
Subject: [PATCH 4/9] perf, tools: Automatically look for event file name for cpu v3
Date: Fri, 27 Jun 2014 16:15:59 -0700
Message-Id: <1403910964-11017-5-git-send-email-andi@firstfloor.org>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
References: <1403910964-11017-1-git-send-email-andi@firstfloor.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Andi Kleen <ak@linux.intel.com>

When no JSON event file is specified automatically look
for a suitable file in ~/.cache/pmu-events. A "perf download" can
automatically add files there for the current CPUs.

This does not include the actual event files with perf,
but they can be automatically downloaded instead
(implemented in the next patch)

This has the advantage that the events can be always uptodate,
because they are freshly downloaded. In oprofile we always
had problems with out of date or incomplete events files.

The event file format is per architecture, but can be
extended for other architectures.

v2: Supports XDG_CACHE_HOME and defaults to ~/.cache/pmu-events
v3: Minor updates and handle EVENTMAP.
Acked-by: Namhyung Kim <namhyung@kernel.org>
Signed-off-by: Andi Kleen <ak@linux.intel.com>
---
 tools/perf/arch/x86/Makefile      |  1 +
 tools/perf/arch/x86/util/cpustr.c | 34 ++++++++++++++++++++++++++++++++
 tools/perf/util/jevents.c         | 41 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/jevents.h         |  1 +
 tools/perf/util/pmu.c             |  2 +-
 5 files changed, 78 insertions(+), 1 deletion(-)
 create mode 100644 tools/perf/arch/x86/util/cpustr.c

diff --git a/tools/perf/arch/x86/Makefile b/tools/perf/arch/x86/Makefile
index 1641542..0efeb14 100644
--- a/tools/perf/arch/x86/Makefile
+++ b/tools/perf/arch/x86/Makefile
@@ -14,4 +14,5 @@ LIB_OBJS += $(OUTPUT)arch/$(ARCH)/tests/dwarf-unwind.o
 endif
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/header.o
 LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/tsc.o
+LIB_OBJS += $(OUTPUT)arch/$(ARCH)/util/cpustr.o
 LIB_H += arch/$(ARCH)/util/tsc.h
diff --git a/tools/perf/arch/x86/util/cpustr.c b/tools/perf/arch/x86/util/cpustr.c
new file mode 100644
index 0000000..e1cd76c
--- /dev/null
+++ b/tools/perf/arch/x86/util/cpustr.c
@@ -0,0 +1,34 @@
+#include <stdio.h>
+#include <stdlib.h>
+#include "../../util/jevents.h"
+
+char *get_cpu_str(void)
+{
+	char *line = NULL;
+	size_t llen = 0;
+	int found = 0, n;
+	char vendor[30];
+	int model, fam;
+	char *res = NULL;
+	FILE *f = fopen("/proc/cpuinfo", "r");
+
+	if (!f)
+		return NULL;
+	while (getline(&line, &llen, f) > 0) {
+		if (sscanf(line, "vendor_id : %30s", vendor) == 1)
+			found++;
+		else if (sscanf(line, "model : %d", &model) == 1)
+			found++;
+		else if (sscanf(line, "cpu family : %d", &fam) == 1)
+			found++;
+		if (found == 3) {
+			n = asprintf(&res, "%s-%d-%X-core", vendor, fam, model);
+			if (n < 0)
+				res = NULL;
+			break;
+		}
+	}
+	free(line);
+	fclose(f);
+	return res;
+}
diff --git a/tools/perf/util/jevents.c b/tools/perf/util/jevents.c
index 943a1fc..1fae0b7 100644
--- a/tools/perf/util/jevents.c
+++ b/tools/perf/util/jevents.c
@@ -33,10 +33,49 @@
 #include <errno.h>
 #include <string.h>
 #include <ctype.h>
+#include "cache.h"
 #include "jsmn.h"
 #include "json.h"
 #include "jevents.h"
 
+__attribute__((weak)) char *get_cpu_str(void)
+{
+	return NULL;
+}
+
+static const char *json_default_name(void)
+{
+	char *cache;
+	char *idstr = get_cpu_str();
+	char *res = NULL;
+	char *home = NULL;
+	char *emap;
+
+	emap = getenv("EVENTMAP");
+	if (emap) {
+		if (access(emap, R_OK) == 0)
+			return emap;
+		if (asprintf(&idstr, "%s-core", emap) < 0)
+			return NULL;
+	}
+
+	cache = getenv("XDG_CACHE_HOME");
+	if (!cache) {
+		home = getenv("HOME");
+		if (!home || asprintf(&cache, "%s/.cache", home) < 0)
+			goto out;
+	}
+	if (cache && idstr)
+		res = mkpath("%s/pmu-events/%s.json",
+			     cache,
+			     idstr);
+	if (home)
+		free(cache);
+out:
+	free(idstr);
+	return res;
+}
+
 static void addfield(char *map, char **dst, const char *sep,
 		     const char *a, jsmntok_t *bt)
 {
@@ -174,6 +213,8 @@ int json_events(const char *fn,
 	int i, j, len;
 	char *map;
 
+	if (!fn)
+		fn = json_default_name();
 	tokens = parse_json(fn, &map, &size, &len);
 	if (!tokens)
 		return -EIO;
diff --git a/tools/perf/util/jevents.h b/tools/perf/util/jevents.h
index 4c2b879..6a377a8 100644
--- a/tools/perf/util/jevents.h
+++ b/tools/perf/util/jevents.h
@@ -1,3 +1,4 @@
 int json_events(const char *fn,
 		int (*func)(void *data, char *name, char *event, char *desc),
 		void *data);
+char *get_cpu_str(void);
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 9f154af..fa21319 100644
--- a/tools/perf/util/pmu.c
+++ b/tools/perf/util/pmu.c
@@ -433,7 +433,7 @@ static struct perf_pmu *pmu_lookup(const char *name)
 	if (pmu_aliases(name, &aliases))
 		return NULL;
 
-	if (!strcmp(name, "cpu") && json_file)
+	if (!strcmp(name, "cpu"))
 		json_events(json_file, add_alias, &aliases);
 
 	if (pmu_type(name, &type))
-- 
1.9.3

