Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbaIOWst (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Sep 2014 18:48:49 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:51061 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1758121AbaIOWRn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Sep 2014 18:17:43 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 083/187] USB: OHCI: don't lose track of EDs when a controller dies
Date: Mon, 15 Sep 2014 15:08:13 -0700
Message-Id: <1410818997-9432-84-git-send-email-kamal@canonical.com>
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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/host/ohci-q.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

diff --git a/drivers/usb/host/ohci-q.c b/drivers/usb/host/ohci-q.c
index e7f577e..4e9f6a4 100644
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
1.9.1

