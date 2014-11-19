Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932975AbaKSU4r (ORCPT <rfc822;w@1wt.eu>);
	Wed, 19 Nov 2014 15:56:47 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:56046 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932723AbaKSUyX (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 19 Nov 2014 15:54:23 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Florian Fainelli <f.fainelli@gmail.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.17 112/141] net: systemport: enable RX interrupts after NAPI
Date: Wed, 19 Nov 2014 12:52:15 -0800
Message-Id: <20141119205154.301549641@linuxfoundation.org>
X-Mailer: git-send-email 2.1.3
In-Reply-To: <20141119205150.700188369@linuxfoundation.org>
References: <20141119205150.700188369@linuxfoundation.org>
User-Agent: quilt/0.63-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.17-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Florian Fainelli <f.fainelli@gmail.com>

commit 8edf0047f4b8e03d94ef88f5a7dec146cce03a06 upstream.

There is currently a small window during which the SYSTEMPORT adapter
enables its RX interrupts without having enabled its NAPI handler, which
can result in packets to be discarded during interface bringup.

A similar but more serious window exists in bcm_sysport_resume() during
which we can have the RDMA engine not fully prepared to receive packets
and yet having RX interrupts enabled.

Fix this my moving the RX interrupt enable down to
bcm_sysport_netif_start() after napi_enable() for the RX path is called,
which fixes both call sites: bcm_sysport_open() and
bcm_sysport_resume().

Fixes: b02e6d9ba7ad ("net: systemport: add bcm_sysport_netif_{enable,stop}")
Signed-off-by: Florian Fainelli <f.fainelli@gmail.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/broadcom/bcmsysport.c |    9 +++------
 1 file changed, 3 insertions(+), 6 deletions(-)

--- a/drivers/net/ethernet/broadcom/bcmsysport.c
+++ b/drivers/net/ethernet/broadcom/bcmsysport.c
@@ -1384,6 +1384,9 @@ static void bcm_sysport_netif_start(stru
 	/* Enable NAPI */
 	napi_enable(&priv->napi);
 
+	/* Enable RX interrupt and TX ring full interrupt */
+	intrl2_0_mask_clear(priv, INTRL2_0_RDMA_MBDONE | INTRL2_0_TX_RING_FULL);
+
 	phy_start(priv->phydev);
 
 	/* Enable TX interrupts for the 32 TXQs */
@@ -1486,9 +1489,6 @@ static int bcm_sysport_open(struct net_d
 	if (ret)
 		goto out_free_rx_ring;
 
-	/* Enable RX interrupt and TX ring full interrupt */
-	intrl2_0_mask_clear(priv, INTRL2_0_RDMA_MBDONE | INTRL2_0_TX_RING_FULL);
-
 	/* Turn on TDMA */
 	ret = tdma_enable_set(priv, 1);
 	if (ret)
@@ -1872,9 +1872,6 @@ static int bcm_sysport_resume(struct dev
 
 	netif_device_attach(dev);
 
-	/* Enable RX interrupt and TX ring full interrupt */
-	intrl2_0_mask_clear(priv, INTRL2_0_RDMA_MBDONE | INTRL2_0_TX_RING_FULL);
-
 	/* RX pipe enable */
 	topctrl_writel(priv, 0, RX_FLUSH_CNTL);
 


