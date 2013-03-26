Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S965451Ab3CZPdf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 26 Mar 2013 11:33:35 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:54108 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S965339Ab3CZPXr (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 26 Mar 2013 11:23:47 -0400
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Ben Hutchings <bhutchings@solarflare.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 124/150] sfc: Really disable flow control while flushing
Date: Tue, 26 Mar 2013 15:20:23 +0000
Message-Id: <1364311249-14454-125-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
References: <1364311249-14454-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.9 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Ben Hutchings <bhutchings@solarflare.com>

commit d5e8cc6c946e0857826dcfbb3585068858445bfe upstream.

Receiving pause frames can block TX queue flushes.  Earlier changes
work around this by reconfiguring the MAC during flushes for VFs, but
during flushes for the PF we would only change the fc_disable counter.
Unless the MAC is reconfigured for some other reason during the flush
(which I would not expect to happen) this had no effect at all.

Signed-off-by: Ben Hutchings <bhutchings@solarflare.com>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/sfc/falcon.c      |  2 ++
 drivers/net/ethernet/sfc/net_driver.h  |  2 ++
 drivers/net/ethernet/sfc/nic.c         |  3 +--
 drivers/net/ethernet/sfc/nic.h         |  2 ++
 drivers/net/ethernet/sfc/siena.c       | 15 ++++++++++++++-
 drivers/net/ethernet/sfc/siena_sriov.c |  6 ++----
 6 files changed, 23 insertions(+), 7 deletions(-)

diff --git a/drivers/net/ethernet/sfc/falcon.c b/drivers/net/ethernet/sfc/falcon.c
index 12b573a..49bcd19 100644
--- a/drivers/net/ethernet/sfc/falcon.c
+++ b/drivers/net/ethernet/sfc/falcon.c
@@ -1792,6 +1792,7 @@ const struct efx_nic_type falcon_a1_nic_type = {
 	.remove_port = falcon_remove_port,
 	.handle_global_event = falcon_handle_global_event,
 	.prepare_flush = falcon_prepare_flush,
+	.finish_flush = efx_port_dummy_op_void,
 	.update_stats = falcon_update_nic_stats,
 	.start_stats = falcon_start_nic_stats,
 	.stop_stats = falcon_stop_nic_stats,
@@ -1834,6 +1835,7 @@ const struct efx_nic_type falcon_b0_nic_type = {
 	.remove_port = falcon_remove_port,
 	.handle_global_event = falcon_handle_global_event,
 	.prepare_flush = falcon_prepare_flush,
+	.finish_flush = efx_port_dummy_op_void,
 	.update_stats = falcon_update_nic_stats,
 	.start_stats = falcon_start_nic_stats,
 	.stop_stats = falcon_stop_nic_stats,
diff --git a/drivers/net/ethernet/sfc/net_driver.h b/drivers/net/ethernet/sfc/net_driver.h
index f80659e..cb7fd7c 100644
--- a/drivers/net/ethernet/sfc/net_driver.h
+++ b/drivers/net/ethernet/sfc/net_driver.h
@@ -891,6 +891,7 @@ static inline unsigned int efx_port_num(struct efx_nic *efx)
  * @remove_port: Free resources allocated by probe_port()
  * @handle_global_event: Handle a "global" event (may be %NULL)
  * @prepare_flush: Prepare the hardware for flushing the DMA queues
+ * @finish_flush: Clean up after flushing the DMA queues
  * @update_stats: Update statistics not provided by event handling
  * @start_stats: Start the regular fetching of statistics
  * @stop_stats: Stop the regular fetching of statistics
@@ -938,6 +939,7 @@ struct efx_nic_type {
 	void (*remove_port)(struct efx_nic *efx);
 	bool (*handle_global_event)(struct efx_channel *channel, efx_qword_t *);
 	void (*prepare_flush)(struct efx_nic *efx);
+	void (*finish_flush)(struct efx_nic *efx);
 	void (*update_stats)(struct efx_nic *efx);
 	void (*start_stats)(struct efx_nic *efx);
 	void (*stop_stats)(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/nic.c b/drivers/net/ethernet/sfc/nic.c
index 3821432..c44a3a0 100644
--- a/drivers/net/ethernet/sfc/nic.c
+++ b/drivers/net/ethernet/sfc/nic.c
@@ -678,7 +678,6 @@ int efx_nic_flush_queues(struct efx_nic *efx)
 	struct efx_tx_queue *tx_queue;
 	int rc = 0;
 
-	efx->fc_disable++;
 	efx->type->prepare_flush(efx);
 
 	efx_for_each_channel(channel, efx) {
@@ -740,7 +739,7 @@ int efx_nic_flush_queues(struct efx_nic *efx)
 		atomic_set(&efx->rxq_flush_outstanding, 0);
 	}
 
-	efx->fc_disable--;
+	efx->type->finish_flush(efx);
 
 	return rc;
 }
diff --git a/drivers/net/ethernet/sfc/nic.h b/drivers/net/ethernet/sfc/nic.h
index f48ccf6..bbdfcd6 100644
--- a/drivers/net/ethernet/sfc/nic.h
+++ b/drivers/net/ethernet/sfc/nic.h
@@ -316,6 +316,8 @@ static inline int efx_nic_irq_test_irq_cpu(struct efx_nic *efx)
 
 /* Global Resources */
 extern int efx_nic_flush_queues(struct efx_nic *efx);
+extern void siena_prepare_flush(struct efx_nic *efx);
+extern void siena_finish_flush(struct efx_nic *efx);
 extern void falcon_start_nic_stats(struct efx_nic *efx);
 extern void falcon_stop_nic_stats(struct efx_nic *efx);
 extern void falcon_setup_xaui(struct efx_nic *efx);
diff --git a/drivers/net/ethernet/sfc/siena.c b/drivers/net/ethernet/sfc/siena.c
index 2354886..2011319 100644
--- a/drivers/net/ethernet/sfc/siena.c
+++ b/drivers/net/ethernet/sfc/siena.c
@@ -127,6 +127,18 @@ static void siena_remove_port(struct efx_nic *efx)
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
@@ -658,7 +670,8 @@ const struct efx_nic_type siena_a0_nic_type = {
 	.reset = siena_reset_hw,
 	.probe_port = siena_probe_port,
 	.remove_port = siena_remove_port,
-	.prepare_flush = efx_port_dummy_op_void,
+	.prepare_flush = siena_prepare_flush,
+	.finish_flush = siena_finish_flush,
 	.update_stats = siena_update_nic_stats,
 	.start_stats = siena_start_nic_stats,
 	.stop_stats = siena_stop_nic_stats,
diff --git a/drivers/net/ethernet/sfc/siena_sriov.c b/drivers/net/ethernet/sfc/siena_sriov.c
index 9cb3b84..78f5408 100644
--- a/drivers/net/ethernet/sfc/siena_sriov.c
+++ b/drivers/net/ethernet/sfc/siena_sriov.c
@@ -688,8 +688,7 @@ static int efx_vfdi_fini_all_queues(struct efx_vf *vf)
 		return VFDI_RC_ENOMEM;
 
 	rtnl_lock();
-	if (efx->fc_disable++ == 0)
-		efx_mcdi_set_mac(efx);
+	siena_prepare_flush(efx);
 	rtnl_unlock();
 
 	/* Flush all the initialized queues */
@@ -726,8 +725,7 @@ static int efx_vfdi_fini_all_queues(struct efx_vf *vf)
 	}
 
 	rtnl_lock();
-	if (--efx->fc_disable == 0)
-		efx_mcdi_set_mac(efx);
+	siena_finish_flush(efx);
 	rtnl_unlock();
 
 	/* Irrespective of success/failure, fini the queues */
-- 
1.8.1.2

