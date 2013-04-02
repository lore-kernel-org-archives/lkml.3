Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1761163Ab3DBLSY (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 07:18:24 -0400
Received: from mail-pd0-f172.google.com ([209.85.192.172]:51598 "EHLO
	mail-pd0-f172.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1760738Ab3DBLSW (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 07:18:22 -0400
From: Yuan-Hsin Chen <yuanlmm@gmail.com>
To: balbi@ti.com, gregkh@linuxfoundation.org, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: Yuan-Hsin Chen <yhchen@faraday-tech.com>
Subject: [PATCH v2 2/2] usb: gadget: fusb300_udc: bug fix of not doing idma reset for each time
Date: Tue,  2 Apr 2013 11:18:08 +0000
Message-Id: <1364901488-21578-1-git-send-email-yhchen@faraday-tech.com>
X-Mailer: git-send-email 1.7.4.1
In-Reply-To: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
References: <1361516979-7340-1-git-send-email-yhchen@faraday-tech.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Enter IDMA_RESET only when the controller has been reset or
the device has been plugged in to or out from a host. In
IDMA_RESET, we should disable the corresponding PRD interrupt.
Also there is a redundant space eliminated.

fusb300_udc driver is tested on FARADAY platform a369 with
FUSB300 FPGA v1.8

Signed-off-by: Yuan-Hsin Chen <yhchen@faraday-tech.com>
---

v2:
split patch

 drivers/usb/gadget/fusb300_udc.c |    9 ++++++---
 1 files changed, 6 insertions(+), 3 deletions(-)

diff --git a/drivers/usb/gadget/fusb300_udc.c b/drivers/usb/gadget/fusb300_udc.c
index c20cc58..c4dc906 100644
--- a/drivers/usb/gadget/fusb300_udc.c
+++ b/drivers/usb/gadget/fusb300_udc.c
@@ -930,12 +930,15 @@ static void fusb300_wait_idma_finished(struct fusb300_ep *ep)
 
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
 
-static void  fusb300_set_idma(struct fusb300_ep *ep,
+static void fusb300_set_idma(struct fusb300_ep *ep,
 			struct fusb300_request *req)
 {
 	dma_addr_t d;
-- 
1.7.4.1

