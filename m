Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756558Ab3LSUnE (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 15:43:04 -0500
Received: from seketeli.net ([91.121.166.71]:47965 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1756376Ab3LSUm3 (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 15:42:29 -0500
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v3 2/2] usb: musb: fix setting JZ4740 gadget periphal mode on reset
Date: Thu, 19 Dec 2013 21:42:27 +0100
Message-Id: <1387485747-25759-3-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1387485747-25759-1-git-send-email-apelete@seketeli.net>
References: <1387485747-25759-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

JZ4740 USB Device Controller is not OTG compatible and does not have
DEVCTL register in silicon.

During ethernet-over-usb transactions, on reset, musb driver tries to
read from DEVCTL and consequently sets device as host (A-Device)
instead of peripheral (B-Device), which makes it a composite device to
the USB gadget driver.
This induces a kernel panic during power down where the USB gadget
driver does a null pointer dereference when trying to access the
composite device configuration.

On reset, do not rely on DEVCTL value for setting gadget peripheral
mode. Use is_otg flag instead to set it to B-Device.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
---
 drivers/usb/musb/musb_gadget.c |   10 +++++++++-
 1 file changed, 9 insertions(+), 1 deletion(-)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index c410a7f..d4aa779 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -2119,7 +2119,15 @@ __acquires(musb->lock)
 	/* Normal reset, as B-Device;
 	 * or else after HNP, as A-Device
 	 */
-	if (devctl & MUSB_DEVCTL_BDEVICE) {
+	if (!musb->g.is_otg) {
+		/* USB device controllers that are not OTG compatible
+		 * may not have DEVCTL register in silicon.
+		 * In that case, do not rely on devctl for setting
+		 * peripheral mode.
+		 */
+		musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
+		musb->g.is_a_peripheral = 0;
+	} else if (devctl & MUSB_DEVCTL_BDEVICE) {
 		musb->xceiv->state = OTG_STATE_B_PERIPHERAL;
 		musb->g.is_a_peripheral = 0;
 	} else {
-- 
1.7.10.4

