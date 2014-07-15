Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759410AbaGOWsK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 15 Jul 2014 18:48:10 -0400
Received: from smtp.codeaurora.org ([198.145.11.231]:43294 "EHLO
	smtp.codeaurora.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752536AbaGOWsD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 15 Jul 2014 18:48:03 -0400
From: Saravana Kannan <skannan@codeaurora.org>
To: "Rafael J . Wysocki" <rjw@rjwysocki.net>,
        Viresh Kumar <viresh.kumar@linaro.org>,
        Todd Poynor <toddpoynor@google.com>,
        "Srivatsa S . Bhat" <srivatsa@mit.edu>
Cc: linux-pm@vger.kernel.org, linux-kernel@vger.kernel.org,
        linux-arm-msm@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        "Saravana Kannan" <skannan@codeaurora.org>,
        Stephen Boyd <sboyd@codeaurora.org>
Subject: [PATCH v3 2/2] cpufreq: Simplify and fix mutual exclusion with hotplug
Date: Tue, 15 Jul 2014 15:47:53 -0700
Message-Id: <1405464473-3916-3-git-send-email-skannan@codeaurora.org>
X-Mailer: git-send-email 1.8.2.1
In-Reply-To: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
References: <1405464473-3916-1-git-send-email-skannan@codeaurora.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Since we no longer alloc and destroy/freeze policy and sysfs nodes during
hotplug and suspend, we don't need to lock sysfs with hotplug. We can
achieve the same effect by checking if policy->cpus is empty.

Hotplug mutual exclusion was only done for sysfs writes. But reads need the
same protection too.  So, this patch adds that too.

Also, cpufreq driver (un)register can race with hotplug since CPU online
state can change between adding/removing the currently online devices and
registering/unregistering for hotplug notifiers. So, fix that by
registering for hotplug notifiers first before adding devices and
unregistering from hotplug notifiers first before removing devices.

Signed-off-by: Saravana Kannan <skannan@codeaurora.org>
---
 drivers/cpufreq/cpufreq.c | 44 ++++++++++++++++++++------------------------
 1 file changed, 20 insertions(+), 24 deletions(-)

diff --git a/drivers/cpufreq/cpufreq.c b/drivers/cpufreq/cpufreq.c
index a0a2ec2..f72b2b7 100644
--- a/drivers/cpufreq/cpufreq.c
+++ b/drivers/cpufreq/cpufreq.c
@@ -748,17 +748,18 @@ static ssize_t show(struct kobject *kobj, struct attribute *attr, char *buf)
 {
 	struct cpufreq_policy *policy = to_policy(kobj);
 	struct freq_attr *fattr = to_attr(attr);
-	ssize_t ret;
+	ssize_t ret = -EINVAL;
 
 	if (!down_read_trylock(&cpufreq_rwsem))
-		return -EINVAL;
-
+		return ret;
 	down_read(&policy->rwsem);
 
-	if (fattr->show)
-		ret = fattr->show(policy, buf);
-	else
-		ret = -EIO;
+	if (!cpumask_empty(policy->cpus)) {
+		if (fattr->show)
+			ret = fattr->show(policy, buf);
+		else
+			ret = -EIO;
+	}
 
 	up_read(&policy->rwsem);
 	up_read(&cpufreq_rwsem);
@@ -773,26 +774,19 @@ static ssize_t store(struct kobject *kobj, struct attribute *attr,
 	struct freq_attr *fattr = to_attr(attr);
 	ssize_t ret = -EINVAL;
 
-	get_online_cpus();
-
-	if (!cpu_online(policy->cpu))
-		goto unlock;
-
 	if (!down_read_trylock(&cpufreq_rwsem))
-		goto unlock;
-
+		return ret;
 	down_write(&policy->rwsem);
 
-	if (fattr->store)
-		ret = fattr->store(policy, buf, count);
-	else
-		ret = -EIO;
+	if (!cpumask_empty(policy->cpus)) {
+		if (fattr->store)
+			ret = fattr->store(policy, buf, count);
+		else
+			ret = -EIO;
+	}
 
 	up_write(&policy->rwsem);
-
 	up_read(&cpufreq_rwsem);
-unlock:
-	put_online_cpus();
 
 	return ret;
 }
@@ -2270,6 +2264,8 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		}
 	}
 
+	register_hotcpu_notifier(&cpufreq_cpu_notifier);
+
 	ret = subsys_interface_register(&cpufreq_interface);
 	if (ret)
 		goto err_boost_unreg;
@@ -2293,13 +2289,13 @@ int cpufreq_register_driver(struct cpufreq_driver *driver_data)
 		}
 	}
 
-	register_hotcpu_notifier(&cpufreq_cpu_notifier);
 	pr_debug("driver %s up and running\n", driver_data->name);
 
 	return 0;
 err_if_unreg:
 	subsys_interface_unregister(&cpufreq_interface);
 err_boost_unreg:
+	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
 	if (cpufreq_boost_supported())
 		cpufreq_sysfs_remove_file(&boost.attr);
 err_null_driver:
@@ -2327,12 +2323,12 @@ int cpufreq_unregister_driver(struct cpufreq_driver *driver)
 
 	pr_debug("unregistering driver %s\n", driver->name);
 
+	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
+
 	subsys_interface_unregister(&cpufreq_interface);
 	if (cpufreq_boost_supported())
 		cpufreq_sysfs_remove_file(&boost.attr);
 
-	unregister_hotcpu_notifier(&cpufreq_cpu_notifier);
-
 	down_write(&cpufreq_rwsem);
 	write_lock_irqsave(&cpufreq_driver_lock, flags);
 
-- 
1.8.2.1

The Qualcomm Innovation Center, Inc. is a member of the Code Aurora Forum,
hosted by The Linux Foundation
