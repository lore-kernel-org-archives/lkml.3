Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752500AbaGPUFf (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jul 2014 16:05:35 -0400
Received: from mx1.redhat.com ([209.132.183.28]:48957 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751864AbaGPUDN (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jul 2014 16:03:13 -0400
From: Jiri Olsa <jolsa@kernel.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Arnaldo Carvalho de Melo <acme@kernel.org>,
        Andi Kleen <ak@linux.intel.com>, Jiri Olsa <jolsa@kernel.org>
Subject: [PATCH 08/13] perf tools: Automatically look for event file name for cpu
Date: Wed, 16 Jul 2014 22:02:44 +0200
Message-Id: <1405540969-18975-9-git-send-email-jolsa@kernel.org>
In-Reply-To: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
References: <1405540969-18975-1-git-send-email-jolsa@kernel.org>
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

Signed-off-by: Andi Kleen <ak@linux.intel.com>
Acked-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/n/1405123165-22666-7-git-send-email-andi@firstfloor.org
Signed-off-by: Jiri Olsa <jolsa@kernel.org>
---
 tools/perf/arch/x86/util/header.c | 19 ++++++++++++++++---
 tools/perf/util/jevents.c         | 40 +++++++++++++++++++++++++++++++++++++++
 tools/perf/util/jevents.h         |  1 +
 tools/perf/util/pmu.c             |  2 +-
 4 files changed, 58 insertions(+), 4 deletions(-)

diff --git a/tools/perf/arch/x86/util/header.c b/tools/perf/arch/x86/util/header.c
index 146d12a1cec0..76e0ece09b49 100644
--- a/tools/perf/arch/x86/util/header.c
+++ b/tools/perf/arch/x86/util/header.c
@@ -5,6 +5,7 @@
 #include <string.h>
 
 #include "../../util/header.h"
+#include "../../util/jevents.h"
 
 static inline void
 cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
@@ -19,8 +20,8 @@ cpuid(unsigned int op, unsigned int *a, unsigned int *b, unsigned int *c,
 			: "a" (op));
 }
 
-int
-get_cpuid(char *buffer, size_t sz)
+static int
+__get_cpuid(char *buffer, size_t sz, const char *fmt)
 {
 	unsigned int a, b, c, d, lvl;
 	int family = -1, model = -1, step = -1;
@@ -48,7 +49,7 @@ get_cpuid(char *buffer, size_t sz)
 		if (family >= 0x6)
 			model += ((a >> 16) & 0xf) << 4;
 	}
-	nb = scnprintf(buffer, sz, "%s,%u,%u,%u$", vendor, family, model, step);
+	nb = scnprintf(buffer, sz, fmt, vendor, family, model, step);
 
 	/* look for end marker to ensure the entire data fit */
 	if (strchr(buffer, '$')) {
@@ -57,3 +58,15 @@ get_cpuid(char *buffer, size_t sz)
 	}
 	return -1;
 }
+
+int get_cpuid(char *buffer, size_t sz)
+{
+	return __get_cpuid(buffer, sz, "%s,%u,%u,%u$");
+}
+
+char *get_cpu_str(void)
+{
+	char *buf = malloc(128);
+	__get_cpuid(buf, 128, "%s-%d-%X-core");
+	return buf;
+}
diff --git a/tools/perf/util/jevents.c b/tools/perf/util/jevents.c
index a23f57f112da..418502ac0560 100644
--- a/tools/perf/util/jevents.c
+++ b/tools/perf/util/jevents.c
@@ -38,6 +38,44 @@
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
@@ -170,6 +208,8 @@ int json_events(const char *fn,
 	int i, j, len;
 	char *map;
 
+	if (!fn)
+		fn = json_default_name();
 	tokens = parse_json(fn, &map, &size, &len);
 	if (!tokens)
 		return -EIO;
diff --git a/tools/perf/util/jevents.h b/tools/perf/util/jevents.h
index fbc45497078e..86a94ddc9f7d 100644
--- a/tools/perf/util/jevents.h
+++ b/tools/perf/util/jevents.h
@@ -4,5 +4,6 @@
 int json_events(const char *fn,
 		int (*func)(void *data, char *name, char *event, char *desc),
 		void *data);
+char *get_cpu_str(void);
 
 #endif
diff --git a/tools/perf/util/pmu.c b/tools/perf/util/pmu.c
index 9f154afc95fe..fa2131947ad3 100644
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
1.8.3.1

