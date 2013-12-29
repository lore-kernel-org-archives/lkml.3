Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756813Ab3L2DDA (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 22:03:00 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54974 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751739Ab3L2CJv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:51 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Sarah Sharp" <sarah.a.sharp@linux.intel.com>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.321757195@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 004/185] usb: Disable USB 2.0 Link PM before device reset.
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Sarah Sharp <sarah.a.sharp@linux.intel.com>

commit dcc01c0864823f91c3bf3ffca6613e2351702b87 upstream.

Before the USB core resets a device, we need to disable the L1 timeout
for the roothub, if USB 2.0 Link PM is enabled.  Otherwise the port may
transition into L1 in between descriptor fetches, before we know if the
USB device descriptors changed.  LPM will be re-enabled after the
full device descriptors are fetched, and we can confirm the device still
supports USB 2.0 LPM after the reset.

We don't need to wait for the USB device to exit L1 before resetting the
device, since the xHCI roothub port diagrams show a transition to the
Reset state from any of the Ux states (see Figure 34 in the 2012-08-14
xHCI specification update).

This patch should be backported to kernels as old as 3.2, that contain
the commit 65580b4321eb36f16ae8b5987bfa1bb948fc5112 "xHCI: set USB2
hardware LPM".  That was the first commit to enable USB 2.0
hardware-driven Link Power Management.

Signed-off-by: Sarah Sharp <sarah.a.sharp@linux.intel.com>
[bwh: Backported to 3.2: adjust context]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c | 6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4018,6 +4018,12 @@ static int usb_reset_and_verify_device(s
 	}
 	parent_hub = hdev_to_hub(parent_hdev);
 
+	/* Disable USB2 hardware LPM.
+	 * It will be re-enabled by the enumeration process.
+	 */
+	if (udev->usb2_hw_lpm_enabled == 1)
+		usb_set_usb2_hardware_lpm(udev, 0);
+
 	set_bit(port1, parent_hub->busy_bits);
 	for (i = 0; i < SET_CONFIG_TRIES; ++i) {
 

