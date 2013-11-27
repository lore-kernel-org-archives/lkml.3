Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753820Ab3K0BAT (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:00:19 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39602 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754031Ab3K0A7m (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:59:42 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>
Subject: [PATCH 3.12 102/116] usb: Disable USB 2.0 Link PM before device reset.
Date: Tue, 26 Nov 2013 16:57:55 -0800
Message-Id: <20131127005743.949233001@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005736.915454872@linuxfoundation.org>
References: <20131127005736.915454872@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -5118,6 +5118,12 @@ static int usb_reset_and_verify_device(s
 	}
 	parent_hub = usb_hub_to_struct_hub(parent_hdev);
 
+	/* Disable USB2 hardware LPM.
+	 * It will be re-enabled by the enumeration process.
+	 */
+	if (udev->usb2_hw_lpm_enabled == 1)
+		usb_set_usb2_hardware_lpm(udev, 0);
+
 	bos = udev->bos;
 	udev->bos = NULL;
 


