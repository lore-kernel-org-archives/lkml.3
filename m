Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753821AbaLAOjf (ORCPT <rfc822;w@1wt.eu>);
	Mon, 1 Dec 2014 09:39:35 -0500
Received: from mx1.redhat.com ([209.132.183.28]:41742 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753548AbaLAOje (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 1 Dec 2014 09:39:34 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Renninger <trenn@suse.de>,
        linux-pm@vger.kernel.org
Subject: [PATCH] tools, cpupower, fix return checks for sysfs_get_idlestate_count()
Date: Mon,  1 Dec 2014 09:39:22 -0500
Message-Id: <1417444762-26450-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Red Hat and Fedora use a bug reporting tool that gathers data about
"broken" systems called sosreport.  Among other things, it includes the
output of 'cpupower idle-info'.  Executing 'cpupower idle-info' on a
system that has cpuidle disabled via 'cpuidle.off=1' results in a 300
second hang in the cpupower application.

ie)
[root@intel-brickland-05]# cpupower idle-info
Could not determine cpuidle driver

Analyzing CPU 0:
Number of idle states: -19
[hang]

The problem is that the cpupower code only checks for a zero return from
sysfs_get_idlestate_count().  The function can return -ENODEV (-19) as
above.  This patch fixes callers to sysfs_get_idlestate_count() to check
the right return values.

Cc: Thomas Renninger <trenn@suse.de>
Cc: linux-pm@vger.kernel.org
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 tools/power/cpupower/utils/cpuidle-info.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/power/cpupower/utils/cpuidle-info.c b/tools/power/cpupower/utils/cpuidle-info.c
index 75e66de..458d69b 100644
--- a/tools/power/cpupower/utils/cpuidle-info.c
+++ b/tools/power/cpupower/utils/cpuidle-info.c
@@ -22,13 +22,13 @@
 
 static void cpuidle_cpu_output(unsigned int cpu, int verbose)
 {
-	unsigned int idlestates, idlestate;
+	int idlestates, idlestate;
 	char *tmp;
 
 	printf(_ ("Analyzing CPU %d:\n"), cpu);
 
 	idlestates = sysfs_get_idlestate_count(cpu);
-	if (idlestates == 0) {
+	if (idlestates < 1) {
 		printf(_("CPU %u: No idle states\n"), cpu);
 		return;
 	}
@@ -100,10 +100,10 @@ static void cpuidle_general_output(void)
 static void proc_cpuidle_cpu_output(unsigned int cpu)
 {
 	long max_allowed_cstate = 2000000000;
-	unsigned int cstate, cstates;
+	int cstate, cstates;
 
 	cstates = sysfs_get_idlestate_count(cpu);
-	if (cstates == 0) {
+	if (cstates < 1) {
 		printf(_("CPU %u: No C-states info\n"), cpu);
 		return;
 	}
-- 
1.7.9.3

