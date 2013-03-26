Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755479Ab3CZWol (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 18:44:41 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52723 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753571Ab3CZWof (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:44:35 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 85/98] USB: EHCI: fix regression during bus resume
Date: Tue, 26 Mar 2013 15:43:14 -0700
Message-Id: <20130326224251.302220133@linuxfoundation.org>
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

commit 2a40f324541ee61c22146214349c2ce9f5c30bcf upstream.

This patch (as1663) fixes a regression caused by commit
6e0c3339a6f19d748f16091d0a05adeb1e1f822b (USB: EHCI: unlink one async
QH at a time).  In order to avoid keeping multiple QHs in an unusable
intermediate state, that commit changed unlink_empty_async() so that
it unlinks only one empty QH at a time.

However, when the EHCI root hub is suspended, _all_ async QHs need to
be unlinked.  ehci_bus_suspend() used to do this by calling
unlink_empty_async(), but now this only unlinks one of the QHs, not
all of them.

The symptom is that when the root hub is resumed, USB communications
don't work for some period of time.  This is because ehci-hcd doesn't
realize it needs to restart the async schedule; it assumes that
because some QHs are already on the schedule, the schedule must be
running.

The easiest way to fix the problem is add a new function that unlinks
all the async QHs when the root hub is suspended.

This patch should be applied to all kernels that have the 6e0c3339a6f1
commit.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Adrian Bassett <adrian.bassett@hotmail.co.uk>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-hcd.c |    1 +
 drivers/usb/host/ehci-hub.c |    2 +-
 drivers/usb/host/ehci-q.c   |   13 +++++++++++++
 3 files changed, 15 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/ehci-hcd.c
+++ b/drivers/usb/host/ehci-hcd.c
@@ -302,6 +302,7 @@ static void ehci_quiesce (struct ehci_hc
 
 static void end_unlink_async(struct ehci_hcd *ehci);
 static void unlink_empty_async(struct ehci_hcd *ehci);
+static void unlink_empty_async_suspended(struct ehci_hcd *ehci);
 static void ehci_work(struct ehci_hcd *ehci);
 static void start_unlink_intr(struct ehci_hcd *ehci, struct ehci_qh *qh);
 static void end_unlink_intr(struct ehci_hcd *ehci, struct ehci_qh *qh);
--- a/drivers/usb/host/ehci-hub.c
+++ b/drivers/usb/host/ehci-hub.c
@@ -328,7 +328,7 @@ static int ehci_bus_suspend (struct usb_
 	ehci->rh_state = EHCI_RH_SUSPENDED;
 
 	end_unlink_async(ehci);
-	unlink_empty_async(ehci);
+	unlink_empty_async_suspended(ehci);
 	ehci_handle_intr_unlinks(ehci);
 	end_free_itds(ehci);
 
--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -1316,6 +1316,19 @@ static void unlink_empty_async(struct eh
 	}
 }
 
+/* The root hub is suspended; unlink all the async QHs */
+static void unlink_empty_async_suspended(struct ehci_hcd *ehci)
+{
+	struct ehci_qh		*qh;
+
+	while (ehci->async->qh_next.qh) {
+		qh = ehci->async->qh_next.qh;
+		WARN_ON(!list_empty(&qh->qtd_list));
+		single_unlink_async(ehci, qh);
+	}
+	start_iaa_cycle(ehci, false);
+}
+
 /* makes sure the async qh will become idle */
 /* caller must own ehci->lock */
 


