Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753415Ab3LNDsm (ORCPT <rfc822;w@1wt.eu>);
	Fri, 13 Dec 2013 22:48:42 -0500
Received: from seketeli.net ([91.121.166.71]:48108 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1753228Ab3LNDsk (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 13 Dec 2013 22:48:40 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH 3/3] usb: musb: fix setting JZ4740 gadget periphal mode on reset
Date: Sat, 14 Dec 2013 04:48:38 +0100
Message-Id: <1386992918-1531-4-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1386992918-1531-1-git-send-email-apelete@seketeli.net>
References: <1386992918-1531-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JZ4740 USB Device Controller is not OTG compatible and does not have DEVCTL
register in silicon.

During ethernet-over-usb transactions, on reset, musb driver tries to
read from DEVCTL and consequently sets device as host (A-Device)
instead of peripheral (B-Device), which makes it a composite device to
the USB gadget driver.
This induces a kernel panic during power down where the USB gadget
driver does a null pointer dereference when trying to access the
composite device configuration.

On reset, do not rely on DEVCTL value for setting gadget peripheral
mode: hardcode it instead to B-Device.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
---
 drivers/usb/musb/musb_gadget.c |    9 +++++++++
 1 file changed, 9 insertions(+)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 32fb057..b4bea7a 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -2119,6 +2119,14 @@ __acquires(musb->lock)
 	/* Normal reset, as B-Device;
 	 * or else after HNP, as A-Device
 	 */
+#if defined(CONFIG_USB_MUSB_JZ4740) || defined(CONFIG_USB_MUSB_JZ4740_MODULE)
+	/* JZ4740 UDC Controller is not OTG compatible and does not
+	 * have DEVCTL register in silicon: do not rely on devctl for
+	 * setting peripheral mode.
+	 */
+	musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+	musb->g.is_a_peripheral = 0;
+#else
 	if (devctl & MUSB_DEVCTL_BDEVICE) {
 		musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
 		musb->g.is_a_peripheral = 0;
@@ -2126,6 +2134,7 @@ __acquires(musb->lock)
 		musb->xceiv->state = OTG_STATE_A_PERIPHERAL;
 		musb->g.is_a_peripheral = 1;
 	}
+#endif
 
 	/* start with default limits on VBUS power draw */
 	(void) musb_gadget_vbus_draw(&musb->g, 8);
-- 
1.7.10.4

