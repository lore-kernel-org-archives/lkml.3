Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1162484Ab3LFNTq (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 08:19:46 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44601 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1161437Ab3LFNE2 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 08:04:28 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Julius Werner <jwerner@chromium.org>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 220/272] usb: hub: Clear Port Reset Change during init/resume
Date: Fri,  6 Dec 2013 12:58:29 +0000
Message-Id: <1386334761-25517-221-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
References: <1386334761-25517-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.1 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/usb/core/hub.c | 5 +++++
 1 file changed, 5 insertions(+)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index ef15a22..9ba5fcd4 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1129,6 +1129,11 @@ static void hub_activate(struct usb_hub *hub, enum hub_activation_type type)
 			usb_clear_port_feature(hub->hdev, port1,
 					USB_PORT_FEAT_C_ENABLE);
 		}
+		if (portchange & USB_PORT_STAT_C_RESET) {
+			need_debounce_delay = true;
+			usb_clear_port_feature(hub->hdev, port1,
+					USB_PORT_FEAT_C_RESET);
+		}
 		if ((portchange & USB_PORT_STAT_C_BH_RESET) &&
 				hub_is_superspeed(hub->hdev)) {
 			need_debounce_delay = true;
-- 
1.8.3.2

