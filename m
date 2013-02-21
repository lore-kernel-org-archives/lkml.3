Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754006Ab3BUTgV (ORCPT <rfc822;w@1wt.eu>);
	Thu, 21 Feb 2013 14:36:21 -0500
Received: from p3plsmtps2ded02.prod.phx3.secureserver.net ([208.109.80.59]:54871
	"EHLO p3plsmtps2ded02.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753054Ab3BUTgR (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 21 Feb 2013 14:36:17 -0500
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: gregkh@linuxfoundation.org, linux-kernel@vger.kernel.org,
        devel@linuxdriverproject.org, ohering@suse.com,
        jbottomley@parallels.com, hch@infradead.org,
        linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH 4/4] Drivers: scsi: storvsc: Handle dynamic resizing of the device
Date: Thu, 21 Feb 2013 12:04:53 -0800
Message-Id: <1361477093-17549-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361477093-17549-1-git-send-email-kys@microsoft.com>
References: <1361477060-17505-1-git-send-email-kys@microsoft.com>
 <1361477093-17549-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Handle LUN size changes by re-scanning the device.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Haiyang Zhang <haiyangz@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   31 +++++++++++++++++++++++++++++++
 1 files changed, 31 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 16d5aac..16a3a0c 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -201,6 +201,7 @@ enum storvsc_request_type {
 #define SRB_STATUS_AUTOSENSE_VALID	0x80
 #define SRB_STATUS_INVALID_LUN	0x20
 #define SRB_STATUS_SUCCESS	0x01
+#define SRB_STATUS_ABORTED	0x02
 #define SRB_STATUS_ERROR	0x04
 
 /*
@@ -295,6 +296,25 @@ struct storvsc_scan_work {
 	uint lun;
 };
 
+static void storvsc_device_scan(struct work_struct *work)
+{
+	struct storvsc_scan_work *wrk;
+	uint lun;
+	struct scsi_device *sdev;
+
+	wrk = container_of(work, struct storvsc_scan_work, work);
+	lun = wrk->lun;
+
+	sdev = scsi_device_lookup(wrk->host, 0, 0, lun);
+	if (!sdev)
+		goto done;
+	scsi_rescan_device(&sdev->sdev_gendev);
+	scsi_device_put(sdev);
+
+done:
+	kfree(wrk);
+}
+
 static void storvsc_bus_scan(struct work_struct *work)
 {
 	struct storvsc_scan_work *wrk;
@@ -791,7 +811,18 @@ static void storvsc_handle_error(struct vmscsi_request *vm_srb,
 		do_work = true;
 		process_err_fn = storvsc_remove_lun;
 		break;
+	case (SRB_STATUS_ABORTED | SRB_STATUS_AUTOSENSE_VALID):
+		if ((asc == 0x2a) && (ascq == 0x9)) {
+			do_work = true;
+			process_err_fn = storvsc_device_scan;
+			/*
+			 * Retry the I/O that trigerred this.
+			 */
+			set_host_byte(scmnd, DID_REQUEUE);
+		}
+		break;
 	}
+
 	if (!do_work)
 		return;
 
-- 
1.7.4.1

