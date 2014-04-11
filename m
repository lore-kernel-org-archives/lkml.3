Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759809AbaDKQRz (ORCPT <rfc822;w@1wt.eu>);
	Fri, 11 Apr 2014 12:17:55 -0400
Received: from mail.linuxfoundation.org ([140.211.169.12]:56794 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1759282AbaDKQJ3 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 11 Apr 2014 12:09:29 -0400
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Shradha Shah <sshah@solarflare.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.14 12/23] Call efx_set_channels() before efx->type->dimension_resources()
Date: Fri, 11 Apr 2014 09:12:01 -0700
Message-Id: <20140411161201.929555705@linuxfoundation.org>
X-Mailer: git-send-email 1.9.0
In-Reply-To: <20140411161200.236939691@linuxfoundation.org>
References: <20140411161200.236939691@linuxfoundation.org>
User-Agent: quilt/0.60-1
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.14-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Daniel Pieczko <dpieczko@solarflare.com>

[ Upstream commit 52ad762b85ed7947ec9eff6b036eb985352f6874 ]

When using the "separate_tx_channels=1" module parameter, the TX queues are
initially numbered starting from the first TX-only channel number (after all the
RX-only channels).  efx_set_channels() renumbers the queues so that they are
indexed from zero.

On EF10, the TX queues need to be relabelled in this way before calling the
dimension_resources NIC type operation, otherwise the TX queue PIO buffers can be
linked to the wrong VIs when using "separate_tx_channels=1".

Added comments to explain UC/WC mappings for PIO buffers

Signed-off-by: Shradha Shah <sshah@solarflare.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/sfc/ef10.c |    7 +++++++
 drivers/net/ethernet/sfc/efx.c  |    3 ++-
 2 files changed, 9 insertions(+), 1 deletion(-)

--- a/drivers/net/ethernet/sfc/ef10.c
+++ b/drivers/net/ethernet/sfc/ef10.c
@@ -565,10 +565,17 @@ static int efx_ef10_dimension_resources(
 	 * several of each (in fact that's the only option if host
 	 * page size is >4K).  So we may allocate some extra VIs just
 	 * for writing PIO buffers through.
+	 *
+	 * The UC mapping contains (min_vis - 1) complete VIs and the
+	 * first half of the next VI.  Then the WC mapping begins with
+	 * the second half of this last VI.
 	 */
 	uc_mem_map_size = PAGE_ALIGN((min_vis - 1) * EFX_VI_PAGE_SIZE +
 				     ER_DZ_TX_PIOBUF);
 	if (nic_data->n_piobufs) {
+		/* pio_write_vi_base rounds down to give the number of complete
+		 * VIs inside the UC mapping.
+		 */
 		pio_write_vi_base = uc_mem_map_size / EFX_VI_PAGE_SIZE;
 		wc_mem_map_size = (PAGE_ALIGN((pio_write_vi_base +
 					       nic_data->n_piobufs) *
--- a/drivers/net/ethernet/sfc/efx.c
+++ b/drivers/net/ethernet/sfc/efx.c
@@ -1603,6 +1603,8 @@ static int efx_probe_nic(struct efx_nic
 	if (rc)
 		goto fail1;
 
+	efx_set_channels(efx);
+
 	rc = efx->type->dimension_resources(efx);
 	if (rc)
 		goto fail2;
@@ -1613,7 +1615,6 @@ static int efx_probe_nic(struct efx_nic
 		efx->rx_indir_table[i] =
 			ethtool_rxfh_indir_default(i, efx->rss_spread);
 
-	efx_set_channels(efx);
 	netif_set_real_num_tx_queues(efx->net_dev, efx->n_tx_channels);
 	netif_set_real_num_rx_queues(efx->net_dev, efx->n_rx_channels);
 


