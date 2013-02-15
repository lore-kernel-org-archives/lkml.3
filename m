Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752392Ab3BOW4H (ORCPT <rfc822;w@1wt.eu>);
	Fri, 15 Feb 2013 17:56:07 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:49297 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752044Ab3BOW4F (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 15 Feb 2013 17:56:05 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Alexander Duyck <alexander.h.duyck@intel.com>,
        Jeff Pieper <jeffrey.e.pieper@intel.com>,
        Jeff Kirsher <jeffrey.t.kirsher@intel.com>,
        Vinson Lee <vlee@twitter.com>
Subject: [ 4/4] igb: Remove artificial restriction on RQDPC stat reading
Date: Fri, 15 Feb 2013 14:55:53 -0800
Message-Id: <20130215225524.066467303@linuxfoundation.org>
X-Mailer: git-send-email 1.8.1.rc1.5.g7e0651a
In-Reply-To: <20130215225523.525656849@linuxfoundation.org>
References: <20130215225523.525656849@linuxfoundation.org>
User-Agent: quilt/0.60-2.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.0-stable review patch.  If anyone has any objections, please let me know.

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
Cc: Vinson Lee <vlee@twitter.com>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/igb/igb_main.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

--- a/drivers/net/igb/igb_main.c
+++ b/drivers/net/igb/igb_main.c
@@ -4521,11 +4521,13 @@ void igb_update_stats(struct igb_adapter
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


