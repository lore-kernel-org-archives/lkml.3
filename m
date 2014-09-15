Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757173AbaIOUcP (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 16:32:15 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:55109 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755671AbaIOThD (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:37:03 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.14 033/114] Drivers: scsi: storvsc: Change the limits to reflect the values on the host
Date: Mon, 15 Sep 2014 12:25:33 -0700
Message-Id: <20140915192642.481824478@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192641.428509513@linuxfoundation.org>
References: <20140915192641.428509513@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit 4cd83ecdac20d30725b4f96e5d7814a1e290bc7e upstream.

Hyper-V hosts can support multiple targets and multiple channels and larger number of
LUNs per target. Update the code to reflect this. With this patch we can correctly
enumerate all the paths in a multi-path storage environment.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |   51 +++++++++++++++++++++++++++++----------------
 1 file changed, 33 insertions(+), 18 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -331,17 +331,17 @@ static int storvsc_timeout = 180;
 
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
-
-
+#define STORVSC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_MAX_TARGETS				2
+#define STORVSC_MAX_CHANNELS				8
+
+#define STORVSC_FC_MAX_LUNS_PER_TARGET			255
+#define STORVSC_FC_MAX_TARGETS				128
+#define STORVSC_FC_MAX_CHANNELS				8
+
+#define STORVSC_IDE_MAX_LUNS_PER_TARGET			64
+#define STORVSC_IDE_MAX_TARGETS				1
+#define STORVSC_IDE_MAX_CHANNELS			1
 
 struct storvsc_cmd_request {
 	struct list_head entry;
@@ -1713,7 +1713,6 @@ static struct scsi_host_template scsi_dr
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
 	.cmd_per_lun =		1,
-	/* 64 max_queue * 1 target */
 	.can_queue =		STORVSC_MAX_IO_REQUESTS*STORVSC_MAX_TARGETS,
 	.this_id =		-1,
 	/* no use setting to 0 since ll_blk_rw reset it to 1 */
@@ -1778,6 +1777,9 @@ static int storvsc_probe(struct hv_devic
 	}
 
 
+	if (dev_id->driver_data == SFC_GUID)
+		scsi_driver.can_queue = (STORVSC_MAX_IO_REQUESTS *
+					 STORVSC_FC_MAX_TARGETS);
 	host = scsi_host_alloc(&scsi_driver,
 			       sizeof(struct hv_host_device));
 	if (!host)
@@ -1811,12 +1813,25 @@ static int storvsc_probe(struct hv_devic
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
 


