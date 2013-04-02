Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1762160Ab3DBTOf (ORCPT <rfc822;w@1wt.eu>);
	Tue, 2 Apr 2013 15:14:35 -0400
Received: from 2.mo1.mail-out.ovh.net ([178.32.119.250]:54258 "EHLO
	mo1.mail-out.ovh.net" rhost-flags-OK-OK-OK-FAIL) by vger.kernel.org
	with ESMTP id S1760998Ab3DBTOd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 2 Apr 2013 15:14:33 -0400
X-Greylist: delayed 2099 seconds by postgrey-1.27 at vger.kernel.org; Tue, 02 Apr 2013 15:14:33 EDT
From: Boris BREZILLON <linux-arm@overkiz.com>
To: Nicolas Ferre <nicolas.ferre@atmel.com>
Cc: Arnd Bergmann <arnd@arndb.de>,
        Greg Kroah-Hartman <gregkh@linuxfoundation.org>,
        Grant Likely <grant.likely@secretlab.ca>,
        Rob Herring <rob.herring@calxeda.com>,
        linux-arm-kernel@lists.infradead.org, linux-kernel@vger.kernel.org,
        Andrew Victor <linux@maxim.org.za>,
        Jean-Christophe Plagniol-Villard <plagnioj@jcrosoft.com>,
        Boris BREZILLON <linux-arm@overkiz.com>
X-Ovh-Mailout: 178.32.228.1 (mo1.mail-out.ovh.net)
Subject: [PATCH] ARM: at91/tc: fix clock source id for tc block > 1
Date: Tue,  2 Apr 2013 18:46:51 +0200
Message-Id: <1364921211-15756-1-git-send-email-linux-arm@overkiz.com>
X-Mailer: git-send-email 1.7.9.5
X-Ovh-Tracer-Id: 898186652337288300
X-Ovh-Remote: 80.245.18.66 ()
X-Ovh-Local: 213.186.33.20 (ns0.ovh.net)
X-OVH-SPAMSTATE: OK
X-OVH-SPAMSCORE: -100
X-OVH-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
X-Spam-Check: DONE|U 0.5/N
X-VR-SPAMSTATE: OK
X-VR-SPAMSCORE: -100
X-VR-SPAMCAUSE: gggruggvucftvghtrhhoucdtuddrfeeiuddrkeejucetufdoteggodetrfcurfhrohhfihhlvgemucfqggfjnecuuegrihhlohhuthemuceftddtnecusecvtfgvtghiphhivghnthhsucdlqddutddtmd
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch fixes wrong clock request for TC block 2.
The second block was using t0_clk, t1_clk and t2_clk clks instead of
t3_clk, t4_clk and t5_clk clks.


Signed-off-by: Boris BREZILLON <linux-arm@overkiz.com>
---
 drivers/misc/atmel_tclib.c |   24 ++++++++++++++++--------
 1 file changed, 16 insertions(+), 8 deletions(-)

diff --git a/drivers/misc/atmel_tclib.c b/drivers/misc/atmel_tclib.c
index c8d8e38..768a988 100644
--- a/drivers/misc/atmel_tclib.c
+++ b/drivers/misc/atmel_tclib.c
@@ -142,6 +142,8 @@ static int __init tc_probe(struct platform_device *pdev)
 	struct atmel_tc *tc;
 	struct clk	*clk;
 	int		irq;
+	char		clk_id[7];
+	int		clk_offset;
 
 	if (!platform_get_resource(pdev, IORESOURCE_MEM, 0))
 		return -EINVAL;
@@ -156,25 +158,31 @@ static int __init tc_probe(struct platform_device *pdev)
 
 	tc->pdev = pdev;
 
-	clk = clk_get(&pdev->dev, "t0_clk");
-	if (IS_ERR(clk)) {
-		kfree(tc);
-		return -EINVAL;
-	}
-
 	/* Now take SoC information if available */
 	if (pdev->dev.of_node) {
 		const struct of_device_id *match;
 		match = of_match_node(atmel_tcb_dt_ids, pdev->dev.of_node);
 		if (match)
 			tc->tcb_config = match->data;
+		clk_offset = of_alias_get_id(tc->pdev->dev.of_node, "tcb");
+	} else
+		clk_offset = pdev->id;
+	clk_offset *= 3;
+
+	snprintf(clk_id, sizeof(clk_id), "t%d_clk", clk_offset++);
+	clk = clk_get(&pdev->dev, clk_id);
+	if (IS_ERR(clk)) {
+		kfree(tc);
+		return -EINVAL;
 	}
 
 	tc->clk[0] = clk;
-	tc->clk[1] = clk_get(&pdev->dev, "t1_clk");
+	snprintf(clk_id, sizeof(clk_id), "t%d_clk", clk_offset++);
+	tc->clk[1] = clk_get(&pdev->dev, clk_id);
 	if (IS_ERR(tc->clk[1]))
 		tc->clk[1] = clk;
-	tc->clk[2] = clk_get(&pdev->dev, "t2_clk");
+	snprintf(clk_id, sizeof(clk_id), "t%d_clk", clk_offset++);
+	tc->clk[2] = clk_get(&pdev->dev, clk_id);
 	if (IS_ERR(tc->clk[2]))
 		tc->clk[2] = clk;
 
-- 
1.7.9.5

