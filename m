Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932287AbaICJ5p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:57:45 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57427 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S932267AbaICJ5n (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:57:43 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 14/56] USB: OHCI: fix bugs in debug routines
Date: Wed,  3 Sep 2014 11:26:33 +0200
Message-Id: <85bce5bb61611d5e4df489fe33663926544d4d2d.1409735865.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
References: <b4839e6cd4a236a81725e422b2e05c26fe36048a.1409735865.git.jslaby@suse.cz>
In-Reply-To: <cover.1409735865.git.jslaby@suse.cz>
References: <cover.1409735865.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Alan Stern <stern@rowland.harvard.edu>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 256dbcd80f1ccf8abf421c1d72ba79a4e29941dd upstream.

The debug routine fill_async_buffer() in ohci-hcd is buggy: It never
produces any output because it forgets to initialize the output buffer
size.  Also, the debug routine ohci_dump() has an unused argument.

This patch adds the correct initialization and removes the unused
argument.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ohci-dbg.c |  9 +++++----
 drivers/usb/host/ohci-hcd.c | 10 +++++-----
 2 files changed, 10 insertions(+), 9 deletions(-)

diff --git a/drivers/usb/host/ohci-dbg.c b/drivers/usb/host/ohci-dbg.c
index 31b81f9eacdc..4a9238563409 100644
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
index 604cad1bcf9c..3770fcb55e28 100644
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
2.1.0

