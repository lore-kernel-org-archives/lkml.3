Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754626Ab3GXWG1 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Jul 2013 18:06:27 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55353 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753148Ab3GXWF6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Jul 2013 18:05:58 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Richard Cochran <richardcochran@gmail.com>
Subject: [PATCH 17/36] PTP: convert class code to use dev_groups
Date: Wed, 24 Jul 2013 15:05:20 -0700
Message-Id: <1374703539-9705-18-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
References: <1374703539-9705-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct class is going away soon, dev_groups
should be used instead.  This converts the ptp class code to use the
correct field.

Cc: Richard Cochran <richardcochran@gmail.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---

Richard, feel free to take this through your tree, or ACK it and I can take it
through mine.

 drivers/ptp/ptp_clock.c   |  2 +-
 drivers/ptp/ptp_private.h |  2 +-
 drivers/ptp/ptp_sysfs.c   | 51 +++++++++++++++++++++++++++--------------------
 3 files changed, 31 insertions(+), 24 deletions(-)

diff --git a/drivers/ptp/ptp_clock.c b/drivers/ptp/ptp_clock.c
index 4a8c3883..a8319b26 100644
--- a/drivers/ptp/ptp_clock.c
+++ b/drivers/ptp/ptp_clock.c
@@ -330,7 +330,7 @@ static int __init ptp_init(void)
 		goto no_region;
 	}
 
-	ptp_class->dev_attrs = ptp_dev_attrs;
+	ptp_class->dev_groups = ptp_groups;
 	pr_info("PTP clock support registered\n");
 	return 0;
 
diff --git a/drivers/ptp/ptp_private.h b/drivers/ptp/ptp_private.h
index 69d32070..df03f2e3 100644
--- a/drivers/ptp/ptp_private.h
+++ b/drivers/ptp/ptp_private.h
@@ -84,7 +84,7 @@ uint ptp_poll(struct posix_clock *pc,
  * see ptp_sysfs.c
  */
 
-extern struct device_attribute ptp_dev_attrs[];
+extern const struct attribute_group *ptp_groups[];
 
 int ptp_cleanup_sysfs(struct ptp_clock *ptp);
 
diff --git a/drivers/ptp/ptp_sysfs.c b/drivers/ptp/ptp_sysfs.c
index 2f93926a..13ec5311 100644
--- a/drivers/ptp/ptp_sysfs.c
+++ b/drivers/ptp/ptp_sysfs.c
@@ -27,36 +27,43 @@ static ssize_t clock_name_show(struct device *dev,
 	struct ptp_clock *ptp = dev_get_drvdata(dev);
 	return snprintf(page, PAGE_SIZE-1, "%s\n", ptp->info->name);
 }
+static DEVICE_ATTR(clock_name, 0444, clock_name_show, NULL);
 
-#define PTP_SHOW_INT(name)						\
-static ssize_t name##_show(struct device *dev,				\
+#define PTP_SHOW_INT(name, var)						\
+static ssize_t var##_show(struct device *dev,				\
 			   struct device_attribute *attr, char *page)	\
 {									\
 	struct ptp_clock *ptp = dev_get_drvdata(dev);			\
-	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->info->name);	\
-}
-
-PTP_SHOW_INT(max_adj);
-PTP_SHOW_INT(n_alarm);
-PTP_SHOW_INT(n_ext_ts);
-PTP_SHOW_INT(n_per_out);
-PTP_SHOW_INT(pps);
+	return snprintf(page, PAGE_SIZE-1, "%d\n", ptp->info->var);	\
+}									\
+static DEVICE_ATTR(name, 0444, var##_show, NULL);
+
+PTP_SHOW_INT(max_adjustment, max_adj);
+PTP_SHOW_INT(n_alarms, n_alarm);
+PTP_SHOW_INT(n_external_timestamps, n_ext_ts);
+PTP_SHOW_INT(n_periodic_outputs, n_per_out);
+PTP_SHOW_INT(pps_available, pps);
+
+static struct attribute *ptp_attrs[] = {
+	&dev_attr_clock_name.attr,
+	&dev_attr_max_adjustment.attr,
+	&dev_attr_n_alarms.attr,
+	&dev_attr_n_external_timestamps.attr,
+	&dev_attr_n_periodic_outputs.attr,
+	&dev_attr_pps_available.attr,
+	NULL,
+};
 
-#define PTP_RO_ATTR(_var, _name) {				\
-	.attr	= { .name = __stringify(_name), .mode = 0444 },	\
-	.show	= _var##_show,					\
-}
+static const struct attribute_group ptp_group = {
+	.attrs = ptp_attrs,
+};
 
-struct device_attribute ptp_dev_attrs[] = {
-	PTP_RO_ATTR(clock_name,	clock_name),
-	PTP_RO_ATTR(max_adj,	max_adjustment),
-	PTP_RO_ATTR(n_alarm,	n_alarms),
-	PTP_RO_ATTR(n_ext_ts,	n_external_timestamps),
-	PTP_RO_ATTR(n_per_out,	n_periodic_outputs),
-	PTP_RO_ATTR(pps,	pps_available),
-	__ATTR_NULL,
+const struct attribute_group *ptp_groups[] = {
+	&ptp_group,
+	NULL,
 };
 
+
 static ssize_t extts_enable_store(struct device *dev,
 				  struct device_attribute *attr,
 				  const char *buf, size_t count)
-- 
1.8.3.rc0.20.gb99dd2e

