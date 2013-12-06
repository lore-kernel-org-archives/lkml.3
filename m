Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1161950Ab3LFWbi (ORCPT <rfc822;w@1wt.eu>);
	Fri, 6 Dec 2013 17:31:38 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:60625 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754730Ab3LFVw4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 6 Dec 2013 16:52:56 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Francois Romieu <romieu@fr.zoreil.com>,
        "Alex A. Schmidt" <aaschmidt1@gmail.com>,
        Jamie Heilman <jamie@audible.transient.net>,
        Michele Baldessari <michele@acksyn.org>,
        Julia Lawall <Julia.Lawall@lip6.fr>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 51/83] via-velocity: fix netif_receive_skb use in irq disabled section.
Date: Fri,  6 Dec 2013 13:51:41 -0800
Message-Id: <20131206214644.802698960@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.67.gb00d244
In-Reply-To: <20131206214640.002320724@linuxfoundation.org>
References: <20131206214640.002320724@linuxfoundation.org>
User-Agent: quilt/0.60-8.1.3
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Francois Romieu <romieu@fr.zoreil.com>

[ Upstream commit bc9627e7e918a85e906c1a3f6d01d9b8ef911a96 ]

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
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
---
 drivers/net/ethernet/via/via-velocity.c |   11 ++++++-----
 1 file changed, 6 insertions(+), 5 deletions(-)

--- a/drivers/net/ethernet/via/via-velocity.c
+++ b/drivers/net/ethernet/via/via-velocity.c
@@ -2172,16 +2172,13 @@ static int velocity_poll(struct napi_str
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
@@ -2342,6 +2339,8 @@ static int velocity_change_mtu(struct ne
 		if (ret < 0)
 			goto out_free_tmp_vptr_1;
 
+		napi_disable(&vptr->napi);
+
 		spin_lock_irqsave(&vptr->lock, flags);
 
 		netif_stop_queue(dev);
@@ -2362,6 +2361,8 @@ static int velocity_change_mtu(struct ne
 
 		velocity_give_many_rx_descs(vptr);
 
+		napi_enable(&vptr->napi);
+
 		mac_enable_int(vptr->mac_regs);
 		netif_start_queue(dev);
 


