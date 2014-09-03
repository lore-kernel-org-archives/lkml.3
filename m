Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S935857AbaICXX7 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 19:23:59 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:45858 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757166AbaICWP7 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 18:15:59 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Roger Quadros <rogerq@ti.com>, Michael Welling <mwelling@emacinc.com>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.14 81/88] usb: hub: Prevent hub autosuspend if usbcore.autosuspend is -1
Date: Wed,  3 Sep 2014 15:05:55 -0700
Message-Id: <20140903220518.369252517@linuxfoundation.org>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <20140903220515.958924632@linuxfoundation.org>
References: <20140903220515.958924632@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/hub.c |    6 +++++-
 1 file changed, 5 insertions(+), 1 deletion(-)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1695,8 +1695,12 @@ static int hub_probe(struct usb_interfac
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


