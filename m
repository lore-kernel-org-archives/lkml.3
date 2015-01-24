Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754343AbbAXABq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 23 Jan 2015 19:01:46 -0500
Received: from mail-ie0-f175.google.com ([209.85.223.175]:58217 "EHLO
	mail-ie0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751524AbbAXABo (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 23 Jan 2015 19:01:44 -0500
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        Douglas Anderson <dianders@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>, Wu Liang feng <wulf@rock-chips.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH] usb: Retry port status check on resume to work around RH bugs
Date: Fri, 23 Jan 2015 16:01:28 -0800
Message-Id: <1422057688-18956-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The EHCI controller on the RK3288 SoC is violating basic parts of the
USB spec and thereby unable to properly resume a suspended port. It does
not start SOF generation within 3ms of finishing resume signaling, so
the attached device will drop off the bus again. This is a particular
problem with runtime PM, where accessing the device will trigger a
resume that immediately makes it unavailabe (and reenumerate with a new
handle).

Thankfully, the persist feature is generally able to work around stuff
like that. Unfortunately, it doesn't quite work in this particular case
because the controller will turn off the CurrentConnectStatus bit for an
instant while the device is reconnecting, which causes the kernel to
conclude that it permanently disappeared. This patch adds a tiny retry
mechanism to the core port resume code which will catch this case and
shouldn't have any notable impact on other controllers.

Signed-off-by: Julius Werner <jwerner@chromium.org>
---
 drivers/usb/core/hub.c | 13 +++++++++++--
 1 file changed, 11 insertions(+), 2 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index aeb50bb..d1d0a66 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -2896,10 +2896,12 @@ static int port_is_suspended(struct usb_hub *hub, unsigned portstatus)
  */
 static int check_port_resume_type(struct usb_device *udev,
 		struct usb_hub *hub, int port1,
-		int status, unsigned portchange, unsigned portstatus)
+		int status, u16 portchange, u16 portstatus)
 {
 	struct usb_port *port_dev = hub->ports[port1 - 1];
+	int retries = 3;
 
+retry:
 	/* Is a warm reset needed to recover the connection? */
 	if (status == 0 && udev->reset_resume
 		&& hub_port_warm_reset_required(hub, port1, portstatus)) {
@@ -2909,8 +2911,15 @@ static int check_port_resume_type(struct usb_device *udev,
 	else if (status || port_is_suspended(hub, portstatus) ||
 			!port_is_power_on(hub, portstatus) ||
 			!(portstatus & USB_PORT_STAT_CONNECTION)) {
-		if (status >= 0)
+		if (status >= 0) {
+			if (retries--) {
+				udelay(200);
+				status = hub_port_status(hub, port1,
+						&portstatus, &portchange);
+				goto retry;
+			}
 			status = -ENODEV;
+		}
 	}
 
 	/* Can't do a normal resume if the port isn't enabled,
-- 
2.1.2

