Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752798Ab3KSWu5 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 19 Nov 2013 17:50:57 -0500
Received: from seketeli.net ([91.121.166.71]:39974 "EHLO ms.seketeli.net"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751723Ab3KSWuz (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 19 Nov 2013 17:50:55 -0500
X-Greylist: delayed 1978 seconds by postgrey-1.27 at vger.kernel.org; Tue, 19 Nov 2013 17:50:55 EST
From: Apelete Seketeli <apelete@seketeli.net>
To: linux-usb@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Felipe Balbi <balbi@ti.com>,
        Lars-Peter Clausen <lars@metafoo.de>
Subject: [PATCH v2 1/1] usb: fix musb gadget to enable OTG mode conditionally
Date: Tue, 19 Nov 2013 23:18:20 +0100
Message-Id: <1384899500-30307-2-git-send-email-apelete@seketeli.net>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1384899500-30307-1-git-send-email-apelete@seketeli.net>
References: <1384899500-30307-1-git-send-email-apelete@seketeli.net>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The musb driver is usable in host, gadget or dual role mode depending
on the kernel configuration.
However, the musb gadget part of the driver is enabling OTG mode
whether the driver is built for dual role or gadget only mode. This
induces a bug for gadget only USB device controllers where the kernel
tries to use Host Negotiation Protocol with such controllers, which
causes a panic.
This behaviour is now fixed by enabling OTG mode only when musb driver
is built for dual role mode.

Signed-off-by: Apelete Seketeli <apelete@seketeli.net>
---
 drivers/usb/musb/musb_gadget.c |    4 ++++
 1 file changed, 4 insertions(+)

diff --git a/drivers/usb/musb/musb_gadget.c b/drivers/usb/musb/musb_gadget.c
index 3671898..5bcd9d6 100644
--- a/drivers/usb/musb/musb_gadget.c
+++ b/drivers/usb/musb/musb_gadget.c
@@ -1796,7 +1796,11 @@ int musb_gadget_setup(struct musb *musb)
 
 	/* this "gadget" abstracts/virtualizes the controller */
 	musb->g.name = musb_driver_name;
+#if IS_ENABLED(CONFIG_USB_MUSB_DUAL_ROLE)
 	musb->g.is_otg = 1;
+#elif IS_ENABLED(CONFIG_USB_MUSB_GADGET)
+	musb->g.is_otg = 0;
+#endif
 
 	musb_g_init_endpoints(musb);
 
-- 
1.7.10.4

