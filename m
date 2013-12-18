Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932117Ab3LRWVg (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 17:21:36 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:35726 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752074Ab3LRVIt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:08:49 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.4 11/31] usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED
Date: Wed, 18 Dec 2013 13:08:19 -0800
Message-Id: <20131218210523.114599656@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218210522.790152625@linuxfoundation.org>
References: <20131218210522.790152625@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit 2d51f3cd11f414c56a87dc018196b85fd50b04a4 upstream.

This patch adds a check for USB_STATE_NOTATTACHED to the
hub_port_warm_reset_required() workaround for ports that end up in
Compliance Mode in hub_events() when trying to decide which reset
function to use. Trying to call usb_reset_device() with a NOTATTACHED
device will just fail and leave the port broken.

Signed-off-by: Julius Werner <jwerner@chromium.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/core/hub.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -3891,8 +3891,9 @@ static void hub_events(void)
 					hub->hdev->children[i - 1];
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev || !(portstatus &
-						USB_PORT_STAT_CONNECTION)) {
+				if (!udev ||
+				    !(portstatus & USB_PORT_STAT_CONNECTION) ||
+				    udev->state == USB_STATE_NOTATTACHED) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);


