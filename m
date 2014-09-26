Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757154AbaIZKf5 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 26 Sep 2014 06:35:57 -0400
Received: from cantor2.suse.de ([195.135.220.15]:33004 "EHLO mx2.suse.de"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1754713AbaIZJp6 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 26 Sep 2014 05:45:58 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Roger Quadros <rogerq@ti.com>,
        Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 026/142] usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1
Date: Fri, 26 Sep 2014 11:43:57 +0200
Message-Id: <f576af6bb6af8db0ecb8f766650faaf98a701919.1411724723.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
References: <406eb8e630446eff74211cba53a536f232bbefd1.1411724723.git.jslaby@suse.cz>
In-Reply-To: <cover.1411724723.git.jslaby@suse.cz>
References: <cover.1411724723.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Roger Quadros <rogerq@ti.com>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

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
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/usb/core/hub.c | 6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 557e8a9fe58a..156fe93fb3d9 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1704,8 +1704,12 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
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
2.1.0

