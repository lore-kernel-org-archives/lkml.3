Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758640Ab3FDROF (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 13:14:05 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48271 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756673Ab3FDQ5Q (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:16 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 15/75] USB: OHCI: fix logic for scheduling isochronous URBs
Date: Tue,  4 Jun 2013 09:54:59 -0700
Message-Id: <1370364959-9475-16-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1370364959-9475-1-git-send-email-kamal@canonical.com>
References: <1370364959-9475-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 815fa7b917614261748d1ecd9600ff27f99508e5 upstream.

The isochronous scheduling logic in ohci-hcd has a bug.  The
calculation for skipping TDs that are too late should be carried out
only in the !URB_ISO_ASAP case.  When URB_ISO_ASAP is set, the URB is
pushed back so that none of the TDs are too late, which would cause
the calculation to overflow.

The patch also fixes the calculation to avoid overflow in the case
where the frame value wraps around.

This should be applied to -stable kernels going back to 3.8.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ohci-hcd.c | 32 ++++++++++++++++++--------------
 1 file changed, 18 insertions(+), 14 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 4b6d1c8..007137f 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -240,7 +240,7 @@ static int ohci_urb_enqueue (
 		if (unlikely(tick_before(frame, next))) {
 
 			/* USB_ISO_ASAP: Round up to the first available slot */
-			if (urb->transfer_flags & URB_ISO_ASAP)
+			if (urb->transfer_flags & URB_ISO_ASAP) {
 				frame += (next - frame + ed->interval - 1) &
 						-ed->interval;
 
@@ -248,21 +248,25 @@ static int ohci_urb_enqueue (
 			 * Not ASAP: Use the next slot in the stream.  If
 			 * the entire URB falls before the threshold, fail.
 			 */
-			else if (tick_before(frame + ed->interval *
+			} else {
+				if (tick_before(frame + ed->interval *
 					(urb->number_of_packets - 1), next)) {
-				retval = -EXDEV;
-				usb_hcd_unlink_urb_from_ep(hcd, urb);
-				goto fail;
-			}
+					retval = -EXDEV;
+					usb_hcd_unlink_urb_from_ep(hcd, urb);
+					goto fail;
+				}
 
-			/*
-			 * Some OHCI hardware doesn't handle late TDs
-			 * correctly.  After retiring them it proceeds to
-			 * the next ED instead of the next TD.  Therefore
-			 * we have to omit the late TDs entirely.
-			 */
-			urb_priv->td_cnt = DIV_ROUND_UP(next - frame,
-					ed->interval);
+				/*
+				 * Some OHCI hardware doesn't handle late TDs
+				 * correctly.  After retiring them it proceeds
+				 * to the next ED instead of the next TD.
+				 * Therefore we have to omit the late TDs
+				 * entirely.
+				 */
+				urb_priv->td_cnt = DIV_ROUND_UP(
+						(u16) (next - frame),
+						ed->interval);
+			}
 		}
 		urb->start_frame = frame;
 	}
-- 
1.8.1.2

