Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752308AbaL2RKv (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:10:51 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53723
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751473AbaL2RKt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:10:49 -0500
X-IronPort-AV: E=Sophos;i="5.07,659,1413237600"; 
   d="scan'208";a="94921790"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Michal Simek <michal.simek@xilinx.com>
Cc: kernel-janitors@vger.kernel.org,
        =?UTF-8?q?S=C3=B6ren=20Brinkmann?= <soren.brinkmann@xilinx.com>,
        netdev@vger.kernel.org, linux-arm-kernel@lists.infradead.org,
        linux-kernel@vger.kernel.org
Subject: [PATCH 1/8] net: Xilinx: fix error return code
Date: Mon, 29 Dec 2014 18:04:36 +0100
Message-Id: <1419872683-32709-2-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/ethernet/xilinx/ll_temac_main.c   |    2 ++
 drivers/net/ethernet/xilinx/xilinx_emaclite.c |    1 +
 2 files changed, 3 insertions(+)

diff --git a/drivers/net/ethernet/xilinx/ll_temac_main.c b/drivers/net/ethernet/xilinx/ll_temac_main.c
index 9c2d91e..dbcbf0c 100644
--- a/drivers/net/ethernet/xilinx/ll_temac_main.c
+++ b/drivers/net/ethernet/xilinx/ll_temac_main.c
@@ -1043,6 +1043,7 @@ static int temac_of_probe(struct platform_device *op)
 	lp->regs = of_iomap(op->dev.of_node, 0);
 	if (!lp->regs) {
 		dev_err(&op->dev, "could not map temac regs.\n");
+		rc = -ENOMEM;
 		goto nodev;
 	}
 
@@ -1062,6 +1063,7 @@ static int temac_of_probe(struct platform_device *op)
 	np = of_parse_phandle(op->dev.of_node, "llink-connected", 0);
 	if (!np) {
 		dev_err(&op->dev, "could not find DMA node\n");
+		rc = -ENODEV;
 		goto err_iounmap;
 	}
 
diff --git a/drivers/net/ethernet/xilinx/xilinx_emaclite.c b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
index 2485879..9d4ce38 100644
--- a/drivers/net/ethernet/xilinx/xilinx_emaclite.c
+++ b/drivers/net/ethernet/xilinx/xilinx_emaclite.c
@@ -1109,6 +1109,7 @@ static int xemaclite_of_probe(struct platform_device *ofdev)
 	res = platform_get_resource(ofdev, IORESOURCE_IRQ, 0);
 	if (!res) {
 		dev_err(dev, "no IRQ found\n");
+		rc = -ENXIO;
 		goto error;
 	}
 

