Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752123Ab3HUAVw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 Aug 2013 20:21:52 -0400
Received: from mga02.intel.com ([134.134.136.20]:5762 "EHLO mga02.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752033Ab3HUAUm (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 Aug 2013 20:20:42 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.89,923,1367996400"; 
   d="scan'208";a="390573812"
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>,
        Mark Asselstine <mark.asselstine@windriver.com>,
        Mike Frysinger <vapier@chromium.org>,
        Josh Triplett <josh@joshtriplett.org>
Subject: [PATCH v2 4/8] turbostat: Check return value of fscanf
Date: Tue, 20 Aug 2013 17:20:15 -0700
Message-Id: <1377044419-15045-5-git-send-email-josh@joshtriplett.org>
X-Mailer: git-send-email 1.8.4.rc3
In-Reply-To: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
References: <1377044419-15045-1-git-send-email-josh@joshtriplett.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Some systems declare fscanf with the warn_unused_result attribute.  On
such systems, turbostat generates the following warnings:

turbostat.c: In function 'get_core_id':
turbostat.c:1203:8: warning: ignoring return value of 'fscanf', declared with attribute warn_unused_result [-Wunused-result]
turbostat.c: In function 'get_physical_package_id':
turbostat.c:1186:8: warning: ignoring return value of 'fscanf', declared with attribute warn_unused_result [-Wunused-result]
turbostat.c: In function 'cpu_is_first_core_in_package':
turbostat.c:1169:8: warning: ignoring return value of 'fscanf', declared with attribute warn_unused_result [-Wunused-result]
turbostat.c: In function 'cpu_is_first_sibling_in_core':
turbostat.c:1148:8: warning: ignoring return value of 'fscanf', declared with attribute warn_unused_result [-Wunused-result]

Fix these by checking the return value of those four calls to fscanf.

Signed-off-by: Josh Triplett <josh@joshtriplett.org>
---
 tools/power/x86/turbostat/turbostat.c | 20 ++++++++++++++++----
 1 file changed, 16 insertions(+), 4 deletions(-)

diff --git a/tools/power/x86/turbostat/turbostat.c b/tools/power/x86/turbostat/turbostat.c
index dc30f1b..514adba 100644
--- a/tools/power/x86/turbostat/turbostat.c
+++ b/tools/power/x86/turbostat/turbostat.c
@@ -1167,7 +1167,10 @@ int cpu_is_first_sibling_in_core(int cpu)
 		perror(path);
 		exit(1);
 	}
-	fscanf(filep, "%d", &first_cpu);
+	if (fscanf(filep, "%d", &first_cpu) != 1) {
+		perror(path);
+		exit(1);
+	}
 	fclose(filep);
 	return (cpu == first_cpu);
 }
@@ -1188,7 +1191,10 @@ int cpu_is_first_core_in_package(int cpu)
 		perror(path);
 		exit(1);
 	}
-	fscanf(filep, "%d", &first_cpu);
+	if (fscanf(filep, "%d", &first_cpu) != 1) {
+		perror(path);
+		exit(1);
+	}
 	fclose(filep);
 	return (cpu == first_cpu);
 }
@@ -1205,7 +1211,10 @@ int get_physical_package_id(int cpu)
 		perror(path);
 		exit(1);
 	}
-	fscanf(filep, "%d", &pkg);
+	if (fscanf(filep, "%d", &pkg) != 1) {
+		perror(path);
+		exit(1);
+	}
 	fclose(filep);
 	return pkg;
 }
@@ -1222,7 +1231,10 @@ int get_core_id(int cpu)
 		perror(path);
 		exit(1);
 	}
-	fscanf(filep, "%d", &core);
+	if (fscanf(filep, "%d", &core) != 1) {
+		perror(path);
+		exit(1);
+	}
 	fclose(filep);
 	return core;
 }
-- 
1.8.4.rc3

