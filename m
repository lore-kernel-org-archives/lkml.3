Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751565AbaGJFeg (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:34:36 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57820
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751263AbaGJFda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:33:30 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>
Subject: [PATCH V2 6/8] Drivers: scsi: storvsc: Implement an abort handler
Date: Wed,  9 Jul 2014 23:33:50 -0700
Message-Id: <1404974032-5023-6-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404974032-5023-1-git-send-email-kys@microsoft.com>
References: <1404974008-4984-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Implement a simple abort handler. The host does not support "Abort"; just
ensure that all inflight I/Os have been accounted for.

In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
---
 drivers/scsi/storvsc_drv.c |   22 ++++++++++++++++++++++
 1 files changed, 22 insertions(+), 0 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 7b99f38..443a1c2 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1521,6 +1521,27 @@ static int storvsc_host_reset_handler(struct scsi_cmnd *scmnd)
 	return SUCCESS;
 }
 
+static int storvsc_host_abort_handler(struct scsi_cmnd *scmnd)
+{
+	struct hv_host_device *host_dev = shost_priv(scmnd->device->host);
+	struct hv_device *device = host_dev->dev;
+
+	struct storvsc_device *stor_device;
+
+
+	stor_device = get_out_stor_device(device);
+	if (!stor_device)
+		return FAILED;
+
+	/*
+	 * Just wait for all in flight I/O's to complete.
+	 */
+
+	storvsc_wait_to_drain(stor_device);
+
+	return SUCCESS;
+}
+
 static bool storvsc_scsi_cmd_ok(struct scsi_cmnd *scmnd)
 {
 	bool allowed = true;
@@ -1700,6 +1721,7 @@ static struct scsi_host_template scsi_driver = {
 	.bios_param =		storvsc_get_chs,
 	.queuecommand =		storvsc_queuecommand,
 	.eh_host_reset_handler =	storvsc_host_reset_handler,
+	.eh_abort_handler =	storvsc_host_abort_handler,
 	.slave_alloc =		storvsc_device_alloc,
 	.slave_destroy =	storvsc_device_destroy,
 	.slave_configure =	storvsc_device_configure,
-- 
1.7.4.1

