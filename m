Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758521Ab3BFVru (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 16:47:50 -0500
Received: from merlin.infradead.org ([205.233.59.134]:57288 "EHLO
	merlin.infradead.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758695Ab3BFVoc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 16:44:32 -0500
From: Arnaldo Carvalho de Melo <acme@infradead.org>
To: Ingo Molnar <mingo@kernel.org>
Cc: linux-kernel@vger.kernel.org, Stephane Eranian <eranian@google.com>,
        Andi Kleen <ak@linux.intel.com>, Ingo Molnar <mingo@elte.hu>,
        Jiri Olsa <jolsa@redhat.com>, Namhyung Kim <namhyung.kim@lge.com>,
        Peter Zijlstra <peterz@infradead.org>,
        Arnaldo Carvalho de Melo <acme@redhat.com>
Subject: [PATCH 09/17] perf tools: Add cpu_map processor socket level functions
Date: Wed,  6 Feb 2013 18:44:11 -0300
Message-Id: <1360187059-12661-10-git-send-email-acme@infradead.org>
X-Mailer: git-send-email 1.8.1.1.361.gec3ae6e
In-Reply-To: <1360187059-12661-1-git-send-email-acme@infradead.org>
References: <1360187059-12661-1-git-send-email-acme@infradead.org>
Content-Type: text/plain; charset="utf-8"
X-SRS-Rewrite: SMTP reverse-path rewritten from <acme@infradead.org> by merlin.infradead.org
	See http://www.infradead.org/rpr.html
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Stephane Eranian <eranian@google.com>

This patch adds:
- cpu_map__get_socket: get socked id from cpu
- cpu_map__build_socket_map: build socket map
- cpu_map__socket: gets acutal socket from logical socket

Those functions are used by uncore and processor socket-level
aggregation modes.

Signed-off-by: Stephane Eranian <eranian@google.com>
Cc: Andi Kleen <ak@linux.intel.com>
Cc: Ingo Molnar <mingo@elte.hu>
Cc: Jiri Olsa <jolsa@redhat.com>
Cc: Namhyung Kim <namhyung.kim@lge.com>
Cc: Peter Zijlstra <peterz@infradead.org>
Link: http://lkml.kernel.org/r/1360161962-9675-2-git-send-email-eranian@google.com
Signed-off-by: Arnaldo Carvalho de Melo <acme@redhat.com>
---
 tools/perf/util/cpumap.c | 54 ++++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h |  9 ++++++++
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
1.8.1.1.361.gec3ae6e

