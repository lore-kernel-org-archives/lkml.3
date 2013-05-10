Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753236Ab3EJNTn (ORCPT <rfc822;w@1wt.eu>);
	Fri, 10 May 2013 09:19:43 -0400
Received: from eusmtp01.atmel.com ([212.144.249.243]:1938 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753171Ab3EJNTm (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 10 May 2013 09:19:42 -0400
From: Nicolas Ferre <nicolas.ferre@atmel.com>
To: Vinod Koul <vinod.koul@intel.com>, <linux-arm-kernel@lists.infradead.org>
CC: <linux-kernel@vger.kernel.org>,
        Ludovic Desroches <ludovic.desroches@atmel.com>,
        Jean-Christophe PLAGNIOL-VILLARD <plagnioj@jcrosoft.com>,
        Nicolas Ferre <nicolas.ferre@atmel.com>
Subject: [PATCH 2/3] dmaengine: at_hdmac: extend hardware handshaking interface identification
Date: Fri, 10 May 2013 15:19:14 +0200
Message-ID: <136a15966daabbb99360411f225adc14fcc763f3.1368191734.git.nicolas.ferre@atmel.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <042cac60509755c1340d141315a9a8eb1965438a.1368191734.git.nicolas.ferre@atmel.com>
References: <042cac60509755c1340d141315a9a8eb1965438a.1368191734.git.nicolas.ferre@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Peripheral handshaking identification numbers can be bigger than 15, so new
fields have been created in the CFG register.
Add macros to take this modification into account and use them in
at_dma_xlate() function.

Signed-off-by: Nicolas Ferre <nicolas.ferre@atmel.com>
---
 drivers/dma/at_hdmac.c                  | 2 ++
 include/linux/platform_data/dma-atmel.h | 4 ++++
 2 files changed, 6 insertions(+)

diff --git a/drivers/dma/at_hdmac.c b/drivers/dma/at_hdmac.c
index cd49420..78c3fb4 100644
--- a/drivers/dma/at_hdmac.c
+++ b/drivers/dma/at_hdmac.c
@@ -1230,6 +1230,8 @@ static struct dma_chan *at_dma_xlate(struct of_phandle_args *dma_spec,
 	per_id = dma_spec->args[1];
 	atslave->cfg = ATC_FIFOCFG_HALFFIFO | ATC_DST_H2SEL_HW
 		      | ATC_SRC_H2SEL_HW | ATC_DST_PER(per_id)
+		      | ATC_DST_PER_MSB(per_id)
+		      | ATC_SRC_PER_MSB(per_id)
 		      | ATC_SRC_PER(per_id);
 	atslave->dma_dev = &dmac_pdev->dev;
 
diff --git a/include/linux/platform_data/dma-atmel.h b/include/linux/platform_data/dma-atmel.h
index cab0997..e95f19c 100644
--- a/include/linux/platform_data/dma-atmel.h
+++ b/include/linux/platform_data/dma-atmel.h
@@ -35,16 +35,20 @@ struct at_dma_slave {
 
 
 /* Platform-configurable bits in CFG */
+#define ATC_PER_MSB(h)	((0x30U & (h)) >> 4)	/* Extract most significant bits of a handshaking identifier */
+
 #define	ATC_SRC_PER(h)		(0xFU & (h))	/* Channel src rq associated with periph handshaking ifc h */
 #define	ATC_DST_PER(h)		((0xFU & (h)) <<  4)	/* Channel dst rq associated with periph handshaking ifc h */
 #define	ATC_SRC_REP		(0x1 <<  8)	/* Source Replay Mod */
 #define	ATC_SRC_H2SEL		(0x1 <<  9)	/* Source Handshaking Mod */
 #define		ATC_SRC_H2SEL_SW	(0x0 <<  9)
 #define		ATC_SRC_H2SEL_HW	(0x1 <<  9)
+#define	ATC_SRC_PER_MSB(h)	(ATC_PER_MSB(h) << 10)	/* Channel src rq (most significant bits) */
 #define	ATC_DST_REP		(0x1 << 12)	/* Destination Replay Mod */
 #define	ATC_DST_H2SEL		(0x1 << 13)	/* Destination Handshaking Mod */
 #define		ATC_DST_H2SEL_SW	(0x0 << 13)
 #define		ATC_DST_H2SEL_HW	(0x1 << 13)
+#define	ATC_DST_PER_MSB(h)	(ATC_PER_MSB(h) << 14)	/* Channel dst rq (most significant bits) */
 #define	ATC_SOD			(0x1 << 16)	/* Stop On Done */
 #define	ATC_LOCK_IF		(0x1 << 20)	/* Interface Lock */
 #define	ATC_LOCK_B		(0x1 << 21)	/* AHB Bus Lock */
-- 
1.8.0

