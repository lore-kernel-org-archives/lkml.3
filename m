Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S967778Ab3DRKMr (ORCPT <rfc822;w@1wt.eu>);
	Thu, 18 Apr 2013 06:12:47 -0400
Received: from mail-we0-f175.google.com ([74.125.82.175]:58080 "EHLO
	mail-we0-f175.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S967762Ab3DRKMn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 18 Apr 2013 06:12:43 -0400
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Lee Jones <lee.jones@linaro.org>, Vinod Koul <vinod.koul@intel.com>,
        Dan Williams <djbw@fb.com>, Per Forlin <per.forlin@stericsson.com>,
        Rabin Vincent <rabin@rab.in>
Subject: [PATCH 05/32] dmaengine: ste_dma40: Supply macros to resolve 'src' and 'dst' directions
Date: Thu, 18 Apr 2013 11:11:47 +0100
Message-Id: <1366279934-30761-6-git-send-email-lee.jones@linaro.org>
X-Mailer: git-send-email 1.7.10.4
In-Reply-To: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There are lots of lengthy if() statements located sporadically up and
down the driver. This simple macro should make many of them a little
simpler to decipher. The remainder have to stay in place, as they
detail slightly more specific settings.

Cc: Vinod Koul <vinod.koul@intel.com>
Cc: Dan Williams <djbw@fb.com>
Cc: Per Forlin <per.forlin@stericsson.com>
Cc: Rabin Vincent <rabin@rab.in>
Signed-off-by: Lee Jones <lee.jones@linaro.org>
---
 drivers/dma/ste_dma40.c |   38 ++++++++++++++++++++------------------
 1 file changed, 20 insertions(+), 18 deletions(-)

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index e50354d..b21a8a3 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -55,6 +55,10 @@
 
 #define MAX(a, b) (((a) < (b)) ? (b) : (a))
 
+#define D40_IS_SRC(dir)  ((dir == STEDMA40_PERIPH_TO_MEM) ? true : false)
+#define D40_IS_DST(dir) (((dir == STEDMA40_MEM_TO_PERIPH) || \
+			  (dir == STEDMA40_MEM_TO_MEM)) ? true : false)
+
 /* Reserved event lines for memcpy only. */
 static int dma40_memcpy_channels[] = { 56, 57, 58, 59, 60 };
 
@@ -823,7 +827,7 @@ static void d40_log_lli_to_lcxa(struct d40_chan *chan, struct d40_desc *desc)
 		 * that uses linked lists.
 		 */
 		if (!(chan->phy_chan->use_soft_lli &&
-			chan->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM))
+		      D40_IS_SRC(chan->dma_cfg.dir)))
 			curr_lcla = d40_lcla_alloc_one(chan, desc);
 
 		first_lcla = curr_lcla;
@@ -1291,12 +1295,12 @@ static void d40_config_set_event(struct d40_chan *d40c,
 	u32 event = D40_TYPE_TO_EVENT(d40c->dma_cfg.dev_type);
 
 	/* Enable event line connected to device (or memcpy) */
-	if ((d40c->dma_cfg.dir ==  STEDMA40_PERIPH_TO_MEM) ||
+	if (D40_IS_SRC(d40c->dma_cfg.dir) ||
 	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
 		__d40_config_set_event(d40c, event_type, event,
 				       D40_CHAN_REG_SSLNK);
 
-	if (d40c->dma_cfg.dir !=  STEDMA40_PERIPH_TO_MEM)
+	if (!D40_IS_SRC(d40c->dma_cfg.dir))
 		__d40_config_set_event(d40c, event_type, event,
 				       D40_CHAN_REG_SDLNK);
 }
@@ -1762,7 +1766,7 @@ static int d40_validate_conf(struct d40_chan *d40c,
 		res = -EINVAL;
 	}
 
-	if (conf->dir == STEDMA40_PERIPH_TO_MEM &&
+	if (D40_IS_SRC(conf->dir) &&
 	    d40c->base->plat_data->dev_rx[conf->dev_type] == 0 &&
 	    d40c->runtime_addr == 0) {
 		chan_err(d40c, "Invalid RX channel address (%d)\n",
@@ -1895,17 +1899,17 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 	int j;
 	int log_num;
 	int num_phy_chans;
+	int dir = d40c->dma_cfg.dir;
 	bool is_src;
 	bool is_log = d40c->dma_cfg.mode == STEDMA40_MODE_LOGICAL;
 
 	phys = d40c->base->phy_res;
 	num_phy_chans = d40c->base->num_phy_chans;
 
-	if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
+	if (D40_IS_SRC(dir)) {
 		log_num = 2 * dev_type;
 		is_src = true;
-	} else if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
-		   d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
+	} else if (D40_IS_DST(dir)) {
 		/* dst event lines are used for logical memcpy */
 		log_num = 2 * dev_type + 1;
 		is_src = false;
@@ -1916,7 +1920,7 @@ static int d40_allocate_channel(struct d40_chan *d40c, bool *first_phy_user)
 	event_line = D40_TYPE_TO_EVENT(dev_type);
 
 	if (!is_log) {
-		if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
+		if (dir == STEDMA40_MEM_TO_MEM) {
 			/* Find physical half channel */
 			if (d40c->dma_cfg.use_fixed_channel) {
 				i = d40c->dma_cfg.phy_channel;
@@ -2053,11 +2057,10 @@ static int d40_free_dma(struct d40_chan *d40c)
 		return -EINVAL;
 	}
 
-	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
-	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM)
-		is_src = false;
-	else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM)
+	if (D40_IS_SRC(d40c->dma_cfg.dir))
 		is_src = true;
+	else if (D40_IS_DST(d40c->dma_cfg.dir))
+		is_src = false;
 	else {
 		chan_err(d40c, "Unknown direction\n");
 		return -EINVAL;
@@ -2118,12 +2121,11 @@ static bool d40_is_paused(struct d40_chan *d40c)
 		goto _exit;
 	}
 
-	if (d40c->dma_cfg.dir == STEDMA40_MEM_TO_PERIPH ||
-	    d40c->dma_cfg.dir == STEDMA40_MEM_TO_MEM) {
-		status = readl(chanbase + D40_CHAN_REG_SDLNK);
-	} else if (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_MEM) {
+	if (D40_IS_SRC(d40c->dma_cfg.dir))
 		status = readl(chanbase + D40_CHAN_REG_SSLNK);
-	} else {
+	else if (D40_IS_DST(d40c->dma_cfg.dir))
+		status = readl(chanbase + D40_CHAN_REG_SDLNK);
+	else {
 		chan_err(d40c, "Unknown direction\n");
 		goto _exit;
 	}
@@ -2394,7 +2396,7 @@ static void d40_set_prio_realtime(struct d40_chan *d40c)
 	if (d40c->base->rev < 3)
 		return;
 
-	if ((d40c->dma_cfg.dir ==  STEDMA40_PERIPH_TO_MEM) ||
+	if (D40_IS_SRC(d40c->dma_cfg.dir) ||
 	    (d40c->dma_cfg.dir == STEDMA40_PERIPH_TO_PERIPH))
 		__d40_set_prio_rt(d40c, d40c->dma_cfg.dev_type, true);
 
-- 
1.7.10.4

