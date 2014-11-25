Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756185AbaKYMFU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 25 Nov 2014 07:05:20 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58038 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752562AbaKYKkZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 25 Nov 2014 05:40:25 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.16.y-ckt 017/254] usb-storage: handle a skipped data phase
Date: Tue, 25 Nov 2014 10:36:07 +0000
Message-Id: <1416912004-5928-18-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
References: <1416912004-5928-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.16
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.16.7-ckt2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 93c9bf4d1838d5851a18ca398b0ad66397f05056 upstream.

Sometimes mass-storage devices using the Bulk-only transport will
mistakenly skip the data phase of a command.  Rather than sending the
data expected by the host or sending a zero-length packet, they go
directly to the status phase and send the CSW.

This causes problems for usb-storage, for obvious reasons.  The driver
will interpret the CSW as a short data transfer and will wait to
receive a CSW.  The device won't have anything left to send, so the
command eventually times out.

The SCSI layer doesn't retry commands after they time out (this is a
relatively recent change).  Therefore we should do our best to detect
a skipped data phase and handle it promptly.

This patch adds code to do that.  If usb-storage receives a short
13-byte data transfer from the device, and if the first four bytes of
the data match the CSW signature, the driver will set the residue to
the full transfer length and interpret the data as a CSW.

This fixes Bugzilla #86611.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
CC: Matthew Dharm <mdharm-usb@one-eyed-alien.net>
Tested-by: Paul Osmialowski <newchief@king.net.pl>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/storage/transport.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index 22c7d4360fa2..b1d815eb6d0b 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1118,6 +1118,31 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 		 */
 		if (result == USB_STOR_XFER_LONG)
 			fake_sense = 1;
+
+		/*
+		 * Sometimes a device will mistakenly skip the data phase
+		 * and go directly to the status phase without sending a
+		 * zero-length packet.  If we get a 13-byte response here,
+		 * check whether it really is a CSW.
+		 */
+		if (result == USB_STOR_XFER_SHORT &&
+				srb->sc_data_direction == DMA_FROM_DEVICE &&
+				transfer_length - scsi_get_resid(srb) ==
+					US_BULK_CS_WRAP_LEN) {
+			struct scatterlist *sg = NULL;
+			unsigned int offset = 0;
+
+			if (usb_stor_access_xfer_buf((unsigned char *) bcs,
+					US_BULK_CS_WRAP_LEN, srb, &sg,
+					&offset, FROM_XFER_BUF) ==
+						US_BULK_CS_WRAP_LEN &&
+					bcs->Signature ==
+						cpu_to_le32(US_BULK_CS_SIGN)) {
+				usb_stor_dbg(us, "Device skipped data phase\n");
+				scsi_set_resid(srb, transfer_length);
+				goto skipped_data_phase;
+			}
+		}
 	}
 
 	/* See flow chart on pg 15 of the Bulk Only Transport spec for
@@ -1153,6 +1178,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
+ skipped_data_phase:
 	/* check bulk status */
 	residue = le32_to_cpu(bcs->Residue);
 	usb_stor_dbg(us, "Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
-- 
2.1.0

