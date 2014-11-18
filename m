Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753686AbaKRHd1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:33:27 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:64303 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753477AbaKRHdF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:33:05 -0500
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Cc: Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH v4/RFC 4/4] QoS: Enable PM QoS requests to apply only on smp_affinity of an IRQ
Date: Tue, 18 Nov 2014 00:31:50 -0700
Message-Id: <1416295910-40433-5-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
References: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QoS requests that need to track an IRQ can be set to apply only on the
cpus to which the IRQ's smp_affinity attribute is set to. The PM QoS
framework will automatically track IRQ migration between the cores. The
QoS is updated to be applied only to the core(s) that the IRQ has been
migrated to.

The userspace sysfs interface does not support IRQ affinity.

Signed-off-by: Lina Iyer <lina.iyer@linaro.org>
Based on work by: Praveen Chidambaram <pchidamb@codeaurora.org>
---
 Documentation/power/pm_qos_interface.txt |  4 +++-
 include/linux/pm_qos.h                   |  3 +++
 kernel/irq/manage.c                      |  3 +++
 kernel/power/qos.c                       | 41 +++++++++++++++++++++++++++++++-
 4 files changed, 49 insertions(+), 2 deletions(-)

diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
index 7f7a774..73bfa16 100644
--- a/Documentation/power/pm_qos_interface.txt
+++ b/Documentation/power/pm_qos_interface.txt
@@ -49,8 +49,10 @@ applies to all cores. However, the driver can also specify a request type to
 be either of
         PM_QOS_REQ_ALL_CORES,
         PM_QOS_REQ_AFFINE_CORES,
+        PM_QOS_REQ_AFFINE_IRQ,
 
-Specify the cpumask when type is set to PM_QOS_REQ_AFFINE_CORES.
+Specify the cpumask when type is set to PM_QOS_REQ_AFFINE_CORES and specify
+the IRQ number with PM_QOS_REQ_AFFINE_IRQ.
 
 void pm_qos_update_request(handle, new_target_value):
 Will update the list element pointed to by the handle with the new target value
diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index de9b04b..e0b80af 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -46,11 +46,13 @@ enum pm_qos_flags_status {
 enum pm_qos_req_type {
 	PM_QOS_REQ_ALL_CORES = 0,
 	PM_QOS_REQ_AFFINE_CORES,
+	PM_QOS_REQ_AFFINE_IRQ,
 };
 
 struct pm_qos_request {
 	enum pm_qos_req_type type;
 	struct cpumask cpus_affine;
+	uint32_t irq;
 	/* Internal structure members */
 	struct plist_node node;
 	int pm_qos_class;
@@ -146,6 +148,7 @@ int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_request_active(struct pm_qos_request *req);
 s32 pm_qos_read_value(struct pm_qos_constraints *c);
+void pm_qos_irq_affinity_change(u32 irq, const struct cpumask *mask);
 
 #ifdef CONFIG_PM
 enum pm_qos_flags_status __dev_pm_qos_flags(struct device *dev, s32 mask);
diff --git a/kernel/irq/manage.c b/kernel/irq/manage.c
index 2d17098..8790f71 100644
--- a/kernel/irq/manage.c
+++ b/kernel/irq/manage.c
@@ -18,6 +18,7 @@
 #include <linux/sched.h>
 #include <linux/sched/rt.h>
 #include <linux/task_work.h>
+#include <linux/pm_qos.h>
 
 #include "internals.h"
 
@@ -209,6 +210,8 @@ int irq_set_affinity_locked(struct irq_data *data, const struct cpumask *mask,
 		irq_copy_pending(desc, mask);
 	}
 
+	pm_qos_irq_affinity_change(data->irq, mask);
+
 	if (desc->affinity_notify) {
 		kref_get(&desc->affinity_notify->kref);
 		schedule_work(&desc->affinity_notify->work);
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 36b4414..43de784 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -42,6 +42,7 @@
 #include <linux/init.h>
 #include <linux/kernel.h>
 #include <linux/cpumask.h>
+#include <linux/interrupt.h>
 
 #include <linux/uaccess.h>
 #include <linux/export.h>
@@ -460,6 +461,39 @@ static void pm_qos_work_fn(struct work_struct *work)
 	__pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
 }
 
+void pm_qos_irq_affinity_change(u32 irq, const struct cpumask *mask)
+{
+	struct pm_qos_constraints *c;
+	unsigned long flags;
+	struct pm_qos_request *req;
+	s32 curr_value;
+	int i;
+	bool needs_update;
+
+	for (i = PM_QOS_CPU_DMA_LATENCY; i < PM_QOS_NUM_CLASSES; i++) {
+		c = pm_qos_array[i]->constraints;
+		if (plist_head_empty(&c->list))
+			continue;
+		needs_update = false;
+		spin_lock_irqsave(&pm_qos_lock, flags);
+		plist_for_each_entry(req, &c->list, node) {
+			if (req->irq == irq) {
+				cpumask_copy(&req->cpus_affine, mask);
+				needs_update = true;
+			}
+		}
+		if (needs_update) {
+			pm_qos_set_value_for_cpus(c);
+			curr_value = pm_qos_get_value(c);
+		}
+		spin_unlock_irqrestore(&pm_qos_lock, flags);
+		if (needs_update && c->notifiers)
+			blocking_notifier_call_chain(c->notifiers,
+						(unsigned long)curr_value,
+						NULL);
+	}
+}
+
 /**
  * pm_qos_add_request - inserts new qos request into the list
  * @req: pointer to a preallocated handle
@@ -493,6 +527,12 @@ void pm_qos_add_request(struct pm_qos_request *req,
 							cpu_possible_mask);
 		break;
 
+	case PM_QOS_REQ_AFFINE_IRQ:
+		if (irq_can_set_affinity(req->irq) &&
+			!irq_get_affinity(req->irq, &req->cpus_affine))
+			req->type = PM_QOS_REQ_ALL_CORES;
+		break;
+
 	default:
 		req->type = PM_QOS_REQ_ALL_CORES;
 		break;
@@ -577,7 +617,6 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
  */
 void pm_qos_remove_request(struct pm_qos_request *req)
 {
-
 	if (!req) /*guard against callers passing in null */
 		return;
 		/* silent return to keep pcm code cleaner */
-- 
2.1.0

