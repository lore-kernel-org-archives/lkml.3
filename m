Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754470Ab3CZXvY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:51:24 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52350 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754114Ab3CZWne (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:43:34 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>, Stephen Thirlwall <sdt@dr.com>
Subject: [ 01/98] USB: EHCI: work around silicon bug in Intels EHCI controllers
Date: Tue, 26 Mar 2013 15:41:50 -0700
Message-Id: <20130326224242.606311299@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224242.449070940@linuxfoundation.org>
References: <20130326224242.449070940@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 6402c796d3b4205d3d7296157956c5100a05d7d6 upstream.

This patch (as1660) works around a hardware problem present in some
(if not all) Intel EHCI controllers.  After a QH has been unlinked
from the async schedule and the corresponding IAA interrupt has
occurred, the controller is not supposed access the QH and its qTDs.
There certainly shouldn't be any more DMA writes to those structures.
Nevertheless, Intel's controllers have been observed to perform a
final writeback to the QH's overlay region and to the most recent qTD.
For more information and a test program to determine whether this
problem is present in a particular controller, see

	http://marc.info/?l=linux-usb&m=135492071812265&w=2
	http://marc.info/?l=linux-usb&m=136182570800963&w=2

This patch works around the problem by always waiting for two IAA
cycles when unlinking an async QH.  The extra IAA delay gives the
controller time to perform its final writeback.

Surprisingly enough, the effects of this silicon bug have gone
undetected until quite recently.  More through luck than anything
else, it hasn't caused any apparent problems.  However, it does
interact badly with the path that follows this one, so it needs to be
addressed.

This is the first part of a fix for the regression reported at:

	https://bugs.launchpad.net/bugs/1088733

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Tested-by: Stephen Thirlwall <sdt@dr.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hcd.c |    6 ++----
 drivers/usb/host/ehci-q.c   |   18 ++++++++++++++----
 2 files changed, 16 insertions(+), 8 deletions(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -748,11 +748,9 @@ static irqreturn_t ehci_irq (struct usb_
 		/* guard against (alleged) silicon errata */
 		if (cmd & CMD_IAAD)
 			ehci_dbg(ehci, "IAA with IAAD still set?\n");
-		if (ehci->async_iaa) {
+		if (ehci->async_iaa)
 			COUNT(ehci->stats.iaa);
-			end_unlink_async(ehci);
-		} else
-			ehci_dbg(ehci, "IAA with nothing unlinked?\n");
+		end_unlink_async(ehci);
 	}
 
 	/* remote wakeup [4.3.1] */
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1178,7 +1178,7 @@ static void single_unlink_async(struct e
 	struct ehci_qh		*prev;
 
 	/* Add to the end of the list of QHs waiting for the next IAAD */
-	qh->qh_state = QH_STATE_UNLINK;
+	qh->qh_state = QH_STATE_UNLINK_WAIT;
 	if (ehci->async_unlink)
 		ehci->async_unlink_last->unlink_next = qh;
 	else
@@ -1221,9 +1221,19 @@ static void start_iaa_cycle(struct ehci_
 
 		/* Do only the first waiting QH (nVidia bug?) */
 		qh = ehci->async_unlink;
-		ehci->async_iaa = qh;
-		ehci->async_unlink = qh->unlink_next;
-		qh->unlink_next = NULL;
+
+		/*
+		 * Intel (?) bug: The HC can write back the overlay region
+		 * even after the IAA interrupt occurs.  In self-defense,
+		 * always go through two IAA cycles for each QH.
+		 */
+		if (qh->qh_state == QH_STATE_UNLINK_WAIT) {
+			qh->qh_state = QH_STATE_UNLINK;
+		} else {
+			ehci->async_iaa = qh;
+			ehci->async_unlink = qh->unlink_next;
+			qh->unlink_next = NULL;
+		}
 
 		/* Make sure the unlinks are all visible to the hardware */
 		wmb();


