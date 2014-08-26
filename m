Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758067AbaHZNMz (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Aug 2014 09:12:55 -0400
Received: from mail-wi0-f176.google.com ([209.85.212.176]:44565 "EHLO
	mail-wi0-f176.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757982AbaHZNMw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Aug 2014 09:12:52 -0400
From: Tomeu Vizoso <tomeu.vizoso@collabora.com>
To: linux-pm@vger.kernel.org
Cc: Thierry Reding <thierry.reding@gmail.com>,
        =?UTF-8?q?Terje=20Bergstr=C3=B6m?= <tbergstrom@nvidia.com>,
        Stephen Warren <swarren@wwwdotorg.org>,
        "Rafael J. Wysocki" <rjw@rjwysocki.net>, Pavel Machek <pavel@ucw.cz>,
        Len Brown <len.brown@intel.com>, linux-tegra@vger.kernel.org,
        linux-kernel@vger.kernel.org,
        Javier Martinez Canillas <javier.martinez@collabora.co.uk>,
        Mikko Perttunen <mperttunen@nvidia.com>,
        Tomeu Vizoso <tomeu.vizoso@collabora.com>
Subject: [PATCH v4 1/3] PM / QoS: Add PM_QOS_MEMORY_BANDWIDTH class
Date: Tue, 26 Aug 2014 15:12:06 +0200
Message-Id: <1409058728-13347-2-git-send-email-tomeu.vizoso@collabora.com>
X-Mailer: git-send-email 1.9.3
In-Reply-To: <1409058728-13347-1-git-send-email-tomeu.vizoso@collabora.com>
References: <1409058728-13347-1-git-send-email-tomeu.vizoso@collabora.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Also adds a class type PM_QOS_SUM that aggregates the values by summing them.

It can be used by memory controllers to calculate the optimum clock frequency
based on the bandwidth needs of the different memory clients.

Signed-off-by: Tomeu Vizoso <tomeu.vizoso@collabora.com>
Acked-by: Pavel Machek <pavel@ucw.cz>

---

v3: * Changed units to be megabits per second
---
 Documentation/power/pm_qos_interface.txt |  4 +++-
 include/linux/pm_qos.h                   |  5 ++++-
 kernel/power/qos.c                       | 27 ++++++++++++++++++++++++++-
 3 files changed, 33 insertions(+), 3 deletions(-)

diff --git a/Documentation/power/pm_qos_interface.txt b/Documentation/power/pm_qos_interface.txt
index a5da5c7..129f7c0 100644
--- a/Documentation/power/pm_qos_interface.txt
+++ b/Documentation/power/pm_qos_interface.txt
@@ -5,7 +5,8 @@ performance expectations by drivers, subsystems and user space applications on
 one of the parameters.
 
 Two different PM QoS frameworks are available:
-1. PM QoS classes for cpu_dma_latency, network_latency, network_throughput.
+1. PM QoS classes for cpu_dma_latency, network_latency, network_throughput,
+memory_bandwidth.
 2. the per-device PM QoS framework provides the API to manage the per-device latency
 constraints and PM QoS flags.
 
@@ -13,6 +14,7 @@ Each parameters have defined units:
  * latency: usec
  * timeout: usec
  * throughput: kbs (kilo bit / sec)
+ * memory bandwidth: mbs (mega bit / sec)
 
 
 1. PM QoS framework
diff --git a/include/linux/pm_qos.h b/include/linux/pm_qos.h
index 9ab4bf7..636e828 100644
--- a/include/linux/pm_qos.h
+++ b/include/linux/pm_qos.h
@@ -15,6 +15,7 @@ enum {
 	PM_QOS_CPU_DMA_LATENCY,
 	PM_QOS_NETWORK_LATENCY,
 	PM_QOS_NETWORK_THROUGHPUT,
+	PM_QOS_MEMORY_BANDWIDTH,
 
 	/* insert new class ID */
 	PM_QOS_NUM_CLASSES,
@@ -32,6 +33,7 @@ enum pm_qos_flags_status {
 #define PM_QOS_CPU_DMA_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_LAT_DEFAULT_VALUE	(2000 * USEC_PER_SEC)
 #define PM_QOS_NETWORK_THROUGHPUT_DEFAULT_VALUE	0
+#define PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE	0
 #define PM_QOS_RESUME_LATENCY_DEFAULT_VALUE	0
 #define PM_QOS_LATENCY_TOLERANCE_DEFAULT_VALUE	0
 #define PM_QOS_LATENCY_TOLERANCE_NO_CONSTRAINT	(-1)
@@ -69,7 +71,8 @@ struct dev_pm_qos_request {
 enum pm_qos_type {
 	PM_QOS_UNITIALIZED,
 	PM_QOS_MAX,		/* return the largest value */
-	PM_QOS_MIN		/* return the smallest value */
+	PM_QOS_MIN,		/* return the smallest value */
+	PM_QOS_SUM		/* return the sum */
 };
 
 /*
diff --git a/kernel/power/qos.c b/kernel/power/qos.c
index 884b770..5f4c006 100644
--- a/kernel/power/qos.c
+++ b/kernel/power/qos.c
@@ -105,11 +105,27 @@ static struct pm_qos_object network_throughput_pm_qos = {
 };
 
 
+static BLOCKING_NOTIFIER_HEAD(memory_bandwidth_notifier);
+static struct pm_qos_constraints memory_bw_constraints = {
+	.list = PLIST_HEAD_INIT(memory_bw_constraints.list),
+	.target_value = PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE,
+	.default_value = PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE,
+	.no_constraint_value = PM_QOS_MEMORY_BANDWIDTH_DEFAULT_VALUE,
+	.type = PM_QOS_SUM,
+	.notifiers = &memory_bandwidth_notifier,
+};
+static struct pm_qos_object memory_bandwidth_pm_qos = {
+	.constraints = &memory_bw_constraints,
+	.name = "memory_bandwidth",
+};
+
+
 static struct pm_qos_object *pm_qos_array[] = {
 	&null_pm_qos,
 	&cpu_dma_pm_qos,
 	&network_lat_pm_qos,
-	&network_throughput_pm_qos
+	&network_throughput_pm_qos,
+	&memory_bandwidth_pm_qos,
 };
 
 static ssize_t pm_qos_power_write(struct file *filp, const char __user *buf,
@@ -130,6 +146,9 @@ static const struct file_operations pm_qos_power_fops = {
 /* unlocked internal variant */
 static inline int pm_qos_get_value(struct pm_qos_constraints *c)
 {
+	struct plist_node *node;
+	int total_value = 0;
+
 	if (plist_head_empty(&c->list))
 		return c->no_constraint_value;
 
@@ -140,6 +159,12 @@ static inline int pm_qos_get_value(struct pm_qos_constraints *c)
 	case PM_QOS_MAX:
 		return plist_last(&c->list)->prio;
 
+	case PM_QOS_SUM:
+		plist_for_each(node, &c->list)
+			total_value += node->prio;
+
+		return total_value;
+
 	default:
 		/* runtime check for not using enum */
 		BUG();
-- 
1.9.3

