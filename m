Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752566AbaLOOOD (ORCPT <rfc822;w@1wt.eu>);
	Mon, 15 Dec 2014 09:14:03 -0500
Received: from eusmtp01.atmel.com ([212.144.249.243]:13294 "EHLO
	eusmtp01.atmel.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752543AbaLOOOB (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 15 Dec 2014 09:14:01 -0500
From: Cyrille Pitchen <cyrille.pitchen@atmel.com>
To: <nicolas.ferre@atmel.com>, <davem@davemloft.net>,
        <linux-arm-kernel@lists.infradead.org>, <netdev@vger.kernel.org>,
        <soren.brinkmann@xilinx.com>
CC: <linux-kernel@vger.kernel.org>,
        Cyrille Pitchen <cyrille.pitchen@atmel.com>
Subject: [PATCH 1/2] net/macb: fix misplaced call of free_netdev() in macb_remove()
Date: Mon, 15 Dec 2014 15:13:31 +0100
Message-ID: <bb09b43ee435334877b4f8aa6c006d03c1afa8f3.1418651689.git.cyrille.pitchen@atmel.com>
X-Mailer: git-send-email 1.8.2.2
In-Reply-To: <cover.1418651689.git.cyrille.pitchen@atmel.com>
References: <cover.1418651689.git.cyrille.pitchen@atmel.com>
MIME-Version: 1.0
Content-Type: text/plain
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

fix a bug introduced by the multiqueue support patch:
"net/macb: add TX multiqueue support for gem"

the "bp" pointer to the netdev private data was dereferenced and used after the
associated memory had been freed by calling free_netdev().

Signed-off-by: Cyrille Pitchen <cyrille.pitchen@atmel.com>
---
 drivers/net/ethernet/cadence/macb.c | 2 +-
 1 file changed, 1 insertion(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/cadence/macb.c b/drivers/net/ethernet/cadence/macb.c
index 0987d2a..81f317f 100644
--- a/drivers/net/ethernet/cadence/macb.c
+++ b/drivers/net/ethernet/cadence/macb.c
@@ -2408,11 +2408,11 @@ static int __exit macb_remove(struct platform_device *pdev)
 		queue = bp->queues;
 		for (q = 0; q < bp->num_queues; ++q, ++queue)
 			devm_free_irq(&pdev->dev, queue->irq, queue);
-		free_netdev(dev);
 		if (!IS_ERR(bp->tx_clk))
 			clk_disable_unprepare(bp->tx_clk);
 		clk_disable_unprepare(bp->hclk);
 		clk_disable_unprepare(bp->pclk);
+		free_netdev(dev);
 	}
 
 	return 0;
-- 
1.8.2.2

