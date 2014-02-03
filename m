Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752974AbaBCP3S (ORCPT <rfc822;w@1wt.eu>);
	Mon, 3 Feb 2014 10:29:18 -0500
Received: from mail-ie0-f178.google.com ([209.85.223.178]:53510 "EHLO
	mail-ie0-f178.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752465AbaBCP3R (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 3 Feb 2014 10:29:17 -0500
From: Matt Porter <mporter@linaro.org>
To: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: Linux USB List <linux-usb@vger.kernel.org>,
        Linux Kernel Mailing List <linux-kernel@vger.kernel.org>
Subject: [PATCH] usb: gadget: s3c-hsotg: fix build on x86 and other architectures
Date: Mon,  3 Feb 2014 10:29:09 -0500
Message-Id: <1391441349-15887-1-git-send-email-mporter@linaro.org>
X-Mailer: git-send-email 1.8.4
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The readsl and writesl I/O accessors are only defined on some
architectures. The driver currently depends on CONFIG_ARM because
the build breaks on x86, in particular. Switch to use of ioread32_rep
and iowrite32_rep to fix build on all architectures and remove the
CONFIG_ARM dependency.

Also update printk formatting to handle a long long dma_addr_t to avoid
warnings on !32-bit architectures.

Signed-off-by: Matt Porter <mporter@linaro.org>
---
 drivers/usb/gadget/Kconfig     |  1 -
 drivers/usb/gadget/s3c-hsotg.c | 12 ++++++------
 2 files changed, 6 insertions(+), 7 deletions(-)

diff --git a/drivers/usb/gadget/Kconfig b/drivers/usb/gadget/Kconfig
index 8154165..782f43a 100644
--- a/drivers/usb/gadget/Kconfig
+++ b/drivers/usb/gadget/Kconfig
@@ -301,7 +301,6 @@ config USB_PXA27X
 	   gadget drivers to also be dynamically linked.
 
 config USB_S3C_HSOTG
-	depends on ARM
 	tristate "Designware/S3C HS/OtG USB Device controller"
 	help
 	  The Designware USB2.0 high-speed gadget controller
diff --git a/drivers/usb/gadget/s3c-hsotg.c b/drivers/usb/gadget/s3c-hsotg.c
index 1172eae..0449b76 100644
--- a/drivers/usb/gadget/s3c-hsotg.c
+++ b/drivers/usb/gadget/s3c-hsotg.c
@@ -617,7 +617,7 @@ static int s3c_hsotg_write_fifo(struct s3c_hsotg *hsotg,
 	to_write = DIV_ROUND_UP(to_write, 4);
 	data = hs_req->req.buf + buf_pos;
 
-	writesl(hsotg->regs + EPFIFO(hs_ep->index), data, to_write);
+	iowrite32_rep(hsotg->regs + EPFIFO(hs_ep->index), data, to_write);
 
 	return (to_write >= can_write) ? -ENOSPC : 0;
 }
@@ -720,8 +720,8 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 		ureq->length, ureq->actual);
 	if (0)
 		dev_dbg(hsotg->dev,
-			"REQ buf %p len %d dma 0x%08x noi=%d zp=%d snok=%d\n",
-			ureq->buf, length, ureq->dma,
+			"REQ buf %p len %d dma 0x%08llx noi=%d zp=%d snok=%d\n",
+			ureq->buf, length, (unsigned long long)ureq->dma,
 			ureq->no_interrupt, ureq->zero, ureq->short_not_ok);
 
 	maxreq = get_ep_limit(hs_ep);
@@ -789,8 +789,8 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 		dma_reg = dir_in ? DIEPDMA(index) : DOEPDMA(index);
 		writel(ureq->dma, hsotg->regs + dma_reg);
 
-		dev_dbg(hsotg->dev, "%s: 0x%08x => 0x%08x\n",
-			__func__, ureq->dma, dma_reg);
+		dev_dbg(hsotg->dev, "%s: 0x%08llx => 0x%08x\n",
+			__func__, (unsigned long long)ureq->dma, dma_reg);
 	}
 
 	ctrl |= DxEPCTL_EPEna;	/* ensure ep enabled */
@@ -1488,7 +1488,7 @@ static void s3c_hsotg_rx_data(struct s3c_hsotg *hsotg, int ep_idx, int size)
 	 * note, we might over-write the buffer end by 3 bytes depending on
 	 * alignment of the data.
 	 */
-	readsl(fifo, hs_req->req.buf + read_ptr, to_read);
+	ioread32_rep(fifo, hs_req->req.buf + read_ptr, to_read);
 }
 
 /**
-- 
1.8.4

