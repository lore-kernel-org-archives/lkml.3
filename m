Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753446Ab3AaOD1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 31 Jan 2013 09:03:27 -0500
Received: from mail-wg0-f43.google.com ([74.125.82.43]:56539 "EHLO
	mail-wg0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752997Ab3AaODY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 31 Jan 2013 09:03:24 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 1/2] perf tools: add cpu_map__get_socket()
Date: Thu, 31 Jan 2013 14:54:38 +0100
Message-Id: <1359640479-5289-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1359640479-5289-1-git-send-email-eranian@google.com>
References: <1359640479-5289-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

To get the socket number associated with a CPU.
Useful for uncore output.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/cpumap.c |   26 ++++++++++++++++++++++++++
 tools/perf/util/cpumap.h |    1 +
 2 files changed, 27 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 2b32ffa..adb2e9c 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,4 +1,5 @@
 #include "util.h"
+#include "sysfs.h"
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
@@ -201,3 +202,28 @@ void cpu_map__delete(struct cpu_map *map)
 {
 	free(map);
 }
+
+int cpu_map__get_socket(struct cpu_map *map, int idx)
+{
+	FILE *fp;
+	char path[PATH_MAX];
+	const char *sysfs;
+	int cpu, ret;
+
+	if (idx > map->nr)
+		return -1;
+
+	cpu = map->map[idx];
+
+	sysfs = sysfs_find_mountpoint();
+	if (!sysfs)
+		return -1;
+
+	sprintf(path, "%s/devices/system/cpu/cpu%d/topology/physical_package_id", sysfs, cpu);
+	fp = fopen(path, "r");
+	if (!fp)
+		return -1;
+	ret = fscanf(fp, "%d", &cpu);
+	fclose(fp);
+	return ret == 1 ? cpu : -1;
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 2f68a3b..0178e49 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -14,6 +14,7 @@ struct cpu_map *cpu_map__dummy_new(void);
 void cpu_map__delete(struct cpu_map *map);
 struct cpu_map *cpu_map__read(FILE *file);
 size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
+int cpu_map__get_socket(struct cpu_map *map, int idx);
 
 static inline int cpu_map__nr(const struct cpu_map *map)
 {
-- 
1.7.10.4

