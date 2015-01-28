Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965545AbbA1Er0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 Jan 2015 23:47:26 -0500
Received: from mail.kernel.org ([198.145.29.136]:40189 "EHLO mail.kernel.org"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S934298AbbA1EXE (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 Jan 2015 23:23:04 -0500
From: lizf@kernel.org
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, Jack Pham <jackp@codeaurora.org>,
        Felipe Balbi <balbi@ti.com>, Zefan Li <lizefan@huawei.com>
Subject: [PATCH 3.4 103/177] usb: dwc3: gadget: Properly initialize LINK TRB
Date: Wed, 28 Jan 2015 12:09:21 +0800
Message-Id: <1422418236-12852-194-git-send-email-lizf@kernel.org>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1422418050-12581-1-git-send-email-lizf@kernel.org>
References: <1422418050-12581-1-git-send-email-lizf@kernel.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jack Pham <jackp@codeaurora.org>

3.4.106-rc1 review patch.  If anyone has any objections, please let me know.

------------------


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
Signed-off-by: Zefan Li <lizefan@huawei.com>
---
 drivers/usb/dwc3/gadget.c | 3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

diff --git a/drivers/usb/dwc3/gadget.c b/drivers/usb/dwc3/gadget.c
index 3ceb8da..1acb3a4 100644
--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -485,12 +485,11 @@ static int __dwc3_gadget_ep_enable(struct dwc3_ep *dep,
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

