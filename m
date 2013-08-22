Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753535Ab3HVMt4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 Aug 2013 08:49:56 -0400
Received: from shrek-wifi.podlesie.net ([93.179.225.50]:54835 "EHLO
	shrek.podlesie.net" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753341Ab3HVMty (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 Aug 2013 08:49:54 -0400
From: Krzysztof Mazur <krzysiek@podlesie.net>
To: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, linux-usb@vger.kernel.org
Cc: Alan Stern <stern@rowland.harvard.edu>, linux-kernel@vger.kernel.org,
        Krzysztof Mazur <krzysiek@podlesie.net>
Subject: [PATCH v3 3/3] usb: don't use bNbrPorts after initialization
Date: Thu, 22 Aug 2013 14:49:40 +0200
Message-Id: <1377175780-10611-4-git-send-email-krzysiek@podlesie.net>
X-Mailer: git-send-email 1.8.4.rc4.527.g303b16c
In-Reply-To: <1377175780-10611-1-git-send-email-krzysiek@podlesie.net>
References: <1377175780-10611-1-git-send-email-krzysiek@podlesie.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

After successful initialization hub->descriptor->bNbrPorts and
hub->hdev->maxchild are equal, but using hub->hdev->maxchild is
preferred because that value is explicitly used for initialization
of hub->ports[].

Signed-off-by: Krzysztof Mazur <krzysiek@podlesie.net>
Acked-by: Alan Stern <stern@rowland.harvard.edu>
---
 drivers/usb/core/hub.c | 12 +++++-------
 1 file changed, 5 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index 292ffa8..86e353f 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -451,7 +451,7 @@ static void led_work (struct work_struct *work)
 	if (hdev->state != USB_STATE_CONFIGURED || hub->quiescing)
 		return;
 
-	for (i = 0; i < hub->descriptor->bNbrPorts; i++) {
+	for (i = 0; i < hdev->maxchild; i++) {
 		unsigned	selector, mode;
 
 		/* 30%-50% duty cycle */
@@ -500,7 +500,7 @@ static void led_work (struct work_struct *work)
 	}
 	if (!changed && blinkenlights) {
 		cursor++;
-		cursor %= hub->descriptor->bNbrPorts;
+		cursor %= hdev->maxchild;
 		set_port_led(hub, cursor + 1, HUB_LED_GREEN);
 		hub->indicator[cursor] = INDICATOR_CYCLE;
 		changed++;
@@ -826,7 +826,7 @@ static unsigned hub_power_on(struct usb_hub *hub, bool do_delay)
 	else
 		dev_dbg(hub->intfdev, "trying to enable port power on "
 				"non-switchable hub\n");
-	for (port1 = 1; port1 <= hub->descriptor->bNbrPorts; port1++)
+	for (port1 = 1; port1 <= hub->hdev->maxchild; port1++)
 		if (hub->ports[port1 - 1]->power_is_on)
 			set_port_feature(hub->hdev, port1, USB_PORT_FEAT_POWER);
 		else
@@ -4655,9 +4655,7 @@ static void hub_events(void)
 		hub_dev = hub->intfdev;
 		intf = to_usb_interface(hub_dev);
 		dev_dbg(hub_dev, "state %d ports %d chg %04x evt %04x\n",
-				hdev->state, hub->descriptor
-					? hub->descriptor->bNbrPorts
-					: 0,
+				hdev->state, hdev->maxchild,
 				/* NOTE: expects max 15 ports... */
 				(u16) hub->change_bits[0],
 				(u16) hub->event_bits[0]);
@@ -4702,7 +4700,7 @@ static void hub_events(void)
 		}
 
 		/* deal with port status changes */
-		for (i = 1; i <= hub->descriptor->bNbrPorts; i++) {
+		for (i = 1; i <= hdev->maxchild; i++) {
 			if (test_bit(i, hub->busy_bits))
 				continue;
 			connect_change = test_bit(i, hub->change_bits);
-- 
1.8.4.rc4.527.g303b16c

