Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S933020AbaGVXBN (ORCPT <rfc822;w@1wt.eu>);
	Tue, 22 Jul 2014 19:01:13 -0400
Received: from youngberry.canonical.com ([91.189.89.112]:44323 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1755978AbaGVWWd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 22 Jul 2014 18:22:33 -0400
From: Kamal Mostafa <kamal@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Todd Fujinaka <todd.fujinaka@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Tim Gardner <tim.gardner@canonical.com>,
        Kamal Mostafa <kamal@canonical.com>
Subject: [PATCH 3.8 001/116] igb: fix stats for i210 rx_fifo_errors
Date: Tue, 22 Jul 2014 15:20:12 -0700
Message-Id: <1406067727-19683-2-git-send-email-kamal@canonical.com>
X-Mailer: git-send-email 1.9.1
In-Reply-To: <1406067727-19683-1-git-send-email-kamal@canonical.com>
References: <1406067727-19683-1-git-send-email-kamal@canonical.com>
X-Extended-Stable: 3.8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.8.13.27 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: Todd Fujinaka <todd.fujinaka@intel.com>

commit e66c083aab32842f225bae2a2c30744bf96abaec upstream.

RQDPC on i210/i211 is R/W not ReadClear. Clear after reading.

Signed-off-by: Todd Fujinaka <todd.fujinaka@intel.com>
Tested-by: Aaron Brown <aaron.f.brown@intel.com>
Signed-off-by: Jeff Kirsher <jeffrey.t.kirsher@intel.com>
Cc: Tim Gardner <tim.gardner@canonical.com>
Signed-off-by: Kamal Mostafa <kamal@canonical.com>
---
 drivers/net/ethernet/intel/igb/igb_main.c | 4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/intel/igb/igb_main.c b/drivers/net/ethernet/intel/igb/igb_main.c
index 31cfe2e..40f80c3 100644
--- a/drivers/net/ethernet/intel/igb/igb_main.c
+++ b/drivers/net/ethernet/intel/igb/igb_main.c
@@ -4592,8 +4592,10 @@ void igb_update_stats(struct igb_adapter *adapter,
 	bytes = 0;
 	packets = 0;
 	for (i = 0; i < adapter->num_rx_queues; i++) {
-		u32 rqdpc = rd32(E1000_RQDPC(i));
 		struct igb_ring *ring = adapter->rx_ring[i];
+		u32 rqdpc = rd32(E1000_RQDPC(i));
+		if (hw->mac.type >= e1000_i210)
+			wr32(E1000_RQDPC(i), 0);
 
 		if (rqdpc) {
 			ring->rx_stats.drops += rqdpc;
-- 
1.9.1

