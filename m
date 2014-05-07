Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S932719AbaEGLuc (ORCPT <rfc822;w@1wt.eu>);
	Wed, 7 May 2014 07:50:32 -0400
Received: from mail-pa0-f53.google.com ([209.85.220.53]:38056 "EHLO
	mail-pa0-f53.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S932297AbaEGLub (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Wed, 7 May 2014 07:50:31 -0400
Date: Wed, 7 May 2014 17:20:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: ralf@linux-mips.org, linux-mips@linux-mips.org,
        linux-kernel@vger.kernel.org, markos.chandras@imgtec.com
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] MIPS: Introduce the use of the managed version of kzalloc
Message-ID: <20140507114848.GA10370@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions.The labels out and out_mem are also removed as they are no
longer required.

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
Tested-by: Markos Chandras <markos.chandras@imgtec.com>
Reviewed-by: Markos Chandras <markos.chandras@imgtec.com>
---
v2: remove trailing whitespace

 arch/mips/mti-sead3/sead3-i2c-drv.c | 35 +++++++++++++----------------------
 1 file changed, 13 insertions(+), 22 deletions(-)

diff --git a/arch/mips/mti-sead3/sead3-i2c-drv.c b/arch/mips/mti-sead3/sead3-i2c-drv.c
index 1f787a6..07092e0 100644
--- a/arch/mips/mti-sead3/sead3-i2c-drv.c
+++ b/arch/mips/mti-sead3/sead3-i2c-drv.c
@@ -304,22 +304,18 @@ static int sead3_i2c_platform_probe(struct platform_device *pdev)
 	int ret;
 
 	r = platform_get_resource(pdev, IORESOURCE_MEM, 0);
-	if (!r) {
-		ret = -ENODEV;
-		goto out;
-	}
+	if (!r)
+		return -ENODEV;
 
-	priv = kzalloc(sizeof(struct pic32_i2c_platform_data), GFP_KERNEL);
-	if (!priv) {
-		ret = -ENOMEM;
-		goto out;
-	}
+	priv = devm_kzalloc(&pdev->dev,
+			    sizeof(struct pic32_i2c_platform_data),
+			    GFP_KERNEL);
+	if (!priv)
+		return -ENOMEM;
 
 	priv->base = r->start;
-	if (!priv->base) {
-		ret = -EBUSY;
-		goto out_mem;
-	}
+	if (!priv->base)
+		return -EBUSY;
 
 	priv->xfer_timeout = 200;
 	priv->ack_timeout = 200;
@@ -334,15 +330,11 @@ static int sead3_i2c_platform_probe(struct platform_device *pdev)
 	sead3_i2c_platform_setup(priv);
 
 	ret = i2c_add_numbered_adapter(&priv->adap);
-	if (ret == 0) {
-		platform_set_drvdata(pdev, priv);
-		return 0;
-	}
+	if (ret)
+		return ret;
 
-out_mem:
-	kfree(priv);
-out:
-	return ret;
+	platform_set_drvdata(pdev, priv);
+	return 0;
 }
 
 static int sead3_i2c_platform_remove(struct platform_device *pdev)
@@ -351,7 +343,6 @@ static int sead3_i2c_platform_remove(struct platform_device *pdev)
 
 	platform_set_drvdata(pdev, NULL);
 	i2c_del_adapter(&priv->adap);
-	kfree(priv);
 	return 0;
 }
 
-- 
1.9.1

