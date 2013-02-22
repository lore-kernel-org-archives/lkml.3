Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754270Ab3BVHKA (ORCPT <rfc822;w@1wt.eu>);
	Fri, 22 Feb 2013 02:10:00 -0500
Received: from mail-pa0-f41.google.com ([209.85.220.41]:38676 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753193Ab3BVHJ6 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 22 Feb 2013 02:09:58 -0500
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Yuan-Hsin Chen <yuanlmm@gmail.com>,
        Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH] fusb300_udc: modify stall clear and idma reset procedure
Date: Fri, 22 Feb 2013 07:09:39 +0000
Message-Id: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
X-Mailer: git-send-email 1.7.4.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Yuan-Hsin Chen <yuanlmm@gmail.com>

Due to fusb300 controller modification, stall clear procedure should be
modified consistantly. This patch also fixes software bugs: only
enter IDMA_RESET when the condition matched and disable corresponding
PRD interrupt in IDMA_RESET.


Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
---
 drivers/usb/gadget/fusb300_udc.c |    9 ++++++---
 drivers/usb/gadget/fusb300_udc.h |    2 +-
 2 files changed, 7 insertions(+), 4 deletions(-)

diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index 72cd5e6..109cab1 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -394,7 +394,7 @@ static void fusb300_clear_epnstall(struct fusb300 *fusb300, u8 ep)
 
 	if (reg & FUSB300_EPSET0_STL) {
 		printk(KERN_DEBUG "EP%d stall... Clear!!\n", ep);
-		reg &= ~FUSB300_EPSET0_STL;
+		reg |= FUSB300_EPSET0_STL_CLR;
 		iowrite32(reg, fusb300->reg + FUSB300_OFFSET_EPSET0(ep));
 	}
 }
@@ -930,9 +930,12 @@ static void fusb300_wait_idma_finished(struct fusb300_ep *ep)
 
 	fusb300_clear_int(ep->fusb300, FUSB300_OFFSET_IGR0,
 		FUSB300_IGR0_EPn_PRD_INT(ep->epnum));
+	return;
+
 IDMA_RESET:
-	fusb300_clear_int(ep->fusb300, FUSB300_OFFSET_IGER0,
-		FUSB300_IGER0_EEPn_PRD_INT(ep->epnum));
+	reg = ioread32(ep->fusb300->reg + FUSB300_OFFSET_IGER0);
+	reg &= ~FUSB300_IGER0_EEPn_PRD_INT(ep->epnum);
+	iowrite32(reg, ep->fusb300->reg + FUSB300_OFFSET_IGER0);
 }
 
 static void  fusb300_set_idma(struct fusb300_ep *ep,
diff --git a/drivers/usb/gadget/fusb300_udc.h b/drivers/usb/gadget/fusb300_udc.h
index 542cd83..ccae1b5 100644
--- a/drivers/usb/gadget/fusb300_udc.h
+++ b/drivers/usb/gadget/fusb300_udc.h
@@ -111,8 +111,8 @@
 /*
  * * EPn Setting 0 (EPn_SET0, offset = 020H+(n-1)*30H, n=1~15 )
  * */
+#define FUSB300_EPSET0_STL_CLR		(1 << 3)
 #define FUSB300_EPSET0_CLRSEQNUM	(1 << 2)
-#define FUSB300_EPSET0_EPn_TX0BYTE	(1 << 1)
 #define FUSB300_EPSET0_STL		(1 << 0)
 
 /*
-- 
1.7.4.1

