Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753191AbaLENmH (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Dec 2014 08:42:07 -0500
Received: from hqemgate16.nvidia.com ([216.228.121.65]:10546 "EHLO
	hqemgate16.nvidia.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752208AbaLENmC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Dec 2014 08:42:02 -0500
X-PGP-Universal: processed;
	by hqnvupgp07.nvidia.com on Fri, 05 Dec 2014 05:39:23 -0800
From: Arto Merilainen <amerilainen@nvidia.com>
To: <myungjoo.ham@samsung.com>, <kyungmin.park@samsung.com>,
        <tomeu.vizoso@collabora.com>, <gnurou@gmail.com>
CC: <javier.martinez@collabora.co.uk>, <linux-pm@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-tegra@vger.kernel.org>,
        <swarren@wwwdotorg.org>, <thierry.reding@gmail.com>,
        <grant.likely@linaro.org>, <srasal@nvidia.com>,
        <amerilainen@nvidia.com>
Subject: [RFC RESEND 1/3] PM / devfreq: Add watermark events
Date: Fri, 5 Dec 2014 15:41:30 +0200
Message-ID: <1417786892-477-2-git-send-email-amerilainen@nvidia.com>
X-Mailer: git-send-email 1.8.1.5
In-Reply-To: <1417786892-477-1-git-send-email-amerilainen@nvidia.com>
References: <1417786892-477-1-git-send-email-amerilainen@nvidia.com>
X-NVConfidentiality: public
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Shridhar Rasal <srasal@nvidia.com>

This patch adds support for watermark events. These events inform
the governor that the device load has gone below (low watermark) or
above (high watermark) certain load value.

Signed-off-by: Shridhar Rasal <srasal@nvidia.com>
Signed-off-by: Arto Merilainen <amerilainen@nvidia.com>
---
 drivers/devfreq/devfreq.c  | 19 +++++++++++++++++++
 drivers/devfreq/governor.h |  1 +
 include/linux/devfreq.h    | 26 ++++++++++++++++++++++++++
 3 files changed, 46 insertions(+)

diff --git a/drivers/devfreq/devfreq.c b/drivers/devfreq/devfreq.c
index 30b538d8cc90..8333d024132a 100644
--- a/drivers/devfreq/devfreq.c
+++ b/drivers/devfreq/devfreq.c
@@ -1050,6 +1050,25 @@ static struct attribute *devfreq_attrs[] = {
 };
 ATTRIBUTE_GROUPS(devfreq);
 
+/**
+ * devfreq_watermark_event() - Handles watermark events
+ * @devfreq: the devfreq instance to be updated
+ * @type: type of watermark event
+ */
+int devfreq_watermark_event(struct devfreq *devfreq, int type)
+{
+	if (!devfreq)
+		return -EINVAL;
+
+	if (!devfreq->governor)
+		return -EINVAL;
+
+	return devfreq->governor->event_handler(devfreq,
+				DEVFREQ_GOV_WMARK, &type);
+}
+EXPORT_SYMBOL(devfreq_watermark_event);
+
+
 static int __init devfreq_init(void)
 {
 	devfreq_class = class_create(THIS_MODULE, "devfreq");
diff --git a/drivers/devfreq/governor.h b/drivers/devfreq/governor.h
index fad7d6321978..fb9875388f3f 100644
--- a/drivers/devfreq/governor.h
+++ b/drivers/devfreq/governor.h
@@ -24,6 +24,7 @@
 #define DEVFREQ_GOV_INTERVAL			0x3
 #define DEVFREQ_GOV_SUSPEND			0x4
 #define DEVFREQ_GOV_RESUME			0x5
+#define DEVFREQ_GOV_WMARK			0x6
 
 /* Caution: devfreq->lock must be locked before calling update_devfreq */
 extern int update_devfreq(struct devfreq *devfreq);
diff --git a/include/linux/devfreq.h b/include/linux/devfreq.h
index f1863dcd83ea..b5bf6c4fe286 100644
--- a/include/linux/devfreq.h
+++ b/include/linux/devfreq.h
@@ -21,6 +21,12 @@
 
 struct devfreq;
 
+enum watermark_type {
+	NO_WATERMARK_EVENT = 0,
+	HIGH_WATERMARK_EVENT = 1,
+	LOW_WATERMARK_EVENT = 2
+};
+
 /**
  * struct devfreq_dev_status - Data given from devfreq user device to
  *			     governors. Represents the performance
@@ -68,6 +74,16 @@ struct devfreq_dev_status {
  *			status to devfreq, which is used by governors.
  * @get_cur_freq:	The device should provide the current frequency
  *			at which it is operating.
+ * @set_high_wmark:	This is an optional callback to set high
+ *			watermark for watermark event. The value is
+ *			be scaled between 0 and 1000 where 1000 equals to
+ *			100% load. Setting this value to 1000 disables
+ *			the event
+ * @set_low_wmark:	This is an optional callback to set low
+ *			watermark for watermark event. The value is
+ *			be scaled between 0 and 1000 where 1000 equals to
+ *			100% load. Setting this value to 0 disables the
+ *			event.
  * @exit:		An optional callback that is called when devfreq
  *			is removing the devfreq object due to error or
  *			from devfreq_remove_device() call. If the user
@@ -84,6 +100,8 @@ struct devfreq_dev_profile {
 	int (*get_dev_status)(struct device *dev,
 			      struct devfreq_dev_status *stat);
 	int (*get_cur_freq)(struct device *dev, unsigned long *freq);
+	int (*set_high_wmark)(struct device *dev, unsigned int val);
+	int (*set_low_wmark)(struct device *dev, unsigned int val);
 	void (*exit)(struct device *dev);
 
 	unsigned int *freq_table;
@@ -191,6 +209,8 @@ extern void devm_devfreq_remove_device(struct device *dev,
 /* Supposed to be called by PM_SLEEP/PM_RUNTIME callbacks */
 extern int devfreq_suspend_device(struct devfreq *devfreq);
 extern int devfreq_resume_device(struct devfreq *devfreq);
+extern int devfreq_watermark_event(struct devfreq *devfreq,
+				  int type);
 
 /* Helper functions for devfreq user device driver with OPP. */
 extern struct dev_pm_opp *devfreq_recommended_opp(struct device *dev,
@@ -289,6 +309,12 @@ static inline void devm_devfreq_unregister_opp_notifier(struct device *dev,
 							struct devfreq *devfreq)
 {
 }
+
+static inline int devfreq_watermark_event(struct devfreq *devfreq,
+					int type)
+{
+	return 0;
+}
 #endif /* CONFIG_PM_DEVFREQ */
 
 #endif /* __LINUX_DEVFREQ_H__ */
-- 
1.8.1.5

