Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757414Ab3APRFE (ORCPT <rfc822;w@1wt.eu>);
	Wed, 16 Jan 2013 12:05:04 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:35846 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757312Ab3APQAR (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 16 Jan 2013 11:00:17 -0500
From: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: David Woodhouse <David.Woodhouse@intel.com>,
        "David S. Miller" <davem@davemloft.net>,
        Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
Subject: =?UTF-8?q?=5BPATCH=20045/222=5D=208139cp=3A=20set=20ring=20address=20after=20enabling=20C+=20mode?=
Date: Wed, 16 Jan 2013 13:54:05 -0200
Message-Id: <1358351822-7675-46-git-send-email-herton.krzesinski@canonical.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
References: <1358351822-7675-1-git-send-email-herton.krzesinski@canonical.com>
X-Extended-Stable: 3.5
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Content-Transfer-Encoding: 8bit
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.3 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: David Woodhouse <dwmw2@infradead.org>

commit a9dbe40fc10cea2efe6e1ff9e03c62dd7579c5ba upstream.

This fixes (for me) a regression introduced by commit b01af457 ("8139cp:
set ring address before enabling receiver"). That commit configured the
descriptor ring addresses earlier in the initialisation sequence, in
order to avoid the possibility of triggering stray DMA before the
correct address had been set up.

Unfortunately, it seems that the hardware will scribble garbage into the
TxRingAddr registers when we enable "plus mode" Tx in the CpCmd
register. Observed on a Traverse Geos router board.

To deal with this, while not reintroducing the problem which led to the
original commit, we augment cp_start_hw() to write to the CpCmd register
*first*, then set the descriptor ring addresses, and then finally to
enable Rx and Tx in the original 8139 Cmd register. The datasheet
actually indicates that we should enable Tx/Rx in the Cmd register
*before* configuring the descriptor addresses, but that would appear to
re-introduce the problem that the offending commit b01af457 was trying
to solve. And this variant appears to work fine on real hardware.

Signed-off-by: David Woodhouse <David.Woodhouse@intel.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Herton Ronaldo Krzesinski <herton.krzesinski@canonical.com>
---
 drivers/net/ethernet/realtek/8139cp.c |   40 +++++++++++++++++++++++----------
 1 file changed, 28 insertions(+), 12 deletions(-)

diff --git a/drivers/net/ethernet/realtek/8139cp.c b/drivers/net/ethernet/realtek/8139cp.c
index 995d0cf..e0490ad 100644
--- a/drivers/net/ethernet/realtek/8139cp.c
+++ b/drivers/net/ethernet/realtek/8139cp.c
@@ -957,7 +957,35 @@ static void cp_reset_hw (struct cp_private *cp)
 
 static inline void cp_start_hw (struct cp_private *cp)
 {
+	dma_addr_t ring_dma;
+
 	cpw16(CpCmd, cp->cpcmd);
+
+	/*
+	 * These (at least TxRingAddr) need to be configured after the
+	 * corresponding bits in CpCmd are enabled. Datasheet v1.6 §6.33
+	 * (C+ Command Register) recommends that these and more be configured
+	 * *after* the [RT]xEnable bits in CpCmd are set. And on some hardware
+	 * it's been observed that the TxRingAddr is actually reset to garbage
+	 * when C+ mode Tx is enabled in CpCmd.
+	 */
+	cpw32_f(HiTxRingAddr, 0);
+	cpw32_f(HiTxRingAddr + 4, 0);
+
+	ring_dma = cp->ring_dma;
+	cpw32_f(RxRingAddr, ring_dma & 0xffffffff);
+	cpw32_f(RxRingAddr + 4, (ring_dma >> 16) >> 16);
+
+	ring_dma += sizeof(struct cp_desc) * CP_RX_RING_SIZE;
+	cpw32_f(TxRingAddr, ring_dma & 0xffffffff);
+	cpw32_f(TxRingAddr + 4, (ring_dma >> 16) >> 16);
+
+	/*
+	 * Strictly speaking, the datasheet says this should be enabled
+	 * *before* setting the descriptor addresses. But what, then, would
+	 * prevent it from doing DMA to random unconfigured addresses?
+	 * This variant appears to work fine.
+	 */
 	cpw8(Cmd, RxOn | TxOn);
 }
 
@@ -969,7 +997,6 @@ static void cp_enable_irq(struct cp_private *cp)
 static void cp_init_hw (struct cp_private *cp)
 {
 	struct net_device *dev = cp->dev;
-	dma_addr_t ring_dma;
 
 	cp_reset_hw(cp);
 
@@ -979,17 +1006,6 @@ static void cp_init_hw (struct cp_private *cp)
 	cpw32_f (MAC0 + 0, le32_to_cpu (*(__le32 *) (dev->dev_addr + 0)));
 	cpw32_f (MAC0 + 4, le32_to_cpu (*(__le32 *) (dev->dev_addr + 4)));
 
-	cpw32_f(HiTxRingAddr, 0);
-	cpw32_f(HiTxRingAddr + 4, 0);
-
-	ring_dma = cp->ring_dma;
-	cpw32_f(RxRingAddr, ring_dma & 0xffffffff);
-	cpw32_f(RxRingAddr + 4, (ring_dma >> 16) >> 16);
-
-	ring_dma += sizeof(struct cp_desc) * CP_RX_RING_SIZE;
-	cpw32_f(TxRingAddr, ring_dma & 0xffffffff);
-	cpw32_f(TxRingAddr + 4, (ring_dma >> 16) >> 16);
-
 	cp_start_hw(cp);
 	cpw8(TxThresh, 0x06); /* XXX convert magic num to a constant */
 
-- 
1.7.9.5

