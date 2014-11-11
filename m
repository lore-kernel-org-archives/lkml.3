Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754604AbaKKL7i (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 06:59:38 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57307 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752594AbaKKLJl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 06:09:41 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 044/170] intel_pstate: Don't lose sysfs settings during cpu offline
Date: Tue, 11 Nov 2014 11:06:43 +0000
Message-Id: <1415704129-12709-45-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
References: <1415704129-12709-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt1 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit c034871712730a33e0267095f48b62eae958499c upstream.

The user may have custom settings don't destroy them during suspend.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=80651
Reported-by: Tobias Jakobi <liquid.acid@gmx.net>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 41bbeae458a1..7e408bde89be 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -726,7 +726,9 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 {
 	struct cpudata *cpu;
 
-	all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
+	if (!all_cpu_data[cpunum])
+		all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata),
+					       GFP_KERNEL);
 	if (!all_cpu_data[cpunum])
 		return -ENOMEM;
 
@@ -812,8 +814,6 @@ static void intel_pstate_stop_cpu(struct cpufreq_policy *policy)
 
 	del_timer_sync(&all_cpu_data[cpu_num]->timer);
 	intel_pstate_set_pstate(cpu, cpu->pstate.min_pstate);
-	kfree(all_cpu_data[cpu_num]);
-	all_cpu_data[cpu_num] = NULL;
 }
 
 static int intel_pstate_cpu_init(struct cpufreq_policy *policy)
-- 
2.1.0

