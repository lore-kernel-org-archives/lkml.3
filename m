Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751372Ab3HKAht (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 Aug 2013 20:37:49 -0400
Received: from relay4-d.mail.gandi.net ([217.70.183.196]:46382 "EHLO
	relay4-d.mail.gandi.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751117Ab3HKAhs (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 Aug 2013 20:37:48 -0400
X-Originating-IP: 50.43.39.152
Date: Sat, 10 Aug 2013 17:37:39 -0700
From: Josh Triplett <josh@joshtriplett.org>
To: linux-kernel@vger.kernel.org
Cc: Len Brown <len.brown@intel.com>, akpm@linux-foundation.org,
        torvalds@linux-foundation.org
Subject: [PATCH] turbostat: Check return value of fscanf
Message-ID: <20130811003737.GA13053@jtriplet-mobl1>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
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
1.8.4.rc1

