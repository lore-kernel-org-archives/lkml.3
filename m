Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1753122AbaETSJv (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:09:51 -0400
Received: from mail-pa0-f43.google.com ([209.85.220.43]:37557 "EHLO
	mail-pa0-f43.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1752788AbaETSJt (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:09:49 -0400
Date: Tue, 20 May 2014 23:39:42 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Ralf Baechle <ralf@linux-mips.org>, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] MIPS: mti-sead3: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140520180942.GA11445@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, the now unnecessary labels out_mem and out are done
away with. The error handling code is moved under if and return 0 is now
at the end of the function.

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
 arch/mips/mti-sead3/sead3-pic32-i2c-drv.c | 36 +++++++++++--------------------
 1 file changed, 13 insertions(+), 23 deletions(-)

diff --git a/arch/mips/mti-sead3/sead3-pic32-i2c-drv.c b/arch/mips/mti-sead3/sead3-pic32-i2c-drv.c
index b921e5e..80fe194 100644
--- a/arch/mips/mti-sead3/sead3-pic32-i2c-drv.c
+++ b/arch/mips/mti-sead3/sead3-pic32-i2c-drv.c
@@ -312,16 +312,13 @@ static int i2c_platform_probe(struct platform_device *pdev)
 
 	pr_debug("i2c_platform_probe\n");
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (!r)
+		return -ENODEV;
 
-	priv = kzalloc(sizeof(struct i2c_platform_data), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	priv = devm_kzalloc(&pdev->dev, sizeof(struct i2c_platform_data),
+			    GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
 	/* FIXME: need to allocate resource in PIC32 space */
 #if 0
@@ -330,10 +327,8 @@ static int i2c_platform_probe(struct platform_device *pdev)
 #else
 	priv->base = r->start;
 #endif
-	if (!priv->base) {
-		ret = -EBUSY;
-		goto out_mem;
-	}
+	if (!priv->base)
+		return -EBUSY;
 
 	priv->xfer_timeout = 200;
 	priv->ack_timeout = 200;
@@ -348,17 +343,13 @@ static int i2c_platform_probe(struct platform_device *pdev)
 	i2c_platform_setup(priv);
 
 	ret = i2c_add_numbered_adapter(&priv->adap);
-	if (ret == 0) {
-		platform_set_drvdata(pdev, priv);
-		return 0;
+	if (ret) {
+		i2c_platform_disable(priv);
+		return ret;
 	}
 
-	i2c_platform_disable(priv);
-
-out_mem:
-	kfree(priv);
-out:
-	return ret;
+	platform_set_drvdata(pdev, priv);
+	return 0;
 }
 
 static int i2c_platform_remove(struct platform_device *pdev)
@@ -369,7 +360,6 @@ static int i2c_platform_remove(struct platform_device *pdev)
 	platform_set_drvdata(pdev, NULL);
 	i2c_del_adapter(&priv->adap);
 	i2c_platform_disable(priv);
-	kfree(priv);
 	return 0;
 }
 
-- 
1.9.1

