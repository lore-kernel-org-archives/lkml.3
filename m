Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753929Ab3AXDIz (ORCPT <rfc822;w@1wt.eu>);
	Wed, 23 Jan 2013 22:08:55 -0500
Received: from mga01.intel.com ([192.55.52.88]:7626 "EHLO mga01.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753272Ab3AXDHl (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 23 Jan 2013 22:07:41 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,525,1355126400"; 
   d="scan'208";a="277725041"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com
Subject: [patch v4 10/18] sched: add sysfs interface for sched_policy selection
Date: Thu, 24 Jan 2013 11:06:52 +0800
Message-Id: <1358996820-23036-11-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
References: <1358996820-23036-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the power aware scheduler knob into sysfs:

$cat /sys/devices/system/cpu/sched_policy/available_sched_policy
performance powersaving balance
$cat /sys/devices/system/cpu/sched_policy/current_sched_policy
powersaving

This means the using sched policy is 'powersaving'.

User can change the policy by commend 'echo':
 echo performance > /sys/devices/system/cpu/current_sched_policy

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu | 25 +++++++
 kernel/sched/fair.c                                | 76 ++++++++++++++++++++++
 2 files changed, 101 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 6943133..0ca0727 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -53,6 +53,31 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
 		the system.  Information writtento the file to remove CPU's
 		is architecture specific.
 
+What:		/sys/devices/system/cpu/sched_policy/current_sched_policy
+		/sys/devices/system/cpu/sched_policy/available_sched_policy
+Date:		Oct 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	CFS scheduler policy showing and setting interface.
+
+		available_sched_policy shows there are 3 kinds of policy now:
+		performance, balance and powersaving.
+		current_sched_policy shows current scheduler policy. User
+		can change the policy by writing it.
+
+		Policy decides the CFS scheduler how to distribute tasks onto
+		different CPU unit.
+
+		performance: try to spread tasks onto more CPU sockets,
+		more CPU cores. performance oriented.
+
+		powersaving: try to pack tasks onto same core or same CPU
+		until every LCPUs are busy in the core or CPU socket.
+		powersaving oriented.
+
+		balance:     try to pack tasks onto same core or same CPU
+		until full powered CPUs are busy.
+		balance between performance and powersaving.
+
 What:		/sys/devices/system/cpu/cpu#/node
 Date:		October 2009
 Contact:	Linux memory management mailing list <linux-mm@kvack.org>
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 538f469..947542f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6088,6 +6088,82 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 
 /* The default scheduler policy is 'performance'. */
 int __read_mostly sched_policy = SCHED_POLICY_PERFORMANCE;
+
+#ifdef CONFIG_SYSFS
+static ssize_t show_available_sched_policy(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	return sprintf(buf, "performance balance powersaving\n");
+}
+
+static ssize_t show_current_sched_policy(struct device *dev,
+		struct device_attribute *attr,
+		char *buf)
+{
+	if (sched_policy == SCHED_POLICY_PERFORMANCE)
+		return sprintf(buf, "performance\n");
+	else if (sched_policy == SCHED_POLICY_POWERSAVING)
+		return sprintf(buf, "powersaving\n");
+	else if (sched_policy == SCHED_POLICY_BALANCE)
+		return sprintf(buf, "balance\n");
+	return 0;
+}
+
+static ssize_t set_sched_policy(struct device *dev,
+		struct device_attribute *attr, const char *buf, size_t count)
+{
+	unsigned int ret = -EINVAL;
+	char    str_policy[16];
+
+	ret = sscanf(buf, "%15s", str_policy);
+	if (ret != 1)
+		return -EINVAL;
+
+	if (!strcmp(str_policy, "performance"))
+		sched_policy = SCHED_POLICY_PERFORMANCE;
+	else if (!strcmp(str_policy, "powersaving"))
+		sched_policy = SCHED_POLICY_POWERSAVING;
+	else if (!strcmp(str_policy, "balance"))
+		sched_policy = SCHED_POLICY_BALANCE;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+/*
+ *  * Sysfs setup bits:
+ *   */
+static DEVICE_ATTR(current_sched_policy, 0644, show_current_sched_policy,
+						set_sched_policy);
+
+static DEVICE_ATTR(available_sched_policy, 0444,
+		show_available_sched_policy, NULL);
+
+static struct attribute *sched_policy_default_attrs[] = {
+	&dev_attr_current_sched_policy.attr,
+	&dev_attr_available_sched_policy.attr,
+	NULL
+};
+static struct attribute_group sched_policy_attr_group = {
+	.attrs = sched_policy_default_attrs,
+	.name = "sched_policy",
+};
+
+int __init create_sysfs_sched_policy_group(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &sched_policy_attr_group);
+}
+
+static int __init sched_policy_sysfs_init(void)
+{
+	return create_sysfs_sched_policy_group(cpu_subsys.dev_root);
+}
+
+core_initcall(sched_policy_sysfs_init);
+#endif /* CONFIG_SYSFS */
+
 /*
  * All the scheduling class methods:
  */
-- 
1.7.12

