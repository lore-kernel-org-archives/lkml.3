Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753738AbaI3VhZ (ORCPT <rfc822;w@1wt.eu>);
	Tue, 30 Sep 2014 17:37:25 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:60924 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753661AbaI3VhW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 30 Sep 2014 17:37:22 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Roger Quadros <rogerq@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 068/103] usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1
Date: Tue, 30 Sep 2014 14:31:13 -0700
Message-Id: <1412112708-27356-69-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1412112708-27356-1-git-send-email-kamal@canonical.com>
References: <1412112708-27356-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.8 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Roger Quadros <rogerq@ti.com>

commit bdd405d2a5287bdb9b04670ea255e1f122138e66 upstream.

If user specifies that USB autosuspend must be disabled by module
parameter "usbcore.autosuspend=-1" then we must prevent
autosuspend of USB hub devices as well.

commit 596d789a211d introduced in v3.8 changed the original behaivour
and stopped respecting the usbcore.autosuspend parameter for hubs.

Fixes: 596d789a211d "USB: set hub's default autosuspend delay as 0"

Signed-off-by: Roger Quadros <rogerq@ti.com>
Tested-by: Michael Welling <mwelling@emacinc.com>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/core/hub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 9d30359..79c24e6 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1701,8 +1701,12 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
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
1.9.1

