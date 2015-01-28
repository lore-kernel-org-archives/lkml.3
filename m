Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965286AbbA1Ekk (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:40:40 -0500
Received: from mail.kernel.org ([198.145.29.136]:40667 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S965108AbbA1EYX (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:24:23 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 129/177] usb-storage: handle a skipped data phase
Date: Wed, 28 Jan 2015 12:09:47 +0800
Message-Id: <1422418236-12852-220-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
[lizf: Backported to 3.4: change usb_stor_dbg() to US_DEBUGP()]
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/storage/transport.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

diff --git a/drivers/usb/storage/transport.c b/drivers/usb/storage/transport.c
index c70109e..d8d26f4 100644
--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1120,6 +1120,31 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
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
+				US_DEBUGP("Device skipped data phase\n");
+				scsi_set_resid(srb, transfer_length);
+				goto skipped_data_phase;
+			}
+		}
 	}
 
 	/* See flow chart on pg 15 of the Bulk Only Transport spec for
@@ -1155,6 +1180,7 @@ int usb_stor_Bulk_transport(struct scsi_cmnd *srb, struct us_data *us)
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
+ skipped_data_phase:
 	/* check bulk status */
 	residue = le32_to_cpu(bcs->Residue);
 	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",
-- 
1.9.1

