Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759160AbaIOVJk (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 17:09:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:54620 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754927AbaIOT0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 15:26:55 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        "K. Y. Srinivasan" <kys@microsoft.com>, Hannes Reinecke <hare@suse.de>,
        Christoph Hellwig <hch@lst.de>
Subject: [PATCH 3.16 051/158] Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
Date: Mon, 15 Sep 2014 12:24:50 -0700
Message-Id: <20140915192544.428349776@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140915192542.872134685@linuxfoundation.org>
References: <20140915192542.872134685@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16-stable review patch.  If anyone has any objections, please let me know.

------------------

From: "K. Y. Srinivasan" <kys@microsoft.com>

commit adb6f9e1a8c6af1037232b59edb11277471537ea upstream.

Based on the negotiated VMBUS protocol version, we adjust the size of the storage
protocol messages. The two sizes we currently handle are pre-win8 and post-win8.
In WS2012 R2, we are negotiating higher VMBUS protocol version than the win8
version. Make adjustments to correctly handle this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/scsi/storvsc_drv.c |   17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1764,19 +1764,22 @@ static int storvsc_probe(struct hv_devic
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


