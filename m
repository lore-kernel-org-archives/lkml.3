Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751734AbaEVUfo (ORCPT <rfc822;w@1wt.eu>);
	Thu, 22 May 2014 16:35:44 -0400
Received: from mail-pb0-f48.google.com ([209.85.160.48]:50095 "EHLO
	mail-pb0-f48.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1750996AbaEVUfn (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Thu, 22 May 2014 16:35:43 -0400
Date: Fri, 23 May 2014 02:05:36 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] sbus: Introduce the use of the managed version of kzalloc
Message-ID: <20140522203536.GA16457@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. The header file is added to make the devm function explicitly
available. Also, unnecessary assignment statements and labels are
removed.

The following Coccinelle semantic patch was used for making a part of
the change:

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
Not compile tested due to incompatible architecture.

To send to: "David S. Miller" <davem@davemloft.net>,sparclinux@vger.kernel.org,linux-kernel@vger.kernel.org

 drivers/sbus/char/display7seg.c | 23 ++++++++---------------
 1 file changed, 8 insertions(+), 15 deletions(-)

diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 7c71e7b..367b64d 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -20,6 +20,7 @@
 #include <asm/io.h>
 
 #include <asm/display7seg.h>
+#include <linux/device.h>
 
 #define D7S_MINOR	193
 #define DRIVER_NAME	"d7s"
@@ -173,22 +174,21 @@ static struct miscdevice d7s_miscdev = {
 static int d7s_probe(struct platform_device *op)
 {
 	struct device_node *opts;
-	int err = -EINVAL;
+	int err;
 	struct d7s *p;
 	u8 regs;
 
 	if (d7s_device)
-		goto out;
+		return -EINVAL;
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
-	err = -ENOMEM;
+	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
 	if (!p)
-		goto out;
+		return -ENOMEM;
 
 	p->regs = of_ioremap(&op->resource[0], 0, sizeof(u8), "d7s");
 	if (!p->regs) {
 		printk(KERN_ERR PFX "Cannot map chip registers\n");
-		goto out_free;
+		return -ENOMEM;
 	}
 
 	err = misc_register(&d7s_miscdev);
@@ -222,17 +222,11 @@ static int d7s_probe(struct platform_device *op)
 
 	dev_set_drvdata(&op->dev, p);
 	d7s_device = p;
-	err = 0;
-
-out:
-	return err;
+	return 0;
 
 out_iounmap:
 	of_iounmap(&op->resource[0], p->regs, sizeof(u8));
-
-out_free:
-	kfree(p);
-	goto out;
+	return err;
 }
 
 static int d7s_remove(struct platform_device *op)
@@ -251,7 +245,6 @@ static int d7s_remove(struct platform_device *op)
 
 	misc_deregister(&d7s_miscdev);
 	of_iounmap(&op->resource[0], p->regs, sizeof(u8));
-	kfree(p);
 
 	return 0;
 }
-- 
1.9.1

