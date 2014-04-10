Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965526AbaDJET3 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 10 Apr 2014 00:19:29 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41037 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934679AbaDJDWF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        "Artem S. Tashkinov" <t.artem@lycos.com>,
        Christof Meerwald <cmeerw@cmeerw.org>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 046/134] USB: EHCI: bugfix: urb->hcpriv should not be NULL
Date: Wed,  9 Apr 2014 20:22:42 -0700
Message-Id: <20140410032305.996615407@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 2656a9abcf1ec8dd5fee6a75d6997a0f2fa0094e upstream.

This patch (as1632b) fixes a bug in ehci-hcd.  The USB core uses
urb->hcpriv to determine whether or not an URB is active; host
controller drivers are supposed to set this pointer to a non-NULL
value when an URB is queued.  However ehci-hcd sets it to NULL for
isochronous URBs, which defeats the check in usbcore.

In itself this isn't a big deal.  But people have recently found that
certain sequences of actions will cause the snd-usb-audio driver to
reuse URBs without waiting for them to complete.  In the absence of
proper checking by usbcore, the URBs get added to their endpoint list
twice.  This leads to list corruption and a system freeze.

The patch makes ehci-hcd assign a meaningful value to urb->hcpriv for
isochronous URBs.  Improving robustness always helps.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-by: Artem S. Tashkinov <t.artem@lycos.com>
Reported-by: Christof Meerwald <cmeerw@cmeerw.org>
[bwh: Backported to 3.2:
 - Adjust context
 - Also use usb_pipetype() to work out whether we should call qh_put()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/host/ehci-q.c     |   16 ++++++----------
 drivers/usb/host/ehci-sched.c |    4 ++--
 2 files changed, 8 insertions(+), 12 deletions(-)

--- a/drivers/usb/host/ehci-q.c
+++ b/drivers/usb/host/ehci-q.c
@@ -264,18 +264,14 @@ ehci_urb_done(struct ehci_hcd *ehci, str
 __releases(ehci->lock)
 __acquires(ehci->lock)
 {
-	if (likely (urb->hcpriv != NULL)) {
-		struct ehci_qh	*qh = (struct ehci_qh *) urb->hcpriv;
-
-		/* S-mask in a QH means it's an interrupt urb */
-		if ((qh->hw->hw_info2 & cpu_to_hc32(ehci, QH_SMASK)) != 0) {
-
-			/* ... update hc-wide periodic stats (for usbfs) */
-			ehci_to_hcd(ehci)->self.bandwidth_int_reqs--;
-		}
-		qh_put (qh);
+	if (usb_pipetype(urb->pipe) == PIPE_INTERRUPT) {
+		/* ... update hc-wide periodic stats */
+		ehci_to_hcd(ehci)->self.bandwidth_int_reqs--;
 	}
 
+	if (usb_pipetype(urb->pipe) != PIPE_ISOCHRONOUS)
+		qh_put((struct ehci_qh *) urb->hcpriv);
+
 	if (unlikely(urb->unlinked)) {
 		COUNT(ehci->stats.unlink);
 	} else {
--- a/drivers/usb/host/ehci-sched.c
+++ b/drivers/usb/host/ehci-sched.c
@@ -1684,7 +1684,7 @@ itd_link_urb (
 
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, iso_sched);
-	urb->hcpriv = NULL;
+	urb->hcpriv = stream;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
 	return enable_periodic(ehci);
@@ -2094,7 +2094,7 @@ sitd_link_urb (
 
 	/* don't need that schedule data any more */
 	iso_sched_free (stream, sched);
-	urb->hcpriv = NULL;
+	urb->hcpriv = stream;
 
 	timer_action (ehci, TIMER_IO_WATCHDOG);
 	return enable_periodic(ehci);


