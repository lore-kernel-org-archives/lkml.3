Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753835AbaB1RvG (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:51:06 -0500
Received: from mx1.redhat.com ([209.132.183.28]:31513 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753176AbaB1Rne (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:34 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 04/19] perf: Allow ability to map cpus to nodes easily
Date: Fri, 28 Feb 2014 12:42:53 -0500
Message-Id: <1393609388-40489-5-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch figures out the max number of cpus and nodes that are on the
system and creates a map of cpu to node.  This allows us to provide a cpu
and quickly get the node associated with it.

It was mostly copied from builtin-kmem.c and tweaked slightly to use less memory
(use possible cpus instead of max).  It also calculates the max number of nodes.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/cpumap.c | 150 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h |  35 +++++++++++
 2 files changed, 185 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 7fe4994..d19d5b3 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -317,3 +317,153 @@ int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep)
 {
 	return cpu_map__build_map(cpus, corep, cpu_map__get_core);
 }
+
+/* setup simple routines to easily access node numbers given a cpu number */
+
+
+#define PATH_SYS_NODE   "/sys/devices/system/node"
+
+/* Determine highest possible cpu in the system for sparse allocation */
+static void set_max_cpu_num(void)
+{
+	FILE *fp;
+	char buf[256];
+	int num;
+
+	/* set up default */
+	max_cpu_num = 4096;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	fp = fopen("/sys/devices/system/cpu/possible", "r");
+	if (!fp)
+		goto out;
+
+	num = fread(&buf, 1, sizeof(buf), fp);
+	if (!num)
+		goto out_close;
+	buf[num] = '\0';
+
+	/* start on the right, to find highest cpu num */
+	while (--num) {
+		if ((buf[num] == ',') || (buf[num] == '-')) {
+			num++;
+			break;
+		}
+	}
+	if (sscanf(&buf[num], "%d", &max_cpu_num) < 1)
+		goto out_close;
+
+	max_cpu_num++;
+
+	fclose(fp);
+	return;
+
+out_close:
+	fclose(fp);
+out:
+	pr_err("Failed to read max cpus, using default of %d\n",
+		max_cpu_num);
+	return;
+}
+
+/* Determine highest possible node in the system for sparse allocation */
+static void set_max_node_num(void)
+{
+	FILE *fp;
+	char buf[256];
+	int num;
+
+	/* set up default */
+	max_node_num = 8;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	fp = fopen("/sys/devices/system/node/possible", "r");
+	if (!fp)
+		goto out;
+
+	num = fread(&buf, 1, sizeof(buf), fp);
+	if (!num)
+		goto out_close;
+	buf[num] = '\0';
+
+	/* start on the right, to find highest node num */
+	while (--num) {
+		if ((buf[num] == ',') || (buf[num] == '-')) {
+			num++;
+			break;
+		}
+	}
+	if (sscanf(&buf[num], "%d", &max_node_num) < 1)
+		goto out_close;
+
+	max_node_num++;
+
+	fclose(fp);
+	return;
+
+out_close:
+	fclose(fp);
+out:
+	pr_err("Failed to read max nodes, using default of %d\n",
+		max_node_num);
+	return;
+}
+
+static int init_cpunode_map(void)
+{
+	int i;
+
+	set_max_cpu_num();
+	set_max_node_num();
+
+	cpunode_map = calloc(max_cpu_num, sizeof(int));
+	if (!cpunode_map) {
+		pr_err("%s: calloc failed\n", __func__);
+		goto out;
+	}
+
+	for (i = 0; i < max_cpu_num; i++)
+		cpunode_map[i] = -1;
+
+	return 0;
+out:
+	return -1;
+}
+
+int cpu_map__setup_cpunode_map(void)
+{
+	struct dirent *dent1, *dent2;
+	DIR *dir1, *dir2;
+	unsigned int cpu, mem;
+	char buf[PATH_MAX];
+
+	/* initialize globals */
+	if (init_cpunode_map())
+		return -1;
+
+	dir1 = opendir(PATH_SYS_NODE);
+	if (!dir1)
+		return 0;
+
+	/* walk tree and setup map */
+	while ((dent1 = readdir(dir1)) != NULL) {
+		if (dent1->d_type != DT_DIR ||
+		    sscanf(dent1->d_name, "node%u", &mem) < 1)
+			continue;
+
+		snprintf(buf, PATH_MAX, "%s/%s", PATH_SYS_NODE, dent1->d_name);
+		dir2 = opendir(buf);
+		if (!dir2)
+			continue;
+		while ((dent2 = readdir(dir2)) != NULL) {
+			if (dent2->d_type != DT_LNK ||
+			    sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
+				continue;
+			cpunode_map[cpu] = mem;
+		}
+		closedir(dir2);
+	}
+	closedir(dir1);
+	return 0;
+}
+
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index b123bb9..d6fde2b 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -4,6 +4,9 @@
 #include <stdio.h>
 #include <stdbool.h>
 
+#include "perf.h"
+#include "util/debug.h"
+
 struct cpu_map {
 	int nr;
 	int map[];
@@ -46,4 +49,36 @@ static inline bool cpu_map__empty(const struct cpu_map *map)
 	return map ? map->map[0] == -1 : true;
 }
 
+int max_cpu_num;
+int max_node_num;
+int *cpunode_map;
+
+int cpu_map__setup_cpunode_map(void);
+
+static inline int cpu_map__max_node(void)
+{
+	if (unlikely(!max_node_num))
+		pr_debug("cpu_map not initiailzed\n");
+
+	return max_node_num;
+}
+
+static inline int cpu_map__max_cpu(void)
+{
+	if (unlikely(!max_cpu_num))
+		pr_debug("cpu_map not initiailzed\n");
+
+	return max_cpu_num;
+}
+
+static inline int cpu_map__get_node(int cpu)
+{
+	if (unlikely(cpunode_map == NULL)) {
+		pr_debug("cpu_map not initialized\n");
+		return -1;
+	}
+
+	return cpunode_map[cpu];
+}
+
 #endif /* __PERF_CPUMAP_H */
-- 
1.7.11.7

