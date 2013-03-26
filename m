Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756424Ab3CZXW0 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 19:22:26 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:52991 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755484Ab3CZWwS (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 18:52:18 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Ben Hutchings <bhutchings@solarflare.com>
Subject: [ 19/72] sfc: Really disable flow control while flushing
Date: Tue, 26 Mar 2013 15:51:02 -0700
Message-Id: <20130326224921.701718773@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130326224919.675227837@linuxfoundation.org>
References: <20130326224919.675227837@linuxfoundation.org>
User-Agent: quilt/0.60-5.1.1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.4-stable review patch.  If anyone has any objections, please let me know.

------------------


From: Ben Hutchings <bhutchings@solarflare.com>

[ Upstream commit d5e8cc6c946e0857826dcfbb3585068858445bfe ]

Receiving pause frames can block TX queue flushes.  Earlier changes
work around this by reconfiguring the MAC during flushes for VFs, but
during flushes for the PF we would only change the fc_disable counter.
Unless the MAC is reconfigured for some other reason during the flush
(which I would not expect to happen) this had no effect at all.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/falcon.c      |    2 ++
 drivers/net/ethernet/sfc/net_driver.h  |    2 ++
 drivers/net/ethernet/sfc/nic.c         |    3 +--
 drivers/net/ethernet/sfc/nic.h         |    2 ++
 drivers/net/ethernet/sfc/siena.c       |   15 ++++++++++++++-
 drivers/net/ethernet/sfc/siena_sriov.c |    6 ++----
 6 files changed, 23 insertions(+), 7 deletions(-)

--- a/drivers/net/ethernet/sfc/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon.c
@@ -1765,6 +1765,7 @@ const struct efx_nic_type falcon_a1_nic_
 	.remove_port = falcon_remove_port,
 	.handle_global_event = falcon_handle_global_event,
 	.prepare_flush = falcon_prepare_flush,
+	.finish_flush = efx_port_dummy_op_void,
 	.update_stats = falcon_update_nic_stats,
 	.start_stats = falcon_start_nic_stats,
 	.stop_stats = falcon_stop_nic_stats,
@@ -1807,6 +1808,7 @@ const struct efx_nic_type falcon_b0_nic_
 	.remove_port = falcon_remove_port,
 	.handle_global_event = falcon_handle_global_event,
 	.prepare_flush = falcon_prepare_flush,
+	.finish_flush = efx_port_dummy_op_void,
 	.update_stats = falcon_update_nic_stats,
 	.start_stats = falcon_start_nic_stats,
 	.stop_stats = falcon_stop_nic_stats,
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -887,6 +887,7 @@ static inline unsigned int efx_port_num(
  * @remove_port: Free resources allocated by probe_port()
  * @handle_global_event: Handle a "global" event (may be %NULL)
  * @prepare_flush: Prepare the hardware for flushing the DMA queues
+ * @finish_flush: Clean up after flushing the DMA queues
  * @update_stats: Update statistics not provided by event handling
  * @start_stats: Start the regular fetching of statistics
  * @stop_stats: Stop the regular fetching of statistics
@@ -933,6 +934,7 @@ struct efx_nic_type {
 	void (*remove_port)(struct efx_nic *efx);
 	bool (*handle_global_event)(struct efx_channel *channel, efx_qword_t *);
 	void (*prepare_flush)(struct efx_nic *efx);
+	void (*finish_flush)(struct efx_nic *efx);
 	void (*update_stats)(struct efx_nic *efx);
 	void (*start_stats)(struct efx_nic *efx);
 	void (*stop_stats)(struct efx_nic *efx);
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -681,7 +681,6 @@ int efx_nic_flush_queues(struct efx_nic
 	struct efx_tx_queue *tx_queue;
 	int rc = 0;
 
-	efx->fc_disable++;
 	efx->type->prepare_flush(efx);
 
 	efx_for_each_channel(channel, efx) {
@@ -743,7 +742,7 @@ int efx_nic_flush_queues(struct efx_nic
 		atomic_set(&efx->rxq_flush_outstanding, 0);
 	}
 
-	efx->fc_disable--;
+	efx->type->finish_flush(efx);
 
 	return rc;
 }
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -316,6 +316,8 @@ static inline int efx_nic_irq_test_irq_c
 
 /* Global Resources */
 extern int efx_nic_flush_queues(struct efx_nic *efx);
+extern void siena_prepare_flush(struct efx_nic *efx);
+extern void siena_finish_flush(struct efx_nic *efx);
 extern void falcon_start_nic_stats(struct efx_nic *efx);
 extern void falcon_stop_nic_stats(struct efx_nic *efx);
 extern void falcon_setup_xaui(struct efx_nic *efx);
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -125,6 +125,18 @@ static void siena_remove_port(struct efx
 	efx_nic_free_buffer(efx, &efx->stats_buffer);
 }
 
+void siena_prepare_flush(struct efx_nic *efx)
+{
+	if (efx->fc_disable++ == 0)
+		efx_mcdi_set_mac(efx);
+}
+
+void siena_finish_flush(struct efx_nic *efx)
+{
+	if (--efx->fc_disable == 0)
+		efx_mcdi_set_mac(efx);
+}
+
 static const struct efx_nic_register_test siena_register_tests[] = {
 	{ FR_AZ_ADR_REGION,
 	  EFX_OWORD32(0x0003FFFF, 0x0003FFFF, 0x0003FFFF, 0x0003FFFF) },
@@ -637,7 +649,8 @@ const struct efx_nic_type siena_a0_nic_t
 	.reset = siena_reset_hw,
 	.probe_port = siena_probe_port,
 	.remove_port = siena_remove_port,
-	.prepare_flush = efx_port_dummy_op_void,
+	.prepare_flush = siena_prepare_flush,
+	.finish_flush = siena_finish_flush,
 	.update_stats = siena_update_nic_stats,
 	.start_stats = siena_start_nic_stats,
 	.stop_stats = siena_stop_nic_stats,
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -688,8 +688,7 @@ static int efx_vfdi_fini_all_queues(stru
 		return VFDI_RC_ENOMEM;
 
 	rtnl_lock();
-	if (efx->fc_disable++ == 0)
-		efx_mcdi_set_mac(efx);
+	siena_prepare_flush(efx);
 	rtnl_unlock();
 
 	/* Flush all the initialized queues */
@@ -726,8 +725,7 @@ static int efx_vfdi_fini_all_queues(stru
 	}
 
 	rtnl_lock();
-	if (--efx->fc_disable == 0)
-		efx_mcdi_set_mac(efx);
+	siena_finish_flush(efx);
 	rtnl_unlock();
 
 	/* Irrespective of success/failure, fini the queues */


