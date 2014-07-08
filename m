Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753900AbaGHOzK (ORCPT <rfc822;w@1wt.eu>);
	Tue, 8 Jul 2014 10:55:10 -0400
Received: from mailout4.samsung.com ([203.254.224.34]:51321 "EHLO
	mailout4.samsung.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751566AbaGHOzH (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 8 Jul 2014 10:55:07 -0400
X-AuditID: cbfee61b-f79f86d00000144c-dd-53bc0649eaaf
From: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
To: Paul Zimmerman <paulz@synopsys.com>
Cc: Felipe Balbi <balbi@ti.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Ben Dooks <ben.dooks@codethink.co.uk>,
        Robert Baldyga <r.baldyga@samsung.com>,
        Kyungmin Park <kyungmin.park@samsung.com>, linux-usb@vger.kernel.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH] usb: dwc2: remove incomplete DMA support from gadget code
Date: Tue, 08 Jul 2014 16:54:41 +0200
Message-id: <2181126.aCTfeXMESu@amdc1032>
User-Agent: KMail/4.8.4 (Linux/3.2.0-54-generic-pae; KDE/4.8.5; i686; ; )
MIME-version: 1.0
Content-transfer-encoding: 7Bit
Content-type: text/plain; charset=us-ascii
X-Brightmail-Tracker: H4sIAAAAAAAAA+NgFjrLLMWRmVeSWpSXmKPExsVy+t9jQV1Ptj3BBrsbRCwO3q+3eHCrlcmi
	efF6NouzTW/YLS7vmsNmsWhZK7PF9inTmSweHN7J7sDh8ezlZCaP/XPXsHv0bVnF6LFl/2dG
	j+M3tjN5fN4kF8AWxWWTkpqTWZZapG+XwJVx/cZF9oL1aRUvrq5ibmA8G9DFyMEhIWAicetT
	YhcjJ5ApJnHh3nq2LkYuDiGB6YwSex6cY4RwWpgkJj9axwZSxSZgJTGxfRUjiC0ioC6x4vk9
	dpAiZoFuJol93xvAioQFvCS+bX8FZrMIqErMOjKJHcTmFdCUuHj5NwuILSrgKbFj+0o2iLig
	xI/J98DizALyEvv2T2WFsLUk1u88zjSBkW8WkrJZSMpmISlbwMi8ilE0tSC5oDgpPddIrzgx
	t7g0L10vOT93EyM4kJ9J72Bc1WBxiFGAg1GJh3fFwV3BQqyJZcWVuYcYJTiYlUR4v5zaHSzE
	m5JYWZValB9fVJqTWnyIUZqDRUmc92CrdaCQQHpiSWp2ampBahFMlomDU6qBUdFe9ppWzIRl
	p1vKpu/gvPpf1tij8fUPW88Cpo7Lns3OS37scnrbssQvtFlMlf+kuPMLRZv9ZYs3TDv+w/T5
	nZ3aPTxhnxNSt890vj2jW0jzaVvHm/DckpUr3NoqfT8vsQ6el19w59Rkw+QZOkW+9fdcDshJ
	PPoe9ZBTq2IFg+OnrNVLozpvKLEUZyQaajEXFScCAMT0d09gAgAA
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The commit 5b7d70c6dbf2 ("USB: Gadget driver for Samsung HS/OtG
block") which added this driver also introduced the inactive DMA
support (due to hardware limitations of DMA buffers alignment).
It has been a dead code for over 5 years and should be removed.

We don't keep the unused/untested features in the kernel.  Such
code has a real maintainance cost (all other changes have to take
dead code into account), i.e. https://lkml.org/lkml/2014/5/6/461.
Also all the removed dead code is still accessible in the kernel
git repository and can be easily brought back if/when needed.

There should be no functional changes caused by this patch.

Signed-off-by: Bartlomiej Zolnierkiewicz <b.zolnierkie@samsung.com>
Acked-by: Kyungmin Park <kyungmin.park@samsung.com>
---
 drivers/usb/dwc2/gadget.c | 210 +++-------------------------------------------
 1 file changed, 12 insertions(+), 198 deletions(-)

diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index f3c56a2..d252355 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -21,7 +21,6 @@
 #include <linux/spinlock.h>
 #include <linux/interrupt.h>
 #include <linux/platform_device.h>
-#include <linux/dma-mapping.h>
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/delay.h>
@@ -69,30 +68,6 @@ static inline void __bic32(void __iomem *ptr, u32 val)
 static void s3c_hsotg_dump(struct s3c_hsotg *hsotg);
 
 /**
- * using_dma - return the DMA status of the driver.
- * @hsotg: The driver state.
- *
- * Return true if we're using DMA.
- *
- * Currently, we have the DMA support code worked into everywhere
- * that needs it, but the AMBA DMA implementation in the hardware can
- * only DMA from 32bit aligned addresses. This means that gadgets such
- * as the CDC Ethernet cannot work as they often pass packets which are
- * not 32bit aligned.
- *
- * Unfortunately the choice to use DMA or not is global to the controller
- * and seems to be only settable when the controller is being put through
- * a core reset. This means we either need to fix the gadgets to take
- * account of DMA alignment, or add bounce buffers (yuerk).
- *
- * Until this issue is sorted out, we always return 'false'.
- */
-static inline bool using_dma(struct s3c_hsotg *hsotg)
-{
-	return false;	/* support is not complete */
-}
-
-/**
  * s3c_hsotg_en_gsint - enable one or more of the general interrupt
  * @hsotg: The device state
  * @ints: A bitmask of the interrupts to enable
@@ -260,28 +235,6 @@ static inline int is_ep_periodic(struct s3c_hsotg_ep *hs_ep)
 }
 
 /**
- * s3c_hsotg_unmap_dma - unmap the DMA memory being used for the request
- * @hsotg: The device state.
- * @hs_ep: The endpoint for the request
- * @hs_req: The request being processed.
- *
- * This is the reverse of s3c_hsotg_map_dma(), called for the completion
- * of a request to ensure the buffer is ready for access by the caller.
- */
-static void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
-				struct s3c_hsotg_ep *hs_ep,
-				struct s3c_hsotg_req *hs_req)
-{
-	struct usb_request *req = &hs_req->req;
-
-	/* ignore this if we're not moving any data */
-	if (hs_req->req.length == 0)
-		return;
-
-	usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->dir_in);
-}
-
-/**
  * s3c_hsotg_write_fifo - write packet Data to the TxFIFO
  * @hsotg: The controller state.
  * @hs_ep: The endpoint we're going to write for.
@@ -609,21 +562,6 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 	/* write size / packets */
 	writel(epsize, hsotg->regs + epsize_reg);
 
-	if (using_dma(hsotg) && !continuing) {
-		unsigned int dma_reg;
-
-		/*
-		 * write DMA address to control register, buffer already
-		 * synced by s3c_hsotg_ep_queue().
-		 */
-
-		dma_reg = dir_in ? DIEPDMA(index) : DOEPDMA(index);
-		writel(ureq->dma, hsotg->regs + dma_reg);
-
-		dev_dbg(hsotg->dev, "%s: %pad => 0x%08x\n",
-			__func__, &ureq->dma, dma_reg);
-	}
-
 	ctrl |= DXEPCTL_EPENA;	/* ensure ep enabled */
 	ctrl |= DXEPCTL_USBACTEP;
 
@@ -639,15 +577,10 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 	dev_dbg(hsotg->dev, "%s: DxEPCTL=0x%08x\n", __func__, ctrl);
 	writel(ctrl, hsotg->regs + epctrl_reg);
 
-	/*
-	 * set these, it seems that DMA support increments past the end
-	 * of the packet buffer so we need to calculate the length from
-	 * this information.
-	 */
 	hs_ep->size_loaded = length;
 	hs_ep->last_load = ureq->actual;
 
-	if (dir_in && !using_dma(hsotg)) {
+	if (dir_in) {
 		/* set these anyway, we may need them for non-periodic in */
 		hs_ep->fifo_load = 0;
 
@@ -680,42 +613,6 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
 	s3c_hsotg_ctrl_epint(hsotg, hs_ep->index, hs_ep->dir_in, 1);
 }
 
-/**
- * s3c_hsotg_map_dma - map the DMA memory being used for the request
- * @hsotg: The device state.
- * @hs_ep: The endpoint the request is on.
- * @req: The request being processed.
- *
- * We've been asked to queue a request, so ensure that the memory buffer
- * is correctly setup for DMA. If we've been passed an extant DMA address
- * then ensure the buffer has been synced to memory. If our buffer has no
- * DMA memory, then we map the memory and mark our request to allow us to
- * cleanup on completion.
- */
-static int s3c_hsotg_map_dma(struct s3c_hsotg *hsotg,
-			     struct s3c_hsotg_ep *hs_ep,
-			     struct usb_request *req)
-{
-	struct s3c_hsotg_req *hs_req = our_req(req);
-	int ret;
-
-	/* if the length is zero, ignore the DMA data */
-	if (hs_req->req.length == 0)
-		return 0;
-
-	ret = usb_gadget_map_request(&hsotg->gadget, req, hs_ep->dir_in);
-	if (ret)
-		goto dma_error;
-
-	return 0;
-
-dma_error:
-	dev_err(hsotg->dev, "%s: failed to map buffer %p, %d bytes\n",
-		__func__, req->buf, req->length);
-
-	return -EIO;
-}
-
 static int s3c_hsotg_ep_queue(struct usb_ep *ep, struct usb_request *req,
 			      gfp_t gfp_flags)
 {
@@ -733,13 +630,6 @@ static int s3c_hsotg_ep_queue(struct usb_ep *ep, struct usb_request *req,
 	req->actual = 0;
 	req->status = -EINPROGRESS;
 
-	/* if we're using DMA, sync the buffers as necessary */
-	if (using_dma(hs)) {
-		int ret = s3c_hsotg_map_dma(hs, hs_ep, req);
-		if (ret)
-			return ret;
-	}
-
 	first = list_empty(&hs_ep->queue);
 	list_add_tail(&hs_req->queue, &hs_ep->queue);
 
@@ -1236,9 +1126,6 @@ static void s3c_hsotg_complete_request(struct s3c_hsotg *hsotg,
 	hs_ep->req = NULL;
 	list_del_init(&hs_req->queue);
 
-	if (using_dma(hsotg))
-		s3c_hsotg_unmap_dma(hsotg, hs_ep, hs_req);
-
 	/*
 	 * call the complete request with the locks off, just in case the
 	 * request tries to queue more work for this endpoint.
@@ -1397,24 +1284,6 @@ static void s3c_hsotg_handle_outdone(struct s3c_hsotg *hsotg,
 		return;
 	}
 
-	if (using_dma(hsotg)) {
-		unsigned size_done;
-
-		/*
-		 * Calculate the size of the transfer by checking how much
-		 * is left in the endpoint size register and then working it
-		 * out from the amount we loaded for the transfer.
-		 *
-		 * We need to do this as DMA pointers are always 32bit aligned
-		 * so may overshoot/undershoot the transfer.
-		 */
-
-		size_done = hs_ep->size_loaded - size_left;
-		size_done += hs_ep->last_load;
-
-		req->actual = size_done;
-	}
-
 	/* if there is more request to do, schedule new transfer */
 	if (req->actual < req->length && size_left == 0) {
 		s3c_hsotg_start_req(hsotg, hs_ep, hs_req, true);
@@ -1477,18 +1346,12 @@ static u32 s3c_hsotg_read_frameno(struct s3c_hsotg *hsotg)
  * The RXFIFO is a true FIFO, the packets coming out are still in packet
  * chunks, so if you have x packets received on an endpoint you'll get x
  * FIFO events delivered, each with a packet's worth of data in it.
- *
- * When using DMA, we should not be processing events from the RXFIFO
- * as the actual data should be sent to the memory directly and we turn
- * on the completion interrupts to get notifications of transfer completion.
  */
 static void s3c_hsotg_handle_rx(struct s3c_hsotg *hsotg)
 {
 	u32 grxstsr = readl(hsotg->regs + GRXSTSP);
 	u32 epnum, status, size;
 
-	WARN_ON(using_dma(hsotg));
-
 	epnum = grxstsr & GRXSTS_EPNUM_MASK;
 	status = grxstsr & GRXSTS_PKTSTS_MASK;
 
@@ -1508,8 +1371,7 @@ static void s3c_hsotg_handle_rx(struct s3c_hsotg *hsotg)
 		dev_dbg(hsotg->dev, "OutDone (Frame=0x%08x)\n",
 			s3c_hsotg_read_frameno(hsotg));
 
-		if (!using_dma(hsotg))
-			s3c_hsotg_handle_outdone(hsotg, epnum, false);
+		s3c_hsotg_handle_outdone(hsotg, epnum, false);
 		break;
 
 	case GRXSTS_PKTSTS_SETUPDONE:
@@ -1720,10 +1582,6 @@ static void s3c_hsotg_complete_in(struct s3c_hsotg *hsotg,
 	 * Calculate the size of the transfer by checking how much is left
 	 * in the endpoint size register and then working it out from
 	 * the amount we loaded for the transfer.
-	 *
-	 * We do this even for DMA, as the transfer may have incremented
-	 * past the end of the buffer (DMA transfers are always 32bit
-	 * aligned).
 	 */
 
 	size_left = DXEPTSIZ_XFERSIZE_GET(epsize);
@@ -1816,13 +1674,6 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 
 			if (idx == 0 && !hs_ep->req)
 				s3c_hsotg_enqueue_setup(hsotg);
-		} else if (using_dma(hsotg)) {
-			/*
-			 * We're using DMA, we need to fire an OutDone here
-			 * as we ignore the RXFIFO.
-			 */
-
-			s3c_hsotg_handle_outdone(hsotg, idx, false);
 		}
 	}
 
@@ -1849,20 +1700,6 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 
 	if (ints & DXEPINT_SETUP) {  /* Setup or Timeout */
 		dev_dbg(hsotg->dev, "%s: Setup/Timeout\n",  __func__);
-
-		if (using_dma(hsotg) && idx == 0) {
-			/*
-			 * this is the notification we've received a
-			 * setup packet. In non-DMA mode we'd get this
-			 * from the RXFIFO, instead we need to process
-			 * the setup here.
-			 */
-
-			if (dir_in)
-				WARN_ON_ONCE(1);
-			else
-				s3c_hsotg_handle_outdone(hsotg, 0, true);
-		}
 	}
 
 	if (ints & DXEPINT_BACK2BACKSETUP)
@@ -1886,8 +1723,7 @@ static void s3c_hsotg_epint(struct s3c_hsotg *hsotg, unsigned int idx,
 		    ints & DIEPMSK_TXFIFOEMPTY) {
 			dev_dbg(hsotg->dev, "%s: ep%d: TxFIFOEmpty\n",
 				__func__, idx);
-			if (!using_dma(hsotg))
-				s3c_hsotg_trytx(hsotg, hs_ep);
+			s3c_hsotg_trytx(hsotg, hs_ep);
 		}
 	}
 }
@@ -2136,15 +1972,10 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
 		GINTSTS_USBSUSP | GINTSTS_WKUPINT,
 		hsotg->regs + GINTMSK);
 
-	if (using_dma(hsotg))
-		writel(GAHBCFG_GLBL_INTR_EN | GAHBCFG_DMA_EN |
-		       GAHBCFG_HBSTLEN_INCR4,
-		       hsotg->regs + GAHBCFG);
-	else
-		writel(((hsotg->dedicated_fifos) ? (GAHBCFG_NP_TXF_EMP_LVL |
-						    GAHBCFG_P_TXF_EMP_LVL) : 0) |
-		       GAHBCFG_GLBL_INTR_EN,
-		       hsotg->regs + GAHBCFG);
+	writel(((hsotg->dedicated_fifos) ? (GAHBCFG_NP_TXF_EMP_LVL |
+					    GAHBCFG_P_TXF_EMP_LVL) : 0) |
+		GAHBCFG_GLBL_INTR_EN,
+		hsotg->regs + GAHBCFG);
 
 	/*
 	 * If INTknTXFEmpMsk is enabled, it's important to disable ep interrupts
@@ -2160,12 +1991,9 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
 		hsotg->regs + DIEPMSK);
 
 	/*
-	 * don't need XferCompl, we get that from RXFIFO in slave mode. In
-	 * DMA mode we may need this.
+	 * don't need XferCompl, we get that from RXFIFO in slave mode.
 	 */
-	writel((using_dma(hsotg) ? (DIEPMSK_XFERCOMPLMSK |
-				    DIEPMSK_TIMEOUTMSK) : 0) |
-		DOEPMSK_EPDISBLDMSK | DOEPMSK_AHBERRMSK |
+	writel(DOEPMSK_EPDISBLDMSK | DOEPMSK_AHBERRMSK |
 		DOEPMSK_SETUPMSK,
 		hsotg->regs + DOEPMSK);
 
@@ -2180,11 +2008,9 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
 
 	/*
 	 * Enable the RXFIFO when in slave mode, as this is how we collect
-	 * the data. In DMA mode, we get events from the FIFO but also
-	 * things we cannot process, so do not use it.
+	 * the data.
 	 */
-	if (!using_dma(hsotg))
-		s3c_hsotg_en_gsint(hsotg, GINTSTS_RXFLVL);
+	s3c_hsotg_en_gsint(hsotg, GINTSTS_RXFLVL);
 
 	/* Enable interrupts for EP0 in and out */
 	s3c_hsotg_ctrl_epint(hsotg, 0, 0, 1);
@@ -2816,8 +2642,7 @@ static void s3c_hsotg_init(struct s3c_hsotg *hsotg)
 	writel(GUSBCFG_PHYIF16 | GUSBCFG_TOUTCAL(7) | (0x5 << 10),
 	       hsotg->regs + GUSBCFG);
 
-	writel(using_dma(hsotg) ? GAHBCFG_DMA_EN : 0x0,
-	       hsotg->regs + GAHBCFG);
+	writel(0x0, hsotg->regs + GAHBCFG);
 }
 
 /**
@@ -3009,17 +2834,6 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
 
 	ptxfifo = readl(hsotg->regs + DPTXFSIZN(epnum));
 	hs_ep->fifo_size = FIFOSIZE_DEPTH_GET(ptxfifo) * 4;
-
-	/*
-	 * if we're using dma, we need to set the next-endpoint pointer
-	 * to be something valid.
-	 */
-
-	if (using_dma(hsotg)) {
-		u32 next = DXEPCTL_NEXTEP((epnum + 1) % 15);
-		writel(next, hsotg->regs + DIEPCTL(epnum));
-		writel(next, hsotg->regs + DOEPCTL(epnum));
-	}
 }
 
 /**
-- 
1.8.2.3


