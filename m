Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964888AbaESTOq (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 15:14:46 -0400
Received: from mx1.redhat.com ([209.132.183.28]:57543 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S932702AbaESTOk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 15:14:40 -0400
From: Don Zickus <dzickus@redhat.com>
To: jolsa@redhat.com
Cc: acme@ghostprotocols.net, peterz@infradead.org,
        LKML <linux-kernel@vger.kernel.org>, namhyung@gmail.com,
        eranian@google.com, Andi Kleen <andi@firstfloor.org>,
        Don Zickus <dzickus@redhat.com>
Subject: [PATCH 6/7] perf: Add support to dynamically get cacheline size
Date: Mon, 19 May 2014 15:13:52 -0400
Message-Id: <1400526833-141779-7-git-send-email-dzickus@redhat.com>
In-Reply-To: <1400526833-141779-1-git-send-email-dzickus@redhat.com>
References: <1400526833-141779-1-git-send-email-dzickus@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Different arches may have different cacheline sizes.  Look it up and set
a global variable for reference.

Signed-off-by: Don Zickus <dzickus@redhat.com>
---
 tools/perf/util/cpumap.c | 31 +++++++++++++++++++++++++++++++
 tools/perf/util/cpumap.h | 12 ++++++++++++
 tools/perf/util/sort.c   |  3 +++
 3 files changed, 46 insertions(+)

diff --git a/tools/perf/util/cpumap.c b/tools/perf/util/cpumap.c
index c4e55b7..d833238 100644
--- a/tools/perf/util/cpumap.c
+++ b/tools/perf/util/cpumap.c
@@ -477,3 +477,34 @@ int cpu__setup_cpunode_map(void)
 	closedir(dir1);
 	return 0;
 }
+
+int cpu__setup_cacheline_size(void)
+{
+	const char *mnt;
+	char path[PATH_MAX];
+	int n, ret, size;
+	FILE *fp;
+	
+
+	mnt = sysfs__mountpoint();
+	if (!mnt)
+		return -1;
+
+	n = snprintf(path, PATH_MAX, "%s/devices/system/cpu/cpu0/cache/index0/coherency_line_size", mnt);
+	if (n == PATH_MAX) {
+		pr_err("sysfs path crossed PATH_MAX(%d) size\n", PATH_MAX);
+		return -1;
+	}
+
+	fp = fopen(path, "r");
+	if (!fp)
+		return -1;
+	ret = fscanf(fp, "%d", &size);
+	fclose(fp);
+	if (ret != 1)
+		return -1;
+
+	cacheline_size = size;
+
+	return 0;
+}
diff --git a/tools/perf/util/cpumap.h b/tools/perf/util/cpumap.h
index 61a6548..b3e7b22 100644
--- a/tools/perf/util/cpumap.h
+++ b/tools/perf/util/cpumap.h
@@ -81,4 +81,16 @@ static inline int cpu__get_node(int cpu)
 	return cpunode_map[cpu];
 }
 
+int cacheline_size;
+
+int cpu__setup_cacheline_size(void);
+
+static inline int cpu__cacheline_size(void)
+{
+	if (unlikely(!cacheline_size))
+		pr_debug("cacheline size not initialized\n");
+
+	return cacheline_size;
+}
+
 #endif /* __PERF_CPUMAP_H */
diff --git a/tools/perf/util/sort.c b/tools/perf/util/sort.c
index 635cd8f..50adbfb 100644
--- a/tools/perf/util/sort.c
+++ b/tools/perf/util/sort.c
@@ -2,6 +2,7 @@
 #include "hist.h"
 #include "comm.h"
 #include "symbol.h"
+#include "cpumap.h"
 
 regex_t		parent_regex;
 const char	default_parent_pattern[] = "^sys_|^do_page_fault";
@@ -1117,6 +1118,8 @@ int setup_sorting(void)
 		return -ENOMEM;
 	}
 
+	cpu__setup_cacheline_size();
+
 	for (tok = strtok_r(str, ", ", &tmp);
 			tok; tok = strtok_r(NULL, ", ", &tmp)) {
 		ret = sort_dimension__add(tok);
-- 
1.7.11.7

