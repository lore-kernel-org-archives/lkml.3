Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756110Ab3CDDnO (ORCPT <rfc822;w@1wt.eu>);
	Sun, 3 Mar 2013 22:43:14 -0500
Received: from shadbolt.e.decadent.org.uk ([88.96.1.126]:60939 "EHLO
	shadbolt.e.decadent.org.uk" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1755876Ab3CDDnC (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 3 Mar 2013 22:43:02 -0500
Message-Id: <20130304033719.095753517@decadent.org.uk>
User-Agent: quilt/0.60-1
Date: Mon, 04 Mar 2013 03:39:04 +0000
From: Ben Hutchings <ben@decadent.org.uk>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org
Cc: akpm@linux-foundation.org, Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Subject: [ 117/153] igb: Remove artificial restriction on RQDPC stat reading
In-Reply-To: <20130304033707.648729212@decadent.org.uk>
X-SA-Exim-Connect-IP: 2001:470:1f08:1539:a11:96ff:fec6:70c4
X-SA-Exim-Mail-From: ben@decadent.org.uk
X-SA-Exim-Scanned: No (on shadbolt.decadent.org.uk); SAEximRunCond expanded to false
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.2-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Alexander Duyck <alexander.h.duyck@intel.com>

commit ae1c07a6b7ced6c0c94c99e3b53f4e7856fa8bff upstream.

For some reason the reading of the RQDPC register was being artificially
limited to 4K.  Instead of limiting the value we should read the value and
add the full amount.  Otherwise this can lead to a misleading number of
dropped packets when the actual value is in fact much higher.

Signed-off-by: Alexander Duyck <alexander.h.duyck@intel.com>
Tested-by: Jeff Pieper   <jeffrey.e.pieper@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Signed-off-by: Ben Hutchings <ben@decadent.org.uk>
---
 drivers/net/ethernet/intel/igb/igb_main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 19d7666..246646b 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4681,11 +4681,13 @@ void igb_update_stats(struct igb_adapter *adapter,
 	bytes = 0;
 	packets = 0;
 	for (i = 0; i < adapter->num_rx_queues; i++) {
-		u32 rqdpc_tmp = rd32(E1000_RQDPC(i)) & 0x0FFF;
+		u32 rqdpc = rd32(E1000_RQDPC(i));
 		struct igb_ring *ring = adapter->rx_ring[i];
 
-		ring->rx_stats.drops += rqdpc_tmp;
-		net_stats->rx_fifo_errors += rqdpc_tmp;
+		if (rqdpc) {
+			ring->rx_stats.drops += rqdpc;
+			net_stats->rx_fifo_errors += rqdpc;
+		}
 
 		do {
 			start = u64_stats_fetch_begin_bh(&ring->rx_syncp);


