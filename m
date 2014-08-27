Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932146AbaH0UPq (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 16:15:46 -0400
Received: from mail-pa0-f51.google.com ([209.85.220.51]:33337 "EHLO
	mail-pa0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S935760AbaH0UPn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 16:15:43 -0400
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, tglx@linutronix.de, rjw@rjwysocki.net
Cc: daniel.lezcano@linaro.org, Lina Iyer <lina.iyer@linaro.org>,
        Praveen Chidambaram <pchidamb@codeaurora.org>
Subject: [PATCH v3 2/4] QoS: Enhance framework to support per-cpu PM QoS request
Date: Wed, 27 Aug 2014 14:14:37 -0600
Message-Id: <1409170479-29955-3-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
References: <1409170479-29955-1-git-send-email-lina.iyer@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Praveen Chidambaram <pchidamb@codeaurora.org>

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

Signed-off-by: Praveen Chidambaram <pchidamb@codeaurora.org>
Signed-off-by: Lina Iyer <lina.iyer@linaro.org>
[lina.iyer: rework, add commit text, split changes into multiple patches]

diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
index a5da5c7..c129517 100644
--- a/Documentation/power/pm_qos_interface.txt
+++ b/Documentation/power/pm_qos_interface.txt
@@ -41,6 +41,15 @@ registered notifiers are called only if the target value is now different.
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
@@ -54,6 +63,13 @@ the request.
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
index e1b763d..a3aa5b5 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -9,6 +9,8 @@
 #include <linux/miscdevice.h>
 #include <linux/device.h>
 #include <linux/workqueue.h>
+#include <linux/cpumask.h>
+#include <linux/interrupt.h>
 
 enum {
 	PM_QOS_RESERVED = 0,
@@ -40,7 +42,15 @@ enum pm_qos_flags_status {
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
@@ -80,6 +90,7 @@ enum pm_qos_type {
 struct pm_qos_constraints {
 	struct plist_head list;
 	s32 target_value;	/* Do not change to 64 bit */
+	s32 target_per_cpu[NR_CPUS];
 	s32 default_value;
 	s32 no_constraint_value;
 	enum pm_qos_type type;
@@ -127,6 +138,8 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req,
 void pm_qos_remove_request(struct pm_qos_request *req);
 
 int pm_qos_request(int pm_qos_class);
+int pm_qos_request_for_cpu(int pm_qos_class, int cpu);
+int pm_qos_request_for_cpumask(int pm_qos_class, struct cpumask *mask);
 int pm_qos_add_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_remove_notifier(int pm_qos_class, struct notifier_block *notifier);
 int pm_qos_request_active(struct pm_qos_request *req);
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index d0b9c0f..27f84a2 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -65,6 +65,8 @@ static BLOCKING_NOTIFIER_HEAD(cpu_dma_lat_notifier);
 static struct pm_qos_constraints cpu_dma_constraints = {
 	.list = PLIST_HEAD_INIT(cpu_dma_constraints.list),
 	.target_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
+	.target_per_cpu = { [0 ... (NR_CPUS - 1)] =
+				PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE },
 	.default_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
 	.no_constraint_value = PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE,
 	.type = PM_QOS_MIN,
@@ -79,6 +81,8 @@ static BLOCKING_NOTIFIER_HEAD(network_lat_notifier);
 static struct pm_qos_constraints network_lat_constraints = {
 	.list = PLIST_HEAD_INIT(network_lat_constraints.list),
 	.target_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
+	.target_per_cpu = { [0 ... (NR_CPUS - 1)] =
+				PM_QOS_NETWORK_LAT_DEFAULT_VALUE },
 	.default_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
 	.no_constraint_value = PM_QOS_NETWORK_LAT_DEFAULT_VALUE,
 	.type = PM_QOS_MIN,
@@ -94,6 +98,8 @@ static BLOCKING_NOTIFIER_HEAD(network_throughput_notifier);
 static struct pm_qos_constraints network_tput_constraints = {
 	.list = PLIST_HEAD_INIT(network_tput_constraints.list),
 	.target_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
+	.target_per_cpu = { [0 ... (NR_CPUS - 1)] =
+				PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE },
 	.default_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
 	.no_constraint_value = PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE,
 	.type = PM_QOS_MAX,
@@ -157,6 +163,43 @@ static inline void pm_qos_set_value(struct pm_qos_constraints *c, s32 value)
 	c->target_value = value;
 }
 
+static inline void pm_qos_set_value_for_cpus(struct pm_qos_constraints *c)
+{
+	struct pm_qos_request *req = NULL;
+	int cpu;
+	s32 *qos_val;
+
+	qos_val = kcalloc(NR_CPUS, sizeof(*qos_val), GFP_KERNEL);
+	if (!qos_val) {
+		WARN("%s: No memory for PM QoS\n", __func__);
+		return;
+	}
+
+	for_each_possible_cpu(cpu)
+		qos_val[cpu] = c->default_value;
+
+	plist_for_each_entry(req, &c->list, node) {
+		for_each_cpu(cpu, &req->cpus_affine) {
+			switch (c->type) {
+			case PM_QOS_MIN:
+				if (qos_val[cpu] > req->node.prio)
+					qos_val[cpu] = req->node.prio;
+				break;
+			case PM_QOS_MAX:
+				if (req->node.prio > qos_val[cpu])
+					qos_val[cpu] = req->node.prio;
+				break;
+			default:
+				BUG();
+				break;
+			}
+		}
+	}
+
+	for_each_possible_cpu(cpu)
+		c->target_per_cpu[cpu] = qos_val[cpu];
+}
+
 /**
  * pm_qos_update_target - manages the constraints list and calls the notifiers
  *  if needed
@@ -206,6 +249,7 @@ int pm_qos_update_target(struct pm_qos_constraints *c,
 
 	curr_value = pm_qos_get_value(c);
 	pm_qos_set_value(c, curr_value);
+	pm_qos_set_value_for_cpus(c);
 
 	spin_unlock_irqrestore(&pm_qos_lock, flags);
 
@@ -298,6 +342,44 @@ int pm_qos_request(int pm_qos_class)
 }
 EXPORT_SYMBOL_GPL(pm_qos_request);
 
+int pm_qos_request_for_cpu(int pm_qos_class, int cpu)
+{
+	return pm_qos_array[pm_qos_class]->constraints->target_per_cpu[cpu];
+}
+EXPORT_SYMBOL(pm_qos_request_for_cpu);
+
+int pm_qos_request_for_cpumask(int pm_qos_class, struct cpumask *mask)
+{
+	unsigned long irqflags;
+	int cpu;
+	struct pm_qos_constraints *c = NULL;
+	int val;
+
+	spin_lock_irqsave(&pm_qos_lock, irqflags);
+	c = pm_qos_array[pm_qos_class]->constraints;
+	val = c->default_value;
+
+	for_each_cpu(cpu, mask) {
+		switch (c->type) {
+		case PM_QOS_MIN:
+			if (c->target_per_cpu[cpu] < val)
+				val = c->target_per_cpu[cpu];
+			break;
+		case PM_QOS_MAX:
+			if (c->target_per_cpu[cpu] > val)
+				val = c->target_per_cpu[cpu];
+			break;
+		default:
+			BUG();
+			break;
+		}
+	}
+	spin_unlock_irqrestore(&pm_qos_lock, irqflags);
+
+	return val;
+}
+EXPORT_SYMBOL(pm_qos_request_for_cpumask);
+
 int pm_qos_request_active(struct pm_qos_request *req)
 {
 	return req->pm_qos_class != 0;
@@ -353,6 +435,24 @@ void pm_qos_add_request(struct pm_qos_request *req,
 		WARN(1, KERN_ERR "pm_qos_add_request() called for already added request\n");
 		return;
 	}
+
+	switch (req->type) {
+	case PM_QOS_REQ_AFFINE_CORES:
+		if (cpumask_empty(&req->cpus_affine)) {
+			req->type = PM_QOS_REQ_ALL_CORES;
+			cpumask_setall(&req->cpus_affine);
+			WARN(1, KERN_ERR "Affine cores not set for request with affinity flag\n");
+		}
+		break;
+
+	default:
+		WARN(1, KERN_ERR "Unknown request type %d\n", req->type);
+		/* fall through */
+	case PM_QOS_REQ_ALL_CORES:
+		cpumask_setall(&req->cpus_affine);
+		break;
+	}
+
 	req->pm_qos_class = pm_qos_class;
 	INIT_DELAYED_WORK(&req->work, pm_qos_work_fn);
 	trace_pm_qos_add_request(pm_qos_class, value);
@@ -426,6 +526,7 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
  */
 void pm_qos_remove_request(struct pm_qos_request *req)
 {
+
 	if (!req) /*guard against callers passing in null */
 		return;
 		/* silent return to keep pcm code cleaner */
@@ -441,6 +542,7 @@ void pm_qos_remove_request(struct pm_qos_request *req)
 	pm_qos_update_target(pm_qos_array[req->pm_qos_class]->constraints,
 			     req, PM_QOS_REMOVE_REQ,
 			     PM_QOS_DEFAULT_VALUE);
+
 	memset(req, 0, sizeof(*req));
 }
 EXPORT_SYMBOL_GPL(pm_qos_remove_request);
-- 
1.9.1

