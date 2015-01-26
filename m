Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757062AbbAZV07 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 26 Jan 2015 16:26:59 -0500
Received: from mail-ig0-f175.google.com ([209.85.213.175]:44557 "EHLO
	mail-ig0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756489AbbAZV0z (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 26 Jan 2015 16:26:55 -0500
From: Julius Werner <jwerner@chromium.org>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org, linux-usb@vger.kernel.org,
        Alan Stern <stern@rowland.harvard.edu>,
        Dan Williams <dan.j.williams@intel.com>,
        Douglas Anderson <dianders@chromium.org>,
        Tomasz Figa <tfiga@chromium.org>, Wu Liang feng <wulf@rock-chips.com>,
        Julius Werner <jwerner@chromium.org>
Subject: [PATCH v2] usb: Retry port status check on resume to work around RH bugs
Date: Mon, 26 Jan 2015 13:26:42 -0800
Message-Id: <1422307602-30466-1-git-send-email-jwerner@chromium.org>
X-Mailer: git-send-email 2.2.0.rc0.207.ga3a616c
In-Reply-To: <CAODwPW-EeNn_rWLTen2MHnpB_skL08j1aGX06Acf8kph=i_pcg@mail.gmail.com>
References: <1422057688-18956-1-git-send-email-jwerner@chromium.org> <Pine.LNX.4.44L0.1501241046550.7435-100000@netrider.rowland.org> <CAODwPW-EeNn_rWLTen2MHnpB_skL08j1aGX06Acf8kph=i_pcg@mail.gmail.com>
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
+				usleep_range(200, 300);
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

