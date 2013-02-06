Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756051Ab3BFOqp (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 09:46:45 -0500
Received: from mail-we0-f174.google.com ([74.125.82.174]:45151 "EHLO
	mail-we0-f174.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754169Ab3BFOqT (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 09:46:19 -0500
From: Stephane Eranian <eranian@google.com>
To: linux-kernel@vger.kernel.org
Cc: peterz@infradead.org, mingo@elte.hu, ak@linux.intel.com, acme@redhat.com,
        jolsa@redhat.com, namhyung.kim@lge.com
Subject: [PATCH 1/2] perf tools: add cpu_map processor socket level functions
Date: Wed,  6 Feb 2013 15:46:01 +0100
Message-Id: <1360161962-9675-2-git-send-email-eranian@google.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1360161962-9675-1-git-send-email-eranian@google.com>
References: <1360161962-9675-1-git-send-email-eranian@google.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds:
- cpu_map__get_socket: get socked id from cpu
- cpu_map__build_socket_map: build socket map
- cpu_map__socket: gets acutal socket from logical socket

Those functions are used by uncore and processor socket-level
aggregation modes.

Signed-off-by: Stephane Eranian <eranian@google.com>
---
 tools/perf/util/cpumap.c |   54 ++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h |    9 ++++++++
 2 files changed, 63 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 2b32ffa..f817046 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -1,4 +1,5 @@
 #include "util.h"
+#include "sysfs.h"
 #include "../perf.h"
 #include "cpumap.h"
 #include <assert.h>
@@ -201,3 +202,56 @@ void cpu_map__delete(struct cpu_map *map)
 {
 	free(map);
 }
+
+int cpu_map__get_socket(struct cpu_map *map, int idx)
+{
+	FILE *fp;
+	const char *mnt;
+	char path[PATH_MAX];
+	int cpu, ret;
+
+	if (idx > map->nr)
+		return -1;
+
+	cpu = map->map[idx];
+
+	mnt = sysfs_find_mountpoint();
+	if (!mnt)
+		return -1;
+
+	sprintf(path,
+		"%s/devices/system/cpu/cpu%d/topology/physical_package_id",
+		mnt, cpu);
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -1;
+	ret = fscanf(fp, "%d", &cpu);
+	fclose(fp);
+	return ret == 1 ? cpu : -1;
+}
+
+int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp)
+{
+	struct cpu_map *sock;
+	int nr = cpus->nr;
+	int cpu, s1, s2;
+
+	sock = calloc(1, sizeof(*sock) + nr * sizeof(int));
+	if (!sock)
+		return -1;
+
+	for (cpu = 0; cpu < nr; cpu++) {
+		s1 = cpu_map__get_socket(cpus, cpu);
+		for (s2 = 0; s2 < sock->nr; s2++) {
+			if (s1 == sock->map[s2])
+				break;
+		}
+		if (s2 == sock->nr) {
+			sock->map[sock->nr] = s1;
+			sock->nr++;
+		}
+	}
+	*sockp = sock;
+	return 0;
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 2f68a3b..161b007 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -14,6 +14,15 @@ struct cpu_map *cpu_map__dummy_new(void);
 void cpu_map__delete(struct cpu_map *map);
 struct cpu_map *cpu_map__read(FILE *file);
 size_t cpu_map__fprintf(struct cpu_map *map, FILE *fp);
+int cpu_map__get_socket(struct cpu_map *map, int idx);
+int cpu_map__build_socket_map(struct cpu_map *cpus, struct cpu_map **sockp);
+
+static inline int cpu_map__socket(struct cpu_map *sock, int s)
+{
+	if (!sock || s > sock->nr || s < 0)
+		return 0;
+	return sock->map[s];
+}
 
 static inline int cpu_map__nr(const struct cpu_map *map)
 {
-- 
1.7.9.5

