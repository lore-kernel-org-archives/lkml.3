Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1756855Ab3LSM6z (ORCPT <rfc822;w@1wt.eu>);
	Thu, 19 Dec 2013 07:58:55 -0500
Received: from youngberry.canonical.com ([91.189.89.112]:44627 "EHLO
	youngberry.canonical.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754337Ab3LSL4b (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 19 Dec 2013 06:56:31 -0500
From: Luis Henriques <luis.henriques@canonical.com>
To: linux-kernel@vger.kernel.org, stable@vger.kernel.org,
        kernel-team@lists.ubuntu.com
Cc: Francois Romieu <romieu@fr.zoreil.com>,
        Jamie Heilman <jamie@audible.transient.net>,
        Michele Baldessari <michele@acksyn.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "David S. Miller" <davem@davemloft.net>,
        Luis Henriques <luis.henriques@canonical.com>
Subject: [PATCH 3.11 048/208] via-velocity: fix netif_receive_skb use in irq disabled section.
Date: Thu, 19 Dec 2013 11:52:26 +0000
Message-Id: <1387454106-19326-49-git-send-email-luis.henriques@canonical.com>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
References: <1387454106-19326-1-git-send-email-luis.henriques@canonical.com>
X-Extended-Stable: 3.11
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.11.10.2 -stable review patch.  If anyone has any objections, please let me know.

------------------

From: =?UTF-8?q?fran=C3=A7ois=20romieu?= <romieu@fr.zoreil.com>

commit bc9627e7e918a85e906c1a3f6d01d9b8ef911a96 upstream.

2fdac010bdcf10a30711b6924612dfc40daf19b8 ("via-velocity.c: update napi
implementation") overlooked an irq disabling spinlock when the Rx part
of the NAPI poll handler was converted from netif_rx to netif_receive_skb.

NAPI Rx processing can be taken out of the locked section with a pair of
napi_{disable / enable} since it only races with the MTU change function.

An heavier rework of the NAPI locking would be able to perform NAPI Tx
before Rx where I simply removed one of velocity_tx_srv calls.

References: https://bugzilla.redhat.com/show_bug.cgi?id=1022733
Fixes: 2fdac010bdcf (via-velocity.c: update napi implementation)
Signed-off-by: Francois Romieu <romieu@fr.zoreil.com>
Tested-by: Alex A. Schmidt <aaschmidt1@gmail.com>
Cc: Jamie Heilman <jamie@audible.transient.net>
Cc: Michele Baldessari <michele@acksyn.org>
Cc: Julia Lawall <Julia.Lawall@lip6.fr>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Luis Henriques <luis.henriques@canonical.com>
---
 drivers/net/ethernet/via/via-velocity.c | 11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

diff --git a/drivers/net/ethernet/via/via-velocity.c b/drivers/net/ethernet/via/via-velocity.c
index d01cacf..40e4c02 100644
--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2172,16 +2172,13 @@ static int velocity_poll(struct napi_struct *napi, int budget)
 	unsigned int rx_done;
 	unsigned long flags;
 
-	spin_lock_irqsave(&vptr->lock, flags);
 	/*
 	 * Do rx and tx twice for performance (taken from the VIA
 	 * out-of-tree driver).
 	 */
-	rx_done = velocity_rx_srv(vptr, budget / 2);
-	velocity_tx_srv(vptr);
-	rx_done += velocity_rx_srv(vptr, budget - rx_done);
+	rx_done = velocity_rx_srv(vptr, budget);
+	spin_lock_irqsave(&vptr->lock, flags);
 	velocity_tx_srv(vptr);
-
 	/* If budget not fully consumed, exit the polling mode */
 	if (rx_done < budget) {
 		napi_complete(napi);
@@ -2342,6 +2339,8 @@ static int velocity_change_mtu(struct net_device *dev, int new_mtu)
 		if (ret < 0)
 			goto out_free_tmp_vptr_1;
 
+		napi_disable(&vptr->napi);
+
 		spin_lock_irqsave(&vptr->lock, flags);
 
 		netif_stop_queue(dev);
@@ -2362,6 +2361,8 @@ static int velocity_change_mtu(struct net_device *dev, int new_mtu)
 
 		velocity_give_many_rx_descs(vptr);
 
+		napi_enable(&vptr->napi);
+
 		mac_enable_int(vptr->mac_regs);
 		netif_start_queue(dev);
 
-- 
1.8.3.2

