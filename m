Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753531AbaKRHdF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 02:33:05 -0500
Received: from mail-ig0-f170.google.com ([209.85.213.170]:61739 "EHLO
	mail-ig0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751417AbaKRHdB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 02:33:01 -0500
From: Lina Iyer <lina.iyer@linaro.org>
To: khilman@linaro.org, ulf.hansson@linaro.org,
        linux-arm-kernel@lists.infradead.org, linux-pm@vger.kernel.org,
        linux-kernel@vger.kernel.org, rjw@rjwysocki.net,
        daniel.lezcano@linaro.org
Cc: Lina Iyer <lina.iyer@linaro.org>
Subject: [PATCH v4/RFC 1/4] QoS: Modify data structures and function arguments for scalability.
Date: Tue, 18 Nov 2014 00:31:47 -0700
Message-Id: <1416295910-40433-2-git-send-email-lina.iyer@linaro.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
References: <1416295910-40433-1-git-send-email-lina.iyer@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Praveen Chidambaram <pchidamb@codeaurora.org>

QoS add requests uses a handle to the priority list that is used
internally to save the request, but this does not extend well. Also,
dev_pm_qos structure definition seems to use a list object directly.
The 'derivative' relationship seems to be broken.

Use pm_qos_request objects instead of passing around the protected
priority list object.

Signed-off-by: Lina Iyer <lina.iyer@linaro.org>
Acked-by: Kevin Hilman <khilman@linaro.org>
---
 drivers/base/power/qos.c | 14 +++++++-------
 include/linux/pm_qos.h   |  7 ++++---
 kernel/power/qos.c       | 14 ++++++++------
 3 files changed, 19 insertions(+), 16 deletions(-)

diff --git a/drivers/base/power/qos.c b/drivers/base/power/qos.c
index 36b9eb4..67a66b1 100644
--- a/drivers/base/power/qos.c
+++ b/drivers/base/power/qos.c
@@ -143,7 +143,7 @@ static int apply_constraint(struct dev_pm_qos_request *req,
 	switch(req->type) {
 	case DEV_PM_QOS_RESUME_LATENCY:
 		ret = pm_qos_update_target(&qos->resume_latency,
-					   &req->data.pnode, action, value);
+					   &req->data.lat, action, value);
 		if (ret) {
 			value = pm_qos_read_value(&qos->resume_latency);
 			blocking_notifier_call_chain(&dev_pm_notifiers,
@@ -153,7 +153,7 @@ static int apply_constraint(struct dev_pm_qos_request *req,
 		break;
 	case DEV_PM_QOS_LATENCY_TOLERANCE:
 		ret = pm_qos_update_target(&qos->latency_tolerance,
-					   &req->data.pnode, action, value);
+					   &req->data.lat, action, value);
 		if (ret) {
 			value = pm_qos_read_value(&qos->latency_tolerance);
 			req->dev->power.set_latency_tolerance(req->dev, value);
@@ -254,7 +254,7 @@ void dev_pm_qos_constraints_destroy(struct device *dev)
 
 	/* Flush the constraints lists for the device. */
 	c = &qos->resume_latency;
-	plist_for_each_entry_safe(req, tmp, &c->list, data.pnode) {
+	plist_for_each_entry_safe(req, tmp, &c->list, data.lat.node) {
 		/*
 		 * Update constraints list and call the notification
 		 * callbacks if needed
@@ -263,7 +263,7 @@ void dev_pm_qos_constraints_destroy(struct device *dev)
 		memset(req, 0, sizeof(*req));
 	}
 	c = &qos->latency_tolerance;
-	plist_for_each_entry_safe(req, tmp, &c->list, data.pnode) {
+	plist_for_each_entry_safe(req, tmp, &c->list, data.lat.node) {
 		apply_constraint(req, PM_QOS_REMOVE_REQ, PM_QOS_DEFAULT_VALUE);
 		memset(req, 0, sizeof(*req));
 	}
@@ -378,7 +378,7 @@ static int __dev_pm_qos_update_request(struct dev_pm_qos_request *req,
 	switch(req->type) {
 	case DEV_PM_QOS_RESUME_LATENCY:
 	case DEV_PM_QOS_LATENCY_TOLERANCE:
-		curr_value = req->data.pnode.prio;
+		curr_value = req->data.lat.node.prio;
 		break;
 	case DEV_PM_QOS_FLAGS:
 		curr_value = req->data.flr.flags;
@@ -831,8 +831,8 @@ s32 dev_pm_qos_get_user_latency_tolerance(struct device *dev)
 	mutex_lock(&dev_pm_qos_mtx);
 	ret = IS_ERR_OR_NULL(dev->power.qos)
 		|| !dev->power.qos->latency_tolerance_req ?
-			PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT :
-			dev->power.qos->latency_tolerance_req->data.pnode.prio;
+		PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT :
+		dev->power.qos->latency_tolerance_req->data.lat.node.prio;
 	mutex_unlock(&dev_pm_qos_mtx);
 	return ret;
 }
diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index 636e828..c4d859e 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -62,7 +62,7 @@ enum dev_pm_qos_req_type {
 struct dev_pm_qos_request {
 	enum dev_pm_qos_req_type type;
 	union {
-		struct plist_node pnode;
+		struct pm_qos_request lat;
 		struct pm_qos_flags_request flr;
 	} data;
 	struct device *dev;
@@ -115,7 +115,8 @@ static inline int dev_pm_qos_request_active(struct dev_pm_qos_request *req)
 	return req->dev != NULL;
 }
 
-int pm_qos_update_target(struct pm_qos_constraints *c, struct plist_node *node,
+int pm_qos_update_target(struct pm_qos_constraints *c,
+			 struct pm_qos_request *req,
 			 enum pm_qos_req_action action, int value);
 bool pm_qos_update_flags(struct pm_qos_flags *pqf,
 			 struct pm_qos_flags_request *req,
@@ -213,7 +214,7 @@ int dev_pm_qos_update_user_latency_tolerance(struct device *dev, s32 val);
 
 static inline s32 dev_pm_qos_requested_resume_latency(struct device *dev)
 {
-	return dev->power.qos->resume_latency_req->data.pnode.prio;
+	return dev->power.qos->resume_latency_req->data.lat.node.prio;
 }
 
 static inline s32 dev_pm_qos_requested_flags(struct device *dev)
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 5f4c006..602f5cb 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -186,19 +186,21 @@ static inline void pm_qos_set_value(struct pm_qos_constraints *c, s32 value)
  * pm_qos_update_target - manages the constraints list and calls the notifiers
  *  if needed
  * @c: constraints data struct
- * @node: request to add to the list, to update or to remove
+ * @req: request to add to the list, to update or to remove
  * @action: action to take on the constraints list
  * @value: value of the request to add or update
  *
  * This function returns 1 if the aggregated constraint value has changed, 0
  *  otherwise.
  */
-int pm_qos_update_target(struct pm_qos_constraints *c, struct plist_node *node,
+int pm_qos_update_target(struct pm_qos_constraints *c,
+			 struct pm_qos_request *req,
 			 enum pm_qos_req_action action, int value)
 {
 	unsigned long flags;
 	int prev_value, curr_value, new_value;
 	int ret;
+	struct plist_node *node = &req->node;
 
 	spin_lock_irqsave(&pm_qos_lock, flags);
 	prev_value = pm_qos_get_value(c);
@@ -335,7 +337,7 @@ static void __pm_qos_update_request(struct pm_qos_request *req,
 	if (new_value != req->node.prio)
 		pm_qos_update_target(
 			pm_qos_array[req->pm_qos_class]->constraints,
-			&req->node, PM_QOS_UPDATE_REQ, new_value);
+			req, PM_QOS_UPDATE_REQ, new_value);
 }
 
 /**
@@ -380,7 +382,7 @@ void pm_qos_add_request(struct pm_qos_request *req,
 	INIT_DELAYED_WORK(&req->work, pm_qos_work_fn);
 	trace_pm_qos_add_request(pm_qos_class, value);
 	pm_qos_update_target(pm_qos_array[pm_qos_class]->constraints,
-			     &req->node, PM_QOS_ADD_REQ, value);
+			     req, PM_QOS_ADD_REQ, value);
 }
 EXPORT_SYMBOL_GPL(pm_qos_add_request);
 
@@ -434,7 +436,7 @@ void pm_qos_update_request_timeout(struct pm_qos_request *req, s32 new_value,
 	if (new_value != req->node.prio)
 		pm_qos_update_target(
 			pm_qos_array[req->pm_qos_class]->constraints,
-			&req->node, PM_QOS_UPDATE_REQ, new_value);
+			req, PM_QOS_UPDATE_REQ, new_value);
 
 	schedule_delayed_work(&req->work, usecs_to_jiffies(timeout_us));
 }
@@ -462,7 +464,7 @@ void pm_qos_remove_request(struct pm_qos_request *req)
 
 	trace_pm_qos_remove_request(req->pm_qos_class, PM_QOS_DEFAULT_VALUE);
 	pm_qos_update_target(pm_qos_array[req->pm_qos_class]->constraints,
-			     &req->node, PM_QOS_REMOVE_REQ,
+			     req, PM_QOS_REMOVE_REQ,
 			     PM_QOS_DEFAULT_VALUE);
 	memset(req, 0, sizeof(*req));
 }
-- 
2.1.0

