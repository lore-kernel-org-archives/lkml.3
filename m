Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755234AbaDVSe1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Apr 2014 14:34:27 -0400
Received: from terminus.zytor.com ([198.137.202.10]:52889 "EHLO
	terminus.zytor.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752957AbaDVSeU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Apr 2014 14:34:20 -0400
Date: Tue, 22 Apr 2014 11:34:06 -0700
From: tip-bot for Don Zickus <tipbot@zytor.com>
Message-ID: <tip-7780c25bae59fd042281710f5e1243268e2c18dc@git.kernel.org>
Cc: linux-kernel@vger.kernel.org, hpa@zytor.com, mingo@kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, jolsa@redhat.com,
        dzickus@redhat.com
Reply-To: mingo@kernel.org, hpa@zytor.com, linux-kernel@vger.kernel.org,
        tglx@linutronix.de, namhyung@kernel.org, dzickus@redhat.com,
        jolsa@redhat.com
In-Reply-To: <1396896924-129847-2-git-send-email-dzickus@redhat.com>
References: <1396896924-129847-2-git-send-email-dzickus@redhat.com>
To: linux-tip-commits@vger.kernel.org
Subject: [tip:perf/core] perf tools:
  Allow ability to map cpus to nodes easily
Git-Commit-ID: 7780c25bae59fd042281710f5e1243268e2c18dc
X-Mailer: tip-git-log-daemon
Robot-ID: <tip-bot.git.kernel.org>
Robot-Unsubscribe: Contact <mailto:hpa@kernel.org>
  to get blacklisted from these emails
MIME-Version: 1.0
Content-Transfer-Encoding: 8bit
Content-Type: text/plain; charset=UTF-8
Content-Disposition: inline
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Commit-ID:  7780c25bae59fd042281710f5e1243268e2c18dc
Gitweb:     http://git.kernel.org/tip/7780c25bae59fd042281710f5e1243268e2c18dc
Author:     Don Zickus <dzickus@redhat.com>
AuthorDate: Mon, 7 Apr 2014 14:55:21 -0400
Committer:  Jiri Olsa <jolsa@redhat.com>
CommitDate: Tue, 22 Apr 2014 17:39:12 +0200

perf tools: Allow ability to map cpus to nodes easily

This patch figures out the max number of cpus and nodes that are on the
system and creates a map of cpu to node.  This allows us to provide a cpu
and quickly get the node associated with it.

It was mostly copied from builtin-kmem.c and tweaked slightly to use less memory
(use possible cpus instead of max).  It also calculates the max number of nodes.

Signed-off-by: Don Zickus <dzickus@redhat.com>
Reviewed-by: Namhyung Kim <namhyung@kernel.org>
Link: http://lkml.kernel.org/r/1396896924-129847-2-git-send-email-dzickus@redhat.com
[ Removing out label code in init_cpunode_map ]
[ Adding check for snprintf error ]
[ Removing unneeded returns ]
Signed-off-by: Jiri Olsa <jolsa@redhat.com>
---
 tools/perf/util/cpumap.c | 160 +++++++++++++++++++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h |  35 +++++++++++
 2 files changed, 195 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index 7fe4994..526da02 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -317,3 +317,163 @@ int cpu_map__build_core_map(struct cpu_map *cpus, struct cpu_map **corep)
 {
 	return cpu_map__build_map(cpus, corep, cpu_map__get_core);
 }
+
+/* setup simple routines to easily access node numbers given a cpu number */
+static int get_max_num(char *path, int *max)
+{
+	size_t num;
+	char *buf;
+	int err = 0;
+
+	if (filename__read_str(path, &buf, &num))
+		return -1;
+
+	buf[num] = '\0';
+
+	/* start on the right, to find highest node num */
+	while (--num) {
+		if ((buf[num] == ',') || (buf[num] == '-')) {
+			num++;
+			break;
+		}
+	}
+	if (sscanf(&buf[num], "%d", max) < 1) {
+		err = -1;
+		goto out;
+	}
+
+	/* convert from 0-based to 1-based */
+	(*max)++;
+
+out:
+	free(buf);
+	return err;
+}
+
+/* Determine highest possible cpu in the system for sparse allocation */
+static void set_max_cpu_num(void)
+{
+	const char *mnt;
+	char path[PATH_MAX];
+	int ret = -1;
+
+	/* set up default */
+	max_cpu_num = 4096;
+
+	mnt = sysfs__mountpoint();
+	if (!mnt)
+		goto out;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	ret = snprintf(path, PATH_MAX, "%s/devices/system/cpu/kernel_max", mnt);
+	if (ret == PATH_MAX) {
+		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+		goto out;
+	}
+
+	ret = get_max_num(path, &max_cpu_num);
+
+out:
+	if (ret)
+		pr_err("Failed to read max cpus, using default of %d\n", max_cpu_num);
+}
+
+/* Determine highest possible node in the system for sparse allocation */
+static void set_max_node_num(void)
+{
+	const char *mnt;
+	char path[PATH_MAX];
+	int ret = -1;
+
+	/* set up default */
+	max_node_num = 8;
+
+	mnt = sysfs__mountpoint();
+	if (!mnt)
+		goto out;
+
+	/* get the highest possible cpu number for a sparse allocation */
+	ret = snprintf(path, PATH_MAX, "%s/devices/system/node/possible", mnt);
+	if (ret == PATH_MAX) {
+		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+		goto out;
+	}
+
+	ret = get_max_num(path, &max_node_num);
+
+out:
+	if (ret)
+		pr_err("Failed to read max nodes, using default of %d\n", max_node_num);
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
+		return -1;
+	}
+
+	for (i = 0; i < max_cpu_num; i++)
+		cpunode_map[i] = -1;
+
+	return 0;
+}
+
+int cpu__setup_cpunode_map(void)
+{
+	struct dirent *dent1, *dent2;
+	DIR *dir1, *dir2;
+	unsigned int cpu, mem;
+	char buf[PATH_MAX];
+	char path[PATH_MAX];
+	const char *mnt;
+	int n;
+
+	/* initialize globals */
+	if (init_cpunode_map())
+		return -1;
+
+	mnt = sysfs__mountpoint();
+	if (!mnt)
+		return 0;
+
+	n = snprintf(path, PATH_MAX, "%s/devices/system/node", mnt);
+	if (n == PATH_MAX) {
+		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+		return -1;
+	}
+
+	dir1 = opendir(path);
+	if (!dir1)
+		return 0;
+
+	/* walk tree and setup map */
+	while ((dent1 = readdir(dir1)) != NULL) {
+		if (dent1->d_type != DT_DIR || sscanf(dent1->d_name, "node%u", &mem) < 1)
+			continue;
+
+		n = snprintf(buf, PATH_MAX, "%s/%s", path, dent1->d_name);
+		if (n == PATH_MAX) {
+			pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+			continue;
+		}
+
+		dir2 = opendir(buf);
+		if (!dir2)
+			continue;
+		while ((dent2 = readdir(dir2)) != NULL) {
+			if (dent2->d_type != DT_LNK || sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
+				continue;
+			cpunode_map[cpu] = mem;
+		}
+		closedir(dir2);
+	}
+	closedir(dir1);
+	return 0;
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index b123bb9..61a6548 100644
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
+int cpu__setup_cpunode_map(void);
+
+static inline int cpu__max_node(void)
+{
+	if (unlikely(!max_node_num))
+		pr_debug("cpu_map not initialized\n");
+
+	return max_node_num;
+}
+
+static inline int cpu__max_cpu(void)
+{
+	if (unlikely(!max_cpu_num))
+		pr_debug("cpu_map not initialized\n");
+
+	return max_cpu_num;
+}
+
+static inline int cpu__get_node(int cpu)
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
