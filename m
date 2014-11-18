Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753603AbaKRHdH (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:33:07 -0500
Received: from mail-ie0-f180.google.com ([209.85.223.180]:64352 "EHLO
	mail-ie0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753296AbaKRHdD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:33:03 -0500
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Cc: Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH v4/RFC 2/4] QoS: Enhance PM QoS framework to support per-cpu QoS request
Date: Tue, 18 Nov 2014 00:31:48 -0700
Message-Id: <1416295910-40433-3-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
References: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

QoS request can be better optimized if the request can be set only for
the required cpus and not all cpus. This helps save power on other
cores, while still guaranteeing the quality of service on the desired
cores.

Add a new enumeration to specify the PM QoS request type. The enums help
specify what is the intended target cpu of the request.

Enhance the QoS constraints data structures to support target value for
each core. Requests specify if the QoS is applicable to all cores
(default) or to a selective subset of the cores or to a core(s).

Idle and interested drivers can request a PM QoS value for a constraint
across all cpus, or a specific cpu or a set of cpus. Separate APIs have
been added to request for individual cpu or a cpumask.  The default
behaviour of PM QoS is maintained i.e, requests that do not specify a
type of the request will continue to be effected on all cores.

The userspace sysfs interface does not support setting cpumask of a PM
QoS request.

Signed-off-by: Lina Iyer <lina.iyer@linaro.org>
Based on work by: Praveen Chidambaram <pchidamb@codeaurora.org>
https://www.codeaurora.org/cgit/quic/la/kernel/msm-3.10/tree/kernel/power?h=LNX.LA.3.7
---
 Documentation/power/pm_qos_interface.txt |  16 ++++
 include/linux/pm_qos.h                   |  12 +++
 kernel/power/qos.c                       | 130 ++++++++++++++++++++++++++++++-
 3 files changed, 157 insertions(+), 1 deletion(-)

diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
index 129f7c0..7f7a774 100644
--- a/Documentation/power/pm_qos_interface.txt
+++ b/Documentation/power/pm_qos_interface.txt
@@ -43,6 +43,15 @@ registered notifiers are called only if the target value is now different.
 Clients of pm_qos need to save the returned handle for future use in other
 pm_qos API functions.
 
+The handle is a pm_qos_request object. By default the request object sets the
+request type to PM_QOS_REQ_ALL_CORES, in which case, the PM QoS request
+applies to all cores. However, the driver can also specify a request type to
+be either of
+        PM_QOS_REQ_ALL_CORES,
+        PM_QOS_REQ_AFFINE_CORES,
+
+Specify the cpumask when type is set to PM_QOS_REQ_AFFINE_CORES.
+
 void pm_qos_update_request(handle, new_target_value):
 Will update the list element pointed to by the handle with the new target value
 and recompute the new aggregated target, calling the notification tree if the
@@ -56,6 +65,13 @@ the request.
 int pm_qos_request(param_class):
 Returns the aggregated value for a given PM QoS class.
 
+int pm_qos_request_for_cpu(param_class, cpu):
+Returns the aggregated value for a given PM QoS class for the specified cpu.
+
+int pm_qos_request_for_cpumask(param_class, cpumask):
+Returns the aggregated value for a given PM QoS class for the specified
+cpumask.
+
 int pm_qos_request_active(handle):
 Returns if the request is still active, i.e. it has not been removed from a
 PM QoS class constraints list.
diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index c4d859e..de9b04b 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -9,6 +9,7 @@
 #include <linux/miscdevice.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
+#include <linux/cpumask.h>
 
 enum {
 	PM_QOS_RESERVED = 0,
@@ -42,7 +43,15 @@ enum pm_qos_flags_status {
 #define PM_QOS_FLAG_NO_POWER_OFF	(1 << 0)
 #define PM_QOS_FLAG_REMOTE_WAKEUP	(1 << 1)
 
+enum pm_qos_req_type {
+	PM_QOS_REQ_ALL_CORES = 0,
+	PM_QOS_REQ_AFFINE_CORES,
+};
+
 struct pm_qos_request {
+	enum pm_qos_req_type type;
+	struct cpumask cpus_affine;
+	/* Internal structure members */
 	struct plist_node node;
 	int pm_qos_class;
 	struct delayed_work work; /* for pm_qos_update_request_timeout */
@@ -83,6 +92,7 @@ enum pm_qos_type {
 struct pm_qos_constraints {
 	struct plist_head list;
 	s32 target_value;	/* Do not change to 64 bit */
+	s32 __percpu *target_per_cpu;
 	s32 default_value;
 	s32 no_constraint_value;
 	enum pm_qos_type type;
@@ -130,6 +140,8 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req,
 void pm_qos_remove_request(struct pm_qos_request *req);
 
 int pm_qos_request(int pm_qos_class);
+int pm_qos_request_for_cpu(int pm_qos_class, int cpu);
+int pm_qos_request_for_cpumask(int pm_qos_class, struct cpumask *mask);
 int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_request_active(struct pm_qos_request *req);
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 602f5cb..36b4414 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -41,6 +41,7 @@
 #include <linux/platform_device.h>
 #include <linux/init.h>
 #include <linux/kernel.h>
+#include <linux/cpumask.h>
 
 #include <linux/uaccess.h>
 #include <linux/export.h>
@@ -182,6 +183,49 @@ static inline void pm_qos_set_value(struct pm_qos_constraints *c, s32 value)
 	c->target_value = value;
 }
 
+static inline int pm_qos_set_value_for_cpus(struct pm_qos_constraints *c)
+{
+	struct pm_qos_request *req;
+	int cpu;
+	s32 *qos_val;
+
+	if (!c->target_per_cpu) {
+		c->target_per_cpu = alloc_percpu_gfp(s32, GFP_ATOMIC);
+		if (!c->target_per_cpu)
+			return -ENOMEM;
+	}
+
+	for_each_possible_cpu(cpu)
+		*per_cpu_ptr(c->target_per_cpu, cpu) = c->no_constraint_value;
+
+	if (plist_head_empty(&c->list))
+		return 0;
+
+	plist_for_each_entry(req, &c->list, node) {
+		for_each_cpu(cpu, &req->cpus_affine) {
+			qos_val = per_cpu_ptr(c->target_per_cpu, cpu);
+			switch (c->type) {
+			case PM_QOS_MIN:
+				if (*qos_val > req->node.prio)
+					*qos_val = req->node.prio;
+				break;
+			case PM_QOS_MAX:
+				if (req->node.prio > *qos_val)
+					*qos_val = req->node.prio;
+				break;
+			case PM_QOS_SUM:
+				*qos_val += req->node.prio;
+				break;
+			default:
+				BUG();
+				break;
+			}
+		}
+	}
+
+	return 0;
+}
+
 /**
  * pm_qos_update_target - manages the constraints list and calls the notifiers
  *  if needed
@@ -231,9 +275,12 @@ int pm_qos_update_target(struct pm_qos_constraints *c,
 
 	curr_value = pm_qos_get_value(c);
 	pm_qos_set_value(c, curr_value);
-
+	ret = pm_qos_set_value_for_cpus(c);
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
+	if (ret)
+		return ret;
+
 	trace_pm_qos_update_target(action, prev_value, curr_value);
 	if (prev_value != curr_value) {
 		ret = 1;
@@ -323,6 +370,64 @@ int pm_qos_request(int pm_qos_class)
 }
 EXPORT_SYMBOL_GPL(pm_qos_request);
 
+int pm_qos_request_for_cpu(int pm_qos_class, int cpu)
+{
+	s32 qos_val;
+	unsigned long flags;
+	struct pm_qos_constraints *c;
+
+	spin_lock_irqsave(&pm_qos_lock, flags);
+	c = pm_qos_array[pm_qos_class]->constraints;
+	if (c->target_per_cpu)
+		qos_val = per_cpu(*c->target_per_cpu, cpu);
+	else
+		qos_val = c->no_constraint_value;
+	spin_unlock_irqrestore(&pm_qos_lock, flags);
+
+	return qos_val;
+}
+EXPORT_SYMBOL(pm_qos_request_for_cpu);
+
+int pm_qos_request_for_cpumask(int pm_qos_class, struct cpumask *mask)
+{
+	unsigned long irqflags;
+	int cpu;
+	struct pm_qos_constraints *c;
+	s32 val, qos_val;
+
+	spin_lock_irqsave(&pm_qos_lock, irqflags);
+	c = pm_qos_array[pm_qos_class]->constraints;
+	val = c->no_constraint_value;
+	if (!c->target_per_cpu)
+		goto skip_loop;
+
+	for_each_cpu(cpu, mask) {
+		qos_val = *per_cpu_ptr(c->target_per_cpu, cpu);
+		switch (c->type) {
+		case PM_QOS_MIN:
+			if (val < qos_val)
+				val = qos_val;
+			break;
+		case PM_QOS_MAX:
+			if (qos_val > val)
+				val = qos_val;
+			break;
+		case PM_QOS_SUM:
+			val += qos_val;
+			break;
+		default:
+			BUG();
+			break;
+		}
+	}
+
+skip_loop:
+	spin_unlock_irqrestore(&pm_qos_lock, irqflags);
+
+	return val;
+}
+EXPORT_SYMBOL(pm_qos_request_for_cpumask);
+
 int pm_qos_request_active(struct pm_qos_request *req)
 {
 	return req->pm_qos_class != 0;
@@ -378,6 +483,27 @@ void pm_qos_add_request(struct pm_qos_request *req,
 		WARN(1, KERN_ERR "pm_qos_add_request() called for already added request\n");
 		return;
 	}
+
+	switch (req->type) {
+	case PM_QOS_REQ_AFFINE_CORES:
+		if (cpumask_empty(&req->cpus_affine))
+			req->type = PM_QOS_REQ_ALL_CORES;
+		else
+			cpumask_and(&req->cpus_affine, &req->cpus_affine,
+							cpu_possible_mask);
+		break;
+
+	default:
+		req->type = PM_QOS_REQ_ALL_CORES;
+		break;
+
+	case PM_QOS_REQ_ALL_CORES:
+		break;
+	}
+
+	if (req->type == PM_QOS_REQ_ALL_CORES)
+		cpumask_copy(&req->cpus_affine, cpu_possible_mask);
+
 	req->pm_qos_class = pm_qos_class;
 	INIT_DELAYED_WORK(&req->work, pm_qos_work_fn);
 	trace_pm_qos_add_request(pm_qos_class, value);
@@ -451,6 +577,7 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
  */
 void pm_qos_remove_request(struct pm_qos_request *req)
 {
+
 	if (!req) /*guard against callers passing in null */
 		return;
 		/* silent return to keep pcm code cleaner */
@@ -466,6 +593,7 @@ void pm_qos_remove_request(struct pm_qos_request *req)
 	pm_qos_update_target(pm_qos_array[req->pm_qos_class]->constraints,
 			     req, PM_QOS_REMOVE_REQ,
 			     PM_QOS_DEFAULT_VALUE);
+
 	memset(req, 0, sizeof(*req));
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_request);
-- 
2.1.0

