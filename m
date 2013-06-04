Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756981Ab3FDQ6T (ORCPT <rfc822;w@1wt.eu>);
	Tue, 4 Jun 2013 12:58:19 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:48296 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754647Ab3FDQ5R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 4 Jun 2013 12:57:17 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Clemens Ladisch <clemens@ladisch.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 14/75] USB: fix latency in uhci-hcd and ohci-hcd
Date: Tue,  4 Jun 2013 09:54:58 -0700
Message-Id: <1370364959-9475-15-git-send-email-kamal@canonical.com>
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

commit e1944017839d7dfbf7329fac4bdec8b4050edf5e upstream.

Commits c44b225077bb1fb25ed5cd5c4f226897b91bedd4 (UHCI: implement new
semantics for URB_ISO_ASAP) and
6a41b4d3fe8cd4cc95181516fc6fba7b1747a27c (OHCI: implement new
semantics for URB_ISO_ASAP) increased the latency for isochronous URBs
in uhci-hcd and ohci-hcd respectively to 2 milliseconds, in an
attempt to avoid underruns.  It turns out that not only was this
unnecessary -- 1-ms latency works okay -- it also causes problems with
certain application loads such as real-time audio.

This patch changes the latency for both drivers back to 1 ms.

This should be applied to -stable kernels going back to 3.8.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Joe Rayhawk <jrayhawk@fairlystable.org>
CC: Clemens Ladisch <clemens@ladisch.de>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ohci-hcd.c | 2 +-
 drivers/usb/host/uhci-q.c   | 2 +-
 2 files changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 180a2b0..4b6d1c8 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -233,7 +233,7 @@ static int ohci_urb_enqueue (
 			urb->start_frame = frame;
 		}
 	} else if (ed->type == PIPE_ISOCHRONOUS) {
-		u16	next = ohci_frame_no(ohci) + 2;
+		u16	next = ohci_frame_no(ohci) + 1;
 		u16	frame = ed->last_iso + ed->interval;
 
 		/* Behind the scheduling threshold? */
diff --git a/drivers/usb/host/uhci-q.c b/drivers/usb/host/uhci-q.c
index 15921fd..3b08519 100644
--- a/drivers/usb/host/uhci-q.c
+++ b/drivers/usb/host/uhci-q.c
@@ -1287,7 +1287,7 @@ static int uhci_submit_isochronous(struct uhci_hcd *uhci, struct urb *urb,
 		return -EINVAL;		/* Can't change the period */
 
 	} else {
-		next = uhci->frame_number + 2;
+		next = uhci->frame_number + 1;
 
 		/* Find the next unused frame */
 		if (list_empty(&qh->queue)) {
-- 
1.8.1.2

