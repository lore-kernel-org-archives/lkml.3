Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933771AbaICXfw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:35:52 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45518 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933149AbaICWIc (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:08:32 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.14 05/88] USB: OHCI: fix bugs in debug routines
Date: Wed,  3 Sep 2014 15:04:39 -0700
Message-Id: <20140903220516.119136963@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/host/ohci-dbg.c |    9 +++++----
 drivers/usb/host/ohci-hcd.c |   10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

--- a/drivers/usb/host/ohci-dbg.c
+++ b/drivers/usb/host/ohci-dbg.c
@@ -236,7 +236,7 @@ ohci_dump_roothub (
 	}
 }
 
-static void ohci_dump (struct ohci_hcd *controller, int verbose)
+static void ohci_dump(struct ohci_hcd *controller)
 {
 	ohci_dbg (controller, "OHCI controller state\n");
 
@@ -464,15 +464,16 @@ show_list (struct ohci_hcd *ohci, char *
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
 
--- a/drivers/usb/host/ohci-hcd.c
+++ b/drivers/usb/host/ohci-hcd.c
@@ -76,8 +76,8 @@ static const char	hcd_name [] = "ohci_hc
 #include "ohci.h"
 #include "pci-quirks.h"
 
-static void ohci_dump (struct ohci_hcd *ohci, int verbose);
-static void ohci_stop (struct usb_hcd *hcd);
+static void ohci_dump(struct ohci_hcd *ohci);
+static void ohci_stop(struct usb_hcd *hcd);
 
 #include "ohci-hub.c"
 #include "ohci-dbg.c"
@@ -744,7 +744,7 @@ retry:
 		ohci->ed_to_check = NULL;
 	}
 
-	ohci_dump (ohci, 1);
+	ohci_dump(ohci);
 
 	return 0;
 }
@@ -825,7 +825,7 @@ static irqreturn_t ohci_irq (struct usb_
 			usb_hc_died(hcd);
 		}
 
-		ohci_dump (ohci, 1);
+		ohci_dump(ohci);
 		ohci_usb_reset (ohci);
 	}
 
@@ -925,7 +925,7 @@ static void ohci_stop (struct usb_hcd *h
 {
 	struct ohci_hcd		*ohci = hcd_to_ohci (hcd);
 
-	ohci_dump (ohci, 1);
+	ohci_dump(ohci);
 
 	if (quirk_nec(ohci))
 		flush_work(&ohci->nec_work);


