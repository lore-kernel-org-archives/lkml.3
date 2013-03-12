Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756171Ab3CLWgm (ORCPT <rfc822;w@1wt.eu>);
	Tue, 12 Mar 2013 18:36:42 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:60462 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756146Ab3CLWdl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 12 Mar 2013 18:33:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [ 095/100] USB: Dont use EHCI port sempahore for USB 3.0 hubs.
Date: Tue, 12 Mar 2013 15:32:20 -0700
Message-Id: <20130312223133.079443132@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130312223122.884099393@linuxfoundation.org>
References: <20130312223122.884099393@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

[This is upstream commit 0fe51aa5eee51db7c7ecd201d42a977ad79c58b6.
It needs to be backported to kernels as old as 3.2, because it fixes the
buggy commit 65bdac5effd15d6af619b3b7218627ef4d84ed6a "USB: Handle warm
reset failure on empty port."]

The EHCI host controller needs to prevent EHCI initialization when the
UHCI or OHCI companion controller is in the middle of a port reset.  It
uses ehci_cf_port_reset_rwsem to do this.  USB 3.0 hubs can't be under
an EHCI host controller, so it makes no sense to down the semaphore for
USB 3.0 hubs.  It also makes the warm port reset code more complex.

Don't down ehci_cf_port_reset_rwsem for USB 3.0 hubs.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |   15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2661,17 +2661,16 @@ static int hub_port_reset(struct usb_hub
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
@@ -2709,7 +2708,7 @@ static int hub_port_reset(struct usb_hub
 		port1);
 
 done:
-	if (!warm)
+	if (!hub_is_superspeed(hub->hdev))
 		up_read(&ehci_cf_port_reset_rwsem);
 
 	return status;


