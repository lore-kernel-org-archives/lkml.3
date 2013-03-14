Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757437Ab3CNKic (ORCPT <rfc822;w@1wt.eu>);
	Thu, 14 Mar 2013 06:38:32 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:52120 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757407Ab3CNKiY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 14 Mar 2013 06:38:24 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 85/88] USB: Don't use EHCI port sempahore for USB 3.0 hubs.
Date: Thu, 14 Mar 2013 10:36:18 +0000
Message-Id: <1363257381-15900-86-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
References: <1363257381-15900-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit 0fe51aa5eee51db7c7ecd201d42a977ad79c58b6 upstream.

[This is upstream commit 0fe51aa5eee51db7c7ecd201d42a977ad79c58b6.
It needs to be backported to kernels as old as 3.2, because it fixes the
buggy commit 9dbcaec830cd97f44a0b91b315844e0d7144746b "USB: Handle warm
reset failure on empty port."]

The EHCI host controller needs to prevent EHCI initialization when the
UHCI or OHCI companion controller is in the middle of a port reset.  It
uses ehci_cf_port_reset_rwsem to do this.  USB 3.0 hubs can't be under
an EHCI host controller, so it makes no sense to down the semaphore for
USB 3.0 hubs.  It also makes the warm port reset code more complex.

Don't down ehci_cf_port_reset_rwsem for USB 3.0 hubs.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 15 +++++++--------
 1 file changed, 7 insertions(+), 8 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index c9590c6..1a2cd0e 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2552,17 +2552,16 @@ static int hub_port_reset(struct usb_hub *hub, int port1,
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
@@ -2600,7 +2599,7 @@ static int hub_port_reset(struct usb_hub *hub, int port1,
 		port1);
 
 done:
-	if (!warm)
+	if (!hub_is_superspeed(hub->hdev))
 		up_read(&ehci_cf_port_reset_rwsem);
 
 	return status;
-- 
1.8.1.2

