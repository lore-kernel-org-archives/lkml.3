Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1754098AbaETSPw (ORCPT <rfc822;w@1wt.eu>);
	Tue, 20 May 2014 14:15:52 -0400
Received: from mail-pa0-f47.google.com ([209.85.220.47]:38229 "EHLO
	mail-pa0-f47.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751864AbaETSPu (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Tue, 20 May 2014 14:15:50 -0400
Date: Tue, 20 May 2014 23:45:37 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Jean Delvare <jdelvare@suse.de>, Guenter Roeck <linux@roeck-us.net>,
        lm-sensors@lm-sensors.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH v2] hwmon: Introduce the use of the managed version of kzalloc
Message-ID: <20140520181536.GA11483@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. Also, the unnecessary label out_free is removed.

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
v2: fix whitespace error
Not compile tested.

 drivers/hwmon/ultra45_env.c | 7 ++-----
 1 file changed, 2 insertions(+), 5 deletions(-)

diff --git a/drivers/hwmon/ultra45_env.c b/drivers/hwmon/ultra45_env.c
index fb3e693..7d46586 100644
--- a/drivers/hwmon/ultra45_env.c
+++ b/drivers/hwmon/ultra45_env.c
@@ -252,7 +252,7 @@ static const struct attribute_group env_group = {
 
 static int env_probe(struct platform_device *op)
 {
-	struct env *p = kzalloc(sizeof(*p), GFP_KERNEL);
+	struct env *p = devm_kzalloc(&op->dev, sizeof(*p), GFP_KERNEL);
 	int err = -ENOMEM;
 
 	if (!p)
@@ -262,7 +262,7 @@ static int env_probe(struct platform_device *op)
 
 	p->regs = of_ioremap(&op->resource[0], 0, REG_SIZE, "pic16f747");
 	if (!p->regs)
-		goto out_free;
+		goto out;
 
 	err = sysfs_create_group(&op->dev.kobj, &env_group);
 	if (err)
@@ -286,8 +286,6 @@ out_sysfs_remove_group:
 out_iounmap:
 	of_iounmap(&op->resource[0], p->regs, REG_SIZE);
 
-out_free:
-	kfree(p);
 	goto out;
 }
 
@@ -299,7 +297,6 @@ static int env_remove(struct platform_device *op)
 		sysfs_remove_group(&op->dev.kobj, &env_group);
 		hwmon_device_unregister(p->hwmon_dev);
 		of_iounmap(&op->resource[0], p->regs, REG_SIZE);
-		kfree(p);
 	}
 
 	return 0;
-- 
1.9.1

