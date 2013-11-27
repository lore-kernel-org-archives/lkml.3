Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1760050Ab3K0Bi7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Nov 2013 20:38:59 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:39220 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932294Ab3K0A6N (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Nov 2013 19:58:13 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Julius Werner <jwerner@chromium.org>,
        Alan Stern <stern@rowland.harvard.edu>
Subject: [PATCH 3.10 73/80] usb: hub: Clear Port Reset Change during init/resume
Date: Tue, 26 Nov 2013 16:57:42 -0800
Message-Id: <20131127005645.986827243@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.rc3
In-Reply-To: <20131127005640.934155527@linuxfoundation.org>
References: <20131127005640.934155527@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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

---
 drivers/usb/core/hub.c |    5 +++++
 1 file changed, 5 insertions(+)

--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1129,6 +1129,11 @@ static void hub_activate(struct usb_hub
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


