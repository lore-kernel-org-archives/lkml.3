Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752629AbaHMMQ4 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 13 Aug 2014 08:16:56 -0400
Received: from mail.neotion.com ([5.39.84.84]:40068 "EHLO mail.neotion.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1751984AbaHMMQy (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Wed, 13 Aug 2014 08:16:54 -0400
Message-ID: <53EB5732.3010704@neotion.com>
Date: Wed, 13 Aug 2014 14:16:50 +0200
From: Neil Armstrong <narmstrong@neotion.com>
Reply-To: narmstrong@neotion.com
Organization: Neotion
User-Agent: Mozilla/5.0 (X11; Linux i686 on x86_64; rv:24.0) Gecko/20100101 Thunderbird/24.6.0
MIME-Version: 1.0
To: Paul Zimmerman <paulz@synopsys.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        linux-usb@vger.kernel.org, linux-kernel@vger.kernel.org,
        ben-linux@fluff.org, m.szyprowski@samsung.com, r.baldyga@samsung.com
Subject: [PATCH RFC] usb: gadget: dwc2: make driver run on a version 3.10a
 instance of DWC_OTG
X-Enigmail-Version: 1.6
OpenPGP: id=1166F485
Content-Type: text/plain; charset=ISO-8859-1
Content-Transfer-Encoding: 7bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

We are trying to make a driver run on our PCD only instance of Synopsys
DWC_OTG IP with the following parameters :
- Dedicated Fifos : Yes
- Descriptor DMA : Yes
- PHY : 8bit UTMI+ (may need also support for ULPI)
- Endpoints : 6 (7 with ep0)
- Periodic IN Endpoints : 0
- IN Endpoints : 3 (4 with ep0)
- EP repartition : INOUT, IN, OUT, IN , OUT, IN, OUT
- DFifo Depth : 1844

I do not know what is the original s3c hsotg IP config, but to
correctly support the Dedicated Fifos you need to attribute a FIFO
index for each IN endpoints, and on the 3.10a release we only have
4 TX FIFOS, so we just cannot give the EP number as fifo index.

It impacts the FIFO repartition, it is not perfect since we do
not take into account the Isochronous needs, so it needs some
rework.

To managed these FIFOs, I load from the registers the EP
repartition, HW fifo depth and HW revision.
It also impacts that hw_cfg must be done before init call.

Same for the num_of_eps value, in the Synopsys documentation,
it specifies it is the count of non-ep0 endpoints, but the
driver for loops where like :
for(i = 1 ; i < hsotg->num_of_eps ; ++i)
which is absolutely invalid and ignores the last EP.

We never managed to make the driver work in FIFO mode, but in DMA
mode it works like a charm, and to support all the gadget drivers,
we implemented a silly Bounce Buffer mode.

The PHY configuration was also rewritten according to the
documentation.

Fo the descripto DMA mode, I tried to add missing parts, but I get stuck
with weird HW beheviours....

Signed-off-by: Neil Armstrong <narmstrong@neotion.com>
---
 drivers/usb/dwc2/core.h   |   14 +++
 drivers/usb/dwc2/gadget.c |  267 +++++++++++++++++++++++++++++++++++----------
 2 files changed, 221 insertions(+), 60 deletions(-)

This is mainly an RFC in order to make this driver run with recent HW.
This is why the patch is not 100% clean.

diff --git a/drivers/usb/dwc2/core.h b/drivers/usb/dwc2/core.h
index 1efd10c..21c136e 100644
--- a/drivers/usb/dwc2/core.h
+++ b/drivers/usb/dwc2/core.h
@@ -102,6 +102,7 @@ struct s3c_hsotg_req;
  * @dir_in: Set to true if this endpoint is of the IN direction, which
  *          means that it is sending data to the Host.
  * @index: The index for the endpoint registers.
+ * @txfnum: The TX fifo index.
  * @mc: Multi Count - number of transactions per microframe
  * @interval - Interval for periodic endpoints
  * @name: The name array passed to the USB core.
@@ -142,6 +143,7 @@ struct s3c_hsotg_ep {
 
     unsigned char           dir_in;
     unsigned char           index;
+    unsigned int            txfnum;
     unsigned char           mc;
     unsigned char           interval;
 
@@ -167,6 +169,10 @@ struct s3c_hsotg_ep {
  * @phyif: PHY interface width
  * @dedicated_fifos: Set if the hardware has dedicated IN-EP fifos.
  * @num_of_eps: Number of available EPs (excluding EP0)
+ * @dfifo_depth: depth of HW DFIFO
+ * @dir_of_eps: direction of each endpoint
+ * @hw_major: Hardware Major number
+ * @hw_minor: Hardware minor ID
  * @debug_root: root directrory for debugfs.
  * @debug_file: main status file for debugfs.
  * @debug_fifo: FIFO status file for debugfs.
@@ -195,7 +201,12 @@ struct s3c_hsotg {
 
     u32                     phyif;
     unsigned int            dedicated_fifos:1;
+    unsigned int            dfifo_depth;
     unsigned char           num_of_eps;
+    unsigned int            dma_enable:1;
+    unsigned char           dir_of_eps[16];
+    unsigned int            hw_major;
+    unsigned int            hw_minor[3];
 
     struct dentry           *debug_root;
     struct dentry           *debug_file;
@@ -224,6 +235,9 @@ struct s3c_hsotg_req {
     struct list_head        queue;
     unsigned char           in_progress;
     unsigned char           mapped;
+    unsigned            bounced_dma;
+    dma_addr_t          bounce_phys;
+    void                * bounce;
 };
 
 #define call_gadget(_hs, _entry) \
diff --git a/drivers/usb/dwc2/gadget.c b/drivers/usb/dwc2/gadget.c
index 392b373..1f3f9b9 100644
--- a/drivers/usb/dwc2/gadget.c
+++ b/drivers/usb/dwc2/gadget.c
@@ -89,7 +89,7 @@ static void s3c_hsotg_dump(struct s3c_hsotg *hsotg);
  */
 static inline bool using_dma(struct s3c_hsotg *hsotg)
 {
-    return false;    /* support is not complete */
+    return hsotg->dma_enable;
 }
 
 /**
@@ -163,17 +163,30 @@ static void s3c_hsotg_ctrl_epint(struct s3c_hsotg *hsotg,
  */
 static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
 {
+    unsigned int rxfifo_size;
     unsigned int ep;
     unsigned int addr;
     unsigned int size;
+    unsigned int txfifonum;
     int timeout;
     u32 val;
 
-    /* set FIFO sizes to 2048/1024 */
+    rxfifo_size = (4 * 1) + 6; // (4 * number of control endpoint + 6)
+    rxfifo_size += (1024 / 4) + 1; // (largest packet / 4) + 1
+    rxfifo_size += 2; // for ep0 as OUT endpoint
+    for (ep = 1; ep <= hsotg->num_of_eps; ep++)
+        if(hsotg->dir_of_eps[ep] > 1)
+            rxfifo_size += 2; // OUT endpoint
+    rxfifo_size += 1; // for global NAK
 
-    writel(2048, hsotg->regs + GRXFSIZ);
-    writel((2048 << FIFOSIZE_STARTADDR_SHIFT) |
-        (1024 << FIFOSIZE_DEPTH_SHIFT), hsotg->regs + GNPTXFSIZ);
+    /* Round up to multiple of 128 words */
+    if ( rxfifo_size%128 > 0 )
+        rxfifo_size += 128 - (rxfifo_size%128);
+
+    writel(rxfifo_size, hsotg->regs + GRXFSIZ);
+    writel((rxfifo_size & FIFOSIZE_STARTADDR_MASK) |
+            ((1024/4) << FIFOSIZE_DEPTH_SHIFT),
+            hsotg->regs + GNPTXFSIZ);
 
     /*
      * arange all the rest of the TX FIFOs, as some versions of this
@@ -183,22 +196,48 @@ static void s3c_hsotg_init_fifo(struct s3c_hsotg *hsotg)
      */
 
     /* start at the end of the GNPTXFSIZ, rounded up */
-    addr = 2048 + 1024;
-    size = 768;
+    addr = rxfifo_size + (1024/4);
+    size = (1024/4);
 
     /*
-     * currently we allocate TX FIFOs for all possible endpoints,
+     * currently we allocate TX FIFOs for all IN endpoints,
      * and assume that they are all the same size.
      */
 
-    for (ep = 1; ep <= 15; ep++) {
+    for (txfifonum = 1, ep = 1; ep <= hsotg->num_of_eps; ep++) {
+
+        /*
+         * configure only IN endpoints
+         */
+        if (hsotg->dir_of_eps[ep] > 1)
+            continue;
+
+        /*
+         * check for FIFO addr in available FIFO words
+         */
+        if (addr >= hsotg->dfifo_depth)
+        {
+            dev_err(hsotg->dev, "critical usage of data fifo size at ep %d addr %x\n", ep, addr);
+        }
+
         val = addr;
         val |= size << FIFOSIZE_DEPTH_SHIFT;
         addr += size;
 
-        writel(val, hsotg->regs + DPTXFSIZN(ep));
+        dev_dbg(hsotg->dev, "txfifo[%d] start=%d size=%d\n", txfifonum, addr, size);
+
+        writel(val, hsotg->regs + DPTXFSIZN(txfifonum));
+        val = readl(hsotg->regs + DPTXFSIZN(txfifonum));
+        dev_dbg(hsotg->dev, "DPTx[%d] FSize=%d, StAddr=0x%08x\n", txfifonum,
+                val >> FIFOSIZE_DEPTH_SHIFT,
+                val & FIFOSIZE_STARTADDR_MASK);
+        txfifonum++;
     }
 
+    dev_dbg(hsotg->dev, "%d %s TX FIFOs\n", txfifonum-1, (hsotg->dedicated_fifos?"Dedicated":"Periodic"));
+
+    dev_info(hsotg->dev, "Using %d words of FIFO, remains %d unused words\n", addr, (hsotg->dfifo_depth - addr));
+
     /*
      * according to p428 of the design guide, we need to ensure that
      * all fifos are flushed before continuing
@@ -278,6 +317,16 @@ static void s3c_hsotg_unmap_dma(struct s3c_hsotg *hsotg,
     if (hs_req->req.length == 0)
         return;
 
+    if(hs_req->bounced_dma)
+    {
+        if(!hs_ep->dir_in)
+            memcpy(req->buf, hs_req->bounce, req->length);
+
+        dma_free_coherent(hsotg->dev, req->length, hs_req->bounce, hs_req->bounce_phys);
+
+        return;
+    }
+
     usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->dir_in);
 }
 
@@ -549,7 +598,7 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
     length = ureq->length - ureq->actual;
     dev_dbg(hsotg->dev, "ureq->length:%d ureq->actual:%d\n",
         ureq->length, ureq->actual);
-    if (0)
+    if(using_dma(hsotg))
         dev_dbg(hsotg->dev,
             "REQ buf %p len %d dma %pad noi=%d zp=%d snok=%d\n",
             ureq->buf, length, &ureq->dma,
@@ -630,7 +679,7 @@ static void s3c_hsotg_start_req(struct s3c_hsotg *hsotg,
     dev_dbg(hsotg->dev, "setup req:%d\n", hsotg->setup);
 
     /* For Setup request do not clear NAK */
-    if (hsotg->setup && index == 0)
+    if (hsotg->hw_major < 3 && hsotg->setup && index == 0)
         hsotg->setup = 0;
     else
         ctrl |= DXEPCTL_CNAK;    /* clear NAK set by core */
@@ -707,6 +756,31 @@ static int s3c_hsotg_map_dma(struct s3c_hsotg *hsotg,
     if (ret)
         goto dma_error;
 
+    /* badly aligned, use bounce buffer */
+    if ((req->dma & 3) != 0)
+    {
+        hs_req->bounced_dma = 1;
+
+        /* unmap */
+        usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->dir_in);
+
+        hs_req->bounce = dma_alloc_coherent(hsotg->dev, req->length, &hs_req->bounce_phys, GFP_KERNEL);
+        if(hs_req->bounce == NULL)
+        {
+            dev_err(hsotg->dev, "badly aligned DMA buffer, but unable to allocate bounce buffer\n");
+            usb_gadget_unmap_request(&hsotg->gadget, req, hs_ep->dir_in);
+            return -EIO;
+        }
+
+
+        dev_dbg(hsotg->dev, "using DMA bounce buffer %p (%08x) for length %d\n", hs_req->bounce, hs_req->bounce_phys, req->length);
+
+        req->dma = hs_req->bounce_phys;
+
+        if (hs_ep->dir_in)
+            memcpy(hs_req->bounce, req->buf, req->length);
+    }
+
     return 0;
 
 dma_error:
@@ -1634,7 +1708,10 @@ static void s3c_hsotg_txfifo_flush(struct s3c_hsotg *hsotg, unsigned int idx)
     int timeout;
     int val;
 
-    writel(GRSTCTL_TXFNUM(idx) | GRSTCTL_TXFFLSH,
+    if(!hsotg->eps[idx].dir_in)
+        return;
+
+    writel(GRSTCTL_TXFNUM(hsotg->eps[idx].txfnum) | GRSTCTL_TXFFLSH,
         hsotg->regs + GRSTCTL);
 
     /* wait until the fifo is flushed */
@@ -1953,7 +2030,7 @@ static void s3c_hsotg_irq_enumdone(struct s3c_hsotg *hsotg)
     if (ep0_mps) {
         int i;
         s3c_hsotg_set_ep_maxpacket(hsotg, 0, ep0_mps);
-        for (i = 1; i < hsotg->num_of_eps; i++)
+        for (i = 1; i <= hsotg->num_of_eps; i++)
             s3c_hsotg_set_ep_maxpacket(hsotg, i, ep_mps);
     }
 
@@ -2011,7 +2088,7 @@ static void s3c_hsotg_disconnect(struct s3c_hsotg *hsotg)
 {
     unsigned ep;
 
-    for (ep = 0; ep < hsotg->num_of_eps; ep++)
+    for (ep = 0; ep <= hsotg->num_of_eps; ep++)
         kill_all_requests(hsotg, &hsotg->eps[ep], -ESHUTDOWN, true);
 
     call_gadget(hsotg, disconnect);
@@ -2029,7 +2106,7 @@ static void s3c_hsotg_irq_fifoempty(struct s3c_hsotg *hsotg, bool periodic)
 
     /* look through for any more data to transmit */
 
-    for (epno = 0; epno < hsotg->num_of_eps; epno++) {
+    for (epno = 0; epno <= hsotg->num_of_eps; epno++) {
         ep = &hsotg->eps[epno];
 
         if (!ep->dir_in)
@@ -2113,10 +2190,6 @@ static void s3c_hsotg_core_init(struct s3c_hsotg *hsotg)
      * set configuration.
      */
 
-    /* set the PLL on, remove the HNP/SRP and set the PHY */
-    writel(hsotg->phyif | GUSBCFG_TOUTCAL(7) |
-           (0x5 << 10), hsotg->regs + GUSBCFG);
-
     s3c_hsotg_init_fifo(hsotg);
 
     __orr32(hsotg->regs + DCTL, DCTL_SFTDISCON);
@@ -2292,12 +2365,12 @@ irq_retry:
 
         dev_dbg(hsotg->dev, "%s: daint=%08x\n", __func__, daint);
 
-        for (ep = 0; ep < 15 && daint_out; ep++, daint_out >>= 1) {
+        for (ep = 0; ep <= 15 && daint_out; ep++, daint_out >>= 1) {
             if (daint_out & 1)
                 s3c_hsotg_epint(hsotg, ep, 0);
         }
 
-        for (ep = 0; ep < 15 && daint_in; ep++, daint_in >>= 1) {
+        for (ep = 0; ep <= 15 && daint_in; ep++, daint_in >>= 1) {
             if (daint_in & 1)
                 s3c_hsotg_epint(hsotg, ep, 1);
         }
@@ -2518,7 +2591,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
              */
 
             hs_ep->periodic = 1;
-            epctrl |= DXEPCTL_TXFNUM(index);
+            epctrl |= DXEPCTL_TXFNUM(hs_ep->txfnum);
         }
 
         epctrl |= DXEPCTL_EPTYPE_INTERRUPT;
@@ -2534,7 +2607,7 @@ static int s3c_hsotg_ep_enable(struct usb_ep *ep,
      * a unique tx-fifo even if it is non-periodic.
      */
     if (dir_in && hsotg->dedicated_fifos)
-        epctrl |= DXEPCTL_TXFNUM(index);
+        epctrl |= DXEPCTL_TXFNUM(hs_ep->txfnum);
 
     /* for non control endpoints, set PID to D0 */
     if (index)
@@ -2783,6 +2856,8 @@ static void s3c_hsotg_phy_disable(struct s3c_hsotg *hsotg)
  */
 static void s3c_hsotg_init(struct s3c_hsotg *hsotg)
 {
+    u32 gusbcfg;
+
     /* unmask subset of endpoint interrupts */
 
     writel(DIEPMSK_TIMEOUTMSK | DIEPMSK_AHBERRMSK |
@@ -2812,12 +2887,25 @@ static void s3c_hsotg_init(struct s3c_hsotg *hsotg)
 
     s3c_hsotg_init_fifo(hsotg);
 
-    /* set the PLL on, remove the HNP/SRP and set the PHY */
-    writel(GUSBCFG_PHYIF16 | GUSBCFG_TOUTCAL(7) | (0x5 << 10),
-           hsotg->regs + GUSBCFG);
+    /* TODO : Support ULPI PHY */
+
+    gusbcfg = hsotg->phyif;
+    if(hsotg->phyif == GUSBCFG_PHYIF8)
+        gusbcfg |= 9 << GUSBCFG_USBTRDTIM_SHIFT;
+    else // default 16BIT
+        gusbcfg |= 5 << GUSBCFG_USBTRDTIM_SHIFT;
+    dev_info(hsotg->dev, "UTMI+ %dbit PHY\n", (hsotg->phyif == GUSBCFG_PHYIF8?8:16));
+
+    /* Maximum calibration delay */
+    gusbcfg |= 7 << GUSBCFG_TOUTCAL_SHIFT;
+
+    writel(gusbcfg, hsotg->regs + GUSBCFG);
 
     writel(using_dma(hsotg) ? GAHBCFG_DMA_EN : 0x0,
-           hsotg->regs + GAHBCFG);
+            hsotg->regs + GAHBCFG);
+
+    if (using_dma(hsotg))
+        dev_info(hsotg->dev, "Using DMA");
 }
 
 /**
@@ -2975,20 +3063,28 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
 {
     u32 ptxfifo;
     char *dir;
+    static int txfnum_count = 0;
 
-    if (epnum == 0)
-        dir = "";
-    else if ((epnum % 2) == 0) {
-        dir = "out";
-    } else {
+    if (hsotg->dir_of_eps[epnum] == 1)
+    {
         dir = "in";
+        hs_ep->txfnum = txfnum_count++;
         hs_ep->dir_in = 1;
     }
+    else if(epnum > 0)
+        dir = "out";
+    else
+    {
+        dir = "";
+        hs_ep->txfnum = txfnum_count++;
+    }
 
     hs_ep->index = epnum;
 
     snprintf(hs_ep->name, sizeof(hs_ep->name), "ep%d%s", epnum, dir);
 
+    dev_dbg(hsotg->dev, "init %s\n", hs_ep->name);
+
     INIT_LIST_HEAD(&hs_ep->queue);
     INIT_LIST_HEAD(&hs_ep->ep.ep_list);
 
@@ -3028,21 +3124,54 @@ static void s3c_hsotg_initep(struct s3c_hsotg *hsotg,
  *
  * Read the USB core HW configuration registers
  */
-static void s3c_hsotg_hw_cfg(struct s3c_hsotg *hsotg)
+static int s3c_hsotg_hw_cfg(struct s3c_hsotg *hsotg)
 {
-    u32 cfg2, cfg4;
+    int i;
+    u32 cfg1, cfg2, cfg3, cfg4, gsnpsid;
+
+    /* get Hardware revision */
+    gsnpsid = readl(hsotg->regs + GSNPSID);
+
+    if ((gsnpsid & 0xfffff000) != 0x4f542000 &&
+            (gsnpsid & 0xfffff000) != 0x4f543000)
+    {
+        dev_err(hsotg->dev, "Invalid SynopsysID %04x\n", gsnpsid & 0xfffff000);
+        return -EINVAL;
+    }
+    hsotg->hw_major = (gsnpsid >> 12) & 0xf;
+    for (i = 0 ; i < 3 ; ++i)
+        hsotg->hw_minor[i] = (gsnpsid >> (8 - (i * 4))) & 0xf;
+
+    dev_info(hsotg->dev, "Synopsys DesignWare Core USB 2.0 Hi-Speed OTG Controller revision %d.%d%d%x\n", hsotg->hw_major, hsotg->hw_minor[0], hsotg->hw_minor[1], hsotg->hw_minor[2]);
+
     /* check hardware configuration */
 
-    cfg2 = readl(hsotg->regs + 0x48);
-    hsotg->num_of_eps = (cfg2 >> 10) & 0xF;
+    cfg2 = readl(hsotg->regs + GHWCFG2);
+    hsotg->num_of_eps = (cfg2 & GHWCFG2_NUM_DEV_EP_MASK) >>
+        GHWCFG2_NUM_DEV_EP_SHIFT;
 
     dev_info(hsotg->dev, "EPs:%d\n", hsotg->num_of_eps);
 
-    cfg4 = readl(hsotg->regs + 0x50);
-    hsotg->dedicated_fifos = (cfg4 >> 25) & 1;
+    cfg1 = readl(hsotg->regs + GHWCFG1);
+    for(i = 0 ; i <= 16 ; ++i)
+        hsotg->dir_of_eps[i] = ((cfg1 >> (i * 2)) & 3);
+
+    for(i = 0 ; i <= hsotg->num_of_eps ; ++i)
+        dev_info(hsotg->dev, "EP[%d]:%s\n", i, (hsotg->dir_of_eps[i]==0?"BIDIR":
+                    (hsotg->dir_of_eps[i]==1?"IN":"OUT")));
+
+    cfg3 = readl(hsotg->regs + GHWCFG3);
+    hsotg->dfifo_depth = (cfg3 & GHWCFG3_DFIFO_DEPTH_MASK) >>
+        GHWCFG3_DFIFO_DEPTH_SHIFT;
+
+    cfg4 = readl(hsotg->regs + GHWCFG4);
+    hsotg->dedicated_fifos = !!(cfg4 & GHWCFG4_DED_FIFO_EN);
+
+    dev_info(hsotg->dev, "%s fifos of %d words\n",
+            hsotg->dedicated_fifos ? "dedicated" : "shared",
+            hsotg->dfifo_depth);
 
-    dev_info(hsotg->dev, "%s fifos\n",
-         hsotg->dedicated_fifos ? "dedicated" : "shared");
+    return 0;
 }
 
 /**
@@ -3069,26 +3198,30 @@ static void s3c_hsotg_dump(struct s3c_hsotg *hsotg)
 
     /* show periodic fifo settings */
 
-    for (idx = 1; idx <= 15; idx++) {
+    for (idx = 1, txfifonum = 1; idx <= hsotg->num_of_eps; idx++) {
+        if(hsotg->dir_of_eps[idx] > 1)
+            continue;
         val = readl(regs + DPTXFSIZN(idx));
         dev_info(dev, "DPTx[%d] FSize=%d, StAddr=0x%08x\n", idx,
-             val >> FIFOSIZE_DEPTH_SHIFT,
-             val & FIFOSIZE_STARTADDR_MASK);
+                val >> FIFOSIZE_DEPTH_SHIFT,
+                val & FIFOSIZE_STARTADDR_MASK);
+        txfifonum++;
     }
 
-    for (idx = 0; idx < 15; idx++) {
-        dev_info(dev,
-             "ep%d-in: EPCTL=0x%08x, SIZ=0x%08x, DMA=0x%08x\n", idx,
-             readl(regs + DIEPCTL(idx)),
-             readl(regs + DIEPTSIZ(idx)),
-             readl(regs + DIEPDMA(idx)));
+    for (idx = 0; idx < hsotg->num_of_eps; idx++) {
+        if(idx == 0 || hsotg->dir_of_eps[idx] == 1)
+            dev_info(dev,
+                    "ep%d-in: EPCTL=0x%08x, SIZ=0x%08x, DMA=0x%08x\n", idx,
+                    readl(regs + DIEPCTL(idx)),
+                    readl(regs + DIEPTSIZ(idx)),
+                    readl(regs + DIEPDMA(idx)));
 
-        val = readl(regs + DOEPCTL(idx));
-        dev_info(dev,
-             "ep%d-out: EPCTL=0x%08x, SIZ=0x%08x, DMA=0x%08x\n",
-             idx, readl(regs + DOEPCTL(idx)),
-             readl(regs + DOEPTSIZ(idx)),
-             readl(regs + DOEPDMA(idx)));
+        if(idx == 0 || hsotg->dir_of_eps[idx] == 2)
+            dev_info(dev,
+                    "ep%d-out: EPCTL=0x%08x, SIZ=0x%08x, DMA=0x%08x\n",
+                    idx, readl(regs + DOEPCTL(idx)),
+                    readl(regs + DOEPTSIZ(idx)),
+                    readl(regs + DOEPDMA(idx)));
 
     }
 
@@ -3182,6 +3315,7 @@ static int fifo_show(struct seq_file *seq, void *v)
     void __iomem *regs = hsotg->regs;
     u32 val;
     int idx;
+    unsigned int ep;
 
     seq_puts(seq, "Non-periodic FIFOs:\n");
     seq_printf(seq, "RXFIFO: Size %d\n", readl(regs + GRXFSIZ));
@@ -3189,16 +3323,20 @@ static int fifo_show(struct seq_file *seq, void *v)
     val = readl(regs + GNPTXFSIZ);
     seq_printf(seq, "NPTXFIFO: Size %d, Start 0x%08x\n",
            val >> FIFOSIZE_DEPTH_SHIFT,
-           val & FIFOSIZE_DEPTH_MASK);
+           val & FIFOSIZE_STARTADDR_MASK);
 
     seq_puts(seq, "\nPeriodic TXFIFOs:\n");
 
-    for (idx = 1; idx <= 15; idx++) {
+    for (idx = 1, ep = 1; ep <= hsotg->num_of_eps; ep++) {
+        if (hsotg->dir_of_eps[ep] > 1)
+            continue;
+
         val = readl(regs + DPTXFSIZN(idx));
 
         seq_printf(seq, "\tDPTXFIFO%2d: Size %d, Start 0x%08x\n", idx,
                val >> FIFOSIZE_DEPTH_SHIFT,
                val & FIFOSIZE_STARTADDR_MASK);
+        idx++;
     }
 
     return 0;
@@ -3400,6 +3538,11 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
         return -ENOMEM;
     }
 
+#ifdef CONFIG_OF
+    if (of_find_property(pdev->dev.of_node, "pcd-dma-enable", NULL))
+        hsotg->dma_enable = 1;
+#endif
+
     /*
      * Attempt to find a generic PHY, then look for an old style
      * USB PHY, finally fall back to pdata
@@ -3503,8 +3646,12 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
     s3c_hsotg_phy_enable(hsotg);
 
     s3c_hsotg_corereset(hsotg);
+
+    ret = s3c_hsotg_hw_cfg(hsotg);
+    if (ret)
+        goto err_supplies;
+
     s3c_hsotg_init(hsotg);
-    s3c_hsotg_hw_cfg(hsotg);
 
     /* hsotg->num_of_eps holds number of EPs other than ep0 */
 
@@ -3540,7 +3687,7 @@ static int s3c_hsotg_probe(struct platform_device *pdev)
     }
 
     /* initialise the endpoints now the core has been initialised */
-    for (epnum = 0; epnum < hsotg->num_of_eps; epnum++)
+    for (epnum = 0; epnum <= hsotg->num_of_eps; epnum++)
         s3c_hsotg_initep(hsotg, &hsotg->eps[epnum], epnum);
 
     /* disable power and clock */
-- 
1.7.0.4

