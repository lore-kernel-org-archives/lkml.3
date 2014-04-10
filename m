Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965456AbaDJDy7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 9 Apr 2014 23:54:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:41210 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S934647AbaDJDWl (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 9 Apr 2014 23:22:41 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Ben Hutchings <ben@decadent.org.uk>,
        Yang Yingliang <yangyingliang@huawei.com>
Subject: [PATCH 3.4 086/134] usb: Disable USB 2.0 Link PM before device reset.
Date: Wed,  9 Apr 2014 20:23:22 -0700
Message-Id: <20140410032310.999625356@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140410032259.587501440@linuxfoundation.org>
References: <20140410032259.587501440@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Yang Yingliang <yangyingliang@huawei.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    6 ++++++
 1 file changed, 6 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4139,6 +4139,12 @@ static int usb_reset_and_verify_device(s
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
 


