Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932557AbaKLB23 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:28:29 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:59072 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932540AbaKLB21 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:28:27 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Dirk Brandewie <dirk.j.brandewie@intel.com>,
        "Rafael J. Wysocki" <rafael.j.wysocki@intel.com>
Subject: [PATCH 3.17 172/319] cpufreq: expose scaling_cur_freq sysfs file for set_policy() drivers
Date: Wed, 12 Nov 2014 10:15:10 +0900
Message-Id: <20141112011021.164091156@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112010952.553519040@linuxfoundation.org>
References: <20141112010952.553519040@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/cpufreq/cpufreq.c |   23 +++++++++++++++++------
 1 file changed, 17 insertions(+), 6 deletions(-)

--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -512,7 +512,18 @@ show_one(cpuinfo_max_freq, cpuinfo.max_f
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
@@ -906,11 +917,11 @@ static int cpufreq_add_dev_interface(str
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


