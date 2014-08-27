Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933592AbaH0ML0 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 27 Aug 2014 08:11:26 -0400
Received: from comal.ext.ti.com ([198.47.26.152]:41077 "EHLO comal.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933520AbaH0MLY (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 27 Aug 2014 08:11:24 -0400
Message-ID: <53FDCADE.3040601@ti.com>
Date: Wed, 27 Aug 2014 15:11:10 +0300
From: Roger Quadros <rogerq@ti.com>
User-Agent: Mozilla/5.0 (X11; Linux i686; rv:24.0) Gecko/20100101 Thunderbird/24.3.0
MIME-Version: 1.0
To: <gregkh@linuxfoundation.org>, <stern@rowland.harvard.edu>
CC: <balbi@ti.com>, <ming.lei@canonical.com>, <mwelling@emacinc.com>,
        <stefan@herbrechtsmeier.net>, <linux-usb@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, "[3.8+]" <stable@vger.kernel.org>
Subject: [PATCH v2] usb: hub: Prevent hub autosuspend if usbcore.autosuspend
 is -1
References: <1407145486-14013-1-git-send-email-rogerq@ti.com>
In-Reply-To: <1407145486-14013-1-git-send-email-rogerq@ti.com>
Content-Type: text/plain; charset="ISO-8859-1"
Content-Transfer-Encoding: 7bit
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
 drivers/usb/core/hub.c | 8 +++++++-
 1 file changed, 7 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 8a4dcbc..59b599d 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1728,8 +1728,14 @@ static int hub_probe(struct usb_interface *intf, const struct usb_device_id *id)
 	 * - Change autosuspend delay of hub can avoid unnecessary auto
 	 *   suspend timer for hub, also may decrease power consumption
 	 *   of USB bus.
+	 *
+	 * - If user has indicated to prevent autosuspend by passing
+	 *   usbcore.autosuspend = -1 then keep autosuspend disabled.
 	 */
-	pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
+#ifdef CONFIG_PM_RUNTIME
+	if (hdev->dev.power.autosuspend_delay >= 0)
+		pm_runtime_set_autosuspend_delay(&hdev->dev, 0);
+#endif
 
 	/*
 	 * Hubs have proper suspend/resume support, except for root hubs
-- 
1.8.3.2

