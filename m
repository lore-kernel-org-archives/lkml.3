Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756769Ab3CZXMW (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:12:22 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:53364 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1756703Ab3CZXCA (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 19:02:00 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 10/49] sfc: Fix Siena mac statistics on big endian platforms
Date: Tue, 26 Mar 2013 16:01:07 -0700
Message-Id: <20130326225840.646314145@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326225839.554028294@linuxfoundation.org>
References: <20130326225839.554028294@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Steve Hodgson <shodgson@solarflare.com>

[ Upstream commit a659b2a94d87add999229ecd9f2f56817d5d737b ]

[bwh: Use __force in the one place it's needed]
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/sfc/siena.c |   14 +++++++-------
 1 file changed, 7 insertions(+), 7 deletions(-)

--- a/drivers/net/sfc/siena.c
+++ b/drivers/net/sfc/siena.c
@@ -372,14 +372,13 @@ static void siena_remove_nic(struct efx_
 	efx->nic_data = NULL;
 }
 
-#define STATS_GENERATION_INVALID ((u64)(-1))
+#define STATS_GENERATION_INVALID ((__force __le64)(-1))
 
 static int siena_try_update_nic_stats(struct efx_nic *efx)
 {
-	u64 *dma_stats;
+	__le64 *dma_stats;
 	struct efx_mac_stats *mac_stats;
-	u64 generation_start;
-	u64 generation_end;
+	__le64 generation_start, generation_end;
 
 	mac_stats = &efx->mac_stats;
 	dma_stats = (u64 *)efx->stats_buffer.addr;
@@ -390,7 +389,7 @@ static int siena_try_update_nic_stats(st
 	rmb();
 
 #define MAC_STAT(M, D) \
-	mac_stats->M = dma_stats[MC_CMD_MAC_ ## D]
+	mac_stats->M = le64_to_cpu(dma_stats[MC_CMD_MAC_ ## D])
 
 	MAC_STAT(tx_bytes, TX_BYTES);
 	MAC_STAT(tx_bad_bytes, TX_BAD_BYTES);
@@ -460,7 +459,8 @@ static int siena_try_update_nic_stats(st
 	MAC_STAT(rx_internal_error, RX_INTERNAL_ERROR_PKTS);
 	mac_stats->rx_good_lt64 = 0;
 
-	efx->n_rx_nodesc_drop_cnt = dma_stats[MC_CMD_MAC_RX_NODESC_DROPS];
+	efx->n_rx_nodesc_drop_cnt =
+		le64_to_cpu(dma_stats[MC_CMD_MAC_RX_NODESC_DROPS]);
 
 #undef MAC_STAT
 
@@ -489,7 +489,7 @@ static void siena_update_nic_stats(struc
 
 static void siena_start_nic_stats(struct efx_nic *efx)
 {
-	u64 *dma_stats = (u64 *)efx->stats_buffer.addr;
+	__le64 *dma_stats = efx->stats_buffer.addr;
 
 	dma_stats[MC_CMD_MAC_GENERATION_END] = STATS_GENERATION_INVALID;
 


