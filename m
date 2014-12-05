Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751733AbaLERTY (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 12:19:24 -0500
Received: from devils.ext.ti.com ([198.47.26.153]:51040 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751468AbaLERTV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 12:19:21 -0500
From: Dave Gerlach <d-gerlach@ti.com>
To: <linux-kernel@vger.kernel.org>, <linux-pm@vger.kernel.org>
CC: "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, Nishanth Menon <nm@ti.com>,
        Dave Gerlach <d-gerlach@ti.com>
Subject: [PATCH] PM QoS: Add debugfs support to view the list of constraints
Date: Fri, 5 Dec 2014 11:19:08 -0600
Message-ID: <1417799948-48440-1-git-send-email-d-gerlach@ti.com>
X-Mailer: git-send-email 2.1.0
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Nishanth Menon <nm@ti.com>

PM QoS requests are notoriously hard to debug and made even
more so due to their highly dynamic nature. Having visibility
into the internal data representation per constraint allows
us to have much better appreciation of potential issues or
bad usage by drivers in the system.

So introduce for all classes of PM QoS, an entry in
/sys/kernel/debug/pm_qos that shall show all the current
requests as well as the snapshot of the value these requests
boil down to. For example:
==> /sys/kernel/debug/pm_qos/cpu_dma_latency <==
1: 4444: Active
2: 2000000000: Default
3: 2000000000: Default
4: 2000000000: Default
Type=Minimum, Value=4444, Requests: active=1 / total=4

==> /sys/kernel/debug/pm_qos/memory_bandwidth <==
Empty!

...

The actual value listed will have their meaning based
on the QoS it is on, the 'Type' indicates what logic
it would use to collate the information - Minimum,
Maximum, or Sum. Value is the collation of all requests.
This interface also compares the values with the defaults
for the QoS class and marks the ones that are
currently active.

Signed-off-by: Nishanth Menon <nm@ti.com>
Signed-off-by: Dave Gerlach <d-gerlach@ti.com>
---
 kernel/power/qos.c | 91 ++++++++++++++++++++++++++++++++++++++++++++++++++++--
 1 file changed, 89 insertions(+), 2 deletions(-)

diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 5f4c006..97b0df7 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -41,6 +41,8 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/debugfs.h>
+#include <linux/seq_file.h>
 
 #include <linux/uaccess.h>
 #include <linux/export.h>
@@ -182,6 +184,81 @@ static inline void pm_qos_set_value(struct pm_qos_constraints *c, s32 value)
 	c->target_value = value;
 }
 
+static inline int pm_qos_get_value(struct pm_qos_constraints *c);
+static int pm_qos_dbg_show_requests(struct seq_file *s, void *unused)
+{
+	struct pm_qos_object *qos = (struct pm_qos_object *)s->private;
+	struct pm_qos_constraints *c;
+	struct pm_qos_request *req;
+	char *type;
+	unsigned long flags;
+	int tot_reqs = 0;
+	int active_reqs = 0;
+
+	if (IS_ERR_OR_NULL(qos)) {
+		pr_err("%s: bad qos param!\n", __func__);
+		return -EINVAL;
+	}
+	c = qos->constraints;
+	if (IS_ERR_OR_NULL(c)) {
+		pr_err("%s: Bad constraints on qos?\n", __func__);
+		return -EINVAL;
+	}
+
+	/* Lock to ensure we have a snapshot */
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	if (plist_head_empty(&c->list)) {
+		seq_puts(s, "Empty!\n");
+		goto out;
+	}
+
+	switch (c->type) {
+	case PM_QOS_MIN:
+		type = "Minimum";
+		break;
+	case PM_QOS_MAX:
+		type = "Maximum";
+		break;
+	case PM_QOS_SUM:
+		type = "Sum";
+		break;
+	default:
+		type = "Unknown";
+	}
+
+	plist_for_each_entry(req, &c->list, node) {
+		char *state = "Default";
+
+		if ((req->node).prio != c->default_value) {
+			active_reqs++;
+			state = "Active";
+		}
+		tot_reqs++;
+		seq_printf(s, "%d: %d: %s\n", tot_reqs,
+			   (req->node).prio, state);
+	}
+
+	seq_printf(s, "Type=%s, Value=%d, Requests: active=%d / total=%d\n",
+		   type, pm_qos_get_value(c), active_reqs, tot_reqs);
+
+out:
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+	return 0;
+}
+
+static int pm_qos_dbg_open(struct inode *inode, struct file *file)
+{
+	return single_open(file, pm_qos_dbg_show_requests,
+			   inode->i_private);
+}
+
+static const struct file_operations pm_qos_debug_fops = {
+	.open           = pm_qos_dbg_open,
+	.read           = seq_read,
+	.llseek         = seq_lseek,
+	.release        = single_release,
+};
+
 /**
  * pm_qos_update_target - manages the constraints list and calls the notifiers
  *  if needed
@@ -509,12 +586,17 @@ int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier)
 EXPORT_SYMBOL_GPL(pm_qos_remove_notifier);
 
 /* User space interface to PM QoS classes via misc devices */
-static int register_pm_qos_misc(struct pm_qos_object *qos)
+static int register_pm_qos_misc(struct pm_qos_object *qos, struct dentry *d)
 {
 	qos->pm_qos_power_miscdev.minor = MISC_DYNAMIC_MINOR;
 	qos->pm_qos_power_miscdev.name = qos->name;
 	qos->pm_qos_power_miscdev.fops = &pm_qos_power_fops;
 
+	if (d) {
+		(void)debugfs_create_file(qos->name, S_IRUGO, d,
+					  (void *)qos, &pm_qos_debug_fops);
+	}
+
 	return misc_register(&qos->pm_qos_power_miscdev);
 }
 
@@ -608,11 +690,16 @@ static int __init pm_qos_power_init(void)
 {
 	int ret = 0;
 	int i;
+	struct dentry *d;
 
 	BUILD_BUG_ON(ARRAY_SIZE(pm_qos_array) != PM_QOS_NUM_CLASSES);
 
+	d = debugfs_create_dir("pm_qos", NULL);
+	if (IS_ERR_OR_NULL(d))
+		d = NULL;
+
 	for (i = PM_QOS_CPU_DMA_LATENCY; i < PM_QOS_NUM_CLASSES; i++) {
-		ret = register_pm_qos_misc(pm_qos_array[i]);
+		ret = register_pm_qos_misc(pm_qos_array[i], d);
 		if (ret < 0) {
 			printk(KERN_ERR "pm_qos_param: %s setup failed\n",
 			       pm_qos_array[i]->name);
-- 
2.1.0

