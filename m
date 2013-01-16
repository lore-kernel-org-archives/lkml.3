Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756900Ab3APP6p (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 10:58:45 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35711 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755340Ab3APP6k (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 10:58:40 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alan Stern <stern@rowland.harvard.edu>,
        Sarah Sharp <sarah.a.sharp@linux.intel.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: [PATCH 019/222] USB: fix endpoint-disabling for failed config changes
Date: Wed, 16 Jan 2013 13:53:39 -0200
Message-Id: <1358351822-7675-20-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alan Stern <stern@rowland.harvard.edu>

commit 36caff5d795429c572443894e8789c2150dd796b upstream.

This patch (as1631) fixes a bug that shows up when a config change
fails for a device under an xHCI controller.  The controller needs to
be told to disable the endpoints that have been enabled for the new
config.  The existing code does this, but before storing the
information about which endpoints were enabled!  As a result, any
second attempt to install the new config is doomed to fail because
xhci-hcd will refuse to enable an endpoint that is already enabled.

The patch optimistically initializes the new endpoints' device
structures before asking the device to switch to the new config.  If
the request fails then the endpoint information is already stored, so
we can use usb_hcd_alloc_bandwidth() to disable the endpoints with no
trouble.  The rest of the error path is slightly more complex now; we
have to disable the new interfaces and call put_device() rather than
simply deallocating them.

Signed-off-by: Alan Stern <stern@rowland.harvard.edu>
Reported-and-tested-by: Matthias Schniedermeyer <ms@citd.de>
CC: Sarah Sharp <sarah.a.sharp@linux.intel.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/usb/core/message.c |   54 +++++++++++++++++++++++++-------------------
 1 file changed, 31 insertions(+), 23 deletions(-)

diff --git a/drivers/usb/core/message.c b/drivers/usb/core/message.c
index 11cc49d..cf8cb4e 100644
--- a/drivers/usb/core/message.c
+++ b/drivers/usb/core/message.c
@@ -1806,29 +1806,8 @@ free_interfaces:
 		goto free_interfaces;
 	}
 
-	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
-			      USB_REQ_SET_CONFIGURATION, 0, configuration, 0,
-			      NULL, 0, USB_CTRL_SET_TIMEOUT);
-	if (ret < 0) {
-		/* All the old state is gone, so what else can we do?
-		 * The device is probably useless now anyway.
-		 */
-		cp = NULL;
-	}
-
-	dev->actconfig = cp;
-	if (!cp) {
-		usb_set_device_state(dev, USB_STATE_ADDRESS);
-		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
-		/* Leave LPM disabled while the device is unconfigured. */
-		mutex_unlock(hcd->bandwidth_mutex);
-		usb_autosuspend_device(dev);
-		goto free_interfaces;
-	}
-	mutex_unlock(hcd->bandwidth_mutex);
-	usb_set_device_state(dev, USB_STATE_CONFIGURED);
-
-	/* Initialize the new interface structures and the
+	/*
+	 * Initialize the new interface structures and the
 	 * hc/hcd/usbcore interface/endpoint state.
 	 */
 	for (i = 0; i < nintf; ++i) {
@@ -1872,6 +1851,35 @@ free_interfaces:
 	}
 	kfree(new_interfaces);
 
+	ret = usb_control_msg(dev, usb_sndctrlpipe(dev, 0),
+			      USB_REQ_SET_CONFIGURATION, 0, configuration, 0,
+			      NULL, 0, USB_CTRL_SET_TIMEOUT);
+	if (ret < 0 && cp) {
+		/*
+		 * All the old state is gone, so what else can we do?
+		 * The device is probably useless now anyway.
+		 */
+		usb_hcd_alloc_bandwidth(dev, NULL, NULL, NULL);
+		for (i = 0; i < nintf; ++i) {
+			usb_disable_interface(dev, cp->interface[i], true);
+			put_device(&cp->interface[i]->dev);
+			cp->interface[i] = NULL;
+		}
+		cp = NULL;
+	}
+
+	dev->actconfig = cp;
+	mutex_unlock(hcd->bandwidth_mutex);
+
+	if (!cp) {
+		usb_set_device_state(dev, USB_STATE_ADDRESS);
+
+		/* Leave LPM disabled while the device is unconfigured. */
+		usb_autosuspend_device(dev);
+		return ret;
+	}
+	usb_set_device_state(dev, USB_STATE_CONFIGURED);
+
 	if (cp->string == NULL &&
 			!(dev->quirks & USB_QUIRK_CONFIG_INTF_STRINGS))
 		cp->string = usb_cache_string(dev, cp->desc.iConfiguration);
-- 
1.7.9.5

