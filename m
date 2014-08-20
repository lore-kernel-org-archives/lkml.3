Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753261AbaHTLuL (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Aug 2014 07:50:11 -0400
Received: from ip4-83-240-18-248.cust.nbox.cz ([83.240.18.248]:59021 "EHLO
	ip4-83-240-18-248.cust.nbox.cz" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752618AbaHTLoL (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Aug 2014 07:44:11 -0400
From: Jiri Slaby <jslaby@suse.cz>
To: stable@vger.kernel.org
Cc: linux-kernel@vger.kernel.org, David Gibson <david@gibson.dropbear.id.au>,
        "David S. Miller" <davem@davemloft.net>, Jiri Slaby <jslaby@suse.cz>
Subject: [PATCH 3.12 092/104] netxen: Correct off-by-one errors in bounds checks
Date: Wed, 20 Aug 2014 13:43:55 +0200
Message-Id: <901de023d3162f4164869aa8f4a616e5ac8b5869.1408535000.git.jslaby@suse.cz>
X-Mailer: git-send-email 2.0.4
In-Reply-To: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
References: <cbcbb4c4826ff594b091e143b0f049f13ab7a64e.1408535000.git.jslaby@suse.cz>
In-Reply-To: <cover.1408535000.git.jslaby@suse.cz>
References: <cover.1408535000.git.jslaby@suse.cz>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: David Gibson <david@gibson.dropbear.id.au>

3.12-stable review patch.  If anyone has any objections, please let me know.

===============

commit 4710b2ba873692194c636811ceda398f95e02db2 upstream.

netxen_process_lro() contains two bounds checks.  One for the ring number
against the number of rings, and one for the Rx buffer ID against the
array of receive buffers.

Both of these have off-by-one errors, using > instead of >=. The correct
versions are used in netxen_process_rcv(), they're just wrong in
netxen_process_lro().

Signed-off-by: David Gibson <david@gibson.dropbear.id.au>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Jiri Slaby <jslaby@suse.cz>
---
 drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c | 4 ++--
 1 file changed, 2 insertions(+), 2 deletions(-)

diff --git a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
index 7692dfd4f262..cc68657f0536 100644
--- a/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
+++ b/drivers/net/ethernet/qlogic/netxen/netxen_nic_init.c
@@ -1604,13 +1604,13 @@ netxen_process_lro(struct netxen_adapter *adapter,
 	u32 seq_number;
 	u8 vhdr_len = 0;
 
-	if (unlikely(ring > adapter->max_rds_rings))
+	if (unlikely(ring >= adapter->max_rds_rings))
 		return NULL;
 
 	rds_ring = &recv_ctx->rds_rings[ring];
 
 	index = netxen_get_lro_sts_refhandle(sts_data0);
-	if (unlikely(index > rds_ring->num_desc))
+	if (unlikely(index >= rds_ring->num_desc))
 		return NULL;
 
 	buffer = &rds_ring->rx_buf_arr[index];
-- 
2.0.4

