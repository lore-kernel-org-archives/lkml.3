Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1759712Ab3EGB5d (ORCPT <rfc822;w@1wt.eu>);
	Mon, 6 May 2013 21:57:33 -0400
Received: from mga14.intel.com ([143.182.124.37]:20011 "EHLO mga14.intel.com"
	rhost-flags-OK-OK-OK-OK) by vger.kernel.org with ESMTP
	id S933006Ab3EGB4E (ORCPT <rfc822;linux-kernel@vger.kernel.org>);
	Mon, 6 May 2013 21:56:04 -0400
X-ExtLoop1: 1
X-IronPort-AV: E=Sophos;i="4.87,624,1363158000"; 
   d="scan'208";a="329960360"
From: Jon Mason <jon.mason@intel.com>
To: linux-kernel@vger.kernel.org
Cc: Dave Jiang <dave.jiang@intel.com>
Subject: [PATCH 07/10] NTB: Correctly handle receive buffers of the minimal size
Date: Mon,  6 May 2013 18:55:26 -0700
Message-Id: <1367891729-11738-8-git-send-email-jon.mason@intel.com>
X-Mailer: git-send-email 1.7.9.5
In-Reply-To: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
References: <1367891729-11738-1-git-send-email-jon.mason@intel.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The ring logic of the NTB receive buffer/transmit memory window requires
there to be at least 2 payload sized allotments.  For the minimal size
case, split the buffer into two and set the transport_mtu to the
appropriate size.

Signed-off-by: Jon Mason <jon.mason@intel.com>
---
 drivers/ntb/ntb_transport.c |    8 +++++---
 1 file changed, 5 insertions(+), 3 deletions(-)

diff --git a/drivers/ntb/ntb_transport.c b/drivers/ntb/ntb_transport.c
index 73a000e..cd9745b 100644
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
1.7.9.5

