Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756814Ab3KYNUH (ORCPT <rfc822;w@1wt.eu>);
	Mon, 25 Nov 2013 08:20:07 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:57160 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754419Ab3KYNIH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 25 Nov 2013 08:08:07 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.5 41/78] usb: Disable USB 2.0 Link PM before device reset.
Date: Mon, 25 Nov 2013 13:06:28 +0000
Message-Id: <1385384825-21681-42-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
References: <1385384825-21681-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.26 -stable review patch.  If anyone has any objections, please let me know.

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
[ luis: backported to 3.5: adjusted context ]
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 6 ++++++
 1 file changed, 6 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 7be4e11..86c7421 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4824,6 +4824,12 @@ static int usb_reset_and_verify_device(struct usb_device *udev)
 	}
 	parent_hub = hdev_to_hub(parent_hdev);
 
+	/* Disable USB2 hardware LPM.
+	 * It will be re-enabled by the enumeration process.
+	 */
+	if (udev->usb2_hw_lpm_enabled == 1)
+		usb_set_usb2_hardware_lpm(udev, 0);
+
 	/* Disable LPM while we reset the device and reinstall the alt settings.
 	 * Device-initiated LPM settings, and system exit latency settings are
 	 * cleared when the device is reset, so we have to set them up again.
-- 
1.8.3.2

