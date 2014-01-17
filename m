Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1752028AbaAQFo7 (ORCPT <rfc822;w@1wt.eu>);
	Fri, 17 Jan 2014 00:44:59 -0500
Received: from mail-db8lp0186.outbound.messaging.microsoft.com ([213.199.154.186]:29121
	"EHLO db8outboundpool.messaging.microsoft.com" rhost-flags-OK-OK-OK-OK)
	by vger.kernel.org with ESMTP id S1751513AbaAQFo5 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 17 Jan 2014 00:44:57 -0500
X-Forefront-Antispam-Report: CIP:70.37.183.190;KIP:(null);UIP:(null);IPV:NLI;H:mail.freescale.net;RD:none;EFVD:NLI
X-SpamScore: 0
X-BigFish: VS0(zzzz1f42h2148h208ch1ee6h1de0h1fdah2073h2146h1202h1e76h2189h1d1ah1d2ah1fc6hzz1de098h8275bh1de097hz2dh2a8h839he5bhf0ah1288h12a5h12a9h12bdh12e5h137ah139eh13b6h1441h1504h1537h162dh1631h1758h1898h18e1h1946h19b5h1ad9h1b0ah1b2fh2222h224fh1fb3h1d0ch1d2eh1d3fh1dc1h1dfeh1dffh1e23h1fe8h1ff5h2218h2216h226dh22d0h2327h2336h2438h2461h2487h1155h)
From: Xiubo Li <Li.Xiubo@freescale.com>
To: <grant.likely@linaro.org>, <robh+dt@kernel.org>
CC: <devicetree@vger.kernel.org>, <linux-kernel@vger.kernel.org>,
        Xiubo Li <Li.Xiubo@freescale.com>
Subject: [PATCH] of: fix of_update_property()
Date: Fri, 17 Jan 2014 12:46:36 +0800
Message-ID: <1389933996-19306-1-git-send-email-Li.Xiubo@freescale.com>
X-Mailer: git-send-email 1.8.0
MIME-Version: 1.0
Content-Type: text/plain
X-OriginatorOrg: freescale.com
X-FOPE-CONNECTOR: Id%0$Dn%*$RO%0$TLS%0$FQDN%$TlsDn%
X-FOPE-CONNECTOR: Id%0$Dn%FREESCALE.MAIL.ONMICROSOFT.COM$RO%1$TLS%0$FQDN%$TlsDn%
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

The of_update_property() is intent to update a property in a node
and if the property does not exist, will add it to the node.

The second search of the property is possibly won't be found, that
maybe removed by other thread just before the second search begain,
if so just retry it.

Signed-off-by: Xiubo Li <Li.Xiubo@freescale.com>
---
 drivers/of/base.c | 3 ++-
 1 file changed, 2 insertions(+), 1 deletion(-)

diff --git a/drivers/of/base.c b/drivers/of/base.c
index f807d0e..d0c53bc 100644
--- a/drivers/of/base.c
+++ b/drivers/of/base.c
@@ -1572,6 +1572,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	if (!newprop->name)
 		return -EINVAL;
 
+retry:
 	oldprop = of_find_property(np, newprop->name, NULL);
 	if (!oldprop)
 		return of_add_property(np, newprop);
@@ -1593,7 +1594,7 @@ int of_update_property(struct device_node *np, struct property *newprop)
 	raw_spin_unlock_irqrestore(&devtree_lock, flags);
 
 	if (!found)
-		return -ENODEV;
+		goto retry;
 
 #ifdef CONFIG_PROC_DEVICETREE
 	/* try to add to proc as well if it was initialized */
-- 
1.8.4


