Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752373AbaL2RKz (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:10:55 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:62930
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752316AbaL2RKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:10:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,659,1413237600"; 
   d="scan'208";a="94921796"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Anirudha Sarangi <anirudh@xilinx.com>
Cc: kernel-janitors@vger.kernel.org, John Linn <John.Linn@xilinx.com>,
        Michal Simek <michal.simek@xilinx.com>,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 7/8] net: axienet: fix error return code
Date: Mon, 29 Dec 2014 18:04:42 +0100
Message-Id: <1419872683-32709-8-git-send-email-Julia.Lawall@lip6.fr>
X-Mailer: git-send-email 1.8.3.2
In-Reply-To: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
References: <1419872683-32709-1-git-send-email-Julia.Lawall@lip6.fr>
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

Return a negative error code on failure.

A simplified version of the semantic match that finds this problem is as
follows: (http://coccinelle.lip6.fr/)

// <smpl>
@@
identifier ret; expression e1,e2;
@@
(
if (\(ret < 0\|ret != 0\))
 { ... return ret; }
|
ret = 0
)
... when != ret = e1
    when != &ret
*if(...)
{
  ... when != ret = e2
      when forall
 return ret;
}
// </smpl>

Signed-off-by: Julia Lawall <Julia.Lawall@lip6.fr>

---
 drivers/net/ethernet/xilinx/xilinx_axienet_main.c |    2 ++
 1 file changed, 2 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
index 4ea2d4e..6ca4a52 100644
--- a/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
+++ b/drivers/net/ethernet/xilinx/xilinx_axienet_main.c
@@ -1501,6 +1501,7 @@ static int axienet_of_probe(struct platform_device *op)
 	lp->regs = of_iomap(op->dev.of_node, 0);
 	if (!lp->regs) {
 		dev_err(&op->dev, "could not map Axi Ethernet regs.\n");
+		ret = -ENOMEM;
 		goto nodev;
 	}
 	/* Setup checksum offload, but default to off if not specified */
@@ -1567,6 +1568,7 @@ static int axienet_of_probe(struct platform_device *op)
 	np = of_parse_phandle(op->dev.of_node, "axistream-connected", 0);
 	if (!np) {
 		dev_err(&op->dev, "could not find DMA node\n");
+		ret = -ENODEV;
 		goto err_iounmap;
 	}
 	lp->dma_regs = of_iomap(np, 0);

