Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754350Ab3A3J1y (ORCPT <rfc822;w@1wt.eu>);
	Wed, 30 Jan 2013 04:27:54 -0500
Received: from cantor2.suse.de ([195.135.220.15]:37741 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751856Ab3A3J0Y (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 30 Jan 2013 04:26:24 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Heiko Carstens <heiko.carstens@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 2/9] dasd: make number of retries configurable
Date: Wed, 30 Jan 2013 10:26:12 +0100
Message-Id: <1359537979-39483-3-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359537979-39483-1-git-send-email-hare@suse.de>
References: <1359537979-39483-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Instead of having the number of retries hard-coded in the various
functions we should be using a default retry value, which can
be modified via sysfs.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 drivers/s390/block/dasd_devmap.c |   41 ++++++++++++++++++++++++++++++++++++++
 drivers/s390/block/dasd_diag.c   |    3 +-
 drivers/s390/block/dasd_eckd.c   |   11 ++++++---
 drivers/s390/block/dasd_fba.c    |    5 +++-
 drivers/s390/block/dasd_int.h    |    3 ++
 5 files changed, 57 insertions(+), 6 deletions(-)

diff --git a/drivers/s390/block/dasd_devmap.c b/drivers/s390/block/dasd_devmap.c
index c196827..d237e31 100644
--- a/drivers/s390/block/dasd_devmap.c
+++ b/drivers/s390/block/dasd_devmap.c
@@ -1241,6 +1241,46 @@ dasd_expires_store(struct device *dev, struct device_attribute *attr,
 
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
@@ -1351,6 +1391,7 @@ static struct attribute * dasd_attrs[] = {
 	&dev_attr_erplog.attr,
 	&dev_attr_failfast.attr,
 	&dev_attr_expires.attr,
+	&dev_attr_retries.attr,
 	&dev_attr_reservation_policy.attr,
 	&dev_attr_last_known_reservation_state.attr,
 	&dev_attr_safe_offline.attr,
diff --git a/drivers/s390/block/dasd_diag.c b/drivers/s390/block/dasd_diag.c
index 704488d..905b2c0 100644
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
 	cqr->buildclk = get_clock();
 	if (blk_noretry_request(req) ||
 	    block->base->features & DASD_FEATURE_FAILFAST)
diff --git a/drivers/s390/block/dasd_eckd.c b/drivers/s390/block/dasd_eckd.c
index e37bc16..5b5b50b 100644
--- a/drivers/s390/block/dasd_eckd.c
+++ b/drivers/s390/block/dasd_eckd.c
@@ -1679,6 +1679,9 @@ dasd_eckd_check_characteristics(struct dasd_device *device)
 
 	/* set default timeout */
 	device->default_expires = DASD_EXPIRES;
+	/* set default retry count */
+	device->default_retries = DASD_RETRIES;
+
 	if (private->gneq) {
 		value = 1;
 		for (i = 0; i < private->gneq->timeout.value; i++)
@@ -2529,7 +2532,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_single(
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;	/* default 5 minutes */
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
@@ -2704,7 +2707,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_cmd_track(
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;	/* default 5 minutes */
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
@@ -2997,7 +3000,7 @@ static struct dasd_ccw_req *dasd_eckd_build_cp_tpm_track(
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;	/* default 5 minutes */
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
@@ -3200,7 +3203,7 @@ static struct dasd_ccw_req *dasd_raw_build_cp(struct dasd_device *startdev,
 	cqr->block = block;
 	cqr->expires = startdev->default_expires * HZ;
 	cqr->lpm = startdev->path_data.ppm;
-	cqr->retries = 256;
+	cqr->retries = startdev->default_retries;
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
 
diff --git a/drivers/s390/block/dasd_fba.c b/drivers/s390/block/dasd_fba.c
index 4146985..3d8dc16 100644
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
 	cqr->buildclk = get_clock();
 	cqr->status = DASD_CQR_FILLED;
 	return cqr;
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index 899e3f5..375ba1f 100644
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
@@ -465,6 +467,7 @@ struct dasd_device {
 
 	/* default expiration time in s */
 	unsigned long default_expires;
+	unsigned long default_retries;
 
 	struct dentry *debugfs_dentry;
 	struct dasd_profile profile;
-- 
1.7.4.2

