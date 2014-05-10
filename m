Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1755569AbaEJStR (ORCPT <rfc822;w@1wt.eu>);
	Sat, 10 May 2014 14:49:17 -0400
Received: from mail-pa0-f48.google.com ([209.85.220.48]:47686 "EHLO
	mail-pa0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752029AbaEJStQ (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sat, 10 May 2014 14:49:16 -0400
Date: Sun, 11 May 2014 00:19:00 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Matt Mackall <mpm@selenic.com>, Herbert Xu <herbert@gondor.apana.org.au>,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] char: Introduce the use of the managed version of kzalloc
Message-ID: <20140510184859.GA6818@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. The NULL assignment to np->units is removed as there is no
interaction between this field and sun4v_hvapi_unregister. Also, the
labels out_free_units and out_free are removed as they are no longer
required.

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
---
I would like to know if removing the NULL assignment is OK as it may be
used for security to prevent it from being read before reinitialization.

 drivers/char/hw_random/n2-drv.c | 24 +++++++-----------------
 1 file changed, 7 insertions(+), 17 deletions(-)

diff --git a/drivers/char/hw_random/n2-drv.c b/drivers/char/hw_random/n2-drv.c
index 432232e..292a588 100644
--- a/drivers/char/hw_random/n2-drv.c
+++ b/drivers/char/hw_random/n2-drv.c
@@ -632,7 +632,7 @@ static int n2rng_probe(struct platform_device *op)
 	multi_capable = (match->data != NULL);
 
 	n2rng_driver_version();
-	np = kzalloc(sizeof(*np), GFP_KERNEL);
+	np = devm_kzalloc(&op->dev, sizeof(*np), GFP_KERNEL);
 	if (!np)
 		goto out;
 	np->op = op;
@@ -653,7 +653,7 @@ static int n2rng_probe(struct platform_device *op)
 					 &np->hvapi_minor)) {
 			dev_err(&op->dev, "Cannot register suitable "
 				"HVAPI version.\n");
-			goto out_free;
+			goto out;
 		}
 	}
 
@@ -676,15 +676,16 @@ static int n2rng_probe(struct platform_device *op)
 	dev_info(&op->dev, "Registered RNG HVAPI major %lu minor %lu\n",
 		 np->hvapi_major, np->hvapi_minor);
 
-	np->units = kzalloc(sizeof(struct n2rng_unit) * np->num_units,
-			    GFP_KERNEL);
+	np->units = devm_kzalloc(&op->dev,
+				 sizeof(struct n2rng_unit) * np->num_units,
+				 GFP_KERNEL);
 	err = -ENOMEM;
 	if (!np->units)
 		goto out_hvapi_unregister;
 
 	err = n2rng_init_control(np);
 	if (err)
-		goto out_free_units;
+		goto out_hvapi_unregister;
 
 	dev_info(&op->dev, "Found %s RNG, units: %d\n",
 		 ((np->flags & N2RNG_FLAG_MULTI) ?
@@ -697,7 +698,7 @@ static int n2rng_probe(struct platform_device *op)
 
 	err = hwrng_register(&np->hwrng);
 	if (err)
-		goto out_free_units;
+		goto out_hvapi_unregister;
 
 	platform_set_drvdata(op, np);
 
@@ -705,15 +706,9 @@ static int n2rng_probe(struct platform_device *op)
 
 	return 0;
 
-out_free_units:
-	kfree(np->units);
-	np->units = NULL;
-
 out_hvapi_unregister:
 	sun4v_hvapi_unregister(HV_GRP_RNG);
 
-out_free:
-	kfree(np);
 out:
 	return err;
 }
@@ -730,11 +725,6 @@ static int n2rng_remove(struct platform_device *op)
 
 	sun4v_hvapi_unregister(HV_GRP_RNG);
 
-	kfree(np->units);
-	np->units = NULL;
-
-	kfree(np);
-
 	return 0;
 }
 
-- 
1.9.1

