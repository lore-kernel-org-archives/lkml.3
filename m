Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754901AbaAHGpw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 8 Jan 2014 01:45:52 -0500
Received: from mail-oa0-f53.google.com ([209.85.219.53]:36245 "EHLO
	mail-oa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752078AbaAHGpn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 8 Jan 2014 01:45:43 -0500
MIME-Version: 1.0
Date: Wed, 8 Jan 2014 14:45:42 +0800
Message-ID: <CANthSfYiQZXJ46SsbeqSS2eMHMLu7t+NOnCQd87BwvhcYp8aUA@mail.gmail.com>
Subject: [PATCH] usb:hub set hub->change_bits when over-current happens
From: Shen Guang <shenguang10@gmail.com>
To: Greg KH <gregkh@linuxfoundation.org>
Cc: linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Content-Type: text/plain; charset=ISO-8859-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

When we are doing compliance test with xHCI, we found that if we
enable CONFIG_USB_SUSPEND and plug in a bad device which causes
over-current condition to the root port, software will not be noticed.
The reason is that current code don't set hub->change_bits in
hub_activate() when over-current happens, and then hub_events() will
not check the port status because it thinks nothing changed.
If CONFIG_USB_SUSPEND is disabled, the interrupt pipe of the hub will
report the change and set hub->event_bits, and then hub_events() will
check what events happened.In this case over-current can be detected.

Signed-off-by: Shen Guang <shenguang10@gmail.com>
---
 drivers/usb/core/hub.c |    3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/core/hub.c b/drivers/usb/core/hub.c
index bd9dc35..98b5679 100644
--- a/drivers/usb/core/hub.c
+++ b/drivers/usb/core/hub.c
@@ -1154,7 +1154,8 @@ static void hub_activate(struct usb_hub *hub,
enum hub_activation_type type)
                        /* Tell khubd to disconnect the device or
                         * check for a new connection
                         */
-                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION))
+                       if (udev || (portstatus & USB_PORT_STAT_CONNECTION) ||
+                               (portstatus & USB_PORT_STAT_OVERCURRENT))
                                set_bit(port1, hub->change_bits);

                } else if (portstatus & USB_PORT_STAT_ENABLE) {
--
1.7.9.5

--
To unsubscribe from this list: send the line "unsubscribe linux-usb" in
the body of a message to majordomo@vger.kernel.org
More majordomo info at  http://vger.kernel.org/majordomo-info.html
