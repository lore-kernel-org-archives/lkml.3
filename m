Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752112Ab3L2CJz (ORCPT <rfc822;w@1wt.eu>);
	Sat, 28 Dec 2013 21:09:55 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:54977 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751809Ab3L2CJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 28 Dec 2013 21:09:49 -0500
Content-Type: text/plain; charset="UTF-8"
Content-Disposition: inline
Content-Transfer-Encoding: 8bit
MIME-Version: 1.0
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
CC: akpm@linux-foundation.org, "Julius Werner" <jwerner@chromium.org>,
        "Greg Kroah-Hartman" <gregkh@linuxfoundation.org>,
        "Alan Stern" <stern@rowland.harvard.edu>
Date: Sun, 29 Dec 2013 03:08:43 +0100
Message-ID: <lsq.1388282923.810556825@decadent.org.uk>
X-Mailer: LinuxStableQueue (scripts by bwh)
Subject: [PATCH 3.2 005/185] usb: hub: Clear Port Reset Change during
 init/resume
In-Reply-To: <lsq.1388282923.751256928@decadent.org.uk>
X-SA-Exim-Connect-IP: 31.18.200.85
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2.54-rc1 review patch.  If anyone has any objections, please let me know.

------------------

From: Julius Werner <jwerner@chromium.org>

commit e92aee330837e4911553761490a8fb843f2053a6 upstream.

This patch adds the Port Reset Change flag to the set of bits that are
preemptively cleared on init/resume of a hub. In theory this bit should
never be set unexpectedly... in practice it can still happen if BIOS,
SMM or ACPI code plays around with USB devices without cleaning up
correctly. This is especially dangerous for XHCI root hubs, which don't
generate any more Port Status Change Events until all change bits are
cleared, so this is a good precaution to have (similar to how it's
already done for the Warm Port Reset Change flag).

Signed-off-by: Julius Werner <jwerner@chromium.org>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
[bwh: Backported to 3.2:
 - Adjust context
 - s/usb_clear_port_feature/clear_port_feature/]
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/usb/core/hub.c | 5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -900,6 +900,11 @@ static void hub_activate(struct usb_hub
 			clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_PORT_LINK_STATE);
 		}
+		if (portchange & USB_PORT_STAT_C_RESET) {
+			need_debounce_delay = true;
+			clear_port_feature(hub->hdev, port1,
+					USB_PORT_FEAT_C_RESET);
+		}
 
 		if ((portchange & USB_PORT_STAT_C_BH_RESET) &&
 				hub_is_superspeed(hub->hdev)) {

