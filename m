Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759590AbaIOWwu (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:52:50 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51002 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754881AbaIOWRI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:08 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 082/187] USB: OHCI: fix bugs in debug routines
Date: Mon, 15 Sep 2014 15:08:12 -0700
Message-Id: <1410818997-9432-83-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1410818997-9432-1-git-send-email-kamal@canonical.com>
References: <1410818997-9432-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.7 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 256dbcd80f1ccf8abf421c1d72ba79a4e29941dd upstream.

The debug routine fill_async_buffer() in ohci-hcd is buggy: It never
produces any output because it forgets to initialize the output buffer
size.  Also, the debug routine ohci_dump() has an unused argument.

This patch adds the correct initialization and removes the unused
argument.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ohci-dbg.c |  9 +++++----
 drivers/usb/host/ohci-hcd.c | 10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 3fca52e..39e404e 100644
--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -289,7 +289,7 @@ ohci_dump_roothub (
 	}
 }
 
-static void ohci_dump (struct ohci_hcd *controller, int verbose)
+static void ohci_dump(struct ohci_hcd *controller)
 {
 	ohci_dbg (controller, "OHCI controller state\n");
 
@@ -531,15 +531,16 @@ show_list (struct ohci_hcd *ohci, char *buf, size_t count, struct ed *ed)
 static ssize_t fill_async_buffer(struct debug_buffer *buf)
 {
 	struct ohci_hcd		*ohci;
-	size_t			temp;
+	size_t			temp, size;
 	unsigned long		flags;
 
 	ohci = buf->ohci;
+	size = PAGE_SIZE;
 
 	/* display control and bulk lists together, for simplicity */
 	spin_lock_irqsave (&ohci->lock, flags);
-	temp = show_list(ohci, buf->page, buf->count, ohci->ed_controltail);
-	temp += show_list(ohci, buf->page + temp, buf->count - temp,
+	temp = show_list(ohci, buf->page, size, ohci->ed_controltail);
+	temp += show_list(ohci, buf->page + temp, size - temp,
 			  ohci->ed_bulktail);
 	spin_unlock_irqrestore (&ohci->lock, flags);
 
diff --git a/drivers/usb/host/ohci-hcd.c b/drivers/usb/host/ohci-hcd.c
index 8ada13f..b32fd8b 100644
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -78,8 +78,8 @@ static const char	hcd_name [] = "ohci_hcd";
 #include "ohci.h"
 #include "pci-quirks.h"
 
-static void ohci_dump (struct ohci_hcd *ohci, int verbose);
-static void ohci_stop (struct usb_hcd *hcd);
+static void ohci_dump(struct ohci_hcd *ohci);
+static void ohci_stop(struct usb_hcd *hcd);
 
 #include "ohci-hub.c"
 #include "ohci-dbg.c"
@@ -754,7 +754,7 @@ retry:
 		ohci->ed_to_check = NULL;
 	}
 
-	ohci_dump (ohci, 1);
+	ohci_dump(ohci);
 
 	return 0;
 }
@@ -835,7 +835,7 @@ static irqreturn_t ohci_irq (struct usb_hcd *hcd)
 			usb_hc_died(hcd);
 		}
 
-		ohci_dump (ohci, 1);
+		ohci_dump(ohci);
 		ohci_usb_reset (ohci);
 	}
 
@@ -935,7 +935,7 @@ static void ohci_stop (struct usb_hcd *hcd)
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 
-	ohci_dump (ohci, 1);
+	ohci_dump(ohci);
 
 	if (quirk_nec(ohci))
 		flush_work(&ohci->nec_work);
-- 
1.9.1

