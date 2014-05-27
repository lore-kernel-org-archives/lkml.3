Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753349AbaE0SZ7 (ORCPT <rfc822;w@1wt.eu>);
	Tue, 27 May 2014 14:25:59 -0400
Received: from mail-pa0-f41.google.com ([209.85.220.41]:62686 "EHLO
	mail-pa0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752287AbaE0SZ4 (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 27 May 2014 14:25:56 -0400
Date: Tue, 27 May 2014 23:55:48 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Herbert Xu <herbert@gondor.apana.org.au>,
        "David S. Miller" <davem@davemloft.net>, linux-crypto@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] crypto: caam: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140527182548.GA6333@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions.  Also, linux/device.h is added to make sure the devm_*()
routine declarations are unambiguously available. Earlier, in the probe
function ctrlpriv was leaked on the failure of ctrl = of_iomap(nprop, 0);
as well as on the failure of ctrlpriv->jrpdev = kzalloc(...); . These
two bugs have been fixed by the patch.

The following Coccinelle semantic patch was used for making the change:

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
Not compile tested due to incompatible architecture.

 drivers/crypto/caam/ctrl.c | 12 ++++++------
 1 file changed, 6 insertions(+), 6 deletions(-)

diff --git a/drivers/crypto/caam/ctrl.c b/drivers/crypto/caam/ctrl.c
index 1c38f86..34ffc35 100644
--- a/drivers/crypto/caam/ctrl.c
+++ b/drivers/crypto/caam/ctrl.c
@@ -5,6 +5,7 @@
  * Copyright 2008-2012 Freescale Semiconductor, Inc.
  */
 
+#include <linux/device.h>
 #include <linux/of_address.h>
 #include <linux/of_irq.h>
 
@@ -295,9 +296,6 @@ static int caam_remove(struct platform_device *pdev)
 	/* Unmap controller region */
 	iounmap(&topregs->ctrl);
 
-	kfree(ctrlpriv->jrpdev);
-	kfree(ctrlpriv);
-
 	return ret;
 }
 
@@ -382,7 +380,8 @@ static int caam_probe(struct platform_device *pdev)
 #endif
 	u64 cha_vid;
 
-	ctrlpriv = kzalloc(sizeof(struct caam_drv_private), GFP_KERNEL);
+	ctrlpriv = devm_kzalloc(&pdev->dev, sizeof(struct caam_drv_private),
+				GFP_KERNEL);
 	if (!ctrlpriv)
 		return -ENOMEM;
 
@@ -432,8 +431,9 @@ static int caam_probe(struct platform_device *pdev)
 		    of_device_is_compatible(np, "fsl,sec4.0-job-ring"))
 			rspec++;
 
-	ctrlpriv->jrpdev = kzalloc(sizeof(struct platform_device *) * rspec,
-								GFP_KERNEL);
+	ctrlpriv->jrpdev = devm_kzalloc(&pdev->dev,
+					sizeof(struct platform_device *) * rspec,
+					GFP_KERNEL);
 	if (ctrlpriv->jrpdev == NULL) {
 		iounmap(&topregs->ctrl);
 		return -ENOMEM;
-- 
1.9.1

