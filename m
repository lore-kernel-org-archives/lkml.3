Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758634Ab3FCPGR (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Jun 2013 11:06:17 -0400
Received: from e06smtp11.uk.ibm.com ([195.75.94.107]:42433 "EHLO
	e06smtp11.uk.ibm.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758602Ab3FCPEU (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Jun 2013 11:04:20 -0400
From: Martin Schwidefsky <schwidefsky@de.ibm.com>
To: linux-kernel <linux-kernel@vger.kernel.org>,
        linux-s390 <linux-s390@vger.kernel.org>, Jens Axboe <axboe@kernel.dk>
Cc: Martin Schwidefsky <schwidefsky@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>, Stefan Weinhuber <wein@de.ibm.com>
Subject: [PATCH 2/9] dasd: make number of retries configurable
Date: Mon,  3 Jun 2013 17:03:15 +0200
Message-Id: <1370271802-30019-3-git-send-email-schwidefsky@de.ibm.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
References: <1370271802-30019-1-git-send-email-schwidefsky@de.ibm.com>
X-TM-AS-MML: No
X-Content-Scanned: Fidelis XPS MAILER
x-cbid: 13060314-5024-0000-0000-000006396332
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Hannes Reinecke <hare@suse.de>

Instead of having the number of retries hard-coded in the various
functions we should be using a default retry value, which can
be modified via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Stefan Weinhuber <wein@de.ibm.com>
Signed-off-by: Martin Schwidefsky <schwidefsky@de.ibm.com>
---
 drivers/s390/block/dasd_devmap.c |   41 ++++++++++++++++++++++++++++++++++++++
 drivers/s390/block/dasd_diag.c   |    3 ++-
 drivers/s390/block/dasd_eckd.c   |   11 ++++++----
 drivers/s390/block/dasd_fba.c    |    5 ++++-
 drivers/s390/block/dasd_int.h    |    3 +++
 5 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index a71bb8a..bc3e7af 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -1240,6 +1240,46 @@ dasd_expires_store(struct device *dev, struct device_attribute *attr,
 
 static DEVICE_ATTR(expires, 0644, dasd_expires_show, dasd_expires_store);
 
+static ssize_t
+dasd_retries_show(struct device *dev, struct device_attribute *attr, char *buf)
+{
+	struct dasd_device *device;
+	int len;
+
+	device = dasd_device_from_cdev(to_ccwdev(dev));
+	if (IS_ERR(device))
+		return -ENODEV;
+	len = snprintf(buf, PAGE_SIZE, "%lu\n", device->default_retries);
+	dasd_put_device(device);
+	return len;
+}
+
+static ssize_t
+dasd_retries_store(struct device *dev, struct device_attribute *attr,
+		   const char *buf, size_t count)
+{
+	struct dasd_device *device;
+	unsigned long val;
+
+	device = dasd_device_from_cdev(to_ccwdev(dev));
+	if (IS_ERR(device))
+		return -ENODEV;
+
+	if ((strict_strtoul(buf, 10, &val) != 0) ||
+	    (val > DASD_RETRIES_MAX)) {
+		dasd_put_device(device);
+		return -EINVAL;
+	}
+
+	if (val)
+		device->default_retries = val;
+
+	dasd_put_device(device);
+	return count;
+}
+
+static DEVICE_ATTR(retries, 0644, dasd_retries_show, dasd_retries_store);
+
 static ssize_t dasd_reservation_policy_show(struct device *dev,
 					    struct device_attribute *attr,
 					    char *buf)
@@ -1350,6 +1390,7 @@ static struct attribute * dasd_attrs[] = {
 	&dev_attr_erplog.attr,
 	&dev_attr_failfast.attr,
 	&dev_attr_expires.attr,
+	&dev_attr_retries.attr,
 	&dev_attr_reservation_policy.attr,
 	&dev_attr_last_known_reservation_state.attr,
 	&dev_attr_safe_offline.attr,
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index cc06033..1548422 100644
--- a/drivers/s390/block/dasd_diag.c
+++ b/drivers/s390/block/dasd_diag.c
@@ -359,6 +359,7 @@ dasd_diag_check_device(struct dasd_device *device)
 	}
 
 	device->default_expires = DIAG_TIMEOUT;
+	device->default_retries = DIAG_MAX_RETRIES;
 
 	/* Figure out position of label block */
 	switch (private->rdc_data.vdev_class) {
@@ -555,7 +556,7 @@ static struct dasd_ccw_req *dasd_diag_build_cp(struct dasd_device *memdev,
 			recid++;
 		}
 	}
-	cqr->retries = DIAG_MAX_RETRIES;
+	cqr->retries = memdev->default_retries;
 	cqr->buildclk = get_tod_clock();
 	if (blk_noretry_request(req) ||
 	    block->base->features & DASD_FEATURE_FAILFAST)
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index 6a44b27..f4315dc 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1682,6 +1682,9 @@ dasd_eckd_check_characteristics(struct dasd_device *device)
 
 	/* set default timeout */
 	device->default_expires = DASD_EXPIRES;
+	/* set default retry count */
+	device->default_retries = DASD_RETRIES;
+
 	if (private->gneq) {
 		value = 1;
 		for (i = 0; i < private->gneq->timeout.value; i++)
@@ -2659,7 +2662,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;	/* default 5 minutes */
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_tod_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
@@ -2834,7 +2837,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_track(
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;	/* default 5 minutes */
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_tod_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
@@ -3127,7 +3130,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;	/* default 5 minutes */
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_tod_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
@@ -3330,7 +3333,7 @@ static struct dasd_ccw_req *dasd_raw_build_cp(struct dasd_device *startdev,
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_tod_clock();
 	cqr->status = DASD_CQR_FILLED;
 
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 4dd0e2f..d232c83 100644
--- a/drivers/s390/block/dasd_fba.c
+++ b/drivers/s390/block/dasd_fba.c
@@ -29,6 +29,8 @@
 #endif				/* PRINTK_HEADER */
 #define PRINTK_HEADER "dasd(fba):"
 
+#define FBA_DEFAULT_RETRIES 32
+
 #define DASD_FBA_CCW_WRITE 0x41
 #define DASD_FBA_CCW_READ 0x42
 #define DASD_FBA_CCW_LOCATE 0x43
@@ -167,6 +169,7 @@ dasd_fba_check_characteristics(struct dasd_device *device)
 	}
 
 	device->default_expires = DASD_EXPIRES;
+	device->default_retries = FBA_DEFAULT_RETRIES;
 	device->path_data.opm = LPM_ANYPATH;
 
 	readonly = dasd_device_is_ro(device);
@@ -369,7 +372,7 @@ static struct dasd_ccw_req *dasd_fba_build_cp(struct dasd_device * memdev,
 	cqr->memdev = memdev;
 	cqr->block = block;
 	cqr->expires = memdev->default_expires * HZ;	/* default 5 minutes */
-	cqr->retries = 32;
+	cqr->retries = memdev->default_retries;
 	cqr->buildclk = get_tod_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 0785bd9..ad42075 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -224,6 +224,8 @@ struct dasd_ccw_req {
 /* default expiration time*/
 #define DASD_EXPIRES	  300
 #define DASD_EXPIRES_MAX  40000000
+#define DASD_RETRIES	  256
+#define DASD_RETRIES_MAX  32768
 
 /* per dasd_ccw_req flags */
 #define DASD_CQR_FLAGS_USE_ERP   0	/* use ERP for this request */
@@ -466,6 +468,7 @@ struct dasd_device {
 
 	/* default expiration time in s */
 	unsigned long default_expires;
+	unsigned long default_retries;
 
 	struct dentry *debugfs_dentry;
 	struct dasd_profile profile;
-- 
1.7.9.5

