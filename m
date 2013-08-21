Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752114Ab3HUAVc (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:21:32 -0400
Received: from mga02.intel.com ([134.134.136.20]:41929 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752048Ab3HUAUn (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:43 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573819"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 6/8] turbostat: Factor out common function to open file and exit on failure
Date: Tue, 20 Aug 2013 17:20:17 -0700
Message-Id: <1377044419-15045-7-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Several different functions in turbostat contain the same pattern of
opening a file and exiting on failure.  Factor out a common fopen_or_die
function for that.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 tools/power/x86/turbostat/turbostat.c | 31 ++++++++++++++++---------------
 1 file changed, 16 insertions(+), 15 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index e0dbada..aa80db9 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1153,6 +1153,19 @@ void free_all_buffers(void)
 }
 
 /*
+ * Open a file, and exit on failure
+ */
+FILE *fopen_or_die(const char *path, const char *mode)
+{
+	FILE *filep = fopen(path, "r");
+	if (!filep) {
+		perror(path);
+		exit(1);
+	}
+	return filep;
+}
+
+/*
  * Parse a file containing a single int.
  */
 int parse_int_file(const char *fmt, ...)
@@ -1165,11 +1178,7 @@ int parse_int_file(const char *fmt, ...)
 	va_start(args, fmt);
 	vsnprintf(path, sizeof(path), fmt, args);
 	va_end(args);
-	filep = fopen(path, "r");
-	if (!filep) {
-		perror(path);
-		exit(1);
-	}
+	filep = fopen_or_die(path, "r");
 	if (fscanf(filep, "%d", &value) != 1) {
 		perror(path);
 		exit(1);
@@ -1215,11 +1224,7 @@ int get_num_ht_siblings(int cpu)
 	char character;
 
 	sprintf(path, "/sys/devices/system/cpu/cpu%d/topology/thread_siblings_list", cpu);
-	filep = fopen(path, "r");
-	if (filep == NULL) {
-		perror(path);
-		exit(1);
-	}
+	filep = fopen_or_die(path, "r");
 	/*
 	 * file format:
 	 * if a pair of number with a character between: 2 siblings (eg. 1-2, or 1,4)
@@ -1289,11 +1294,7 @@ int for_all_proc_cpus(int (func)(int))
 	int cpu_num;
 	int retval;
 
-	fp = fopen(proc_stat, "r");
-	if (fp == NULL) {
-		perror(proc_stat);
-		exit(1);
-	}
+	fp = fopen_or_die(proc_stat, "r");
 
 	retval = fscanf(fp, "cpu %*d %*d %*d %*d %*d %*d %*d %*d %*d %*d\n");
 	if (retval != 0) {
-- 
1.8.4.rc3

