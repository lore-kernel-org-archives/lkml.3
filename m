Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758826Ab3BFWIq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 17:08:46 -0500
Received: from terminus.zytor.com ([198.137.202.10]:37344 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758314Ab3BFWIk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 17:08:40 -0500
Date: Wed, 6 Feb 2013 14:08:12 -0800
From: tip-bot for Stephane Eranian <eranian@google.com>
Message-ID: <tip-5ac59a8a77e3faa1eaf9bfe82a61e9396b082c3d@git.kernel.org>
Cc: acme@redhat.com, linux-kernel@vger.kernel.org, eranian@google.com,
        hpa@zytor.com, mingo@kernel.org, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
Reply-To: mingo@kernel.org, hpa@zytor.com, eranian@google.com,
        linux-kernel@vger.kernel.org, acme@redhat.com, peterz@infradead.org,
        namhyung.kim@lge.com, jolsa@redhat.com, ak@linux.intel.com,
        tglx@linutronix.de, mingo@elte.hu
In-Reply-To: <1360161962-9675-2-git-send-email-eranian@google.com>
References: <1360161962-9675-2-git-send-email-eranian@google.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Add cpu_map processor socket level functions
Git-Commit-ID: 5ac59a8a77e3faa1eaf9bfe82a61e9396b082c3d
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
X-Greylist: Sender IP whitelisted, not delayed by milter-greylist-4.2.7 (terminus.zytor.com [127.0.0.1]); Wed, 06 Feb 2013 14:08:18 -0800 (PST)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  5ac59a8a77e3faa1eaf9bfe82a61e9396b082c3d
Gitweb:     http://git.kernel.org/tip/5ac59a8a77e3faa1eaf9bfe82a61e9396b082c3d
Author:     Stephane Eranian <eranian@google.com>
AuthorDate: Wed, 6 Feb 2013 15:46:01 +0100
Committer:  Arnaldo Carvalho de Melo <acme@redhat.com>
CommitDate: Wed, 6 Feb 2013 18:09:26 -0300

perf tools: Add cpu_map processor socket level functions

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
