Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751481AbaEYK6e (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 06:58:34 -0400
Received: from mail-pb0-f41.google.com ([209.85.160.41]:52573 "EHLO
	mail-pb0-f41.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751342AbaEYK6c (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 06:58:32 -0400
Date: Sun, 25 May 2014 16:28:25 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: "David S. Miller" <davem@davemloft.net>, sparclinux@vger.kernel.org,
        linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr, Sam Ravnborg <sam@ravnborg.org>
Subject: [PATCH v2] sbus: Introduce the use of the managed version of kzalloc
Message-ID: <20140525105825.GA3437@himangi-Dell>
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
available.

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
Acked-by: Julia Lawall <julia.lawall@lip6.fr>
---
v2: remove random return points introduces by me in v1

Not compile tested due to incompatible architecture.

 drivers/sbus/char/display7seg.c | 5 ++---
 1 file changed, 2 insertions(+), 3 deletions(-)

diff --git a/drivers/sbus/char/display7seg.c b/drivers/sbus/char/display7seg.c
index 7c71e7b..b48899c 100644
--- a/drivers/sbus/char/display7seg.c
+++ b/drivers/sbus/char/display7seg.c
@@ -4,6 +4,7 @@
  * Copyright (c) 2000 Eric Brower (ebrower@usa.net)
  */
 
+#include <linux/device.h>
 #include <linux/kernel.h>
 #include <linux/module.h>
 #include <linux/fs.h>
@@ -180,7 +181,7 @@ static int d7s_probe(struct platform_device *op)
 	if (d7s_device)
 		goto out;
 
-	p = kzalloc(sizeof(*p), GFP_KERNEL);
+	p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
 	err = -ENOMEM;
 	if (!p)
 		goto out;
@@ -231,7 +232,6 @@ out_iounmap:
 	of_iounmap(&op->resource[0], p->regs, sizeof(u8));
 
 out_free:
-	kfree(p);
 	goto out;
 }
 
@@ -251,7 +251,6 @@ static int d7s_remove(struct platform_device *op)
 
 	misc_deregister(&d7s_miscdev);
 	of_iounmap(&op->resource[0], p->regs, sizeof(u8));
-	kfree(p);
 
 	return 0;
 }
-- 
1.9.1

