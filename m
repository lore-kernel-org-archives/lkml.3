Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752211AbaHDJpB (ORCPT <rfc822;w@1wt.eu>);
	Mon, 4 Aug 2014 05:45:01 -0400
Received: from devils.ext.ti.com ([198.47.26.153]:54533 "EHLO
	devils.ext.ti.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751550AbaHDJo7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 4 Aug 2014 05:44:59 -0400
From: Roger Quadros <rogerq@ti.com>
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <ming.lei@canonical.com>, <mwelling@emacinc.com>,
        <stefan@herbrechtsmeier.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Roger Quadros <rogerq@ti.com>,
        "[3.8+]" <stable@vger.kernel.org>
Subject: [PATCH] usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1
Date: Mon, 4 Aug 2014 12:44:46 +0300
Message-ID: <1407145486-14013-1-git-send-email-rogerq@ti.com>
X-Mailer: git-send-email 1.8.3.2
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If user specifies that USB autosuspend must be disabled by module
parameter "usbcore.autosuspend=-1" then we must prevent
autosuspend of USB hub devices as well.

commit 596d789a211d introduced in v3.8 changed the original behaivour
and stopped respecting the usbcore.autosuspend parameter for hubs.

Fixes: 596d789a211d "USB: set hub's default autosuspend delay as 0"

Cc: [3.8+] <stable@vger.kernel.org>
Signed-off-by: Roger Quadros <rogerq@ti.com>
---
 drivers/usb/core/hub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 0e950ad..a287cd5 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1728,8 +1728,12 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 * - Change autosuspend delay of hub can avoid unnecessary auto
 	 *   suspend timer for hub, also may decrease power consumption
 	 *   of USB bus.
+	 *
+	 * - If user has indicated to prevent autosuspend by passing
+	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
 	 */
-	pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
+	if (hdev->dev.power.autosuspend_delay >= 0)
+		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
 
 	/*
 	 * Hubs have proper suspend/resume support, except for root hubs
-- 
1.8.3.2

