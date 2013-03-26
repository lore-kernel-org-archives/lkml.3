Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756674Ab3CZXYa (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:24:30 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52956 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755970Ab3CZWwL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:11 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 20/72] sfc: Work-around flush timeout when flushes have completed
Date: Tue, 26 Mar 2013 15:51:03 -0700
Message-Id: <20130326224921.801486051@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Daniel Pieczko <dpieczko@solarflare.com>

[ Upstream commit 525d9e824018cd7cc8d8d44832ddcd363abfe6e1 ]

We sometimes hit a "failed to flush" timeout on some TX queues, but the
flushes have completed and the flush completion events seem to go missing.
In this case, we can check the TX_DESC_PTR_TBL register and drain the
queues if the flushes had finished.

[bwh: Minor fixes to coding style]
Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/net_driver.h |    1 
 drivers/net/ethernet/sfc/nic.c        |   56 +++++++++++++++++++++++++++++++---
 2 files changed, 53 insertions(+), 4 deletions(-)

--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -194,6 +194,7 @@ struct efx_tx_queue {
 	/* Members shared between paths and sometimes updated */
 	unsigned int empty_read_count ____cacheline_aligned_in_smp;
 #define EFX_EMPTY_COUNT_VALID 0x80000000
+	atomic_t flush_outstanding;
 };
 
 /**
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -73,6 +73,8 @@
 	_EFX_CHANNEL_MAGIC(_EFX_CHANNEL_MAGIC_TX_DRAIN,			\
 			   (_tx_queue)->queue)
 
+static void efx_magic_event(struct efx_channel *channel, u32 magic);
+
 /**************************************************************************
  *
  * Solarstorm hardware access
@@ -495,6 +497,9 @@ static void efx_flush_tx_queue(struct ef
 	struct efx_nic *efx = tx_queue->efx;
 	efx_oword_t tx_flush_descq;
 
+	WARN_ON(atomic_read(&tx_queue->flush_outstanding));
+	atomic_set(&tx_queue->flush_outstanding, 1);
+
 	EFX_POPULATE_OWORD_2(tx_flush_descq,
 			     FRF_AZ_TX_FLUSH_DESCQ_CMD, 1,
 			     FRF_AZ_TX_FLUSH_DESCQ, tx_queue->queue);
@@ -670,6 +675,47 @@ static bool efx_flush_wake(struct efx_ni
 		 && atomic_read(&efx->rxq_flush_pending) > 0));
 }
 
+static bool efx_check_tx_flush_complete(struct efx_nic *efx)
+{
+	bool i = true;
+	efx_oword_t txd_ptr_tbl;
+	struct efx_channel *channel;
+	struct efx_tx_queue *tx_queue;
+
+	efx_for_each_channel(channel, efx) {
+		efx_for_each_channel_tx_queue(tx_queue, channel) {
+			efx_reado_table(efx, &txd_ptr_tbl,
+					FR_BZ_TX_DESC_PTR_TBL, tx_queue->queue);
+			if (EFX_OWORD_FIELD(txd_ptr_tbl,
+					    FRF_AZ_TX_DESCQ_FLUSH) ||
+			    EFX_OWORD_FIELD(txd_ptr_tbl,
+					    FRF_AZ_TX_DESCQ_EN)) {
+				netif_dbg(efx, hw, efx->net_dev,
+					  "flush did not complete on TXQ %d\n",
+					  tx_queue->queue);
+				i = false;
+			} else if (atomic_cmpxchg(&tx_queue->flush_outstanding,
+						  1, 0)) {
+				/* The flush is complete, but we didn't
+				 * receive a flush completion event
+				 */
+				netif_dbg(efx, hw, efx->net_dev,
+					  "flush complete on TXQ %d, so drain "
+					  "the queue\n", tx_queue->queue);
+				/* Don't need to increment drain_pending as it
+				 * has already been incremented for the queues
+				 * which did not drain
+				 */
+				efx_magic_event(channel,
+						EFX_CHANNEL_MAGIC_TX_DRAIN(
+							tx_queue));
+			}
+		}
+	}
+
+	return i;
+}
+
 /* Flush all the transmit queues, and continue flushing receive queues until
  * they're all flushed. Wait for the DRAIN events to be recieved so that there
  * are no more RX and TX events left on any channel. */
@@ -730,7 +776,8 @@ int efx_nic_flush_queues(struct efx_nic
 					     timeout);
 	}
 
-	if (atomic_read(&efx->drain_pending)) {
+	if (atomic_read(&efx->drain_pending) &&
+	    !efx_check_tx_flush_complete(efx)) {
 		netif_err(efx, hw, efx->net_dev, "failed to flush %d queues "
 			  "(rx %d+%d)\n", atomic_read(&efx->drain_pending),
 			  atomic_read(&efx->rxq_flush_outstanding),
@@ -1017,9 +1064,10 @@ efx_handle_tx_flush_done(struct efx_nic
 	if (qid < EFX_TXQ_TYPES * efx->n_tx_channels) {
 		tx_queue = efx_get_tx_queue(efx, qid / EFX_TXQ_TYPES,
 					    qid % EFX_TXQ_TYPES);
-
-		efx_magic_event(tx_queue->channel,
-				EFX_CHANNEL_MAGIC_TX_DRAIN(tx_queue));
+		if (atomic_cmpxchg(&tx_queue->flush_outstanding, 1, 0)) {
+			efx_magic_event(tx_queue->channel,
+					EFX_CHANNEL_MAGIC_TX_DRAIN(tx_queue));
+		}
 	}
 }
 


