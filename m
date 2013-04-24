Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756319Ab3DXPLw (ORCPT <rfc822;w@1wt.eu>);
	Wed, 24 Apr 2013 11:11:52 -0400
Received: from mail-wi0-f177.google.com ([209.85.212.177]:45833 "EHLO
	mail-wi0-f177.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753591Ab3DXPLv (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 24 Apr 2013 11:11:51 -0400
Date: Wed, 24 Apr 2013 16:11:45 +0100
From: Lee Jones <lee.jones@linaro.org>
To: linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Cc: arnd@arndb.de, linus.walleij@stericsson.com,
        Vinod Koul <vinod.koul@intel.com>, Dan Williams <djbw@fb.com>,
        Per Forlin <per.forlin@stericsson.com>, Rabin Vincent <rabin@rab.in>
Subject: [PATCH 03/32 v3] dmaengine: ste_dma40: Use the BIT macro to replace
 ugly '(1 << x)'s
Message-ID: <20130424151145.GH9652@gmail.com>
References: <1366279934-30761-1-git-send-email-lee.jones@linaro.org>
 <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <1366279934-30761-4-git-send-email-lee.jones@linaro.org>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The aim is to make the code that little more readable.

Acked-by: Vinod Koul <vnod.koul@intel.com>
Acked-by: Arnd Bergmann <arnd@arndb.de>
Signed-off-by: Lee Jones <lee.jones@linaro.org>

diff --git a/drivers/dma/ste_dma40.c b/drivers/dma/ste_dma40.c
index 3b83dee..b3a82bf 100644
--- a/drivers/dma/ste_dma40.c
+++ b/drivers/dma/ste_dma40.c
@@ -49,8 +49,8 @@
 #define MAX_LCLA_ALLOC_ATTEMPTS 256
 
 /* Bit markings for allocation map */
-#define D40_ALLOC_FREE		(1 << 31)
-#define D40_ALLOC_PHY		(1 << 30)
+#define D40_ALLOC_FREE		BIT(31)
+#define D40_ALLOC_PHY		BIT(30)
 #define D40_ALLOC_LOG_FREE	0
 
 #define MAX(a, b) (((a) < (b)) ? (b) : (a))
@@ -993,12 +993,12 @@ static int d40_size_2_dmalen(int size, u32 data_width1, u32 data_width2)
 	int dmalen;
 	u32 max_w = max(data_width1, data_width2);
 	u32 min_w = min(data_width1, data_width2);
-	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE << min_w, 1 << max_w);
+	u32 seg_max = ALIGN(STEDMA40_MAX_SEG_SIZE << min_w, BIT(max_w));
 
 	if (seg_max > STEDMA40_MAX_SEG_SIZE)
-		seg_max -= (1 << max_w);
+		seg_max -= BIT(max_w);
 
-	if (!IS_ALIGNED(size, 1 << max_w))
+	if (!IS_ALIGNED(size, BIT(max_w)))
 		return -EINVAL;
 
 	if (size <= seg_max)
@@ -1448,7 +1448,7 @@ static u32 d40_residue(struct d40_chan *d40c)
 			  >> D40_SREG_ELEM_PHY_ECNT_POS;
 	}
 
-	return num_elt * (1 << d40c->dma_cfg.dst_info.data_width);
+	return num_elt << d40c->dma_cfg.dst_info.data_width;
 }
 
 static bool d40_tx_is_linked(struct d40_chan *d40c)
@@ -1722,7 +1722,7 @@ static irqreturn_t d40_handle_interrupt(int irq, void *data)
 		}
 
 		/* ACK interrupt */
-		writel(1 << idx, base->virtbase + il[row].clr);
+		writel(BIT(idx), base->virtbase + il[row].clr);
 
 		spin_lock(&d40c->lock);
 
@@ -1804,9 +1804,9 @@ static int d40_validate_conf(struct d40_chan *d40c,
 	}
 
 	if (d40_psize_2_burst_size(is_log, conf->src_info.psize) *
-	    (1 << conf->src_info.data_width) !=
+	    BIT(conf->src_info.data_width) !=
 	    d40_psize_2_burst_size(is_log, conf->dst_info.psize) *
-	    (1 << conf->dst_info.data_width)) {
+	    BIT(conf->dst_info.data_width)) {
 		/*
 		 * The DMAC hardware only supports
 		 * src (burst x width) == dst (burst x width)
@@ -1848,8 +1848,8 @@ static bool d40_alloc_mask_set(struct d40_phy_res *phy,
 		if (phy->allocated_src == D40_ALLOC_FREE)
 			phy->allocated_src = D40_ALLOC_LOG_FREE;
 
-		if (!(phy->allocated_src & (1 << log_event_line))) {
-			phy->allocated_src |= 1 << log_event_line;
+		if (!(phy->allocated_src & BIT(log_event_line))) {
+			phy->allocated_src |= BIT(log_event_line);
 			goto found;
 		} else
 			goto not_found;
@@ -1860,8 +1860,8 @@ static bool d40_alloc_mask_set(struct d40_phy_res *phy,
 		if (phy->allocated_dst == D40_ALLOC_FREE)
 			phy->allocated_dst = D40_ALLOC_LOG_FREE;
 
-		if (!(phy->allocated_dst & (1 << log_event_line))) {
-			phy->allocated_dst |= 1 << log_event_line;
+		if (!(phy->allocated_dst & BIT(log_event_line))) {
+			phy->allocated_dst |= BIT(log_event_line);
 			goto found;
 		} else
 			goto not_found;
@@ -1891,11 +1891,11 @@ static bool d40_alloc_mask_free(struct d40_phy_res *phy, bool is_src,
 
 	/* Logical channel */
 	if (is_src) {
-		phy->allocated_src &= ~(1 << log_event_line);
+		phy->allocated_src &= ~BIT(log_event_line);
 		if (phy->allocated_src == D40_ALLOC_LOG_FREE)
 			phy->allocated_src = D40_ALLOC_FREE;
 	} else {
-		phy->allocated_dst &= ~(1 << log_event_line);
+		phy->allocated_dst &= ~BIT(log_event_line);
 		if (phy->allocated_dst == D40_ALLOC_LOG_FREE)
 			phy->allocated_dst = D40_ALLOC_FREE;
 	}
@@ -2394,7 +2394,7 @@ static void __d40_set_prio_rt(struct d40_chan *d40c, int dev_type, bool src)
 	u32 rtreg;
 	u32 event = D40_TYPE_TO_EVENT(dev_type);
 	u32 group = D40_TYPE_TO_GROUP(dev_type);
-	u32 bit = 1 << event;
+	u32 bit = BIT(event);
 	u32 prioreg;
 	struct d40_gen_dmac *dmac = &d40c->base->gen_dmac;
