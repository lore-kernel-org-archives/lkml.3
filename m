Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755598AbaKRORF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 18 Nov 2014 09:17:05 -0500
Received: from cantor2.suse.de ([195.135.220.15]:57207 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1755112AbaKROK1 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 18 Nov 2014 09:10:27 -0500
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Matthew Dharm <mdharm-usb@one-eyed-alien.net>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 168/206] usb-storage: handle a skipped data phase
Date: Tue, 18 Nov 2014 15:08:43 +0100
Message-Id: <2aa227341252dc88670a9814793975f1e685e74c.1416319692.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
References: <28f04bcc068a44c5641c727883947960fb8dcbd5.1416319692.git.jslaby@suse.cz>
In-Reply-To: <cover.1416319692.git.jslaby@suse.cz>
References: <cover.1416319692.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
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
2.1.3

