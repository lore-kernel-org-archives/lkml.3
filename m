Return-Path: <linux-kernel-owner@vger.kernel.org>
Received: (majordomo@vger.kernel.org) by vger.kernel.org via listexpand
	id S1751461AbaEYKXz (ORCPT <rfc822;w@1wt.eu>);
	Sun, 25 May 2014 06:23:55 -0400
Received: from mail-pa0-f44.google.com ([209.85.220.44]:49958 "EHLO
	mail-pa0-f44.google.com" rhost-flags-OK-OK-OK-OK) by vger.kernel.org
	with ESMTP id S1751375AbaEYKXx (ORCPT
	<rfc822;linux-kernel@vger.kernel.org>);
	Sun, 25 May 2014 06:23:53 -0400
Date: Sun, 25 May 2014 15:53:47 +0530
From: Himangi Saraogi <himangi774@gmail.com>
To: Ike Panhc <ike.pan@canonical.com>,
        Matthew Garrett <matthew.garrett@nebula.com>,
        platform-driver-x86@vger.kernel.org, linux-kernel@vger.kernel.org
Cc: julia.lawall@lip6.fr
Subject: [PATCH] ideapad_laptop: Introduce the use of the managed version of
 kzalloc
Message-ID: <20140525102346.GA19485@himangi-Dell>
MIME-Version: 1.0
Content-Type: text/plain; charset=us-ascii
Content-Disposition: inline
User-Agent: Mutt/1.5.21 (2010-09-15)
Sender: linux-kernel-owner@vger.kernel.org
List-ID: <linux-kernel.vger.kernel.org>
X-Mailing-List: linux-kernel@vger.kernel.org

This patch moves data allocated using kzalloc to managed data allocated
using devm_kzalloc and cleans now unnecessary kfrees in probe and remove
functions. The label sysfs_failed is removed as it is no longer
required.  Also, linux/device.h is added to make sure the devm_*()
routine declarations are unambiguously available.

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
Not compile tested due to incompatible architecture.
 drivers/platform/x86/ideapad-laptop.c | 8 +++-----
 1 file changed, 3 insertions(+), 5 deletions(-)

diff --git a/drivers/platform/x86/ideapad-laptop.c b/drivers/platform/x86/ideapad-laptop.c
index 6dd060a..aadfb1f 100644
--- a/drivers/platform/x86/ideapad-laptop.c
+++ b/drivers/platform/x86/ideapad-laptop.c
@@ -36,6 +36,7 @@
 #include <linux/debugfs.h>
 #include <linux/seq_file.h>
 #include <linux/i8042.h>
+#include <linux/device.h>
 
 #define IDEAPAD_RFKILL_DEV_NUM	(3)
 
@@ -833,7 +834,7 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 	if (read_method_int(adev->handle, "_CFG", &cfg))
 		return -ENODEV;
 
-	priv = kzalloc(sizeof(*priv), GFP_KERNEL);
+	priv = devm_kzalloc(&pdev->dev, sizeof(*priv), GFP_KERNEL);
 	if (!priv)
 		return -ENOMEM;
 
@@ -844,7 +845,7 @@ static int ideapad_acpi_add(struct platform_device *pdev)
 
 	ret = ideapad_sysfs_init(priv);
 	if (ret)
-		goto sysfs_failed;
+		return ret;
 
 	ret = ideapad_debugfs_init(priv);
 	if (ret)
@@ -884,8 +885,6 @@ input_failed:
 	ideapad_debugfs_exit(priv);
 debugfs_failed:
 	ideapad_sysfs_exit(priv);
-sysfs_failed:
-	kfree(priv);
 	return ret;
 }
 
@@ -903,7 +902,6 @@ static int ideapad_acpi_remove(struct platform_device *pdev)
 	ideapad_debugfs_exit(priv);
 	ideapad_sysfs_exit(priv);
 	dev_set_drvdata(&pdev->dev, NULL);
-	kfree(priv);
 
 	return 0;
 }
-- 
1.9.1

