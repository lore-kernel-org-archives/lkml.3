Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1757838AbaEPSJv (ORCPT <rfc822;w@1wt.eu>);
	Fri, 16 May 2014 14:09:51 -0400
Received: from mail-pb0-f46.google.com ([209.85.160.46]:42891 "EHLO
	mail-pb0-f46.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1757384AbaEPSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Fri, 16 May 2014 14:09:49 -0400
Date: Fri, 16 May 2014 23:39:35 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ieee802154: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140516180935.GA13004@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions.

The following Coccinelle semantic patch was used for making the change:

@platform@
identifier p, probefn, removefn;
@@
struct platform_driver p = {
  .probe = probefn,
  .remove = removefn,
};

@prb@
identifier platform.probefn, pdev;
expression e, e1, e2;
@@
probefn(struct platform_device *pdev, ...) {
  <+...
- e = kzalloc(e1, e2)
+ e = devm_kzalloc(&pdev->dev, e1, e2)
  ...
?-kfree(e);
  ...+>
}

@rem depends on prb@
identifier platform.removefn;
expression e;
@@
removefn(...) {
  <...
- kfree(e);
  ...>
}

Signed-off-by: Himangi Saraogi <himangi774@gmail.com>
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
 drivers/net/ieee802154/fakelb.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/fakelb.c b/drivers/net/ieee802154/fakelb.c
index b8d2217..0bddcde 100644
--- a/drivers/net/ieee802154/fakelb.c
+++ b/drivers/net/ieee802154/fakelb.c
@@ -228,7 +228,8 @@ static int fakelb_probe(struct platform_device *pdev)
 	int err = -ENOMEM;
 	int i;
 
-	priv = kzalloc(sizeof(struct fakelb_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct fakelb_priv),
+			    GFP_KERNEL);
 	if (!priv)
 		goto err_alloc;
 
@@ -248,7 +249,6 @@ static int fakelb_probe(struct platform_device *pdev)
 err_slave:
 	list_for_each_entry(dp, &priv->list, list)
 		fakelb_del(dp);
-	kfree(priv);
 err_alloc:
 	return err;
 }
@@ -260,7 +260,6 @@ static int fakelb_remove(struct platform_device *pdev)
 
 	list_for_each_entry_safe(dp, temp, &priv->list, list)
 		fakelb_del(dp);
-	kfree(priv);
 
 	return 0;
 }
-- 
1.9.1

