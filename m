Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S964863AbaESQz0 (ORCPT <rfc822;w@1wt.eu>);
	Mon, 19 May 2014 12:55:26 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:59918 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S964819AbaESQzV (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Mon, 19 May 2014 12:55:21 -0400
Date: Mon, 19 May 2014 22:25:11 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Alexander Smirnov <alex.bluesman.smirnov@gmail.com>,
        Dmitry Eremin-Solenikov <dbaryshkov@gmail.com>,
        linux-zigbee-devel@lists.sourceforge.net, netdev@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] ieee802154: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140519165511.GA8966@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. An explicit linux/device.h include is added to make sure
the devm_*() routine declarations are unambiguously available.

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
v2: add explicit include for linux/device.h

 drivers/net/ieee802154/fakelb.c | 6 +++---
 1 file changed, 3 insertions(+), 3 deletions(-)

diff --git a/drivers/net/ieee802154/fakelb.c b/drivers/net/ieee802154/fakelb.c
index b8d2217..27d8320 100644
--- a/drivers/net/ieee802154/fakelb.c
+++ b/drivers/net/ieee802154/fakelb.c
@@ -26,6 +26,7 @@
 #include <linux/timer.h>
 #include <linux/platform_device.h>
 #include <linux/netdevice.h>
+#include <linux/device.h>
 #include <linux/spinlock.h>
 #include <net/mac802154.h>
 #include <net/wpan-phy.h>
@@ -228,7 +229,8 @@ static int fakelb_probe(struct platform_device *pdev)
 	int err = -ENOMEM;
 	int i;
 
-	priv = kzalloc(sizeof(struct fakelb_priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct fakelb_priv),
+			    GFP_KERNEL);
 	if (!priv)
 		goto err_alloc;
 
@@ -248,7 +250,6 @@ static int fakelb_probe(struct platform_device *pdev)
 err_slave:
 	list_for_each_entry(dp, &priv->list, list)
 		fakelb_del(dp);
-	kfree(priv);
 err_alloc:
 	return err;
 }
@@ -260,7 +261,6 @@ static int fakelb_remove(struct platform_device *pdev)
 
 	list_for_each_entry_safe(dp, temp, &priv->list, list)
 		fakelb_del(dp);
-	kfree(priv);
 
 	return 0;
 }
-- 
1.9.1

