Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754078AbaAVG4a (ORCPT <rfc822;w@1wt.eu>);
	Wed, 22 Jan 2014 01:56:30 -0500
Received: from ch1ehsobe005.messaging.microsoft.com ([216.32.181.185]:29660
	"EHLO ch1outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1753814AbaAVG40 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 22 Jan 2014 01:56:26 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah21bch1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h24afh2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <robh+dt@kernel.org>, <grant.likely@linaro.org>
CC: <panto@antoniou-consulting.com>, <devicetree@vger.kernel.org>,
        <linux-kernel@vger.kernel.org>, Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCHv2 2/2] of: fix of_update_property()
Date: Wed, 22 Jan 2014 13:57:40 +0800
Message-ID: <1390370260-11273-2-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
In-Reply-To: <1390370260-11273-1-git-send-email-Li.Xiubo@freescale.com>
References: <1390370260-11273-1-git-send-email-Li.Xiubo@freescale.com>
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_update_property() is intented to update a property in a node
and if the property does not exist, will add it.

The second search of the property is possibly won't be found, that
maybe removed by other thread just before the second search begain.

Using the __of_find_property() and __of_add_property() instead and
move them into lock operations.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
Cc: Pantelis Antoniou <panto@antoniou-consulting.com>
---
 drivers/of/base.c | 36 ++++++++++++++----------------------
 1 file changed, 14 insertions(+), 22 deletions(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index b86b77a..458072d 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1573,7 +1573,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
 {
 	struct property **next, *oldprop;
 	unsigned long flags;
-	int rc, found = 0;
+	int rc = 0;
 
 	rc = of_property_notify(OF_RECONFIG_UPDATE_PROPERTY, np, newprop);
 	if (rc)
@@ -1582,36 +1582,28 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	if (!newprop->name)
 		return -EINVAL;
 
-	oldprop = of_find_property(np, newprop->name, NULL);
-	if (!oldprop)
-		return of_add_property(np, newprop);
-
 	raw_spin_lock_irqsave(&devtree_lock, flags);
-	next = &np->properties;
-	while (*next) {
-		if (*next == oldprop) {
-			/* found the node */
-			newprop->next = oldprop->next;
-			*next = newprop;
-			oldprop->next = np->deadprops;
-			np->deadprops = oldprop;
-			found = 1;
-			break;
-		}
-		next = &(*next)->next;
+	oldprop = __of_find_property(np, newprop->name, NULL);
+	if (!oldprop) {
+		/* add the node */
+		rc = __of_add_property(np, newprop);
+	} else {
+		/* replace the node */
+		next = &oldprop;
+		newprop->next = oldprop->next;
+		*next = newprop;
+		oldprop->next = np->deadprops;
+		np->deadprops = oldprop;
 	}
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
-	if (!found)
-		return -ENODEV;
-
 #ifdef CONFIG_PROC_DEVICETREE
 	/* try to add to proc as well if it was initialized */
-	if (np->pde)
+	if (!rc && np->pde)
 		proc_device_tree_update_prop(np->pde, newprop, oldprop);
 #endif /* CONFIG_PROC_DEVICETREE */
 
-	return 0;
+	return rc;
 }
 
 #if defined(CONFIG_OF_DYNAMIC)
-- 
1.8.4


