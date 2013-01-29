Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753372Ab3A2HN1 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 29 Jan 2013 02:13:27 -0500
Received: from cantor2.suse.de ([195.135.220.15]:40540 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752532Ab3A2HMG (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 29 Jan 2013 02:12:06 -0500
From: Hannes Reinecke <hare@suse.de>
To: Martin Schwidefsky <schwidefsky@de.ibm.com>
Cc: linux-kernel@vger.kernel.org, Stefan Weinhuber <wein@de.ibm.com>,
        Hannes Reinecke <hare@suse.de>
Subject: [PATCH 9/9] dasd: Fail all requests when DASD_FLAG_ABORTIO is set
Date: Tue, 29 Jan 2013 08:12:01 +0100
Message-Id: <1359443521-24670-10-git-send-email-hare@suse.de>
X-Mailer: git-send-email 1.7.4.2
In-Reply-To: <1359443521-24670-1-git-send-email-hare@suse.de>
References: <1359443521-24670-1-git-send-email-hare@suse.de>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Whenever a DASD request encounters a timeout we might
need to abort all outstanding requests on this or
even other devices.

This is especially useful if one wants to fail all
devices on one side of a RAID10 configuration, even
though only one device exhibited an error.

To handle this I've introduced a new device flag
DASD_FLAG_ABORTIO.
This flag is evaluated in __dasd_process_request_queue()
and will invoke blk_abort_request() for all
outstanding requests with DASD_CQR_FLAGS_FAILFAST set.
This will cause any of these requests to be aborted
immediately if the blk_timeout function is activated.

The DASD_FLAG_ABORTIO is also evaluated in
__dasd_process_request_queue to abort all
new request which would have the
DASD_CQR_FLAGS_FAILFAST bit set.

The flag can be set with the new ioctls 'BIODASDABORTIO'
and removed with 'BIODASDALLOWIO'.

Signed-off-by: Hannes Reinecke <hare@suse.de>
---
 arch/s390/include/uapi/asm/dasd.h |    4 ++
 drivers/s390/block/dasd.c         |   13 ++++++--
 drivers/s390/block/dasd_int.h     |    3 ++
 drivers/s390/block/dasd_ioctl.c   |   59 +++++++++++++++++++++++++++++++++++++
 4 files changed, 76 insertions(+), 3 deletions(-)

diff --git a/arch/s390/include/uapi/asm/dasd.h b/arch/s390/include/uapi/asm/dasd.h
index 38eca3b..a2ea496 100644
--- a/arch/s390/include/uapi/asm/dasd.h
+++ b/arch/s390/include/uapi/asm/dasd.h
@@ -261,6 +261,10 @@ struct dasd_snid_ioctl_data {
 #define BIODASDQUIESCE _IO(DASD_IOCTL_LETTER,6) 
 /* Resume IO on device */
 #define BIODASDRESUME  _IO(DASD_IOCTL_LETTER,7) 
+/* Abort all I/O on a device */
+#define BIODASDABORTIO _IO(DASD_IOCTL_LETTER,240) 
+/* Allow I/O on a device */
+#define BIODASDALLOWIO  _IO(DASD_IOCTL_LETTER,241) 
 
 
 /* retrieve API version number */
diff --git a/drivers/s390/block/dasd.c b/drivers/s390/block/dasd.c
index 61080df..9f8dbbb 100644
--- a/drivers/s390/block/dasd.c
+++ b/drivers/s390/block/dasd.c
@@ -38,9 +38,6 @@
  */
 #define DASD_CHANQ_MAX_SIZE 4
 
-#define DASD_SLEEPON_START_TAG	(void *) 1
-#define DASD_SLEEPON_END_TAG	(void *) 2
-
 /*
  * SECTION: exported variables of dasd.c
  */
@@ -2446,6 +2443,16 @@ static void __dasd_process_request_queue(struct dasd_block *block)
 			__blk_end_request_all(req, -EIO);
 			continue;
 		}
+		if (test_bit(DASD_FLAG_ABORTALL, &basedev->flags) &&
+		    (basedev->features & DASD_FEATURE_FAILFAST ||
+		     blk_noretry_request(req))) {
+			DBF_DEV_EVENT(DBF_ERR, basedev,
+				      "Rejecting failfast request %p",
+				      req);
+			blk_start_request(req);
+			__blk_end_request_all(req, -ETIMEDOUT);
+			continue;
+		}
 		cqr = basedev->discipline->build_cp(basedev, block, req);
 		if (IS_ERR(cqr)) {
 			if (PTR_ERR(cqr) == -EBUSY)
diff --git a/drivers/s390/block/dasd_int.h b/drivers/s390/block/dasd_int.h
index d00d07a..a4f3050 100644
--- a/drivers/s390/block/dasd_int.h
+++ b/drivers/s390/block/dasd_int.h
@@ -523,7 +523,10 @@ struct dasd_block {
 #define DASD_FLAG_SUSPENDED	9	/* The device was suspended */
 #define DASD_FLAG_SAFE_OFFLINE	10	/* safe offline processing requested*/
 #define DASD_FLAG_SAFE_OFFLINE_RUNNING	11	/* safe offline running */
+#define DASD_FLAG_ABORTALL	12	/* Abort all noretry requests */
 
+#define DASD_SLEEPON_START_TAG	(void *) 1
+#define DASD_SLEEPON_END_TAG	(void *) 2
 
 void dasd_put_device_wake(struct dasd_device *);
 
diff --git a/drivers/s390/block/dasd_ioctl.c b/drivers/s390/block/dasd_ioctl.c
index 03c0e04..d59bdb6 100644
--- a/drivers/s390/block/dasd_ioctl.c
+++ b/drivers/s390/block/dasd_ioctl.c
@@ -141,6 +141,59 @@ static int dasd_ioctl_resume(struct dasd_block *block)
 }
 
 /*
+ * Abort all failfast I/O on a device.
+ */
+static int dasd_ioctl_abortio(struct dasd_block *block)
+{
+	unsigned long flags;
+	struct dasd_device *base;
+	struct dasd_ccw_req *cqr, *n;
+
+	base = block->base;
+	if (!capable (CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (test_and_set_bit(DASD_FLAG_ABORTALL, &base->flags))
+		return 0;
+	DBF_DEV_EVENT(DBF_NOTICE, base, "%s", "abortall flag set");
+
+	spin_lock_irqsave(&block->request_queue_lock, flags);
+	spin_lock(&block->queue_lock);
+	list_for_each_entry_safe(cqr, n, &block->ccw_queue, blocklist) {
+		if (test_bit(DASD_CQR_FLAGS_FAILFAST, &cqr->flags) &&
+		    cqr->callback_data &&
+		    cqr->callback_data != DASD_SLEEPON_START_TAG &&
+		    cqr->callback_data != DASD_SLEEPON_END_TAG ) {
+			spin_unlock(&block->queue_lock);
+			blk_abort_request(cqr->callback_data);
+			spin_lock(&block->queue_lock);
+		}
+	}
+	spin_unlock(&block->queue_lock);
+	spin_unlock_irqrestore(&block->request_queue_lock, flags);
+
+	dasd_schedule_block_bh(block);
+	return 0;
+}
+
+/*
+ * Allow I/O on a device
+ */
+static int dasd_ioctl_allowio(struct dasd_block *block)
+{
+	struct dasd_device *base;
+
+	base = block->base;
+	if (!capable (CAP_SYS_ADMIN))
+		return -EACCES;
+
+	if (test_and_clear_bit(DASD_FLAG_ABORTALL, &base->flags))
+		DBF_DEV_EVENT(DBF_NOTICE, base, "%s", "abortall flag unset");
+
+	return 0;
+}
+
+/*
  * performs formatting of _device_ according to _fdata_
  * Note: The discipline's format_function is assumed to deliver formatting
  * commands to format a single unit of the device. In terms of the ECKD
@@ -469,6 +522,12 @@ int dasd_ioctl(struct block_device *bdev, fmode_t mode,
 	case BIODASDRESUME:
 		rc = dasd_ioctl_resume(block);
 		break;
+	case BIODASDABORTIO:
+		rc = dasd_ioctl_abortio(block);
+		break;
+	case BIODASDALLOWIO:
+		rc = dasd_ioctl_allowio(block);
+		break;
 	case BIODASDFMT:
 		rc = dasd_ioctl_format(bdev, argp);
 		break;
-- 
1.7.4.2

