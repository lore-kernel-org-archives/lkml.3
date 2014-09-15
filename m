Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932309AbaIOWLo (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:11:44 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:50582 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932246AbaIOWLk (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:11:40 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, Christoph Hellwig <hch@lst.de>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 095/187] Drivers: scsi: storvsc: Change the limits to reflect the values on the host
Date: Mon, 15 Sep 2014 15:08:25 -0700
Message-Id: <1410818997-9432-96-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 4cd83ecdac20d30725b4f96e5d7814a1e290bc7e upstream.

Hyper-V hosts can support multiple targets and multiple channels and larger number of
LUNs per target. Update the code to reflect this. With this patch we can correctly
enumerate all the paths in a multi-path storage environment.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/scsi/storvsc_drv.c | 47 ++++++++++++++++++++++++++++++----------------
 1 file changed, 31 insertions(+), 16 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 9969fa1..8938b13 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -330,17 +330,17 @@ static int storvsc_timeout = 180;
 
 static void storvsc_on_channel_callback(void *context);
 
-/*
- * In Hyper-V, each port/path/target maps to 1 scsi host adapter.  In
- * reality, the path/target is not used (ie always set to 0) so our
- * scsi host adapter essentially has 1 bus with 1 target that contains
- * up to 256 luns.
- */
-#define STORVSC_MAX_LUNS_PER_TARGET			64
-#define STORVSC_MAX_TARGETS				1
-#define STORVSC_MAX_CHANNELS				1
+#define STORVSC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_MAX_TARGETS				2
+#define STORVSC_MAX_CHANNELS				8
 
+#define STORVSC_FC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_FC_MAX_TARGETS				128
+#define STORVSC_FC_MAX_CHANNELS				8
 
+#define STORVSC_IDE_MAX_LUNS_PER_TARGET			64
+#define STORVSC_IDE_MAX_TARGETS				1
+#define STORVSC_IDE_MAX_CHANNELS			1
 
 struct storvsc_cmd_request {
 	struct list_head entry;
@@ -1691,7 +1691,6 @@ static struct scsi_host_template scsi_driver = {
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		1,
-	/* 64 max_queue * 1 target */
 	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
 	.this_id =		-1,
 	/* no use setting to 0 since ll_blk_rw reset it to 1 */
@@ -1756,6 +1755,9 @@ static int storvsc_probe(struct hv_device *device,
 	}
 
 
+	if (dev_id->driver_data == SFC_GUID)
+		scsi_driver.can_queue = (STORVSC_MAX_IO_REQUESTS *
+					 STORVSC_FC_MAX_TARGETS);
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
@@ -1789,12 +1791,25 @@ static int storvsc_probe(struct hv_device *device,
 	host_dev->path = stor_device->path_id;
 	host_dev->target = stor_device->target_id;
 
-	/* max # of devices per target */
-	host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
-	/* max # of targets per channel */
-	host->max_id = STORVSC_MAX_TARGETS;
-	/* max # of channels */
-	host->max_channel = STORVSC_MAX_CHANNELS - 1;
+	switch (dev_id->driver_data) {
+	case SFC_GUID:
+		host->max_lun = STORVSC_FC_MAX_LUNS_PER_TARGET;
+		host->max_id = STORVSC_FC_MAX_TARGETS;
+		host->max_channel = STORVSC_FC_MAX_CHANNELS - 1;
+		break;
+
+	case SCSI_GUID:
+		host->max_lun = STORVSC_MAX_LUNS_PER_TARGET;
+		host->max_id = STORVSC_MAX_TARGETS;
+		host->max_channel = STORVSC_MAX_CHANNELS - 1;
+		break;
+
+	default:
+		host->max_lun = STORVSC_IDE_MAX_LUNS_PER_TARGET;
+		host->max_id = STORVSC_IDE_MAX_TARGETS;
+		host->max_channel = STORVSC_IDE_MAX_CHANNELS - 1;
+		break;
+	}
 	/* max cmd length */
 	host->max_cmd_len = STORVSC_MAX_CMD_LEN;
 
-- 
1.9.1

