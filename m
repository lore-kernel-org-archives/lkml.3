Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757456Ab3BRFK4 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Feb 2013 00:10:56 -0500
Received: from mga03.intel.com ([143.182.124.21]:12556 "EHLO mga03.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751888Ab3BRFHx (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Feb 2013 00:07:53 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.84,684,1355126400"; 
   d="scan'208";a="258209964"
From: Alex Shi <alex.shi@intel.com>
To: torvalds@linux-foundation.org, mingo@redhat.com, peterz@infradead.org,
        tglx@linutronix.de, akpm@linux-foundation.org, arjan@linux.intel.com,
        bp@alien8.de, pjt@google.com, namhyung@kernel.org, efault@gmx.de
Cc: vincent.guittot@linaro.org, gregkh@linuxfoundation.org,
        preeti@linux.vnet.ibm.com, viresh.kumar@linaro.org,
        linux-kernel@vger.kernel.org, alex.shi@intel.com,
        morten.rasmussen@arm.com
Subject: [patch v5 05/15] sched: add sysfs interface for sched_balance_policy selection
Date: Mon, 18 Feb 2013 13:07:32 +0800
Message-Id: <1361164062-20111-6-git-send-email-alex.shi@intel.com>
X-Mailer: git-send-email 1.7.12
In-Reply-To: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
References: <1361164062-20111-1-git-send-email-alex.shi@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch add the power aware scheduler knob into sysfs:

$cat /sys/devices/system/cpu/sched_balance_policy/available_sched_balance_policy
performance powersaving balance
$cat /sys/devices/system/cpu/sched_balance_policy/current_sched_balance_policy
powersaving

This means the using sched balance policy is 'powersaving'.

User can change the policy by commend 'echo':
 echo performance > /sys/devices/system/cpu/sched_balance_policy/current_sched_balance_policy

Signed-off-by: Alex Shi <alex.shi@intel.com>
---
 Documentation/ABI/testing/sysfs-devices-system-cpu | 26 ++++++++
 kernel/sched/fair.c                                | 73 ++++++++++++++++++++++
 2 files changed, 99 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index 6943133..3283a86 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -53,6 +53,32 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
 		the system.  Information writtento the file to remove CPU's
 		is architecture specific.
 
+What:		/sys/devices/system/cpu/sched_balance_policy/current_sched_balance_policy
+		/sys/devices/system/cpu/sched_balance_policy/available_sched_balance_policy
+Date:		Oct 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	CFS scheduler policy showing and setting interface.
+
+		available_sched_balance_policy shows there are 3 kinds of
+		policies:
+			performance, balance and powersaving.
+		current_sched_balance_policy shows current scheduler policy.
+		User can change the policy by writing it.
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
index 2f98ffb..fcdb21f 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -6108,6 +6108,79 @@ static unsigned int get_rr_interval_fair(struct rq *rq, struct task_struct *task
 /* The default scheduler policy is 'performance'. */
 int __read_mostly sched_balance_policy = SCHED_POLICY_PERFORMANCE;
 
+#ifdef CONFIG_SYSFS
+static ssize_t show_available_sched_balance_policy(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "performance balance powersaving\n");
+}
+
+static ssize_t show_current_sched_balance_policy(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE)
+		return sprintf(buf, "performance\n");
+	else if (sched_balance_policy == SCHED_POLICY_POWERSAVING)
+		return sprintf(buf, "powersaving\n");
+	else if (sched_balance_policy == SCHED_POLICY_BALANCE)
+		return sprintf(buf, "balance\n");
+	return 0;
+}
+
+static ssize_t set_sched_balance_policy(struct device *dev,
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
+		sched_balance_policy = SCHED_POLICY_PERFORMANCE;
+	else if (!strcmp(str_policy, "powersaving"))
+		sched_balance_policy = SCHED_POLICY_POWERSAVING;
+	else if (!strcmp(str_policy, "balance"))
+		sched_balance_policy = SCHED_POLICY_BALANCE;
+	else
+		return -EINVAL;
+
+	return count;
+}
+
+/*
+ *  * Sysfs setup bits:
+ *   */
+static DEVICE_ATTR(current_sched_balance_policy, 0644,
+		show_current_sched_balance_policy, set_sched_balance_policy);
+
+static DEVICE_ATTR(available_sched_balance_policy, 0444,
+		show_available_sched_balance_policy, NULL);
+
+static struct attribute *sched_balance_policy_default_attrs[] = {
+	&dev_attr_current_sched_balance_policy.attr,
+	&dev_attr_available_sched_balance_policy.attr,
+	NULL
+};
+static struct attribute_group sched_balance_policy_attr_group = {
+	.attrs = sched_balance_policy_default_attrs,
+	.name = "sched_balance_policy",
+};
+
+int __init create_sysfs_sched_balance_policy_group(struct device *dev)
+{
+	return sysfs_create_group(&dev->kobj, &sched_balance_policy_attr_group);
+}
+
+static int __init sched_balance_policy_sysfs_init(void)
+{
+	return create_sysfs_sched_balance_policy_group(cpu_subsys.dev_root);
+}
+
+core_initcall(sched_balance_policy_sysfs_init);
+#endif /* CONFIG_SYSFS */
+
 /*
  * All the scheduling class methods:
  */
-- 
1.7.12

