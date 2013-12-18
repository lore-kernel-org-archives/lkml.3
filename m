Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755522Ab3LRVdk (ORCPT <rfc822;w@1wt.eu>);
	Wed, 18 Dec 2013 16:33:40 -0500
Received: from mail.linuxfoundation.org ([140.211.169.12]:36413 "EHLO
	mail.linuxfoundation.org" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1754110Ab3LRVNg (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 18 Dec 2013 16:13:36 -0500
From: Greg Kroah-Hartman <gregkh@linuxfoundation.org>
To: linux-kernel@vger.kernel.org
Cc: Greg Kroah-Hartman <gregkh@linuxfoundation.org>, stable@vger.kernel.org,
        Maxime Ripard <maxime.ripard@free-electrons.com>,
        "David S. Miller" <davem@davemloft.net>
Subject: [PATCH 3.12 060/118] net: allwinner: emac: Add missing free_irq
Date: Wed, 18 Dec 2013 13:11:37 -0800
Message-Id: <20131218211221.159858900@linuxfoundation.org>
X-Mailer: git-send-email 1.8.5.1.163.gd7aced9
In-Reply-To: <20131218211219.461663463@linuxfoundation.org>
References: <20131218211219.461663463@linuxfoundation.org>
User-Agent: quilt/0.61-1
MIME-Version: 1.0
Content-Type: text/plain; charset=UTF-8
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

3.12-stable review patch.  If anyone has any objections, please let me know.

------------------

From: Maxime Ripard <maxime.ripard@free-electrons.com>

commit e9c56f8d2f851fb6d6ce6794c0f5463b862a878e upstream.

The sun4i-emac driver uses devm_request_irq at .ndo_open time, but relies on
the managed device mechanism to actually free it. This causes an issue whenever
someone wants to restart the interface, the interrupt still being held, and not
yet released.

Fall back to using the regular request_irq at .ndo_open time, and introduce a
free_irq during .ndo_stop.

Signed-off-by: Maxime Ripard <maxime.ripard@free-electrons.com>
Signed-off-by: David S. Miller <davem@davemloft.net>
Signed-off-by: Greg Kroah-Hartman <gregkh@linuxfoundation.org>

---
 drivers/net/ethernet/allwinner/sun4i-emac.c |    5 +++--
 1 file changed, 3 insertions(+), 2 deletions(-)

--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -717,8 +717,7 @@ static int emac_open(struct net_device *
 	if (netif_msg_ifup(db))
 		dev_dbg(db->dev, "enabling %s\n", dev->name);
 
-	if (devm_request_irq(db->dev, dev->irq, &emac_interrupt,
-			     0, dev->name, dev))
+	if (request_irq(dev->irq, &emac_interrupt, 0, dev->name, dev))
 		return -EAGAIN;
 
 	/* Initialize EMAC board */
@@ -774,6 +773,8 @@ static int emac_stop(struct net_device *
 
 	emac_shutdown(ndev);
 
+	free_irq(ndev->irq, ndev);
+
 	return 0;
 }
 


