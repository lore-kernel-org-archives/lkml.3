Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752044AbaK1NwC (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Nov 2014 08:52:02 -0500
Received: from mail-la0-f43.google.com ([209.85.215.43]:46861 "EHLO
	mail-la0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751942AbaK1NvZ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Nov 2014 08:51:25 -0500
From: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>,
        Peter Chen <peter.chen@freescale.com>,
        Andrzej Pietrasiewicz <andrzej.p@samsung.com>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org
Subject: [PATCH 16/17] net2280: Move ASSERT_OUT_NAKING into out_flush
Date: Fri, 28 Nov 2014 14:51:01 +0100
Message-Id: <1417182662-7405-17-git-send-email-ricardo.ribalda@gmail.com>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
References: <1417182662-7405-1-git-send-email-ricardo.ribalda@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

ASSERT_OUT_NAKING was only called by out_flush and was hidden behind a
ifdef.

This patch moves the inline function into out_flush and remove the
ifdef. The user can decide to print the debug message or not via dynamic
printk

Signed-off-by: Ricardo Ribalda Delgado <ricardo.ribalda@gmail.com>
---
 drivers/usb/gadget/udc/net2280.c | 10 ++++++++--
 drivers/usb/gadget/udc/net2280.h | 17 -----------------
 2 files changed, 8 insertions(+), 19 deletions(-)

diff --git a/drivers/usb/gadget/udc/net2280.c b/drivers/usb/gadget/udc/net2280.c
index a978e6e..b1c253e 100644
--- a/drivers/usb/gadget/udc/net2280.c
+++ b/drivers/usb/gadget/udc/net2280.c
@@ -575,9 +575,15 @@ static void out_flush(struct net2280_ep *ep)
 	u32	__iomem *statp;
 	u32	tmp;
 
-	ASSERT_OUT_NAKING(ep);
-
 	statp = &ep->regs->ep_stat;
+
+	tmp = readl(statp);
+	if (tmp & BIT(NAK_OUT_PACKETS)) {
+		ep_dbg(ep->dev, "%s %s %08x !NAK\n",
+			ep->ep.name, __func__, tmp);
+		writel(BIT(SET_NAK_OUT_PACKETS), &ep->regs->ep_rsp);
+	}
+
 	writel(BIT(DATA_OUT_PING_TOKEN_INTERRUPT) |
 		BIT(DATA_PACKET_RECEIVED_INTERRUPT),
 		statp);
diff --git a/drivers/usb/gadget/udc/net2280.h b/drivers/usb/gadget/udc/net2280.h
index b31deb0..a307dce 100644
--- a/drivers/usb/gadget/udc/net2280.h
+++ b/drivers/usb/gadget/udc/net2280.h
@@ -356,23 +356,6 @@ static inline void start_out_naking(struct net2280_ep *ep)
 	readl(&ep->regs->ep_rsp);
 }
 
-#ifdef DEBUG
-static inline void assert_out_naking(struct net2280_ep *ep, const char *where)
-{
-	u32	tmp = readl(&ep->regs->ep_stat);
-
-	if ((tmp & BIT(NAK_OUT_PACKETS)) == 0) {
-		ep_dbg(ep->dev, "%s %s %08x !NAK\n",
-				ep->ep.name, where, tmp);
-		writel(BIT(SET_NAK_OUT_PACKETS),
-			&ep->regs->ep_rsp);
-	}
-}
-#define ASSERT_OUT_NAKING(ep) assert_out_naking(ep, __func__)
-#else
-#define ASSERT_OUT_NAKING(ep) do {} while (0)
-#endif
-
 static inline void stop_out_naking(struct net2280_ep *ep)
 {
 	u32	tmp;
-- 
2.1.3

