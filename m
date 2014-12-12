Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760673AbaLLGbo (ORCPT <rfc822;w@1wt.eu>);
	Fri, 12 Dec 2014 01:31:44 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51940 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1759335AbaLLGQ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 12 Dec 2014 01:16:58 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Paul Osmialowski" <newchief@king.net.pl>,
        "Matthew Dharm" <mdharm-usb@one-eyed-alien.net>,
        "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Fri, 12 Dec 2014 06:14:25 +0000
Message-ID: <lsq.1418364865.169825479@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 111/164] usb-storage: handle a skipped data phase
In-Reply-To: <lsq.1418364865.554543691@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:c97:8151:cc89:c28d
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.65-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: use US_DEBUGP() not usb_stor_dbg()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/storage/transport.c | 26 ++++++++++++++++++++++++++
 1 file changed, 26 insertions(+)

--- a/drivers/usb/storage/transport.c
+++ b/drivers/usb/storage/transport.c
@@ -1119,6 +1119,31 @@ int usb_stor_Bulk_transport(struct scsi_
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
@@ -1154,6 +1179,7 @@ int usb_stor_Bulk_transport(struct scsi_
 	if (result != USB_STOR_XFER_GOOD)
 		return USB_STOR_TRANSPORT_ERROR;
 
+ skipped_data_phase:
 	/* check bulk status */
 	residue = le32_to_cpu(bcs->Residue);
 	US_DEBUGP("Bulk Status S 0x%x T 0x%x R %u Stat 0x%x\n",

