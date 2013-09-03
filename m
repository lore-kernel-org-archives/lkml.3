Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756953Ab3ICQYU (ORCPT <rfc822;w@1wt.eu>);
	Tue, 3 Sep 2013 12:24:20 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:46444 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756528Ab3ICQYP (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 3 Sep 2013 12:24:15 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Clemens Ladisch <clemens@ladisch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 11/58] USB: EHCI: accept very late isochronous URBs
Date: Tue,  3 Sep 2013 09:23:15 -0700
Message-Id: <1378225442-20654-12-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1378225442-20654-1-git-send-email-kamal@canonical.com>
References: <1378225442-20654-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 24f531371de17010f2b1b57d90e42240032e7733 upstream.

Since commits 4005ad4390bf (EHCI: implement new semantics for
URB_ISO_ASAP) and c75c5ab575af (ALSA: USB: adjust for changed 3.8 USB
API) became widely distributed, people have been experiencing problems
with audio transfers.  The slightest underrun causes complete failure,
requiring the audio stream to be restarted.

It turns out that the current isochronous API doesn't handle underruns
in the best way.  The ALSA developers would much rather have transfers
that are submitted too late be accepted and complete in the normal
fashion, rather than being refused outright.

This patch implements the requested approach.  When an isochronous URB
submission is so late that all its scheduled slots have already
expired, a debugging message will be printed in the log and the URB
will be accepted as usual.  Assuming it was submitted by a completion
handler (which is normally the case), it will complete shortly
thereafter with all the usb_iso_packet_descriptor status fields marked
-EXDEV.

This fixes (for ehci-hcd)

	https://bugs.launchpad.net/ubuntu/+source/linux/+bug/1191603

It should be applied to all kernels that include commit 4005ad4390bf.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Maksim Boyko <maksboyko@yandex.ru>
CC: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ehci-sched.c | 13 ++++++-------
 1 file changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/host/ehci-sched.c b/drivers/usb/host/ehci-sched.c
index 5a00ef3..64a9c97 100644
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1394,21 +1394,20 @@ iso_stream_schedule (
 
 		/* Behind the scheduling threshold? */
 		if (unlikely(start < next)) {
+			unsigned now2 = (now - base) & (mod - 1);
 
 			/* USB_ISO_ASAP: Round up to the first available slot */
 			if (urb->transfer_flags & URB_ISO_ASAP)
 				start += (next - start + period - 1) & -period;
 
 			/*
-			 * Not ASAP: Use the next slot in the stream.  If
-			 * the entire URB falls before the threshold, fail.
+			 * Not ASAP: Use the next slot in the stream,
+			 * no matter what.
 			 */
-			else if (start + span - period < next) {
-				ehci_dbg(ehci, "iso urb late %p (%u+%u < %u)\n",
+			else if (start + span - period < now2) {
+				ehci_dbg(ehci, "iso underrun %p (%u+%u < %u)\n",
 						urb, start + base,
-						span - period, next + base);
-				status = -EXDEV;
-				goto fail;
+						span - period, now2 + base);
 			}
 		}
 
-- 
1.8.1.2

