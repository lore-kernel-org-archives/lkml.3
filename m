Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756849AbaIZK2B (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:28:01 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33033 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754789AbaIZJqE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:46:04 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, "K. Y. Srinivasan" <kys@microsoft.com>,
        Christoph Hellwig <hch@lst.de>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 062/142] Drivers: scsi: storvsc: Fix a bug in handling VMBUS protocol version
Date: Fri, 26 Sep 2014 11:44:33 +0200
Message-Id: <bc5bf5e8aa08c8f35c648b302b2362d06a72461e.1411724724.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: "K. Y. Srinivasan" <kys@microsoft.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit adb6f9e1a8c6af1037232b59edb11277471537ea upstream.

Based on the negotiated VMBUS protocol version, we adjust the size of the storage
protocol messages. The two sizes we currently handle are pre-win8 and post-win8.
In WS2012 R2, we are negotiating higher VMBUS protocol version than the win8
version. Make adjustments to correctly handle this.

Signed-off-by: K. Y. Srinivasan <kys@microsoft.com>
Reviewed-by: Hannes Reinecke <hare@suse.de>
Signed-off-by: Christoph Hellwig <hch@lst.de>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/scsi/storvsc_drv.c | 17 ++++++++++-------
 1 file changed, 10 insertions(+), 7 deletions(-)

diff --git a/drivers/scsi/storvsc_drv.c b/drivers/scsi/storvsc_drv.c
index 1d77edce03c2..2b8595b7ad45 100644
--- a/drivers/scsi/storvsc_drv.c
+++ b/drivers/scsi/storvsc_drv.c
@@ -1764,19 +1764,22 @@ static int storvsc_probe(struct hv_device *device,
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
2.1.0

