Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932224Ab3HWV0B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Aug 2013 17:26:01 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60458 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932164Ab3HWVZF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Aug 2013 17:25:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, Tejun Heo <tj@kernel.org>
Subject: [PATCH 15/15] workqueue: convert bus code to use dev_groups
Date: Fri, 23 Aug 2013 14:24:41 -0700
Message-Id: <1377293081-10957-15-git-send-email-gregkh@linuxfoundation.org>
X-Mailer: git-send-email 1.8.3.rc0.20.gb99dd2e
In-Reply-To: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
References: <1377293081-10957-1-git-send-email-gregkh@linuxfoundation.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The dev_attrs field of struct bus_type is going away soon, dev_groups
should be used instead.  This converts the workqueue bus code to use
the correct field.

Cc: Tejun Heo <tj@kernel.org>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 kernel/workqueue.c | 27 +++++++++++++++------------
 1 file changed, 15 insertions(+), 12 deletions(-)

diff --git a/kernel/workqueue.c b/kernel/workqueue.c
index 7f5d4be2..0d6063d8 100644
--- a/kernel/workqueue.c
+++ b/kernel/workqueue.c
@@ -3086,25 +3086,26 @@ static struct workqueue_struct *dev_to_wq(struct device *dev)
 	return wq_dev->wq;
 }
 
-static ssize_t wq_per_cpu_show(struct device *dev,
-			       struct device_attribute *attr, char *buf)
+static ssize_t per_cpu_show(struct device *dev, struct device_attribute *attr,
+			    char *buf)
 {
 	struct workqueue_struct *wq = dev_to_wq(dev);
 
 	return scnprintf(buf, PAGE_SIZE, "%d\n", (bool)!(wq->flags & WQ_UNBOUND));
 }
+static DEVICE_ATTR_RO(per_cpu);
 
-static ssize_t wq_max_active_show(struct device *dev,
-				  struct device_attribute *attr, char *buf)
+static ssize_t max_active_show(struct device *dev,
+			       struct device_attribute *attr, char *buf)
 {
 	struct workqueue_struct *wq = dev_to_wq(dev);
 
 	return scnprintf(buf, PAGE_SIZE, "%d\n", wq->saved_max_active);
 }
 
-static ssize_t wq_max_active_store(struct device *dev,
-				   struct device_attribute *attr,
-				   const char *buf, size_t count)
+static ssize_t max_active_store(struct device *dev,
+				struct device_attribute *attr, const char *buf,
+				size_t count)
 {
 	struct workqueue_struct *wq = dev_to_wq(dev);
 	int val;
@@ -3115,12 +3116,14 @@ static ssize_t wq_max_active_store(struct device *dev,
 	workqueue_set_max_active(wq, val);
 	return count;
 }
+static DEVICE_ATTR_RW(max_active);
 
-static struct device_attribute wq_sysfs_attrs[] = {
-	__ATTR(per_cpu, 0444, wq_per_cpu_show, NULL),
-	__ATTR(max_active, 0644, wq_max_active_show, wq_max_active_store),
-	__ATTR_NULL,
+static struct attribute *wq_sysfs_attrs[] = {
+	&dev_attr_per_cpu.attr,
+	&dev_attr_max_active.attr,
+	NULL,
 };
+ATTRIBUTE_GROUPS(wq_sysfs);
 
 static ssize_t wq_pool_ids_show(struct device *dev,
 				struct device_attribute *attr, char *buf)
@@ -3270,7 +3273,7 @@ static struct device_attribute wq_sysfs_unbound_attrs[] = {
 
 static struct bus_type wq_subsys = {
 	.name				= "workqueue",
-	.dev_attrs			= wq_sysfs_attrs,
+	.dev_groups			= wq_sysfs_groups,
 };
 
 static int __init wq_sysfs_init(void)
-- 
1.8.3.rc0.20.gb99dd2e

