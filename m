Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933588AbaE2IQL (ORCPT <rfc822;w@1wt.eu>);
	Thu, 29 May 2014 04:16:11 -0400
Received: from mail-pa0-f52.google.com ([209.85.220.52]:43926 "EHLO
	mail-pa0-f52.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933476AbaE2IQG (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 29 May 2014 04:16:06 -0400
From: Amit Daniel Kachhap <amit.daniel@samsung.com>
To: linux-pm@vger.kernel.org, linux-acpi@vger.kernel.org
Cc: Zhang Rui <rui.zhang@intel.com>, linux-kernel@vger.kernel.org,
        amit.kachhap@gmail.com, edubezval@gmail.com, rjw@rjwysocki.net,
        linux-arm-kernel@lists.infradead.org, lenb@kernel.org
Subject: [PATCH v1 3/6] thermal: thermal-core: Add notifications support for the cooling states
Date: Thu, 29 May 2014 13:45:31 +0530
Message-Id: <1401351334-11210-4-git-send-email-amit.daniel@samsung.com>
X-Mailer: git-send-email 1.7.1
In-Reply-To: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
References: <1401351334-11210-1-git-send-email-amit.daniel@samsung.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds notification infrastructure for any requests related to cooling
states. The notifier structure passed is of both Get/Set type. So the receiver
of these can sense the new/cur/max cooling state as decided by thermal governor.
In addition to that it can also override the cooling state and may do something
interesting after receiving these CPU cooling events such as masking some
states, enabling some extra conditional states or perform any extra operation
for aggressive thermal cooling.
The notfications events can be of type,

1. COOLING_SET_STATE_PRE
2. COOLING_SET_STATE_POST
3. COOLING_GET_CUR_STATE
4. COOLING_GET_MAX_STATE

Signed-off-by: Amit Daniel Kachhap <amit.daniel@samsung.com>
---
 Documentation/thermal/sysfs-api.txt |   21 +++++++++++
 drivers/thermal/thermal_core.c      |   69 ++++++++++++++++++++++++++++++++++-
 include/linux/thermal.h             |   21 +++++++++++
 3 files changed, 109 insertions(+), 2 deletions(-)

diff --git a/Documentation/thermal/sysfs-api.txt b/Documentation/thermal/sysfs-api.txt
index 87519cb..5f45e03 100644
--- a/Documentation/thermal/sysfs-api.txt
+++ b/Documentation/thermal/sysfs-api.txt
@@ -92,6 +92,27 @@ temperature) and throttle appropriate devices.
     It deletes the corresponding entry form /sys/class/thermal folder and
     unbind itself from all the thermal zone devices using it.
 
+1.2.3 int thermal_cooling_register_notifier(struct notifier_block *nb)
+
+    This interface function registers the client notifier handler. The notifier
+    handler can use this to monitor or update any cooling state requests.
+    nb: notifier structure containing client notifier handler.
+
+1.2.4 int thermal_cooling_unregister_notifier(struct notifier_block *nb)
+
+    This interface function unregisters the client notifier handler.
+    nb: notifier structure containing client notifier handler.
+
+1.2.5 int thermal_cooling_notify_states(struct thermal_cooling_status *request,enum cooling_state_ops op)
+
+    This interface function invokes the earlier registered cooling states handler.
+    request: holds the relevant cooling state value.
+	.cur_state: current cooling state.
+	.new_state: new cooling state to be set.
+	.max_state: max cooling state.
+	.devdata: driver private data pointer.
+    op: describes various operation supported.
+
 1.3 interface for binding a thermal zone device with a thermal cooling device
 1.3.1 int thermal_zone_bind_cooling_device(struct thermal_zone_device *tz,
 	int trip, struct thermal_cooling_device *cdev,
diff --git a/drivers/thermal/thermal_core.c b/drivers/thermal/thermal_core.c
index 71b0ec0..1a60f83 100644
--- a/drivers/thermal/thermal_core.c
+++ b/drivers/thermal/thermal_core.c
@@ -52,6 +52,8 @@ static DEFINE_MUTEX(thermal_idr_lock);
 static LIST_HEAD(thermal_tz_list);
 static LIST_HEAD(thermal_cdev_list);
 static LIST_HEAD(thermal_governor_list);
+/* Notfier list to validates/updates the cpufreq cooling states */
+static BLOCKING_NOTIFIER_HEAD(cooling_state_notifier_list);
 
 static DEFINE_MUTEX(thermal_list_lock);
 static DEFINE_MUTEX(thermal_governor_lock);
@@ -1073,8 +1075,71 @@ static struct class thermal_class = {
 };
 
 /**
- * __thermal_cooling_device_register() - register a new thermal cooling device
- * @np:		a pointer to a device tree node.
+ * thermal_cooling_notify_states - Invoke the necessary cooling states handler.
+ * @request: holds the relevant cooling state value. say if the cooling state
+ * operation is of type COOLING_GET_MAX_STATE, then request holds
+ * the current max cooling state value.
+ * @op: different operations supported
+ *
+ * This API allows the registered user to recieve the different cooling
+ * notifications like current state, max state and set state.
+ *
+ * Return: 0 (success)
+ */
+int thermal_cooling_notify_states(struct thermal_cooling_status *request,
+				enum cooling_state_ops op)
+{
+	/* Invoke the notifiers which have registered for this state change */
+	if (op == COOLING_SET_STATE_PRE ||
+		op == COOLING_SET_STATE_POST ||
+		op == COOLING_GET_MAX_STATE ||
+		op == COOLING_GET_CUR_STATE) {
+		blocking_notifier_call_chain(
+			&cooling_state_notifier_list, op, request);
+	}
+	return 0;
+}
+EXPORT_SYMBOL_GPL(thermal_cooling_notify_states);
+
+/**
+ * thermal_cooling_register_notifier - registers a notifier with thermal cooling.
+ * @nb:	notifier function to register.
+ *
+ * Add a driver to receive all cooling notifications like current state,
+ * max state and set state. The drivers after reading the events can perform
+ * some mapping like grouping some P states into 1 cooling state.
+ *
+ * Return: 0 (success)
+ */
+int thermal_cooling_register_notifier(struct notifier_block *nb)
+{
+	int ret = 0;
+	ret = blocking_notifier_chain_register(
+				&cooling_state_notifier_list, nb);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(thermal_cooling_register_notifier);
+
+/**
+ * thermal_cooling_unregister_notifier - unregisters a notifier with thermal
+ * cooling.
+ * @nb:	notifier function to unregister.
+ *
+ * Removes a driver to receive further cooling notifications.
+ *
+ * Return: 0 (success)
+ */
+int thermal_cooling_unregister_notifier(struct notifier_block *nb)
+{
+	int ret = 0;
+	ret = blocking_notifier_chain_unregister(
+				&cooling_state_notifier_list, nb);
+	return ret;
+}
+EXPORT_SYMBOL_GPL(thermal_cooling_unregister_notifier);
+
+/**
+ * thermal_cooling_device_register() - register a new thermal cooling device
  * @type:	the thermal cooling device type.
  * @devdata:	device private data.
  * @ops:		standard thermal cooling devices callbacks.
diff --git a/include/linux/thermal.h b/include/linux/thermal.h
index f7e11c7..3fb1b92 100644
--- a/include/linux/thermal.h
+++ b/include/linux/thermal.h
@@ -106,6 +106,21 @@ enum {
 };
 #define THERMAL_GENL_CMD_MAX (__THERMAL_GENL_CMD_MAX - 1)
 
+/* Cooling states supported operations */
+enum cooling_state_ops {
+	COOLING_SET_STATE_PRE,
+	COOLING_SET_STATE_POST,
+	COOLING_GET_CUR_STATE,
+	COOLING_GET_MAX_STATE,
+};
+
+struct thermal_cooling_status {
+	unsigned long cur_state;
+	unsigned long new_state;
+	unsigned long max_state;
+	void *devdata;
+};
+
 struct thermal_zone_device_ops {
 	int (*bind) (struct thermal_zone_device *,
 		     struct thermal_cooling_device *);
@@ -285,6 +300,12 @@ struct thermal_cooling_device *
 thermal_of_cooling_device_register(struct device_node *np, char *, void *,
 				   const struct thermal_cooling_device_ops *);
 void thermal_cooling_device_unregister(struct thermal_cooling_device *);
+
+int thermal_cooling_notify_states(struct thermal_cooling_status *request,
+				enum cooling_state_ops op);
+int thermal_cooling_register_notifier(struct notifier_block *nb);
+int thermal_cooling_unregister_notifier(struct notifier_block *nb);
+
 struct thermal_zone_device *thermal_zone_get_zone_by_name(const char *name);
 int thermal_zone_get_temp(struct thermal_zone_device *tz, unsigned long *temp);
 
-- 
1.7.1

