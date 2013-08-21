Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752072Ab3HUAUp (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:20:45 -0400
Received: from mga02.intel.com ([134.134.136.20]:41929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752041Ab3HUAUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573816"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 5/8] turbostat: Add a helper to parse a single int out of a file
Date: Tue, 20 Aug 2013 17:20:16 -0700
Message-Id: <1377044419-15045-6-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Many different chunks of code in turbostat open a file, parse a single
int out of it, and close it.  Factor that out into a common function.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 tools/power/x86/turbostat/turbostat.c | 81 +++++++++++------------------------
 1 file changed, 24 insertions(+), 57 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index 514adba..e0dbada 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -21,6 +21,7 @@
 
 #define _GNU_SOURCE
 #include MSRHEADER
+#include <stdarg.h>
 #include <stdio.h>
 #include <unistd.h>
 #include <sys/types.h>
@@ -1152,27 +1153,38 @@ void free_all_buffers(void)
 }
 
 /*
- * cpu_is_first_sibling_in_core(cpu)
- * return 1 if given CPU is 1st HT sibling in the core
+ * Parse a file containing a single int.
  */
-int cpu_is_first_sibling_in_core(int cpu)
+int parse_int_file(const char *fmt, ...)
 {
-	char path[64];
+	va_list args;
+	char path[PATH_MAX];
 	FILE *filep;
-	int first_cpu;
+	int value;
 
-	sprintf(path, "/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list", cpu);
+	va_start(args, fmt);
+	vsnprintf(path, sizeof(path), fmt, args);
+	va_end(args);
 	filep = fopen(path, "r");
-	if (filep == NULL) {
+	if (!filep) {
 		perror(path);
 		exit(1);
 	}
-	if (fscanf(filep, "%d", &first_cpu) != 1) {
+	if (fscanf(filep, "%d", &value) != 1) {
 		perror(path);
 		exit(1);
 	}
 	fclose(filep);
-	return (cpu == first_cpu);
+	return value;
+}
+
+/*
+ * cpu_is_first_sibling_in_core(cpu)
+ * return 1 if given CPU is 1st HT sibling in the core
+ */
+int cpu_is_first_sibling_in_core(int cpu)
+{
+	return cpu == parse_int_file("/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list", cpu);
 }
 
 /*
@@ -1181,62 +1193,17 @@ int cpu_is_first_sibling_in_core(int cpu)
  */
 int cpu_is_first_core_in_package(int cpu)
 {
-	char path[64];
-	FILE *filep;
-	int first_cpu;
-
-	sprintf(path, "/sys/devices/system/cpu/cpu%d/topology/core_siblings_list", cpu);
-	filep = fopen(path, "r");
-	if (filep == NULL) {
-		perror(path);
-		exit(1);
-	}
-	if (fscanf(filep, "%d", &first_cpu) != 1) {
-		perror(path);
-		exit(1);
-	}
-	fclose(filep);
-	return (cpu == first_cpu);
+	return cpu == parse_int_file("/sys/devices/system/cpu/cpu%d/topology/core_siblings_list", cpu);
 }
 
 int get_physical_package_id(int cpu)
 {
-	char path[80];
-	FILE *filep;
-	int pkg;
-
-	sprintf(path, "/sys/devices/system/cpu/cpu%d/topology/physical_package_id", cpu);
-	filep = fopen(path, "r");
-	if (filep == NULL) {
-		perror(path);
-		exit(1);
-	}
-	if (fscanf(filep, "%d", &pkg) != 1) {
-		perror(path);
-		exit(1);
-	}
-	fclose(filep);
-	return pkg;
+	return parse_int_file("/sys/devices/system/cpu/cpu%d/topology/physical_package_id", cpu);
 }
 
 int get_core_id(int cpu)
 {
-	char path[80];
-	FILE *filep;
-	int core;
-
-	sprintf(path, "/sys/devices/system/cpu/cpu%d/topology/core_id", cpu);
-	filep = fopen(path, "r");
-	if (filep == NULL) {
-		perror(path);
-		exit(1);
-	}
-	if (fscanf(filep, "%d", &core) != 1) {
-		perror(path);
-		exit(1);
-	}
-	fclose(filep);
-	return core;
+	return parse_int_file("/sys/devices/system/cpu/cpu%d/topology/core_id", cpu);
 }
 
 int get_num_ht_siblings(int cpu)
-- 
1.8.4.rc3

