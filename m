Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935811AbaH0UPw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:15:52 -0400
Received: from mail-pa0-f45.google.com ([209.85.220.45]:35220 "EHLO
	mail-pa0-f45.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935760AbaH0UPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:15:50 -0400
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, Lina Iyer <lina.iyer@linaro.org>,
        Praveen Chidambaram <pchidamb@codeaurora.org>
Subject: [PATCH v3 4/4] QoS: Enable PM QoS requests to apply only on smp_affinity of an IRQ
Date: Wed, 27 Aug 2014 14:14:39 -0600
Message-Id: <1409170479-29955-5-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on original work by pchidamb@codeaurora.org.

QoS requests that need to track an IRQ can be set to apply only on the
cpus to which the IRQ's smp_affinity attribute is set to. The PM QoS
framework will automatically track IRQ migration between the cores. The
QoS is updated to be applied only to the core(s) that the IRQ has been
migrated to.

The userspace sysfs interface does not support IRQ affinity.

Signed-off-by: Praveen Chidambaram <pchidamb@codeaurora.org>
Signed-off-by: Lina Iyer <lina.iyer@linaro.org>
[lina.iyer: Split the change from a previous change, add commit text]

diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
index c129517..32b864d 100644
--- a/Documentation/power/pm_qos_interface.txt
+++ b/Documentation/power/pm_qos_interface.txt
@@ -47,8 +47,10 @@ applies to all cores. However, the driver can also specify a request type to
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
index a3aa5b5..68b16b8 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -11,6 +11,7 @@
 #include <linux/workqueue.h>
 #include <linux/cpumask.h>
 #include <linux/interrupt.h>
+#include <linux/completion.h>
 
 enum {
 	PM_QOS_RESERVED = 0,
@@ -45,12 +46,16 @@ enum pm_qos_flags_status {
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
+	struct irq_affinity_notify irq_notify;
+	struct completion irq_released;
 	struct plist_node node;
 	int pm_qos_class;
 	struct delayed_work work; /* for pm_qos_update_request_timeout */
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 27f84a2..c10e8bc 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -41,6 +41,9 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/irq.h>
+#include <linux/irqdesc.h>
+#include <linux/delay.h>
 
 #include <linux/uaccess.h>
 #include <linux/export.h>
@@ -412,6 +415,37 @@ static void pm_qos_work_fn(struct work_struct *work)
 	__pm_qos_update_request(req, PM_QOS_DEFAULT_VALUE);
 }
 
+static void pm_qos_irq_release(struct kref *ref)
+{
+	unsigned long flags;
+	struct irq_affinity_notify *notify = container_of(ref,
+			struct irq_affinity_notify, kref);
+	struct pm_qos_request *req = container_of(notify,
+			struct pm_qos_request, irq_notify);
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	cpumask_clear(&req->cpus_affine);
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	complete(&req->irq_released);
+}
+
+static void pm_qos_irq_notify(struct irq_affinity_notify *notify,
+		const cpumask_t *mask)
+{
+	unsigned long flags;
+	struct pm_qos_request *req = container_of(notify,
+			struct pm_qos_request, irq_notify);
+	struct pm_qos_constraints *c =
+		pm_qos_array[req->pm_qos_class]->constraints;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	cpumask_copy(&req->cpus_affine, mask);
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	pm_qos_update_target(c, req, PM_QOS_UPDATE_REQ, req->node.prio);
+}
+
 /**
  * pm_qos_add_request - inserts new qos request into the list
  * @req: pointer to a preallocated handle
@@ -445,6 +479,34 @@ void pm_qos_add_request(struct pm_qos_request *req,
 		}
 		break;
 
+	case PM_QOS_REQ_AFFINE_IRQ:
+		if (irq_can_set_affinity(req->irq)) {
+			int ret = 0;
+			struct irq_desc *desc = irq_to_desc(req->irq);
+			struct cpumask *mask = desc->irq_data.affinity;
+
+			/* Get the current affinity */
+			cpumask_copy(&req->cpus_affine, mask);
+			req->irq_notify.irq = req->irq;
+			req->irq_notify.notify = pm_qos_irq_notify;
+			req->irq_notify.release = pm_qos_irq_release;
+
+			ret = irq_set_affinity_notifier(req->irq,
+					&req->irq_notify);
+			if (ret) {
+				WARN(1, KERN_ERR "IRQ affinity notify set failed\n");
+				req->type = PM_QOS_REQ_ALL_CORES;
+				cpumask_setall(&req->cpus_affine);
+			}
+		} else {
+			req->type = PM_QOS_REQ_ALL_CORES;
+			cpumask_setall(&req->cpus_affine);
+			WARN(1, KERN_ERR "IRQ-%d not set for request with affinity flag\n",
+					req->irq);
+		}
+		init_completion(&req->irq_released);
+		break;
+
 	default:
 		WARN(1, KERN_ERR "Unknown request type %d\n", req->type);
 		/* fall through */
@@ -526,11 +588,14 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
  */
 void pm_qos_remove_request(struct pm_qos_request *req)
 {
-
 	if (!req) /*guard against callers passing in null */
 		return;
 		/* silent return to keep pcm code cleaner */
 
+	/* Remove ourselves from the irq notification */
+	if (req->type == PM_QOS_REQ_AFFINE_IRQ)
+		irq_release_affinity_notifier(&req->irq_notify);
+
 	if (!pm_qos_request_active(req)) {
 		WARN(1, KERN_ERR "pm_qos_remove_request() called for unknown object\n");
 		return;
@@ -543,6 +608,16 @@ void pm_qos_remove_request(struct pm_qos_request *req)
 			     req, PM_QOS_REMOVE_REQ,
 			     PM_QOS_DEFAULT_VALUE);
 
+	/**
+	 * The 'release' callback of the notifier would not be called unless
+	 * there are no active users of the irq_notify object, i.e, kref count
+	 * is non-zero. This could happen if there is an active 'notify'
+	 * callback happening while the pm_qos_remove request is called. Wait
+	 * until the release callback clears the cpus_affine mask.
+	 */
+	if (req->type == PM_QOS_REQ_AFFINE_IRQ)
+		wait_for_completion(&req->irq_released);
+
 	memset(req, 0, sizeof(*req));
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_request);
-- 
1.9.1

