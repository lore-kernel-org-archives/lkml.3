Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753732AbaB1Rst (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Feb 2014 12:48:49 -0500
Received: from mx1.redhat.com ([209.132.183.28]:26075 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753241AbaB1Rnn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Feb 2014 12:43:43 -0500
From: Don Zickus <dzickus@redhat.com>
To: acme@ghostprotocols.net
Cc: LKML <linux-kernel@vger.kernel.org>, jolsa@redhat.com, jmario@redhat.com,
        fowles@inreach.com, eranian@google.com,
        Don Zickus <dzickus@redhat.com>, Li Zefan <lizf@cn.fujitsu.com>
Subject: [PATCH 05/19] perf, kmem: Utilize the new generic cpunode_map
Date: Fri, 28 Feb 2014 12:42:54 -0500
Message-Id: <1393609388-40489-6-git-send-email-dzickus@redhat.com>
In-Reply-To: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
References: <1393609388-40489-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Use the previous patch implementation of cpunode_map for builtin-kmem.c
Should not be any functional difference.

Cc: Li Zefan <lizf@cn.fujitsu.com>
Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/builtin-kmem.c | 78 ++---------------------------------------------
 1 file changed, 3 insertions(+), 75 deletions(-)

diff --git a/tools/perf/builtin-kmem.c b/tools/perf/builtin-kmem.c
index 929462a..9ff7892 100644
--- a/tools/perf/builtin-kmem.c
+++ b/tools/perf/builtin-kmem.c
@@ -14,6 +14,7 @@
 #include "util/parse-options.h"
 #include "util/trace-event.h"
 #include "util/data.h"
+#include "util/cpumap.h"
 
 #include "util/debug.h"
 
@@ -31,9 +32,6 @@ static int			caller_lines = -1;
 
 static bool			raw_ip;
 
-static int			*cpunode_map;
-static int			max_cpu_num;
-
 struct alloc_stat {
 	u64	call_site;
 	u64	ptr;
@@ -55,76 +53,6 @@ static struct rb_root root_caller_sorted;
 static unsigned long total_requested, total_allocated;
 static unsigned long nr_allocs, nr_cross_allocs;
 
-#define PATH_SYS_NODE	"/sys/devices/system/node"
-
-static int init_cpunode_map(void)
-{
-	FILE *fp;
-	int i, err = -1;
-
-	fp = fopen("/sys/devices/system/cpu/kernel_max", "r");
-	if (!fp) {
-		max_cpu_num = 4096;
-		return 0;
-	}
-
-	if (fscanf(fp, "%d", &max_cpu_num) < 1) {
-		pr_err("Failed to read 'kernel_max' from sysfs");
-		goto out_close;
-	}
-
-	max_cpu_num++;
-
-	cpunode_map = calloc(max_cpu_num, sizeof(int));
-	if (!cpunode_map) {
-		pr_err("%s: calloc failed\n", __func__);
-		goto out_close;
-	}
-
-	for (i = 0; i < max_cpu_num; i++)
-		cpunode_map[i] = -1;
-
-	err = 0;
-out_close:
-	fclose(fp);
-	return err;
-}
-
-static int setup_cpunode_map(void)
-{
-	struct dirent *dent1, *dent2;
-	DIR *dir1, *dir2;
-	unsigned int cpu, mem;
-	char buf[PATH_MAX];
-
-	if (init_cpunode_map())
-		return -1;
-
-	dir1 = opendir(PATH_SYS_NODE);
-	if (!dir1)
-		return 0;
-
-	while ((dent1 = readdir(dir1)) != NULL) {
-		if (dent1->d_type != DT_DIR ||
-		    sscanf(dent1->d_name, "node%u", &mem) < 1)
-			continue;
-
-		snprintf(buf, PATH_MAX, "%s/%s", PATH_SYS_NODE, dent1->d_name);
-		dir2 = opendir(buf);
-		if (!dir2)
-			continue;
-		while ((dent2 = readdir(dir2)) != NULL) {
-			if (dent2->d_type != DT_LNK ||
-			    sscanf(dent2->d_name, "cpu%u", &cpu) < 1)
-				continue;
-			cpunode_map[cpu] = mem;
-		}
-		closedir(dir2);
-	}
-	closedir(dir1);
-	return 0;
-}
-
 static int insert_alloc_stat(unsigned long call_site, unsigned long ptr,
 			     int bytes_req, int bytes_alloc, int cpu)
 {
@@ -235,7 +163,7 @@ static int perf_evsel__process_alloc_node_event(struct perf_evsel *evsel,
 	int ret = perf_evsel__process_alloc_event(evsel, sample);
 
 	if (!ret) {
-		int node1 = cpunode_map[sample->cpu],
+		int node1 = cpu_map__get_node(sample->cpu),
 		    node2 = perf_evsel__intval(evsel, sample, "node");
 
 		if (node1 != node2)
@@ -770,7 +698,7 @@ int cmd_kmem(int argc, const char **argv, const char *prefix __maybe_unused)
 	if (!strncmp(argv[0], "rec", 3)) {
 		return __cmd_record(argc, argv);
 	} else if (!strcmp(argv[0], "stat")) {
-		if (setup_cpunode_map())
+		if (cpu_map__setup_cpunode_map())
 			return -1;
 
 		if (list_empty(&caller_sort))
-- 
1.7.11.7

