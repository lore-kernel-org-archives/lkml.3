Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751549Ab3DJEQ2 (ORCPT <rfc822;w@1wt.eu>);
	Wed, 10 Apr 2013 00:16:28 -0400
Received: from ch1ehsobe006.messaging.microsoft.com ([216.32.181.186]:26484
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751273Ab3DJEQ1 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 10 Apr 2013 00:16:27 -0400
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h1fc6h1ee6h1de0h1fdah1202h1e76h1d1ah1d2ahzz8275bhz2dh2a8h668h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1155h)
From: <Yuantian.Tang@freescale.com>
To: <grant.likely@secretlab.ca>
CC: <rob.herring@calxeda.com>, <devicetree-discuss@lists.ozlabs.org>,
        <linux-kernel@vger.kernel.org>, <linuxppc-dev@lists.ozlabs.org>,
        Tang Yuantian <yuantian.tang@freescale.com>,
        Tang Yuantian <Yuantian.Tang@freescale.com>
Subject: [PATCH v2] of/base: release the node correctly in of_parse_phandle_with_args()
Date: Wed, 10 Apr 2013 11:36:39 +0800
Message-ID: <1365564999-24427-1-git-send-email-Yuantian.Tang@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

From: Tang Yuantian <yuantian.tang@freescale.com>

Call of_node_put() only when the out_args is NULL on success,
or the node's reference count will not be correct because the caller
will call of_node_put() again.

Signed-off-by: Tang Yuantian <Yuantian.Tang@freescale.com>
---
v2:
	- modified the title and description. the 1st patch title is:
	  of: remove the unnecessary of_node_put for of_parse_phandle_with_args()
	  the 1st patch is not good enough.

 drivers/of/base.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index 321d3ef..ee94f64 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1158,6 +1158,7 @@ static int __of_parse_phandle_with_args(const struct device_node *np,
 			if (!phandle)
 				goto err;
 
+			/* Found it! return success */
 			if (out_args) {
 				int i;
 				if (WARN_ON(count > MAX_PHANDLE_ARGS))
@@ -1166,11 +1167,10 @@ static int __of_parse_phandle_with_args(const struct device_node *np,
 				out_args->args_count = count;
 				for (i = 0; i < count; i++)
 					out_args->args[i] = be32_to_cpup(list++);
+			} else if (node) {
+				of_node_put(node);
 			}
 
-			/* Found it! return success */
-			if (node)
-				of_node_put(node);
 			return 0;
 		}
 
-- 
1.8.0


