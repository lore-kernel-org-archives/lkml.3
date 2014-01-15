Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753079AbaAOVyR (ORCPT <rfc822;w@1wt.eu>);
	Wed, 15 Jan 2014 16:54:17 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:40760 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753028AbaAOVyI (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 15 Jan 2014 16:54:08 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 025/166] usb: hub: Use correct reset for wedged USB3 devices that are NOTATTACHED
Date: Wed, 15 Jan 2014 13:50:39 -0800
Message-Id: <1389822780-4729-26-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1389822780-4729-1-git-send-email-kamal@canonical.com>
References: <1389822780-4729-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.16 -stable review patch.  If anyone has any objections, please let me know.

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
[ kamal: backport to 3.8 (context) ]
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/core/hub.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 1ac190b..edbf39f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -4764,7 +4764,9 @@ static void hub_events(void)
 					hub->ports[i - 1]->child;
 
 				dev_dbg(hub_dev, "warm reset port %d\n", i);
-				if (!udev) {
+				if (!udev ||
+				    !(portstatus & USB_PORT_STAT_CONNECTION) ||
+				    udev->state == USB_STATE_NOTATTACHED) {
 					status = hub_port_reset(hub, i,
 							NULL, HUB_BH_RESET_TIME,
 							true);
-- 
1.8.3.2

