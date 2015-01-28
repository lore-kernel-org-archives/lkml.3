Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965659AbbA1E6j (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:58:39 -0500
Received: from mail.kernel.org ([198.145.29.136]:39371 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934113AbbA1EUy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:20:54 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 076/177] cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
Date: Wed, 28 Jan 2015 12:08:38 +0800
Message-Id: <1422418236-12852-151-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Dirk Brandewie <dirk.j.brandewie@intel.com>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


commit c034b02e213d271b98c45c4a7b54af8f69aaac1e upstream.

Currently the core does not expose scaling_cur_freq for set_policy()
drivers this breaks some userspace monitoring tools.
Change the core to expose this file for all drivers and if the
set_policy() driver supports the get() callback use it to retrieve the
current frequency.

Link: https://bugzilla.kernel.org/show_bug.cgi?id=73741
Signed-off-by: Dirk Brandewie <dirk.j.brandewie@intel.com>
Signed-off-by: Rafael J. Wysocki <rafael.j.wysocki@intel.com>
[lizf: Backported to 3.4: adjust context]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/cpufreq/cpufreq.c | 23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index 7f2f149..cf864ef 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -371,7 +371,18 @@ show_one(cpuinfo_max_freq, cpuinfo.max_freq);
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
 
 static int __cpufreq_set_policy(struct cpufreq_policy *data,
 				struct cpufreq_policy *policy);
@@ -818,11 +829,11 @@ static int cpufreq_add_dev_interface(unsigned int cpu,
 		if (ret)
 			goto err_out_kobj_put;
 	}
-	if (cpufreq_driver->target) {
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

