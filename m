Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373Ab3CREbS (ORCPT <rfc822;w@1wt.eu>);
	Mon, 18 Mar 2013 00:31:18 -0400
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:33434 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751581Ab3CREaS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 18 Mar 2013 00:30:18 -0400
Message-Id: <20130318042151.028092270@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 18 Mar 2013 04:22:54 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 70/82] USB: Dont use EHCI port sempahore for USB 3.0  hubs.
In-Reply-To: <20130318042144.234468645@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:d98f:da4e:f620:7bea
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 0fe51aa5eee51db7c7ecd201d42a977ad79c58b6 upstream.

The EHCI host controller needs to prevent EHCI initialization when the
UHCI or OHCI companion controller is in the middle of a port reset.  It
uses ehci_cf_port_reset_rwsem to do this.  USB 3.0 hubs can't be under
an EHCI host controller, so it makes no sense to down the semaphore for
USB 3.0 hubs.  It also makes the warm port reset code more complex.

Don't down ehci_cf_port_reset_rwsem for USB 3.0 hubs.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c |   15 +++++++--------
 1 files changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2271,17 +2271,16 @@ static int hub_port_reset(struct usb_hub
 {
 	int i, status;
 
-	if (!warm) {
-		/* Block EHCI CF initialization during the port reset.
-		 * Some companion controllers don't like it when they mix.
-		 */
-		down_read(&ehci_cf_port_reset_rwsem);
-	} else {
-		if (!hub_is_superspeed(hub->hdev)) {
+	if (!hub_is_superspeed(hub->hdev)) {
+		if (warm) {
 			dev_err(hub->intfdev, "only USB3 hub support "
 						"warm reset\n");
 			return -EINVAL;
 		}
+		/* Block EHCI CF initialization during the port reset.
+		 * Some companion controllers don't like it when they mix.
+		 */
+		down_read(&ehci_cf_port_reset_rwsem);
 	}
 
 	/* Reset the port */
@@ -2319,7 +2318,7 @@ static int hub_port_reset(struct usb_hub
 		port1);
 
 done:
-	if (!warm)
+	if (!hub_is_superspeed(hub->hdev))
 		up_read(&ehci_cf_port_reset_rwsem);
 
 	return status;


