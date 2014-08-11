Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753011AbaHKLfR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 11 Aug 2014 07:35:17 -0400
Received: from e35.co.us.ibm.com ([32.97.110.153]:45351 "EHLO
	e35.co.us.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751992AbaHKLfP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 11 Aug 2014 07:35:15 -0400
Subject: [RFC PATCH V2 05/19] sched: add sysfs interface for
 sched_balance_policy selection
From: Preeti U Murthy <preeti@linux.vnet.ibm.com>
To: alex.shi@intel.com, vincent.guittot@linaro.org, peterz@infradead.org,
        pjt@google.com, efault@gmx.de, rjw@rjwysocki.net,
        morten.rasmussen@arm.com, svaidy@linux.vnet.ibm.com,
        arjan@linux.intel.com, mingo@kernel.org
Cc: nicolas.pitre@linaro.org, len.brown@intel.com, yuyang.du@intel.com,
        linaro-kernel@lists.linaro.org, daniel.lezcano@linaro.org,
        corbet@lwn.net, catalin.marinas@arm.com, markgross@thegnar.org,
        sundar.iyer@intel.com, linux-kernel@vger.kernel.org,
        dietmar.eggemann@arm.com, Lorenzo.Pieralisi@arm.com,
        mike.turquette@linaro.org, akpm@linux-foundation.org,
        paulmck@linux.vnet.ibm.com, tglx@linutronix.de
Date: Mon, 11 Aug 2014 17:04:49 +0530
Message-ID: <20140811113427.31956.40252.stgit@preeti.in.ibm.com>
In-Reply-To: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
References: <20140811113000.31956.52857.stgit@preeti.in.ibm.com>
User-Agent: StGit/0.17-dirty
MIME-Version: 1.0
Content-Type: text/plain; charset="utf-8"
Content-Transfer-Encoding: 7bit
X-TM-AS-MML: disable
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 14081111-6688-0000-0000-000003EAB029
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alex Shi <alex.shi@intel.com>

This patch add the power aware scheduler knob into sysfs:

$cat /sys/devices/system/cpu/sched_balance_policy/available_sched_balance_policy
performance powersaving
$cat /sys/devices/system/cpu/sched_balance_policy/current_sched_balance_policy
powersaving

This means the using sched balance policy is 'powersaving'.

User can change the policy by commend 'echo':
 echo performance > /sys/devices/system/cpu/sched_balance_policy/current_sched_balance_policy

Signed-off-by: Alex Shi <alex.shi@intel.com>
[Added CONFIG_SCHED_POWER switch to enable this patch]
Signed-off-by: Preeti U Murthy <preeti@linux.vnet.ibm.com>
---

 Documentation/ABI/testing/sysfs-devices-system-cpu |   23 +++++++
 kernel/sched/fair.c                                |   69 ++++++++++++++++++++
 2 files changed, 92 insertions(+)

diff --git a/Documentation/ABI/testing/sysfs-devices-system-cpu b/Documentation/ABI/testing/sysfs-devices-system-cpu
index acb9bfc..c7ed5c1 100644
--- a/Documentation/ABI/testing/sysfs-devices-system-cpu
+++ b/Documentation/ABI/testing/sysfs-devices-system-cpu
@@ -53,6 +53,29 @@ Description:	Dynamic addition and removal of CPU's.  This is not hotplug
 		the system.  Information writtento the file to remove CPU's
 		is architecture specific.
 
+What:		/sys/devices/system/cpu/sched_balance_policy/current_sched_balance_policy
+		/sys/devices/system/cpu/sched_balance_policy/available_sched_balance_policy
+Date:		Oct 2012
+Contact:	Linux kernel mailing list <linux-kernel@vger.kernel.org>
+Description:	CFS balance policy show and set interface.
+		This will get activated only when CONFIG_SCHED_POWER is set.
+
+		available_sched_balance_policy: shows there are 2 kinds of
+		policies:
+			performance powersaving.
+		current_sched_balance_policy: shows current scheduler policy.
+		User can change the policy by writing it.
+
+		Policy decides the CFS scheduler how to balance tasks onto
+		different CPU unit.
+
+		performance: try to spread tasks onto more CPU sockets,
+		more CPU cores. performance oriented.
+
+		powersaving: try to pack tasks onto same core or same CPU
+		until every LCPUs are busy in the core or CPU socket.
+		powersaving oriented.
+
 What:		/sys/devices/system/cpu/cpu#/node
 Date:		October 2009
 Contact:	Linux memory management mailing list <linux-mm@kvack.org>
diff --git a/kernel/sched/fair.c b/kernel/sched/fair.c
index 77da534..f1b0a33 100644
--- a/kernel/sched/fair.c
+++ b/kernel/sched/fair.c
@@ -5863,6 +5863,75 @@ static inline int sg_imbalanced(struct sched_group *group)
 	return group->sgc->imbalance;
 }
 
+#if defined(CONFIG_SYSFS) && defined(CONFIG_SCHED_POWER)
+static ssize_t show_available_sched_balance_policy(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	return sprintf(buf, "performance powersaving\n");
+}
+
+static ssize_t show_current_sched_balance_policy(struct device *dev,
+		struct device_attribute *attr, char *buf)
+{
+	if (sched_balance_policy == SCHED_POLICY_PERFORMANCE)
+		return sprintf(buf, "performance\n");
+	else if (sched_balance_policy == SCHED_POLICY_POWERSAVING)
+		return sprintf(buf, "powersaving\n");
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
+#endif /* CONFIG_SYSFS && CONFIG_SCHED_POWER*/
+
 /*
  * Compute the group capacity factor.
  *

