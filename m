Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S966814AbaKLB5A (ORCPT <rfc822;w@1wt.eu>);
	Tue, 11 Nov 2014 20:57:00 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:33183 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S966800AbaKLB44 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 11 Nov 2014 20:56:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Jack Pham <jackp@codeaurora.org>, Felipe Balbi <balbi@ti.com>
Subject: [PATCH 3.10 090/123] usb: dwc3: gadget: Properly initialize LINK TRB
Date: Wed, 12 Nov 2014 10:17:36 +0900
Message-Id: <20141112011723.088922972@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141112011718.985171261@linuxfoundation.org>
References: <20141112011718.985171261@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=ISO-8859-15
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.10-stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/usb/dwc3/gadget.c |    3 +--
 1 file changed, 1 insertion(+), 2 deletions(-)

--- a/drivers/usb/dwc3/gadget.c
+++ b/drivers/usb/dwc3/gadget.c
@@ -550,12 +550,11 @@ static int __dwc3_gadget_ep_enable(struc
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


