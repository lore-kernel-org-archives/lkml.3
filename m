Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756271AbaICJ4m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 05:56:42 -0400
Received: from ip4-83-240-67-251.cust.nbox.cz ([83.240.67.251]:57376 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-FAIL)
	by vger.kernel.org with ESMTP id S1756226AbaICJ4k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 05:56:40 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Alan Stern <stern@rowland.harvard.edu>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 15/56] USB: OHCI: don't lose track of EDs when a controller dies
Date: Wed,  3 Sep 2014 11:26:34 +0200
Message-Id: <feee60a9f84a5b8c9026c68086b212f14f1474dc.1409735865.git.jslaby@suse.cz>
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

commit 977dcfdc60311e7aa571cabf6f39c36dde13339e upstream.

This patch fixes a bug in ohci-hcd.  When an URB is unlinked, the
corresponding Endpoint Descriptor is added to the ed_rm_list and taken
off the hardware schedule.  Once the ED is no longer visible to the
hardware, finish_unlinks() handles the URBs that were unlinked or have
completed.  If any URBs remain attached to the ED, the ED is added
back to the hardware schedule -- but only if the controller is
running.

This fails when a controller dies.  A non-empty ED does not get added
back to the hardware schedule and does not remain on the ed_rm_list;
ohci-hcd loses track of it.  The remaining URBs cannot be unlinked,
which causes the USB stack to hang.

The patch changes finish_unlinks() so that non-empty EDs remain on
the ed_rm_list if the controller isn't running.  This requires moving
some of the existing code around, to avoid modifying the ED's hardware
fields more than once.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/host/ohci-q.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index e7f577e63624..4e9f6a45f4e4 100644
--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -315,8 +315,7 @@ static void periodic_unlink (struct ohci_hcd *ohci, struct ed *ed)
  *  - ED_OPER: when there's any request queued, the ED gets rescheduled
  *    immediately.  HC should be working on them.
  *
- *  - ED_IDLE:  when there's no TD queue. there's no reason for the HC
- *    to care about this ED; safe to disable the endpoint.
+ *  - ED_IDLE: when there's no TD queue or the HC isn't running.
  *
  * When finish_unlinks() runs later, after SOF interrupt, it will often
  * complete one or more URB unlinks before making that state change.
@@ -930,6 +929,10 @@ rescan_all:
 		int			completed, modified;
 		__hc32			*prev;
 
+		/* Is this ED already invisible to the hardware? */
+		if (ed->state == ED_IDLE)
+			goto ed_idle;
+
 		/* only take off EDs that the HC isn't using, accounting for
 		 * frame counter wraps and EDs with partially retired TDs
 		 */
@@ -959,12 +962,20 @@ skip_ed:
 			}
 		}
 
+		/* ED's now officially unlinked, hc doesn't see */
+		ed->state = ED_IDLE;
+		if (quirk_zfmicro(ohci) && ed->type == PIPE_INTERRUPT)
+			ohci->eds_scheduled--;
+		ed->hwHeadP &= ~cpu_to_hc32(ohci, ED_H);
+		ed->hwNextED = 0;
+		wmb();
+		ed->hwINFO &= ~cpu_to_hc32(ohci, ED_SKIP | ED_DEQUEUE);
+ed_idle:
+
 		/* reentrancy:  if we drop the schedule lock, someone might
 		 * have modified this list.  normally it's just prepending
 		 * entries (which we'd ignore), but paranoia won't hurt.
 		 */
-		*last = ed->ed_next;
-		ed->ed_next = NULL;
 		modified = 0;
 
 		/* unlink urbs as requested, but rescan the list after
@@ -1022,19 +1033,20 @@ rescan_this:
 		if (completed && !list_empty (&ed->td_list))
 			goto rescan_this;
 
-		/* ED's now officially unlinked, hc doesn't see */
-		ed->state = ED_IDLE;
-		if (quirk_zfmicro(ohci) && ed->type == PIPE_INTERRUPT)
-			ohci->eds_scheduled--;
-		ed->hwHeadP &= ~cpu_to_hc32(ohci, ED_H);
-		ed->hwNextED = 0;
-		wmb ();
-		ed->hwINFO &= ~cpu_to_hc32 (ohci, ED_SKIP | ED_DEQUEUE);
-
-		/* but if there's work queued, reschedule */
-		if (!list_empty (&ed->td_list)) {
-			if (ohci->rh_state == OHCI_RH_RUNNING)
-				ed_schedule (ohci, ed);
+		/*
+		 * If no TDs are queued, take ED off the ed_rm_list.
+		 * Otherwise, if the HC is running, reschedule.
+		 * If not, leave it on the list for further dequeues.
+		 */
+		if (list_empty(&ed->td_list)) {
+			*last = ed->ed_next;
+			ed->ed_next = NULL;
+		} else if (ohci->rh_state == OHCI_RH_RUNNING) {
+			*last = ed->ed_next;
+			ed->ed_next = NULL;
+			ed_schedule(ohci, ed);
+		} else {
+			last = &ed->ed_next;
 		}
 
 		if (modified)
-- 
2.1.0

