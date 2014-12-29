Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752519AbaL2RMT (ORCPT <rfc822;w@1wt.eu>);
	Mon, 29 Dec 2014 12:12:19 -0500
Received: from mail3-relais-sop.national.inria.fr ([192.134.164.104]:53723
	"EHLO mail3-relais-sop.national.inria.fr" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1752314AbaL2RKw (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 29 Dec 2014 12:10:52 -0500
X-IronPort-AV: E=Sophos;i="5.07,659,1413237600"; 
   d="scan'208";a="94921794"
From: Julia Lawall <Julia.Lawall@lip6.fr>
To: Maxime Ripard <maxime.ripard@free-electrons.com>
Cc: kernel-janitors@vger.kernel.org, netdev@vger.kernel.org,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org
Subject: [PATCH 5/8] net: sun4i-emac: fix error return code
Date: Mon, 29 Dec 2014 18:04:40 +0100
Message-Id: <1419872683-32709-6-git-send-email-Julia.Lawall@lip6.fr>
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
 drivers/net/ethernet/allwinner/sun4i-emac.c |    4 +++-
 1 file changed, 3 insertions(+), 1 deletion(-)

diff --git a/drivers/net/ethernet/allwinner/sun4i-emac.c b/drivers/net/ethernet/allwinner/sun4i-emac.c
index 1fcd556..cfdf7de 100644
--- a/drivers/net/ethernet/allwinner/sun4i-emac.c
+++ b/drivers/net/ethernet/allwinner/sun4i-emac.c
@@ -850,8 +850,10 @@ static int emac_probe(struct platform_device *pdev)
 	}
 
 	db->clk = devm_clk_get(&pdev->dev, NULL);
-	if (IS_ERR(db->clk))
+	if (IS_ERR(db->clk)) {
+		ret = PTR_ERR(db->clk);
 		goto out;
+	}
 
 	clk_prepare_enable(db->clk);
 

