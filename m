Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754141Ab3BFLus (ORCPT <rfc822;w@1wt.eu>);
	Wed, 6 Feb 2013 06:50:48 -0500
Received: from va3ehsobe005.messaging.microsoft.com ([216.32.180.31]:19637
	"EHLO va3outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750951Ab3BFLuq (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 6 Feb 2013 06:50:46 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1ee6h1de0h1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1155h)
From: Vakul Garg <vakul@freescale.com>
To: <linux-crypto@vger.kernel.org>
CC: Herbert Xu <herbert@gondor.hengli.com.au>,
        "David S. Miller" <davem@davemloft.net>,
        Kim Phillips <kim.phillips@freescale.com>,
        Shengzhou Liu <Shengzhou.Liu@freescale.com>,
        Alex Porosanu <alexandru.porosanu@freescale.com>,
        <linux-kernel@vger.kernel.org>
Subject: [PATCH] crypto: caam - set RDB bit in security configuration register
Date: Wed, 6 Feb 2013 17:17:46 +0530
Message-ID: <1360151266-28428-1-git-send-email-vakul@freescale.com>
X-Mailer: git-send-email 1.7.7.6
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This change is required for post SEC-5.0 devices which have RNG4. Setting RDB
in security configuration register allows CAAM to use the "Random Data Buffer"
to be filled by a single request. The Random Data Buffer is large enough for
ten packets to get their IVs from a single request. If the Random Data Buffer
is not enabled, then each IV causes a separate request, and RNG4 hardware
cannot keep up resulting in lower IPSEC throughput.

Signed-off-by: Vakul Garg <vakul@freescale.com>
---

 drivers/crypto/caam/ctrl.c |    3 +++
 drivers/crypto/caam/regs.h |    4 +++-
 2 files changed, 6 insertions(+), 1 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index b3fecfa..53dd54e 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -234,6 +234,9 @@ static int caam_probe(struct platform_device *pdev)
 	setbits32(&topregs->ctrl.mcr, MCFGR_WDENABLE |
 		  (sizeof(dma_addr_t) == sizeof(u64) ? MCFGR_LONG_PTR : 0));
 
+	if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
+		setbits32(&topregs->ctrl.scfgr, SCFGR_RDBENABLE);
+
 	if (sizeof(dma_addr_t) == sizeof(u64))
 		if (of_device_is_compatible(nprop, "fsl,sec-v5.0"))
 			dma_set_mask(dev, DMA_BIT_MASK(40));
diff --git a/drivers/crypto/caam/regs.h b/drivers/crypto/caam/regs.h
index 3223fc6..cd6feda 100644
--- a/drivers/crypto/caam/regs.h
+++ b/drivers/crypto/caam/regs.h
@@ -252,7 +252,8 @@ struct caam_ctrl {
 	/* Read/Writable					        */
 	u32 rsvd1;
 	u32 mcr;		/* MCFG      Master Config Register  */
-	u32 rsvd2[2];
+	u32 rsvd2;
+	u32 scfgr;		/* SCFGR, Security Config Register */
 
 	/* Bus Access Configuration Section			010-11f */
 	/* Read/Writable                                                */
@@ -299,6 +300,7 @@ struct caam_ctrl {
 #define MCFGR_WDFAIL		0x20000000 /* DECO watchdog force-fail */
 #define MCFGR_DMA_RESET		0x10000000
 #define MCFGR_LONG_PTR		0x00010000 /* Use >32-bit desc addressing */
+#define SCFGR_RDBENABLE		0x00000400
 
 /* AXI read cache control */
 #define MCFGR_ARCACHE_SHIFT	12
-- 
1.7.7.6


