Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933024Ab3B1Oux (ORCPT <rfc822;w@1wt.eu>);
	Thu, 28 Feb 2013 09:50:53 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:42505 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S933000Ab3B1Ous (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 28 Feb 2013 09:50:48 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 120/139] igb: Remove artificial restriction on RQDPC stat reading
Date: Thu, 28 Feb 2013 14:44:30 +0000
Message-Id: <1362062689-2567-121-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.1.2
In-Reply-To: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
References: <1362062689-2567-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.5
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.5.7.7 -stable review patch.  If anyone has any objections, please let me know.

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
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 64a0f74..9269192 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4580,11 +4580,13 @@ void igb_update_stats(struct igb_adapter *adapter,
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
-- 
1.8.1.2

