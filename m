Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932464AbaICVl3 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 3 Sep 2014 17:41:29 -0400
Received: from mail-we0-f171.google.com ([74.125.82.171]:37628 "EHLO
	mail-we0-f171.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932175AbaICVl0 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 3 Sep 2014 17:41:26 -0400
From: Mark Einon <mark.einon@gmail.com>
To: gregkh@linuxfoundation.org
Cc: linux-kernel@vger.kernel.org, devel@driverdev.osuosl.org,
        Mark Einon <mark.einon@gmail.com>
Subject: [PATCH 2/4] staging: et131x: Remove spinlock fbr_lock
Date: Wed,  3 Sep 2014 22:40:55 +0100
Message-Id: <1409780457-6060-2-git-send-email-mark.einon@gmail.com>
X-Mailer: git-send-email 2.1.0
In-Reply-To: <1409780457-6060-1-git-send-email-mark.einon@gmail.com>
References: <1409780457-6060-1-git-send-email-mark.einon@gmail.com>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The spinlock fbr_lock is only used in a single call sequence staring
from et131x_poll. As this call is already locked by napi->poll_lock,
we can remove it.

Signed-off-by: Mark Einon <mark.einon@gmail.com>
---
 drivers/staging/et131x/et131x.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 7a1df8a..9819e0e 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -490,7 +490,6 @@ struct et131x_adapter {
 	spinlock_t send_hw_lock;
 
 	spinlock_t rcv_lock;
-	spinlock_t fbr_lock;
 
 	/* Packet Filter and look ahead size */
 	u32 packet_filter;
@@ -2325,8 +2324,6 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 		u32 __iomem *offset;
 		struct fbr_desc *next;
 
-		spin_lock_irqsave(&adapter->fbr_lock, flags);
-
 		if (ring_index == 0)
 			offset = &rx_dma->fbr0_full_offset;
 		else
@@ -2346,8 +2343,6 @@ static void nic_return_rfd(struct et131x_adapter *adapter, struct rfd *rfd)
 		free_buff_ring = bump_free_buff_ring(&fbr->local_full,
 						     fbr->num_entries - 1);
 		writel(free_buff_ring, offset);
-
-		spin_unlock_irqrestore(&adapter->fbr_lock, flags);
 	} else {
 		dev_err(&adapter->pdev->dev,
 			  "%s illegal Buffer Index returned\n", __func__);
@@ -3691,7 +3686,6 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	spin_lock_init(&adapter->tcb_ready_qlock);
 	spin_lock_init(&adapter->send_hw_lock);
 	spin_lock_init(&adapter->rcv_lock);
-	spin_lock_init(&adapter->fbr_lock);
 
 	adapter->registry_jumbo_packet = 1514;	/* 1514-9216 */
 
-- 
2.1.0

