Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754136AbaKFXP4 (ORCPT <rfc822;w@1wt.eu>);
	Thu, 6 Nov 2014 18:15:56 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:58625 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752224AbaKFWkN (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 6 Nov 2014 17:40:13 -0500
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Jack Pham <jackp@codeaurora.org>, Felipe Balbi <balbi@ti.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.13 136/162] usb: dwc3: gadget: Properly initialize LINK TRB
Date: Thu,  6 Nov 2014 14:36:40 -0800
Message-Id: <1415313426-9622-137-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1415313426-9622-1-git-send-email-kamal@canonical.com>
References: <1415313426-9622-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.13
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13.11.11 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Jack Pham <jackp@codeaurora.org>

commit 1200a82a59b6aa65758ccc92c3447b98c53cd7a2 upstream.

On ISOC endpoints the last trb_pool entry used as a
LINK TRB is not getting zeroed out correctly due to
memset being called incorrectly and in the wrong place.
If pool allocated from DMA was not zero-initialized
to begin with this will result in the size and ctrl
values being random garbage. Call memset correctly after
assignment of the trb_link pointer.

Fixes: f6bafc6a1c ("usb: dwc3: convert TRBs into bitshifts")
Signed-off-by: Jack Pham <jackp@codeaurora.org>
Signed-off-by: Felipe Balbi <balbi@ti.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/usb/dwc3/gadget.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 27b9c8a..20e4d2e 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -532,12 +532,11 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep,
 		if (!usb_endpoint_xfer_isoc(desc))
 			return 0;
 
-		memset(&trb_link, 0, sizeof(trb_link));
-
 		/* Link TRB for ISOC. The HWO bit is never reset */
 		trb_st_hw = &dep->trb_pool[0];
 
 		trb_link = &dep->trb_pool[DWC3_TRB_NUM - 1];
+		memset(trb_link, 0, sizeof(*trb_link));
 
 		trb_link->bpl = lower_32_bits(dwc3_trb_dma_offset(dep, trb_st_hw));
 		trb_link->bph = upper_32_bits(dwc3_trb_dma_offset(dep, trb_st_hw));
-- 
1.9.1

