Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758335Ab3KZXU0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 18:20:26 -0500
Received: from mga14.intel.com ([143.182.124.37]:19201 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756777Ab3KZXUT (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 18:20:19 -0500
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.93,778,1378882800"; 
   d="scan'208";a="434758874"
From: Jacob Pan <jacob.jun.pan@linux.intel.com>
To: Linux PM <linux-pm@vger.kernel.org>, LKML <linux-kernel@vger.kernel.org>,
        Peter Zijlstra <a.p.zijlstra@chello.nl>,
        Rafael Wysocki <rafael.j.wysocki@intel.com>,
        Len Brown <len.brown@intel.com>,
        Arjan van de Ven <arjan@linux.intel.com>,
        Zhang Rui <rui.zhang@intel.com>
Cc: Jacob Pan <jacob.jun.pan@linux.intel.com>
Subject: [PATCH 1/3] pm/qos: allow state control of qos class
Date: Tue, 26 Nov 2013 15:20:09 -0800
Message-Id: <1385508011-26914-2-git-send-email-jacob.jun.pan@linux.intel.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
References: <1385508011-26914-1-git-send-email-jacob.jun.pan@linux.intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When power capping or thermal control is needed, CPU QOS latency cannot
be satisfied. This patch adds a state variable to indicate whether a QOS
class (including all constraint requests) should be ignored.

Signed-off-by: Jacob Pan <jacob.jun.pan@linux.intel.com>
---
 include/linux/pm_qos.h | 10 +++++++++-
 kernel/power/qos.c     | 24 ++++++++++++++++++++++++
 2 files changed, 33 insertions(+), 1 deletion(-)

diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index 5a95013..648b50b 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -10,7 +10,7 @@
 #include <linux/device.h>
 #include <linux/workqueue.h>
 
-enum {
+enum pm_qos_class {
 	PM_QOS_RESERVED = 0,
 	PM_QOS_CPU_DMA_LATENCY,
 	PM_QOS_NETWORK_LATENCY,
@@ -20,6 +20,11 @@ enum {
 	PM_QOS_NUM_CLASSES,
 };
 
+enum pm_qos_state {
+	PM_QOS_CONSTRAINT_AVAILABLE,
+	PM_QOS_CONSTRAINT_IGNORED,
+};
+
 enum pm_qos_flags_status {
 	PM_QOS_FLAGS_UNDEFINED = -1,
 	PM_QOS_FLAGS_NONE,
@@ -77,6 +82,7 @@ struct pm_qos_constraints {
 	struct plist_head list;
 	s32 target_value;	/* Do not change to 64 bit */
 	s32 default_value;
+	enum pm_qos_state state;
 	enum pm_qos_type type;
 	struct blocking_notifier_head *notifiers;
 };
@@ -123,6 +129,8 @@ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_request_active(struct pm_qos_request *req);
 s32 pm_qos_read_value(struct pm_qos_constraints *c);
+void pm_qos_set_constraint_class_state(enum pm_qos_class class,
+				enum pm_qos_state state);
 
 #ifdef CONFIG_PM
 enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev, s32 mask);
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 8dff9b4..cf475b0 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -146,6 +146,11 @@ static inline int pm_qos_get_value(struct pm_qos_constraints *c)
 
 s32 pm_qos_read_value(struct pm_qos_constraints *c)
 {
+	/* return invalid default value if constraints cannot be met, e.g.
+	 * during idle injection.
+	 */
+	if (c->state == PM_QOS_CONSTRAINT_IGNORED)
+		return PM_QOS_DEFAULT_VALUE;
 	return c->target_value;
 }
 
@@ -353,6 +358,25 @@ void pm_qos_add_request(struct pm_qos_request *req,
 }
 EXPORT_SYMBOL_GPL(pm_qos_add_request);
 
+void pm_qos_set_constraint_class_state(enum pm_qos_class class,
+				enum pm_qos_state state)
+{
+	struct pm_qos_constraints *c = pm_qos_array[class]->constraints;
+	unsigned long curr_value;
+
+	if (c->state == state)
+		return;
+	curr_value = (state == PM_QOS_CONSTRAINT_IGNORED) ?
+		PM_QOS_DEFAULT_VALUE : c->target_value;
+	c->state = state;
+
+	/* notify existing QOS requests change */
+	blocking_notifier_call_chain(c->notifiers,
+				curr_value,
+				NULL);
+}
+EXPORT_SYMBOL_GPL(pm_qos_set_constraint_class_state);
+
 /**
  * pm_qos_update_request - modifies an existing qos request
  * @req : handle to list element holding a pm_qos request to use
-- 
1.8.1.2

