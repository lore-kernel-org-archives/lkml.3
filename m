Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751303Ab3A3J1E (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:27:04 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37751 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753184Ab3A3J00 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:26:26 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 8/9] dasd: Add 'timeout' attribute
Date: Wed, 30 Jan 2013 10:26:18 +0100
Message-Id: <1359537979-39483-9-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359537979-39483-1-git-send-email-hare@suse.de>
References: <1359537979-39483-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch adds a 'timeout' attibute to the DASD driver.
When set to non-zero, the blk_timeout function will
be enabled with the timeout specified in the attribute.
Setting 'timeout' to '0' will disable block timeouts.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/s390/block/dasd.c        |    2 +
 drivers/s390/block/dasd_devmap.c |   56 ++++++++++++++++++++++++++++++++++++++
 drivers/s390/block/dasd_int.h    |    4 +++
 3 files changed, 62 insertions(+), 0 deletions(-)

diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index bab870b..64b1b81 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -2785,6 +2785,8 @@ enum blk_eh_timer_return dasd_times_out(struct request *req)
 		return BLK_EH_NOT_HANDLED;
 
 	device = cqr->startdev ? cqr->startdev : block->base;
+	if (!device->blk_timeout)
+		return BLK_EH_RESET_TIMER;
 	DBF_DEV_EVENT(DBF_WARNING, device,
 		      " dasd_times_out cqr %p status %x",
 		      cqr, cqr->status);
diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index d237e31..91d656a6c 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -1281,6 +1281,61 @@ dasd_retries_store(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(retries, 0644, dasd_retries_show, dasd_retries_store);
 
+static ssize_t
+dasd_timeout_show(struct device *dev, struct device_attribute *attr,
+		  char *buf)
+{
+	struct dasd_device *device;
+	int len;
+
+	device = dasd_device_from_cdev(to_ccwdev(dev));
+	if (IS_ERR(device))
+		return -ENODEV;
+	len = snprintf(buf, PAGE_SIZE, "%lu\n", device->blk_timeout);
+	dasd_put_device(device);
+	return len;
+}
+
+static ssize_t
+dasd_timeout_store(struct device *dev, struct device_attribute *attr,
+		   const char *buf, size_t count)
+{
+	struct dasd_device *device;
+	struct request_queue *q;
+	unsigned long val, flags;
+
+	device = dasd_device_from_cdev(to_ccwdev(dev));
+	if (IS_ERR(device) || !device->block)
+		return -ENODEV;
+
+	if ((strict_strtoul(buf, 10, &val) != 0) ||
+	    val > UINT_MAX / HZ) {
+		dasd_put_device(device);
+		return -EINVAL;
+	}
+	q = device->block->request_queue;
+	if (!q) {
+		dasd_put_device(device);
+		return -ENODEV;
+	}
+	spin_lock_irqsave(&device->block->request_queue_lock, flags);
+	if (!val)
+		blk_queue_rq_timed_out(q, NULL);
+	else
+		blk_queue_rq_timed_out(q, dasd_times_out);
+
+	device->blk_timeout = val;
+
+	blk_queue_rq_timeout(q, device->blk_timeout * HZ);
+	spin_unlock_irqrestore(&device->block->request_queue_lock, flags);
+
+	dasd_put_device(device);
+	return count;
+}
+
+static DEVICE_ATTR(timeout, 0644,
+		   dasd_timeout_show, dasd_timeout_store);
+
 static ssize_t dasd_reservation_policy_show(struct device *dev,
 					    struct device_attribute *attr,
 					    char *buf)
@@ -1392,6 +1447,7 @@ static struct attribute * dasd_attrs[] = {
 	&dev_attr_failfast.attr,
 	&dev_attr_expires.attr,
 	&dev_attr_retries.attr,
+	&dev_attr_timeout.attr,
 	&dev_attr_reservation_policy.attr,
 	&dev_attr_last_known_reservation_state.attr,
 	&dev_attr_safe_offline.attr,
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 375ba1f..d00d07a 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -469,6 +469,8 @@ struct dasd_device {
 	unsigned long default_expires;
 	unsigned long default_retries;
 
+	unsigned long blk_timeout;
+
 	struct dentry *debugfs_dentry;
 	struct dasd_profile profile;
 };
@@ -662,6 +664,8 @@ void dasd_free_device(struct dasd_device *);
 struct dasd_block *dasd_alloc_block(void);
 void dasd_free_block(struct dasd_block *);
 
+enum blk_eh_timer_return dasd_times_out(struct request *req);
+
 void dasd_enable_device(struct dasd_device *);
 void dasd_set_target_state(struct dasd_device *, int);
 void dasd_kick_device(struct dasd_device *);
-- 
1.7.4.2

