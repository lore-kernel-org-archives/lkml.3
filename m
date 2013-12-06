Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753093Ab3LFDa1 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 5 Dec 2013 22:30:27 -0500
Received: from mail-pd0-f170.google.com ([209.85.192.170]:57136 "EHLO
	mail-pd0-f170.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751935Ab3LFDaY (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 5 Dec 2013 22:30:24 -0500
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Vincent Palatin <vpalatin@chromium.org>,
        Doug Anderson <dianders@chromium.org>,
        Vivek Gautam <gautam.vivek@samsung.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH v2] usb: core: Make sure usb_set_configuration(-1) cannot fail
Date: Thu,  5 Dec 2013 19:29:53 -0800
Message-Id: <1386300593-1270-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 1.8.5.1
References: <1386116201-22131-1-git-send-email-jwerner@chromium.org> <Pine.LNX.4.44L0.1312041014460.1329-100000@iolanthe.rowland.org> <CAODwPW8aLDUyQbX1h2FkeFvWHCTV=sCFVztPP6kHpaaF-OBOOA@mail.gmail.com>
In-Reply-To: <CAODwPW8aLDUyQbX1h2FkeFvWHCTV=sCFVztPP6kHpaaF-OBOOA@mail.gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

usb_deauthorize_device() tries to unset the configuration of a USB
device and then unconditionally blows away the configuration descriptors
with usb_destroy_configuration(). This is bad if the
usb_set_configuration() call failed before the configuration could be
correctly unset, since pointers like udev->actconfig can keep pointing
to the now invalid memory. We have encountered hard to reproduce crashes
from devices disconnected during suspend due to this, where khubd's
disconnect handling races with userspace tools that change authorization
on resume.

It seems desirable that a USB device can always be marked as
unconfigured (reclaiming its bandwidth) in the kernel, regardless of
communication problems. This patch changes usb_set_configuration() to
ignore all failures in the case where no new configuration is being set.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/message.c | 7 ++++---
 1 file changed, 4 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index bb31597..f980b6d 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1706,7 +1706,8 @@ static void __usb_queue_reset_device(struct work_struct *ws)
  * underlying call that failed.  On successful completion, each interface
  * in the original device configuration has been destroyed, and each one
  * in the new configuration has been probed by all relevant usb device
- * drivers currently known to the kernel.
+ * drivers currently known to the kernel. Guaranteed not to fail if the
+ * device is to be unconfigured (@configuration = -1).
  */
 int usb_set_configuration(struct usb_device *dev, int configuration)
 {
@@ -1774,7 +1775,7 @@ free_interfaces:
 
 	/* Wake up the device so we can send it the Set-Config request */
 	ret = usb_autoresume_device(dev);
-	if (ret)
+	if (ret && cp)
 		goto free_interfaces;
 
 	/* if it's already configured, clear out old state first.
@@ -1797,7 +1798,7 @@ free_interfaces:
 	 * installed, so that the xHCI driver can recalculate the U1/U2
 	 * timeouts.
 	 */
-	if (dev->actconfig && usb_disable_lpm(dev)) {
+	if (dev->actconfig && usb_disable_lpm(dev) && cp) {
 		dev_err(&dev->dev, "%s Failed to disable LPM\n.", __func__);
 		mutex_unlock(hcd->bandwidth_mutex);
 		ret = -ENOMEM;
-- 
1.7.12.4

