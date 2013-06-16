Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932079Ab3FPWQn (ORCPT <rfc822;w@1wt.eu>);
	Sun, 16 Jun 2013 18:16:43 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:46398 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755833Ab3FPWJF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 16 Jun 2013 18:09:05 -0400
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>,
        "Don Zickus" <dzickus@redhat.com>, "Tony Camuso" <tcamuso@redhat.com>
Date: Sun, 16 Jun 2013 23:01:38 +0100
Message-ID: <lsq.1371420098.956033959@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [36/83] xhci - correct comp_mode_recovery_timer on return from
 hibernate
In-Reply-To: <lsq.1371420097.958132574@decadent.org.uk>
X-SA-Exim-Connect-IP: 192.168.4.101
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.47-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Tony Camuso <tcamuso@redhat.com>

commit 77df9e0b799b03e1d5d9c68062709af5f637e834 upstream.

Commit 71c731a2 (usb: host: xhci: Fix Compliance Mode on SN65LVPE502CP
Hardware) was a workaround for systems using the SN65LVPE502CP,
controller, but it introduced a bug in resume from hibernate.

The fix created a timer, comp_mode_recovery_timer, which is deleted from
a timer list when xhci_suspend() is called. However, the hibernate image,
including the timer list containing the comp_mode_recovery_timer, had
already been saved before the timer was deleted.

Upon resume from hibernate, the list containing the comp_mode_recovery_timer
is restored from the image saved to disk, and xhci_resume(), assuming that
the timer had been deleted by xhci_suspend(), makes a call to
compliance_mode_recoery_timer_init(), which creates a new instance of the
comp_mode_recovery_timer and attempts to place it into the same list in which
it is already active, thus corrupting the list during the list_add() call.

At this point, a call trace is emitted indicating the list corruption.
Soon afterward, the system locks up, the watchdog times out, and the
ensuing NMI crashes the system.

The problem did not occur when resuming from suspend. In suspend, the
image in RAM remains exactly as it was when xhci_suspend() deleted the
comp_mode_recovery_timer, so there is no problem when xhci_resume()
creates a new instance of this timer and places it in the still empty
list.

This patch avoids the problem by deleting the timer in xhci_resume()
when resuming from hibernate. Now xhci_resume() can safely make the
call to create a new instance of this timer, whether returning from
suspend or hibernate.

Thanks to Alan Stern for his help with understanding the problem.

[Sarah reworked this patch to cover the case where the xHCI restore
register operation fails, and (temp & STS_SRE) is true (and we re-init
the host, including re-init for the compliance mode), but hibernate is
false.  The original patch would have caused list corruption in this
case.]

This patch should be backported to kernels as old as 3.2, that
contain the commit 71c731a296f1b08a3724bd1b514b64f1bda87a23 "usb: host:
xhci: Fix Compliance Mode on SN65LVPE502CP Hardware"

Signed-off-by: Tony Camuso <tcamuso@redhat.com>
Tested-by: Tony Camuso <tcamuso@redhat.com>
Acked-by: Don Zickus <dzickus@redhat.com>
Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/host/xhci.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -938,6 +938,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
+	bool			comp_timer_running = false;
 
 	/* Wait a bit if either of the roothubs need to settle from the
 	 * transition into bus suspend.
@@ -975,6 +976,13 @@ int xhci_resume(struct xhci_hcd *xhci, b
 
 	/* If restore operation fails, re-initialize the HC during resume */
 	if ((temp & STS_SRE) || hibernated) {
+
+		if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) &&
+				!(xhci_all_ports_seen_u0(xhci))) {
+			del_timer_sync(&xhci->comp_mode_recovery_timer);
+			xhci_dbg(xhci, "Compliance Mode Recovery Timer deleted!\n");
+		}
+
 		/* Let the USB core know _both_ roothubs lost power. */
 		usb_root_hub_lost_power(xhci->main_hcd->self.root_hub);
 		usb_root_hub_lost_power(xhci->shared_hcd->self.root_hub);
@@ -1017,6 +1025,8 @@ int xhci_resume(struct xhci_hcd *xhci, b
 		retval = xhci_init(hcd->primary_hcd);
 		if (retval)
 			return retval;
+		comp_timer_running = true;
+
 		xhci_dbg(xhci, "Start the primary HCD\n");
 		retval = xhci_run(hcd->primary_hcd);
 		if (!retval) {
@@ -1058,7 +1068,7 @@ int xhci_resume(struct xhci_hcd *xhci, b
 	 * to suffer the Compliance Mode issue again. It doesn't matter if
 	 * ports have entered previously to U0 before system's suspension.
 	 */
-	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+	if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) && !comp_timer_running)
 		compliance_mode_recovery_timer_init(xhci);
 
 	/* Re-enable port polling. */

