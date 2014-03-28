Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753878AbaC1Rok (ORCPT <rfc822;w@1wt.eu>);
	Fri, 28 Mar 2014 13:44:40 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:51355 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1753125AbaC1RbF (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 28 Mar 2014 13:31:05 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>,
        Shradha Shah <sshah@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.13 18/46] sfc: Use the correct maximum TX DMA ring size for SFC9100
Date: Fri, 28 Mar 2014 10:32:02 -0700
Message-Id: <20140328173137.130536313@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140328173134.630198216@linuxfoundation.org>
References: <20140328173134.630198216@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.13-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit d9317aea16ecec7694271ef11fb7791a0f0d9cc5 upstream.

As part of a workaround for a hardware erratum in the SFC9100 family
(SF bug 35388), the TX_DESC_UPD_DWORD register address is also used
for communicating with the event block, and only descriptor pointer
values < 2048 are valid.

If the TX DMA ring size is increased to 4096 descriptors (which the
firmware still allows) then we may write a descriptor pointer
value >= 2048, which has entirely different and undesirable effects!

Limit the TX DMA ring size correctly when this workaround is in
effect.

Fixes: 8127d661e77f ('sfc: Add support for Solarflare SFC9100 family')
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Shradha Shah <sshah@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/sfc/efx.h     |    3 +++
 drivers/net/ethernet/sfc/ethtool.c |    4 ++--
 2 files changed, 5 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/sfc/efx.h
+++ b/drivers/net/ethernet/sfc/efx.h
@@ -66,6 +66,9 @@ void efx_schedule_slow_fill(struct efx_r
 #define EFX_RXQ_MIN_ENT		128U
 #define EFX_TXQ_MIN_ENT(efx)	(2 * efx_tx_max_skb_descs(efx))
 
+#define EFX_TXQ_MAX_ENT(efx)	(EFX_WORKAROUND_35388(efx) ? \
+				 EFX_MAX_DMAQ_SIZE / 2 : EFX_MAX_DMAQ_SIZE)
+
 /* Filters */
 
 /**
--- a/drivers/net/ethernet/sfc/ethtool.c
+++ b/drivers/net/ethernet/sfc/ethtool.c
@@ -583,7 +583,7 @@ static void efx_ethtool_get_ringparam(st
 	struct efx_nic *efx = netdev_priv(net_dev);
 
 	ring->rx_max_pending = EFX_MAX_DMAQ_SIZE;
-	ring->tx_max_pending = EFX_MAX_DMAQ_SIZE;
+	ring->tx_max_pending = EFX_TXQ_MAX_ENT(efx);
 	ring->rx_pending = efx->rxq_entries;
 	ring->tx_pending = efx->txq_entries;
 }
@@ -596,7 +596,7 @@ static int efx_ethtool_set_ringparam(str
 
 	if (ring->rx_mini_pending || ring->rx_jumbo_pending ||
 	    ring->rx_pending > EFX_MAX_DMAQ_SIZE ||
-	    ring->tx_pending > EFX_MAX_DMAQ_SIZE)
+	    ring->tx_pending > EFX_TXQ_MAX_ENT(efx))
 		return -EINVAL;
 
 	if (ring->rx_pending < EFX_RXQ_MIN_ENT) {


