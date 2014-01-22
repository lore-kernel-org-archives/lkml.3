Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753744AbaAVG4V (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:56:21 -0500
Received: from co9ehsobe001.messaging.microsoft.com ([207.46.163.24]:17438
	"EHLO co9outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1750823AbaAVG4U (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:56:20 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zze0eahzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <robh+dt@kernel.org>, <grant.likely@linaro.org>
CC: <panto@antoniou-consulting.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 1/2] of: add __of_add_property() without lock operations
Date: Wed, 22 Jan 2014 13:57:39 +0800
Message-ID: <1390370260-11273-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

There two places will use the same code for adding one new property to
the DT node. Adding __of_add_property() and prepare for fixing
of_update_property()'s bug.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/of/base.c | 38 ++++++++++++++++++++++++--------------
 1 file changed, 24 insertions(+), 14 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f807d0e..b86b77a 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1469,11 +1469,31 @@ static int of_property_notify(int action, struct device_node *np,
 #endif
 
 /**
+ * __of_add_property - Add a property to a node without lock operations
+ */
+static int __of_add_property(struct device_node *np, struct property *prop)
+{
+	struct property **next;
+
+	prop->next = NULL;
+	next = &np->properties;
+	while (*next) {
+		if (strcmp(prop->name, (*next)->name) == 0)
+			/* duplicate ! don't insert it */
+			return -EEXIST;
+
+		next = &(*next)->next;
+	}
+	*next = prop;
+
+	return 0;
+}
+
+/**
  * of_add_property - Add a property to a node
  */
 int of_add_property(struct device_node *np, struct property *prop)
 {
-	struct property **next;
 	unsigned long flags;
 	int rc;
 
@@ -1481,27 +1501,17 @@ int of_add_property(struct device_node *np, struct property *prop)
 	if (rc)
 		return rc;
 
-	prop->next = NULL;
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	next = &np->properties;
-	while (*next) {
-		if (strcmp(prop->name, (*next)->name) == 0) {
-			/* duplicate ! don't insert it */
-			raw_spin_unlock_irqrestore(&devtree_lock, flags);
-			return -1;
-		}
-		next = &(*next)->next;
-	}
-	*next = prop;
+	rc = __of_add_property(np, prop);
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 #ifdef CONFIG_PROC_DEVICETREE
 	/* try to add to proc as well if it was initialized */
-	if (np->pde)
+	if (!rc && np->pde)
 		proc_device_tree_add_prop(np->pde, prop);
 #endif /* CONFIG_PROC_DEVICETREE */
 
-	return 0;
+	return rc;
 }
 
 /**
-- 
1.8.4


