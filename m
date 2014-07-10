Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751520AbaGJFeR (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Jul 2014 01:34:17 -0400
Received: from p3plsmtps2ded03.prod.phx3.secureserver.net ([208.109.80.60]:57819
	"EHLO p3plsmtps2ded03.prod.phx3.secureserver.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751262AbaGJFda (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 10 Jul 2014 01:33:30 -0400
x-originating-ip: 72.167.245.219
From: "K. Y. Srinivasan" <kys@microsoft.com>
To: linux-kernel@vger.kernel.org, devel@linuxdriverproject.org,
        ohering@suse.com, jbottomley@parallels.com, hch@infradead.org,
        jasowang@redhat.com, apw@canonical.com, linux-scsi@vger.kernel.org
Cc: "K. Y. Srinivasan" <kys@microsoft.com>, <stable@vger.kernel.org>
Subject: [PATCH V2 4/8] Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
Date: Wed,  9 Jul 2014 23:33:48 -0700
Message-Id: <1404974032-5023-4-git-send-email-kys@microsoft.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1404974032-5023-1-git-send-email-kys@microsoft.com>
References: <1404974008-4984-1-git-send-email-kys@microsoft.com>
 <1404974032-5023-1-git-send-email-kys@microsoft.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Based on the negotiated VMBUS protocol version, we adjust the size of the storage
protocol messages. The two sizes we currently handle are pre-win8 and post-win8.
In WS2012 R2, we are negotiating higher VMBUS protocol version than the win8
version. Make adjustments to correctly handle this.

In this version of the patch I have addressed comments from
Christoph Hellwig <hch@infradead.org>

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Cc: <stable@vger.kernel.org>
---
 drivers/scsi/storvsc_drv.c |   17 ++++++++++-------
 1 files changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 8f8847e..7e8a642 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1752,19 +1752,22 @@ static int storvsc_probe(struct hv_device *device,
 	 * set state to properly communicate with the host.
 	 */
 
-	if (vmbus_proto_version == VERSION_WIN8) {
-		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
-		vmscsi_size_delta = 0;
-		vmstor_current_major = VMSTOR_WIN8_MAJOR;
-		vmstor_current_minor = VMSTOR_WIN8_MINOR;
-	} else {
+	switch (vmbus_proto_version) {
+	case VERSION_WS2008:
+	case VERSION_WIN7:
 		sense_buffer_size = PRE_WIN8_STORVSC_SENSE_BUFFER_SIZE;
 		vmscsi_size_delta = sizeof(struct vmscsi_win8_extension);
 		vmstor_current_major = VMSTOR_WIN7_MAJOR;
 		vmstor_current_minor = VMSTOR_WIN7_MINOR;
+		break;
+	default:
+		sense_buffer_size = POST_WIN7_STORVSC_SENSE_BUFFER_SIZE;
+		vmscsi_size_delta = 0;
+		vmstor_current_major = VMSTOR_WIN8_MAJOR;
+		vmstor_current_minor = VMSTOR_WIN8_MINOR;
+		break;
 	}
 
-
 	if (dev_id->driver_data == SFC_GUID)
 		scsi_driver.can_queue = (STORVSC_MAX_IO_REQUESTS *
 					 STORVSC_FC_MAX_TARGETS);
-- 
1.7.4.1

