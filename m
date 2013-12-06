Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162503Ab3LFNVf (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:21:35 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44583 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161908Ab3LFNEV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:21 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 216/272] usb: Disable USB 2.0 Link PM before device reset.
Date: Fri,  6 Dec 2013 12:58:25 +0000
Message-Id: <1386334761-25517-217-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.11: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 1c11089..cf98052 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5079,6 +5079,12 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 	}
 	parent_hub = usb_hub_to_struct_hub(parent_hdev);
 
+	/* Disable USB2 hardware LPM.
+	 * It will be re-enabled by the enumeration process.
+	 */
+	if (udev->usb2_hw_lpm_enabled == 1)
+		usb_set_usb2_hardware_lpm(udev, 0);
+
 	/* Disable LPM and LTM while we reset the device and reinstall the alt
 	 * settings.  Device-initiated LPM settings, and system exit latency
 	 * settings are cleared when the device is reset, so we have to set
-- 
1.8.3.2

