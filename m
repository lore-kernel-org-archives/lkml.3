Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752588Ab3KTH6m (ORCPT <rfc822;w@1wt.eu>);
	Wed, 20 Nov 2013 02:58:42 -0500
Received: from mail-pb0-f50.google.com ([209.85.160.50]:33754 "EHLO
	mail-pb0-f50.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752282Ab3KTH6i (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 20 Nov 2013 02:58:38 -0500
Date: Wed, 20 Nov 2013 15:57:15 +0800
From: ZHAO Gang <gamerh2o@gmail.com>
To: Mark Einon <mark.einon@gmail.com>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>
Cc: linux-kernel@vger.kernel.org
Subject: [PATCH v3 4/5] staging: et131x: remove spinlock adapter->lock
Message-ID: <14d763851982be40b32c297eba792f29d1bbd546.1384933520.git.gamerh2o@gmail.com>
Mail-Followup-To: ZHAO Gang <gamerh2o@gmail.com>,
	Mark Einon <mark.einon@gmail.com>,
	Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
	linux-kernel@vger.kernel.org
References: <cover.1384933520.git.gamerh2o@gmail.com>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
In-Reply-To: <cover.1384933520.git.gamerh2o@gmail.com>
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

adapter->lock is only used in et131x_multicast(), which is eventually
called by network stack function __dev_set_rx_mode(). __dev_set_rx_mode()
is always called by (net_device *)dev->addr_list_lock hold, to protect from
concurrent access. So adapter->lock is redundant.

Signed-off-by: ZHAO Gang <gamerh2o@gmail.com>
---
 drivers/staging/et131x/et131x.c | 6 ------
 1 file changed, 6 deletions(-)

diff --git a/drivers/staging/et131x/et131x.c b/drivers/staging/et131x/et131x.c
index 6254a6b..66530b1 100644
--- a/drivers/staging/et131x/et131x.c
+++ b/drivers/staging/et131x/et131x.c
@@ -486,8 +486,6 @@ struct et131x_adapter {
 	u8 eeprom_data[2];
 
 	/* Spinlocks */
-	spinlock_t lock;
-
 	spinlock_t tcb_send_qlock;
 	spinlock_t tcb_ready_qlock;
 	spinlock_t send_hw_lock;
@@ -3867,7 +3865,6 @@ static struct et131x_adapter *et131x_adapter_init(struct net_device *netdev,
 	adapter->netdev = netdev;
 
 	/* Initialize spinlocks here */
-	spin_lock_init(&adapter->lock);
 	spin_lock_init(&adapter->tcb_send_qlock);
 	spin_lock_init(&adapter->tcb_ready_qlock);
 	spin_lock_init(&adapter->send_hw_lock);
@@ -4429,8 +4426,6 @@ static void et131x_multicast(struct net_device *netdev)
 	struct netdev_hw_addr *ha;
 	int i;
 
-	spin_lock_irqsave(&adapter->lock, flags);
-
 	/* Before we modify the platform-independent filter flags, store them
 	 * locally. This allows us to determine if anything's changed and if
 	 * we even need to bother the hardware
@@ -4484,7 +4479,6 @@ static void et131x_multicast(struct net_device *netdev)
 		/* Call the device's filter function */
 		et131x_set_packet_filter(adapter);
 	}
-	spin_unlock_irqrestore(&adapter->lock, flags);
 }
 
 /* et131x_tx - The handler to tx a packet on the device
-- 
1.8.3.1

