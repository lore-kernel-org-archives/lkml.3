Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1758501Ab3ERCvv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 May 2013 22:51:51 -0400
Received: from mail-pb0-f51.google.com ([209.85.160.51]:49318 "EHLO
	mail-pb0-f51.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757346Ab3ERCvu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 May 2013 22:51:50 -0400
From: Jonghwan Choi <jhbird.choi@gmail.com>
To: Jon Mason <jon.mason@intel.com>
Cc: stable@vger.kernel.org, linux-kernel@vger.kernel.org,
        Jonghwan Choi <jhbird.choi@samsung.com>
Subject: [PATCH 3.9-table] NTB: Correctly handle receive buffers of the minimal size
Date: Sat, 18 May 2013 11:49:39 +0900
Message-Id: <1368845379-4177-1-git-send-email-jhbird.choi@samsung.com>
X-Mailer: git-send-email 1.8.1.2
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Jon Mason <jon.mason@intel.com>

This patch looks like it should be in the 3.9-stable tree, should we apply
it?

------------------

From: "Jon Mason <jon.mason@intel.com>"

commit c9d534c8cbaedbb522a1d2cb037c6c394f610317 upstream

The ring logic of the NTB receive buffer/transmit memory window requires
there to be at least 2 payload sized allotments.  For the minimal size
case, split the buffer into two and set the transport_mtu to the
appropriate size.

Cc: <stable@vger.kernel.org> # 3.9.x: ad3e2751: ntb: off by one
Cc: <stable@vger.kernel.org> # 3.9.x: cc0f868d: NTB: fix pointer math
Cc: <stable@vger.kernel.org> # 3.9.x: 113fc505: NTB: Handle 64bit BAR
Cc: <stable@vger.kernel.org> # 3.9.x: b77b2637: NTB: Link toggle memory
Cc: <stable@vger.kernel.org> # 3.9.x: 90f9e934: NTB: reset tx_index on
Signed-off-by: Jon Mason <jon.mason@intel.com>
Signed-off-by: Jonghwan Choi <jhbird.choi@samsung.com>
---
 drivers/ntb/ntb_transport.c | 8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 0828124..a288a26 100644
--- a/drivers/ntb/ntb_transport.c
+++ b/drivers/ntb/ntb_transport.c
@@ -490,11 +490,12 @@ static void ntb_transport_setup_qp_mw(struct ntb_transport *nt,
 	rx_size -= sizeof(struct ntb_rx_info);
 
 	qp->rx_buff = qp->remote_rx_info + 1;
-	qp->rx_max_frame = min(transport_mtu, rx_size);
+	/* Due to housekeeping, there must be atleast 2 buffs */
+	qp->rx_max_frame = min(transport_mtu, rx_size / 2);
 	qp->rx_max_entry = rx_size / qp->rx_max_frame;
 	qp->rx_index = 0;
 
-	qp->remote_rx_info->entry = qp->rx_max_entry;
+	qp->remote_rx_info->entry = qp->rx_max_entry - 1;
 
 	/* setup the hdr offsets with 0's */
 	for (i = 0; i < qp->rx_max_entry; i++) {
@@ -818,7 +819,8 @@ static void ntb_transport_init_queue(struct ntb_transport *nt,
 	tx_size -= sizeof(struct ntb_rx_info);
 
 	qp->tx_mw = qp->rx_info + 1;
-	qp->tx_max_frame = min(transport_mtu, tx_size);
+	/* Due to housekeeping, there must be atleast 2 buffs */
+	qp->tx_max_frame = min(transport_mtu, tx_size / 2);
 	qp->tx_max_entry = tx_size / qp->tx_max_frame;
 
 	if (nt->debugfs_dir) {
-- 
1.8.1.2

