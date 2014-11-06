Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753186AbaKFWnv (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 17:43:51 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:59021 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753166AbaKFWnn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:43:43 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 090/162] cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
Date: Thu,  6 Nov 2014 14:35:54 -0800
Message-Id: <1415313426-9622-91-git-send-email-kamal@canonical.com>
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

commit c034b02e213d271b98c45c4a7b54af8f69aaac1e upstream.

Currently the core does not expose scaling_cur_freq for set_policy()
drivers this breaks some userspace monitoring tools.
Change the core to expose this file for all drivers and if the
set_policy() driver supports the get() callback use it to retrieve the
current frequency.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=73741
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/cpufreq/cpufreq.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index c166b4a..a9cd300 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -405,7 +405,18 @@ show_one(cpuinfo_max_freq, cpuinfo.max_freq);
 show_one(cpuinfo_transition_latency, cpuinfo.transition_latency);
 show_one(scaling_min_freq, min);
 show_one(scaling_max_freq, max);
-show_one(scaling_cur_freq, cur);
+
+static ssize_t show_scaling_cur_freq(
+	struct cpufreq_policy *policy, char *buf)
+{
+	ssize_t ret;
+
+	if (cpufreq_driver && cpufreq_driver->setpolicy && cpufreq_driver->get)
+		ret = sprintf(buf, "%u\n", cpufreq_driver->get(policy->cpu));
+	else
+		ret = sprintf(buf, "%u\n", policy->cur);
+	return ret;
+}
 
 static int cpufreq_set_policy(struct cpufreq_policy *policy,
 				struct cpufreq_policy *new_policy);
@@ -799,11 +810,11 @@ static int cpufreq_add_dev_interface(struct cpufreq_policy *policy,
 		if (ret)
 			goto err_out_kobj_put;
 	}
-	if (has_target()) {
-		ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
-		if (ret)
-			goto err_out_kobj_put;
-	}
+
+	ret = sysfs_create_file(&policy->kobj, &scaling_cur_freq.attr);
+	if (ret)
+		goto err_out_kobj_put;
+
 	if (cpufreq_driver->bios_limit) {
 		ret = sysfs_create_file(&policy->kobj, &bios_limit.attr);
 		if (ret)
-- 
1.9.1

