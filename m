Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753697AbaLNOGy (ORCPT <rfc822;w@1wt.eu>);
	Sun, 14 Dec 2014 09:06:54 -0500
Received: from mx1.redhat.com ([209.132.183.28]:44206 "EHLO mx1.redhat.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753308AbaLNOGs (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Sun, 14 Dec 2014 09:06:48 -0500
From: Prarit Bhargava <prarit@redhat.com>
To: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: Prarit Bhargava <prarit@redhat.com>, Thomas Renninger <trenn@suse.de>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 1/2] Revert "tools: cpupower: fix return checks for sysfs_get_idlestate_count()"
Date: Sun, 14 Dec 2014 09:06:37 -0500
Message-Id: <1418565998-3701-2-git-send-email-prarit@redhat.com>
In-Reply-To: <1418565998-3701-1-git-send-email-prarit@redhat.com>
References: <1418565998-3701-1-git-send-email-prarit@redhat.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This reverts commit 16b7c275c055cc36218404b5d147be7f76575087.

My previous commit 16b7c275c055 ("tools: cpupower: fix return checks for
sysfs_get_idlestate_count()") was not correct.  After looking
at the changelog for cpupower I noticed that Thomas had changed the return of
sysfs_get_idlestate_count() to an unsigned int to simplify the code.  The
problem is really that both he (in his original change) and I (in my new
change) missed the obvious that sysfs_get_idlestate_count()
can't return -ENODEV.  It should just return 0 for "no c-states".

Cc: Thomas Renninger <trenn@suse.de>
Cc: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Prarit Bhargava <prarit@redhat.com>
---
 tools/power/cpupower/utils/cpuidle-info.c |    8 ++++----
 1 file changed, 4 insertions(+), 4 deletions(-)

diff --git a/tools/power/cpupower/utils/cpuidle-info.c b/tools/power/cpupower/utils/cpuidle-info.c
index 458d69b..75e66de 100644
--- a/tools/power/cpupower/utils/cpuidle-info.c
+++ b/tools/power/cpupower/utils/cpuidle-info.c
@@ -22,13 +22,13 @@
 
 static void cpuidle_cpu_output(unsigned int cpu, int verbose)
 {
-	int idlestates, idlestate;
+	unsigned int idlestates, idlestate;
 	char *tmp;
 
 	printf(_ ("Analyzing CPU %d:\n"), cpu);
 
 	idlestates = sysfs_get_idlestate_count(cpu);
-	if (idlestates < 1) {
+	if (idlestates == 0) {
 		printf(_("CPU %u: No idle states\n"), cpu);
 		return;
 	}
@@ -100,10 +100,10 @@ static void cpuidle_general_output(void)
 static void proc_cpuidle_cpu_output(unsigned int cpu)
 {
 	long max_allowed_cstate = 2000000000;
-	int cstate, cstates;
+	unsigned int cstate, cstates;
 
 	cstates = sysfs_get_idlestate_count(cpu);
-	if (cstates < 1) {
+	if (cstates == 0) {
 		printf(_("CPU %u: No C-states info\n"), cpu);
 		return;
 	}
-- 
1.7.9.3

