Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753933AbaKFW6k (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:58:40 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58973 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753007AbaKFWnQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:16 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 092/162] intel_pstate: Don't lose sysfs settings during cpu offline
Date: Thu,  6 Nov 2014 14:35:56 -0800
Message-Id: <1415313426-9622-93-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

commit c034871712730a33e0267095f48b62eae958499c upstream.

The user may have custom settings don't destroy them during suspend.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=80651
Reported-by: Tobias Jakobi <liquid.acid@gmx.net>
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[ kamal: backport to 3.13-stable: context ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/intel_pstate.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/cpufreq/intel_pstate.c b/drivers/cpufreq/intel_pstate.c
index 7d622cd..4469fed 100644
--- a/drivers/cpufreq/intel_pstate.c
+++ b/drivers/cpufreq/intel_pstate.c
@@ -711,7 +711,9 @@ static int intel_pstate_init_cpu(unsigned int cpunum)
 	if (!id)
 		return -ENODEV;
 
-	all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata), GFP_KERNEL);
+	if (!all_cpu_data[cpunum])
+		all_cpu_data[cpunum] = kzalloc(sizeof(struct cpudata),
+					       GFP_KERNEL);
 	if (!all_cpu_data[cpunum])
 		return -ENOMEM;
 
@@ -799,8 +801,6 @@ static int intel_pstate_cpu_exit(struct cpufreq_policy *policy)
 	int cpu = policy->cpu;
 
 	del_timer(&all_cpu_data[cpu]->timer);
-	kfree(all_cpu_data[cpu]);
-	all_cpu_data[cpu] = NULL;
 	return 0;
 }
 
-- 
1.9.1

