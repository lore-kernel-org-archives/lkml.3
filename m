Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757228Ab3GEJKe (ORCPT <rfc822;w@1wt.eu>);
	Fri, 5 Jul 2013 05:10:34 -0400
Received: from ch1ehsobe003.messaging.microsoft.com ([216.32.181.183]:41919
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753718Ab3GEJKd (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 5 Jul 2013 05:10:33 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 3
X-BigFish: VS3(zzzz1f42h1ee6h1de0h1fdah2073h1202h1e76h1d1ah1d2ah1fc6h1082kzz8275bhz2dh2a8h668h839hd24he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1155h)
From: Huang Shijie <b32955@freescale.com>
To: <grant.likely@linaro.org>
CC: <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <shawn.guo@linaro.org>,
        <linux-arm-kernel@lists.infradead.org>,
        Huang Shijie <b32955@freescale.com>
Subject: [PATCH] of: match the compatible in the order set by the dts file
Date: Fri, 5 Jul 2013 16:43:38 +0800
Message-ID: <1373013818-11365-1-git-send-email-b32955@freescale.com>
X-Mailer: git-send-email 1.7.1
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

If we set the uart compatible in the dts file like this:
   ------------------------------------------------------
    compatible = "fsl,imx6q-uart", "fsl,imx21-uart";
   ------------------------------------------------------

and we set the uart compatible in the uart driver like this:
   ------------------------------------------------------
	{ .compatible = "fsl,imx1-uart", ... },
	{ .compatible = "fsl,imx21-uart", ... },
	{ .compatible = "fsl,imx6q-uart", ... },
	{ /* sentinel */ }
   ------------------------------------------------------

the current code will match the "fsl,imx21-uart" in the end.

Of course, this is not what we want. We want it to match the "fsl,imx6q-uart".

This patch rewrites the match code, and make it to check the compatible
in the order set by the DTS file.

Signed-off-by: Huang Shijie <b32955@freescale.com>
---
 drivers/of/base.c |   29 +++++++++++++++++++++++++----
 1 files changed, 25 insertions(+), 4 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 0d61fc5..b13846b 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -622,10 +622,14 @@ static
 const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 					   const struct device_node *node)
 {
+	struct of_device_id *old = (struct of_device_id *)matches;
+	const char *cp;
+	int cplen, l;
+
 	if (!matches)
 		return NULL;
 
-	while (matches->name[0] || matches->type[0] || matches->compatible[0]) {
+	while (matches->name[0] || matches->type[0]) {
 		int match = 1;
 		if (matches->name[0])
 			match &= node->name
@@ -633,13 +637,30 @@ const struct of_device_id *__of_match_node(const struct of_device_id *matches,
 		if (matches->type[0])
 			match &= node->type
 				&& !strcmp(matches->type, node->type);
-		if (matches->compatible[0])
-			match &= __of_device_is_compatible(node,
-							   matches->compatible);
 		if (match)
 			return matches;
 		matches++;
 	}
+
+	/* Check the compatible in the order set by the DTS file. */
+	cp = __of_get_property(node, "compatible", &cplen);
+	if (!cp)
+		return NULL;
+
+	while (cplen > 0) {
+		matches = old;
+
+		while (matches->compatible[0]) {
+			if (!of_compat_cmp(cp, matches->compatible,
+						strlen(matches->compatible)))
+				return matches;
+			matches++;
+		}
+
+		l = strlen(cp) + 1;
+		cp += l;
+		cplen -= l;
+	}
 	return NULL;
 }
 
-- 
1.7.1


