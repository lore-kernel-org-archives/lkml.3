Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755542AbaIKMeQ (ORCPT <rfc822;w@1wt.eu>);
	Thu, 11 Sep 2014 08:34:16 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:51465 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1754994AbaIKMeE (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 11 Sep 2014 08:34:04 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Alan Stern" <stern@rowland.harvard.edu>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>
Date: Thu, 11 Sep 2014 13:32:13 +0100
Message-ID: <lsq.1410438733.649476518@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 013/131] USB: OHCI: don't lose track of EDs when a
 controller dies
In-Reply-To: <lsq.1410438733.176537304@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.249
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.63-rc1 review patch.  If anyone has any objections, please let me know.

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
[bwh: Backported to 3.2: keep using HC_IS_RUNNING()]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/ohci-q.c | 46 +++++++++++++++++++++++++++++-----------------
 1 file changed, 29 insertions(+), 17 deletions(-)

--- a/drivers/usb/host/ohci-q.c
+++ b/drivers/usb/host/ohci-q.c
@@ -294,8 +294,7 @@ static void periodic_unlink (struct ohci
  *  - ED_OPER: when there's any request queued, the ED gets rescheduled
  *    immediately.  HC should be working on them.
  *
- *  - ED_IDLE:  when there's no TD queue. there's no reason for the HC
- *    to care about this ED; safe to disable the endpoint.
+ *  - ED_IDLE: when there's no TD queue or the HC isn't running.
  *
  * When finish_unlinks() runs later, after SOF interrupt, it will often
  * complete one or more URB unlinks before making that state change.
@@ -909,6 +908,10 @@ rescan_all:
 		int			completed, modified;
 		__hc32			*prev;
 
+		/* Is this ED already invisible to the hardware? */
+		if (ed->state == ED_IDLE)
+			goto ed_idle;
+
 		/* only take off EDs that the HC isn't using, accounting for
 		 * frame counter wraps and EDs with partially retired TDs
 		 */
@@ -938,12 +941,20 @@ skip_ed:
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
@@ -1001,19 +1012,20 @@ rescan_this:
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
-			if (HC_IS_RUNNING(ohci_to_hcd(ohci)->state))
-				ed_schedule (ohci, ed);
+		/*
+		 * If no TDs are queued, take ED off the ed_rm_list.
+		 * Otherwise, if the HC is running, reschedule.
+		 * If not, leave it on the list for further dequeues.
+		 */
+		if (list_empty(&ed->td_list)) {
+			*last = ed->ed_next;
+			ed->ed_next = NULL;
+		} else if (HC_IS_RUNNING(ohci_to_hcd(ohci)->state)) {
+			*last = ed->ed_next;
+			ed->ed_next = NULL;
+			ed_schedule(ohci, ed);
+		} else {
+			last = &ed->ed_next;
 		}
 
 		if (modified)

