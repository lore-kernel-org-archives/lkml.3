Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753039AbaCGMRh (ORCPT <rfc822;w@1wt.eu>);
	Fri, 7 Mar 2014 07:17:37 -0500
Received: from arroyo.ext.ti.com ([192.94.94.40]:38885 "EHLO arroyo.ext.ti.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S1752961AbaCGMRe (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Fri, 7 Mar 2014 07:17:34 -0500
From: Sricharan R <r.sricharan@ti.com>
To: <r.sricharan@ti.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, <linux-arm-kernel@lists.infradead.org>,
        <linux-omap@vger.kernel.org>, <dmaengine@vger.kernel.org>
CC: <santosh.shilimkar@ti.com>, <rnayak@ti.com>, <nsekhar@ti.com>,
        <tony@atomide.com>, <linux@arm.linux.org.uk>, <vinod.koul@intel.com>,
        <dan.j.williams@intel.com>, <nm@ti.com>
Subject: [RFC PATCH 4/9] drivers: omap-dma: Add crossbar line as a resource to omap_chan structure
Date: Fri, 7 Mar 2014 17:46:11 +0530
Message-ID: <1394194576-23741-5-git-send-email-r.sricharan@ti.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
References: <1394194576-23741-1-git-send-email-r.sricharan@ti.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

In socs which have crossbar to route the peripheral dma request
line to the dma controller, only the peripheral crossbar request line
number is fixed and this is passed through the DT nodes. The dma request
channel to be used is allocated dynamically.

The total number of crossbar channels are registered during probe a
the dma request line free is mapped using the registered router's map function
during the device_alloc_chan_resource callback and freed with free_resource.
When a router is not registered, the dma request number is same as the
crossbar number.

Signed-off-by: Sricharan R <r.sricharan@ti.com>
---
 drivers/dma/omap-dma.c |   21 ++++++++++++++++-----
 1 file changed, 16 insertions(+), 5 deletions(-)

diff --git a/drivers/dma/omap-dma.c b/drivers/dma/omap-dma.c
index 38407f9..05ac480 100644
--- a/drivers/dma/omap-dma.c
+++ b/drivers/dma/omap-dma.c
@@ -47,6 +47,7 @@ struct omap_chan {
 	struct dma_xbar_device *router;
 
 	unsigned dma_sig;
+	unsigned dma_xbar;
 	bool cyclic;
 	bool paused;
 
@@ -530,6 +531,11 @@ static int omap_dma_alloc_chan_resources(struct dma_chan *chan)
 	struct omap_chan *c = to_omap_dma_chan(chan);
 	int ret;
 
+	if (c->router)
+		c->dma_sig = c->router->ops->map(c->dma_xbar, c->router);
+	else
+		c->dma_sig = c->dma_xbar;
+
 	if (od->legacy) {
 		ret = omap_request_dma(c->dma_sig, "DMA engine",
 				       omap_dma_callback, c, &c->dma_ch);
@@ -539,7 +545,7 @@ static int omap_dma_alloc_chan_resources(struct dma_chan *chan)
 	}
 
 	dev_dbg(od->ddev.dev, "allocating channel %u for %u\n",
-		c->dma_ch, c->dma_sig);
+		c->dma_ch, c->dma_xbar);
 
 	if (ret >= 0) {
 		omap_dma_assign(od, c, c->dma_ch);
@@ -594,9 +600,14 @@ static void omap_dma_free_chan_resources(struct dma_chan *chan)
 	od->lch_map[c->dma_ch] = NULL;
 	vchan_free_chan_resources(&c->vc);
 
+	if (c->router) {
+		c->router->ops->unmap(c->dma_sig, c->router);
+		c->dma_sig = 0;
+	}
+
 	omap_free_dma(c->dma_ch);
 
-	dev_dbg(od->ddev.dev, "freeing channel for %u\n", c->dma_sig);
+	dev_dbg(od->ddev.dev, "freeing channel for %u\n", c->dma_xbar);
 }
 
 static size_t omap_dma_sg_size(struct omap_sg *sg)
@@ -1064,7 +1075,7 @@ static int omap_dma_control(struct dma_chan *chan, enum dma_ctrl_cmd cmd,
 	return ret;
 }
 
-static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
+static int omap_dma_chan_init(struct omap_dmadev *od, int dma_xbar)
 {
 	struct omap_chan *c;
 
@@ -1073,7 +1084,7 @@ static int omap_dma_chan_init(struct omap_dmadev *od, int dma_sig)
 		return -ENOMEM;
 
 	c->reg_map = od->reg_map;
-	c->dma_sig = dma_sig;
+	c->dma_xbar = dma_xbar;
 	c->vc.desc_free = omap_dma_desc_free;
 	vchan_init(&c->vc, &od->ddev);
 	INIT_LIST_HEAD(&c->node);
@@ -1263,7 +1274,7 @@ bool omap_dma_filter_fn(struct dma_chan *chan, void *param)
 		struct omap_chan *c = to_omap_dma_chan(chan);
 		unsigned req = args->chan;
 
-		if (req == c->dma_sig) {
+		if (req == c->dma_xbar) {
 			c->router = args->router_data;
 			return true;
 		}
-- 
1.7.9.5

