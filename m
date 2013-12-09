Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933444Ab3LIM3e (ORCPT <rfc822;w@1wt.eu>);
	Mon, 9 Dec 2013 07:29:34 -0500
Received: from mail-pd0-f180.google.com ([209.85.192.180]:50907 "EHLO
	mail-pd0-f180.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933171Ab3LIM3a (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 9 Dec 2013 07:29:30 -0500
From: Vikas Sajjan <vikas.sajjan@linaro.org>
To: linux-samsung-soc@vger.kernel.org
Cc: kgene.kim@samsung.com, linux-kernel@vger.kernel.org,
        linux-usb@vger.kernel.org, sarah.a.sharp@linux.intel.com,
        stern@rowland.harvard.edu, vpalatin@chromium.org, jwerner@chromium.org,
        tianyu.lan@intel.com, burzalodowa@gmail.com,
        gregkh@linuxfoundation.org, gautam.vivek@samsung.com,
        dianders@chromium.org, balbi@ti.com, joshi@samsung.com
Subject: [PATCH] USB: core: Add warm reset while reset-resuming SuperSpeed HUBs
Date: Mon,  9 Dec 2013 18:14:18 +0545
Message-Id: <1386592158-12086-1-git-send-email-vikas.sajjan@linaro.org>
X-Mailer: git-send-email 1.7.9.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Does warm reset while activating SuperSpeed HUBs if the hub activate type
is HUB_RESET_RESUME.

When we do Suspend-to-RAM with (any one of the 16, 32, 64 Jetflash) transcend
USB 3.0 device connected on 3.0 port, during resume I noticed that the
XHCI controller has moved to sometimes RECOVERY, POLLING or INACTIVE STATE.
This behaviour is inconsistent and the connection with connected USB 3.0 device
on 3.0 port was LOST.

Doing warm reset while activating SuperSpeed HUBs if the hub
activate type is HUB_RESET_RESUME, gets the connected device to the stable state.

Reviewed at https://chromium-review.googlesource.com/#/c/177132/

Tested on exynos5420 and exynos5250 with Transcend Jetflash USB 3.0 device (8564:1000)

rebased on Greg Kroah-Hartman's usb-next
git://git.kernel.org/pub/scm/linux/kernel/git/gregkh/usb.git

Signed-off-by: Vikas Sajjan <vikas.sajjan@samsung.com>
---
 drivers/usb/core/hub.c |   41 +++++++++++++++++++++++++----------------
 1 file changed, 25 insertions(+), 16 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index a7c04e2..d8432b0 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -993,6 +993,21 @@ int usb_remove_device(struct usb_device *udev)
 	return 0;
 }
 
+#define PORT_RESET_TRIES	5
+#define SET_ADDRESS_TRIES	2
+#define GET_DESCRIPTOR_TRIES	2
+#define SET_CONFIG_TRIES	(2 * (use_both_schemes + 1))
+#define USE_NEW_SCHEME(i)	((i) / 2 == (int)old_scheme_first)
+
+#define HUB_ROOT_RESET_TIME	50	/* times are in msec */
+#define HUB_SHORT_RESET_TIME	10
+#define HUB_BH_RESET_TIME	50
+#define HUB_LONG_RESET_TIME	200
+#define HUB_RESET_TIMEOUT	800
+
+static int hub_port_reset(struct usb_hub *hub, int port1,
+			struct usb_device *udev, unsigned int delay, bool warm);
+
 enum hub_activation_type {
 	HUB_INIT, HUB_INIT2, HUB_INIT3,		/* INITs must come first */
 	HUB_POST_RESET, HUB_RESUME, HUB_RESET_RESUME,
@@ -1093,6 +1108,16 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 		u16 portstatus, portchange;
 
 		portstatus = portchange = 0;
+
+		/* Some connected devices might be still in unknown state even
+		 * after reset-resume, a WARM_RESET gets the connected device
+		 * to the normal state.
+		 */
+		if (udev && hub_is_superspeed(hub->hdev) &&
+						type == HUB_RESET_RESUME)
+			hub_port_reset(hub, port1, NULL,
+						HUB_BH_RESET_TIME, true);
+
 		status = hub_port_status(hub, port1, &portstatus, &portchange);
 		if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
 			dev_dbg(hub->intfdev,
@@ -2510,22 +2535,6 @@ static unsigned hub_is_wusb(struct usb_hub *hub)
 	return hcd->wireless;
 }
 
-
-#define PORT_RESET_TRIES	5
-#define SET_ADDRESS_TRIES	2
-#define GET_DESCRIPTOR_TRIES	2
-#define SET_CONFIG_TRIES	(2 * (use_both_schemes + 1))
-#define USE_NEW_SCHEME(i)	((i) / 2 == (int)old_scheme_first)
-
-#define HUB_ROOT_RESET_TIME	50	/* times are in msec */
-#define HUB_SHORT_RESET_TIME	10
-#define HUB_BH_RESET_TIME	50
-#define HUB_LONG_RESET_TIME	200
-#define HUB_RESET_TIMEOUT	800
-
-static int hub_port_reset(struct usb_hub *hub, int port1,
-			struct usb_device *udev, unsigned int delay, bool warm);
-
 /* Is a USB 3.0 port in the Inactive or Complinance Mode state?
  * Port worm reset is required to recover
  */
-- 
1.7.9.5

