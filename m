Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964967Ab3GCSnk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Jul 2013 14:43:40 -0400
Received: from hrndva-omtalb.mail.rr.com ([71.74.56.122]:20124 "EHLO
	hrndva-omtalb.mail.rr.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933309Ab3GCSlL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Jul 2013 14:41:11 -0400
X-Authority-Analysis: v=2.0 cv=KtrPKBqN c=1 sm=0 a=Sro2XwOs0tJUSHxCKfOySw==:17 a=Drc5e87SC40A:10 a=Ciwy3NGCPMMA:10 a=oehYaVSiOswA:10 a=5SG0PmZfjMsA:10 a=bbbx4UPp9XUA:10 a=meVymXHHAAAA:8 a=KGjhK52YXX0A:10 a=z9z4ZKRmb1QA:10 a=20KFwNOVAAAA:8 a=QyXUC8HyAAAA:8 a=VwQbUJbxAAAA:8 a=zkIc3Vkfyo_oDInjBWEA:9 a=jEp0ucaQiEUA:10 a=jeBq3FmKZ4MA:10 a=Sro2XwOs0tJUSHxCKfOySw==:117
X-Cloudmark-Score: 0
X-Authenticated-User: 
X-Originating-IP: 67.255.60.225
Message-Id: <20130703184055.903429244@goodmis.org>
User-Agent: quilt/0.60-1
Date: Wed, 03 Jul 2013 14:40:05 -0400
From: Steven Rostedt <rostedt@goodmis.org>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: Tony Camuso <tcamuso@redhat.com>, Don Zickus <dzickus@redhat.com>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [068/141] xhci - correct comp_mode_recovery_timer on return from hibernate
References: <20130703183857.307196999@goodmis.org>
Content-Disposition: inline; filename=0068-xhci-correct-comp_mode_recovery_timer-on-return-from.patch
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.6.11.6 stable review patch.
If anyone has any objections, please let me know.

------------------

From: Tony Camuso <tcamuso@redhat.com>

[ Upstream commit 77df9e0b799b03e1d5d9c68062709af5f637e834 ]

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
Cc: stable@vger.kernel.org
Signed-off-by: Steven Rostedt <rostedt@goodmis.org>
---
 drivers/usb/host/xhci.c |   12 +++++++++++-
 1 file changed, 11 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/host/xhci.c b/drivers/usb/host/xhci.c
index fd36acd..6ee481a 100644
--- a/drivers/usb/host/xhci.c
+++ b/drivers/usb/host/xhci.c
@@ -942,6 +942,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	struct usb_hcd		*hcd = xhci_to_hcd(xhci);
 	struct usb_hcd		*secondary_hcd;
 	int			retval = 0;
+	bool			comp_timer_running = false;
 
 	/* Wait a bit if either of the roothubs need to settle from the
 	 * transition into bus suspend.
@@ -979,6 +980,13 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 
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
@@ -1021,6 +1029,8 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 		retval = xhci_init(hcd->primary_hcd);
 		if (retval)
 			return retval;
+		comp_timer_running = true;
+
 		xhci_dbg(xhci, "Start the primary HCD\n");
 		retval = xhci_run(hcd->primary_hcd);
 		if (!retval) {
@@ -1062,7 +1072,7 @@ int xhci_resume(struct xhci_hcd *xhci, bool hibernated)
 	 * to suffer the Compliance Mode issue again. It doesn't matter if
 	 * ports have entered previously to U0 before system's suspension.
 	 */
-	if (xhci->quirks & XHCI_COMP_MODE_QUIRK)
+	if ((xhci->quirks & XHCI_COMP_MODE_QUIRK) && !comp_timer_running)
 		compliance_mode_recovery_timer_init(xhci);
 
 	return retval;
-- 
1.7.10.4


